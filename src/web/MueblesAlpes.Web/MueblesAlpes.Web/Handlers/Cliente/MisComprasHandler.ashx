<%@ WebHandler Language="VB" Class="MisComprasHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

Public Class MisComprasHandler
    Implements IHttpHandler

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        Dim action As String = context.Request("action")

        Try
            Select Case action
                Case "listar" : ListarPorCliente(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""ok"": false, ""mensaje"": ""Accion no reconocida.""}")
            End Select
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write("{""ok"": false, ""mensaje"": """ & ex.Message.Replace("""", "\""") & """}")
        End Try
    End Sub

    Private Sub ListarPorCliente(context As HttpContext)
        Dim clienteId As Integer = Convert.ToInt32(context.Request("clienteId"))
        Dim dt As DataTable = FacturaClienteService.ListarPorCliente(clienteId)
        Dim lst As New List(Of Object)
        For Each row As DataRow In dt.Rows
            lst.Add(New With {
                .FACLI_CODIGO_FACTURA = row("FACLI_CODIGO_FACTURA"),
                .FACLI_FECHA = row("FACLI_FECHA"),
                .FACLI_FORMA_PAGO = row("FACLI_FORMA_PAGO"),
                .FACLI_TIPO_ENTREGA = row("FACLI_TIPO_ENTREGA"),
                .PRE_CARRITO = row("PRE_CARRITO"),
                .NOMBRE_ALMACEN = If(IsDBNull(row("NOMBRE_ALMACEN")), "", row("NOMBRE_ALMACEN")),
                .TOTAL_REAL = If(IsDBNull(row("TOTAL_REAL")), 0, row("TOTAL_REAL")),
                .PRODUCTOS = If(IsDBNull(row("PRODUCTOS")), "", row("PRODUCTOS"))
            })
        Next
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

End Class
