Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class EmpleadosPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarRoles()
                CargarEmpleados()
            End If
        End Sub

        Private Sub CargarRoles()
            Try
                Dim dt As DataTable = GrupoUsuarioService.Listar()
                ddlRol.DataSource = dt
                ddlRol.DataTextField = "grupus_descripcion"
                ddlRol.DataValueField = "grupus_grupo_usuario"
                ddlRol.DataBind()
                ddlRol.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione rol --", "0"))
            Catch ex As Exception
                lblError.Text = "Error al cargar roles: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Private Sub CargarEmpleados()
            Try
                Dim dt As DataTable = EmpleadoService.Listar()
                gvEmpleados.DataSource = dt
                gvEmpleados.DataBind()
                lblResultado.Text = "📋 Total de empleados: " & dt.Rows.Count
                lblResultado.Visible = True
                lblMensaje.Visible = False
                lblError.Visible = False
            Catch ex As Exception
                lblError.Text = "Error al cargar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Private Function ValidarPassword(pass As String) As String
            If String.IsNullOrWhiteSpace(pass) Then Return "⚠️ La contraseña es obligatoria."
            If pass.Length < 8 Then Return "⚠️ La contraseña debe tener mínimo 8 caracteres."
            If Not Regex.IsMatch(pass, "[A-Z]") Then Return "⚠️ Debe tener al menos una mayúscula."
            If Not Regex.IsMatch(pass, "[a-z]") Then Return "⚠️ Debe tener al menos una minúscula."
            If Not Regex.IsMatch(pass, "[0-9]") Then Return "⚠️ Debe tener al menos un número."
            Return ""
        End Function

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtBuscarDPI.Text) Then
                lblError.Text = "⚠️ Ingrese un DPI para buscar."
                lblError.Visible = True
                Return
            End If
            Try
                Dim dt As DataTable = EmpleadoService.Listar()
                Dim filtered = dt.Select("em_DPI LIKE '%" & txtBuscarDPI.Text.Trim() & "%'")
                Dim result As DataTable = dt.Clone()
                For Each row In filtered
                    result.ImportRow(row)
                Next
                gvEmpleados.DataSource = result
                gvEmpleados.DataBind()
                If result.Rows.Count = 0 Then
                    lblResultado.Text = "🔍 No se encontró ningún empleado con ese DPI."
                    lblResultado.Visible = True
                    lblError.Visible = False
                Else
                    lblResultado.Text = "🔍 Se encontró " & result.Rows.Count & " resultado(s)."
                    lblResultado.Visible = True
                    lblError.Visible = False
                End If
            Catch ex As Exception
                lblError.Text = "Error al buscar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub btnVerTodos_Click(sender As Object, e As EventArgs)
            txtBuscarDPI.Text = ""
            lblMensaje.Visible = False
            lblError.Visible = False
            CargarEmpleados()
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtDPI.Text) OrElse
               String.IsNullOrWhiteSpace(txtPrimerNombre.Text) OrElse
               String.IsNullOrWhiteSpace(txtPrimerApellido.Text) OrElse
               String.IsNullOrWhiteSpace(txtTelefono1.Text) OrElse
               String.IsNullOrWhiteSpace(txtDireccion.Text) OrElse
               String.IsNullOrWhiteSpace(txtAvenida.Text) OrElse
               String.IsNullOrWhiteSpace(txtCodigoPostal.Text) Then
                lblError.Text = "⚠️ Los campos marcados con * son obligatorios."
                lblError.Visible = True
                hfFormOpen.Value = "true"
                hfFormEditing.Value = If(hfId.Value <> "", "true", "false")
                Return
            End If

            If ddlRol.SelectedValue = "0" Then
                lblError.Text = "⚠️ Debe seleccionar un rol."
                lblError.Visible = True
                hfFormOpen.Value = "true"
                hfFormEditing.Value = If(hfId.Value <> "", "true", "false")
                Return
            End If

            If txtDPI.Text.Trim().Length <> 13 OrElse
               Not txtDPI.Text.Trim().All(Function(c) Char.IsDigit(c)) Then
                lblError.Text = "⚠️ DPI debe tener exactamente 13 dígitos."
                lblError.Visible = True
                hfFormOpen.Value = "true"
                hfFormEditing.Value = If(hfId.Value <> "", "true", "false")
                Return
            End If

            If txtTelefono1.Text.Trim().Length <> 8 OrElse
               Not txtTelefono1.Text.Trim().All(Function(c) Char.IsDigit(c)) Then
                lblError.Text = "⚠️ Teléfono debe tener exactamente 8 dígitos."
                lblError.Visible = True
                hfFormOpen.Value = "true"
                hfFormEditing.Value = If(hfId.Value <> "", "true", "false")
                Return
            End If

            If hfId.Value = "" Then
                Dim errPass As String = ValidarPassword(txtPassword.Text)
                If errPass <> "" Then
                    lblError.Text = errPass
                    lblError.Visible = True
                    hfFormOpen.Value = "true"
                    Return
                End If
            End If

            Try
                If hfId.Value <> "" Then
                    EmpleadoService.Actualizar(
                        Convert.ToInt32(hfId.Value),
                        txtDPI.Text.Trim(),
                        txtPrimerNombre.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtSegundoNombre.Text), " ", txtSegundoNombre.Text.Trim()),
                        txtPrimerApellido.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtSegundoApellido.Text), " ", txtSegundoApellido.Text.Trim()),
                        txtDireccion.Text.Trim(),
                        txtAvenida.Text.Trim(),
                        txtCodigoPostal.Text.Trim(),
                        txtTelefono1.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtTelefono2.Text), " ", txtTelefono2.Text.Trim()),
                        Convert.ToInt32(ddlRol.SelectedValue))
                    lblMensaje.Text = "✅ Datos del empleado modificados con éxito."
                Else
                    Dim nuevoId As Integer = EmpleadoService.Crear(
                        txtDPI.Text.Trim(),
                        txtPrimerNombre.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtSegundoNombre.Text), " ", txtSegundoNombre.Text.Trim()),
                        txtPrimerApellido.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtSegundoApellido.Text), " ", txtSegundoApellido.Text.Trim()),
                        txtDireccion.Text.Trim(),
                        txtAvenida.Text.Trim(),
                        txtCodigoPostal.Text.Trim(),
                        txtTelefono1.Text.Trim(),
                        If(String.IsNullOrWhiteSpace(txtTelefono2.Text), " ", txtTelefono2.Text.Trim()),
                        Convert.ToInt32(ddlRol.SelectedValue),
                        txtPassword.Text.Trim())
                    lblMensaje.Text = "✅ Empleado creado ID: " & nuevoId &
                                      " — Usuario: " & txtDPI.Text.Trim()
                End If
                lblMensaje.Visible = True
                lblError.Visible = False
                hfFormOpen.Value = "false"
                hfFormEditing.Value = "false"
                LimpiarFormulario()
                CargarEmpleados()
            Catch ex As Exception
                If ex.Message.Contains("20006") Then
                    lblError.Text = "❌ El DPI ya está registrado."
                Else
                    lblError.Text = "Error: " & ex.Message
                End If
                lblError.Visible = True
                hfFormOpen.Value = "true"
                hfFormEditing.Value = If(hfId.Value <> "", "true", "false")
            End Try
        End Sub

        Protected Sub btnNuevo_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            hfFormOpen.Value = "false"
            hfFormEditing.Value = "false"
            lblMensaje.Visible = False
            lblError.Visible = False
            CargarEmpleados()
        End Sub

        Protected Sub gvEmpleados_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Dim dt As DataTable = EmpleadoService.Buscar(id)
                    If dt.Rows.Count > 0 Then
                        Dim row = dt.Rows(0)
                        hfId.Value = id.ToString()
                        txtDPI.Text = row("em_DPI").ToString()
                        txtPrimerNombre.Text = row("em_primer_nombre").ToString()
                        txtSegundoNombre.Text = row("em_segundo_nombre").ToString().Trim()
                        txtPrimerApellido.Text = row("em_primer_apellido").ToString()
                        txtSegundoApellido.Text = row("em_segundo_apellido").ToString().Trim()
                        txtDireccion.Text = row("em_direccion").ToString()
                        txtAvenida.Text = row("em_avenida").ToString()
                        txtCodigoPostal.Text = row("em_codigo_postal").ToString()
                        txtTelefono1.Text = row("em_primer_telefono").ToString()
                        txtTelefono2.Text = row("em_segundo_telefono").ToString().Trim()
                        ddlRol.SelectedValue = row("rolus_rol_usuario").ToString()
                        txtPassword.Text = ""
                    End If
                    hfFormOpen.Value = "true"
                    hfFormEditing.Value = "true"
                    lblMensaje.Visible = False
                    lblError.Visible = False
                Catch ex As Exception
                    lblError.Text = "Error al cargar: " & ex.Message
                    lblError.Visible = True
                End Try
                CargarEmpleados()

            ElseIf e.CommandName = "Eliminar" Then
                Dim miId As Integer = Convert.ToInt32(Session("UsuarioId"))
                If id = miId Then
                    lblError.Text = "⚠️ No puedes eliminar tu propio usuario estando activo."
                    lblError.Visible = True
                    CargarEmpleados()
                    Return
                End If
                Try
                    EmpleadoService.Eliminar(id)
                    lblMensaje.Text = "🗑️ Empleado ID " & id & " eliminado correctamente."
                    lblMensaje.Visible = True
                    lblError.Visible = False
                Catch ex As Exception
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
                CargarEmpleados()
            End If
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = ""
            txtDPI.Text = ""
            txtPrimerNombre.Text = ""
            txtSegundoNombre.Text = ""
            txtPrimerApellido.Text = ""
            txtSegundoApellido.Text = ""
            txtPassword.Text = ""
            txtDireccion.Text = ""
            txtAvenida.Text = ""
            txtCodigoPostal.Text = ""
            txtTelefono1.Text = ""
            txtTelefono2.Text = ""
            If ddlRol.Items.Count > 0 Then ddlRol.SelectedIndex = 0
        End Sub

    End Class
End Namespace