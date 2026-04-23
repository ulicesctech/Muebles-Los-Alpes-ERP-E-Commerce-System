Imports System.Data

Namespace Modules.ComprasProveedor

    Partial Public Class OrdenesCompra
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarOrdenes()
                CargarProveedores()
            End If
        End Sub

        '========================
        ' HELPERS
        '========================
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
            lblMsg.CssClass = If(esError, "alert-err", "alert-ok")
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

        '========================
        ' BOTONES PRINCIPALES
        '========================
        Protected Sub btnNuevaOrden_Click(sender As Object, e As EventArgs)
            CerrarTodosLosPaneles()
            pnlFormCabecera.Visible = True
            txtIDOrden.Text = ""
            txtCodigo.Text = ""
            txtBuscarPedido.Text = ""
            If ddlProveedor.Items.Count > 0 Then ddlProveedor.SelectedIndex = 0
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

        '========================
        ' GUARDAR NUEVA ORDEN
        ' hfMaterial  - columna MATERIAL   del grid ORC_DETALLES_PEDIDO
        ' hfProducto  - columna PRO_NOMBRE del grid ORC_DETALLES_PEDIDO  --NUEVO
        '========================
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Try
                Dim orcKey As String = txtIDOrden.Text.Trim()
                Dim codigo As String = txtCodigo.Text.Trim()
                Dim provId As Decimal = Convert.ToDecimal(ddlProveedor.SelectedValue)

                If String.IsNullOrEmpty(orcKey) Then
                    MostrarMsg("Ingresa el ID de la orden.", True) : Exit Sub
                End If
                If String.IsNullOrEmpty(codigo) Then
                    MostrarMsg("Ingresa el codigo.", True) : Exit Sub
                End If
                If provId = 0 Then
                    MostrarMsg("Selecciona un proveedor.", True) : Exit Sub
                End If

                OrdenCompraService.Crear(orcKey, codigo, provId, 0)
                hfKey.Value = orcKey

                Dim pedId As Integer = Convert.ToInt32(hfPedidoVinculado.Value)
                If pedId > 0 Then
                    Dim itemsInsertados As Integer = 0
                    Dim itemsSinPrecio As Integer = 0

                    For Each row As GridViewRow In gvItemsPedido.Rows
                        Dim txtPrecio As TextBox = CType(row.FindControl("txtPrecioItem"), TextBox)
                        Dim hfMat As HiddenField = CType(row.FindControl("hfMaterial"), HiddenField)
                        Dim hfProd As HiddenField = CType(row.FindControl("hfProducto"), HiddenField)
                        Dim hfCant As HiddenField = CType(row.FindControl("hfCantidad"), HiddenField)

                        If txtPrecio Is Nothing OrElse hfMat Is Nothing OrElse
                           hfProd Is Nothing OrElse hfCant Is Nothing Then
                            Continue For
                        End If

                        Dim precio As Decimal = 0
                        Dim cantidad As Integer = 0
                        Dim material As String = hfMat.Value
                        Dim producto As String = hfProd.Value

                        If Not Decimal.TryParse(txtPrecio.Text.Trim().Replace(",", "."),
                                                System.Globalization.NumberStyles.Any,
                                                System.Globalization.CultureInfo.InvariantCulture, precio) OrElse precio <= 0 Then
                            itemsSinPrecio += 1
                            Continue For
                        End If

                        Integer.TryParse(hfCant.Value, cantidad)
                        If cantidad <= 0 Then cantidad = 1

                        OrdenDetallePedidoService.Insertar(orcKey, pedId, material, producto, precio, cantidad)
                        itemsInsertados += 1
                    Next

                    If itemsSinPrecio > 0 AndAlso itemsInsertados = 0 Then
                        MostrarMsg("Debes ingresar el precio para al menos un item antes de confirmar.", True)
                        OrdenCompraService.Eliminar(orcKey)
                        Exit Sub
                    ElseIf itemsSinPrecio > 0 Then
                        MostrarMsg(itemsInsertados & " item(s) insertados. " & itemsSinPrecio & " item(s) sin precio fueron omitidos.", False)
                    End If
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

                If String.IsNullOrEmpty(lblMsg.Text) Then
                    MostrarMsg("Orden creada correctamente. Puedes agregar mas items o finalizar.", False)
                End If
            Catch ex As Exception
                MostrarMsg("Error: " & ex.Message, True)
            End Try
        End Sub

        '========================
        ' BUSCAR PEDIDOS
        '========================
        Protected Sub btnBuscarPedido_Click(sender As Object, e As EventArgs)
            Dim texto As String = txtBuscarPedido.Text.Trim()
            Dim dt As DataTable = OrdenCompraService.BuscarPedidos(texto)
            gvBuscarPedidos.DataSource = dt
            gvBuscarPedidos.DataBind()
            pnlResultadosPedidos.Visible = True
            pnlItemsPedido.Visible = False
        End Sub

        Protected Sub gvBuscarPedidos_RowDataBound(sender As Object, e As GridViewRowEventArgs)
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim pedId As Integer = Convert.ToInt32(gvBuscarPedidos.DataKeys(e.Row.RowIndex).Value)
                Dim gvSub As GridView = CType(e.Row.FindControl("gvSubItemsBuscar"), GridView)
                If gvSub IsNot Nothing Then
                    Dim dt As DataTable = OrdenCompraService.DetallesPedido(pedId)
                    gvSub.DataSource = dt
                    gvSub.DataBind()
                End If
            End If
        End Sub

        Protected Sub gvBuscarPedidos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "VerItemsPedido" Then
                Dim partes As String() = e.CommandArgument.ToString().Split("|")
                Dim pedId As Integer = Convert.ToInt32(partes(0))
                Dim pedCod As String = If(partes.Length > 1, partes(1), "")

                Dim dt As DataTable = OrdenCompraService.DetallesPedido(pedId)

                hfPedidoVinculado.Value = pedId.ToString()
                lblPedidoId.Text = pedId.ToString()
                lblPedidoCodigo.Text = pedCod

                gvItemsPedido.DataSource = dt
                gvItemsPedido.DataBind()

                pnlItemsPedido.Visible = True
                pnlResultadosPedidos.Visible = False
                txtBuscarPedido.Text = ""
            End If
        End Sub

        Protected Sub lnkQuitarPedido_Click(sender As Object, e As EventArgs)
            hfPedidoVinculado.Value = "0"
            pnlItemsPedido.Visible = False
        End Sub

        '========================
        ' GRID ORDENES PRINCIPAL
        '========================
        Protected Sub gvOrdenes_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "VerDetalle" Then
                Dim orcKey As String = e.CommandArgument.ToString()
                hfOrdenActiva.Value = orcKey
                lblOrdenSeleccionada.Text = orcKey
                pnlDetalleOrden.Visible = True
                pnlFormCabecera.Visible = False
                gvItemsOrden.EditIndex = -1
                CargarDetalle(orcKey)
            End If
        End Sub

        Protected Sub gvOrdenes_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
            Try
                Dim orcKey As String = gvOrdenes.DataKeys(e.RowIndex).Value.ToString()
                OrdenCompraService.Eliminar(orcKey)
                If hfOrdenActiva.Value = orcKey Then pnlDetalleOrden.Visible = False
                CargarOrdenes()
                MostrarMsg("Orden eliminada.", False)
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

        '========================
        ' GRID ITEMS DETALLE ORDEN
        '========================
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

        Protected Sub gvItemsOrden_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "BorrarItem" Then
                Try
                    OrdenDetallePedidoService.Eliminar(Convert.ToInt32(e.CommandArgument))
                    CargarDetalle(hfOrdenActiva.Value)
                    ActualizarTotalOrden(hfOrdenActiva.Value)
                    CargarOrdenes()
                Catch ex As Exception
                    MostrarMsg("Error: " & ex.Message, True)
                End Try
            End If
        End Sub

        '========================
        ' BUSCAR / LIMPIAR ORDENES
        '========================
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