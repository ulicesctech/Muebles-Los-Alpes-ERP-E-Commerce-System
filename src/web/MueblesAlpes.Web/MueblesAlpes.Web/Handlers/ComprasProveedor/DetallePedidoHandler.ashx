<%@ WebHandler Language="VB" Class="DetallePedidoHandler" %>
Imports System.Web
Imports System.Data
Imports System.IO
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/ComprasProveedor/DetallePedidoHandler.ashx
' ============================================================
Public Class DetallePedidoHandler
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
                Case "listarPorPedido"     : ListarPorPedido(context)
                Case "listarProductos"     : ListarProductos(context)
                Case "listarProductosBase" : ListarProductosBase(context)
                Case "listarTodosProductos": ListarTodosProductos(context)
                Case "insertar"            : InsertarDetalle(context)
                Case "actualizar"          : ActualizarDetalle(context)
                Case "eliminar"            : EliminarDetalle(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""error"": ""Acción no válida.""}")
            End Select
        Catch ex As Exception
            context.Response.StatusCode = 500
            Dim msg As String = ex.Message.Replace("""", "\""").Replace(vbCrLf, " ")
            context.Response.Write("{""error"": """ & msg & """}")
        End Try
    End Sub

    ' ── Helpers para leer JSON body ───────────────────────────────────────────
    Private Function LeerBody(context As HttpContext) As Dictionary(Of String, Object)
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        If String.IsNullOrWhiteSpace(json) Then Return New Dictionary(Of String, Object)
        Return JsonConvert.DeserializeObject(Of Dictionary(Of String, Object))(json)
    End Function

    Private Function Str(data As Dictionary(Of String, Object), key As String) As String
        If data.ContainsKey(key) AndAlso data(key) IsNot Nothing Then Return data(key).ToString()
        Return ""
    End Function

    Private Function Int_(data As Dictionary(Of String, Object), key As String) As Integer
        If data.ContainsKey(key) AndAlso data(key) IsNot Nothing Then Return Convert.ToInt32(data(key))
        Return 0
    End Function

    ' ── GET ──────────────────────────────────────────────────────────────────
    Private Sub ListarPorPedido(context As HttpContext)
        Dim pedidoId As Integer = Convert.ToInt32(context.Request("pedido_id"))
        context.Response.Write(JsonConvert.SerializeObject(DetallePedidoService.ListarPorPedido(pedidoId)))
    End Sub

    Private Sub ListarProductos(context As HttpContext)
        context.Response.Write(JsonConvert.SerializeObject(DetallePedidoService.ListarProductos()))
    End Sub

    Private Sub ListarProductosBase(context As HttpContext)
        context.Response.Write(JsonConvert.SerializeObject(DetallePedidoService.ListarProductosBase()))
    End Sub

    Private Sub ListarTodosProductos(context As HttpContext)
        context.Response.Write(JsonConvert.SerializeObject(DetallePedidoService.ListarTodosProductos()))
    End Sub

    ' ── POST — leen JSON body ─────────────────────────────────────────────────
    Private Sub InsertarDetalle(context As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(context)
        Dim pedidoId As Integer = Int_(d, "pedido_id")
        Dim proReferencia As String = Str(d, "pro_referencia")
        Dim cantidad As Integer = Int_(d, "cantidad")

        If String.IsNullOrEmpty(proReferencia) Then Throw New Exception("La referencia del producto es obligatoria.")
        If cantidad <= 0 Then Throw New Exception("La cantidad debe ser mayor a 0.")

        Dim hipSemilla As Decimal = HistorialPrecioService.RegistrarSemilla(proReferencia)
        DetallePedidoService.Insertar(pedidoId, CInt(hipSemilla), proReferencia, cantidad)
        context.Response.Write("{""mensaje"": ""Detalle agregado con éxito""}")
    End Sub

    Private Sub ActualizarDetalle(context As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(context)
        Dim detalleId As Integer = Int_(d, "detalle_id")
        Dim cantSolicitada As Integer = Int_(d, "cant_solicitada")
        Dim cantRecibida As Integer = Int_(d, "cant_recibida")

        DetallePedidoService.Actualizar(detalleId, cantSolicitada, cantRecibida)
        context.Response.Write("{""mensaje"": ""Detalle actualizado con éxito""}")
    End Sub

    Private Sub EliminarDetalle(context As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(context)
        Dim detalleId As Integer = Int_(d, "detalle_id")
        DetallePedidoService.Eliminar(detalleId)
        context.Response.Write("{""mensaje"": ""Detalle eliminado con éxito""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
