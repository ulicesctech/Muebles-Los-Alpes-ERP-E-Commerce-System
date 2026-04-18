Imports System

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
                    Session("UsuarioId") = result.ClienteId
                    Session("UsuarioNombre") = nombre
                    Session("UsuarioGrupo") = "Cliente"
                    Session("UsuarioTipo") = "CLIENTE"
                    Session("PerAdmin") = False
                    Session("PerRH") = False
                    Session("PerFac") = False
                    Session("PerCli") = False
                    Session("PerBod") = False
                    Session("PerPromo") = False
                    Response.Redirect("~/Modules/AuthUsuarios/Index.aspx")
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
               String.IsNullOrWhiteSpace(txtTelefono.Text) OrElse
               String.IsNullOrWhiteSpace(txtPais.Text) OrElse
               String.IsNullOrWhiteSpace(txtDepartamento.Text) OrElse
               String.IsNullOrWhiteSpace(txtMunicipio.Text) OrElse
               String.IsNullOrWhiteSpace(txtZona.Text) OrElse
               String.IsNullOrWhiteSpace(txtDireccion.Text) OrElse
               String.IsNullOrWhiteSpace(txtCodigoPostal.Text) Then
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

            Try
                Dim nuevoId As Integer = ClienteService.Crear(
                    ddlTipoDoc.SelectedValue,
                    txtNumDoc.Text.Trim(),
                    "",
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
                    "NATURAL")

                lblMensaje.Text = "✅ Cuenta creada. Ya puedes ingresar con tu email y número de documento."
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
            txtPrimerNombre.Text = ""
            txtSegundoNombre.Text = ""
            txtPrimerApellido.Text = ""
            txtSegundoApellido.Text = ""
            txtRegEmail.Text = ""
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