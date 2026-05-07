
<%@ WebHandler Language="VB" Class="StockHandler" %>

Imports System
Imports Microsoft.VisualBasic
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/CatalogoInventario/StockHandler.ashx
' ============================================================
Public Class StockHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        ' Configuración vital de CORS para React Native
        context.Response.ContentType = "application/json"
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        ' Preflight de CORS
        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        Dim action As String = context.Request("action")

        Try
            Select Case action
                Case "listar"
                    Listar(context)
                Case "listar_por_producto"
                    ListarPorProducto(context)
                Case "obtener"
                    Obtener(context)
                Case "obtener_por_nicho"
                    ObtenerPorNicho(context)
                Case "guardar"
                    Guardar(context)
                Case "entrada"
                    Entrada(context)
                Case "salida"
                    Salida(context)
                Case "eliminar"
                    Eliminar(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""error"": ""Acción no válida o no especificada.""}")
            End Select

        Catch ex As Exception
            context.Response.StatusCode = 500
            Dim msgError As String = ex.Message.Replace("""", "\""").Replace(vbCrLf, " ")
            context.Response.Write("{""error"": """ & msgError & """}")
        End Try
    End Sub

    ' ==========================================
    ' MÉTODOS DE LECTURA (GET)
    ' ==========================================

    Private Sub Listar(context As HttpContext)
        Dim dt As DataTable = StockService.Listar()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub ListarPorProducto(context As HttpContext)
        Dim proReferencia As String = context.Request("proReferencia")
        Dim dt As DataTable = StockService.ListarPorProducto(proReferencia)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub Obtener(context As HttpContext)
        Dim hipHistorialPrecio As Decimal = Convert.ToDecimal(context.Request("hipHistorialPrecio"))
        Dim dt As DataTable = StockService.Obtener(hipHistorialPrecio)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub ObtenerPorNicho(context As HttpContext)
        Dim proReferencia As String = context.Request("proReferencia")
        Dim nicNicho As Decimal = Convert.ToDecimal(context.Request("nicNicho"))
        Dim dt As DataTable = StockService.ObtenerPorNicho(proReferencia, nicNicho)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    ' ==========================================
    ' MÉTODOS DE ESCRITURA (POST/PUT/DELETE)
    ' ==========================================

    Private Sub Guardar(context As HttpContext)
        Dim hipHistorialPrecio As Decimal = Convert.ToDecimal(context.Request("hipHistorialPrecio"))
        Dim minimo As Decimal = Convert.ToDecimal(context.Request("minimo"))
        Dim maximo As Decimal = Convert.ToDecimal(context.Request("maximo"))
        Dim disponible As Decimal = Convert.ToDecimal(context.Request("disponible"))

        StockService.Guardar(hipHistorialPrecio, minimo, maximo, disponible)
        context.Response.Write("{""mensaje"": ""Stock guardado con éxito""}")
    End Sub

    Private Sub Entrada(context As HttpContext)
        Dim hipHistorialPrecio As Decimal = Convert.ToDecimal(context.Request("hipHistorialPrecio"))
        Dim cantidad As Decimal = Convert.ToDecimal(context.Request("cantidad"))

        StockService.Entrada(hipHistorialPrecio, cantidad)
        context.Response.Write("{""mensaje"": ""Entrada de stock registrada con éxito""}")
    End Sub

    Private Sub Salida(context As HttpContext)
        Dim hipHistorialPrecio As Decimal = Convert.ToDecimal(context.Request("hipHistorialPrecio"))
        Dim cantidad As Decimal = Convert.ToDecimal(context.Request("cantidad"))

        StockService.Salida(hipHistorialPrecio, cantidad)
        context.Response.Write("{""mensaje"": ""Salida de stock registrada con éxito""}")
    End Sub

    Private Sub Eliminar(context As HttpContext)
        Dim hipHistorialPrecio As Decimal = Convert.ToDecimal(context.Request("hipHistorialPrecio"))
        
        StockService.Eliminar(hipHistorialPrecio)
        context.Response.Write("{""mensaje"": ""Registro de stock eliminado con éxito""}")
    End Sub

    ' Propiedad requerida por IHttpHandler
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class