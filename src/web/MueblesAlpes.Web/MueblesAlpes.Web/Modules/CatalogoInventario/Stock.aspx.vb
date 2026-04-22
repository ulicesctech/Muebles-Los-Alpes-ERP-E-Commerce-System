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
                            pnlPaso1.Visible = True
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
        ' HELPER — Resolver HIP para recepcion de pedido
        '
        ' Logica:
        '   1. Busca si ya existe un HIP vigente REAL para el producto
        '      (precio NOT NULL, fecha_final IS NULL) en cualquier nicho.
        '   2. Si existe y el precio coincide con el del pedido:
        '      -> reutiliza ese HIP. Solo actualiza la semilla para apuntar
        '         al mismo nicho/precio sin crear un nuevo registro.
        '         Devuelve el HIP vigente existente.
        '   3. Si no existe vigente o el precio es diferente:
        '      -> ejecuta flujo normal: CerrarTodos + ActualizarSemilla.
        '         Devuelve el HIP de la semilla actualizada.
        ' =============================================
        Private Function ResolverHipParaRecepcion(proRef As String,
                                                   hipSemilla As Decimal,
                                                   nichoId As Decimal,
                                                   precioNuevo As Decimal,
                                                   fechaHoy As Date) As Decimal
            ' Buscar vigente real del producto en el nicho destino
            Dim dtVigenteNicho As DataTable = HistorialPrecioService.Vigente(proRef, nichoId)

            If dtVigenteNicho IsNot Nothing AndAlso dtVigenteNicho.Rows.Count > 0 Then
                Dim precioVigente As Decimal = Convert.ToDecimal(dtVigenteNicho.Rows(0)("HIP_PRECIO"))
                Dim hipVigente As Decimal = Convert.ToDecimal(dtVigenteNicho.Rows(0)("HIP_HISTORIAL_PRECIO"))

                If precioVigente = precioNuevo Then
                    ' Precio igual al vigente: cerrar solo la semilla (sin tocar el vigente real)
                    ' y devolver el HIP vigente existente para asociar el stock.
                    ' La semilla se cierra para no dejarla huerfana.
                    HistorialPrecioService.CerrarSemilla(hipSemilla, fechaHoy)
                    Return hipVigente
                End If
            End If

            ' Precio diferente o no hay vigente: flujo normal
            HistorialPrecioService.CerrarTodos(proRef, fechaHoy)
            HistorialPrecioService.ActualizarSemilla(hipSemilla, nichoId, precioNuevo, fechaHoy)
            Return hipSemilla
        End Function

        ' =============================================
        ' PASO 1 — PRODUCTO (solo fromped)
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

                hfHipAnterior.Value = "0"
                Dim dtStock As DataTable = Nothing
                Try
                    Dim dtStockNicho As DataTable = StockService.ObtenerPorNicho(referencia, nicId)
                    If dtStockNicho IsNot Nothing AndAlso dtStockNicho.Rows.Count > 0 Then
                        hfHipAnterior.Value = dtStockNicho.Rows(0)("HIP_HISTORIAL_PRECIO").ToString()
                        dtStock = dtStockNicho
                    End If
                Catch
                    dtStock = Nothing
                End Try

                Dim tieneStock As Boolean = (dtStock IsNot Nothing AndAlso dtStock.Rows.Count > 0)

                If tieneStock Then
                    CargarDatosStock(dtStock.Rows(0))

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

                    pnlEntradaMercancia.Visible = True
                    pnlStockActual.Visible = True
                    pnlSinStock.Visible = False
                Else
                    txtDisponibleNuevo.Text = hfCantRecibida.Value
                    txtDisponibleNuevo.ReadOnly = True
                    lblDisponibleNuevoLabel.Text = "Disponible inicial (cantidad recibida)"
                    btnCrearStock.Text = "Confirmar Recepcion y Volver a Pedidos"
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
        ' CREAR STOCK (primera vez — solo desde Pedidos)
        ' =============================================
        Protected Sub btnCrearStock_Click(sender As Object, e As EventArgs)
            If hfFromPed.Value <> "1" Then
                MostrarError("El registro de stock solo esta disponible desde Pedidos.")
                Return
            End If
            If txtMinimoNuevo.Text.Trim() = "" OrElse txtMaximoNuevo.Text.Trim() = "" Then
                MostrarError("Minimo y maximo son obligatorios.")
                Return
            End If
            Try
                Dim minimo As Decimal = Convert.ToDecimal(txtMinimoNuevo.Text.Trim())
                Dim maximo As Decimal = Convert.ToDecimal(txtMaximoNuevo.Text.Trim())
                Dim hipSemilla As Decimal = Convert.ToDecimal(hfHipSemilla.Value)
                Dim nichoId As Decimal = Convert.ToDecimal(ddlNicho.SelectedValue)
                Dim precio As Decimal = Convert.ToDecimal(hfPrecioODP.Value, System.Globalization.CultureInfo.InvariantCulture)
                Dim fechaHoy As Date = Date.Today
                Dim proRef As String = ddlProducto.SelectedValue
                Dim cantRecibida As Decimal = Convert.ToDecimal(hfCantRecibida.Value)

                ' Resolver HIP: reusar vigente si precio igual, o crear nuevo si diferente
                Dim hipFinal As Decimal = ResolverHipParaRecepcion(proRef, hipSemilla, nichoId, precio, fechaHoy)

                StockService.Guardar(hipFinal, minimo, maximo, cantRecibida)

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
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' REGISTRAR ENTRADA DE MERCANCIA — solo desde Pedidos
        ' =============================================
        Protected Sub btnEntrada_Click(sender As Object, e As EventArgs)
            If hfFromPed.Value <> "1" Then
                MostrarError("El registro de entradas solo esta disponible desde Pedidos.")
                Return
            End If
            Try
                Dim cantidad As Decimal = Convert.ToDecimal(hfCantRecibida.Value)
                Dim hipSemilla As Decimal = Convert.ToDecimal(hfHipSemilla.Value)
                Dim nichoId As Decimal = Convert.ToDecimal(ddlNicho.SelectedValue)
                Dim precio As Decimal = Convert.ToDecimal(hfPrecioODP.Value, System.Globalization.CultureInfo.InvariantCulture)
                Dim fechaHoy As Date = Date.Today
                Dim proRef As String = ddlProducto.SelectedValue

                ' Resolver HIP: reusar vigente si precio igual, o crear nuevo si diferente
                Dim hipFinal As Decimal = ResolverHipParaRecepcion(proRef, hipSemilla, nichoId, precio, fechaHoy)

                ' Obtener minimo/maximo/disponible actuales del stock asociado al HIP resuelto
                Dim minimoActual As Decimal = 0
                Dim maximoActual As Decimal = 0
                Dim disponibleActual As Decimal = 0

                Dim hipAnterior As Decimal = If(hfHipAnterior.Value <> "" AndAlso hfHipAnterior.Value <> "0",
                                                 Convert.ToDecimal(hfHipAnterior.Value), 0D)
                Dim hipParaStock As Decimal = If(hipAnterior > 0, hipAnterior, hipFinal)

                Dim dtStockPrev As DataTable = StockService.Obtener(hipParaStock)
                If dtStockPrev IsNot Nothing AndAlso dtStockPrev.Rows.Count > 0 Then
                    minimoActual = Convert.ToDecimal(dtStockPrev.Rows(0)("STO_MINIMO"))
                    maximoActual = Convert.ToDecimal(dtStockPrev.Rows(0)("STO_MAXIMO"))
                    disponibleActual = Convert.ToDecimal(dtStockPrev.Rows(0)("STO_DISPONIBLE"))
                End If

                Dim nuevoDisponible As Decimal = disponibleActual + cantidad
                StockService.Guardar(hipFinal, minimoActual, maximoActual, nuevoDisponible)

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
                If lblDis IsNot Nothing Then Decimal.TryParse(lblDis.Text, disponibleActual)

                StockService.Guardar(hipId, nuevoMin, nuevoMax, disponibleActual)
                gvStock.EditIndex = -1
                CargarTablaStock()
                MostrarExito("Limites actualizados correctamente.")
            Catch ex As Exception
                MostrarError("Error al actualizar: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' TRASLADO DE STOCK — iniciado desde el gridview
        ' =============================================
        Protected Sub gvStock_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "Trasladar" Then
                Dim hipOrigen As Decimal = Convert.ToDecimal(e.CommandArgument)
                Try
                    Dim dtOrigen As DataTable = StockService.Obtener(hipOrigen)
                    If dtOrigen Is Nothing OrElse dtOrigen.Rows.Count = 0 Then
                        MostrarError("No se pudo obtener el stock de este registro.")
                        Return
                    End If

                    Dim dispOrigen As Decimal = Convert.ToDecimal(dtOrigen.Rows(0)("STO_DISPONIBLE"))
                    If dispOrigen <= 0 Then
                        MostrarError("No hay stock disponible en este nicho para trasladar.")
                        Return
                    End If

                    hfHipOrigen.Value = hipOrigen.ToString()
                    hfMinOrigen.Value = dtOrigen.Rows(0)("STO_MINIMO").ToString()
                    hfMaxOrigen.Value = dtOrigen.Rows(0)("STO_MAXIMO").ToString()
                    hfDispOrigen.Value = dispOrigen.ToString()

                    lblOrigenInfo.Text = " " & dtOrigen.Rows(0)("PRO_NOMBRE").ToString() &
                                         " — " & dtOrigen.Rows(0)("ALM_NOMBRE").ToString() &
                                         " / " & dtOrigen.Rows(0)("NIC_NUMERO").ToString() &
                                         " | Disponible: " & dispOrigen.ToString() &
                                         " | Min: " & dtOrigen.Rows(0)("STO_MINIMO").ToString() &
                                         " | Max: " & dtOrigen.Rows(0)("STO_MAXIMO").ToString()

                    hfProductoTraslado.Value = dtOrigen.Rows(0)("PRO_REFERENCIA").ToString()

                    ddlAlmacenDestino.DataSource = AlmacenService.Listar()
                    ddlAlmacenDestino.DataTextField = "ALM_NOMBRE"
                    ddlAlmacenDestino.DataValueField = "ALM_ALMACEN"
                    ddlAlmacenDestino.DataBind()
                    ddlAlmacenDestino.Items.Insert(0, New ListItem("-- Seleccione almacen destino --", ""))
                    ddlNichoDestino.Items.Clear()
                    ddlNichoDestino.Items.Add(New ListItem("-- Primero seleccione almacen --", ""))
                    txtCantidadTraslado.Text = ""
                    pnlResumenDestino.Visible = False
                    pnlDestinoSinStock.Visible = False
                    pnlTraslado.Visible = True
                    pnlMsg.Visible = False
                Catch ex As Exception
                    MostrarError("Error al iniciar traslado: " & ex.Message)
                End Try
            End If
        End Sub

        Protected Sub ddlAlmacenDestino_SelectedIndexChanged(sender As Object, e As EventArgs)
            ddlNichoDestino.Items.Clear()
            pnlResumenDestino.Visible = False
            pnlDestinoSinStock.Visible = False
            If ddlAlmacenDestino.SelectedValue = "" Then
                ddlNichoDestino.Items.Add(New ListItem("-- Primero seleccione almacen --", ""))
                Return
            End If
            Try
                Dim almDestinoId As Decimal = Convert.ToDecimal(ddlAlmacenDestino.SelectedValue)
                Dim dtStockProducto As DataTable = StockService.ListarPorProducto(hfProductoTraslado.Value)
                Dim tieneStockEnAlmacen As Boolean = False
                If dtStockProducto IsNot Nothing Then
                    Dim nichosFila As DataTable = NicAlmService.ListarPorAlmacen(almDestinoId)
                    For Each fila As DataRow In dtStockProducto.Rows
                        If fila("HIP_HISTORIAL_PRECIO").ToString() <> hfHipOrigen.Value Then
                            For Each nicFila As DataRow In nichosFila.Rows
                                If fila("NIC_NICHO").ToString() = nicFila("NIC_NICHO").ToString() Then
                                    tieneStockEnAlmacen = True
                                    Exit For
                                End If
                            Next
                        End If
                        If tieneStockEnAlmacen Then Exit For
                    Next
                End If

                If Not tieneStockEnAlmacen Then
                    MostrarError("El almacen seleccionado no tiene stock registrado para este producto. Selecciona otro almacen.")
                    ddlAlmacenDestino.SelectedIndex = 0
                    ddlNichoDestino.Items.Clear()
                    ddlNichoDestino.Items.Add(New ListItem("-- Primero seleccione almacen --", ""))
                    Return
                End If

                ddlNichoDestino.DataSource = NicAlmService.ListarPorAlmacen(almDestinoId)
                ddlNichoDestino.DataTextField = "NIC_DISPLAY"
                ddlNichoDestino.DataValueField = "NIC_NICHO"
                ddlNichoDestino.DataBind()
                ddlNichoDestino.Items.Insert(0, New ListItem("-- Seleccione nicho destino --", ""))
            Catch ex As Exception
                MostrarError("Error al cargar nichos destino: " & ex.Message)
            End Try
        End Sub

        Protected Sub ddlNichoDestino_SelectedIndexChanged(sender As Object, e As EventArgs)
            pnlResumenDestino.Visible = False
            pnlDestinoSinStock.Visible = False
            If ddlNichoDestino.SelectedValue = "" Then Return

            Dim nicDestinoId As Decimal = Convert.ToDecimal(ddlNichoDestino.SelectedValue)
            Dim referencia As String = hfProductoTraslado.Value

            Try
                Dim dtDest As DataTable = StockService.ObtenerPorNicho(referencia, nicDestinoId)
                If dtDest IsNot Nothing AndAlso dtDest.Rows.Count > 0 Then
                    If dtDest.Rows(0)("HIP_HISTORIAL_PRECIO").ToString() = hfHipOrigen.Value Then
                        MostrarError("El nicho destino no puede ser el mismo que el origen.")
                        ddlNichoDestino.SelectedIndex = 0
                        Return
                    End If
                    hfHipDestino.Value = dtDest.Rows(0)("HIP_HISTORIAL_PRECIO").ToString()
                    hfMinDestino.Value = dtDest.Rows(0)("STO_MINIMO").ToString()
                    hfMaxDestino.Value = dtDest.Rows(0)("STO_MAXIMO").ToString()
                    hfDispDestino.Value = dtDest.Rows(0)("STO_DISPONIBLE").ToString()

                    lblResumenDispDestino.Text = dtDest.Rows(0)("STO_DISPONIBLE").ToString()
                    lblResumenMinDestino.Text = dtDest.Rows(0)("STO_MINIMO").ToString()
                    lblResumenMaxDestino.Text = dtDest.Rows(0)("STO_MAXIMO").ToString()
                    pnlResumenDestino.Visible = True
                Else
                    MostrarError("Este nicho no tiene stock registrado para este producto. Elige otro nicho del mismo almacen.")
                    ddlNichoDestino.SelectedIndex = 0
                End If
            Catch ex As Exception
                MostrarError("Error al verificar destino: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnConfirmarTraslado_Click(sender As Object, e As EventArgs)
            Try
                Dim hipOrigen As Decimal = Convert.ToDecimal(hfHipOrigen.Value)
                Dim dispOrigen As Decimal = Convert.ToDecimal(hfDispOrigen.Value)
                Dim minOrigen As Decimal = Convert.ToDecimal(hfMinOrigen.Value)
                Dim maxOrigen As Decimal = Convert.ToDecimal(hfMaxOrigen.Value)

                Dim cantidad As Decimal
                If Not Decimal.TryParse(txtCantidadTraslado.Text.Trim(), cantidad) OrElse cantidad <= 0 Then
                    MostrarError("Ingresa una cantidad valida mayor a 0.") : Return
                End If

                If cantidad > dispOrigen Then
                    MostrarError("La cantidad supera el disponible del origen (" & dispOrigen.ToString() & ").") : Return
                End If
                If (dispOrigen - cantidad) < minOrigen Then
                    MostrarError("El traslado dejaria el origen por debajo de su minimo (" & minOrigen.ToString() & "). " &
                                 "Maximo trasladable: " & (dispOrigen - minOrigen).ToString() & " unidades.") : Return
                End If

                If hfHipDestino.Value = "" OrElse hfHipDestino.Value = "0" Then
                    MostrarError("Selecciona un nicho destino valido con stock registrado.") : Return
                End If

                Dim hipDestino As Decimal = Convert.ToDecimal(hfHipDestino.Value)
                Dim minDestino As Decimal = Convert.ToDecimal(hfMinDestino.Value)
                Dim maxDestino As Decimal = Convert.ToDecimal(hfMaxDestino.Value)
                Dim dispDestino As Decimal = Convert.ToDecimal(hfDispDestino.Value)

                If maxDestino > 0 AndAlso (dispDestino + cantidad) > maxDestino Then
                    MostrarError("La cantidad superaria el maximo del destino (" & maxDestino.ToString() & "). " &
                                 "Maximo que puede recibir: " & (maxDestino - dispDestino).ToString() & " unidades.") : Return
                End If

                StockService.Guardar(hipOrigen, minOrigen, maxOrigen, dispOrigen - cantidad)
                StockService.Guardar(hipDestino, minDestino, maxDestino, dispDestino + cantidad)

                MostrarExito("Traslado exitoso. Se movieron " & cantidad.ToString() & " unidades.")
                pnlTraslado.Visible = False
                CargarTablaStock()
            Catch ex As Exception
                MostrarError("Error al confirmar traslado: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelarTraslado_Click(sender As Object, e As EventArgs)
            pnlTraslado.Visible = False
            pnlMsg.Visible = False
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
                pnlEntradaMercancia.Visible = True
                pnlEditarLimites.Visible = False
                pnlCancelarLimites.Visible = False
                pnlTraslado.Visible = False
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