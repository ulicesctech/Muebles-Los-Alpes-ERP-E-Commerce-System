<%@ WebHandler Language="VB" Class="OrdenCompraHandler" %>

Imports System
Imports System.Data
Imports System.Web
Imports System.Text

' ============================================================
' RUTA: Handlers/ComprasProveedor/OrdenCompraHandler.ashx
' Service: OrdenCompraService (PKG_CP_BOD_ORDEN_COMPRA)
'
' GET  ?action=listar                        → OrdenCompraService.Listar()
' GET  ?action=obtener&id=ORC-001           → OrdenCompraService.ObtenerPorId(orcKey)
' GET  ?action=buscar&q=texto                → OrdenCompraService.Buscar(filtro)
' GET  ?action=buscar-pedidos&q=texto        → OrdenCompraService.BuscarPedidos(texto)
' GET  ?action=detalles-pedido&id=1         → OrdenCompraService.DetallesPedido(pedidoId)
' POST ?action=crear                         → OrdenCompraService.Crear(orc_key, codigo, prov_id, total)
' POST ?action=actualizar                    → OrdenCompraService.Actualizar(orc_key, codigo, prov_id, total)
' POST ?action=actualizar-total             → OrdenCompraService.ActualizarTotal(orc_key, total)
' POST ?action=eliminar                      → OrdenCompraService.Eliminar(orc_key)
' ============================================================
Public Class OrdenCompraHandler
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
                        Case "listar"           : Listar(context)
                        Case "obtener"          : Obtener(context)
                        Case "buscar"           : Buscar(context)
                        Case "buscar-pedidos"   : BuscarPedidos(context)
                        Case "detalles-pedido"  : DetallesPedido(context)
                        Case Else
                            Responder(context, 400, "action GET invalida. Opciones: listar, obtener, buscar, buscar-pedidos, detalles-pedido")
                    End Select
                Case "POST"
                    Select Case action
                        Case "crear"            : Crear(context)
                        Case "actualizar"       : Actualizar(context)
                        Case "actualizar-total" : ActualizarTotal(context)
                        Case "eliminar"         : Eliminar(context)
                        Case Else
                            Responder(context, 400, "action POST invalida. Opciones: crear, actualizar, actualizar-total, eliminar")
                    End Select
                Case Else
                    Responder(context, 405, "Metodo HTTP no permitido.")
            End Select
        Catch ex As Exception
            Responder(context, 500, "Error interno: " & ex.Message)
        End Try
    End Sub

    ' GET — listar
    Private Sub Listar(context As HttpContext)
        context.Response.Write(DataTableToJson(OrdenCompraService.Listar()))
    End Sub

    ' GET — obtener&id=ORC-001
    Private Sub Obtener(context As HttpContext)
        Dim id As String = context.Request.QueryString("id")
        If String.IsNullOrEmpty(id) Then
            Responder(context, 400, "Parametro 'id' requerido.") : Return
        End If
        context.Response.Write(DataTableToJson(OrdenCompraService.ObtenerPorId(id.Trim())))
    End Sub

    ' GET — buscar&q=texto
    Private Sub Buscar(context As HttpContext)
        Dim q As String = If(context.Request.QueryString("q"), "")
        context.Response.Write(DataTableToJson(OrdenCompraService.Buscar(q.Trim())))
    End Sub

    ' GET — buscar-pedidos&q=texto
    Private Sub BuscarPedidos(context As HttpContext)
        Dim q As String = If(context.Request.QueryString("q"), "")
        context.Response.Write(DataTableToJson(OrdenCompraService.BuscarPedidos(q.Trim())))
    End Sub

    ' GET — detalles-pedido&id=1
    Private Sub DetallesPedido(context As HttpContext)
        Dim idStr As String = context.Request.QueryString("id")
        If String.IsNullOrEmpty(idStr) Then
            Responder(context, 400, "Parametro 'id' requerido.") : Return
        End If
        context.Response.Write(DataTableToJson(OrdenCompraService.DetallesPedido(Convert.ToInt32(idStr))))
    End Sub

    ' POST — crear
    ' Body: orc_key, codigo, prov_id, total(opcional)
    Private Sub Crear(context As HttpContext)
        Dim orcKey  As String = context.Request.Form("orc_key")
        Dim codigo  As String = context.Request.Form("codigo")
        Dim provStr As String = context.Request.Form("prov_id")
        Dim totStr  As String = context.Request.Form("total")

        If String.IsNullOrEmpty(orcKey) OrElse String.IsNullOrEmpty(codigo) OrElse
           String.IsNullOrEmpty(provStr) Then
            Responder(context, 400, "Campos requeridos: orc_key, codigo, prov_id") : Return
        End If

        Dim total As Decimal = 0
        If Not String.IsNullOrEmpty(totStr) Then Decimal.TryParse(totStr, total)

        OrdenCompraService.Crear(orcKey.Trim(), codigo.Trim(), Convert.ToDecimal(provStr), total)
        context.Response.Write("{""ok"":true,""orc_key"":""" & orcKey.Trim() & """}")
    End Sub

    ' POST — actualizar
    ' Body: orc_key, codigo, prov_id, total
    Private Sub Actualizar(context As HttpContext)
        Dim orcKey  As String = context.Request.Form("orc_key")
        Dim codigo  As String = context.Request.Form("codigo")
        Dim provStr As String = context.Request.Form("prov_id")
        Dim totStr  As String = context.Request.Form("total")

        If String.IsNullOrEmpty(orcKey) OrElse String.IsNullOrEmpty(codigo) OrElse
           String.IsNullOrEmpty(provStr) OrElse String.IsNullOrEmpty(totStr) Then
            Responder(context, 400, "Campos requeridos: orc_key, codigo, prov_id, total") : Return
        End If

        OrdenCompraService.Actualizar(orcKey.Trim(), codigo.Trim(),
                                      Convert.ToDecimal(provStr), Convert.ToDecimal(totStr))
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — actualizar-total
    ' Body: orc_key, total
    Private Sub ActualizarTotal(context As HttpContext)
        Dim orcKey As String = context.Request.Form("orc_key")
        Dim totStr As String = context.Request.Form("total")

        If String.IsNullOrEmpty(orcKey) OrElse String.IsNullOrEmpty(totStr) Then
            Responder(context, 400, "Campos requeridos: orc_key, total") : Return
        End If

        OrdenCompraService.ActualizarTotal(orcKey.Trim(), Convert.ToDecimal(totStr))
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — eliminar
    ' Body: orc_key
    Private Sub Eliminar(context As HttpContext)
        Dim orcKey As String = context.Request.Form("orc_key")
        If String.IsNullOrEmpty(orcKey) Then
            Responder(context, 400, "Campo 'orc_key' requerido.") : Return
        End If
        OrdenCompraService.Eliminar(orcKey.Trim())
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
