' ============================================================
' RUTA: Modules/ComprasProveedor/Proveedores.aspx.vb
' ============================================================
Imports System
Imports System.Data
Imports System.Text.RegularExpressions

Namespace Modules.ComprasProveedor

    Partial Public Class Proveedores
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then CargarGrilla()
        End Sub

        ' =============================================
        ' CARGAR GRILLA
        ' =============================================
        Private Sub CargarGrilla()
            Try
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

        ' =============================================
        ' GUARDAR (crear o actualizar)
        ' =============================================
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If Not ValidarCampos() Then Return
            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                If id = 0 Then
                    ProveedorService.Crear(txtNit.Text.Trim(), txtNombre.Text.Trim(),
                                           txtAvenida.Text.Trim(), txtZona.Text.Trim(),
                                           txtDireccion.Text.Trim(), txtTelefono.Text.Trim())
                    LimpiarFormulario()
                    MostrarExito("Proveedor creado correctamente.")
                Else
                    ProveedorService.Actualizar(id, txtNit.Text.Trim(), txtNombre.Text.Trim(),
                                                txtAvenida.Text.Trim(), txtZona.Text.Trim(),
                                                txtDireccion.Text.Trim(), txtTelefono.Text.Trim())
                    LimpiarFormulario()
                    MostrarExito("Proveedor actualizado correctamente.")
                End If
                CargarGrilla()
            Catch ex As Exception
                If ex.Message.Contains("ya existe un proveedor con ese NIT") Then
                    MostrarError("Ya existe un proveedor registrado con ese NIT.")
                Else
                    MostrarError(ex.Message)
                End If
            End Try
        End Sub

        ' =============================================
        ' GRID COMMANDS — Editar y Eliminar
        ' =============================================
        Protected Sub gvProveedores_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandArgument Is Nothing OrElse
               String.IsNullOrEmpty(e.CommandArgument.ToString()) Then Return

            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
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
                    pnlMsg.Visible = False
                Catch ex As Exception
                    MostrarError("No se pudieron cargar los datos para editar.")
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    ProveedorService.Eliminar(id)
                    MostrarExito("Proveedor eliminado correctamente.")
                    CargarGrilla()
                Catch ex As Exception
                    If ex.Message.Contains("ORA-02292") Then
                        MostrarError("No se puede eliminar: este proveedor tiene ordenes, facturas o reclamos vinculados.")
                    Else
                        MostrarError("Error al eliminar: " & ex.Message)
                    End If
                End Try
            End If
        End Sub

        ' =============================================
        ' BUSCAR Y LIMPIAR
        ' =============================================
        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
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

        ' =============================================
        ' VALIDACIONES
        ' =============================================
        Private Function ValidarCampos() As Boolean

            ' NIT obligatorio
            If String.IsNullOrWhiteSpace(txtNit.Text) Then
                MostrarError("Ingresa el NIT o CUI del proveedor.") : Return False
            End If

            ' NIT / CUI formato Guatemala
            If Not EsNitOCuiGuatemalteco(txtNit.Text.Trim()) Then
                MostrarError("El NIT o CUI no tiene un formato valido. " &
                             "Formatos aceptados:" & vbCrLf &
                             "• NIT: digitos sin guion, puede terminar en K (ej: 123456789 o 12345678K)" & vbCrLf &
                             "• CUI: 13 digitos (ej: 1234567890101)") : Return False
            End If

            ' Nombre obligatorio
            If String.IsNullOrWhiteSpace(txtNombre.Text) Then
                MostrarError("Ingresa el nombre o razon social del proveedor.") : Return False
            End If

            ' Avenida obligatoria
            If String.IsNullOrWhiteSpace(txtAvenida.Text) Then
                MostrarError("Ingresa la avenida del proveedor.") : Return False
            End If

            ' Zona obligatoria
            If String.IsNullOrWhiteSpace(txtZona.Text) Then
                MostrarError("Ingresa la zona del proveedor.") : Return False
            End If

            ' Direccion obligatoria
            If String.IsNullOrWhiteSpace(txtDireccion.Text) Then
                MostrarError("Ingresa la direccion del proveedor.") : Return False
            End If

            ' Telefono: obligatorio, exactamente 8 digitos numericos
            Dim tel As String = txtTelefono.Text.Trim()
            If String.IsNullOrWhiteSpace(tel) Then
                MostrarError("Ingresa el telefono del proveedor.") : Return False
            End If
            If Not Regex.IsMatch(tel, "^\d{8}$") Then
                MostrarError("El telefono debe tener exactamente 8 digitos numericos sin espacios ni guiones (ej: 22223333).") : Return False
            End If

            Return True
        End Function

        ' =============================================
        ' VALIDACION NIT / CUI GUATEMALTECO
        '
        ' Formatos validos para PROVEEDORES (guion NO aceptado):
        '
        '   NIT sin guion:  2-9 digitos + digito verificador (0-9 o K)
        '                   Ej: 123456789, 12345678K
        '
        '   CUI:            Exactamente 13 digitos numericos
        '                   Ej: 1234567890101
        ' =============================================
        Private Function EsNitOCuiGuatemalteco(nit As String) As Boolean
            Dim nitUp As String = nit.ToUpper().Trim()

            ' CUI: exactamente 13 digitos
            If Regex.IsMatch(nitUp, "^\d{13}$") Then Return True

            ' NIT sin guion: 2-9 digitos + digito verificador (0-9 o K)
            ' Cubre: 123456789  /  12345678K
            If Regex.IsMatch(nitUp, "^\d{2,9}[\dK]$") Then Return True

            Return False
        End Function

        ' =============================================
        ' HELPERS
        ' =============================================
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