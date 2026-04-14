Namespace Modules.Cliente

    Public Class Registro
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Session("CLI_CLIENTE") IsNot Nothing Then
                Response.Redirect("~/Modules/Cliente/Catalogo.aspx")
            End If
        End Sub

        Protected Sub btnRegistrar_Click(sender As Object, e As EventArgs)
            pnlMsg.Visible = False

            ' Validaciones básicas
            If String.IsNullOrEmpty(txtPNombre.Text.Trim()) OrElse
               String.IsNullOrEmpty(txtPApellido.Text.Trim()) OrElse
               String.IsNullOrEmpty(txtNumDoc.Text.Trim()) OrElse
               String.IsNullOrEmpty(txtEmail.Text.Trim()) OrElse
               String.IsNullOrEmpty(txtUsuario.Text.Trim()) OrElse
               String.IsNullOrEmpty(txtPassword.Text.Trim()) Then
                MostrarError("Completa todos los campos obligatorios (*).")
                Return
            End If

            Try
                ' 1. Crear cliente
                Dim clienteId As Integer = AuthClienteService.RegistrarCliente(
                    ddlTipoDoc.SelectedValue,
                    txtNumDoc.Text.Trim(),
                    txtPNombre.Text.Trim(),
                    txtSNombre.Text.Trim(),
                    txtPApellido.Text.Trim(),
                    txtSApellido.Text.Trim(),
                    txtPais.Text.Trim(),
                    txtDepartamento.Text.Trim(),
                    txtMunicipio.Text.Trim(),
                    txtZona.Text.Trim(),
                    txtDireccion.Text.Trim(),
                    txtCP.Text.Trim(),
                    txtTel1.Text.Trim(),
                    txtTel2.Text.Trim(),
                    txtEmail.Text.Trim(),
                    txtProfesion.Text.Trim(),
                    ddlTipoCliente.SelectedValue
                )

                ' 2. Crear login
                AuthClienteService.CrearLogin(clienteId, txtUsuario.Text.Trim(), txtPassword.Text.Trim())

                ' 3. Sesión automática
                Session("CLI_CLIENTE") = clienteId
                Session("CLI_NOMBRE") = txtPNombre.Text.Trim() & " " & txtPApellido.Text.Trim()
                Session("CLI_EMAIL") = txtEmail.Text.Trim()

                Response.Redirect("~/Modules/Cliente/Catalogo.aspx")

            Catch ex As Exception
                If ex.Message.Contains("unique") OrElse ex.Message.Contains("ORA-00001") Then
                    MostrarError("Ya existe una cuenta con ese email, documento o usuario.")
                Else
                    MostrarError("Error al crear cuenta: " & ex.Message)
                End If
            End Try
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = msg
            lblMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

    End Class

End Namespace