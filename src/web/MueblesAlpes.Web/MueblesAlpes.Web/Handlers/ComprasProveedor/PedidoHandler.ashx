<%@ WebHandler Language="VB" Class="PedidoHandler" %>
Imports System.Web
Imports System.Data
Imports System.IO
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/ComprasProveedor/PedidoHandler.ashx
' ============================================================
Public Class PedidoHandler
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
                Case "listar"          : ListarPedidos(context)
                Case "obtener"         : ObtenerPedido(context)
                Case "buscar"          : BuscarPedidos(context)
                Case "listarFormasPago": ListarFormasPago(context)
                Case "crear"           : CrearPedido(context)
                Case "actualizar"      : ActualizarPedido(context)
                Case "eliminar"        : EliminarPedido(context)
                Case "recibir"         : RecibirItem(context)
                Case "recibirTodo"     : RecibirTodo(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""error"": ""Accion no valida.""}")
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

    Private Function Dec(data As Dictionary(Of String, Object), key As String) As Decimal
        If data.ContainsKey(key) AndAlso data(key) IsNot Nothing Then Return Convert.ToDecimal(data(key))
        Return 0
    End Function

    ' ── GET ──────────────────────────────────────────────────────────────────
    Private Sub ListarPedidos(context As HttpContext)
        context.Response.Write(JsonConvert.SerializeObject(PedidoService.Listar()))
    End Sub

    Private Sub ObtenerPedido(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        context.Response.Write(JsonConvert.SerializeObject(PedidoService.ObtenerPorId(id)))
    End Sub

    Private Sub BuscarPedidos(context As HttpContext)
        context.Response.Write(JsonConvert.SerializeObject(PedidoService.Buscar(context.Request("codigo"))))
    End Sub

    Private Sub ListarFormasPago(context As HttpContext)
        context.Response.Write(JsonConvert.SerializeObject(PedidoService.ListarFormasPago()))
    End Sub

    ' ── POST — leen JSON body ─────────────────────────────────────────────────
    Private Sub CrearPedido(context As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(context)
        Dim formaPago As String = Str(d, "forma_pago")
        Dim total As Decimal = Dec(d, "total")
        If String.IsNullOrEmpty(formaPago) Then Throw New Exception("La forma de pago es obligatoria.")
        Dim nuevoId As Decimal = PedidoService.Crear(formaPago, total)
        context.Response.Write("{""mensaje"": ""Pedido creado con exito"", ""id"": " & nuevoId & "}")
    End Sub

    Private Sub ActualizarPedido(context As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(context)
        Dim id As Decimal = Dec(d, "id")
        Dim codigo As String = Str(d, "codigo")
        Dim formaPago As String = Str(d, "forma_pago")
        Dim total As Decimal = Dec(d, "total")
        If String.IsNullOrEmpty(formaPago) Then Throw New Exception("La forma de pago es obligatoria.")
        PedidoService.Actualizar(id, codigo, formaPago, total)
        context.Response.Write("{""mensaje"": ""Pedido actualizado con exito""}")
    End Sub

    Private Sub EliminarPedido(context As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(context)
        Dim id As Decimal = Dec(d, "id")
        PedidoService.Eliminar(id)
        context.Response.Write("{""mensaje"": ""Pedido eliminado con exito""}")
    End Sub

    Private Sub RecibirItem(context As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(context)
        Dim detpeId As Integer = Convert.ToInt32(Dec(d, "detpe_id"))
        Dim cantRecibida As Integer = Convert.ToInt32(Dec(d, "cant_recibida"))
        If detpeId <= 0 Then Throw New Exception("El ID del detalle es obligatorio.")
        If cantRecibida <= 0 Then Throw New Exception("La cantidad recibida debe ser mayor a 0.")
        PedidoService.Recibir(detpeId, cantRecibida)
        context.Response.Write("{""mensaje"": ""Recepcion registrada. Stock actualizado.""}")
    End Sub

    Private Sub RecibirTodo(context As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(context)
        Dim pedId As Integer = Convert.ToInt32(Dec(d, "ped_id"))
        If pedId <= 0 Then Throw New Exception("El ID del pedido es obligatorio.")
        PedidoService.RecibirTodo(pedId)
        context.Response.Write("{""mensaje"": ""Mercancia recibida completamente. Stock actualizado.""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
