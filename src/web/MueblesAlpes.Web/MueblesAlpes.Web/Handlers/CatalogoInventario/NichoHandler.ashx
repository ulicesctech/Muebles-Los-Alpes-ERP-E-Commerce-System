
<%@ WebHandler Language="VB" Class="NichoHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/CatalogoInventario/NichoHandler.ashx
' ============================================================
Public Class NichoHandler
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
                    Listar(context)
                Case "listar_por_almacen"
                    ListarPorAlmacen(context)
                Case "crear_y_asignar"
                    CrearYAsignar(context)
                Case "actualizar"
                    Actualizar(context)
                Case "eliminar"
                    Eliminar(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""error"": ""Acción no válida. Usa ?action=listar""}")
            End Select

        Catch ex As Exception
            context.Response.StatusCode = 500
            Dim msgError As String = ex.Message.Replace("""", "\""")
            context.Response.Write("{""error"": """ & msgError & """}")
        End Try
    End Sub

    Private Sub Listar(context As HttpContext)
        Dim dt As DataTable = NichoService.Listar()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub ListarPorAlmacen(context As HttpContext)
        Dim almacenId As Decimal = Convert.ToDecimal(context.Request("almacenId"))
        Dim dt As DataTable = NichoService.ListarPorAlmacen(almacenId)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub CrearYAsignar(context As HttpContext)
        Dim numero As String = context.Request("numero")
        Dim zona As String = context.Request("zona")
        Dim caracteristica As String = context.Request("caracteristica")
        Dim almacenId As Decimal = Convert.ToDecimal(context.Request("almacenId"))

        NichoService.CrearYAsignar(numero, zona, caracteristica, almacenId)
        context.Response.Write("{""mensaje"": ""Nicho creado y asignado con éxito""}")
    End Sub

    Private Sub Actualizar(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        Dim numero As String = context.Request("numero")
        Dim zona As String = context.Request("zona")
        Dim caracteristica As String = context.Request("caracteristica")

        NichoService.Actualizar(id, numero, zona, caracteristica)
        context.Response.Write("{""mensaje"": ""Nicho actualizado con éxito""}")
    End Sub

    Private Sub Eliminar(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))

        NichoService.Eliminar(id)
        context.Response.Write("{""mensaje"": ""Nicho eliminado con éxito""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class