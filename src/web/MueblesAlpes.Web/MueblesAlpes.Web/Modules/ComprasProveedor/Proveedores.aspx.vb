Imports System
Imports System.Data

Namespace Modules.ComprasProveedor
    Partial Public Class Proveedores
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                LimpiarFormulario()
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarGrilla()
            Try
                ' Se carga la grilla llamando al servicio
                gvProveedores.DataSource = ProveedorService.Listar()
                gvProveedores.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar la lista de proveedores: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            ' Validación básica de campos obligatorios
            If String.IsNullOrWhiteSpace(txtNit.Text) OrElse String.IsNullOrWhiteSpace(txtNombre.Text) Then
                MostrarError("El NIT y el Nombre son campos obligatorios.")
                Return
            End If

            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)

                If id = 0 Then
                    ' Crear nuevo registro
                    ProveedorService.Crear(txtNit.Text.Trim(), txtNombre.Text.Trim(), txtAvenida.Text.Trim(), txtZona.Text.Trim(), txtDireccion.Text.Trim(), txtTelefono.Text.Trim())
                    MostrarExito("Proveedor creado correctamente.")
                Else
                    ' Actualizar registro existente
                    ProveedorService.Actualizar(id, txtNit.Text.Trim(), txtNombre.Text.Trim(), txtAvenida.Text.Trim(), txtZona.Text.Trim(), txtDireccion.Text.Trim(), txtTelefono.Text.Trim())
                    MostrarExito("Proveedor actualizado correctamente.")
                End If

                LimpiarFormulario()
                CargarGrilla()
            Catch ex As Exception
                MostrarError("Error al guardar los datos: " & ex.Message)
            End Try
        End Sub

        Protected Sub gvProveedores_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            ' Evitar procesar si el argumento está vacío
            If e.CommandArgument Is Nothing OrElse String.IsNullOrEmpty(e.CommandArgument.ToString()) Then Return

            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Dim btn As LinkButton = DirectCast(e.CommandSource, LinkButton)
                    Dim row As GridViewRow = DirectCast(btn.NamingContainer, GridViewRow)

                    hfId.Value = id.ToString()
                    ' Server.HtmlDecode limpia caracteres especiales de las celdas de la grilla
                    txtNit.Text = Server.HtmlDecode(row.Cells(1).Text).Trim().Replace("&nbsp;", "")
                    txtNombre.Text = Server.HtmlDecode(row.Cells(2).Text).Trim().Replace("&nbsp;", "")
                    txtTelefono.Text = Server.HtmlDecode(row.Cells(3).Text).Trim().Replace("&nbsp;", "")
                    txtAvenida.Text = Server.HtmlDecode(row.Cells(4).Text).Trim().Replace("&nbsp;", "")
                    txtZona.Text = Server.HtmlDecode(row.Cells(5).Text).Trim().Replace("&nbsp;", "")
                    txtDireccion.Text = Server.HtmlDecode(row.Cells(6).Text).Trim().Replace("&nbsp;", "")

                    ' Bloquear NIT en edición por integridad de datos
                    txtNit.Enabled = False
                    lblTituloForm.Text = "Editando: " & txtNombre.Text
                    btnGuardar.Text = "💾 Actualizar"
                    pnlMsg.Visible = False
                Catch ex As Exception
                    MostrarError("Error al seleccionar el registro: " & ex.Message)
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    ' ============================================================
                    ' ELIMINACIÓN PROTEGIDA
                    ' ============================================================
                    ProveedorService.Eliminar(id)
                    MostrarExito("Proveedor eliminado correctamente.")
                    CargarGrilla()
                    LimpiarFormulario()
                Catch ex As Exception
                    ' Si Oracle devuelve un error de integridad (ej. ORA-02292 por registros hijos)
                    ' se captura aquí y se muestra el mensaje amigable.
                    If ex.Message.Contains("ORA-02292") Then
                        MostrarError("No se puede eliminar el proveedor porque tiene pedidos o registros asociados.")
                    Else
                        MostrarError("No se pudo eliminar el registro: " & ex.Message)
                    End If
                End Try
            End If
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            ' Aquí podrías implementar un filtro específico si el servicio lo soporta
            CargarGrilla()
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            pnlMsg.Visible = False
            CargarGrilla()
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = "0"
            txtNit.Text = ""
            txtNombre.Text = ""
            txtTelefono.Text = ""
            txtAvenida.Text = ""
            txtZona.Text = ""
            txtDireccion.Text = ""
            txtNit.Enabled = True
            btnGuardar.Text = "💾 Guardar"
            lblTituloForm.Text = "Nuevo Proveedor"
            pnlMsg.Visible = False
        End Sub

        ' --- Métodos de Mensajería UI ---

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