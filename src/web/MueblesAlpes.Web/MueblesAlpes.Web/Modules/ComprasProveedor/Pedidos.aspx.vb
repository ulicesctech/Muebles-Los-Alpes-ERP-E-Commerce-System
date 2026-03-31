' ============================================================
' RUTA: Modules/ComprasProveedor/Pedidos.aspx.vb
' ============================================================
Imports System.Data

Namespace Modules.ComprasProveedor

    Partial Public Class Pedidos
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                LimpiarFormulario()
                CargarGrilla()
            End If
        End Sub

        ' ── Carga de Datos ──────────────────────────────────
        Private Sub CargarGrilla(Optional texto As String = "")
            Try
                gvPedidos.DataSource = If(String.IsNullOrWhiteSpace(texto),
                                          PedidoService.Listar(),
                                          PedidoService.Buscar(texto))
                gvPedidos.DataBind()
            Catch ex As Exception
                MostrarError("No logramos actualizar el listado de pedidos. Por favor, intenta refrescar la página.")
            End Try
        End Sub

        ' ── Acciones de Búsqueda ────────────────────────────
        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            CargarGrilla(txtBuscar.Text.Trim())
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            pnlMsg.Visible = False
            CargarGrilla()
        End Sub

        ' ── Guardar / Actualizar ───────────────────────────
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            ' Validaciones amigables antes de procesar
            If Not ValidarFormulario() Then Return

            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                Dim codigo As String = txtCodigo.Text.Trim()
                Dim formaPago As String = ddlFormaPago.SelectedValue
                Dim total As Decimal = Convert.ToDecimal(txtTotal.Text.Trim())

                If id = 0 Then
                    PedidoService.Crear(codigo, formaPago, total)
                    MostrarExito("¡Excelente! El pedido <strong>" & codigo & "</strong> ha sido registrado correctamente.")
                Else
                    PedidoService.Actualizar(id, codigo, formaPago, total)
                    MostrarExito("¡Hecho! Los cambios en el pedido <strong>" & codigo & "</strong> se han guardado con éxito.")
                End If

                LimpiarFormulario()
                CargarGrilla()
            Catch ex As Exception
                ' Manejo de errores específicos de base de datos
                If ex.Message.Contains("ORA-00001") Then
                    MostrarError("No se pudo guardar: Ya existe un pedido registrado con el código <strong>" & txtCodigo.Text & "</strong>.")
                Else
                    MostrarError("Tuvimos un inconveniente técnico al intentar guardar: " & ex.Message)
                End If
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            pnlMsg.Visible = False
        End Sub

        ' ── Eventos de la Grilla ────────────────────────────
        Protected Sub gvPedidos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandArgument Is Nothing OrElse String.IsNullOrEmpty(e.CommandArgument.ToString()) Then Return

            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)

            Select Case e.CommandName
                Case "Editar"
                    Try
                        Dim dt As DataTable = PedidoService.Listar()
                        Dim filas As DataRow() = dt.Select("PED_PEDIDO = " & id)

                        If filas.Length > 0 Then
                            Dim fila As DataRow = filas(0)
                            hfId.Value = id.ToString()
                            txtCodigo.Text = fila("PED_CODIGO").ToString()
                            txtTotal.Text = fila("PED_TOTAL").ToString()
                            ddlFormaPago.SelectedValue = fila("PED_FORMA_PAGO").ToString()

                            ' Bloqueamos el código para mantener la integridad en edición
                            txtCodigo.Enabled = False
                            lblTituloForm.Text = "📝 Editando Pedido: " & txtCodigo.Text
                            btnGuardar.Text = "💾 Actualizar Pedido"
                            pnlMsg.Visible = False
                        End If
                    Catch
                        MostrarError("No pudimos recuperar la información del pedido para editarla.")
                    End Try

                Case "Eliminar"
                    Try
                        PedidoService.Eliminar(id)
                        LimpiarFormulario()
                        CargarGrilla()
                        MostrarExito("¡Listo! El pedido ha sido eliminado del sistema de forma segura.")
                    Catch ex As Exception
                        ' Error de integridad referencial (FK)
                        If ex.Message.Contains("ORA-02292") Then
                            MostrarError("No se puede eliminar: Este pedido ya tiene documentos vinculados (como facturas o recepciones).")
                        Else
                            MostrarError("Hubo un inconveniente al intentar eliminar el pedido del sistema.")
                        End If
                    End Try
            End Select
        End Sub

        ' ── Métodos Auxiliares ──────────────────────────────
        Private Function ValidarFormulario() As Boolean
            If String.IsNullOrWhiteSpace(txtCodigo.Text) Then
                MostrarError("Por favor, ingresa un código para el pedido. Es un dato necesario.")
                Return False
            End If

            Dim total As Decimal
            If Not Decimal.TryParse(txtTotal.Text.Trim(), total) OrElse total < 0 Then
                MostrarError("El monto total debe ser un número válido mayor o igual a 0.")
                Return False
            End If

            If ddlFormaPago.SelectedIndex = 0 Then
                MostrarError("Debes seleccionar una forma de pago para este pedido.")
                Return False
            End If

            Return True
        End Function

        Private Sub LimpiarFormulario()
            hfId.Value = "0"
            txtCodigo.Text = ""
            txtTotal.Text = "0"
            ddlFormaPago.SelectedIndex = 0
            txtCodigo.Enabled = True
            lblTituloForm.Text = "➕ Nuevo Pedido"
            btnGuardar.Text = "💾 Guardar"
        End Sub

        ' --- Métodos de Mensajería Amigable ---

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