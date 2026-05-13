<%@ WebHandler Language="VB" Class="FacturaClienteHandler" %>
Imports System.Web
Imports System.Web.SessionState
Imports System.Data
Imports System.Collections.Generic
Imports Newtonsoft.Json
Imports Oracle.ManagedDataAccess.Client
Imports MueblesAlpes.Web.Security

Public Class FacturaClienteHandler
    Implements IHttpHandler, IRequiresSessionState

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Cookie")
        context.Response.AddHeader("Access-Control-Allow-Credentials", "true")

        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        Dim action As String = context.Request("action")

        Try
            Select Case action
                Case "crear"
                    If Not SecurityGuard.RequiereCliente(context) Then Return
                    CrearFactura(context)

                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""ok"": false, ""mensaje"": ""Accion no reconocida.""}")
            End Select
        Catch ex As System.Exception
            context.Response.StatusCode = 500
            context.Response.Write("{""ok"": false, ""mensaje"": ""No se pudo procesar la solicitud.""}")
        End Try
    End Sub

    Private Function CarritoPerteneceACliente(carritoId As Integer, clienteId As Integer) As Boolean
        Dim dt As DataTable = CarritoService.BuscarPorCliente(clienteId)

        For Each row As DataRow In dt.Rows
            If Convert.ToInt32(row("PRE_CARRITO")) = carritoId Then
                Return True
            End If
        Next

        Return False
    End Function

    Private Function ObtenerEmpleadoAdmin() As Integer
        Try
            Dim ps As New List(Of OracleParameter) From {
                New OracleParameter("p_id", OracleDbType.Decimal, Nothing, ParameterDirection.Output)
            }

            OracleDb.ExecNonQuery("PKG_RH_EMPLEADO.EMP_OBTENER_ADMIN", ps)

            Dim val As String = ps(0).Value.ToString()

            If Not String.IsNullOrEmpty(val) AndAlso val <> "null" Then
                Return System.Convert.ToInt32(val)
            End If
        Catch
        End Try

        Return 0
    End Function

    Private Sub CrearFactura(context As HttpContext)
        Dim clienteId As Integer = SecurityGuard.ClienteIdActual(context)
        Dim carritoId As Integer = System.Convert.ToInt32(context.Request("carritoId"))

        If clienteId <= 0 Then
            context.Response.StatusCode = 401
            context.Response.Write("{""ok"": false, ""mensaje"": ""Cliente no autenticado.""}")
            Return
        End If

        If Not CarritoPerteneceACliente(carritoId, clienteId) Then
            context.Response.StatusCode = 403
            context.Response.Write("{""ok"": false, ""mensaje"": ""No tiene permisos sobre este carrito.""}")
            Return
        End If

        Dim formaPago As String = If(context.Request("formaPago"), "EFECTIVO")
        Dim tipoEntrega As String = If(context.Request("tipoEntrega"), "DOMICILIO")
        Dim almacenId As Integer = 0

        If context.Request("almacenId") IsNot Nothing AndAlso context.Request("almacenId") <> "" Then
            almacenId = System.Convert.ToInt32(context.Request("almacenId"))
        End If

        CarritoService.Facturar(carritoId)

        Dim empleadoId As Integer = ObtenerEmpleadoAdmin()
        Dim codigoFactura As String = FacturaClienteService.Crear(carritoId, empleadoId, formaPago, tipoEntrega, almacenId)

        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True,
            .codigoFactura = codigoFactura
        }))
    End Sub

End Class