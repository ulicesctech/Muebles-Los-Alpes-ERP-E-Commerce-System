Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios.Admin

    Partial Public Class GrupoUsuarioPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPermisos()
                CargarGrupos()
            End If
        End Sub

        Private Sub CargarPermisos()
            Try
                Dim dt As DataTable = PermisoService.Listar()
                ddlPermisos.DataSource = dt
                ddlPermisos.DataTextField = "per_permisos"
                ddlPermisos.DataValueField = "per_permisos"
                ddlPermisos.DataBind()
                ddlPermisos.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
            Catch ex As Exception
                lblError.Text = "Error al cargar permisos: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Private Sub CargarGrupos()
            Try
                gvGrupos.DataSource = GrupoUsuarioService.Listar()
                gvGrupos.DataBind()
                lblMensaje.Visible = False
                lblError.Visible = False
            Catch ex As Exception
                lblError.Text = "Error al cargar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtDescripcion.Text) Then
                lblError.Text = "⚠️ La descripción es obligatoria."
                lblError.Visible = True
                Return
            End If
            If ddlPermisos.SelectedValue = "0" Then
                lblError.Text = "⚠️ Debe seleccionar un permiso."
                lblError.Visible = True
                Return
            End If

            Try
                If hfId.Value <> "" Then
                    GrupoUsuarioService.Actualizar(
                        Convert.ToInt32(hfId.Value),
                        txtDescripcion.Text.Trim(),
                        Convert.ToInt32(ddlPermisos.SelectedValue))
                    lblMensaje.Text = "✅ Grupo actualizado correctamente."
                Else
                    Dim nuevoId As Integer = GrupoUsuarioService.Crear(
                        txtDescripcion.Text.Trim(),
                        Convert.ToInt32(ddlPermisos.SelectedValue))
                    lblMensaje.Text = "✅ Grupo creado con ID: " & nuevoId
                End If
                lblMensaje.Visible = True
                lblError.Visible = False
                LimpiarFormulario()
                CargarGrupos()
            Catch ex As Exception
                lblError.Text = "Error: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub btnNuevo_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            lblMensaje.Visible = False
            lblError.Visible = False
        End Sub

        Protected Sub gvGrupos_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Dim dt As DataTable = GrupoUsuarioService.Buscar(id)
                    If dt.Rows.Count > 0 Then
                        Dim row = dt.Rows(0)
                        hfId.Value = id.ToString()
                        txtDescripcion.Text = row("grupus_descripcion").ToString()
                        ddlPermisos.SelectedValue = row("per_permisos").ToString()
                    End If
                    lblMensaje.Text = "✏️ Editando grupo ID: " & id
                    lblMensaje.Visible = True
                Catch ex As Exception
                    lblError.Text = "Error al cargar: " & ex.Message
                    lblError.Visible = True
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    GrupoUsuarioService.Eliminar(id)
                    lblMensaje.Text = "🗑️ Grupo ID " & id & " eliminado."
                    lblMensaje.Visible = True
                    CargarGrupos()
                Catch ex As Exception
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
            End If

            CargarGrupos()
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = ""
            txtDescripcion.Text = ""
            If ddlPermisos.Items.Count > 0 Then ddlPermisos.SelectedIndex = 0
        End Sub

    End Class
End Namespace