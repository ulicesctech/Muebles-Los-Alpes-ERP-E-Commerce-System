Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios.Admin

    Partial Public Class PermisosPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPermisos()
            End If
        End Sub

        Private Sub CargarPermisos()
            Try
                gvPermisos.DataSource = PermisoService.Listar()
                gvPermisos.DataBind()
                lblMensaje.Visible = False
                lblError.Visible = False
            Catch ex As Exception
                lblError.Text = "Error al cargar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Dim admin As Integer = If(chkAdmin.Checked, 1, 0)
            Dim rh As Integer = If(chkRH.Checked, 1, 0)
            Dim fac As Integer = If(chkFac.Checked, 1, 0)
            Dim cli As Integer = If(chkCli.Checked, 1, 0)
            Dim bod As Integer = If(chkBod.Checked, 1, 0)
            Dim promo As Integer = If(chkPromo.Checked, 1, 0)

            Try
                If hfId.Value <> "" Then
                    PermisoService.Actualizar(
                        Convert.ToInt32(hfId.Value),
                        admin, rh, fac, cli, bod, promo)
                    lblMensaje.Text = "✅ Permiso actualizado correctamente."
                Else
                    Dim nuevoId As Integer = PermisoService.Crear(admin, rh, fac, cli, bod, promo)
                    lblMensaje.Text = "✅ Permiso creado con ID: " & nuevoId
                End If
                lblMensaje.Visible = True
                lblError.Visible = False
                LimpiarFormulario()
                CargarPermisos()
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

        Protected Sub gvPermisos_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Dim dt As DataTable = PermisoService.Listar()
                    For Each row As DataRow In dt.Rows
                        If Convert.ToInt32(row("per_permisos")) = id Then
                            hfId.Value = id.ToString()
                            chkAdmin.Checked = row("per_admin").ToString() = "1"
                            chkRH.Checked = row("per_rh").ToString() = "1"
                            chkFac.Checked = row("per_fac").ToString() = "1"
                            chkCli.Checked = row("per_cli").ToString() = "1"
                            chkBod.Checked = row("per_bod").ToString() = "1"
                            chkPromo.Checked = row("per_promo").ToString() = "1"
                            Exit For
                        End If
                    Next
                    lblMensaje.Text = "✏️ Editando permiso ID: " & id
                    lblMensaje.Visible = True
                Catch ex As Exception
                    lblError.Text = "Error al cargar: " & ex.Message
                    lblError.Visible = True
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    PermisoService.Eliminar(id)
                    lblMensaje.Text = "🗑️ Permiso ID " & id & " eliminado."
                    lblMensaje.Visible = True
                    CargarPermisos()
                Catch ex As Exception
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
            End If

            CargarPermisos()
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = ""
            chkAdmin.Checked = False
            chkRH.Checked = False
            chkFac.Checked = False
            chkCli.Checked = False
            chkBod.Checked = False
            chkPromo.Checked = False
        End Sub

    End Class
End Namespace