' ============================================================
' RUTA: Modules/ComprasProveedor/Proveedores.aspx.vb
' ============================================================
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
                gvProveedores.DataSource = ProveedorService.Listar()
                gvProveedores.DataBind()
            Catch ex As Exception
                MostrarError("No logramos cargar la lista de proveedores. Por favor, intenta recargar la página.")
            End Try
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            ' Validación amigable
            If Not ValidarCampos() Then Return

            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)

                If id = 0 Then
                    ProveedorService.Crear(txtNit.Text.Trim(), txtNombre.Text.Trim(), txtAvenida.Text.Trim(), txtZona.Text.Trim(), txtDireccion.Text.Trim(), txtTelefono.Text.Trim())
                    MostrarExito("¡Excelente! El nuevo proveedor <strong>" & txtNombre.Text.Trim() & "</strong> ha sido registrado correctamente.")
                Else
                    ProveedorService.Actualizar(id, txtNit.Text.Trim(), txtNombre.Text.Trim(), txtAvenida.Text.Trim(), txtZona.Text.Trim(), txtDireccion.Text.Trim(), txtTelefono.Text.Trim())
                    MostrarExito("Los cambios en la información de <strong>" & txtNombre.Text.Trim() & "</strong> se han guardado con éxito.")
                End If

                LimpiarFormulario()
                CargarGrilla()
            Catch ex As Exception
                ' Manejo de NIT duplicado
                If ex.Message.Contains("ORA-00001") Then
                    MostrarError("No se pudo guardar: Ya existe un proveedor registrado con el NIT <strong>" & txtNit.Text & "</strong>.")
                Else
                    MostrarError("Tuvimos un inconveniente al intentar guardar los datos. Error: " & ex.Message)
                End If
            End Try
        End Sub

        Protected Sub gvProveedores_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandArgument Is Nothing OrElse String.IsNullOrEmpty(e.CommandArgument.ToString()) Then Return

            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    ' Recuperamos la fila para obtener los datos actuales
                    Dim btn As LinkButton = DirectCast(e.CommandSource, LinkButton)
                    Dim row As GridViewRow = DirectCast(btn.NamingContainer, GridViewRow)

                    hfId.Value = id.ToString()
                    txtNit.Text = Server.HtmlDecode(row.Cells(1).Text).Trim().Replace("&nbsp;", "")
                    txtNombre.Text = Server.HtmlDecode(row.Cells(2).Text).Trim().Replace("&nbsp;", "")
                    txtTelefono.Text = Server.HtmlDecode(row.Cells(3).Text).Trim().Replace("&nbsp;", "")
                    txtAvenida.Text = Server.HtmlDecode(row.Cells(4).Text).Trim().Replace("&nbsp;", "")
                    txtZona.Text = Server.HtmlDecode(row.Cells(5).Text).Trim().Replace("&nbsp;", "")
                    txtDireccion.Text = Server.HtmlDecode(row.Cells(6).Text).Trim().Replace("&nbsp;", "")

                    ' Bloqueamos el NIT en edición para evitar inconsistencias
                    txtNit.Enabled = False
                    lblTituloForm.Text = "📝 Editando: " & txtNombre.Text
                    btnGuardar.Text = "💾 Actualizar Información"
                    pnlMsg.Visible = False

                    ' Un pequeño feedback visual para que el usuario sepa que subió al formulario
                    MostrarExito("Datos cargados. Puedes realizar los cambios necesarios arriba.")
                Catch
                    MostrarError("No pudimos recuperar la información del proveedor para editarla.")
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    ProveedorService.Eliminar(id)
                    LimpiarFormulario()
                    CargarGrilla()
                    MostrarExito("¡Hecho! El proveedor ha sido eliminado del sistema de forma segura.")
                Catch ex As Exception
                    If ex.Message.Contains("ORA-02292") Then
                        MostrarError("No se puede eliminar: Este proveedor ya tiene registros vinculados (órdenes, facturas o reclamos).")
                    Else
                        MostrarError("Hubo un inconveniente al intentar eliminar el registro.")
                    End If
                End Try
            End If
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            ' Aquí podrías llamar a un método de búsqueda si el Service lo permite
            CargarGrilla()
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            pnlMsg.Visible = False
            CargarGrilla()
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            pnlMsg.Visible = False
        End Sub

        ' --- Métodos Auxiliares y de Mensajería ---

        Private Function ValidarCampos() As Boolean
            If String.IsNullOrWhiteSpace(txtNit.Text) Then
                MostrarError("Por favor, ingresa el NIT del proveedor. Es un dato obligatorio.") : Return False
            End If
            If String.IsNullOrWhiteSpace(txtNombre.Text) Then
                MostrarError("Necesitamos el nombre comercial o razón social del proveedor.") : Return False
            End If
            If txtTelefono.Text.Length > 0 AndAlso Not IsNumeric(txtTelefono.Text) Then
                MostrarError("El número de teléfono debe contener solo dígitos.") : Return False
            End If
            Return True
        End Function

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
            lblTituloForm.Text = "➕ Nuevo Proveedor"
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = "<span><strong>Lo sentimos:</strong> " & msg & "</span>"
            pnlMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = "<span><strong>¡Hecho!</strong> " & msg & "</span>"
            pnlMsg.CssClass = "alert-ok"
            pnlMsg.Visible = True
        End Sub
    End Class
End Namespace