<%@ WebHandler Language="VB" Class="CarritoClienteHandler" %>
Imports System.Web
Imports System.IO
Imports Newtonsoft.Json
Imports System.Data

Public Class CarritoClienteHandler
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
                Case "crear" : CrearCarrito(context)
                Case "buscar" : BuscarCarrito(context)
                Case "detalle" : ListarDetalle(context)
                Case "agregar" : AgregarDetalle(context)
                Case "eliminar-detalle" : EliminarDetalle(context)
                Case "vaciar" : VaciarCarrito(context)
                Case "almacenes" : AlmacenesConStock(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""ok"": false, ""mensaje"": ""Accion no reconocida.""}")
            End Select
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write("{""ok"": false, ""mensaje"": """ & ex.Message.Replace("""", "\""") & """}")
        End Try
    End Sub

    Private Sub CrearCarrito(context As HttpContext)
        Dim clienteId As Integer = Convert.ToInt32(context.Request("clienteId"))
        Dim id As Integer = CarritoService.Crear(clienteId)
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .carritoId = id}))
    End Sub

    Private Sub BuscarCarrito(context As HttpContext)
        Dim clienteId As Integer = Convert.ToInt32(context.Request("clienteId"))
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
        Dim carritoId As Integer = Convert.ToInt32(context.Request("carritoId"))
        Dim dt As DataTable = OracleDb.ExecRefCursor("PKG_CLI_CARRITO.CARRITO_LISTAR_DETALLE",
            New List(Of Oracle.ManagedDataAccess.Client.OracleParameter) From {
                New Oracle.ManagedDataAccess.Client.OracleParameter("p_carrito", Oracle.ManagedDataAccess.Client.OracleDbType.Decimal, carritoId, System.Data.ParameterDirection.Input)
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
        Dim carritoId As Integer = Convert.ToInt32(context.Request("carritoId"))
        Dim hvId As Integer = Convert.ToInt32(context.Request("hvId"))
        Dim cantidad As Integer = Convert.ToInt32(context.Request("cantidad"))
        CarritoService.AgregarDetalle(carritoId, hvId, cantidad)
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True}))
    End Sub

    Private Sub EliminarDetalle(context As HttpContext)
        Dim detalleId As Integer = Convert.ToInt32(context.Request("detalleId"))
        CarritoService.EliminarDetalle(detalleId)
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True}))
    End Sub

    Private Sub VaciarCarrito(context As HttpContext)
        Dim carritoId As Integer = Convert.ToInt32(context.Request("carritoId"))
        CarritoService.Vaciar(carritoId)
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True}))
    End Sub

    Private Sub AlmacenesConStock(context As HttpContext)
        Dim hvIds As String = context.Request("hvIds")
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