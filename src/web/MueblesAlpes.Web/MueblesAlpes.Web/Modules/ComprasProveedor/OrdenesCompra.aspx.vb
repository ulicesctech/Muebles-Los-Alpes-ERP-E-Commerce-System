Namespace Modules.ComprasProveedor

    Partial Public Class OrdenesCompra
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarOrdenes()
                CargarProveedores()
            End If
        End Sub

        ' =============================================
        ' HELPERS
        ' =============================================
        Private Sub CargarOrdenes()
            gvOrdenes.DataSource = OrdenCompraService.Listar()
            gvOrdenes.DataBind()
        End Sub

        Private Sub CargarProveedores()
            Dim dt As DataTable = ProveedorService.Listar()
            ddlProveedor.DataSource = dt
            ddlProveedor.DataTextField = "PROV_NOMBRE"
            ddlProveedor.DataValueField = "PROV_PROVEEDOR"
            ddlProveedor.DataBind()
            ddlProveedor.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
        End Sub

        Private Sub MostrarMsg(texto As String, esError As Boolean)
            lblMsg.Text = texto
            pnlMsg.CssClass = If(esError, "alert-err", "alert-ok")
            pnlMsg.Visible = True
        End Sub

        Private Sub CerrarTodosLosPaneles()
            pnlFormCabecera.Visible = False
            pnlDetalleOrden.Visible = False
            pnlResultadosPedidos.Visible = False
            pnlItemsPedido.Visible = False
            pnlMsg.Visible = False
            hfKey.Value = ""
            hfPedidoVinculado.Value = "0"
            hfFormaPago.Value = ""
        End Sub

        Private Sub ActualizarTotalOrden(orcKey As String)
            Dim dt As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
            Dim total As Decimal = 0
            For Each row As DataRow In dt.Rows
                Dim p As Decimal = If(IsDBNull(row("ODP_PRECIO")), 0D, Convert.ToDecimal(row("ODP_PRECIO")))
                Dim c As Decimal = If(IsDBNull(row("ODP_CANTIDAD")), 0D, Convert.ToDecimal(row("ODP_CANTIDAD")))
                total += p * c
            Next
            OrdenCompraService.ActualizarTotal(orcKey, total)
        End Sub

        Private Sub CargarDetalle(orcKey As String)
            Dim dt As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
            gvItemsOrden.DataSource = dt
            gvItemsOrden.DataBind()
            CalcularTotal(dt)
        End Sub

        Private Sub CalcularTotal(dt As DataTable)
            Dim total As Decimal = 0
            For Each row As DataRow In dt.Rows
                Dim p As Decimal = If(IsDBNull(row("ODP_PRECIO")), 0D, Convert.ToDecimal(row("ODP_PRECIO")))
                Dim c As Decimal = If(IsDBNull(row("ODP_CANTIDAD")), 0D, Convert.ToDecimal(row("ODP_CANTIDAD")))
                total += p * c
            Next
            lblTotalOrden.Text = total.ToString("N2")
        End Sub

        Private Function PedidoYaAsignado(pedidoId As Integer) As Boolean
            Try
                Dim dt As DataTable = OrdenDetallePedidoService.BuscarPorPedido(pedidoId)
                Return (dt IsNot Nothing AndAlso dt.Rows.Count > 0)
            Catch
                Return False
            End Try
        End Function

        Private Function OrdenTieneRecepcionRegistrada(orcKey As String) As Boolean
            Try
                Dim dtOdp As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
                If dtOdp Is Nothing OrElse dtOdp.Rows.Count = 0 Then Return False
                If dtOdp.Columns.Contains("PED_PEDIDO") Then
                    Dim pedId As Integer = Convert.ToInt32(dtOdp.Rows(0)("PED_PEDIDO"))
                    Dim dtDet As DataTable = DetallePedidoService.ListarPorPedido(pedId)
                    If dtDet IsNot Nothing Then
                        For Each row As DataRow In dtDet.Rows
                            Dim cantRecibida As Integer = 0
                            If Not IsDBNull(row("DETPE_CANTIDAD_RECIBIDA")) Then
                                cantRecibida = Convert.ToInt32(row("DETPE_CANTIDAD_RECIBIDA"))
                            End If
                            If cantRecibida > 0 Then Return True
                        Next
                    End If
                End If
                Return False
            Catch
                Return False
            End Try
        End Function

        Private Sub ScrollAPanel(control As System.Web.UI.Control)
            Dim clientId As String = control.ClientID
            Dim script As String =
                "setTimeout(function(){" &
                "  var el = document.getElementById('" & clientId & "');" &
                "  if(el){" &
                "    el.setAttribute('tabindex','-1');" &
                "    el.focus({preventScroll:true});" &
                "    el.scrollIntoView({behavior:'smooth',block:'start'});" &
                "  }" &
                "}, 200);"
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "scrollTo_" & clientId, script, True)
        End Sub

        ' =============================================
        ' BOTONES PRINCIPALES
        ' =============================================
        Protected Sub btnNuevaOrden_Click(sender As Object, e As EventArgs)
            CerrarTodosLosPaneles()
            pnlFormCabecera.Visible = True
            txtBuscarPedido.Text = ""
            If ddlProveedor.Items.Count > 0 Then ddlProveedor.SelectedIndex = 0
            ScrollAPanel(pnlFormCabecera)
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            CerrarTodosLosPaneles()
        End Sub

        Protected Sub btnCerrarDetalle_Click(sender As Object, e As EventArgs)
            CerrarTodosLosPaneles()
        End Sub

        Protected Sub btnFinalizarOrden_Click(sender As Object, e As EventArgs)
            Try
                If Not String.IsNullOrEmpty(hfOrdenActiva.Value) Then
                    ActualizarTotalOrden(hfOrdenActiva.Value)
                End If
                CargarOrdenes()
                CerrarTodosLosPaneles()
                MostrarMsg("Orden finalizada y guardada correctamente.", False)
            Catch ex As Exception
                MostrarMsg("Error al finalizar: " & ex.Message, True)
            End Try
        End Sub

        ' =============================================
        ' GUARDAR NUEVA ORDEN
        ' =============================================
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Try
                Dim provId As Decimal = Convert.ToDecimal(ddlProveedor.SelectedValue)
                If provId = 0 Then
                    MostrarMsg("Selecciona un proveedor.", True) : Exit Sub
                End If

                If Convert.ToInt32(hfPedidoVinculado.Value) = 0 Then
                    MostrarMsg("Debes seleccionar un pedido antes de confirmar la orden.", True) : Exit Sub
                End If

                Dim pedId As Integer = Convert.ToInt32(hfPedidoVinculado.Value)

                ' Paso 1: validar precios ANTES de crear nada en Oracle
                If pedId > 0 Then
                    Dim itemsFaltantes As New List(Of String)
                    For Each row As GridViewRow In gvItemsPedido.Rows
                        Dim txtPrecio As TextBox = CType(row.FindControl("txtPrecioItem"), TextBox)
                        Dim hfProd As HiddenField = CType(row.FindControl("hfProducto"), HiddenField)
                        If txtPrecio Is Nothing Then Continue For
                        Dim precio As Decimal = 0
                        If Not Decimal.TryParse(txtPrecio.Text.Trim().Replace(",", "."),
                                                System.Globalization.NumberStyles.Any,
                                                System.Globalization.CultureInfo.InvariantCulture,
                                                precio) OrElse precio <= 0 Then
                            Dim nombreProd As String = If(hfProd IsNot Nothing AndAlso
                                                          Not String.IsNullOrEmpty(hfProd.Value),
                                                          hfProd.Value, "Item " & (row.RowIndex + 1).ToString())
                            itemsFaltantes.Add(nombreProd)
                        End If
                    Next
                    If itemsFaltantes.Count > 0 Then
                        MostrarMsg("Debes ingresar un precio valido (mayor a 0) para todos los productos. " &
                                   "Falta precio en: " & String.Join(", ", itemsFaltantes) & ".", True)
                        Exit Sub
                    End If
                End If

                ' Paso 2: validacion superada — crear la orden en Oracle
                Dim orcKey As String = OrdenCompraService.Crear(Convert.ToInt32(provId), 0)
                If String.IsNullOrEmpty(orcKey) Then
                    MostrarMsg("No se pudo obtener el identificador de la orden. Intenta de nuevo.", True)
                    Exit Sub
                End If
                hfKey.Value = orcKey

                ' Paso 3: insertar items
                If pedId > 0 Then
                    For Each row As GridViewRow In gvItemsPedido.Rows
                        Dim txtPrecio As TextBox = CType(row.FindControl("txtPrecioItem"), TextBox)
                        Dim hfMat As HiddenField = CType(row.FindControl("hfMaterial"), HiddenField)
                        Dim hfProd As HiddenField = CType(row.FindControl("hfProducto"), HiddenField)
                        Dim hfCant As HiddenField = CType(row.FindControl("hfCantidad"), HiddenField)
                        If txtPrecio Is Nothing OrElse hfMat Is Nothing OrElse
                           hfProd Is Nothing OrElse hfCant Is Nothing Then Continue For
                        Dim precio As Decimal = 0
                        Dim cantidad As Integer = 0
                        Decimal.TryParse(txtPrecio.Text.Trim().Replace(",", "."),
                                         System.Globalization.NumberStyles.Any,
                                         System.Globalization.CultureInfo.InvariantCulture, precio)
                        Integer.TryParse(hfCant.Value, cantidad)
                        If cantidad <= 0 Then cantidad = 1
                        OrdenDetallePedidoService.Insertar(orcKey, pedId, hfMat.Value, hfProd.Value, precio, cantidad)
                    Next
                End If

                ActualizarTotalOrden(orcKey)

                hfOrdenActiva.Value = orcKey
                lblOrdenSeleccionada.Text = orcKey
                pnlFormCabecera.Visible = False
                pnlDetalleOrden.Visible = True
                pnlItemsPedido.Visible = False
                pnlResultadosPedidos.Visible = False
                hfPedidoVinculado.Value = "0"
                CargarOrdenes()
                CargarDetalle(orcKey)
                ScrollAPanel(pnlDetalleOrden)

                If String.IsNullOrEmpty(lblMsg.Text) OrElse Not pnlMsg.Visible Then
                    MostrarMsg("Orden " & orcKey & " creada correctamente.", False)
                End If
            Catch ex As Exception
                MostrarMsg("Error: " & ex.Message, True)
            End Try
        End Sub

        ' =============================================
        ' BUSCAR PEDIDOS
        ' =============================================
        Protected Sub btnBuscarPedido_Click(sender As Object, e As EventArgs)
            Dim dt As DataTable = OrdenCompraService.BuscarPedidos(txtBuscarPedido.Text.Trim())
            gvBuscarPedidos.DataSource = dt
            gvBuscarPedidos.DataBind()
            pnlResultadosPedidos.Visible = True
            pnlItemsPedido.Visible = False
            ScrollAPanel(pnlResultadosPedidos)
        End Sub

        Protected Sub gvBuscarPedidos_RowDataBound(sender As Object, e As GridViewRowEventArgs)
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim pedId As Integer = Convert.ToInt32(gvBuscarPedidos.DataKeys(e.Row.RowIndex).Value)

                Dim gvSub As GridView = CType(e.Row.FindControl("gvSubItemsBuscar"), GridView)
                If gvSub IsNot Nothing Then
                    gvSub.DataSource = OrdenCompraService.DetallesPedido(pedId)
                    gvSub.DataBind()
                End If

                Dim lnkSel As System.Web.UI.WebControls.LinkButton =
                    CType(e.Row.FindControl("lnkSeleccionar"), System.Web.UI.WebControls.LinkButton)

                If lnkSel IsNot Nothing AndAlso PedidoYaAsignado(pedId) Then
                    lnkSel.Enabled = False
                    lnkSel.Text = "&#128274; Ya asignado"
                    lnkSel.CssClass = "btn-disabled-t"
                    lnkSel.ToolTip = "Este pedido ya fue asignado a una Orden de Compra."
                End If
            End If
        End Sub

        Protected Sub gvBuscarPedidos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "VerItemsPedido" Then
                Dim partes As String() = e.CommandArgument.ToString().Split("|")
                Dim pedId As Integer = Convert.ToInt32(partes(0))
                Dim pedCod As String = If(partes.Length > 1, partes(1), "")
                Dim pedFP As String = If(partes.Length > 2, partes(2), "")

                If PedidoYaAsignado(pedId) Then
                    MostrarMsg("Este pedido ya esta asignado a una Orden de Compra y no puede seleccionarse.", True)
                    Exit Sub
                End If

                hfPedidoVinculado.Value = pedId.ToString()
                hfFormaPago.Value = pedFP
                lblPedidoId.Text = pedId.ToString()
                lblPedidoCodigo.Text = pedCod
                lblFormaPagoPedido.Text = If(pedFP <> "", pedFP, "—")

                gvItemsPedido.DataSource = OrdenCompraService.DetallesPedido(pedId)
                gvItemsPedido.DataBind()
                pnlItemsPedido.Visible = True
                pnlResultadosPedidos.Visible = False
                txtBuscarPedido.Text = ""
                ScrollAPanel(pnlItemsPedido)
            End If
        End Sub

        Protected Sub lnkQuitarPedido_Click(sender As Object, e As EventArgs)
            If Not String.IsNullOrEmpty(hfKey.Value) Then
                Try
                    OrdenCompraService.Eliminar(hfKey.Value)
                    CargarOrdenes()
                Catch ex As Exception
                    MostrarMsg("Error al eliminar la orden al quitar el pedido: " & ex.Message, True)
                End Try
                hfKey.Value = ""
            End If
            hfPedidoVinculado.Value = "0"
            hfFormaPago.Value = ""
            lblFormaPagoPedido.Text = ""
            pnlItemsPedido.Visible = False
        End Sub

        ' =============================================
        ' GRID ORDENES PRINCIPAL
        ' =============================================
        Protected Sub gvOrdenes_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "VerDetalle" Then
                Dim orcKey As String = e.CommandArgument.ToString()
                hfOrdenActiva.Value = orcKey
                lblOrdenSeleccionada.Text = orcKey
                pnlDetalleOrden.Visible = True
                pnlFormCabecera.Visible = False
                gvItemsOrden.EditIndex = -1
                CargarDetalle(orcKey)
                ScrollAPanel(pnlDetalleOrden)
            End If
        End Sub

        Protected Sub gvOrdenes_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
            Try
                Dim orcKey As String = gvOrdenes.DataKeys(e.RowIndex).Value.ToString()

                If OrdenTieneRecepcionRegistrada(orcKey) Then
                    MostrarMsg("No se puede eliminar esta Orden de Compra porque ya se ha registrado " &
                               "recepcion de mercancia (parcial o completa) para uno o mas items del pedido vinculado.", True)
                    Exit Sub
                End If

                OrdenCompraService.Eliminar(orcKey)
                If hfOrdenActiva.Value = orcKey Then pnlDetalleOrden.Visible = False
                CargarOrdenes()
                MostrarMsg("Orden eliminada correctamente.", False)
            Catch ex As Exception
                MostrarMsg("Error: " & ex.Message, True)
            End Try
        End Sub

        Protected Sub gvOrdenes_RowEditing(sender As Object, e As GridViewEditEventArgs)
            gvOrdenes.EditIndex = e.NewEditIndex
            CargarOrdenes()
        End Sub

        Protected Sub gvOrdenes_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
            gvOrdenes.EditIndex = -1
            CargarOrdenes()
        End Sub

        Protected Sub gvOrdenes_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
            gvOrdenes.EditIndex = -1
            CargarOrdenes()
        End Sub

        Protected Sub gvOrdenes_RowDataBound(sender As Object, e As GridViewRowEventArgs)
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim orcKey As String = gvOrdenes.DataKeys(e.Row.RowIndex).Value.ToString()
                Dim gvSub As GridView = CType(e.Row.FindControl("gvSubItems"), GridView)
                If gvSub IsNot Nothing Then
                    Dim dt As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
                    gvSub.DataSource = dt
                    gvSub.DataBind()
                    gvSub.Visible = (dt.Rows.Count > 0)
                End If
            End If
        End Sub

        ' =============================================
        ' GRID ITEMS DETALLE ORDEN
        ' =============================================
        Protected Sub gvItemsOrden_RowEditing(sender As Object, e As GridViewEditEventArgs)
            gvItemsOrden.EditIndex = e.NewEditIndex
            CargarDetalle(hfOrdenActiva.Value)
        End Sub

        Protected Sub gvItemsOrden_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
            gvItemsOrden.EditIndex = -1
            CargarDetalle(hfOrdenActiva.Value)
        End Sub

        Protected Sub gvItemsOrden_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
            Try
                Dim row As GridViewRow = gvItemsOrden.Rows(e.RowIndex)
                Dim id As Integer = Convert.ToInt32(gvItemsOrden.DataKeys(e.RowIndex).Value)
                Dim hfMat As HiddenField = CType(row.FindControl("hfEMat"), HiddenField)
                Dim hfProd As HiddenField = CType(row.FindControl("hfEProd"), HiddenField)
                Dim hfCan As HiddenField = CType(row.FindControl("hfECan"), HiddenField)

                Dim material As String = If(hfMat IsNot Nothing, hfMat.Value.Trim(), "")
                Dim producto As String = If(hfProd IsNot Nothing, hfProd.Value.Trim(), "")
                Dim cantidad As Integer = Convert.ToInt32(hfCan.Value)
                Dim precio As Decimal

                If Not Decimal.TryParse(CType(row.FindControl("txtEPre"), TextBox).Text.Trim().Replace(",", "."),
                                        System.Globalization.NumberStyles.Any,
                                        System.Globalization.CultureInfo.InvariantCulture, precio) OrElse precio <= 0 Then
                    MostrarMsg("Precio invalido.", True) : Exit Sub
                End If

                OrdenDetallePedidoService.Actualizar(id, material, producto, precio, cantidad)
                gvItemsOrden.EditIndex = -1
                CargarDetalle(hfOrdenActiva.Value)
                ActualizarTotalOrden(hfOrdenActiva.Value)
                CargarOrdenes()
            Catch ex As Exception
                MostrarMsg("Error al guardar: " & ex.Message, True)
            End Try
        End Sub

        ' =============================================
        ' BUSCAR / LIMPIAR ORDENES
        ' =============================================
        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            Dim filtro As String = txtBuscar.Text.Trim()
            If String.IsNullOrEmpty(filtro) Then
                CargarOrdenes()
            Else
                gvOrdenes.DataSource = OrdenCompraService.Buscar(filtro)
                gvOrdenes.DataBind()
            End If
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            pnlMsg.Visible = False
            CargarOrdenes()
        End Sub

    End Class

End Namespace