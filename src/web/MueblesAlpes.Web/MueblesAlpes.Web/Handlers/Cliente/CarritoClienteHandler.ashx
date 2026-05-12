<%@ WebHandler Language="VB" Class="CarritoClienteHandler" %>
Imports System.Web
Imports System.Web.SessionState
Imports System.IO
Imports Newtonsoft.Json
Imports System.Data
Imports Oracle.ManagedDataAccess.Client
Imports MueblesAlpes.Web.Security

Public Class CarritoClienteHandler
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
                    CrearCarrito(context)

                Case "buscar"
                    If Not SecurityGuard.RequiereCliente(context) Then Return
                    BuscarCarrito(context)

                Case "detalle"
                    If Not SecurityGuard.RequiereCliente(context) Then Return
                    ListarDetalle(context)

                Case "agregar"
                    If Not SecurityGuard.RequiereCliente(context) Then Return
                    AgregarDetalle(context)

                Case "eliminar-detalle"
                    If Not SecurityGuard.RequiereCliente(context) Then Return
                    EliminarDetalle(context)

                Case "vaciar"
                    If Not SecurityGuard.RequiereCliente(context) Then Return
                    VaciarCarrito(context)

                Case "almacenes"
                    If Not SecurityGuard.RequiereCliente(context) Then Return
                    AlmacenesConStock(context)

                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""ok"": false, ""mensaje"": ""Accion no reconocida.""}")
            End Select
        Catch ex As Exception
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

    Private Function DetallePerteneceACliente(detalleId As Integer, clienteId As Integer) As Boolean
        Dim carritos As DataTable = CarritoService.BuscarPorCliente(clienteId)

        For Each carrito As DataRow In carritos.Rows
            Dim carritoId As Integer = Convert.ToInt32(carrito("PRE_CARRITO"))

            Dim detalles As DataTable = OracleDb.ExecRefCursor("PKG_CLI_CARRITO.CARRITO_LISTAR_DETALLE",
                New List(Of OracleParameter) From {
                    New OracleParameter("p_carrito", OracleDbType.Decimal, carritoId, ParameterDirection.Input)
                }, "p_data")

            For Each det As DataRow In detalles.Rows
                If Convert.ToInt32(det("DETCAR_DETALLE_CARRITO")) = detalleId Then
                    Return True
                End If
            Next
        Next

        Return False
    End Function

    Private Sub CrearCarrito(context As HttpContext)
        Dim clienteId As Integer = SecurityGuard.ClienteIdActual(context)

        If clienteId <= 0 Then
            context.Response.StatusCode = 401
            context.Response.Write("{""ok"": false, ""mensaje"": ""Cliente no autenticado.""}")
            Return
        End If

        Dim id As Integer = CarritoService.Crear(clienteId)

        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True,
            .carritoId = id
        }))
    End Sub

    Private Sub BuscarCarrito(context As HttpContext)
        Dim clienteId As Integer = SecurityGuard.ClienteIdActual(context)

        If clienteId <= 0 Then
            context.Response.StatusCode = 401
            context.Response.Write("{""ok"": false, ""mensaje"": ""Cliente no autenticado.""}")
            Return
        End If

        Dim dt As DataTable = CarritoService.BuscarPorCliente(clienteId)
        Dim lst As New List(Of Object)

        For Each row As DataRow In dt.Rows
            lst.Add(New With {
                .PRE_CARRITO = row("PRE_CARRITO"),
                .PRE_CORRELATIVO = row("PRE_CORRELATIVO"),
                .PRE_FECHA_INICIO = row("PRE_FECHA_INICIO"),
                .PRE_TOTAL = row("PRE_TOTAL")
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub ListarDetalle(context As HttpContext)
        Dim clienteId As Integer = SecurityGuard.ClienteIdActual(context)
        Dim carritoId As Integer = Convert.ToInt32(context.Request("carritoId"))

        If Not CarritoPerteneceACliente(carritoId, clienteId) Then
            context.Response.StatusCode = 403
            context.Response.Write("{""ok"": false, ""mensaje"": ""No tiene permisos sobre este carrito.""}")
            Return
        End If

        Dim dt As DataTable = OracleDb.ExecRefCursor("PKG_CLI_CARRITO.CARRITO_LISTAR_DETALLE",
            New List(Of OracleParameter) From {
                New OracleParameter("p_carrito", OracleDbType.Decimal, carritoId, ParameterDirection.Input)
            }, "p_data")

        Dim lst As New List(Of Object)

        For Each row As DataRow In dt.Rows
            lst.Add(New With {
                .DETCAR_DETALLE_CARRITO = row("DETCAR_DETALLE_CARRITO"),
                .PRO_REFERENCIA = row("PRO_REFERENCIA"),
                .PRO_NOMBRE = row("PRO_NOMBRE"),
                .HV_HISTORIAL_PRECIO_VENTA = row("HV_HISTORIAL_PRECIO_VENTA"),
                .HV_PRECIO_FINAL = row("HV_PRECIO_FINAL"),
                .DETPRE_CANTIDAD = row("DETPRE_CANTIDAD"),
                .SUBTOTAL = row("SUBTOTAL")
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub AgregarDetalle(context As HttpContext)
        Dim clienteId As Integer = SecurityGuard.ClienteIdActual(context)
        Dim carritoId As Integer = Convert.ToInt32(context.Request("carritoId"))
        Dim hvId As Integer = Convert.ToInt32(context.Request("hvId"))
        Dim cantidad As Integer = Convert.ToInt32(context.Request("cantidad"))

        If Not CarritoPerteneceACliente(carritoId, clienteId) Then
            context.Response.StatusCode = 403
            context.Response.Write("{""ok"": false, ""mensaje"": ""No tiene permisos sobre este carrito.""}")
            Return
        End If

        If cantidad <= 0 Then
            context.Response.StatusCode = 400
            context.Response.Write("{""ok"": false, ""mensaje"": ""Cantidad invalida.""}")
            Return
        End If

        CarritoService.AgregarDetalle(carritoId, hvId, cantidad)

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True}))
    End Sub

    Private Sub EliminarDetalle(context As HttpContext)
        Dim clienteId As Integer = SecurityGuard.ClienteIdActual(context)
        Dim detalleId As Integer = Convert.ToInt32(context.Request("detalleId"))

        If Not DetallePerteneceACliente(detalleId, clienteId) Then
            context.Response.StatusCode = 403
            context.Response.Write("{""ok"": false, ""mensaje"": ""No tiene permisos sobre este detalle.""}")
            Return
        End If

        CarritoService.EliminarDetalle(detalleId)

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True}))
    End Sub

    Private Sub VaciarCarrito(context As HttpContext)
        Dim clienteId As Integer = SecurityGuard.ClienteIdActual(context)
        Dim carritoId As Integer = Convert.ToInt32(context.Request("carritoId"))

        If Not CarritoPerteneceACliente(carritoId, clienteId) Then
            context.Response.StatusCode = 403
            context.Response.Write("{""ok"": false, ""mensaje"": ""No tiene permisos sobre este carrito.""}")
            Return
        End If

        CarritoService.Vaciar(carritoId)

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True}))
    End Sub

    Private Sub AlmacenesConStock(context As HttpContext)
        Dim hvIds As String = context.Request("hvIds")

        If String.IsNullOrWhiteSpace(hvIds) Then
            context.Response.StatusCode = 400
            context.Response.Write("{""ok"": false, ""mensaje"": ""Debe enviar productos.""}")
            Return
        End If

        Dim dt As DataTable = CarritoService.AlmacenesConStock(hvIds)
        Dim lst As New List(Of Object)

        For Each row As DataRow In dt.Rows
            lst.Add(New With {
                .ALM_ALMACEN = row("ALM_ALMACEN"),
                .ALM_NOMBRE = row("ALM_NOMBRE"),
                .ALM_UBICACION = row("ALM_UBICACION")
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

End Class