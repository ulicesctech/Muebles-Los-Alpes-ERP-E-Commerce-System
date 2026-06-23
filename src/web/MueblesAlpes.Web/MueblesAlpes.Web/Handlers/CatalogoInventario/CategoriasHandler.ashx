
<%@ WebHandler Language="VB" Class="CategoriasHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json ' Recuerda instalar este paquete NuGet si aún no lo tienes

' ============================================================
' RUTA: Handlers/CatalogoInventario/CategoriasHandler.ashx
' ============================================================
Public Class CategoriasHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        ' 1. Configuración vital de CORS para React Native
        context.Response.ContentType = "application/json"
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        ' 2. Si el navegador/app envía una petición OPTIONS (Preflight de CORS), salimos exitosamente
        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        ' 3. Leemos qué acción quiere ejecutar la app
        Dim action As String = context.Request("action")

        Try
            ' Enrutador mágico
            Select Case action
                Case "listar"
                    ListarCategorias(context)
                Case "buscar"
                    BuscarCategoria(context)
                Case "crear"
                    CrearCategoria(context)
                Case "actualizar"
                    ActualizarCategoria(context)
                Case "eliminar"
                    EliminarCategoria(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""error"": ""Acción no válida o no especificada. Usa ?action=listar""}")
            End Select

        Catch ex As Exception
            ' Si Oracle o el código explotan, mandamos el error en formato JSON
            context.Response.StatusCode = 500
            ' Reemplazamos comillas dobles para no romper el JSON
            Dim msgError As String = ex.Message.Replace("""", "\""")
            context.Response.Write("{""error"": """ & msgError & """}")
        End Try
    End Sub

    ' --- MÉTODOS CRUD ---

    Private Sub ListarCategorias(context As HttpContext)
        Dim dt As DataTable = CategoriaService.Listar()
        ' Convertimos la tabla de Oracle directamente a un arreglo de objetos JSON
        Dim json As String = JsonConvert.SerializeObject(dt)
        context.Response.Write(json)
    End Sub

    Private Sub BuscarCategoria(context As HttpContext)
        Dim texto As String = context.Request("texto")
        Dim dt As DataTable = CategoriaService.Buscar(texto)
        Dim json As String = JsonConvert.SerializeObject(dt)
        context.Response.Write(json)
    End Sub

    Private Sub CrearCategoria(context As HttpContext)
        Dim descripcion As String = context.Request("descripcion")

        If String.IsNullOrEmpty(descripcion) Then
            Throw New Exception("La descripción es obligatoria.")
        End If

        Dim nuevoId As Decimal = CategoriaService.Crear(descripcion)
        context.Response.Write("{""mensaje"": ""Categoría creada con éxito"", ""id"": " & nuevoId & "}")
    End Sub

    Private Sub ActualizarCategoria(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        Dim descripcion As String = context.Request("descripcion")

        If String.IsNullOrEmpty(descripcion) Then
            Throw New Exception("La descripción es obligatoria.")
        End If

        CategoriaService.Actualizar(id, descripcion)
        context.Response.Write("{""mensaje"": ""Categoría actualizada con éxito""}")
    End Sub

    Private Sub EliminarCategoria(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        
        CategoriaService.Eliminar(id)
        context.Response.Write("{""mensaje"": ""Categoría eliminada con éxito""}")
    End Sub

    ' Propiedad requerida por IHttpHandler
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class