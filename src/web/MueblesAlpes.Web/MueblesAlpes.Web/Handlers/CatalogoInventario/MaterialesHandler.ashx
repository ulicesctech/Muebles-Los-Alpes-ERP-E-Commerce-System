
<%@ WebHandler Language="VB" Class="MaterialesHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/CatalogoInventario/MaterialesHandler.ashx
' ============================================================
Public Class MaterialesHandler
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
                Case "buscar"
                    Buscar(context)
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
        Dim dt As DataTable = MaterialService.Listar()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub Buscar(context As HttpContext)
        Dim texto As String = context.Request("texto")
        Dim dt As DataTable = MaterialService.Buscar(texto)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub Crear(context As HttpContext)
        Dim descripcion As String = context.Request("descripcion")

        Dim nuevoId As Decimal = MaterialService.Crear(descripcion)
        context.Response.Write("{""mensaje"": ""Material creado con éxito"", ""id"": " & nuevoId & "}")
    End Sub

    Private Sub Actualizar(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        Dim descripcion As String = context.Request("descripcion")

        MaterialService.Actualizar(id, descripcion)
        context.Response.Write("{""mensaje"": ""Material actualizado con éxito""}")
    End Sub

    Private Sub Eliminar(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))

        MaterialService.Eliminar(id)
        context.Response.Write("{""mensaje"": ""Material eliminado con éxito""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class