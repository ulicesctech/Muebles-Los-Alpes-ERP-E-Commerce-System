Imports System
Imports System.Data
Imports System.Text.RegularExpressions

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class LoginClientePage
        Inherits BasePage

        Private Const MAX_INTENTOS As Integer = 5
        Private Const BLOQUEO_MINUTOS As Integer = 15

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                If Session("CLI_CLIENTE") IsNot Nothing Then
                    Response.Redirect("~/Modules/Cliente/Catalogo.aspx")
                End If
            End If
        End Sub

        Private Function ObtenerClaveIP() As String
            Return "LoginClienteIntentos_" & Request.UserHostAddress
        End Function

        Private Function EstaBloqueado() As Boolean
            Dim clave As String = ObtenerClaveIP()
            Dim intentos As Integer = If(Session(clave & "_count") IsNot Nothing, CInt(Session(clave & "_count")), 0)
            Dim ultimoIntento As DateTime = If(Session(clave & "_time") IsNot Nothing, CDate(Session(clave & "_time")), DateTime.MinValue)

            If intentos >= MAX_INTENTOS Then
                If DateTime.Now.Subtract(ultimoIntento).TotalMinutes < BLOQUEO_MINUTOS Then
                    Dim minutosRestantes As Integer = BLOQUEO_MINUTOS - CInt(DateTime.Now.Subtract(ultimoIntento).TotalMinutes)
                    lblError.Text = "Demasiados intentos fallidos. Intenta en " & minutosRestantes & " minuto(s)."
                    lblError.Visible = True
                    Return True
                Else
                    Session(clave & "_count") = 0
                End If
            End If
            Return False
        End Function

        Private Sub RegistrarIntentoFallido()
            Dim clave As String = ObtenerClaveIP()
            Dim intentos As Integer = If(Session(clave & "_count") IsNot Nothing, CInt(Session(clave & "_count")), 0)
            Session(clave & "_count") = intentos + 1
            Session(clave & "_time") = DateTime.Now
        End Sub

        Private Sub LimpiarIntentos()
            Dim clave As String = ObtenerClaveIP()
            Session(clave & "_count") = 0
            Session(clave & "_time") = Nothing
        End Sub

        Private Function ValidarPassword(pass As String) As String
            If String.IsNullOrWhiteSpace(pass) Then
                Return "La contrasena es obligatoria."
            End If
            If pass.Length < 8 Then
                Return "La contrasena debe tener minimo 8 caracteres."
            End If
            If Not Regex.IsMatch(pass, "[A-Z]") Then
                Return "La contrasena debe tener al menos una letra mayuscula."
            End If
            If Not Regex.IsMatch(pass, "[a-z]") Then
                Return "La contrasena debe tener al menos una letra minuscula."
            End If
            If Not Regex.IsMatch(pass, "[0-9]") Then
                Return "La contrasena debe tener al menos un numero."
            End If
            Return ""
        End Function

        Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
            lblError.Visible = False

            If EstaBloqueado() Then Return

            If String.IsNullOrWhiteSpace(txtEmail.Text) OrElse
               String.IsNullOrWhiteSpace(txtPassword.Text) Then
                lblError.Text = "Ingrese email y contrasena."
                lblError.Visible = True
                Return
            End If

            Try
                Dim result As LoginClienteResult = LoginClienteService.Validar(
                    txtEmail.Text.Trim(), txtPassword.Text.Trim())

                If result.Resultado = 1 Then
                    LimpiarIntentos()
                    SecurityLogger.LogLoginExitoso(txtEmail.Text.Trim(), Request.UserHostAddress)
                    Dim dt As DataTable = ClienteService.BuscarPorId(result.ClienteId)
                    Dim nombre As String = ""
                    If dt.Rows.Count > 0 Then
                        nombre = dt.Rows(0)("cli_primer_nombre").ToString() & " " &
                                 dt.Rows(0)("cli_primer_apellido").ToString()
                    End If
                    Session("CLI_CLIENTE") = result.ClienteId
                    Session("CLI_NOMBRE") = nombre
                    Session("CLI_EMAIL") = txtEmail.Text.Trim()
                    Response.Redirect("~/Modules/Cliente/Catalogo.aspx")
                Else
                    RegistrarIntentoFallido()
                    SecurityLogger.LogLoginFallido(txtEmail.Text.Trim(), Request.UserHostAddress)
                    Dim intentos As Integer = CInt(Session(ObtenerClaveIP() & "_count"))
                    Dim restantes As Integer = MAX_INTENTOS - intentos
                    If restantes > 0 Then
                        lblError.Text = "Email o contrasena incorrectos. Intentos restantes: " & restantes
                    Else
                        SecurityLogger.LogCuentaBloqueada(Request.UserHostAddress)
                        lblError.Text = "Cuenta bloqueada por " & BLOQUEO_MINUTOS & " minutos."
                    End If
                    lblError.Visible = True
                End If
            Catch ex As Exception
                RegistrarIntentoFallido()
                If ex.Message.Contains("20007") Then
                    lblError.Text = "Email o contrasena incorrectos."
                Else
                    lblError.Text = "Error al iniciar sesion. Intenta de nuevo."
                End If
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub btnRegistrar_Click(sender As Object, e As EventArgs)
            If ddlTipoDoc.SelectedValue = "" OrElse
               String.IsNullOrWhiteSpace(txtNumDoc.Text) OrElse
               String.IsNullOrWhiteSpace(txtPrimerNombre.Text) OrElse
               String.IsNullOrWhiteSpace(txtPrimerApellido.Text) OrElse
               String.IsNullOrWhiteSpace(txtRegEmail.Text) OrElse
               String.IsNullOrWhiteSpace(txtRegPassword.Text) OrElse
               String.IsNullOrWhiteSpace(txtConfirmPassword.Text) OrElse
               String.IsNullOrWhiteSpace(txtTelefono.Text) OrElse
               String.IsNullOrWhiteSpace(txtPais.Text) OrElse
               String.IsNullOrWhiteSpace(txtDepartamento.Text) OrElse
               String.IsNullOrWhiteSpace(txtMunicipio.Text) OrElse
               String.IsNullOrWhiteSpace(txtZona.Text) OrElse
               String.IsNullOrWhiteSpace(txtDireccion.Text) OrElse
               String.IsNullOrWhiteSpace(txtCodigoPostal.Text) OrElse
               ddlTipoClienteReg.SelectedValue = "" Then
                lblError.Text = "Los campos marcados con * son obligatorios."
                lblError.Visible = True
                Return
            End If

            If ddlTipoDoc.SelectedValue = "DPI" Then
                If txtNumDoc.Text.Trim().Length <> 13 OrElse
                   Not txtNumDoc.Text.Trim().All(Function(c) Char.IsDigit(c)) Then
                    lblError.Text = "DPI debe tener exactamente 13 digitos."
                    lblError.Visible = True
                    Return
                End If
            End If

            If txtTelefono.Text.Trim().Length <> 8 OrElse
               Not txtTelefono.Text.Trim().All(Function(c) Char.IsDigit(c)) Then
                lblError.Text = "Telefono debe tener exactamente 8 digitos."
                lblError.Visible = True
                Return
            End If

            Dim errPass As String = ValidarPassword(txtRegPassword.Text)
            If errPass <> "" Then
                lblError.Text = errPass
                lblError.Visible = True
                Return
            End If

            If txtRegPassword.Text <> txtConfirmPassword.Text Then
                lblError.Text = "Las contrasenas no coinciden."
                lblError.Visible = True
                Return
            End If

            Try
                Dim nuevoId As Integer = ClienteService.Crear(
                    ddlTipoDoc.SelectedValue,
                    txtNumDoc.Text.Trim(),
                    If(String.IsNullOrWhiteSpace(txtNITReg.Text), " ", txtNITReg.Text.Trim()),
                    txtPrimerNombre.Text.Trim(),
                    txtSegundoNombre.Text.Trim(),
                    txtPrimerApellido.Text.Trim(),
                    txtSegundoApellido.Text.Trim(),
                    txtPais.Text.Trim(),
                    txtDepartamento.Text.Trim(),
                    txtMunicipio.Text.Trim(),
                    txtZona.Text.Trim(),
                    txtDireccion.Text.Trim(),
                    txtCodigoPostal.Text.Trim(),
                    txtTelefono.Text.Trim(),
                    "",
                    txtRegEmail.Text.Trim(),
                    "",
                    ddlTipoClienteReg.SelectedValue,
                    txtRegPassword.Text.Trim())

                lblMensaje.Text = "Cuenta creada exitosamente. Ya puedes iniciar sesion con tu email."
                lblMensaje.Visible = True
                lblError.Visible = False
                LimpiarRegistro()
            Catch ex As Exception
                If ex.Message.Contains("20006") Then
                    lblError.Text = "El email o documento ya esta registrado."
                Else
                    lblError.Text = "Error: " & ex.Message
                End If
                lblError.Visible = True
            End Try
        End Sub

        Private Sub LimpiarRegistro()
            ddlTipoDoc.SelectedIndex = 0
            txtNumDoc.Text = ""
            txtNITReg.Text = ""
            ddlTipoClienteReg.SelectedIndex = 0
            txtPrimerNombre.Text = ""
            txtSegundoNombre.Text = ""
            txtPrimerApellido.Text = ""
            txtSegundoApellido.Text = ""
            txtRegEmail.Text = ""
            txtRegPassword.Text = ""
            txtConfirmPassword.Text = ""
            txtTelefono.Text = ""
            txtPais.Text = ""
            txtDepartamento.Text = ""
            txtMunicipio.Text = ""
            txtZona.Text = ""
            txtDireccion.Text = ""
            txtCodigoPostal.Text = ""
        End Sub

    End Class
End Namespace