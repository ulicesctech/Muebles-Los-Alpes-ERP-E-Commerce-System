<%@ WebHandler Language="VB" Class="HistorialPrecioHandler" %>

Imports System ' <--- Esta línea soluciona los errores de 'Exception' y 'Convert'
Imports Microsoft.VisualBasic ' <--- Esta línea soluciona el error de 'vbCrLf'
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/CatalogoInventario/HistorialPrecioHandler.ashx
' ============================================================
Public Class HistorialPrecioHandler
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
                Case "listar_todos"
                    ListarTodos(context)
                Case "listar_por_producto"
                    ListarPorProducto(context)
                Case "listar_por_mes"
                    ListarPorMes(context)
                Case "vigente"
                    Vigente(context)
                Case "registrar"
                    Registrar(context)
                Case "registrar_semilla"
                    RegistrarSemilla(context)
                Case "registrar_global"
                    RegistrarGlobal(context)
                Case "actualizar_semilla"
                    ActualizarSemilla(context)
                Case "cerrar_vigente"
                    CerrarVigente(context)
                Case "cerrar_todos"
                    CerrarTodos(context)
                Case "cerrar_semilla"
                    CerrarSemilla(context)
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

    Private Sub ListarTodos(context As HttpContext)
        Dim dt As DataTable = HistorialPrecioService.ListarTodos()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub ListarPorProducto(context As HttpContext)
        Dim proReferencia As String = context.Request("proReferencia")
        Dim dt As DataTable = HistorialPrecioService.ListarPorProducto(proReferencia)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub ListarPorMes(context As HttpContext)
        Dim mes As Integer = Convert.ToInt32(context.Request("mes"))
        Dim anio As Integer = Convert.ToInt32(context.Request("anio"))
        Dim dt As DataTable = HistorialPrecioService.ListarPorMes(mes, anio)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub Vigente(context As HttpContext)
        Dim proReferencia As String = context.Request("proReferencia")
        Dim nicNicho As Decimal = Convert.ToDecimal(context.Request("nicNicho"))
        Dim dt As DataTable = HistorialPrecioService.Vigente(proReferencia, nicNicho)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    ' ==========================================
    ' MÉTODOS DE ESCRITURA (POST/PUT)
    ' ==========================================

    Private Sub Registrar(context As HttpContext)
        Dim proReferencia As String = context.Request("proReferencia")
        Dim nicNicho As Decimal = Convert.ToDecimal(context.Request("nicNicho"))
        Dim precio As Decimal = Convert.ToDecimal(context.Request("precio"))
        Dim fechaInicio As Date = Convert.ToDateTime(context.Request("fechaInicio"))

        Dim nuevoId As Decimal = HistorialPrecioService.Registrar(proReferencia, nicNicho, precio, fechaInicio)
        context.Response.Write("{""mensaje"": ""Historial registrado con éxito"", ""id"": " & nuevoId & "}")
    End Sub

    Private Sub RegistrarSemilla(context As HttpContext)
        Dim proReferencia As String = context.Request("proReferencia")

        Dim nuevoId As Decimal = HistorialPrecioService.RegistrarSemilla(proReferencia)
        context.Response.Write("{""mensaje"": ""Semilla registrada con éxito"", ""id"": " & nuevoId & "}")
    End Sub

    Private Sub RegistrarGlobal(context As HttpContext)
        Dim proReferencia As String = context.Request("proReferencia")
        Dim nicNicho As Decimal = Convert.ToDecimal(context.Request("nicNicho"))
        Dim precio As Decimal = Convert.ToDecimal(context.Request("precio"))
        Dim fechaInicio As Date = Convert.ToDateTime(context.Request("fechaInicio"))

        Dim nuevoId As Decimal = HistorialPrecioService.RegistrarGlobal(proReferencia, nicNicho, precio, fechaInicio)
        context.Response.Write("{""mensaje"": ""Historial global registrado con éxito"", ""id"": " & nuevoId & "}")
    End Sub

    Private Sub ActualizarSemilla(context As HttpContext)
        Dim hipId As Decimal = Convert.ToDecimal(context.Request("hipId"))
        Dim nicNicho As Decimal = Convert.ToDecimal(context.Request("nicNicho"))
        Dim precio As Decimal = Convert.ToDecimal(context.Request("precio"))
        Dim fechaInicio As Date = Convert.ToDateTime(context.Request("fechaInicio"))

        HistorialPrecioService.ActualizarSemilla(hipId, nicNicho, precio, fechaInicio)
        context.Response.Write("{""mensaje"": ""Semilla actualizada con éxito""}")
    End Sub

    ' ==========================================
    ' MÉTODOS DE CIERRE (POST/PUT)
    ' ==========================================

    Private Sub CerrarVigente(context As HttpContext)
        Dim proReferencia As String = context.Request("proReferencia")
        Dim nicNicho As Decimal = Convert.ToDecimal(context.Request("nicNicho"))
        Dim fechaCierre As Date = Convert.ToDateTime(context.Request("fechaCierre"))

        HistorialPrecioService.CerrarVigente(proReferencia, nicNicho, fechaCierre)
        context.Response.Write("{""mensaje"": ""Historial vigente cerrado con éxito""}")
    End Sub

    Private Sub CerrarTodos(context As HttpContext)
        Dim proReferencia As String = context.Request("proReferencia")
        Dim fechaCierre As Date = Convert.ToDateTime(context.Request("fechaCierre"))

        HistorialPrecioService.CerrarTodos(proReferencia, fechaCierre)
        context.Response.Write("{""mensaje"": ""Todos los historiales cerrados con éxito""}")
    End Sub

    Private Sub CerrarSemilla(context As HttpContext)
        Dim hipId As Decimal = Convert.ToDecimal(context.Request("hipId"))
        Dim fechaCierre As Date = Convert.ToDateTime(context.Request("fechaCierre"))

        HistorialPrecioService.CerrarSemilla(hipId, fechaCierre)
        context.Response.Write("{""mensaje"": ""Semilla cerrada con éxito""}")
    End Sub

    ' Propiedad requerida por IHttpHandler
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class