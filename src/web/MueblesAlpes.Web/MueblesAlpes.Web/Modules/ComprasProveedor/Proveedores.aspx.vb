Imports System
Imports System.Data

Namespace Modules.ComprasProveedor
    Partial Public Class Proveedores
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then CargarGrilla()
        End Sub

        Private Sub CargarGrilla()
            Try
                ' Si el campo de búsqueda tiene texto, usamos Buscar, si no, Listar
                If String.IsNullOrEmpty(txtBuscar.Text.Trim()) Then
                    gvProveedores.DataSource = ProveedorService.Listar()
                Else
                    gvProveedores.DataSource = ProveedorService.Buscar(txtBuscar.Text.Trim())
                End If
                gvProveedores.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar datos: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                If id = 0 Then
                    ProveedorService.Crear(txtNit.Text, txtNombre.Text, txtAvenida.Text, txtZona.Text, txtDireccion.Text, txtTelefono.Text)
                    MostrarExito("Proveedor creado correctamente.")
                Else
                    ProveedorService.Actualizar(id, txtNit.Text, txtNombre.Text, txtAvenida.Text, txtZona.Text, txtDireccion.Text, txtTelefono.Text)
                    MostrarExito("Proveedor actualizado correctamente.")
                End If
                LimpiarFormulario()
                CargarGrilla()
            Catch ex As Exception
                ' Aquí caerá el mensaje de "No se puede actualizar..." si hay error de integridad
                MostrarError(ex.Message)
            End Try
        End Sub

        Protected Sub gvProveedores_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Try
                Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)

                If e.CommandName = "Editar" Then
                    Dim btn As LinkButton = DirectCast(e.CommandSource, LinkButton)
                    Dim row As GridViewRow = DirectCast(btn.NamingContainer, GridViewRow)

                    hfId.Value = id.ToString()
                    txtNit.Text = Server.HtmlDecode(row.Cells(1).Text).Trim().Replace("&nbsp;", "")
                    txtNombre.Text = Server.HtmlDecode(row.Cells(2).Text).Trim().Replace("&nbsp;", "")
                    txtTelefono.Text = Server.HtmlDecode(row.Cells(3).Text).Trim().Replace("&nbsp;", "")
                    txtAvenida.Text = Server.HtmlDecode(row.Cells(4).Text).Trim().Replace("&nbsp;", "")
                    txtZona.Text = Server.HtmlDecode(row.Cells(5).Text).Trim().Replace("&nbsp;", "")
                    txtDireccion.Text = Server.HtmlDecode(row.Cells(6).Text).Trim().Replace("&nbsp;", "")

                    txtNit.Enabled = False
                    lblTituloForm.Text = "Editando: " & txtNombre.Text
                    btnGuardar.Text = "💾 Actualizar"
                    pnlMsg.Visible = False ' Limpiar mensajes previos al editar

                ElseIf e.CommandName = "Eliminar" Then
                    ' --- CAMBIO CLAVE AQUÍ ---
                    ProveedorService.Eliminar(id)
                    MostrarExito("Proveedor eliminado correctamente.")
                    CargarGrilla()
                End If

            Catch ex As Exception
                ' Aquí se captura el error ORA-02292 que lanzamos desde ProveedorService
                MostrarError(ex.Message)
            End Try
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            CargarGrilla()
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            CargarGrilla()
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = "0"
            txtNit.Text = "" : txtNombre.Text = "" : txtTelefono.Text = ""
            txtAvenida.Text = "" : txtZona.Text = "" : txtDireccion.Text = ""
            txtNit.Enabled = True
            btnGuardar.Text = "💾 Guardar"
            lblTituloForm.Text = "Nuevo Proveedor"
            pnlMsg.Visible = False
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = "⚠️ " & msg
            pnlMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = "✅ " & msg
            pnlMsg.CssClass = "alert-ok"
            pnlMsg.Visible = True
        End Sub
    End Class
End Namespace