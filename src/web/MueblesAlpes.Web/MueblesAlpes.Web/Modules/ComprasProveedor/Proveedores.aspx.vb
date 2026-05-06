' ============================================================
' RUTA: Modules/ComprasProveedor/Proveedores.aspx.vb
' Las reglas de NIT y telefono viven en PKG_CP_BOD_PROVEEDOR.
' El code-behind solo valida que los campos no esten vacios
' antes de ir a la base de datos.
' ============================================================

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
            ' Validacion minima del lado del cliente: campos vacios
            If Not ValidarCamposRequeridos() Then Return
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
                ' El paquete Oracle lanza mensajes descriptivos con RAISE_APPLICATION_ERROR.
                ' Se muestra directamente sin necesidad de parsear el texto aqui.
                MostrarError(LimpiarMensajeOracle(ex.Message))
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
                        MostrarError(LimpiarMensajeOracle(ex.Message))
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
        ' VALIDACION MINIMA EN .NET
        ' Solo verifica que ningun campo este vacio.
        ' Las reglas de formato (NIT, telefono) las aplica
        ' el paquete Oracle y se muestran via ex.Message.
        ' =============================================
        Private Function ValidarCamposRequeridos() As Boolean
            If String.IsNullOrWhiteSpace(txtNit.Text) Then
                MostrarError("Ingresa el NIT o CUI del proveedor.") : Return False
            End If
            If String.IsNullOrWhiteSpace(txtNombre.Text) Then
                MostrarError("Ingresa el nombre o razon social del proveedor.") : Return False
            End If
            If String.IsNullOrWhiteSpace(txtAvenida.Text) Then
                MostrarError("Ingresa la avenida del proveedor.") : Return False
            End If
            If String.IsNullOrWhiteSpace(txtZona.Text) Then
                MostrarError("Ingresa la zona del proveedor.") : Return False
            End If
            If String.IsNullOrWhiteSpace(txtDireccion.Text) Then
                MostrarError("Ingresa la direccion del proveedor.") : Return False
            End If
            If String.IsNullOrWhiteSpace(txtTelefono.Text) Then
                MostrarError("Ingresa el telefono del proveedor.") : Return False
            End If
            Return True
        End Function

        ' =============================================
        ' Quita el prefijo tecnico que Oracle agrega al
        ' mensaje antes de la descripcion del paquete.
        ' Ej: "ORA-20008: PKG_CP_BOD_PROVEEDOR: telefono invalido..."
        '  -> "telefono invalido..."
        ' =============================================
        Private Function LimpiarMensajeOracle(msg As String) As String
            ' Busca el patron "PKG_CP_BOD_PROVEEDOR: " y devuelve lo que sigue
            Dim marca As String = "PKG_CP_BOD_PROVEEDOR: "
            Dim pos As Integer = msg.IndexOf(marca)
            If pos >= 0 Then
                Return msg.Substring(pos + marca.Length)
            End If
            Return msg
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