Imports System

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class LoginEmpleadoPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                If Session("UsuarioId") IsNot Nothing Then
                    Response.Redirect("~/Modules/AuthUsuarios/Index.aspx")
                End If
            End If
        End Sub

        Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
            lblError.Visible = False
            lblMensaje.Visible = False

            If String.IsNullOrWhiteSpace(txtUsuario.Text) OrElse
               String.IsNullOrWhiteSpace(txtPassword.Text) Then
                lblError.Text = "⚠️ Usuario y contraseña son obligatorios."
                lblError.Visible = True
                Return
            End If

            Try
                Dim result As LoginEmpleadoResult =
                    LoginEmpleadoService.Login(txtUsuario.Text.Trim(), txtPassword.Text.Trim())

                If result.Resultado = 1 Then
                    Session("UsuarioId") = result.EmpleadoId
                    Session("UsuarioNombre") = result.Nombre
                    Session("UsuarioGrupo") = result.Grupo
                    Session("UsuarioTipo") = "EMPLEADO"
                    Session("PerAdmin") = (result.PerAdmin = 1)
                    Session("PerRH") = (result.PerRH = 1)
                    Session("PerFac") = (result.PerFac = 1)
                    Session("PerCli") = (result.PerCli = 1)
                    Session("PerBod") = (result.PerBod = 1)
                    Session("PerPromo") = (result.PerPromo = 1)
                    Response.Redirect("~/Modules/AuthUsuarios/Index.aspx")
                Else
                    lblError.Text = "❌ Usuario o contraseña incorrectos."
                    lblError.Visible = True
                End If
            Catch ex As Exception
                lblError.Text = "Error: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

    End Class
End Namespace