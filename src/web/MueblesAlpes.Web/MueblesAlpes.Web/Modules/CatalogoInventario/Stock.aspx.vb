Imports System
Imports System.Data

' ============================================================
' RUTA: Modules/CatalogoInventario/Stock.aspx.vb
' ============================================================
Namespace Modules.CatalogoInventario

    Partial Public Class Stock
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarProductos()
                CargarTablaStock()

                ' MODO DESDE PEDIDOS (fromped=1):
                ' Pre-carga producto, bloquea dropdown y guarda parametros en hidden fields.
                Dim fromPed As String = Request.QueryString("fromped")
                If fromPed = "1" Then
                    Dim refParam As String = Request.QueryString("ref")
                    Dim precioParam As String = Request.QueryString("precio")
                    Dim hipParam As String = Request.QueryString("hip")
                    Dim detpeParam As String = Request.QueryString("detpe")
                    Dim pedidoParam As String = Request.QueryString("pedido")
                    Dim cantRecibParam As String = Request.QueryString("cantrecibida")

                    hfFromPed.Value = "1"
                    hfPedParam.Value = If(String.IsNullOrEmpty(pedidoParam), "0", pedidoParam)
                    hfHipSemilla.Value = If(String.IsNullOrEmpty(hipParam), "0", hipParam)
                    hfDetpeParam.Value = If(String.IsNullOrEmpty(detpeParam), "0", detpeParam)
                    hfPrecioODP.Value = If(String.IsNullOrEmpty(precioParam), "0", precioParam)
                    hfCantRecibida.Value = If(String.IsNullOrEmpty(cantRecibParam), "0", cantRecibParam)

                    If Not String.IsNullOrEmpty(refParam) Then
                        Dim item = ddlProducto.Items.FindByValue(refParam)
                        If item IsNot Nothing Then
                            ddlProducto.SelectedValue = refParam
                            ddlProducto.Enabled = False
                            ddlProducto_SelectedIndexChanged(Nothing, EventArgs.Empty)
                        End If
                    End If

                    MostrarExito("Recepcion del Pedido #" & pedidoParam &
                        ". Selecciona almacen y nicho donde ingresa la mercancia. " &
                        "Al confirmar el stock se registrara la cantidad recibida en el pedido.")
                    pnlAvisoPedido.Visible = True
                End If
            End If
        End Sub

        ' =============================================
        ' PASO 1 — PRODUCTO
        ' =============================================
        Private Sub CargarProductos()
            Try
                ddlProducto.DataSource = ProductoService.Listar()
                ddlProducto.DataTextField = "PRO_NOMBRE"
                ddlProducto.DataValueField = "PRO_REFERENCIA"
                ddlProducto.DataBind()
                ddlProducto.Items.Insert(0, New ListItem("-- Seleccione un producto --", ""))
            Catch ex As Exception
                MostrarError("Error al cargar productos: " & ex.Message)
            End Try
        End Sub

        Protected Sub ddlProducto_SelectedIndexChanged(sender As Object, e As EventArgs)
            ResetearDesde(2)
            pnlInfoProducto.Visible = False
            If ddlProducto.SelectedValue = "" Then Return
            Try
                Dim dt As DataTable = ProductoService.Listar()
                Dim fila As DataRow() = dt.Select("PRO_REFERENCIA = '" & ddlProducto.SelectedValue & "'")
                If fila.Length > 0 Then
                    lblTipo.Text = fila(0)("TIP_DESCRIPCION").ToString()
                    lblMaterial.Text = fila(0)("MAT_DESCRIPCION").ToString()
                    pnlInfoProducto.Visible = True
                End If
                CargarAlmacenes()
                pnlPaso2.Visible = True
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' PASO 2 — ALMACEN
        ' =============================================
        Private Sub CargarAlmacenes()
            Try
                ddlAlmacen.DataSource = AlmacenService.Listar()
                ddlAlmacen.DataTextField = "ALM_NOMBRE"
                ddlAlmacen.DataValueField = "ALM_ALMACEN"
                ddlAlmacen.DataBind()
                ddlAlmacen.Items.Insert(0, New ListItem("-- Seleccione un almacen --", ""))
            Catch ex As Exception
                MostrarError("Error al cargar almacenes: " & ex.Message)
            End Try
        End Sub

        Protected Sub ddlAlmacen_SelectedIndexChanged(sender As Object, e As EventArgs)
            ResetearDesde(3)
            If ddlAlmacen.SelectedValue = "" Then Return
            Try
                CargarNichos(Convert.ToDecimal(ddlAlmacen.SelectedValue))
                pnlPaso3.Visible = True
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' PASO 3 — NICHO
        ' =============================================
        Private Sub CargarNichos(almacenId As Decimal)
            Try
                ddlNicho.DataSource = NicAlmService.ListarPorAlmacen(almacenId)
                ddlNicho.DataTextField = "NIC_DISPLAY"
                ddlNicho.DataValueField = "NIC_NICHO"
                ddlNicho.DataBind()
                ddlNicho.Items.Insert(0, New ListItem("-- Seleccione un nicho --", ""))
            Catch ex As Exception
                MostrarError("Error al cargar nichos: " & ex.Message)
            End Try
        End Sub

        Protected Sub ddlNicho_SelectedIndexChanged(sender As Object, e As EventArgs)
            ResetearDesde(4)
            If ddlNicho.SelectedValue = "" Then Return
            Try
                Dim referencia As String = ddlProducto.SelectedValue
                Dim nicId As Decimal = Convert.ToDecimal(ddlNicho.SelectedValue)
                Dim esDesdePedido As Boolean = (hfFromPed.Value = "1")

                If Not esDesdePedido Then
                    Dim dtVigente As DataTable = HistorialPrecioService.Vigente(referencia, nicId)
                    If dtVigente Is Nothing OrElse dtVigente.Rows.Count = 0 Then
                        pnlAvisoPrecio.Visible = True
                        pnlPaso4.Visible = True
                        Return
                    End If
                    hfHipId.Value = dtVigente.Rows(0)("HIP_HISTORIAL_PRECIO").ToString()
                    lblPrecioVigente.Text = String.Format("{0:C2}", dtVigente.Rows(0)("HIP_PRECIO"))
                    pnlPrecioVigente.Visible = True
                End If

                ' En modo fromped: buscar stock directamente por producto+nicho
                ' sin depender del hip vigente, que pudo haber cambiado en recepciones anteriores.
                Dim dtStock As DataTable = Nothing
                If esDesdePedido Then
                    hfHipAnterior.Value = "0"
                    Try
                        Dim dtStockNicho As DataTable = StockService.ObtenerPorNicho(referencia, nicId)
                        If dtStockNicho IsNot Nothing AndAlso dtStockNicho.Rows.Count > 0 Then
                            hfHipAnterior.Value = dtStockNicho.Rows(0)("HIP_HISTORIAL_PRECIO").ToString()
                            dtStock = dtStockNicho
                        End If
                    Catch
                        dtStock = Nothing
                    End Try
                Else
                    Dim dtStockNormal As DataTable = StockService.Obtener(Convert.ToDecimal(hfHipId.Value))
                    dtStock = If(dtStockNormal IsNot Nothing AndAlso dtStockNormal.Rows.Count > 0, dtStockNormal, Nothing)
                End If

                Dim tieneStock As Boolean = (dtStock IsNot Nothing AndAlso dtStock.Rows.Count > 0)

                If tieneStock Then
                    CargarDatosStock(dtStock.Rows(0))

                    If esDesdePedido Then
                        Dim cantRecib As Decimal = Convert.ToDecimal(hfCantRecibida.Value)
                        Dim disponibleActual As Decimal = Convert.ToDecimal(dtStock.Rows(0)("STO_DISPONIBLE"))
                        Dim nuevoDisponible As Decimal = disponibleActual + cantRecib

                        lblSumaInfo.Text = disponibleActual.ToString() & " + " &
                                           cantRecib.ToString() & " = <strong>" &
                                           nuevoDisponible.ToString() & "</strong>"
                        pnlSumaInfo.Visible = True

                        txtCantidadEntrada.Text = cantRecib.ToString()
                        txtCantidadEntrada.ReadOnly = True
                        lblCantEntradaLabel.Text = "Cantidad recibida (desde pedido)"
                        btnEntrada.Text = "Confirmar Recepcion y Volver a Pedidos"

                        txtMinimo.ReadOnly = True
                        txtMaximo.ReadOnly = True
                        pnlEditarLimites.Visible = True
                        btnGuardar.Visible = False
                    End If

                    pnlStockActual.Visible = True
                    pnlSinStock.Visible = False
                Else
                    If esDesdePedido Then
                        Dim cantRecib As String = hfCantRecibida.Value
                        txtDisponibleNuevo.Text = cantRecib
                        txtDisponibleNuevo.ReadOnly = True
                        lblDisponibleNuevoLabel.Text = "Disponible inicial (cantidad recibida)"
                        btnCrearStock.Text = "Confirmar Recepcion y Volver a Pedidos"
                    End If

                    pnlStockActual.Visible = False
                    pnlSinStock.Visible = True
                End If

                pnlPaso4.Visible = True
            Catch ex As Exception
                MostrarError("Error al cargar datos: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarDatosStock(fila As DataRow)
            Dim disponible As Integer = Convert.ToInt32(fila("STO_DISPONIBLE"))
            Dim minimo As Integer = Convert.ToInt32(fila("STO_MINIMO"))
            Dim maximo As Integer = Convert.ToInt32(fila("STO_MAXIMO"))

            lblDisponible.Text = disponible.ToString()
            lblMinimo.Text = minimo.ToString()
            lblMaximo.Text = maximo.ToString()
            txtDisponible.Text = disponible.ToString()
            txtMinimo.Text = minimo.ToString()
            txtMaximo.Text = maximo.ToString()
            txtCantidadEntrada.Text = ""

            If disponible <= minimo Then
                cardDisponible.Attributes("class") = "stock-item bajo"
            ElseIf disponible >= maximo Then
                cardDisponible.Attributes("class") = "stock-item alto"
            Else
                cardDisponible.Attributes("class") = "stock-item"
            End If
        End Sub

        ' =============================================
        ' CREAR STOCK (primera vez)
        ' =============================================
        Protected Sub btnCrearStock_Click(sender As Object, e As EventArgs)
            Dim esDesdePedido As Boolean = (hfFromPed.Value = "1")
            If Not esDesdePedido AndAlso (txtDisponibleNuevo.Text.Trim() = "" OrElse txtMinimoNuevo.Text.Trim() = "" OrElse txtMaximoNuevo.Text.Trim() = "") Then
                MostrarError("Todos los campos son obligatorios.")
                Return
            End If
            If esDesdePedido AndAlso (txtMinimoNuevo.Text.Trim() = "" OrElse txtMaximoNuevo.Text.Trim() = "") Then
                MostrarError("Minimo y maximo son obligatorios.")
                Return
            End If
            Try
                Dim minimo As Decimal = Convert.ToDecimal(txtMinimoNuevo.Text.Trim())
                Dim maximo As Decimal = Convert.ToDecimal(txtMaximoNuevo.Text.Trim())
                Dim disponible As Decimal = Convert.ToDecimal(txtDisponibleNuevo.Text.Trim())

                If hfFromPed.Value = "1" Then
                    Dim hipSemilla As Decimal = Convert.ToDecimal(hfHipSemilla.Value)
                    Dim nichoId As Decimal = Convert.ToDecimal(ddlNicho.SelectedValue)
                    Dim precio As Decimal = Convert.ToDecimal(hfPrecioODP.Value, System.Globalization.CultureInfo.InvariantCulture)
                    Dim fechaHoy As Date = Date.Today
                    Dim proRef As String = ddlProducto.SelectedValue

                    HistorialPrecioService.CerrarTodos(proRef, fechaHoy)
                    HistorialPrecioService.ActualizarSemilla(hipSemilla, nichoId, precio, fechaHoy)

                    Dim cantRecibida As Decimal = Convert.ToDecimal(hfCantRecibida.Value)
                    StockService.Guardar(hipSemilla, minimo, maximo, cantRecibida)

                    Dim detpeId As Integer = Convert.ToInt32(hfDetpeParam.Value)
                    Dim pedidoId As Integer = Convert.ToInt32(hfPedParam.Value)
                    Dim dtDetalle As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
                    Dim filaDetalle = dtDetalle.Select("DETPE_DETALLE_PEDIDO = " & detpeId)
                    Dim cantSol As Integer = If(filaDetalle.Length > 0,
                                               Convert.ToInt32(filaDetalle(0)("DETPE_CANTIDAD_SOLICITADA")),
                                               CInt(cantRecibida))
                    DetallePedidoService.Actualizar(detpeId, cantSol, CInt(cantRecibida))

                    Response.Redirect(ResolveUrl("~/Modules/ComprasProveedor/Pedidos.aspx") &
                                      "?pedido=" & pedidoId)
                Else
                    StockService.Guardar(
                        Convert.ToDecimal(hfHipId.Value),
                        minimo, maximo, disponible
                    )
                    MostrarExito("Stock creado correctamente.")
                    ddlNicho_SelectedIndexChanged(Nothing, EventArgs.Empty)
                    CargarTablaStock()
                End If
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' REGISTRAR ENTRADA DE MERCANCIA
        ' =============================================
        Protected Sub btnEntrada_Click(sender As Object, e As EventArgs)
            Dim esDesdePedido As Boolean = (hfFromPed.Value = "1")

            If Not esDesdePedido AndAlso txtCantidadEntrada.Text.Trim() = "" Then
                MostrarError("Ingresa la cantidad que entro.")
                Return
            End If
            Try
                Dim cantidad As Decimal = If(esDesdePedido,
                                             Convert.ToDecimal(hfCantRecibida.Value),
                                             Convert.ToDecimal(txtCantidadEntrada.Text.Trim()))

                If esDesdePedido Then
                    Dim hipSemilla As Decimal = Convert.ToDecimal(hfHipSemilla.Value)
                    Dim nichoId As Decimal = Convert.ToDecimal(ddlNicho.SelectedValue)
                    Dim precio As Decimal = Convert.ToDecimal(hfPrecioODP.Value, System.Globalization.CultureInfo.InvariantCulture)
                    Dim fechaHoy As Date = Date.Today
                    Dim proRef As String = ddlProducto.SelectedValue

                    Dim hipAnterior As Decimal = If(hfHipAnterior.Value <> "" AndAlso hfHipAnterior.Value <> "0",
                                                         Convert.ToDecimal(hfHipAnterior.Value), 0D)
                    Dim minimoActual As Decimal = 0
                    Dim maximoActual As Decimal = 0
                    Dim disponibleActual As Decimal = 0
                    If hipAnterior > 0 Then
                        Dim dtStockPrev As DataTable = StockService.Obtener(hipAnterior)
                        If dtStockPrev IsNot Nothing AndAlso dtStockPrev.Rows.Count > 0 Then
                            minimoActual = Convert.ToDecimal(dtStockPrev.Rows(0)("STO_MINIMO"))
                            maximoActual = Convert.ToDecimal(dtStockPrev.Rows(0)("STO_MAXIMO"))
                            disponibleActual = Convert.ToDecimal(dtStockPrev.Rows(0)("STO_DISPONIBLE"))
                        End If
                    End If

                    HistorialPrecioService.CerrarTodos(proRef, fechaHoy)
                    HistorialPrecioService.ActualizarSemilla(hipSemilla, nichoId, precio, fechaHoy)

                    Dim nuevoDisponible As Decimal = disponibleActual + cantidad
                    If hipAnterior > 0 Then
                        StockService.Guardar(hipAnterior, minimoActual, maximoActual, nuevoDisponible)
                    Else
                        StockService.Guardar(hipSemilla, minimoActual, maximoActual, nuevoDisponible)
                    End If

                    Dim detpeId As Integer = Convert.ToInt32(hfDetpeParam.Value)
                    Dim pedidoId As Integer = Convert.ToInt32(hfPedParam.Value)
                    Dim dtDetalle As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
                    Dim filaDetalle = dtDetalle.Select("DETPE_DETALLE_PEDIDO = " & detpeId)
                    Dim cantSol As Integer = If(filaDetalle.Length > 0,
                                               Convert.ToInt32(filaDetalle(0)("DETPE_CANTIDAD_SOLICITADA")),
                                               CInt(cantidad))
                    DetallePedidoService.Actualizar(detpeId, cantSol, CInt(cantidad))

                    Response.Redirect(ResolveUrl("~/Modules/ComprasProveedor/Pedidos.aspx") &
                                      "?pedido=" & pedidoId)
                Else
                    StockService.Entrada(Convert.ToDecimal(hfHipId.Value), cantidad)
                    MostrarExito("Entrada registrada. Se sumaron " & cantidad.ToString() & " unidades al disponible.")
                    ddlNicho_SelectedIndexChanged(Nothing, EventArgs.Empty)
                    CargarTablaStock()
                End If
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' GUARDAR LIMITES (min y max)
        ' =============================================
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If txtMinimo.Text.Trim() = "" OrElse txtMaximo.Text.Trim() = "" Then
                MostrarError("Minimo y maximo son obligatorios.")
                Return
            End If
            Try
                StockService.Guardar(
                    Convert.ToDecimal(hfHipId.Value),
                    Convert.ToDecimal(txtMinimo.Text.Trim()),
                    Convert.ToDecimal(txtMaximo.Text.Trim()),
                    Convert.ToDecimal(txtDisponible.Text.Trim())
                )
                MostrarExito("Limites actualizados correctamente.")
                ddlNicho_SelectedIndexChanged(Nothing, EventArgs.Empty)
                CargarTablaStock()
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            ResetearDesde(1)
            pnlMsg.Visible = False
            CargarTablaStock()
        End Sub

        ' =============================================
        ' HABILITAR / CANCELAR EDICION DE LIMITES (modo fromped)
        ' =============================================
        Protected Sub btnEditarLimites_Click(sender As Object, e As EventArgs)
            txtMinimo.ReadOnly = False
            txtMaximo.ReadOnly = False
            btnGuardar.Visible = True
            pnlEditarLimites.Visible = False
            pnlCancelarLimites.Visible = True
            MostrarExito("Puedes editar el minimo y maximo. Luego haz clic en Guardar Limites.")
        End Sub

        Protected Sub btnCancelarLimites_Click(sender As Object, e As EventArgs)
            txtMinimo.ReadOnly = True
            txtMaximo.ReadOnly = True
            btnGuardar.Visible = False
            pnlEditarLimites.Visible = True
            pnlCancelarLimites.Visible = False
            pnlMsg.Visible = False
        End Sub

        ' =============================================
        ' EDITAR MIN/MAX DESDE EL GRIDVIEW
        ' =============================================
        Protected Sub gvStock_RowEditing(sender As Object, e As GridViewEditEventArgs)
            gvStock.EditIndex = e.NewEditIndex
            CargarTablaStock()
        End Sub

        Protected Sub gvStock_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
            gvStock.EditIndex = -1
            CargarTablaStock()
        End Sub

        Protected Sub gvStock_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
            Try
                Dim row As GridViewRow = gvStock.Rows(e.RowIndex)
                Dim hipId As Decimal = Convert.ToDecimal(gvStock.DataKeys(e.RowIndex).Value)

                Dim txtMin As TextBox = CType(row.FindControl("txtGvMinimo"), TextBox)
                Dim txtMax As TextBox = CType(row.FindControl("txtGvMaximo"), TextBox)
                Dim lblDis As Label = CType(row.FindControl("lblGvDisponible"), Label)

                If txtMin Is Nothing OrElse txtMax Is Nothing Then
                    MostrarError("No se encontraron los campos de edicion.") : Return
                End If

                Dim nuevoMin As Decimal
                Dim nuevoMax As Decimal
                If Not Decimal.TryParse(txtMin.Text.Trim(), nuevoMin) OrElse nuevoMin < 0 Then
                    MostrarError("Minimo invalido.") : Return
                End If
                If Not Decimal.TryParse(txtMax.Text.Trim(), nuevoMax) OrElse nuevoMax < 0 Then
                    MostrarError("Maximo invalido.") : Return
                End If
                If nuevoMin > nuevoMax Then
                    MostrarError("El minimo no puede ser mayor al maximo.") : Return
                End If

                Dim disponibleActual As Decimal = 0
                If lblDis IsNot Nothing Then
                    Decimal.TryParse(lblDis.Text, disponibleActual)
                End If

                StockService.Guardar(hipId, nuevoMin, nuevoMax, disponibleActual)
                gvStock.EditIndex = -1
                CargarTablaStock()
                MostrarExito("Limites actualizados correctamente.")
            Catch ex As Exception
                MostrarError("Error al actualizar: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' TABLA
        ' =============================================
        Private Sub CargarTablaStock()
            Try
                gvStock.DataSource = StockService.Listar()
                gvStock.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar stock: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' HELPERS
        ' =============================================
        Private Sub ResetearDesde(paso As Integer)
            If paso <= 2 Then
                pnlPaso2.Visible = False
                ddlAlmacen.Items.Clear()
            End If
            If paso <= 3 Then
                pnlPaso3.Visible = False
                ddlNicho.Items.Clear()
            End If
            If paso <= 4 Then
                pnlPaso4.Visible = False
                pnlPrecioVigente.Visible = False
                pnlAvisoPrecio.Visible = False
                pnlStockActual.Visible = False
                pnlSinStock.Visible = False
                pnlSumaInfo.Visible = False
                pnlEditarLimites.Visible = False
                pnlCancelarLimites.Visible = False
                hfHipId.Value = ""
                hfHipAnterior.Value = ""
                txtDisponible.Text = ""
                txtMinimo.Text = ""
                txtMaximo.Text = ""
                txtMinimo.ReadOnly = False
                txtMaximo.ReadOnly = False
                btnGuardar.Visible = True
                txtCantidadEntrada.Text = ""
                txtCantidadEntrada.ReadOnly = False
                lblCantEntradaLabel.Text = "Cantidad que ingresa *"
                btnEntrada.Text = "Registrar Entrada"
                txtDisponibleNuevo.Text = ""
                txtMinimoNuevo.Text = ""
                txtMaximoNuevo.Text = ""
                btnCrearStock.Text = "Crear Stock"
            End If
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert-ok"
            pnlMsg.Visible = True
        End Sub

    End Class

End Namespace