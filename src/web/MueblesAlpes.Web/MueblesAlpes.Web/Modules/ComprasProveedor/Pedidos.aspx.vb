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

            Dim dtPed As DataTable = PedidoService.ObtenerPorId(pedidoId)
            If dtPed IsNot Nothing AndAlso dtPed.Rows.Count > 0 Then
                PedidoService.Actualizar(
                    Convert.ToDecimal(pedidoId),
                    dtPed.Rows(0)("PED_CODIGO").ToString(),
                    dtPed.Rows(0)("PED_FORMA_PAGO").ToString(),
                    total)
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
                        Convert.ToDecimal(dt.Rows(0)("PED_TOTAL")))
                    CargarPedidos()
                    MostrarMensaje("Forma de pago actualizada correctamente.", False)
                End If
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, True)
            End Try
        End Sub

        ''' <summary>
        ''' Crea el pedido con codigo temporal, obtiene el ID generado por Oracle
        ''' y actualiza de inmediato el codigo definitivo con formato PED-{ID}.
        ''' El usuario nunca ingresa ni edita el codigo.
        ''' </summary>
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Try
                ' 1. Insertar con codigo temporal para obtener el ID de Oracle
                Dim nuevoId As Decimal = PedidoService.Crear("TEMP", ddlFormaPago.SelectedValue, 0)

                ' 2. Construir el codigo definitivo y actualizar de inmediato
                Dim codigoAuto As String = "PED-" & nuevoId.ToString()
                PedidoService.Actualizar(nuevoId, codigoAuto, ddlFormaPago.SelectedValue, 0)

                ' 3. Abrir el panel de detalle para agregar productos
                hfPedidoActivo.Value = nuevoId.ToString()
                lblIdSeleccionado.Text = nuevoId.ToString()
                CargarProductosDropDown()
                CargarDetallesPedido(Convert.ToInt32(nuevoId))
                CargarInfoCabecera(Convert.ToInt32(nuevoId))
                pnlFormCabecera.Visible = False
                pnlDetalleContenedor.Visible = True
                CargarPedidos()
                MostrarMensaje("Pedido " & codigoAuto & " creado correctamente. Agrega al menos un producto antes de finalizar.", False)
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, True)
            End Try
        End Sub

        ''' <summary>
        ''' Finaliza el pedido solo si tiene al menos un producto agregado.
        ''' Si no tiene productos, elimina el pedido vacio y avisa al usuario.
        ''' </summary>
        Protected Sub btnFinalizarPedido_Click(sender As Object, e As EventArgs)
            Try
                Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)
                Dim dtItems As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)

                ' Validar que tenga al menos un producto
                If dtItems Is Nothing OrElse dtItems.Rows.Count = 0 Then
                    ' Eliminar el pedido vacio para no dejar basura en la BD
                    PedidoService.Eliminar(pedidoId)
                    pnlDetalleContenedor.Visible = False
                    CargarPedidos()
                    MostrarMensaje("No puedes finalizar un pedido sin productos. El pedido fue eliminado automaticamente.", True)
                    Exit Sub
                End If

                ' Tiene productos: cerrar normalmente
                pnlDetalleContenedor.Visible = False
                pnlMsg.Visible = False
                CargarPedidos()
            Catch ex As Exception
                MostrarMensaje("Error al finalizar: " & ex.Message, True)
            End Try
        End Sub

        Protected Sub btnCerrarDetalle_Click(sender As Object, e As EventArgs)
            Try
                Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)
                Dim dtItems As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)

                ' Si cerraron sin agregar productos, eliminar el pedido vacio
                If dtItems Is Nothing OrElse dtItems.Rows.Count = 0 Then
                    PedidoService.Eliminar(pedidoId)
                    CargarPedidos()
                    MostrarMensaje("El pedido no tenia productos y fue eliminado automaticamente.", True)
                End If
            Catch ex As Exception
                ' Si falla la limpieza, simplemente cerrar sin avisar
            Finally
                pnlDetalleContenedor.Visible = False
                pnlFormCabecera.Visible = False
                pnlMsg.Visible = False
            End Try
        End Sub

        '========================
        ' GRID PEDIDOS
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
                    MostrarMensaje("Pedido eliminado correctamente.", False)
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, True)
                End Try
            End If
        End Sub

        '========================
        ' DROPDOWN PRODUCTO
        '========================
        Protected Sub ddlProducto_SelectedIndexChanged(sender As Object, e As EventArgs)
            ' Solo refresca
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

                Dim dtOC As DataTable = OrdenDetallePedidoService.BuscarPorPedido(pedidoId)
                If dtOC IsNot Nothing AndAlso dtOC.Rows.Count > 0 Then
                    MostrarMensaje("No se pueden agregar productos porque este pedido ya tiene una Orden de Compra asociada.", True)
                    Exit Sub
                End If

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
                MostrarMensaje("Producto agregado correctamente. Vincula este pedido a una Orden de Compra para asignar precio.", False)
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
                    MostrarMensaje("Producto eliminado correctamente.", False)
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
                    Dim cantYaRecibida As Integer = Convert.ToInt32(If(partes.Length > 3, partes(3), "0"))

                    Dim cantComplemento As Integer = 0
                    For Each row As GridViewRow In gvDetalles.Rows
                        Dim pnl As Panel = CType(row.FindControl("pnlRecibir"), Panel)
                        If pnl IsNot Nothing AndAlso pnl.Visible Then
                            Dim txtComp As TextBox = CType(row.FindControl("txtCantComplemento"), TextBox)
                            If txtComp IsNot Nothing Then
                                Integer.TryParse(txtComp.Text.Trim(), cantComplemento)
                            End If
                            Exit For
                        End If
                    Next

                    If cantComplemento <= 0 Then
                        MostrarMensaje("Ingresa una cantidad a agregar mayor a 0.", True)
                        Exit Sub
                    End If

                    Dim cantTotalNueva As Integer = cantYaRecibida + cantComplemento
                    If cantTotalNueva > cantSol Then
                        MostrarMensaje("La cantidad total recibida (" & cantTotalNueva &
                                       ") superaria la solicitada (" & cantSol & "). " &
                                       "Maximo que puedes agregar ahora: " &
                                       (cantSol - cantYaRecibida) & ".", True)
                        Exit Sub
                    End If

                    Dim dtOrdenes As DataTable = OrdenDetallePedidoService.BuscarPorPedido(pedidoId)
                    If dtOrdenes Is Nothing OrElse dtOrdenes.Rows.Count = 0 Then
                        MostrarMensaje("Este pedido no tiene una Orden de Compra asociada. Vinculala primero.", True)
                        hfDetalleRecibir.Value = "0"
                        CargarDetallesPedido(pedidoId)
                        Exit Sub
                    End If

                    Dim dtDetalle As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
                    Dim filaDetalle = dtDetalle.Select("DETPE_DETALLE_PEDIDO = " & detalleId)

                    Dim materialItem As String = If(filaDetalle.Length > 0, filaDetalle(0)("MATERIAL").ToString().Trim(), "")
                    Dim productoItem As String = If(filaDetalle.Length > 0, filaDetalle(0)("PRO_NOMBRE").ToString().Trim(), "")

                    Dim hipSemillaId As String = "0"
                    If filaDetalle.Length > 0 AndAlso Not IsDBNull(filaDetalle(0)("HIP_HISTORIAL_PRECIO")) Then
                        hipSemillaId = filaDetalle(0)("HIP_HISTORIAL_PRECIO").ToString()
                    End If

                    Dim filtro As String = "TRIM(ODP_MATERIAL) = '" & materialItem.Replace("'", "''") & "'" &
                                            " AND TRIM(ODP_PRODUCTO) = '" & productoItem.Replace("'", "''") & "'"
                    Dim filasODP = dtOrdenes.Select(filtro)
                    Dim precioODP As Decimal = 0

                    If filasODP.Length > 0 Then
                        precioODP = Convert.ToDecimal(filasODP(0)("ODP_PRECIO"))
                    Else
                        precioODP = Convert.ToDecimal(dtOrdenes.Rows(0)("ODP_PRECIO"))
                        MostrarMensaje("No se encontro precio especifico. Se uso el primer precio disponible.", False)
                    End If

                    Dim precioODPStr As String = precioODP.ToString("F2", System.Globalization.CultureInfo.InvariantCulture)
                    hfDetalleRecibir.Value = "0"

                    Response.Redirect(ResolveUrl("~/Modules/CatalogoInventario/Stock.aspx") &
                              "?ref=" & proRef &
                              "&pedido=" & pedidoId &
                              "&detpe=" & detalleId &
                              "&hip=" & hipSemillaId &
                              "&precio=" & precioODPStr &
                              "&cantrecibida=" & cantComplemento &
                              "&canttotalrecib=" & cantTotalNueva &
                              "&fromped=1")
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
                MostrarMensaje("Item actualizado correctamente.", False)
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