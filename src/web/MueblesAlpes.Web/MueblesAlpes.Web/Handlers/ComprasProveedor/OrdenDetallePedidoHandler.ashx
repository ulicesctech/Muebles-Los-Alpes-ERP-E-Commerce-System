<%@ WebHandler Language="VB" Class="OrdenDetallePedidoHandler" %>

Imports System
Imports System.Data
Imports System.Web
Imports System.Text

' ============================================================
' RUTA: Handlers/ComprasProveedor/OrdenDetallePedidoHandler.ashx
' Service: OrdenDetallePedidoService (PKG_BOD_ORDEN_DETALLE_PEDIDO)
'
' GET  ?action=listar-por-orden&id=ORC-001  → OrdenDetallePedidoService.ListarPorOrden(orcKey)
' GET  ?action=buscar-por-pedido&id=1       → OrdenDetallePedidoService.BuscarPorPedido(pedidoId)
' POST ?action=insertar                      → OrdenDetallePedidoService.Insertar(orc_key, ped_id, material, producto, precio, cantidad)
' POST ?action=actualizar                    → OrdenDetallePedidoService.Actualizar(odp_id, material, producto, precio, cantidad)
' POST ?action=eliminar                      → OrdenDetallePedidoService.Eliminar(odp_id)
' ============================================================
Public Class OrdenDetallePedidoHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.Charset = "utf-8"

        Dim method As String = context.Request.HttpMethod.ToUpper()
        Dim action As String = If(context.Request.QueryString("action"), "").ToLower().Trim()

        Try
            Select Case method
                Case "GET"
                    Select Case action
                        Case "listar-por-orden"   : ListarPorOrden(context)
                        Case "buscar-por-pedido"  : BuscarPorPedido(context)
                        Case Else
                            Responder(context, 400, "action GET invalida. Opciones: listar-por-orden, buscar-por-pedido")
                    End Select
                Case "POST"
                    Select Case action
                        Case "insertar"   : Insertar(context)
                        Case "actualizar" : Actualizar(context)
                        Case "eliminar"   : Eliminar(context)
                        Case Else
                            Responder(context, 400, "action POST invalida. Opciones: insertar, actualizar, eliminar")
                    End Select
                Case Else
                    Responder(context, 405, "Metodo HTTP no permitido.")
            End Select
        Catch ex As Exception
            Responder(context, 500, "Error interno: " & ex.Message)
        End Try
    End Sub

    ' GET — listar-por-orden&id=ORC-001
    Private Sub ListarPorOrden(context As HttpContext)
        Dim id As String = context.Request.QueryString("id")
        If String.IsNullOrEmpty(id) Then
            Responder(context, 400, "Parametro 'id' requerido.") : Return
        End If
        context.Response.Write(DataTableToJson(OrdenDetallePedidoService.ListarPorOrden(id.Trim())))
    End Sub

    ' GET — buscar-por-pedido&id=1
    Private Sub BuscarPorPedido(context As HttpContext)
        Dim idStr As String = context.Request.QueryString("id")
        If String.IsNullOrEmpty(idStr) Then
            Responder(context, 400, "Parametro 'id' requerido.") : Return
        End If
        context.Response.Write(DataTableToJson(OrdenDetallePedidoService.BuscarPorPedido(Convert.ToInt32(idStr))))
    End Sub

    ' POST — insertar
    ' Body: orc_key, ped_id, material, producto, precio, cantidad
    Private Sub Insertar(context As HttpContext)
        Dim orcKey   As String = context.Request.Form("orc_key")
        Dim pedStr   As String = context.Request.Form("ped_id")
        Dim material As String = context.Request.Form("material")
        Dim producto As String = context.Request.Form("producto")
        Dim precStr  As String = context.Request.Form("precio")
        Dim cantStr  As String = context.Request.Form("cantidad")

        If String.IsNullOrEmpty(orcKey)   OrElse String.IsNullOrEmpty(pedStr)   OrElse
           String.IsNullOrEmpty(material) OrElse String.IsNullOrEmpty(producto) OrElse
           String.IsNullOrEmpty(precStr)  OrElse String.IsNullOrEmpty(cantStr) Then
            Responder(context, 400, "Campos requeridos: orc_key, ped_id, material, producto, precio, cantidad") : Return
        End If

        OrdenDetallePedidoService.Insertar(orcKey.Trim(), Convert.ToInt32(pedStr),
                                           material.Trim(), producto.Trim(),
                                           Convert.ToDecimal(precStr), Convert.ToInt32(cantStr))
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — actualizar
    ' Body: odp_id, material, producto, precio, cantidad
    Private Sub Actualizar(context As HttpContext)
        Dim odpIdStr As String = context.Request.Form("odp_id")
        Dim material As String = context.Request.Form("material")
        Dim producto As String = context.Request.Form("producto")
        Dim precStr  As String = context.Request.Form("precio")
        Dim cantStr  As String = context.Request.Form("cantidad")

        If String.IsNullOrEmpty(odpIdStr) OrElse String.IsNullOrEmpty(material) OrElse
           String.IsNullOrEmpty(producto) OrElse String.IsNullOrEmpty(precStr)  OrElse
           String.IsNullOrEmpty(cantStr) Then
            Responder(context, 400, "Campos requeridos: odp_id, material, producto, precio, cantidad") : Return
        End If

        OrdenDetallePedidoService.Actualizar(Convert.ToInt32(odpIdStr), material.Trim(),
                                             producto.Trim(), Convert.ToDecimal(precStr),
                                             Convert.ToInt32(cantStr))
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — eliminar
    ' Body: odp_id
    Private Sub Eliminar(context As HttpContext)
        Dim odpIdStr As String = context.Request.Form("odp_id")
        If String.IsNullOrEmpty(odpIdStr) Then
            Responder(context, 400, "Campo 'odp_id' requerido.") : Return
        End If
        OrdenDetallePedidoService.Eliminar(Convert.ToInt32(odpIdStr))
        context.Response.Write("{""ok"":true}")
    End Sub

    Private Sub Responder(context As HttpContext, statusCode As Integer, mensaje As String)
        context.Response.StatusCode = statusCode
        context.Response.Write("{""ok"":false,""error"":""" & mensaje.Replace("\", "\\").Replace("""", "\""") & """}")
    End Sub

    Private Function DataTableToJson(dt As DataTable) As String
        If dt Is Nothing OrElse dt.Rows.Count = 0 Then Return "[]"
        Dim sb As New StringBuilder
        sb.Append("[")
        For i As Integer = 0 To dt.Rows.Count - 1
            If i > 0 Then sb.Append(",")
            sb.Append("{")
            For j As Integer = 0 To dt.Columns.Count - 1
                If j > 0 Then sb.Append(",")
                Dim col As String = dt.Columns(j).ColumnName
                Dim val As Object = dt.Rows(i)(j)
                sb.Append("""" & col & """:")
                If IsDBNull(val) Then
                    sb.Append("null")
                ElseIf TypeOf val Is Boolean Then
                    sb.Append(If(CBool(val), "true", "false"))
                ElseIf TypeOf val Is Date Then
                    sb.Append("""" & CDate(val).ToString("yyyy-MM-dd") & """")
                ElseIf TypeOf val Is Decimal OrElse TypeOf val Is Integer OrElse
                       TypeOf val Is Long    OrElse TypeOf val Is Double Then
                    sb.Append(val.ToString())
                Else
                    sb.Append("""" & val.ToString().Replace("\", "\\").Replace("""", "\""").Replace(vbCr, "").Replace(vbLf, " ") & """")
                End If
            Next
            sb.Append("}")
        Next
        sb.Append("]")
        Return sb.ToString()
    End Function

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
