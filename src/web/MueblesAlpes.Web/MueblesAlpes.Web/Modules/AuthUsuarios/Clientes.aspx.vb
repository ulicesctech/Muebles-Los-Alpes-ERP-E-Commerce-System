Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class ClientesPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarClientes()
            End If
        End Sub

        Private Sub CargarClientes()
            Try
                gvClientes.DataSource = ClienteService.Listar()
                gvClientes.DataBind()
                lblMensaje.Visible = False
                lblError.Visible = False
            Catch ex As Exception
                lblError.Text = "Error al cargar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            Try
                If Not String.IsNullOrWhiteSpace(txtBuscarEmail.Text) Then
                    gvClientes.DataSource = ClienteService.BuscarPorEmail(txtBuscarEmail.Text.Trim())
                ElseIf Not String.IsNullOrWhiteSpace(txtBuscarDoc.Text) Then
                    gvClientes.DataSource = ClienteService.BuscarPorDocumento(txtBuscarDoc.Text.Trim())
                Else
                    lblError.Text = "⚠️ Ingrese email o documento para buscar."
                    lblError.Visible = True
                    Return
                End If
                gvClientes.DataBind()
                lblError.Visible = False
            Catch ex As Exception
                lblError.Text = "Error al buscar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub btnVerTodos_Click(sender As Object, e As EventArgs)
            txtBuscarEmail.Text = ""
            txtBuscarDoc.Text = ""
            CargarClientes()
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If ddlTipoDoc.SelectedValue = "" OrElse
               String.IsNullOrWhiteSpace(txtNumDoc.Text) OrElse
               String.IsNullOrWhiteSpace(txtPrimerNombre.Text) OrElse
               String.IsNullOrWhiteSpace(txtPrimerApellido.Text) OrElse
               String.IsNullOrWhiteSpace(txtEmail.Text) OrElse
               String.IsNullOrWhiteSpace(txtTelefono1.Text) OrElse
               String.IsNullOrWhiteSpace(txtPais.Text) OrElse
               String.IsNullOrWhiteSpace(txtDepartamento.Text) OrElse
               String.IsNullOrWhiteSpace(txtMunicipio.Text) OrElse
               String.IsNullOrWhiteSpace(txtZona.Text) OrElse
               String.IsNullOrWhiteSpace(txtDireccion.Text) OrElse
               String.IsNullOrWhiteSpace(txtCodigoPostal.Text) OrElse
               ddlTipoCliente.SelectedValue = "" Then
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

            If txtTelefono1.Text.Trim().Length <> 8 OrElse
               Not txtTelefono1.Text.Trim().All(Function(c) Char.IsDigit(c)) Then
                lblError.Text = "⚠️ Teléfono debe tener exactamente 8 dígitos."
                lblError.Visible = True
                Return
            End If

            Try
                If hfId.Value <> "" Then
                    ClienteService.Actualizar(
                        Convert.ToInt32(hfId.Value),
                        ddlTipoDoc.SelectedValue,
                        txtNumDoc.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtNIT.Text), " ", txtNIT.Text.Trim()),
                        txtPrimerNombre.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtSegundoNombre.Text), " ", txtSegundoNombre.Text.Trim()),
                        txtPrimerApellido.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtSegundoApellido.Text), " ", txtSegundoApellido.Text.Trim()),
                        txtPais.Text.Trim(),
                        txtDepartamento.Text.Trim(),
                        txtMunicipio.Text.Trim(),
                        txtZona.Text.Trim(),
                        txtDireccion.Text.Trim(),
                        txtCodigoPostal.Text.Trim(),
                        txtTelefono1.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtTelefono2.Text), " ", txtTelefono2.Text.Trim()),
                        txtEmail.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtProfesion.Text), " ", txtProfesion.Text.Trim()),
                        ddlTipoCliente.SelectedValue)
                    lblMensaje.Text = "✅ Cliente actualizado correctamente."
                Else
                    Dim nuevoId As Integer = ClienteService.Crear(
                        ddlTipoDoc.SelectedValue,
                        txtNumDoc.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtNIT.Text), " ", txtNIT.Text.Trim()),
                        txtPrimerNombre.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtSegundoNombre.Text), " ", txtSegundoNombre.Text.Trim()),
                        txtPrimerApellido.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtSegundoApellido.Text), " ", txtSegundoApellido.Text.Trim()),
                        txtPais.Text.Trim(),
                        txtDepartamento.Text.Trim(),
                        txtMunicipio.Text.Trim(),
                        txtZona.Text.Trim(),
                        txtDireccion.Text.Trim(),
                        txtCodigoPostal.Text.Trim(),
                        txtTelefono1.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtTelefono2.Text), " ", txtTelefono2.Text.Trim()),
                        txtEmail.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtProfesion.Text), " ", txtProfesion.Text.Trim()),
                        ddlTipoCliente.SelectedValue)
                    lblMensaje.Text = "✅ Cliente creado ID: " & nuevoId &
                                      " — Login: " & txtEmail.Text.Trim() &
                                      " / Pass: " & txtNumDoc.Text.Trim()
                End If
                lblMensaje.Visible = True
                lblError.Visible = False
                LimpiarFormulario()
                CargarClientes()
            Catch ex As Exception
                If ex.Message.Contains("20006") Then
                    lblError.Text = "❌ El email o documento ya está registrado."
                Else
                    lblError.Text = "Error: " & ex.Message
                End If
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub btnNuevo_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            lblMensaje.Visible = False
            lblError.Visible = False
        End Sub

        Protected Sub gvClientes_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Dim dt As DataTable = ClienteService.BuscarPorId(id)
                    If dt.Rows.Count > 0 Then
                        Dim row = dt.Rows(0)
                        hfId.Value = id.ToString()
                        ddlTipoDoc.SelectedValue = row("cli_tipodocumento").ToString()
                        txtNumDoc.Text = row("cli_numdocumento").ToString()
                        txtNIT.Text = row("cli_nit").ToString().Trim()
                        txtPrimerNombre.Text = row("cli_primer_nombre").ToString()
                        txtSegundoNombre.Text = row("cli_segundo_nombre").ToString().Trim()
                        txtPrimerApellido.Text = row("cli_primer_apellido").ToString()
                        txtSegundoApellido.Text = row("cli_segundo_apellido").ToString().Trim()
                        txtEmail.Text = row("cli_email").ToString()
                        txtProfesion.Text = row("cli_profesion").ToString().Trim()
                        txtTelefono1.Text = row("cli_primer_telefono").ToString()
                        txtTelefono2.Text = row("cli_segundo_telefono").ToString().Trim()
                        txtPais.Text = row("cli_pais").ToString()
                        txtDepartamento.Text = row("cli_departamento").ToString()
                        txtMunicipio.Text = row("cli_municipio").ToString()
                        txtZona.Text = row("cli_zona").ToString()
                        txtDireccion.Text = row("cli_direccion").ToString()
                        txtCodigoPostal.Text = row("cli_codigo_postal").ToString()
                        ddlTipoCliente.SelectedValue = row("cli_tipocliente").ToString()
                    End If
                    lblMensaje.Text = "✏️ Editando cliente ID: " & id
                    lblMensaje.Visible = True
                Catch ex As Exception
                    lblError.Text = "Error al cargar: " & ex.Message
                    lblError.Visible = True
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    ClienteService.Eliminar(id)
                    lblMensaje.Text = "🗑️ Cliente ID " & id & " eliminado."
                    lblMensaje.Visible = True
                    CargarClientes()
                Catch ex As Exception
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
            End If

            CargarClientes()
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = ""
            ddlTipoDoc.SelectedIndex = 0
            txtNumDoc.Text = ""
            txtNIT.Text = ""
            ddlTipoCliente.SelectedIndex = 0
            txtPrimerNombre.Text = ""
            txtSegundoNombre.Text = ""
            txtPrimerApellido.Text = ""
            txtSegundoApellido.Text = ""
            txtEmail.Text = ""
            txtProfesion.Text = ""
            txtTelefono1.Text = ""
            txtTelefono2.Text = ""
            txtPais.Text = ""
            txtDepartamento.Text = ""
            txtMunicipio.Text = ""
            txtZona.Text = ""
            txtDireccion.Text = ""
            txtCodigoPostal.Text = ""
        End Sub

    End Class
End Namespace