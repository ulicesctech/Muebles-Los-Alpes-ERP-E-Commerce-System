<%@ WebHandler Language="VB" Class="PedidoHandler" %>

Imports System
Imports System.Data
Imports System.Web
Imports System.Text

' ============================================================
' RUTA: Handlers/ComprasProveedor/PedidoHandler.ashx
' Service: PedidoService (PKG_CP_BOD_PEDIDO)
'
' GET  ?action=listar                 → PedidoService.Listar()
' GET  ?action=obtener&id=1          → PedidoService.ObtenerPorId(id)
' GET  ?action=buscar&q=texto         → PedidoService.Buscar(codigo)
' POST ?action=crear                  → PedidoService.Crear(codigo, forma_pago, total)
' POST ?action=actualizar             → PedidoService.Actualizar(id, codigo, forma_pago, total)
' POST ?action=eliminar               → PedidoService.Eliminar(id)
' ============================================================
Public Class PedidoHandler
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
                        Case "listar"  : Listar(context)
                        Case "obtener" : Obtener(context)
                        Case "buscar"  : Buscar(context)
                        Case Else
                            Responder(context, 400, "action GET invalida. Opciones: listar, obtener, buscar")
                    End Select
                Case "POST"
                    Select Case action
                        Case "crear"      : Crear(context)
                        Case "actualizar" : Actualizar(context)
                        Case "eliminar"   : Eliminar(context)
                        Case Else
                            Responder(context, 400, "action POST invalida. Opciones: crear, actualizar, eliminar")
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
        context.Response.Write(DataTableToJson(PedidoService.Listar()))
    End Sub

    ' GET — obtener&id=1
    Private Sub Obtener(context As HttpContext)
        Dim idStr As String = context.Request.QueryString("id")
        If String.IsNullOrEmpty(idStr) Then
            Responder(context, 400, "Parametro 'id' requerido.") : Return
        End If
        context.Response.Write(DataTableToJson(PedidoService.ObtenerPorId(Convert.ToDecimal(idStr))))
    End Sub

    ' GET — buscar&q=texto
    Private Sub Buscar(context As HttpContext)
        Dim q As String = If(context.Request.QueryString("q"), "")
        context.Response.Write(DataTableToJson(PedidoService.Buscar(q.Trim())))
    End Sub

    ' POST — crear
    ' Body: codigo, forma_pago, total(opcional)
    ' Devuelve: { "ok":true, "id": X }
    Private Sub Crear(context As HttpContext)
        Dim codigo    As String = context.Request.Form("codigo")
        Dim formaPago As String = context.Request.Form("forma_pago")
        Dim totalStr  As String = context.Request.Form("total")

        If String.IsNullOrEmpty(codigo) Then
            Responder(context, 400, "Campo 'codigo' requerido.") : Return
        End If
        If String.IsNullOrEmpty(formaPago) Then
            Responder(context, 400, "Campo 'forma_pago' requerido. Valores: CONTADO, CREDITO") : Return
        End If

        Dim total As Decimal = 0
        If Not String.IsNullOrEmpty(totalStr) Then Decimal.TryParse(totalStr, total)

        Dim nuevoId As Decimal = PedidoService.Crear(codigo.Trim(), formaPago.Trim().ToUpper(), total)
        context.Response.Write("{""ok"":true,""id"":" & nuevoId.ToString() & "}")
    End Sub

    ' POST — actualizar
    ' Body: id, codigo, forma_pago, total
    Private Sub Actualizar(context As HttpContext)
        Dim idStr     As String = context.Request.Form("id")
        Dim codigo    As String = context.Request.Form("codigo")
        Dim formaPago As String = context.Request.Form("forma_pago")
        Dim totalStr  As String = context.Request.Form("total")

        If String.IsNullOrEmpty(idStr) OrElse String.IsNullOrEmpty(codigo) OrElse
           String.IsNullOrEmpty(formaPago) OrElse String.IsNullOrEmpty(totalStr) Then
            Responder(context, 400, "Campos requeridos: id, codigo, forma_pago, total") : Return
        End If

        PedidoService.Actualizar(Convert.ToDecimal(idStr), codigo.Trim(),
                                 formaPago.Trim().ToUpper(), Convert.ToDecimal(totalStr))
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — eliminar
    ' Body: id
    Private Sub Eliminar(context As HttpContext)
        Dim idStr As String = context.Request.Form("id")
        If String.IsNullOrEmpty(idStr) Then
            Responder(context, 400, "Campo 'id' requerido.") : Return
        End If
        PedidoService.Eliminar(Convert.ToDecimal(idStr))
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
