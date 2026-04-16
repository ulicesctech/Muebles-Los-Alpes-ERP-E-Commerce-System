Imports System.Data

Namespace Modules.ComprasProveedor

    Partial Public Class Pedidos
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPedidos()
                Dim pedidoParam As String = Request.QueryString("pedido")
                If Not String.IsNullOrEmpty(pedidoParam) Then
                    Dim pedidoId As Integer = Convert.ToInt32(pedidoParam)
                    hfPedidoActivo.Value = pedidoId.ToString()
                    lblIdSeleccionado.Text = pedidoId.ToString()
                    CargarProductosDropDown()
                    CargarDetallesPedido(pedidoId)
                    CargarInfoCabecera(pedidoId)
                    pnlDetalleContenedor.Visible = True
                    MostrarMensaje("Precio registrado. Puedes seguir agregando productos.", False)
                End If
            End If
        End Sub

        '========================
        ' HELPERS
        '========================
        Private Sub CargarPedidos()
            gvPedidos.DataSource = PedidoService.Listar()
            gvPedidos.DataBind()
        End Sub

        Private Sub CargarProductosDropDown()
            Dim dt As DataTable = DetallePedidoService.ListarTodosProductos()
            ddlProducto.DataSource = dt
            ddlProducto.DataTextField = "PRO_NOMBRE"
            ddlProducto.DataValueField = "PRO_REFERENCIA"
            ddlProducto.DataBind()
            ddlProducto.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione producto --", ""))
        End Sub

        Private Sub CargarDetallesPedido(pedidoId As Integer)
            gvDetalles.EditIndex = -1
            Dim dt As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
            gvDetalles.DataSource = dt
            gvDetalles.DataBind()
            RecalcularTotal(dt, pedidoId)
        End Sub

        Private Sub CargarInfoCabecera(pedidoId As Integer)
            Dim dt As DataTable = PedidoService.ObtenerPorId(pedidoId)
            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                lblCabeceraCode.Text = dt.Rows(0)("PED_CODIGO").ToString()
                lblCabeceraFecha.Text = String.Format("{0:dd/MM/yyyy}", dt.Rows(0)("PED_FECHA"))
                lblCabeceraFormaPago.Text = dt.Rows(0)("PED_FORMA_PAGO").ToString()
            End If
        End Sub

        Private Sub RecalcularTotal(dt As DataTable, pedidoId As Integer)
            Dim total As Decimal = 0
            If dt IsNot Nothing Then
                For Each row As DataRow In dt.Rows
                    Dim precio As Decimal = If(IsDBNull(row("HIP_PRECIO")), 0D, Convert.ToDecimal(row("HIP_PRECIO")))
                    Dim cantidad As Decimal = If(IsDBNull(row("DETPE_CANTIDAD_SOLICITADA")), 0D, Convert.ToDecimal(row("DETPE_CANTIDAD_SOLICITADA")))
                    total += (precio * cantidad)
                Next
            End If
            lblTotalDetalle.Text = total.ToString("N2")
            Dim dtPed As DataTable = PedidoService.ObtenerPorId(pedidoId)
            If dtPed IsNot Nothing AndAlso dtPed.Rows.Count > 0 Then
                PedidoService.Actualizar(
                    Convert.ToDecimal(pedidoId),
                    dtPed.Rows(0)("PED_CODIGO").ToString(),
                    dtPed.Rows(0)("PED_FORMA_PAGO").ToString(),
                    total
                )
            End If
        End Sub

        Private Sub MostrarMensaje(msg As String, esError As Boolean)
            lblMsg.Text = msg
            lblMsg.CssClass = If(esError, "alert-err", "alert-ok")
            pnlMsg.Visible = True
        End Sub

        '========================
        ' NUEVO PEDIDO
        '========================
        Protected Sub btnNuevoPedido_Click(sender As Object, e As EventArgs)
            pnlFormCabecera.Visible = True
            pnlDetalleContenedor.Visible = False
            pnlMsg.Visible = False
            txtCodigo.Text = ""
            ddlFormaPago.SelectedIndex = 0
        End Sub

        Protected Sub btnCancelarForm_Click(sender As Object, e As EventArgs)
            pnlFormCabecera.Visible = False
            pnlMsg.Visible = False
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Try
                If String.IsNullOrEmpty(txtCodigo.Text.Trim()) Then
                    MostrarMensaje("Ingresa el codigo del pedido.", True) : Exit Sub
                End If
                Dim nuevoId As Decimal = PedidoService.Crear(txtCodigo.Text.Trim(),
                                                              ddlFormaPago.SelectedValue, 0)
                hfPedidoActivo.Value = nuevoId.ToString()
                lblIdSeleccionado.Text = nuevoId.ToString()
                CargarProductosDropDown()
                CargarDetallesPedido(Convert.ToInt32(nuevoId))
                CargarInfoCabecera(Convert.ToInt32(nuevoId))
                pnlFormCabecera.Visible = False
                pnlDetalleContenedor.Visible = True
                CargarPedidos()
                MostrarMensaje("Pedido #" & nuevoId & " creado. Agrega los productos.", False)
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, True)
            End Try
        End Sub

        Protected Sub btnFinalizarPedido_Click(sender As Object, e As EventArgs)
            pnlDetalleContenedor.Visible = False
            pnlMsg.Visible = False
            CargarPedidos()
        End Sub

        Protected Sub btnCerrarDetalle_Click(sender As Object, e As EventArgs)
            pnlDetalleContenedor.Visible = False
            pnlFormCabecera.Visible = False
            pnlMsg.Visible = False
        End Sub

        '========================
        ' GRID PEDIDOS
        '========================
        Protected Sub gvPedidos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            pnlMsg.Visible = False
            If e.CommandName = "VerDetalle" Then
                Dim pedidoId As Integer = Convert.ToInt32(e.CommandArgument)
                hfPedidoActivo.Value = pedidoId.ToString()
                hfDetalleRecibir.Value = "0"
                lblIdSeleccionado.Text = pedidoId.ToString()
                CargarProductosDropDown()
                CargarDetallesPedido(pedidoId)
                CargarInfoCabecera(pedidoId)
                pnlDetalleContenedor.Visible = True
                pnlFormCabecera.Visible = False
            ElseIf e.CommandName = "Eliminar" Then
                Try
                    PedidoService.Eliminar(Convert.ToInt32(e.CommandArgument))
                    If hfPedidoActivo.Value = e.CommandArgument.ToString() Then
                        pnlDetalleContenedor.Visible = False
                    End If
                    CargarPedidos()
                    MostrarMensaje("Pedido eliminado.", False)
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, True)
                End Try
            End If
        End Sub

        '========================
        ' DROPDOWN PRODUCTO
        '========================
        Protected Sub ddlProducto_SelectedIndexChanged(sender As Object, e As EventArgs)
            ' Solo refresca la seleccion — el precio se asigna desde la Orden de Compra
        End Sub

        '========================
        ' AGREGAR PRODUCTO
        ' CAMBIO: pasa proRef a Insertar para guardar en BOD_DETALLE_PEDIDO.pro_referencia
        '========================
        Protected Sub btnAgregarItem_Click(sender As Object, e As EventArgs)
            Try
                Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)
                Dim proRef As String = ddlProducto.SelectedValue
                Dim cantidad As Integer

                If String.IsNullOrEmpty(proRef) Then
                    MostrarMensaje("Selecciona un producto.", True) : Exit Sub
                End If
                If Not Integer.TryParse(txtCantSolicitada.Text.Trim(), cantidad) OrElse cantidad <= 0 Then
                    MostrarMensaje("Ingresa una cantidad valida.", True) : Exit Sub
                End If

                Dim dt As DataTable = DetallePedidoService.ListarTodosProductos()
                Dim filas = dt.Select("PRO_REFERENCIA = '" & proRef & "'")

                ' 0 = sin historial aun — NULLIF en el paquete lo convierte a NULL en BD
                Dim hipId As Integer = 0
                If filas.Length > 0 Then
                    If Not IsDBNull(filas(0)("HIP_ID_VIGENTE")) Then
                        Dim v As Integer = Convert.ToInt32(filas(0)("HIP_ID_VIGENTE"))
                        If v > 0 Then hipId = v
                    End If
                End If

                ' Ahora pasamos proRef para que el listado pueda mostrar
                ' el nombre del producto aunque no haya historial asignado
                DetallePedidoService.Insertar(pedidoId, hipId, proRef, cantidad)

                txtCantSolicitada.Text = ""
                ddlProducto.SelectedIndex = 0
                CargarDetallesPedido(pedidoId)
                CargarPedidos()

                If hipId = 0 Then
                    MostrarMensaje("Producto agregado. Recuerda vincular este pedido a una Orden de Compra para asignarle precio.", False)
                Else
                    MostrarMensaje("Producto agregado correctamente.", False)
                End If
            Catch ex As Exception
                MostrarMensaje("Error al agregar item: " & ex.Message, True)
            End Try
        End Sub

        '========================
        ' GRID DETALLES
        '========================
        Protected Sub gvDetalles_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)

            If e.CommandName = "BorrarItem" Then
                Try
                    DetallePedidoService.Eliminar(Convert.ToInt32(e.CommandArgument))
                    hfDetalleRecibir.Value = "0"
                    CargarDetallesPedido(pedidoId)
                    CargarPedidos()
                    MostrarMensaje("Producto eliminado.", False)
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, True)
                End Try

            ElseIf e.CommandName = "MarcarRecibido" Then
                hfDetalleRecibir.Value = e.CommandArgument.ToString()
                gvDetalles.EditIndex = -1
                CargarDetallesPedido(pedidoId)

            ElseIf e.CommandName = "CancelarRecibido" Then
                hfDetalleRecibir.Value = "0"
                CargarDetallesPedido(pedidoId)

            ElseIf e.CommandName = "ConfirmarRecibido" Then
                Try
                    Dim partes As String() = e.CommandArgument.ToString().Split("|")
                    Dim detalleId As Integer = Convert.ToInt32(partes(0))
                    Dim proRef As String = If(partes.Length > 1, partes(1), "")
                    Dim cantSol As Integer = Convert.ToInt32(If(partes.Length > 2, partes(2), "0"))

                    Dim cantRecibida As Integer = 0
                    For Each row As GridViewRow In gvDetalles.Rows
                        Dim pnl As Panel = CType(row.FindControl("pnlRecibir"), Panel)
                        If pnl IsNot Nothing AndAlso pnl.Visible Then
                            Dim txt As TextBox = CType(row.FindControl("txtCantRecibir"), TextBox)
                            If txt IsNot Nothing Then Integer.TryParse(txt.Text.Trim(), cantRecibida)
                            Exit For
                        End If
                    Next

                    If cantRecibida < 0 Then
                        MostrarMensaje("Cantidad recibida invalida.", True) : Exit Sub
                    End If
                    If cantRecibida > cantSol Then
                        MostrarMensaje("La cantidad recibida no puede superar la solicitada (" & cantSol & ").", True)
                        Exit Sub
                    End If

                    Dim dtOrdenes As DataTable = OrdenDetallePedidoService.BuscarPorPedido(pedidoId)
                    If dtOrdenes Is Nothing OrElse dtOrdenes.Rows.Count = 0 Then
                        MostrarMensaje("Este pedido no tiene una Orden de Compra asociada. Vinculala primero desde Ordenes de Compra.", True)
                        hfDetalleRecibir.Value = "0"
                        CargarDetallesPedido(pedidoId)
                        Exit Sub
                    End If

                    Dim dtActual As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
                    Dim filaAct = dtActual.Select("DETPE_DETALLE_PEDIDO = " & detalleId)
                    Dim cantSolActual As Integer = If(filaAct.Length > 0,
                                                      Convert.ToInt32(filaAct(0)("DETPE_CANTIDAD_SOLICITADA")),
                                                      cantSol)
                    DetallePedidoService.Actualizar(detalleId, cantSolActual, cantRecibida)

                    Dim precioODP As String = Convert.ToDecimal(dtOrdenes.Rows(0)("ODP_PRECIO")).ToString(
                        "F2", System.Globalization.CultureInfo.InvariantCulture)

                    hfDetalleRecibir.Value = "0"

                    Response.Redirect(ResolveUrl("~/Modules/CatalogoInventario/Precios.aspx") &
                                      "?ref=" & proRef &
                                      "&pedido=" & pedidoId &
                                      "&precio=" & precioODP &
                                      "&readonly=1")
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, True)
                End Try
            End If
        End Sub

        Protected Sub gvDetalles_RowDataBound(sender As Object, e As GridViewRowEventArgs)
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim detalleActivo As Integer = 0
                Integer.TryParse(hfDetalleRecibir.Value, detalleActivo)
                If detalleActivo > 0 Then
                    Dim detalleId As Integer = Convert.ToInt32(gvDetalles.DataKeys(e.Row.RowIndex).Value)
                    Dim pnl As Panel = CType(e.Row.FindControl("pnlRecibir"), Panel)
                    If pnl IsNot Nothing Then
                        pnl.Visible = (detalleId = detalleActivo)
                    End If
                End If
            End If
        End Sub

        Protected Sub gvDetalles_RowEditing(sender As Object, e As GridViewEditEventArgs)
            hfDetalleRecibir.Value = "0"
            gvDetalles.EditIndex = e.NewEditIndex
            CargarDetallesPedido(Convert.ToInt32(hfPedidoActivo.Value))
        End Sub

        Protected Sub gvDetalles_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
            gvDetalles.EditIndex = -1
            CargarDetallesPedido(Convert.ToInt32(hfPedidoActivo.Value))
        End Sub

        Protected Sub gvDetalles_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
            Try
                Dim row As GridViewRow = gvDetalles.Rows(e.RowIndex)
                Dim detalleId As Integer = Convert.ToInt32(gvDetalles.DataKeys(e.RowIndex).Value)
                Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)
                Dim txtSol As TextBox = CType(row.FindControl("txtESolicitada"), TextBox)
                Dim solicitada As Integer

                If txtSol Is Nothing OrElse Not Integer.TryParse(txtSol.Text.Trim(), solicitada) OrElse solicitada <= 0 Then
                    MostrarMensaje("Cantidad solicitada invalida.", True) : Exit Sub
                End If

                Dim dtActual As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
                Dim filaAct = dtActual.Select("DETPE_DETALLE_PEDIDO = " & detalleId)
                Dim recibida As Integer = 0
                If filaAct.Length > 0 AndAlso Not IsDBNull(filaAct(0)("DETPE_CANTIDAD_RECIBIDA")) Then
                    recibida = Convert.ToInt32(filaAct(0)("DETPE_CANTIDAD_RECIBIDA"))
                End If

                DetallePedidoService.Actualizar(detalleId, solicitada, recibida)
                gvDetalles.EditIndex = -1
                CargarDetallesPedido(pedidoId)
                CargarPedidos()
                MostrarMensaje("Item actualizado.", False)
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, True)
            End Try
        End Sub

        '========================
        ' BUSCAR / LIMPIAR
        '========================
        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            Dim filtro As String = txtBuscar.Text.Trim()
            If String.IsNullOrEmpty(filtro) Then
                CargarPedidos()
            Else
                gvPedidos.DataSource = PedidoService.Buscar(filtro)
                gvPedidos.DataBind()
            End If
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            pnlMsg.Visible = False
            CargarPedidos()
        End Sub

    End Class

End Namespace