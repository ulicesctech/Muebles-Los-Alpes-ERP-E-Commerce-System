Imports System.Data

Namespace Modules.ComprasProveedor
    Partial Public Class Pedidos
        Inherits System.Web.UI.Page

        ' ─────────────────────────────────────────────
        '  PAGE LOAD
        ' ─────────────────────────────────────────────
        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarGrilla()
            End If
        End Sub

        ' ─────────────────────────────────────────────
        '  CARGA DE DATOS
        ' ─────────────────────────────────────────────
        Private Sub CargarGrilla(Optional texto As String = "")
            Try
                gvPedidos.DataSource = If(String.IsNullOrEmpty(texto),
                                          PedidoService.Listar(),
                                          PedidoService.Buscar(texto))
                gvPedidos.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar pedidos: " & ex.Message)
            End Try
        End Sub

        ''' <summary>
        ''' Carga el DropDownList con los productos disponibles (BOD_HISTORIAL_PRECIO + BOD_PRODUCTO).
        ''' Llama a DetallePedidoService.ListarProductosDisponibles() que ejecuta
        ''' PKG_BOD_DETALLE_PEDIDO.DET_PED_LISTAR_PRODUCTOS.
        ''' </summary>
        Private Sub CargarProductos()
            Try
                ddlProducto.DataSource     = DetallePedidoService.ListarProductosDisponibles()
                ddlProducto.DataTextField  = "PRO_NOMBRE"
                ddlProducto.DataValueField = "HIP_HISTORIAL_PRECIO"
                ddlProducto.DataBind()
                ddlProducto.Items.Insert(0, New ListItem("-- Seleccione un producto --", "0"))
            Catch ex As Exception
                MostrarError("No se pudo cargar la lista de productos: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarDetalles(pedidoId As Integer)
            Try
                Dim dt As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
                gvDetalles.DataSource = dt
                gvDetalles.DataBind()

                ' Recalcular total acumulado
                Dim total As Decimal = 0
                For Each row As DataRow In dt.Rows
                    total += Convert.ToDecimal(row("DETPE_CANTIDAD_SOLICITADA")) *
                             Convert.ToDecimal(row("HIP_PRECIO"))
                Next
                lblTotalDetalle.Text = total.ToString("N2")
                txtTotal.Text        = total.ToString("N2")
            Catch ex As Exception
                MostrarError("Error al cargar detalles: " & ex.Message)
            End Try
        End Sub

        ' ─────────────────────────────────────────────
        '  NUEVO PEDIDO — solo muestra el formulario vacío
        ' ─────────────────────────────────────────────
        Protected Sub btnNuevoPedido_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            pnlFormCabecera.Visible      = True
            pnlDetalleContenedor.Visible = False
            lblTituloForm.Text           = "Nuevo Pedido"
            pnlMsg.Visible               = False
        End Sub

        ' ─────────────────────────────────────────────
        '  GUARDAR CABECERA (CREAR o ACTUALIZAR)
        ' ─────────────────────────────────────────────
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtCodigo.Text) Then
                MostrarError("El código del pedido es obligatorio.")
                Return
            End If

            Try
                Dim id       As Integer = Convert.ToInt32(hfId.Value)
                Dim totalAct As Decimal = If(String.IsNullOrEmpty(txtTotal.Text), 0D,
                                             Convert.ToDecimal(txtTotal.Text))

                If id = 0 Then
                    ' CREAR
                    Dim nuevoId As Integer = PedidoService.Crear(
                                                txtCodigo.Text,
                                                ddlFormaPago.SelectedValue,
                                                totalAct)
                    hfId.Value             = nuevoId.ToString()
                    lblIdSeleccionado.Text = txtCodigo.Text & " (ID: " & nuevoId & ")"
                    lblTituloForm.Text     = "Editando: " & txtCodigo.Text
                    MostrarExito("Pedido creado correctamente. Ahora puede agregar productos.")
                Else
                    ' ACTUALIZAR
                    PedidoService.Actualizar(id, txtCodigo.Text, ddlFormaPago.SelectedValue, totalAct)
                    lblTituloForm.Text = "Editando: " & txtCodigo.Text
                    MostrarExito("Cabecera actualizada correctamente.")
                End If

                ' Mostrar sección de detalle y cargar productos
                CargarProductos()
                pnlDetalleContenedor.Visible = True
                CargarDetalles(Convert.ToInt32(hfId.Value))
                CargarGrilla()
            Catch ex As Exception
                MostrarError("Error al guardar: " & ex.Message)
            End Try
        End Sub

        ' ─────────────────────────────────────────────
        '  GRILLA DE PEDIDOS — Ver / Eliminar
        ' ─────────────────────────────────────────────
        Protected Sub gvPedidos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Dim dt    As DataTable = PedidoService.Listar()
                    Dim filas As DataRow() = dt.Select("PED_PEDIDO = " & id)

                    If filas.Length > 0 Then
                        Dim fila As DataRow = filas(0)

                        hfId.Value                   = id.ToString()
                        txtCodigo.Text               = fila("PED_CODIGO").ToString()
                        ddlFormaPago.SelectedValue   = fila("PED_FORMA_PAGO").ToString()
                        lblTituloForm.Text           = "Editando: " & fila("PED_CODIGO").ToString()
                        lblIdSeleccionado.Text       = fila("PED_CODIGO").ToString() & " (ID: " & id & ")"

                        pnlFormCabecera.Visible      = True
                        pnlDetalleContenedor.Visible = True
                        CargarProductos()
                        CargarDetalles(id)
                        pnlMsg.Visible = False

                        ' Resaltar fila seleccionada en la grilla
                        For Each row As GridViewRow In gvPedidos.Rows
                            row.CssClass = If(Convert.ToInt32(gvPedidos.DataKeys(row.RowIndex).Value) = id,
                                              "row-selected", "")
                        Next
                    End If
                Catch ex As Exception
                    MostrarError("Error al cargar pedido: " & ex.Message)
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    PedidoService.Eliminar(id)
                    If hfId.Value = id.ToString() Then
                        LimpiarFormulario()
                        pnlFormCabecera.Visible      = False
                        pnlDetalleContenedor.Visible = False
                    End If
                    CargarGrilla()
                    MostrarExito("Pedido eliminado correctamente.")
                Catch ex As Exception
                    MostrarError("No se pudo eliminar: " & ex.Message)
                End Try
            End If
        End Sub

        ' ─────────────────────────────────────────────
        '  AGREGAR ÍTEM AL DETALLE
        ' ─────────────────────────────────────────────
        Protected Sub btnAgregarItem_Click(sender As Object, e As EventArgs)
            Try
                Dim idPedido As Integer = Convert.ToInt32(hfId.Value)

                If idPedido = 0 Then
                    Throw New Exception("Primero debe guardar la cabecera del pedido.")
                End If
                If ddlProducto.SelectedValue = "0" OrElse String.IsNullOrEmpty(ddlProducto.SelectedValue) Then
                    Throw New Exception("Seleccione un producto de la lista.")
                End If
                If String.IsNullOrEmpty(txtCantSolicitada.Text) OrElse Not IsNumeric(txtCantSolicitada.Text) OrElse
                   Convert.ToInt32(txtCantSolicitada.Text) <= 0 Then
                    Throw New Exception("Ingrese una cantidad válida (mayor a 0).")
                End If

                DetallePedidoService.Insertar(
                    idPedido,
                    Convert.ToInt32(ddlProducto.SelectedValue),
                    Convert.ToInt32(txtCantSolicitada.Text))

                txtCantSolicitada.Text = ""
                CargarDetalles(idPedido)
                CargarGrilla()
                MostrarExito("Producto agregado al pedido.")
            Catch ex As Exception
                MostrarError(ex.Message)
            End Try
        End Sub

        ' ─────────────────────────────────────────────
        '  ELIMINAR ÍTEM DEL DETALLE
        ' ─────────────────────────────────────────────
        Protected Sub gvDetalles_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "BorrarItem" Then
                Try
                    DetallePedidoService.Eliminar(Convert.ToInt32(e.CommandArgument))
                    CargarDetalles(Convert.ToInt32(hfId.Value))
                    CargarGrilla()
                    MostrarExito("Producto quitado del pedido.")
                Catch ex As Exception
                    MostrarError("Error al quitar producto: " & ex.Message)
                End Try
            End If
        End Sub

        ' ─────────────────────────────────────────────
        '  BÚSQUEDA Y CANCELAR
        ' ─────────────────────────────────────────────
        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            CargarGrilla(txtBuscar.Text.Trim())
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            CargarGrilla()
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            pnlFormCabecera.Visible      = False
            pnlDetalleContenedor.Visible = False
            pnlMsg.Visible               = False
            CargarGrilla()
        End Sub

        ' ─────────────────────────────────────────────
        '  HELPERS
        ' ─────────────────────────────────────────────
        Private Sub LimpiarFormulario()
            hfId.Value             = "0"
            txtCodigo.Text         = ""
            txtTotal.Text          = "0.00"
            lblTotalDetalle.Text   = "0.00"
            ddlFormaPago.SelectedIndex = 0
            lblTituloForm.Text     = "Nuevo Pedido"
            lblIdSeleccionado.Text = ""
            gvDetalles.DataSource  = Nothing
            gvDetalles.DataBind()
        End Sub

        Private Sub MostrarError(m As String)
            lblMsg.Text      = "⚠️ " & m
            pnlMsg.CssClass  = "alert-err"
            pnlMsg.Visible   = True
        End Sub

        Private Sub MostrarExito(m As String)
            lblMsg.Text      = "✅ " & m
            pnlMsg.CssClass  = "alert-ok"
            pnlMsg.Visible   = True
        End Sub

    End Class
End Namespace
