Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class PuestosPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPuestos()
            End If
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

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtNombre.Text) OrElse
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
                        txtNombre.Text.Trim(),
                        salario,
                        txtDescripcion.Text.Trim())
                    lblMensaje.Text = "✅ Puesto actualizado correctamente."
                Else
                    Dim nuevoId As Integer = PuestoService.Crear(
                        txtNombre.Text.Trim(),
                        salario,
                        txtDescripcion.Text.Trim())
                    lblMensaje.Text = "✅ Puesto creado con ID: " & nuevoId
                End If
                lblMensaje.Visible = True
                lblError.Visible = False
                LimpiarFormulario()
                CargarPuestos()
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

        Protected Sub gvPuestos_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Dim dt As DataTable = PuestoService.Buscar(id)
                    If dt.Rows.Count > 0 Then
                        Dim row = dt.Rows(0)
                        hfId.Value = id.ToString()
                        txtNombre.Text = row("pue_nombre").ToString()
                        txtSalario.Text = row("pue_salario").ToString()
                        txtDescripcion.Text = row("pue_descripcion").ToString()
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
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
            End If

            CargarPuestos()
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = ""
            txtNombre.Text = ""
            txtSalario.Text = ""
            txtDescripcion.Text = ""
        End Sub

    End Class
End Namespace