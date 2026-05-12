<%@ WebHandler Language="VB" Class="OrdenDetallePedidoHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/ComprasProveedor/OrdenDetallePedidoHandler.ashx
' ============================================================
Public Class OrdenDetallePedidoHandler
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
                Case "listarPorOrden"
                    ListarPorOrden(context)
                Case "buscarPorPedido"
                    BuscarPorPedido(context)
                Case "insertar"
                    InsertarDetalle(context)
                Case "actualizar"
                    ActualizarDetalle(context)
                Case "eliminar"
                    EliminarDetalle(context)
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

    Private Sub ListarPorOrden(context As HttpContext)
        Dim orcKey As String = context.Request("orc_key")
        Dim dt As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub BuscarPorPedido(context As HttpContext)
        Dim pedidoId As Integer = Convert.ToInt32(context.Request("pedido_id"))
        Dim dt As DataTable = OrdenDetallePedidoService.BuscarPorPedido(pedidoId)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub InsertarDetalle(context As HttpContext)
        Dim orcKey As String = context.Request("orc_key")
        Dim pedidoId As Integer = Convert.ToInt32(context.Request("pedido_id"))
        Dim material As String = context.Request("material")
        Dim producto As String = context.Request("producto")
        Dim precio As Decimal = Decimal.Parse(context.Request("precio"), System.Globalization.CultureInfo.InvariantCulture)

        Dim cantidad As Integer = Convert.ToInt32(context.Request("cantidad"))

        If String.IsNullOrEmpty(orcKey) Then Throw New Exception("La clave de la orden es obligatoria.")
        If cantidad <= 0 Then Throw New Exception("La cantidad debe ser mayor a 0.")

        OrdenDetallePedidoService.Insertar(orcKey, pedidoId, material, producto, precio, cantidad)
        context.Response.Write("{""mensaje"": ""Detalle de orden agregado con éxito""}")
    End Sub

    Private Sub ActualizarDetalle(context As HttpContext)
        Dim odpId As Integer = Convert.ToInt32(context.Request("odp_id"))
        Dim material As String = context.Request("material")
        Dim producto As String = context.Request("producto")
        Dim precio As Decimal = Convert.ToDecimal(context.Request("precio"))
        Dim cantidad As Integer = Convert.ToInt32(context.Request("cantidad"))

        OrdenDetallePedidoService.Actualizar(odpId, material, producto, precio, cantidad)
        context.Response.Write("{""mensaje"": ""Detalle de orden actualizado con éxito""}")
    End Sub

    Private Sub EliminarDetalle(context As HttpContext)
        Dim odpId As Integer = Convert.ToInt32(context.Request("odp_id"))
        OrdenDetallePedidoService.Eliminar(odpId)
        context.Response.Write("{""mensaje"": ""Detalle de orden eliminado con éxito""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
