Namespace Modules.Cliente

    Public Class Login
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            ' Si ya hay sesión activa redirigir al catálogo
            If Session("CLI_CLIENTE") IsNot Nothing Then
                Response.Redirect("~/Modules/Cliente/Catalogo.aspx")
            End If
        End Sub

        Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
            pnlMsg.Visible = False
            Dim usuario As String = txtUsuario.Text.Trim()
            Dim password As String = txtPassword.Text.Trim()

            If String.IsNullOrEmpty(usuario) OrElse String.IsNullOrEmpty(password) Then
                MostrarError("Ingresa tu usuario o email y contraseña.")
                Return
            End If

            Try
                Dim clienteId As Integer = 0

                ' Intentar por usuario
                Try
                    clienteId = AuthClienteService.Autenticar(usuario, password)
                Catch
                End Try

                ' Si falla, intentar por email
                If clienteId = 0 Then
                    Try
                        clienteId = AuthClienteService.AutenticarPorEmail(usuario, password)
                    Catch
                    End Try
                End If

                If clienteId = 0 Then
                    MostrarError("Usuario, email o contraseña incorrectos.")
                    Return
                End If

                Session("CLI_CLIENTE") = clienteId
                Dim nombre As String = ""
                Dim email As String = ""
                AuthClienteService.ObtenerDatosCliente(clienteId, nombre, email)
                Session("CLI_NOMBRE") = nombre
                Session("CLI_EMAIL") = email

                Dim returnUrl As String = Request.QueryString("returnUrl")
                If Not String.IsNullOrEmpty(returnUrl) Then
                    Response.Redirect(returnUrl)
                Else
                    Response.Redirect("~/Modules/Cliente/Catalogo.aspx")
                End If

            Catch ex As Exception
                MostrarError("Usuario, email o contraseña incorrectos.")
            End Try
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = msg
            lblMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

    End Class

End Namespace