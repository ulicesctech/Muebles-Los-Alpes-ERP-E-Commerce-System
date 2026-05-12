<%@ WebHandler Language="VB" Class="FacturaClienteHandler" %>
Imports System.Web
Imports System.Data
Imports System.Collections.Generic
Imports Newtonsoft.Json
Imports Oracle.ManagedDataAccess.Client

Public Class FacturaClienteHandler
    Implements IHttpHandler

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        Dim action As String = context.Request("action")

        Try
            Select Case action
                Case "crear" : CrearFactura(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""ok"": false, ""mensaje"": ""Accion no reconocida.""}")
            End Select
        Catch ex As System.Exception
            context.Response.StatusCode = 500
            context.Response.Write("{""ok"": false, ""mensaje"": """ & ex.Message.Replace("""", "\""") & """}")
        End Try
    End Sub

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
        Dim carritoId As Integer = System.Convert.ToInt32(context.Request("carritoId"))
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