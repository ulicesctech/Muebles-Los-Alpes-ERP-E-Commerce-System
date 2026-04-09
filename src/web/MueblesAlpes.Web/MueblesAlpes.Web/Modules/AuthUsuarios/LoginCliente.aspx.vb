Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class LoginClientePage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                If Session("UsuarioId") IsNot Nothing Then
                    Response.Redirect("~/Modules/AuthUsuarios/Index.aspx")
                End If
            End If
        End Sub

        '══════════════════════════════════════
        ' LOGIN CLIENTE
        '══════════════════════════════════════
        Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
            lblLoginError.Visible = False
            lblLoginMensaje.Visible = False

            If String.IsNullOrWhiteSpace(txtEmail.Text) OrElse
               String.IsNullOrWhiteSpace(txtPassword.Text) Then
                lblLoginError.Text = "⚠️ Email y contraseña son obligatorios."
                lblLoginError.Visible = True
                Return
            End If

            Try
                Dim result As LoginClienteResult =
                    LoginClienteService.Validar(txtEmail.Text.Trim(), txtPassword.Text.Trim())

                If result.Resultado = 1 Then
                    Dim dt As DataTable = ClienteService.BuscarPorId(result.ClienteId)
                    If dt.Rows.Count > 0 Then
                        Dim row = dt.Rows(0)
                        Session("UsuarioId") = result.ClienteId
                        Session("UsuarioNombre") = row("cli_primer_nombre").ToString() & " " &
                                                   row("cli_primer_apellido").ToString()
                        Session("UsuarioGrupo") = "Cliente"
                        Session("UsuarioTipo") = "CLIENTE"
                        Session("PerAdmin") = False
                        Session("PerRH") = False
                        Session("PerFac") = False
                        Session("PerCli") = False
                        Session("PerBod") = False
                        Session("PerPromo") = False
                    End If
                    Response.Redirect("~/Modules/AuthUsuarios/Index.aspx")
                Else
                    lblLoginError.Text = "❌ Email o contraseña incorrectos."
                    lblLoginError.Visible = True
                End If
            Catch ex As Exception
                lblLoginError.Text = "Error: " & ex.Message
                lblLoginError.Visible = True
            End Try
        End Sub

        '══════════════════════════════════════
        ' REGISTRO CLIENTE
        '══════════════════════════════════════
        Protected Sub btnRegistrar_Click(sender As Object, e As EventArgs)
            lblRegError.Visible = False
            lblRegMensaje.Visible = False

            If ddlTipoDoc.SelectedValue = "" OrElse
               String.IsNullOrWhiteSpace(txtNumDoc.Text) OrElse
               String.IsNullOrWhiteSpace(txtPrimerNombre.Text) OrElse
               String.IsNullOrWhiteSpace(txtPrimerApellido.Text) OrElse
               String.IsNullOrWhiteSpace(txtEmailReg.Text) OrElse
               String.IsNullOrWhiteSpace(txtTelefono.Text) OrElse
               String.IsNullOrWhiteSpace(txtPais.Text) OrElse
               String.IsNullOrWhiteSpace(txtDepartamento.Text) OrElse
               String.IsNullOrWhiteSpace(txtMunicipio.Text) OrElse
               String.IsNullOrWhiteSpace(txtZona.Text) OrElse
               String.IsNullOrWhiteSpace(txtDireccion.Text) OrElse
               String.IsNullOrWhiteSpace(txtCodigoPostal.Text) OrElse
               ddlTipoCliente.SelectedValue = "" Then
                lblRegError.Text = "⚠️ Todos los campos obligatorios deben completarse."
                lblRegError.Visible = True
                Return
            End If

            If ddlTipoDoc.SelectedValue = "DPI" Then
                If txtNumDoc.Text.Trim().Length <> 13 OrElse
                   Not txtNumDoc.Text.Trim().All(Function(c) Char.IsDigit(c)) Then
                    lblRegError.Text = "⚠️ DPI debe tener exactamente 13 dígitos."
                    lblRegError.Visible = True
                    Return
                End If
            End If

            If txtTelefono.Text.Trim().Length <> 8 OrElse
               Not txtTelefono.Text.Trim().All(Function(c) Char.IsDigit(c)) Then
                lblRegError.Text = "⚠️ Teléfono debe tener exactamente 8 dígitos."
                lblRegError.Visible = True
                Return
            End If

            Try
                Dim nuevoId As Integer = ClienteService.Crear(
                    ddlTipoDoc.SelectedValue,
                    txtNumDoc.Text.Trim(),
                    "",
                    txtPrimerNombre.Text.Trim(),
                    "",
                    txtPrimerApellido.Text.Trim(),
                    "",
                    txtPais.Text.Trim(),
                    txtDepartamento.Text.Trim(),
                    txtMunicipio.Text.Trim(),
                    txtZona.Text.Trim(),
                    txtDireccion.Text.Trim(),
                    txtCodigoPostal.Text.Trim(),
                    txtTelefono.Text.Trim(),
                    "",
                    txtEmailReg.Text.Trim(),
                    "",
                    ddlTipoCliente.SelectedValue
                )
                lblRegMensaje.Text = "✅ Registro exitoso con ID: " & nuevoId &
                                        ". Ya puedes iniciar sesión con tu email y número de documento."
                lblRegMensaje.Visible = True
                LimpiarRegistro()
            Catch ex As Exception
                If ex.Message.Contains("20006") OrElse
                   ex.Message.ToLower().Contains("ya registrado") Then
                    lblRegError.Text = "❌ El email o documento ya está registrado."
                Else
                    lblRegError.Text = "Error: " & ex.Message
                End If
                lblRegError.Visible = True
            End Try
        End Sub

        Private Sub LimpiarRegistro()
            ddlTipoDoc.SelectedIndex = 0
            txtNumDoc.Text = ""
            txtPrimerNombre.Text = ""
            txtPrimerApellido.Text = ""
            txtEmailReg.Text = ""
            txtTelefono.Text = ""
            txtPais.Text = ""
            txtDepartamento.Text = ""
            txtMunicipio.Text = ""
            txtZona.Text = ""
            txtDireccion.Text = ""
            txtCodigoPostal.Text = ""
            ddlTipoCliente.SelectedIndex = 0
        End Sub

    End Class
End Namespace