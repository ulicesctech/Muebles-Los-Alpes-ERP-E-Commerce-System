Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class PuestosPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarGrupos()
                CargarPuestos()
            End If
        End Sub

        Private Sub CargarGrupos()
            Try
                Dim dt As DataTable = GrupoUsuarioService.Listar()
                ddlGrupo.DataSource = dt
                ddlGrupo.DataTextField = "grupus_descripcion"
                ddlGrupo.DataValueField = "grupus_descripcion"
                ddlGrupo.DataBind()
                ddlGrupo.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione rol --", ""))
            Catch ex As Exception
                lblError.Text = "Error al cargar grupos: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Private Sub CargarPuestos()
            Try
                gvPuestos.DataSource = PuestoService.Listar()
                gvPuestos.DataBind()
                lblMensaje.Visible = False
                lblError.Visible = False
            Catch ex As Exception
                lblError.Text = "Error al cargar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub ddlGrupo_SelectedIndexChanged(sender As Object, e As EventArgs)
            ' Autocompletar descripción con el nombre del rol
            If ddlGrupo.SelectedValue <> "" Then
                txtDescripcion.Text = ddlGrupo.SelectedItem.Text
            End If
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If ddlGrupo.SelectedValue = "" OrElse
               String.IsNullOrWhiteSpace(txtSalario.Text) OrElse
               String.IsNullOrWhiteSpace(txtDescripcion.Text) Then
                lblError.Text = "⚠️ Todos los campos son obligatorios."
                lblError.Visible = True
                Return
            End If

            Dim salario As Decimal
            If Not Decimal.TryParse(txtSalario.Text.Trim(), salario) OrElse salario <= 0 Then
                lblError.Text = "⚠️ El salario debe ser un número mayor a 0."
                lblError.Visible = True
                Return
            End If

            Try
                If hfId.Value <> "" Then
                    PuestoService.Actualizar(
                        Convert.ToInt32(hfId.Value),
                        ddlGrupo.SelectedValue,
                        salario,
                        txtDescripcion.Text.Trim())
                    lblMensaje.Text = "✅ Puesto actualizado correctamente."
                Else
                    Dim nuevoId As Integer = PuestoService.Crear(
                        ddlGrupo.SelectedValue,
                        salario,
                        txtDescripcion.Text.Trim())
                    lblMensaje.Text = "✅ Puesto creado con ID: " & nuevoId
                End If
                lblMensaje.Visible = True
                lblError.Visible = False
                LimpiarFormulario()
                CargarPuestos()
            Catch ex As Exception
                If ex.Message.Contains("20103") Then
                    lblError.Text = "❌ No se puede eliminar, el puesto está en uso por ascensos."
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

        Protected Sub gvPuestos_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Dim dt As DataTable = PuestoService.Buscar(id)
                    If dt.Rows.Count > 0 Then
                        Dim row = dt.Rows(0)
                        hfId.Value = id.ToString()
                        txtSalario.Text = row("pue_salario").ToString()
                        txtDescripcion.Text = row("pue_descripcion").ToString()
                        ' Seleccionar el grupo que corresponde al nombre del puesto
                        Dim item = ddlGrupo.Items.FindByText(row("pue_nombre").ToString())
                        If item IsNot Nothing Then
                            ddlGrupo.SelectedValue = item.Value
                        End If
                    End If
                    lblMensaje.Text = "✏️ Editando puesto ID: " & id
                    lblMensaje.Visible = True
                Catch ex As Exception
                    lblError.Text = "Error al cargar: " & ex.Message
                    lblError.Visible = True
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    PuestoService.Eliminar(id)
                    lblMensaje.Text = "🗑️ Puesto ID " & id & " eliminado."
                    lblMensaje.Visible = True
                    CargarPuestos()
                Catch ex As Exception
                    If ex.Message.Contains("20103") Then
                        lblError.Text = "❌ No se puede eliminar, el puesto está en uso por ascensos."
                    Else
                        lblError.Text = "Error: " & ex.Message
                    End If
                    lblError.Visible = True
                End Try
            End If

            CargarPuestos()
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = ""
            txtSalario.Text = ""
            txtDescripcion.Text = ""
            If ddlGrupo.Items.Count > 0 Then ddlGrupo.SelectedIndex = 0
        End Sub

    End Class
End Namespace