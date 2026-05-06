<%@ WebHandler Language="VB" Class="ProveedorHandler" %>

Imports System
Imports System.Data
Imports System.Web
Imports System.Text
Imports System.Text.RegularExpressions

' ============================================================
' RUTA: Handlers/ComprasProveedor/ProveedorHandler.ashx
' Service: ProveedorService (PKG_CP_BOD_PROVEEDOR)
'
' GET  ?action=listar                  → ProveedorService.Listar()
' GET  ?action=buscar&q=texto          → ProveedorService.Buscar(texto)
' POST ?action=crear                   → ProveedorService.Crear(nit, nombre, avenida, zona, direccion, telefono)
' POST ?action=actualizar              → ProveedorService.Actualizar(id, nit, nombre, avenida, zona, direccion, telefono)
' POST ?action=eliminar                → ProveedorService.Eliminar(id)
' ============================================================
Public Class ProveedorHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.Charset = "utf-8"

        ' CORS — permite llamadas desde la app movil
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        If context.Request.HttpMethod.ToUpper() = "OPTIONS" Then
            context.Response.StatusCode = 200
            context.Response.End()
            Return
        End If

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
                        Case "crear" : Crear(context)
                        Case "actualizar" : Actualizar(context)
                        Case "eliminar" : Eliminar(context)
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

    ' =============================================
    ' GET — listar
    ' =============================================
    Private Sub Listar(context As HttpContext)
        context.Response.Write(DataTableToJson(ProveedorService.Listar()))
    End Sub

    ' =============================================
    ' GET — buscar&q=texto
    ' =============================================
    Private Sub Buscar(context As HttpContext)
        Dim q As String = If(context.Request.QueryString("q"), "")
        context.Response.Write(DataTableToJson(ProveedorService.Buscar(q.Trim())))
    End Sub

    ' =============================================
    ' POST — crear
    ' Body: nit, nombre, avenida, zona, direccion, telefono
    ' Devuelve: { "ok":true, "id": X }
    ' =============================================
    Private Sub Crear(context As HttpContext)
        Dim nit As String = If(context.Request.Form("nit"), "").Trim()
        Dim nombre As String = If(context.Request.Form("nombre"), "").Trim()
        Dim avenida As String = If(context.Request.Form("avenida"), "").Trim()
        Dim zona As String = If(context.Request.Form("zona"), "").Trim()
        Dim direccion As String = If(context.Request.Form("direccion"), "").Trim()
        Dim telefono As String = If(context.Request.Form("telefono"), "").Trim()

        ' Validar campos obligatorios
        Dim err As String = ValidarCampos(nit, nombre, avenida, zona, direccion, telefono, False)
        If Not String.IsNullOrEmpty(err) Then
            Responder(context, 422, err) : Return
        End If

        Dim nuevoId As Decimal = ProveedorService.Crear(nit, nombre, avenida, zona, direccion, telefono)
        context.Response.Write("{""ok"":true,""id"":" & nuevoId.ToString() & "}")
    End Sub

    ' =============================================
    ' POST — actualizar
    ' Body: id, nit, nombre, avenida, zona, direccion, telefono
    ' Devuelve: { "ok":true }
    ' =============================================
    Private Sub Actualizar(context As HttpContext)
        Dim idStr As String = If(context.Request.Form("id"), "").Trim()
        Dim nit As String = If(context.Request.Form("nit"), "").Trim()
        Dim nombre As String = If(context.Request.Form("nombre"), "").Trim()
        Dim avenida As String = If(context.Request.Form("avenida"), "").Trim()
        Dim zona As String = If(context.Request.Form("zona"), "").Trim()
        Dim direccion As String = If(context.Request.Form("direccion"), "").Trim()
        Dim telefono As String = If(context.Request.Form("telefono"), "").Trim()

        Dim id As Decimal = 0
        If Not Decimal.TryParse(idStr, id) OrElse id <= 0 Then
            Responder(context, 422, "Campo 'id' invalido.") : Return
        End If

        ' En edicion el NIT no se valida de formato (ya existe), solo obligatorio
        Dim err As String = ValidarCampos(nit, nombre, avenida, zona, direccion, telefono, True)
        If Not String.IsNullOrEmpty(err) Then
            Responder(context, 422, err) : Return
        End If

        ProveedorService.Actualizar(id, nit, nombre, avenida, zona, direccion, telefono)
        context.Response.Write("{""ok"":true}")
    End Sub

    ' =============================================
    ' POST — eliminar
    ' Body: id
    ' Devuelve: { "ok":true }
    ' =============================================
    Private Sub Eliminar(context As HttpContext)
        Dim idStr As String = If(context.Request.Form("id"), "").Trim()

        Dim id As Decimal = 0
        If Not Decimal.TryParse(idStr, id) OrElse id <= 0 Then
            Responder(context, 422, "Campo 'id' invalido.") : Return
        End If

        Try
            ProveedorService.Eliminar(id)
            context.Response.Write("{""ok"":true}")
        Catch ex As Exception
            ' FK violation de Oracle: tiene ordenes, facturas o reclamos vinculados
            If ex.Message.Contains("ORA-02292") Then
                Responder(context, 409, "No se puede eliminar: este proveedor tiene ordenes, facturas o reclamos vinculados.")
            Else
                Throw
            End If
        End Try
    End Sub

    ' =============================================
    ' VALIDACIONES
    ' esEdicion=True omite la validacion de formato NIT/CUI
    ' (en edicion el NIT no se puede cambiar)
    ' =============================================
    Private Function ValidarCampos(nit As String, nombre As String, avenida As String,
                                    zona As String, direccion As String, telefono As String,
                                    esEdicion As Boolean) As String
        If String.IsNullOrWhiteSpace(nit) Then Return "El NIT es obligatorio."
        If String.IsNullOrWhiteSpace(nombre) Then Return "El nombre es obligatorio."
        If String.IsNullOrWhiteSpace(avenida) Then Return "La avenida es obligatoria."
        If String.IsNullOrWhiteSpace(zona) Then Return "La zona es obligatoria."
        If String.IsNullOrWhiteSpace(direccion) Then Return "La direccion es obligatoria."
        If String.IsNullOrWhiteSpace(telefono) Then Return "El telefono es obligatorio."

        ' Telefono: exactamente 8 digitos numericos
        If Not Regex.IsMatch(telefono, "^\d{8}$") Then
            Return "El telefono debe tener exactamente 8 digitos numericos (ej: 22223333)."
        End If

        ' Formato NIT/CUI solo al crear
        If Not esEdicion Then
            Dim nitUp As String = nit.ToUpper()
            Dim esCui As Boolean = Regex.IsMatch(nitUp, "^\d{13}$")
            Dim esNit As Boolean = Regex.IsMatch(nitUp, "^\d{2,9}[\dK]$")
            If Not esCui AndAlso Not esNit Then
                Return "El NIT/CUI no tiene formato valido. Acepta: NIT sin guion (ej: 123456789 o 12345678K) o CUI de 13 digitos."
            End If
        End If

        Return ""
    End Function

    ' =============================================
    ' HELPER — escribe { "ok":false, "error":"..." }
    ' =============================================
    Private Sub Responder(context As HttpContext, statusCode As Integer, mensaje As String)
        context.Response.StatusCode = statusCode
        context.Response.Write("{""ok"":false,""error"":""" &
            mensaje.Replace("\", "\\").Replace("""", "\""") & """}")
    End Sub

    ' =============================================
    ' HELPER — DataTable a JSON
    ' Serializa cada fila con los nombres de columna
    ' exactos que devuelve Oracle (PROV_PROVEEDOR, etc.)
    ' =============================================
    Private Function DataTableToJson(dt As DataTable) As String
        If dt Is Nothing OrElse dt.Rows.Count = 0 Then Return "[]"

        Dim sb As New StringBuilder()
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
                       TypeOf val Is Long OrElse TypeOf val Is Double Then
                    sb.Append(val.ToString())
                Else
                    sb.Append("""" &
                        val.ToString() _
                            .Replace("\", "\\") _
                            .Replace("""", "\""") _
                            .Replace(vbCr, "") _
                            .Replace(vbLf, " ") &
                        """")
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
