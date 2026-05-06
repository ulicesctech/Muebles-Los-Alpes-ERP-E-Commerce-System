<%@ WebHandler Language="VB" Class="ReclamoProveedorHandler" %>

Imports System
Imports System.Data
Imports System.Web
Imports System.Text

' ============================================================
' RUTA: Handlers/ComprasProveedor/ReclamoProveedorHandler.ashx
' Service: ReclamoProveedorService (PKG_CP_FAC_RECLAMO_PROV)
'
' Estados disponibles: INICIADO, PENDIENTE, FINALIZADO, RESUELTO, RECHAZADO
' Estados de cierre (Oracle asigna fecha_final=SYSDATE): FINALIZADO, RESUELTO, RECHAZADO
'
' GET  ?action=listar                   → ReclamoProveedorService.Listar()
' GET  ?action=obtener&id=1            → ReclamoProveedorService.ListarPorId(id)
' GET  ?action=estados                  → Lista de estados validos y de cierre
' POST ?action=crear                    → ReclamoProveedorService.Crear(orc_key, comentarios) → devuelve id
' POST ?action=actualizar               → ReclamoProveedorService.Actualizar(id, comentarios)
' POST ?action=cambiar-estado           → ReclamoProveedorService.CambiarEstado(id, estado)
' POST ?action=eliminar                 → ReclamoProveedorService.Eliminar(id)
' ============================================================
Public Class ReclamoProveedorHandler
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
                        Case "estados" : Estados(context)
                        Case Else
                            Responder(context, 400, "action GET invalida. Opciones: listar, obtener, estados")
                    End Select
                Case "POST"
                    Select Case action
                        Case "crear"          : Crear(context)
                        Case "actualizar"     : Actualizar(context)
                        Case "cambiar-estado" : CambiarEstado(context)
                        Case "eliminar"       : Eliminar(context)
                        Case Else
                            Responder(context, 400, "action POST invalida. Opciones: crear, actualizar, cambiar-estado, eliminar")
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
        context.Response.Write(DataTableToJson(ReclamoProveedorService.Listar()))
    End Sub

    ' GET — obtener&id=1
    Private Sub Obtener(context As HttpContext)
        Dim idStr As String = context.Request.QueryString("id")
        If String.IsNullOrEmpty(idStr) Then
            Responder(context, 400, "Parametro 'id' requerido.") : Return
        End If
        context.Response.Write(DataTableToJson(ReclamoProveedorService.ListarPorId(Convert.ToDecimal(idStr))))
    End Sub

    ' GET — estados
    ' Devuelve los arrays EstadosDisponibles y EstadosCierre del service
    Private Sub Estados(context As HttpContext)
        Dim sb As New StringBuilder
        sb.Append("{")
        sb.Append("""estados_disponibles"":[")
        For i As Integer = 0 To ReclamoProveedorService.EstadosDisponibles.Length - 1
            If i > 0 Then sb.Append(",")
            sb.Append("""" & ReclamoProveedorService.EstadosDisponibles(i) & """")
        Next
        sb.Append("],")
        sb.Append("""estados_cierre"":[")
        For i As Integer = 0 To ReclamoProveedorService.EstadosCierre.Length - 1
            If i > 0 Then sb.Append(",")
            sb.Append("""" & ReclamoProveedorService.EstadosCierre(i) & """")
        Next
        sb.Append("]}")
        context.Response.Write(sb.ToString())
    End Sub

    ' POST — crear
    ' Body: orc_key, comentarios
    ' Oracle fija estado=INICIADO, fecha_inicio=SYSDATE, fecha_final=NULL
    ' Devuelve: { "ok":true, "id": X }
    Private Sub Crear(context As HttpContext)
        Dim orcKey      As String = context.Request.Form("orc_key")
        Dim comentarios As String = context.Request.Form("comentarios")

        If String.IsNullOrEmpty(orcKey) OrElse String.IsNullOrEmpty(comentarios) Then
            Responder(context, 400, "Campos requeridos: orc_key, comentarios") : Return
        End If

        Dim nuevoId As Decimal = ReclamoProveedorService.Crear(orcKey.Trim(), comentarios.Trim())
        context.Response.Write("{""ok"":true,""id"":" & nuevoId.ToString() & "}")
    End Sub

    ' POST — actualizar
    ' Body: id, comentarios
    ' Solo actualiza comentarios — no toca estado ni fechas
    Private Sub Actualizar(context As HttpContext)
        Dim idStr       As String = context.Request.Form("id")
        Dim comentarios As String = context.Request.Form("comentarios")

        If String.IsNullOrEmpty(idStr) OrElse String.IsNullOrEmpty(comentarios) Then
            Responder(context, 400, "Campos requeridos: id, comentarios") : Return
        End If

        ReclamoProveedorService.Actualizar(Convert.ToDecimal(idStr), comentarios.Trim())
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — cambiar-estado
    ' Body: id, estado
    ' Valores validos: INICIADO, PENDIENTE, FINALIZADO, RESUELTO, RECHAZADO
    ' Si estado es de cierre, Oracle asigna fecha_final=SYSDATE automaticamente
    ' Devuelve: { "ok":true, "es_cierre": true/false }
    Private Sub CambiarEstado(context As HttpContext)
        Dim idStr  As String = context.Request.Form("id")
        Dim estado As String = context.Request.Form("estado")

        If String.IsNullOrEmpty(idStr) OrElse String.IsNullOrEmpty(estado) Then
            Responder(context, 400, "Campos requeridos: id, estado") : Return
        End If

        Dim estadoUp As String = estado.Trim().ToUpper()
        If Not Array.Exists(ReclamoProveedorService.EstadosDisponibles,
                            Function(e) e = estadoUp) Then
            Responder(context, 400, "Estado invalido. Valores: INICIADO, PENDIENTE, FINALIZADO, RESUELTO, RECHAZADO") : Return
        End If

        ReclamoProveedorService.CambiarEstado(Convert.ToDecimal(idStr), estadoUp)

        Dim esCierre As Boolean = ReclamoProveedorService.EsEstadoDeCierre(estadoUp)
        context.Response.Write("{""ok"":true,""es_cierre"":" & If(esCierre, "true", "false") & "}")
    End Sub

    ' POST — eliminar
    ' Body: id
    Private Sub Eliminar(context As HttpContext)
        Dim idStr As String = context.Request.Form("id")
        If String.IsNullOrEmpty(idStr) Then
            Responder(context, 400, "Campo 'id' requerido.") : Return
        End If
        ReclamoProveedorService.Eliminar(Convert.ToDecimal(idStr))
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
