
<%@ WebHandler Language="VB" Class="TiposHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/CatalogoInventario/TiposHandler.ashx
' ============================================================
Public Class TiposHandler
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
                Case "listar_por_categoria"
                    ListarPorCategoria(context)
                Case "crear"
                    Crear(context)
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
        Dim dt As DataTable = TipoService.Listar()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub ListarPorCategoria(context As HttpContext)
        Dim catId As Decimal = Convert.ToDecimal(context.Request("catId"))
        Dim dt As DataTable = TipoService.ListarPorCategoria(catId)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub Crear(context As HttpContext)
        Dim descripcion As String = context.Request("descripcion")
        Dim catCategoria As Decimal = Convert.ToDecimal(context.Request("catCategoria"))
        
        Dim nuevoId As Decimal = TipoService.Crear(descripcion, catCategoria)
        context.Response.Write("{""mensaje"": ""Tipo creado con éxito"", ""id"": " & nuevoId & "}")
    End Sub

    Private Sub Actualizar(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        Dim descripcion As String = context.Request("descripcion")
        Dim catCategoria As Decimal = Convert.ToDecimal(context.Request("catCategoria"))
        
        TipoService.Actualizar(id, descripcion, catCategoria)
        context.Response.Write("{""mensaje"": ""Tipo actualizado con éxito""}")
    End Sub

    Private Sub Eliminar(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        
        TipoService.Eliminar(id)
        context.Response.Write("{""mensaje"": ""Tipo eliminado con éxito""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class