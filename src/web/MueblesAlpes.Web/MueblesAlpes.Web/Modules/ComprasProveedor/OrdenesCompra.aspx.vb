' ============================================================
' RUTA: Modules/ComprasProveedor/OrdenesCompra.aspx.vb
' ============================================================
Imports System
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.ComprasProveedor

    Partial Public Class OrdenesCompra
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarProveedores()
                LimpiarFormulario()
                CargarGrilla()
            End If
        End Sub

        ' ── Carga de datos ──────────────────────────────────
        Private Sub CargarProveedores()
            Try
                Dim dt As DataTable = ProveedorService.Listar()
                ddlProveedor.DataSource = dt
                ddlProveedor.DataTextField = "PROV_NOMBRE"
                ddlProveedor.DataValueField = "PROV_PROVEEDOR"
                ddlProveedor.DataBind()
                ddlProveedor.Items.Insert(0, New ListItem("-- Seleccione un proveedor --", "0"))
            Catch ex As Exception
                MostrarError("No logramos obtener la lista de proveedores. Por favor, intenta recargar la página.")
            End Try
        End Sub

        Private Sub CargarGrilla(Optional texto As String = "")
            Try
                gvOrdenes.DataSource = If(String.IsNullOrWhiteSpace(texto),
                                          OrdenCompraService.Listar(),
                                          OrdenCompraService.Buscar(texto))
                gvOrdenes.DataBind()
            Catch ex As Exception
                MostrarError("Tuvimos un problema al cargar el listado de órdenes. Intenta nuevamente.")
            End Try
        End Sub

        ' ── Acciones de búsqueda ────────────────────────────
        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            CargarGrilla(txtBuscar.Text.Trim())
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            pnlMsg.Visible = False
            LimpiarFormulario()
            CargarGrilla()
        End Sub

        ' ── Guardar / Actualizar ───────────────────────────
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If Not ValidarFormulario() Then Return

            Try
                Dim modo As String = hfModo.Value
                Dim idOrden As String = txtIDOrden.Text.Trim() ' NUEVO: Captura del ID manual
                Dim codigo As String = txtCodigo.Text.Trim()
                Dim provId As Decimal = Convert.ToDecimal(ddlProveedor.SelectedValue)
                Dim total As Decimal = Convert.ToDecimal(txtTotal.Text.Trim())

                If modo = "nuevo" Then
                    ' Se pasa idOrden como primer parámetro (p_orc_key)
                    OrdenCompraService.Crear(idOrden, codigo, provId, total)
                    MostrarExito("¡Excelente! La orden de compra ha sido registrada correctamente.")
                Else
                    ' En edición, el ID viene del campo (que está deshabilitado pero mantiene el valor)
                    OrdenCompraService.Actualizar(idOrden, codigo, provId, total)
                    MostrarExito("¡Hecho! Los cambios en la orden se han guardado con éxito.")
                End If

                LimpiarFormulario()
                CargarGrilla()
            Catch ex As Exception
                ' Captura de error de código o ID duplicado (Llave Primaria)
                If ex.Message.Contains("ORA-00001") Or ex.Message.ToLower().Contains("unique") Then
                    MostrarError("Ya existe una orden registrada con ese ID o Código. Por favor, verifica los datos.")
                Else
                    MostrarError("No pudimos guardar los datos en este momento. Error técnico: " & ex.Message)
                End If
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            pnlMsg.Visible = False
        End Sub

        ' ── Eventos de la Grilla ────────────────────────────
        Protected Sub gvOrdenes_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandArgument Is Nothing OrElse String.IsNullOrEmpty(e.CommandArgument.ToString()) Then Return

            Dim orcKey As String = e.CommandArgument.ToString()

            Select Case e.CommandName
                Case "Editar"
                    Try
                        ' Recuperamos la data actual
                        Dim dt As DataTable = OrdenCompraService.Listar()
                        Dim filas As DataRow() = dt.Select("ORC_ORDEN_COMPRA = '" & orcKey.Replace("'", "''") & "'")

                        If filas.Length > 0 Then
                            Dim fila As DataRow = filas(0)

                            hfModo.Value = "editar"

                            ' Bloqueamos el ID porque es la llave primaria y no se debe editar
                            txtIDOrden.Text = orcKey
                            txtIDOrden.Enabled = False

                            txtCodigo.Text = fila("ORC_CODIGO").ToString()
                            txtTotal.Text = fila("ORC_TOTAL_PRECIO").ToString()

                            Dim provId As String = fila("PROV_PROVEEDOR").ToString()
                            Dim item As ListItem = ddlProveedor.Items.FindByValue(provId)
                            If item IsNot Nothing Then ddlProveedor.SelectedValue = provId

                            lblTituloForm.Text = "📝 Editando Orden: " & orcKey
                            btnGuardar.Text = "💾 Actualizar"
                            pnlMsg.Visible = False
                        End If
                    Catch
                        MostrarError("No pudimos recuperar la información de esta orden para editarla.")
                    End Try

                Case "Eliminar"
                    Try
                        OrdenCompraService.Eliminar(orcKey)
                        LimpiarFormulario()
                        CargarGrilla()
                        MostrarExito("La orden de compra ha sido eliminada del sistema correctamente.")
                    Catch ex As Exception
                        If ex.Message.Contains("ORA-02292") Then
                            MostrarError("No se puede eliminar: Esta orden ya tiene movimientos asociados.")
                        Else
                            MostrarError("Hubo un inconveniente al intentar borrar el registro.")
                        End If
                    End Try
            End Select
        End Sub

        ' ── Métodos Auxiliares ──────────────────────────────
        Private Function ValidarFormulario() As Boolean
            ' Validación del nuevo campo de ID
            If String.IsNullOrWhiteSpace(txtIDOrden.Text) Then
                MostrarError("Debes ingresar un ID para la orden.") : Return False
            End If

            If String.IsNullOrWhiteSpace(txtCodigo.Text) Then
                MostrarError("¡Ups! Olvidaste ingresar el código de referencia.") : Return False
            End If

            If ddlProveedor.SelectedValue = "0" Then
                MostrarError("Por favor, selecciona un proveedor de la lista.") : Return False
            End If

            Dim total As Decimal
            If Not Decimal.TryParse(txtTotal.Text.Trim(), total) OrElse total < 0 Then
                MostrarError("El monto total debe ser un número válido (mayor o igual a 0).") : Return False
            End If
            Return True
        End Function

        Private Sub LimpiarFormulario()
            hfModo.Value = "nuevo"
            txtIDOrden.Text = ""
            txtIDOrden.Enabled = True ' Se habilita para nuevos registros
            txtCodigo.Text = ""
            txtTotal.Text = "0"
            ddlProveedor.SelectedIndex = 0
            lblTituloForm.Text = "➕ Nueva Orden de Compra"
            btnGuardar.Text = "💾 Guardar"
        End Sub

        ' --- Métodos de Mensajería ---

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