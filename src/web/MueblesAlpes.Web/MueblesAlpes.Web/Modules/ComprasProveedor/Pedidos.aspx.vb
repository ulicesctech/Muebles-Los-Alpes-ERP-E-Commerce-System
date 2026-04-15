Imports System.Data
Imports MueblesAlpes.Web.Modules.ComprasProveedor

Namespace Modules.ComprasProveedor

    Partial Public Class Pedidos
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPedidos()

                ' Si regresa desde Precios, reabrir el detalle del pedido
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
            lblPrecioSugerido.Text = "--"
            txtPrecioManual.Text = ""
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
            For Each row As DataRow In dt.Rows
                Dim precio As Decimal = If(IsDBNull(row("HIP_PRECIO")), 0D, Convert.ToDecimal(row("HIP_PRECIO")))
                Dim cantidad As Decimal = If(IsDBNull(row("DETPE_CANTIDAD_SOLICITADA")), 0D, Convert.ToDecimal(row("DETPE_CANTIDAD_SOLICITADA")))
                total += precio * cantidad
            Next
            lblTotalDetalle.Text = total.ToString("N2")
            Dim dtPed As DataTable = PedidoService.ObtenerPorId(pedidoId)
            If dtPed IsNot Nothing AndAlso dtPed.Rows.Count > 0 Then
                PedidoService.Actualizar(pedidoId,
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
            If String.IsNullOrEmpty(ddlProducto.SelectedValue) Then
                lblPrecioSugerido.Text = "--"
                txtPrecioManual.Text = ""
                Return
            End If
            Try
                Dim dt As DataTable = DetallePedidoService.ListarTodosProductos()
                Dim filas = dt.Select("PRO_REFERENCIA = '" & ddlProducto.SelectedValue & "'")
                If filas.Length > 0 Then
                    Dim precioSug As Decimal = Convert.ToDecimal(filas(0)("PRECIO_SUGERIDO"))
                    If precioSug > 0 Then
                        lblPrecioSugerido.Text = precioSug.ToString("N2")
                        txtPrecioManual.Text = precioSug.ToString("N2")
                    Else
                        lblPrecioSugerido.Text = "Sin precio vigente"
                        txtPrecioManual.Text = ""
                    End If
                End If
            Catch
                lblPrecioSugerido.Text = "--"
            End Try
        End Sub

        '========================
        ' AGREGAR PRODUCTO
        '========================
        Protected Sub btnAgregarItem_Click(sender As Object, e As EventArgs)
            Try
                Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)
                Dim proRef As String = ddlProducto.SelectedValue
                Dim cantidad As Integer
                Dim precio As Decimal

                If String.IsNullOrEmpty(proRef) Then
                    MostrarMensaje("Selecciona un producto.", True) : Exit Sub
                End If
                If Not Integer.TryParse(txtCantSolicitada.Text, cantidad) OrElse cantidad <= 0 Then
                    MostrarMensaje("Ingresa una cantidad valida.", True) : Exit Sub
                End If
                If Not Decimal.TryParse(txtPrecioManual.Text.Replace(",", "."),
                                        System.Globalization.NumberStyles.Any,
                                        System.Globalization.CultureInfo.InvariantCulture,
                                        precio) OrElse precio <= 0 Then
                    MostrarMensaje("Ingresa un precio valido.", True) : Exit Sub
                End If

                ' Obtener datos del producto
                Dim dt As DataTable = DetallePedidoService.ListarTodosProductos()
                Dim filas = dt.Select("PRO_REFERENCIA = '" & proRef & "'")
                Dim hipId As Integer = 0
                Dim nichoId As Integer = 0

                If filas.Length > 0 Then
                    hipId = Convert.ToInt32(filas(0)("HIP_ID_VIGENTE"))
                    nichoId = Convert.ToInt32(filas(0)("NIC_NICHO_VIGENTE"))
                End If

                If hipId = 0 Then
                    MostrarMensaje("Este producto no tiene precio registrado. Usa 'Registrar Precio' para asignarle uno primero.", True)
                    Exit Sub
                End If

                ' Si precio manual difiere del vigente, registrar nuevo precio
                Dim precioVigente As Decimal = Convert.ToDecimal(filas(0)("PRECIO_SUGERIDO"))
                If precio <> precioVigente Then
                    Dim nuevoHip As Decimal = HistorialPrecioService.Registrar(
                        proRef, nichoId, precio, DateTime.Now
                    )
                    hipId = Convert.ToInt32(nuevoHip)
                End If

                DetallePedidoService.Insertar(pedidoId, hipId, cantidad)

                txtCantSolicitada.Text = ""
                txtPrecioManual.Text = ""
                lblPrecioSugerido.Text = "--"
                ddlProducto.SelectedIndex = 0

                CargarDetallesPedido(pedidoId)
                CargarPedidos()
                MostrarMensaje("Producto agregado correctamente.", False)
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, True)
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
                    CargarDetallesPedido(pedidoId)
                    CargarPedidos()
                    MostrarMensaje("Producto eliminado.", False)
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, True)
                End Try

            ElseIf e.CommandName = "MarcarRecibido" Then
                ' Verificar que tiene una orden de compra asociada
                Dim partes As String() = e.CommandArgument.ToString().Split("|")
                Dim proRef As String = If(partes.Length > 1, partes(1), "")
                Dim precio As String = If(partes.Length > 2, partes(2), "0")

                ' Buscar si existe ODP asociado a este pedido
                Dim dtOrdenes As DataTable = OrdenDetallePedidoService.BuscarPorPedido(pedidoId)
                If dtOrdenes Is Nothing OrElse dtOrdenes.Rows.Count = 0 Then
                    MostrarMensaje("Este pedido no tiene una Orden de Compra asociada. Debes vincularla primero desde Ordenes de Compra.", True)
                    Exit Sub
                End If

                ' Redirigir a Precios con datos pre-cargados y en modo solo-lectura
                Response.Redirect(ResolveUrl("~/Modules/CatalogoInventario/Precios.aspx") &
                          "?ref=" & proRef &
                          "&pedido=" & pedidoId &
                          "&precio=" & precio &
                          "&readonly=1")
            End If
        End Sub

        Protected Sub gvDetalles_RowEditing(sender As Object, e As GridViewEditEventArgs)
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

                ' Solicitada viene del HiddenField — no editable
                Dim hfSol As HiddenField = CType(row.FindControl("hfSolicitadaEdit"), HiddenField)
                Dim txtRec As TextBox = CType(row.FindControl("txtERecibida"), TextBox)

                If hfSol Is Nothing OrElse txtRec Is Nothing Then
                    MostrarMensaje("Error al encontrar los campos.", True)
                    gvDetalles.EditIndex = -1
                    CargarDetallesPedido(pedidoId)
                    Exit Sub
                End If

                Dim solicitada As Integer
                Dim recibida As Integer

                If Not Integer.TryParse(hfSol.Value.Trim(), solicitada) Then solicitada = 0
                If Not Integer.TryParse(txtRec.Text.Trim(), recibida) OrElse recibida < 0 Then
                    MostrarMensaje("Cantidad recibida invalida.", True) : Exit Sub
                End If
                If recibida > solicitada Then
                    MostrarMensaje("La cantidad recibida no puede superar la solicitada (" & solicitada & ").", True)
                    Exit Sub
                End If

                DetallePedidoService.Actualizar(detalleId, solicitada, recibida)
                gvDetalles.EditIndex = -1
                CargarDetallesPedido(pedidoId)
                CargarPedidos()
                MostrarMensaje("Cantidad recibida actualizada.", False)
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