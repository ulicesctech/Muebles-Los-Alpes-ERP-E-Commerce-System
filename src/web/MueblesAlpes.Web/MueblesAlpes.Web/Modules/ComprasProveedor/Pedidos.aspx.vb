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
                Dim formaPago As String = dt.Rows(0)("PED_FORMA_PAGO").ToString()
                Dim item As System.Web.UI.WebControls.ListItem = ddlCabeceraFormaPago.Items.FindByValue(formaPago)
                If item IsNot Nothing Then ddlCabeceraFormaPago.SelectedValue = formaPago
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

        Protected Sub btnGuardarCabecera_Click(sender As Object, e As EventArgs)
            Try
                Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)
                Dim dt As DataTable = PedidoService.ObtenerPorId(pedidoId)
                If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                    PedidoService.Actualizar(
                    Convert.ToDecimal(pedidoId),
                    dt.Rows(0)("PED_CODIGO").ToString(),
                    ddlCabeceraFormaPago.SelectedValue,
                    Convert.ToDecimal(dt.Rows(0)("PED_TOTAL"))
                )
                    CargarPedidos()
                    MostrarMensaje("Forma de pago actualizada correctamente.", False)
                End If
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, True)
            End Try
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
        ' GRID PEDIDOS  carga sub-grid de items en cada fila
        '========================
        Protected Sub gvPedidos_RowDataBound(sender As Object, e As GridViewRowEventArgs)
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim pedId As Integer = Convert.ToInt32(gvPedidos.DataKeys(e.Row.RowIndex).Value)
                Dim gvSub As GridView = CType(e.Row.FindControl("gvSubProductos"), GridView)
                If gvSub IsNot Nothing Then
                    Dim dt As DataTable = DetallePedidoService.ListarPorPedido(pedId)
                    gvSub.DataSource = dt
                    gvSub.DataBind()
                End If
            End If
        End Sub

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
            ' Solo refresca  precio se asigna desde Orden de Compra
        End Sub

        '========================
        ' AGREGAR PRODUCTO
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

                ' Validar que el pedido no tenga ya una Orden de Compra asociada
                Dim dtOC As DataTable = OrdenDetallePedidoService.BuscarPorPedido(pedidoId)
                If dtOC IsNot Nothing AndAlso dtOC.Rows.Count > 0 Then
                    MostrarMensaje("No se pueden agregar productos porque este pedido ya tiene una Orden de Compra asociada.", True)
                    Exit Sub
                End If

                ' Validar que el producto no este ya en el pedido
                Dim dtActual As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
                For Each fila As DataRow In dtActual.Rows
                    If Not IsDBNull(fila("PRO_REFERENCIA")) AndAlso
                       fila("PRO_REFERENCIA").ToString() = proRef Then
                        MostrarMensaje("Este producto ya fue agregado al pedido. No se puede repetir.", True)
                        Exit Sub
                    End If
                Next

                Dim hipSemilla As Decimal = HistorialPrecioService.RegistrarSemilla(proRef)
                DetallePedidoService.Insertar(pedidoId, CInt(hipSemilla), proRef, cantidad)

                txtCantSolicitada.Text = ""
                ddlProducto.SelectedIndex = 0
                CargarDetallesPedido(pedidoId)
                CargarPedidos()
                MostrarMensaje("Producto agregado. Vincula este pedido a una Orden de Compra para asignar precio.", False)
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
                    ' 1. Extraer argumentos del comando
                    Dim partes As String() = e.CommandArgument.ToString().Split("|")
                    Dim detalleId As Integer = Convert.ToInt32(partes(0))
                    Dim proRef As String = If(partes.Length > 1, partes(1), "")
                    Dim cantSol As Integer = Convert.ToInt32(If(partes.Length > 2, partes(2), "0"))

                    ' 2. Capturar cantidad recibida desde el TextBox del GridView
                    Dim cantRecibida As Integer = 0
                    For Each row As GridViewRow In gvDetalles.Rows
                        Dim pnl As Panel = CType(row.FindControl("pnlRecibir"), Panel)
                        If pnl IsNot Nothing AndAlso pnl.Visible Then
                            Dim txt As TextBox = CType(row.FindControl("txtCantRecibir"), TextBox)
                            If txt IsNot Nothing Then Integer.TryParse(txt.Text.Trim(), cantRecibida)
                            Exit For
                        End If
                    Next

                    ' 3. Validaciones de negocio
                    ' *** CAMBIE AHORITA: se agrego validacion de cantidad > 0 obligatoria.
                    ' Si cantRecibida = 0 o negativa no se permite continuar a Precios.
                    If cantRecibida <= 0 Then
                        MostrarMensaje("La cantidad recibida debe ser mayor a 0 para continuar.", True)
                        Exit Sub
                    End If
                    ' *** FIN CAMBIE AHORITA
                    If cantRecibida > cantSol Then
                        MostrarMensaje("La cantidad recibida no puede superar la solicitada (" & cantSol & ").", True)
                        Exit Sub
                    End If

                    ' 4. Buscar detalles de la Orden de Compra asociada al pedido
                    Dim dtOrdenes As DataTable = OrdenDetallePedidoService.BuscarPorPedido(pedidoId)
                    If dtOrdenes Is Nothing OrElse dtOrdenes.Rows.Count = 0 Then
                        MostrarMensaje("Este pedido no tiene una Orden de Compra asociada. Vinculala primero.", True)
                        hfDetalleRecibir.Value = "0"
                        CargarDetallesPedido(pedidoId)
                        Exit Sub
                    End If

                    ' 5. Obtener el material y hip_historial_precio del item actual
                    Dim dtDetalle As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
                    Dim filaDetalle = dtDetalle.Select("DETPE_DETALLE_PEDIDO = " & detalleId)
                    Dim materialItem As String = If(filaDetalle.Length > 0, filaDetalle(0)("MATERIAL").ToString().Trim(), "")

                    ' *** CAMBIE AHORITA: se lee el HIP_HISTORIAL_PRECIO de la fila del detalle
                    ' para enviarlo a Precios como parametro "hip" y poder actualizar la semilla.
                    Dim hipSemillaId As String = "0"
                    If filaDetalle.Length > 0 AndAlso Not IsDBNull(filaDetalle(0)("HIP_HISTORIAL_PRECIO")) Then
                        hipSemillaId = filaDetalle(0)("HIP_HISTORIAL_PRECIO").ToString()
                    End If
                    ' *** FIN CAMBIE AHORITA

                    ' Buscar precio en la Orden de Compra por material
                    Dim filasODP = dtOrdenes.Select("TRIM(ODP_MATERIAL) = '" & materialItem.Replace("'", "''") & "'")
                    Dim precioODP As Decimal = 0

                    If filasODP.Length > 0 Then
                        precioODP = Convert.ToDecimal(filasODP(0)("ODP_PRECIO"))
                    Else
                        precioODP = Convert.ToDecimal(dtOrdenes.Rows(0)("ODP_PRECIO"))
                        MostrarMensaje("No se encontro precio especifico. Se uso el primer precio disponible.", False)
                    End If

                    ' 6. Actualizar la cantidad recibida en el detalle del pedido
                    Dim cantSolActual As Integer = If(filaDetalle.Length > 0,
                                             Convert.ToInt32(filaDetalle(0)("DETPE_CANTIDAD_SOLICITADA")),
                                             cantSol)
                    DetallePedidoService.Actualizar(detalleId, cantSolActual, cantRecibida)

                    ' 7. Redirigir a Precios con los parametros necesarios
                    ' *** CAMBIE AHORITA: se agregan &detpe= y &hip= al redirect.
                    ' detpe = ID del BOD_DETALLE_PEDIDO (por si se necesita en Precios).
                    ' hip   = ID del historial semilla a actualizar en Precios.
                    Dim precioODPStr As String = precioODP.ToString("F2", System.Globalization.CultureInfo.InvariantCulture)
                    hfDetalleRecibir.Value = "0"

                    Response.Redirect(ResolveUrl("~/Modules/CatalogoInventario/Precios.aspx") &
                              "?ref=" & proRef &
                              "&pedido=" & pedidoId &
                              "&detpe=" & detalleId &
                              "&hip=" & hipSemillaId &
                              "&precio=" & precioODPStr &
                              "&readonly=1")
                    ' *** FIN CAMBIE AHORITA
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
            Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)

            ' Verificar si este pedido ya tiene una Orden de Compra asociada
            Dim dtOrdenes As DataTable = OrdenDetallePedidoService.BuscarPorPedido(pedidoId)
            If dtOrdenes IsNot Nothing AndAlso dtOrdenes.Rows.Count > 0 Then
                MostrarMensaje("No se puede editar la cantidad porque este pedido ya tiene una Orden de Compra asociada.", True)
                Exit Sub
            End If

            hfDetalleRecibir.Value = "0"
            gvDetalles.EditIndex = e.NewEditIndex
            CargarDetallesPedido(pedidoId)
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