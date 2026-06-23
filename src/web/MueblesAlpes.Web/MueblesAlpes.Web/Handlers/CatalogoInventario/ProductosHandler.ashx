
<%@ WebHandler Language="VB" Class="ProductosHandler" %>
Imports System.Web
Imports System.Data
Imports System.IO
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/CatalogoInventario/ProductosHandler.ashx
' ============================================================
Public Class ProductosHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        ' Configuración de CORS
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
                Case "obtener"
                    Obtener(context)
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
            Dim msgError As String = ex.Message.Replace("""", "\""").Replace(vbCrLf, " ")
            context.Response.Write("{""error"": """ & msgError & """}")
        End Try
    End Sub

    Private Sub Listar(context As HttpContext)
        Dim dt As DataTable = ProductoService.Listar()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub Buscar(context As HttpContext)
        Dim texto As String = context.Request("texto")
        Dim dt As DataTable = ProductoService.Buscar(texto)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub Obtener(context As HttpContext)
        Dim referencia As String = context.Request("referencia")
        Dim dt As DataTable = ProductoService.Obtener(referencia)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub Crear(context As HttpContext)
        ' 1. Capturar datos de texto y números
        Dim referencia As String = context.Request("referencia")
        Dim nombre As String = context.Request("nombre")
        Dim descripcion As String = context.Request("descripcion")
        Dim tipTipo As Decimal = Convert.ToDecimal(context.Request("tipTipo"))
        Dim matMaterial As Decimal = Convert.ToDecimal(context.Request("matMaterial"))
        Dim color As String = context.Request("color")
        
        ' Validaciones para números opcionales (por si vienen vacíos)
        Dim altoCm As Decimal = If(String.IsNullOrEmpty(context.Request("altoCm")), 0, Convert.ToDecimal(context.Request("altoCm")))
        Dim anchoCm As Decimal = If(String.IsNullOrEmpty(context.Request("anchoCm")), 0, Convert.ToDecimal(context.Request("anchoCm")))
        Dim profundidadCm As Decimal = If(String.IsNullOrEmpty(context.Request("profundidadCm")), 0, Convert.ToDecimal(context.Request("profundidadCm")))
        Dim peso As Decimal = If(String.IsNullOrEmpty(context.Request("peso")), 0, Convert.ToDecimal(context.Request("peso")))

        ' 2. Capturar la foto si existe
        Dim fotoBytes As Byte() = ObtenerBytesDeArchivo(context)

        ' 3. Llamar al servicio
        ProductoService.Crear(referencia, nombre, descripcion, tipTipo, matMaterial, altoCm, anchoCm, profundidadCm, color, peso, fotoBytes)
        
        context.Response.Write("{""mensaje"": ""Producto creado con éxito""}")
    End Sub

    Private Sub Actualizar(context As HttpContext)
        ' 1. Capturar datos
        Dim referencia As String = context.Request("referencia")
        Dim nombre As String = context.Request("nombre")
        Dim descripcion As String = context.Request("descripcion")
        Dim tipTipo As Decimal = Convert.ToDecimal(context.Request("tipTipo"))
        Dim matMaterial As Decimal = Convert.ToDecimal(context.Request("matMaterial"))
        Dim color As String = context.Request("color")
        
        Dim altoCm As Decimal = If(String.IsNullOrEmpty(context.Request("altoCm")), 0, Convert.ToDecimal(context.Request("altoCm")))
        Dim anchoCm As Decimal = If(String.IsNullOrEmpty(context.Request("anchoCm")), 0, Convert.ToDecimal(context.Request("anchoCm")))
        Dim profundidadCm As Decimal = If(String.IsNullOrEmpty(context.Request("profundidadCm")), 0, Convert.ToDecimal(context.Request("profundidadCm")))
        Dim peso As Decimal = If(String.IsNullOrEmpty(context.Request("peso")), 0, Convert.ToDecimal(context.Request("peso")))

        ' 2. Capturar la nueva foto (si se envió)
        Dim fotoBytes As Byte() = ObtenerBytesDeArchivo(context)

        ' 3. Llamar al servicio
        ProductoService.Actualizar(referencia, nombre, descripcion, tipTipo, matMaterial, altoCm, anchoCm, profundidadCm, color, peso, fotoBytes)
        
        context.Response.Write("{""mensaje"": ""Producto actualizado con éxito""}")
    End Sub

    Private Sub Eliminar(context As HttpContext)
        Dim referencia As String = context.Request("referencia")
        
        ProductoService.Eliminar(referencia)
        context.Response.Write("{""mensaje"": ""Producto eliminado con éxito""}")
    End Sub

    ' --- MÉTODO AUXILIAR PARA LEER LA IMAGEN ---
    Private Function ObtenerBytesDeArchivo(context As HttpContext) As Byte()
        If context.Request.Files.Count > 0 Then
            Dim archivo As HttpPostedFile = context.Request.Files(0)
            If archivo.ContentLength > 0 Then
                Using br As New BinaryReader(archivo.InputStream)
                    Return br.ReadBytes(archivo.ContentLength)
                End Using
            End If
        End If
        Return Nothing ' Retorna Nothing si no se subió foto
    End Function

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class