<%@ WebHandler Language="VB" Class="FacturaProveedorHandler" %>

Imports System
Imports System.Data
Imports System.Web
Imports System.Text

' ============================================================
' RUTA: Handlers/ComprasProveedor/FacturaProveedorHandler.ashx
' Service: FacturaProveedorService (PKG_CP_FAC_FACTURA_PROV)
'
' GET  ?action=listar                             → FacturaProveedorService.Listar()
' GET  ?action=buscar&q=texto                      → FacturaProveedorService.Buscar(texto)
' POST ?action=registrar                           → FacturaProveedorService.Registrar(orc_key, codigo_factura)
' POST ?action=actualizar                          → FacturaProveedorService.Actualizar(orc_key_old, orc_key_new, codigo_factura)
' POST ?action=eliminar                            → FacturaProveedorService.Eliminar(orc_key)
' ============================================================
Public Class FacturaProveedorHandler
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
                        Case "listar" : Listar(context)
                        Case "buscar" : Buscar(context)
                        Case Else
                            Responder(context, 400, "action GET invalida. Opciones: listar, buscar")
                    End Select
                Case "POST"
                    Select Case action
                        Case "registrar"  : Registrar(context)
                        Case "actualizar" : Actualizar(context)
                        Case "eliminar"   : Eliminar(context)
                        Case Else
                            Responder(context, 400, "action POST invalida. Opciones: registrar, actualizar, eliminar")
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
        context.Response.Write(DataTableToJson(FacturaProveedorService.Listar()))
    End Sub

    ' GET — buscar&q=texto
    Private Sub Buscar(context As HttpContext)
        Dim q As String = If(context.Request.QueryString("q"), "")
        context.Response.Write(DataTableToJson(FacturaProveedorService.Buscar(q.Trim())))
    End Sub

    ' POST — registrar
    ' Body: orc_key, codigo_factura
    Private Sub Registrar(context As HttpContext)
        Dim orcKey As String = context.Request.Form("orc_key")
        Dim codFac As String = context.Request.Form("codigo_factura")

        If String.IsNullOrEmpty(orcKey) OrElse String.IsNullOrEmpty(codFac) Then
            Responder(context, 400, "Campos requeridos: orc_key, codigo_factura") : Return
        End If

        FacturaProveedorService.Registrar(orcKey.Trim(), codFac.Trim())
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — actualizar
    ' Body: orc_key_old, orc_key_new, codigo_factura
    ' orc_key_old = orden original (WHERE), orc_key_new = nueva orden a vincular
    Private Sub Actualizar(context As HttpContext)
        Dim orcKeyOld As String = context.Request.Form("orc_key_old")
        Dim orcKeyNew As String = context.Request.Form("orc_key_new")
        Dim codFac    As String = context.Request.Form("codigo_factura")

        If String.IsNullOrEmpty(orcKeyOld) OrElse String.IsNullOrEmpty(orcKeyNew) OrElse
           String.IsNullOrEmpty(codFac) Then
            Responder(context, 400, "Campos requeridos: orc_key_old, orc_key_new, codigo_factura") : Return
        End If

        FacturaProveedorService.Actualizar(orcKeyOld.Trim(), orcKeyNew.Trim(), codFac.Trim())
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — eliminar
    ' Body: orc_key
    Private Sub Eliminar(context As HttpContext)
        Dim orcKey As String = context.Request.Form("orc_key")
        If String.IsNullOrEmpty(orcKey) Then
            Responder(context, 400, "Campo 'orc_key' requerido.") : Return
        End If
        FacturaProveedorService.Eliminar(orcKey.Trim())
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
