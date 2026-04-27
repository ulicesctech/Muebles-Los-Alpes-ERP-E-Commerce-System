<%@ WebHandler Language="VB" Class="ProveedorHandler" %>

Imports System
Imports System.Data
Imports System.Web
Imports System.Text

' ============================================================
' RUTA: Handlers/ComprasProveedor/ProveedorHandler.ashx
' Service: ProveedorService (PKG_CP_BOD_PROVEEDOR)
'
' GET  ?action=listar                  → ProveedorService.Listar()
' GET  ?action=buscar&q=texto           → ProveedorService.Buscar(texto)
' POST ?action=crear                    → ProveedorService.Crear(nit, nombre, avenida, zona, direccion, telefono)
' POST ?action=actualizar               → ProveedorService.Actualizar(id, nit, nombre, avenida, zona, direccion, telefono)
' POST ?action=eliminar                 → ProveedorService.Eliminar(id)
' ============================================================
Public Class ProveedorHandler
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
        context.Response.Write(DataTableToJson(ProveedorService.Listar()))
    End Sub

    ' GET — buscar&q=texto
    Private Sub Buscar(context As HttpContext)
        Dim q As String = If(context.Request.QueryString("q"), "")
        context.Response.Write(DataTableToJson(ProveedorService.Buscar(q.Trim())))
    End Sub

    ' POST — crear
    ' Body: nit, nombre, avenida, zona, direccion, telefono
    ' Devuelve: { "ok":true, "id": X }
    Private Sub Crear(context As HttpContext)
        Dim nit       As String = context.Request.Form("nit")
        Dim nombre    As String = context.Request.Form("nombre")
        Dim avenida   As String = context.Request.Form("avenida")
        Dim zona      As String = context.Request.Form("zona")
        Dim direccion As String = context.Request.Form("direccion")
        Dim telefono  As String = context.Request.Form("telefono")

        If String.IsNullOrEmpty(nit)       OrElse String.IsNullOrEmpty(nombre)    OrElse
           String.IsNullOrEmpty(avenida)   OrElse String.IsNullOrEmpty(zona)      OrElse
           String.IsNullOrEmpty(direccion) OrElse String.IsNullOrEmpty(telefono) Then
            Responder(context, 400, "Campos requeridos: nit, nombre, avenida, zona, direccion, telefono") : Return
        End If

        Dim nuevoId As Decimal = ProveedorService.Crear(nit.Trim(), nombre.Trim(), avenida.Trim(),
                                                         zona.Trim(), direccion.Trim(), telefono.Trim())
        context.Response.Write("{""ok"":true,""id"":" & nuevoId.ToString() & "}")
    End Sub

    ' POST — actualizar
    ' Body: id, nit, nombre, avenida, zona, direccion, telefono
    Private Sub Actualizar(context As HttpContext)
        Dim idStr     As String = context.Request.Form("id")
        Dim nit       As String = context.Request.Form("nit")
        Dim nombre    As String = context.Request.Form("nombre")
        Dim avenida   As String = context.Request.Form("avenida")
        Dim zona      As String = context.Request.Form("zona")
        Dim direccion As String = context.Request.Form("direccion")
        Dim telefono  As String = context.Request.Form("telefono")

        If String.IsNullOrEmpty(idStr)     OrElse String.IsNullOrEmpty(nit)       OrElse
           String.IsNullOrEmpty(nombre)    OrElse String.IsNullOrEmpty(avenida)   OrElse
           String.IsNullOrEmpty(zona)      OrElse String.IsNullOrEmpty(direccion) OrElse
           String.IsNullOrEmpty(telefono) Then
            Responder(context, 400, "Campos requeridos: id, nit, nombre, avenida, zona, direccion, telefono") : Return
        End If

        ProveedorService.Actualizar(Convert.ToDecimal(idStr), nit.Trim(), nombre.Trim(),
                                    avenida.Trim(), zona.Trim(), direccion.Trim(), telefono.Trim())
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — eliminar
    ' Body: id
    Private Sub Eliminar(context As HttpContext)
        Dim idStr As String = context.Request.Form("id")
        If String.IsNullOrEmpty(idStr) Then
            Responder(context, 400, "Campo 'id' requerido.") : Return
        End If
        ProveedorService.Eliminar(Convert.ToDecimal(idStr))
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
