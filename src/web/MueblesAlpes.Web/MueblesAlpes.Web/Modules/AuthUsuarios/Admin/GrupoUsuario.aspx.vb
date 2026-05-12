Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios.Admin

    Partial Public Class GrupoUsuarioPage
        Inherits BasePage

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPermisos()
                CargarGrupos()
                CargarTablaPermisos()
            End If
        End Sub

        Private Sub CargarTablaPermisos()
            Try
                gvPermisos.DataSource = PermisoService.Listar()
                gvPermisos.DataBind()
            Catch ex As Exception
                lblError.Text = "Error al cargar permisos: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Private Sub CargarPermisos()
            Try
                Dim dt As DataTable = PermisoService.Listar()
                ddlPermisos.DataSource = dt
                ddlPermisos.DataTextField = "per_permisos"
                ddlPermisos.DataValueField = "per_permisos"
                ddlPermisos.DataBind()
                ddlPermisos.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione permiso --", "0"))
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
                lblError.Text = "Error al cargar grupos: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '============================================================
        ' PERMISOS
        '============================================================
        Protected Sub btnGuardarPermiso_Click(sender As Object, e As EventArgs)
            Dim admin As Integer = If(chkAdmin.Checked, 1, 0)
            Dim rh As Integer = If(chkRH.Checked, 1, 0)
            Dim fac As Integer = If(chkFac.Checked, 1, 0)
            Dim cli As Integer = If(chkCli.Checked, 1, 0)
            Dim bod As Integer = If(chkBod.Checked, 1, 0)
            Dim promo As Integer = If(chkPromo.Checked, 1, 0)

            Try
                If hfPermisoId.Value <> "" Then
                    PermisoService.Actualizar(
                        Convert.ToInt32(hfPermisoId.Value),
                        admin, rh, fac, cli, bod, promo)
                    lblMensaje.Text = "✅ Permiso actualizado correctamente."
                    hfPermisoFormOpen.Value = "false"
                    hfPermisoEditing.Value = "false"
                Else
                    Dim nuevoId As Integer = PermisoService.Crear(admin, rh, fac, cli, bod, promo)
                    lblMensaje.Text = "✅ Permiso creado con ID: " & nuevoId &
                                      " — Ahora asígnalo a un Grupo abajo ↓"
                    ' Auto-seleccionar el permiso recién creado en el DDL de grupos
                    hfPermisoSeleccionado.Value = nuevoId.ToString()
                    hfPermisoFormOpen.Value = "false"
                    hfPermisoEditing.Value = "false"
                    hfGrupoFormOpen.Value = "true"
                End If
                lblMensaje.Visible = True
                lblError.Visible = False
                LimpiarFormularioPermiso()
                CargarTablaPermisos()
                CargarPermisos()
                ' Re-seleccionar si se acaba de crear
                If hfPermisoSeleccionado.Value <> "" Then
                    Dim selVal As String = hfPermisoSeleccionado.Value
                    Dim item = ddlPermisos.Items.FindByValue(selVal)
                    If item IsNot Nothing Then
                        ddlPermisos.ClearSelection()
                        item.Selected = True
                    End If
                End If
            Catch ex As Exception
                lblError.Text = "Error: " & ex.Message
                lblError.Visible = True
                hfPermisoFormOpen.Value = "true"
                hfPermisoEditing.Value = If(hfPermisoId.Value <> "", "true", "false")
            End Try
        End Sub

        Protected Sub btnNuevoPermiso_Click(sender As Object, e As EventArgs)
            LimpiarFormularioPermiso()
            hfPermisoFormOpen.Value = "false"
            hfPermisoEditing.Value = "false"
            lblMensaje.Visible = False
            lblError.Visible = False
        End Sub

        Protected Sub gvPermisos_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "EditarPermiso" Then
                Try
                    Dim dt As DataTable = PermisoService.Listar()
                    For Each row As DataRow In dt.Rows
                        If Convert.ToInt32(row("per_permisos")) = id Then
                            hfPermisoId.Value = id.ToString()
                            chkAdmin.Checked = row("per_admin").ToString() = "1"
                            chkRH.Checked = row("per_rh").ToString() = "1"
                            chkFac.Checked = row("per_fac").ToString() = "1"
                            chkCli.Checked = row("per_cli").ToString() = "1"
                            chkBod.Checked = row("per_bod").ToString() = "1"
                            chkPromo.Checked = row("per_promo").ToString() = "1"
                            Exit For
                        End If
                    Next
                    hfPermisoFormOpen.Value = "true"
                    hfPermisoEditing.Value = "true"
                    lblMensaje.Visible = False
                    lblError.Visible = False
                Catch ex As Exception
                    lblError.Text = "Error al cargar: " & ex.Message
                    lblError.Visible = True
                End Try

            ElseIf e.CommandName = "UsarPermiso" Then
                ' Seleccionar permiso y abrir formulario de grupo
                hfPermisoSeleccionado.Value = id.ToString()
                hfGrupoFormOpen.Value = "true"
                CargarPermisos()
                Dim item = ddlPermisos.Items.FindByValue(id.ToString())
                If item IsNot Nothing Then
                    ddlPermisos.ClearSelection()
                    item.Selected = True
                End If
                lblMensaje.Text = "✅ Permiso ID " & id & " seleccionado — completa el nombre del grupo abajo ↓"
                lblMensaje.Visible = True

            ElseIf e.CommandName = "EliminarPermiso" Then
                Try
                    PermisoService.Eliminar(id)
                    lblMensaje.Text = "🗑️ Permiso ID " & id & " eliminado."
                    lblMensaje.Visible = True
                    lblError.Visible = False
                Catch ex As Exception
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
            End If

            CargarTablaPermisos()
            CargarGrupos()
        End Sub

        Private Sub LimpiarFormularioPermiso()
            hfPermisoId.Value = ""
            chkAdmin.Checked = False
            chkRH.Checked = False
            chkFac.Checked = False
            chkCli.Checked = False
            chkBod.Checked = False
            chkPromo.Checked = False
        End Sub

        '============================================================
        ' GRUPOS
        '============================================================
        Protected Sub btnGuardarGrupo_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtDescripcion.Text) Then
                lblError.Text = "⚠️ La descripción del grupo es obligatoria."
                lblError.Visible = True
                hfGrupoFormOpen.Value = "true"
                hfGrupoEditing.Value = If(hfGrupoId.Value <> "", "true", "false")
                Return
            End If
            If ddlPermisos.SelectedValue = "0" Then
                lblError.Text = "⚠️ Debe seleccionar un permiso."
                lblError.Visible = True
                hfGrupoFormOpen.Value = "true"
                hfGrupoEditing.Value = If(hfGrupoId.Value <> "", "true", "false")
                Return
            End If

            Try
                If hfGrupoId.Value <> "" Then
                    GrupoUsuarioService.Actualizar(
                        Convert.ToInt32(hfGrupoId.Value),
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
                hfGrupoFormOpen.Value = "false"
                hfGrupoEditing.Value = "false"
                hfPermisoSeleccionado.Value = ""
                LimpiarFormularioGrupo()
                CargarGrupos()
            Catch ex As Exception
                lblError.Text = "Error: " & ex.Message
                lblError.Visible = True
                hfGrupoFormOpen.Value = "true"
                hfGrupoEditing.Value = If(hfGrupoId.Value <> "", "true", "false")
            End Try
        End Sub

        Protected Sub btnNuevoGrupo_Click(sender As Object, e As EventArgs)
            LimpiarFormularioGrupo()
            hfGrupoFormOpen.Value = "false"
            hfGrupoEditing.Value = "false"
            hfPermisoSeleccionado.Value = ""
            lblMensaje.Visible = False
            lblError.Visible = False
        End Sub

        Protected Sub gvGrupos_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "EditarGrupo" Then
                Try
                    Dim dt As DataTable = GrupoUsuarioService.Buscar(id)
                    If dt.Rows.Count > 0 Then
                        Dim row = dt.Rows(0)
                        hfGrupoId.Value = id.ToString()
                        txtDescripcion.Text = row("grupus_descripcion").ToString()
                        CargarPermisos()
                        Dim item = ddlPermisos.Items.FindByValue(row("per_permisos").ToString())
                        If item IsNot Nothing Then
                            ddlPermisos.ClearSelection()
                            item.Selected = True
                        End If
                        hfPermisoSeleccionado.Value = row("per_permisos").ToString()
                    End If
                    hfGrupoFormOpen.Value = "true"
                    hfGrupoEditing.Value = "true"
                    lblMensaje.Visible = False
                    lblError.Visible = False
                Catch ex As Exception
                    lblError.Text = "Error al cargar: " & ex.Message
                    lblError.Visible = True
                End Try

            ElseIf e.CommandName = "EliminarGrupo" Then
                Try
                    GrupoUsuarioService.Eliminar(id)
                    lblMensaje.Text = "🗑️ Grupo ID " & id & " eliminado."
                    lblMensaje.Visible = True
                    lblError.Visible = False
                Catch ex As Exception
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
            End If

            CargarTablaPermisos()
            CargarGrupos()
        End Sub

        Private Sub LimpiarFormularioGrupo()
            hfGrupoId.Value = ""
            txtDescripcion.Text = ""
            If ddlPermisos.Items.Count > 0 Then ddlPermisos.SelectedIndex = 0
        End Sub

    End Class
End Namespace