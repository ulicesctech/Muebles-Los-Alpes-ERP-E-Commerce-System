<%@ WebHandler Language="VB" Class="FacturaProveedorHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/ComprasProveedor/FacturaProveedorHandler.ashx
' ============================================================
Public Class FacturaProveedorHandler
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
                    ListarFacturas(context)
                Case "buscar"
                    BuscarFacturas(context)
                Case "buscarFiltro"
                    BuscarFiltro(context)
                Case "registrar"
                    RegistrarFactura(context)
                Case "actualizar"
                    ActualizarFactura(context)
                Case "eliminar"
                    EliminarFactura(context)
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

    Private Sub ListarFacturas(context As HttpContext)
        Dim dt As DataTable = FacturaProveedorService.Listar()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub BuscarFacturas(context As HttpContext)
        Dim texto As String = context.Request("texto")
        Dim dt As DataTable = FacturaProveedorService.Buscar(texto)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub BuscarFiltro(context As HttpContext)
        Dim texto As String = context.Request("texto")
        Dim fechaDesde As Object = Nothing
        Dim fechaHasta As Object = Nothing

        Dim strDesde As String = context.Request("fecha_desde")
        Dim strHasta As String = context.Request("fecha_hasta")

        If Not String.IsNullOrEmpty(strDesde) Then fechaDesde = Convert.ToDateTime(strDesde)
        If Not String.IsNullOrEmpty(strHasta) Then fechaHasta = Convert.ToDateTime(strHasta)

        Dim dt As DataTable = FacturaProveedorService.BuscarFiltro(texto, Nothing, fechaDesde, fechaHasta)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub RegistrarFactura(context As HttpContext)
        Dim orcKey As String = context.Request("orc_key")
        Dim codigoFactura As String = context.Request("codigo_factura")

        If String.IsNullOrEmpty(orcKey) Then Throw New Exception("La clave de la orden es obligatoria.")
        If String.IsNullOrEmpty(codigoFactura) Then Throw New Exception("El código de factura es obligatorio.")

        FacturaProveedorService.Registrar(orcKey, codigoFactura)
        context.Response.Write("{""mensaje"": ""Factura registrada con éxito""}")
    End Sub

    Private Sub ActualizarFactura(context As HttpContext)
        Dim orcKeyOld As String = context.Request("orc_key_old")
        Dim orcKeyNew As String = context.Request("orc_key_new")
        Dim codigoFactura As String = context.Request("codigo_factura")

        If String.IsNullOrEmpty(codigoFactura) Then Throw New Exception("El código de factura es obligatorio.")

        FacturaProveedorService.Actualizar(orcKeyOld, orcKeyNew, codigoFactura)
        context.Response.Write("{""mensaje"": ""Factura actualizada con éxito""}")
    End Sub

    Private Sub EliminarFactura(context As HttpContext)
        Dim orcKey As String = context.Request("orc_key")
        FacturaProveedorService.Eliminar(orcKey)
        context.Response.Write("{""mensaje"": ""Factura eliminada con éxito""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
