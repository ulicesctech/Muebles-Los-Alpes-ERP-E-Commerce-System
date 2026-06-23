<%@ WebHandler Language="VB" Class="ReclamoProveedorHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/ComprasProveedor/ReclamoProveedorHandler.ashx
' ============================================================
Public Class ReclamoProveedorHandler
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
                    ListarReclamos(context)
                Case "listarPorId"
                    ListarPorId(context)
                Case "listarEstados"
                    ListarEstados(context)
                Case "buscar"
                    BuscarReclamos(context)
                Case "crear"
                    CrearReclamo(context)
                Case "actualizar"
                    ActualizarReclamo(context)
                Case "actualizarComentarios"
                    ActualizarComentarios(context)
                Case "cambiarEstado"
                    CambiarEstado(context)
                Case "eliminar"
                    EliminarReclamo(context)
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

    Private Sub ListarReclamos(context As HttpContext)
        Dim dt As DataTable = ReclamoProveedorService.Listar()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub ListarPorId(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        Dim dt As DataTable = ReclamoProveedorService.ListarPorId(id)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub ListarEstados(context As HttpContext)
        Dim dt As DataTable = ReclamoProveedorService.ListarEstados()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub BuscarReclamos(context As HttpContext)
        Dim texto As String = context.Request("texto")
        Dim estado As String = context.Request("estado")
        Dim fechaDesde As Object = Nothing
        Dim fechaHasta As Object = Nothing

        Dim strDesde As String = context.Request("fecha_desde")
        Dim strHasta As String = context.Request("fecha_hasta")

        If Not String.IsNullOrEmpty(strDesde) Then fechaDesde = Convert.ToDateTime(strDesde)
        If Not String.IsNullOrEmpty(strHasta) Then fechaHasta = Convert.ToDateTime(strHasta)

        Dim dt As DataTable = ReclamoProveedorService.Buscar(texto, estado, fechaDesde, fechaHasta)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub CrearReclamo(context As HttpContext)
        Dim orcKey As String = context.Request("orc_key")
        Dim descripcion As String = context.Request("descripcion")

        If String.IsNullOrEmpty(orcKey) Then Throw New Exception("La clave de la orden es obligatoria.")
        If String.IsNullOrEmpty(descripcion) Then Throw New Exception("La descripción es obligatoria.")

        Dim nuevoId As Decimal = ReclamoProveedorService.Crear(orcKey, descripcion)
        context.Response.Write("{""mensaje"": ""Reclamo creado con éxito"", ""id"": " & nuevoId & "}")
    End Sub

    Private Sub ActualizarReclamo(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        Dim descripcion As String = context.Request("descripcion")

        If String.IsNullOrEmpty(descripcion) Then Throw New Exception("La descripción es obligatoria.")

        ReclamoProveedorService.Actualizar(id, descripcion)
        context.Response.Write("{""mensaje"": ""Reclamo actualizado con éxito""}")
    End Sub

    Private Sub ActualizarComentarios(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        Dim comentarios As String = context.Request("comentarios")

        ReclamoProveedorService.ActualizarComentarios(id, comentarios)
        context.Response.Write("{""mensaje"": ""Comentarios actualizados con éxito""}")
    End Sub

    Private Sub CambiarEstado(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        Dim estado As String = context.Request("estado")
        Dim comentarios As String = context.Request("comentarios")

        If String.IsNullOrEmpty(estado) Then Throw New Exception("El estado es obligatorio.")

        ReclamoProveedorService.CambiarEstado(id, estado, comentarios)
        context.Response.Write("{""mensaje"": ""Estado actualizado con éxito""}")
    End Sub

    Private Sub EliminarReclamo(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        ReclamoProveedorService.Eliminar(id)
        context.Response.Write("{""mensaje"": ""Reclamo eliminado con éxito""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
