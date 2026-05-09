Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class LoginClientePage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                If Session("CLI_CLIENTE") IsNot Nothing Then
                    Response.Redirect("~/Modules/Cliente/Catalogo.aspx")
                End If
            End If
        End Sub

        Private Function ValidarPassword(pass As String) As String
            If String.IsNullOrWhiteSpace(pass) Then
                Return "⚠️ La contraseña es obligatoria."
            End If
            If pass.Length < 8 Then
                Return "⚠️ La contraseña debe tener mínimo 8 caracteres."
            End If
            If Not Regex.IsMatch(pass, "[A-Z]") Then
                Return "⚠️ La contraseña debe tener al menos una letra mayúscula."
            End If
            If Not Regex.IsMatch(pass, "[a-z]") Then
                Return "⚠️ La contraseña debe tener al menos una letra minúscula."
            End If
            If Not Regex.IsMatch(pass, "[0-9]") Then
                Return "⚠️ La contraseña debe tener al menos un número."
            End If
            Return ""
        End Function

        Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtEmail.Text) OrElse
       String.IsNullOrWhiteSpace(txtPassword.Text) Then
                lblError.Text = "⚠️ Ingrese email y contraseña."
                lblError.Visible = True
                Return
            End If
            Try
                Dim result As LoginClienteResult = LoginClienteService.Validar(
            txtEmail.Text.Trim(), txtPassword.Text.Trim())
                If result.Resultado = 1 Then
                    Dim dt As System.Data.DataTable = ClienteService.BuscarPorId(result.ClienteId)
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
                    lblError.Text = "❌ Email o contraseña incorrectos."
                    lblError.Visible = True
                End If
            Catch ex As Exception
                lblError.Text = "Error: " & ex.Message
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
                lblError.Text = "⚠️ Los campos marcados con * son obligatorios."
                lblError.Visible = True
                Return
            End If

            If ddlTipoDoc.SelectedValue = "DPI" Then
                If txtNumDoc.Text.Trim().Length <> 13 OrElse
                   Not txtNumDoc.Text.Trim().All(Function(c) Char.IsDigit(c)) Then
                    lblError.Text = "⚠️ DPI debe tener exactamente 13 dígitos."
                    lblError.Visible = True
                    Return
                End If
            End If

            If txtTelefono.Text.Trim().Length <> 8 OrElse
               Not txtTelefono.Text.Trim().All(Function(c) Char.IsDigit(c)) Then
                lblError.Text = "⚠️ Teléfono debe tener exactamente 8 dígitos."
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
                lblError.Text = "⚠️ Las contraseñas no coinciden."
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

                lblMensaje.Text = "✅ Cuenta creada exitosamente. Ya puedes iniciar sesión con tu email."
                lblMensaje.Visible = True
                lblError.Visible = False
                LimpiarRegistro()
            Catch ex As Exception
                If ex.Message.Contains("20006") Then
                    lblError.Text = "❌ El email o documento ya está registrado."
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