<%@ WebHandler Language="VB" Class="OrdenCompraHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/ComprasProveedor/OrdenCompraHandler.ashx
' ============================================================
Public Class OrdenCompraHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        Dim action As String = context.Request("action")

        Try
            Select Case action
                Case "listar"
                    ListarOrdenes(context)
                Case "listarPorId"
                    ListarPorId(context)
                Case "buscar"
                    BuscarOrdenes(context)
                Case "buscarPedidos"
                    BuscarPedidos(context)
                Case "detallesPedido"
                    DetallesPedido(context)
                Case "crear"
                    CrearOrden(context)
                Case "actualizar"
                    ActualizarOrden(context)
                Case "actualizarTotal"
                    ActualizarTotal(context)
                Case "eliminar"
                    EliminarOrden(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""error"": ""Acción no válida.""}")
            End Select
        Catch ex As Exception
            context.Response.StatusCode = 500
            Dim msgError As String = ex.Message.Replace("""", "\""")
            context.Response.Write("{""error"": """ & msgError & """}")
        End Try
    End Sub

    Private Sub ListarOrdenes(context As HttpContext)
        Dim dt As DataTable = OrdenCompraService.Listar()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub ListarPorId(context As HttpContext)
        Dim orcKey As String = context.Request("orc_key")
        Dim dt As DataTable = OrdenCompraService.ListarPorId(orcKey)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub BuscarOrdenes(context As HttpContext)
        Dim codigo As String = context.Request("codigo")
        Dim dt As DataTable = OrdenCompraService.Buscar(codigo)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub BuscarPedidos(context As HttpContext)
        Dim texto As String = context.Request("texto")
        Dim dt As DataTable = OrdenCompraService.BuscarPedidos(texto)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub DetallesPedido(context As HttpContext)
        Dim pedId As Integer = Convert.ToInt32(context.Request("ped_id"))
        Dim dt As DataTable = OrdenCompraService.DetallesPedido(pedId)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub CrearOrden(context As HttpContext)
        Dim provId As Integer = Convert.ToInt32(context.Request("prov_id"))
        Dim total As Decimal = Convert.ToDecimal(context.Request("total"))

        If provId <= 0 Then Throw New Exception("El proveedor es obligatorio.")

        Dim orcKey As String = OrdenCompraService.Crear(provId, total)
        context.Response.Write("{""mensaje"": ""Orden de compra creada con éxito"", ""orc_key"": """ & orcKey & """}")
    End Sub

    Private Sub ActualizarOrden(context As HttpContext)
        Dim orcKey As String = context.Request("orc_key")
        Dim codigo As String = context.Request("codigo")
        Dim provId As Integer = Convert.ToInt32(context.Request("prov_id"))
        Dim total As Decimal = Convert.ToDecimal(context.Request("total"))

        OrdenCompraService.Actualizar(orcKey, codigo, provId, total)
        context.Response.Write("{""mensaje"": ""Orden de compra actualizada con éxito""}")
    End Sub

    ' El handler recalcula el total desde Oracle — el móvil no calcula nada
    Private Sub ActualizarTotal(context As HttpContext)
        Dim orcKey As String = context.Request("orc_key")

        Dim dt As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
        Dim total As Decimal = 0
        For Each row As DataRow In dt.Rows
            Dim p As Decimal = If(IsDBNull(row("ODP_PRECIO")), 0D, Convert.ToDecimal(row("ODP_PRECIO")))
            Dim c As Decimal = If(IsDBNull(row("ODP_CANTIDAD")), 0D, Convert.ToDecimal(row("ODP_CANTIDAD")))
            total += p * c
        Next
        OrdenCompraService.ActualizarTotal(orcKey, total)
        context.Response.Write("{""mensaje"": ""Total actualizado con éxito"", ""total"": " & total.ToString("F2", System.Globalization.CultureInfo.InvariantCulture) & "}")
    End Sub

    Private Sub EliminarOrden(context As HttpContext)
        Dim orcKey As String = context.Request("orc_key")
        OrdenCompraService.Eliminar(orcKey)
        context.Response.Write("{""mensaje"": ""Orden de compra eliminada con éxito""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
