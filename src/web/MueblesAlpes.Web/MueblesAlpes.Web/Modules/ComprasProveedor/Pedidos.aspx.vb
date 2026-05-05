Imports Oracle.ManagedDataAccess.Client

Namespace Modules.ComprasProveedor

    Public Class Pedidos
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPedidos()
            End If
        End Sub

        Private Sub CargarPedidos()
            gvPedidos.EditIndex = -1
            gvPedidos.DataSource = PedidoService.Listar()
            gvPedidos.DataBind()
        End Sub

        Private Sub CargarProductos()
            Dim dt As DataTable = DetallePedidoService.ListarProductosDisponibles()
            ddlProducto.DataSource = dt
            ddlProducto.DataTextField = "PRO_NOMBRE"
            ddlProducto.DataValueField = "HIP_HISTORIAL_PRECIO"
            ddlProducto.DataBind()
            ddlProducto.Items.Insert(0, New ListItem("-- Seleccione producto --", "0"))
        End Sub

        Private Sub CargarDetallesPedido(pedidoId As Integer)
            gvDetalles.EditIndex = -1
            Dim dt As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
            gvDetalles.DataSource = dt
            gvDetalles.DataBind()
            RecalcularYActualizarTotal(dt, pedidoId)
        End Sub

        Private Sub CargarInfoCabecera(pedidoId As Integer)
            Dim dtPed As DataTable = PedidoService.ObtenerPorId(pedidoId)
            If dtPed IsNot Nothing AndAlso dtPed.Rows.Count > 0 Then
                lblCabeceraCode.Text = dtPed.Rows(0)("PED_CODIGO").ToString()
                lblCabeceraFecha.Text = String.Format("{0:dd/MM/yyyy}", dtPed.Rows(0)("PED_FECHA"))
                lblCabeceraFormaPago.Text = dtPed.Rows(0)("PED_FORMA_PAGO").ToString()
            End If
        End Sub

        Private Sub RecalcularYActualizarTotal(dt As DataTable, pedidoId As Integer)
            Dim total As Decimal = 0
            For Each row As DataRow In dt.Rows
                total += Convert.ToDecimal(row("DETPE_CANTIDAD_SOLICITADA")) * Convert.ToDecimal(row("DETPE_PRECIO_UNITARIO"))
            Next
            lblTotalDetalle.Text = total.ToString("N2")
            Dim dtPed As DataTable = PedidoService.ObtenerPorId(pedidoId)
            If dtPed IsNot Nothing AndAlso dtPed.Rows.Count > 0 Then
                Dim codigo As String = dtPed.Rows(0)("PED_CODIGO").ToString()
                Dim formaPago As String = dtPed.Rows(0)("PED_FORMA_PAGO").ToString()
                PedidoService.Actualizar(pedidoId, codigo, formaPago, total)
            End If
        End Sub

        Private Sub MostrarMensaje(msg As String, esError As Boolean)
            lblMsg.Text = msg
            lblMsg.CssClass = If(esError, "alert-err", "alert-ok")
            pnlMsg.Visible = True
        End Sub

        Private Sub OcultarMensaje()
            pnlMsg.Visible = False
        End Sub

        Private Sub BloquearCabecera()
            txtCodigo.ReadOnly = True
            ddlFormaPago.Enabled = False
            btnGuardar.Enabled = False
        End Sub

        Private Sub DesbloquearCabecera()
            txtCodigo.ReadOnly = False
            ddlFormaPago.Enabled = True
            btnGuardar.Enabled = True
        End Sub

        Protected Sub btnNuevoPedido_Click(sender As Object, e As EventArgs)
            OcultarMensaje()
            hfPedidoActivo.Value = "0"
            txtCodigo.Text = ""
            ddlFormaPago.SelectedIndex = 0
            DesbloquearCabecera()
            pnlFormCabecera.Visible = True
            pnlDetalleContenedor.Visible = False
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            OcultarMensaje()
            Try
                If String.IsNullOrEmpty(txtCodigo.Text.Trim()) Then
                    MostrarMensaje("Ingrese el codigo del pedido.", True)
                    Exit Sub
                End If
                Dim nuevoId As Decimal = PedidoService.Crear(txtCodigo.Text.Trim(), ddlFormaPago.SelectedValue, 0)
                hfPedidoActivo.Value = nuevoId.ToString()
                lblIdSeleccionado.Text = nuevoId.ToString()
                CargarProductos()
                CargarDetallesPedido(Convert.ToInt32(nuevoId))
                CargarInfoCabecera(Convert.ToInt32(nuevoId))
                BloquearCabecera()
                pnlDetalleContenedor.Visible = True
                CargarPedidos()
                MostrarMensaje("Pedido #" & nuevoId & " creado. Agrega los productos.", False)
            Catch ex As Exception
                MostrarMensaje("Error al crear pedido: " & ex.Message, True)
            End Try
        End Sub

        Protected Sub gvPedidos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            OcultarMensaje()
            If e.CommandName = "VerDetalle" OrElse e.CommandName = "Editar" Then
                Dim pedidoId As Integer = Convert.ToInt32(e.CommandArgument)
                hfPedidoActivo.Value = pedidoId.ToString()
                lblIdSeleccionado.Text = pedidoId.ToString()
                CargarProductos()
                CargarDetallesPedido(pedidoId)
                CargarInfoCabecera(pedidoId)
                pnlDetalleContenedor.Visible = True
                pnlFormCabecera.Visible = False

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    PedidoService.Eliminar(Convert.ToInt32(e.CommandArgument))
                    CargarPedidos()
                    pnlDetalleContenedor.Visible = False
                    MostrarMensaje("Pedido eliminado.", False)
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, True)
                End Try

            ElseIf e.CommandName = "Recibir" Then
                Try
                    Dim pedidoId As Integer = Convert.ToInt32(e.CommandArgument)
                    Using conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
                        Using cmdRec As New OracleCommand("PKG_CP_BOD_PEDIDO.PED_RECIBIR_TODO", conn)
                            cmdRec.CommandType = CommandType.StoredProcedure
                            cmdRec.Parameters.Add("p_ped_id", OracleDbType.Decimal).Value = pedidoId
                            conn.Open()
                            cmdRec.ExecuteNonQuery()
                        End Using
                    End Using
                    CargarPedidos()
                    MostrarMensaje("Pedido #" & pedidoId & " recibido. Stock actualizado.", False)
                Catch ex As OracleException
                    MostrarMensaje("Error Oracle: " & ex.Message & " | Código: " & ex.Number, True)
                Catch ex As Exception
                    MostrarMensaje("Error general: " & ex.Message, True)
                End Try
            End If
        End Sub

        Protected Sub gvPedidos_RowDataBound(sender As Object, e As GridViewRowEventArgs)
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim pedidoId As Integer = Convert.ToInt32(gvPedidos.DataKeys(e.Row.RowIndex).Value)
                Dim gvSub As GridView = CType(e.Row.FindControl("gvSubDetalles"), GridView)
                If gvSub IsNot Nothing Then
                    Dim dt As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
                    gvSub.DataSource = dt
                    gvSub.DataBind()
                    gvSub.Visible = (dt.Rows.Count > 0)
                End If
            End If
        End Sub

        Protected Sub btnAgregarItem_Click(sender As Object, e As EventArgs)
            OcultarMensaje()
            Try
                Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)
                Dim historialId As Integer = Convert.ToInt32(ddlProducto.SelectedValue)
                Dim cantidad As Integer = 0
                Dim precio As Decimal = 0

                If Not Integer.TryParse(txtCantSolicitada.Text, cantidad) OrElse cantidad <= 0 Then
                    MostrarMensaje("Ingrese una cantidad valida mayor a cero.", True)
                    Return
                End If
                If Not Decimal.TryParse(txtPrecioUnitario.Text.Replace(",", "."), precio) OrElse precio <= 0 Then
                    MostrarMensaje("Ingrese un precio de compra valido mayor a cero.", True)
                    Return
                End If
                If historialId = 0 Then
                    MostrarMensaje("Seleccione un producto.", True)
                    Return
                End If
                If pedidoId > 0 Then
                    DetallePedidoService.Insertar(pedidoId, historialId, cantidad, precio)
                    txtCantSolicitada.Text = ""
                    txtPrecioUnitario.Text = ""
                    CargarDetallesPedido(pedidoId)
                    CargarPedidos()
                    MostrarMensaje("Producto agregado.", False)
                End If
            Catch ex As Exception
                MostrarMensaje("Error al agregar producto: " & ex.Message, True)
            End Try
        End Sub

        Protected Sub gvDetalles_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "BorrarItem" Then
                Try
                    Dim detalleId As Integer = Convert.ToInt32(e.CommandArgument)
                    Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)
                    DetallePedidoService.Eliminar(detalleId)
                    CargarDetallesPedido(pedidoId)
                    CargarPedidos()
                    MostrarMensaje("Producto removido.", False)
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, True)
                End Try
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
                Dim pedidoId As Integer = Convert.ToInt32(hfPedidoActivo.Value)
                Dim row As GridViewRow = gvDetalles.Rows(e.RowIndex)
                Dim detalleId As Integer = Convert.ToInt32(gvDetalles.DataKeys(e.RowIndex).Value)
                Dim cantSol As Integer
                Dim cantRec As Integer
                Dim precio As Decimal

                If Not Integer.TryParse(CType(row.FindControl("txtECantSol"), TextBox).Text, cantSol) OrElse cantSol < 0 Then
                    MostrarMensaje("Cantidad solicitada invalida.", True) : Return
                End If
                If Not Integer.TryParse(CType(row.FindControl("txtECantRec"), TextBox).Text, cantRec) OrElse cantRec < 0 Then
                    MostrarMensaje("Cantidad recibida invalida.", True) : Return
                End If
                If Not Decimal.TryParse(CType(row.FindControl("txtEPrecio"), TextBox).Text.Replace(",", "."), precio) OrElse precio < 0 Then
                    MostrarMensaje("Precio unitario invalido.", True) : Return
                End If

                DetallePedidoService.Actualizar(detalleId, cantSol, cantRec, precio)
                gvDetalles.EditIndex = -1
                CargarDetallesPedido(pedidoId)
                CargarPedidos()
                MostrarMensaje("Item actualizado.", False)
            Catch ex As Exception
                MostrarMensaje("Error al guardar: " & ex.Message, True)
            End Try
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            OcultarMensaje()
            gvPedidos.DataSource = PedidoService.Buscar(txtBuscar.Text.Trim())
            gvPedidos.DataBind()
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            OcultarMensaje()
            CargarPedidos()
        End Sub

        Protected Sub btnCerrarDetalle_Click(sender As Object, e As EventArgs)
            pnlDetalleContenedor.Visible = False
            pnlFormCabecera.Visible = False
            DesbloquearCabecera()
            OcultarMensaje()
            CargarPedidos()
        End Sub

    End Class

End Namespace