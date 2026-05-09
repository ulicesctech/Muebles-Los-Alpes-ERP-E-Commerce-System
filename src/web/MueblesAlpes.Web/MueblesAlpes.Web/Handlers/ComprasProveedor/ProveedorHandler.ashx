<%@ WebHandler Language="VB" Class="ProveedorHandler" %>
Imports System.Web
Imports System.Data
Imports System.Text.RegularExpressions
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/ComprasProveedor/ProveedorHandler.ashx
' ============================================================
Public Class ProveedorHandler
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
                    ListarProveedores(context)
                Case "buscar"
                    BuscarProveedores(context)
                Case "crear"
                    CrearProveedor(context)
                Case "actualizar"
                    ActualizarProveedor(context)
                Case "eliminar"
                    EliminarProveedor(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""error"": ""Acción no válida. Usa ?action=listar|buscar|crear|actualizar|eliminar""}")
            End Select
        Catch ex As Exception
            context.Response.StatusCode = 500
            Dim msgError As String = LimpiarMensajeOracle(ex.Message)
            context.Response.Write("{""error"": """ & msgError.Replace("""", "\""") & """}")
        End Try
    End Sub

    ' ==========================================================
    ' VALIDACIONES — espejo del package Oracle
    ' PKG_CP_BOD_PROVEEDOR.VALIDAR_NIT / VALIDAR_TELEFONO
    ' ==========================================================

    ''' <summary>
    ''' NIT Guatemala sin guion: 3-10 caracteres (2-9 dígitos + dígito verificador 0-9 ó K).
    ''' CUI: exactamente 13 dígitos.
    ''' </summary>
    Private Function ValidarNit(nit As String) As Boolean
        Dim v As String = nit.Trim().ToUpper()
        If Regex.IsMatch(v, "^\d{13}$") Then Return True          ' CUI
        If Regex.IsMatch(v, "^\d{2,9}[\dK]$") Then Return True    ' NIT sin guion
        Return False
    End Function

    ''' <summary>
    ''' Teléfono: exactamente 8 dígitos numéricos.
    ''' </summary>
    Private Function ValidarTelefono(tel As String) As Boolean
        Return Regex.IsMatch(tel.Trim(), "^\d{8}$")
    End Function

    ''' <summary>
    ''' Valida todos los campos obligatorios antes de llamar a Oracle.
    ''' Lanza excepción con mensaje legible si algo falla.
    ''' </summary>
    Private Sub ValidarCampos(nit As String, nombre As String, avenida As String,
                               zona As String, direccion As String, telefono As String,
                               Optional validarNitFlag As Boolean = True)
        If validarNitFlag Then
            If String.IsNullOrWhiteSpace(nit) Then Throw New Exception("El NIT o CUI es obligatorio.")
            If Not ValidarNit(nit) Then
                Throw New Exception(
                    "NIT o CUI con formato inválido. " &
                    "Acepta NIT sin guion (ej: 123456789 ó 12345678K) " &
                    "o CUI de 13 dígitos (ej: 1234567890101).")
            End If
        End If

        If String.IsNullOrWhiteSpace(nombre)    Then Throw New Exception("El nombre o razón social es obligatorio.")
        If String.IsNullOrWhiteSpace(avenida)   Then Throw New Exception("La avenida es obligatoria.")
        If String.IsNullOrWhiteSpace(zona)      Then Throw New Exception("La zona es obligatoria.")
        If String.IsNullOrWhiteSpace(direccion) Then Throw New Exception("La dirección es obligatoria.")

        If String.IsNullOrWhiteSpace(telefono) Then Throw New Exception("El teléfono es obligatorio.")
        If Not ValidarTelefono(telefono) Then
            Throw New Exception("El teléfono debe tener exactamente 8 dígitos numéricos (ej: 22223333).")
        End If
    End Sub

    ' ==========================================================
    ' Limpia el prefijo ORA-XXXXX: que Oracle agrega a RAISE_APPLICATION_ERROR
    ' y deja sólo el mensaje legible para el usuario.
    ' ==========================================================
    Private Function LimpiarMensajeOracle(msg As String) As String
        ' Ej: "ORA-20008: PKG_CP_BOD_PROVEEDOR: NIT o CUI con formato invalido..."
        '     "ORA-20001: PKG_CP_BOD_PROVEEDOR: NIT obligatorio.\nORA-06512:..."
        Dim limpio As String = msg

        ' Quita todo desde el segundo ORA- en adelante (stack trace de Oracle)
        Dim stackPos As Integer = limpio.IndexOf(vbLf & "ORA-")
        If stackPos > 0 Then limpio = limpio.Substring(0, stackPos)

        ' Quita el prefijo "ORA-NNNNN: "
        limpio = Regex.Replace(limpio.Trim(), "^ORA-\d+:\s*", "")

        ' Quita el prefijo del package si lo tiene
        limpio = Regex.Replace(limpio, "^PKG_CP_BOD_PROVEEDOR:\s*", "")

        Return limpio.Trim()
    End Function

    ' ==========================================================
    ' ACTIONS
    ' ==========================================================

    Private Sub ListarProveedores(context As HttpContext)
        Dim dt As DataTable = ProveedorService.Listar()
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    ' Buscar: acepta texto vacío (devuelve todo, igual que listar)
    ' Compatible con buscador debounce del móvil.
    Private Sub BuscarProveedores(context As HttpContext)
        Dim texto As String = If(context.Request("texto"), "").Trim()
        If texto = "" Then
            ListarProveedores(context)
            Return
        End If
        Dim dt As DataTable = ProveedorService.Buscar(texto)
        context.Response.Write(JsonConvert.SerializeObject(dt))
    End Sub

    Private Sub CrearProveedor(context As HttpContext)
        Dim nit      As String = If(context.Request("nit"), "").Trim().ToUpper()
        Dim nombre   As String = If(context.Request("nombre"), "").Trim()
        Dim avenida  As String = If(context.Request("avenida"), "").Trim()
        Dim zona     As String = If(context.Request("zona"), "").Trim()
        Dim direccion As String = If(context.Request("direccion"), "").Trim()
        Dim telefono As String = If(context.Request("telefono"), "").Trim()

        ' Validación en el handler antes de llegar a Oracle
        ValidarCampos(nit, nombre, avenida, zona, direccion, telefono, validarNitFlag:=True)

        Dim nuevoId As Decimal = ProveedorService.Crear(nit, nombre, avenida, zona, direccion, telefono)
        context.Response.Write("{""mensaje"": ""Proveedor creado con éxito"", ""id"": " & nuevoId & "}")
    End Sub

    Private Sub ActualizarProveedor(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        ' En actualizar el NIT viene pero no se re-valida el formato
        ' porque Oracle no permite cambiarlo (el package lo admite pero
        ' la web y el móvil lo envían igual que estaba).
        ' De todas formas lo validamos para consistencia.
        Dim nit      As String = If(context.Request("nit"), "").Trim().ToUpper()
        Dim nombre   As String = If(context.Request("nombre"), "").Trim()
        Dim avenida  As String = If(context.Request("avenida"), "").Trim()
        Dim zona     As String = If(context.Request("zona"), "").Trim()
        Dim direccion As String = If(context.Request("direccion"), "").Trim()
        Dim telefono As String = If(context.Request("telefono"), "").Trim()

        ValidarCampos(nit, nombre, avenida, zona, direccion, telefono, validarNitFlag:=True)

        ProveedorService.Actualizar(id, nit, nombre, avenida, zona, direccion, telefono)
        context.Response.Write("{""mensaje"": ""Proveedor actualizado con éxito""}")
    End Sub

    Private Sub EliminarProveedor(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request("id"))
        ProveedorService.Eliminar(id)
        context.Response.Write("{""mensaje"": ""Proveedor eliminado con éxito""}")
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
