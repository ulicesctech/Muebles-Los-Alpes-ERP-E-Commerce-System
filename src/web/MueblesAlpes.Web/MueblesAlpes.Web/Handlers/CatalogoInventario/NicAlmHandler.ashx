<%@ WebHandler Language="VB" Class="NicAlmHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/CatalogoInventario/NicAlmHandler.ashx
' ============================================================
Public Class NicAlmHandler
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
                Case "asignar"
                    Asignar(context)
                Case "quitar"
                    Quitar(context)
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
        Dim dt As DataTable = NicAlmService.Listar()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub ListarPorAlmacen(context As HttpContext)
        Dim almAlmacen As Decimal = Convert.ToDecimal(context.Request("almAlmacen"))
        Dim dt As DataTable = NicAlmService.ListarPorAlmacen(almAlmacen)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub Asignar(context As HttpContext)
        Dim nicNicho As Decimal = Convert.ToDecimal(context.Request("nicNicho"))
        Dim almAlmacen As Decimal = Convert.ToDecimal(context.Request("almAlmacen"))

        Dim nuevoId As Decimal = NicAlmService.Asignar(nicNicho, almAlmacen)
        context.Response.Write("{""mensaje"": ""Asignación creada con éxito"", ""id"": " & nuevoId & "}")
    End Sub

    Private Sub Quitar(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))

        NicAlmService.Quitar(id)
        context.Response.Write("{""mensaje"": ""Asignación eliminada con éxito""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class