Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios
    Partial Public Class LoginEmpleadoPage
        Inherits BasePage

        Private Const MAX_INTENTOS As Integer = 5
        Private Const BLOQUEO_MINUTOS As Integer = 15

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                If Session("UsuarioId") IsNot Nothing Then
                    Response.Redirect("~/Modules/AuthUsuarios/Index.aspx")
                End If
            End If
        End Sub

        Private Function ObtenerClaveIP() As String
            Return "LoginIntentos_" & Request.UserHostAddress
        End Function

        Private Function EstasBloqueado() As Boolean
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

        Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
            lblError.Visible = False
            lblMensaje.Visible = False

            If EstasBloqueado() Then Return

            If String.IsNullOrWhiteSpace(txtUsuario.Text) OrElse
               String.IsNullOrWhiteSpace(txtPassword.Text) Then
                lblError.Text = "Usuario y contraseña son obligatorios."
                lblError.Visible = True
                Return
            End If

            Try
                Dim result As LoginEmpleadoResult =
                    LoginEmpleadoService.Login(txtUsuario.Text.Trim(), txtPassword.Text.Trim())

                If result.Resultado = 1 Then
                    LimpiarIntentos()
                    SecurityLogger.LogLoginExitoso(txtUsuario.Text.Trim(), Request.UserHostAddress)
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
                    RegistrarIntentoFallido()
                    SecurityLogger.LogLoginFallido(txtUsuario.Text.Trim(), Request.UserHostAddress)
                    Dim intentos As Integer = CInt(Session(ObtenerClaveIP() & "_count"))
                    Dim restantes As Integer = MAX_INTENTOS - intentos
                    If restantes > 0 Then
                        lblError.Text = "Usuario o contraseña incorrectos. Intentos restantes: " & restantes
                    Else
                        SecurityLogger.LogCuentaBloqueada(Request.UserHostAddress)
                        lblError.Text = "Cuenta bloqueada por " & BLOQUEO_MINUTOS & " minutos."
                    End If
                    lblError.Visible = True
                End If
            Catch ex As Exception
                RegistrarIntentoFallido()
                lblError.Text = "Usuario o contrasena incorrectos."
                lblError.Visible = True
            End Try
        End Sub

    End Class
End Namespace