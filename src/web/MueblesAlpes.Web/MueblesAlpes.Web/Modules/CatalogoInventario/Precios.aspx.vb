Imports System
Imports System.Data

' ============================================================
' RUTA: Modules/CatalogoInventario/Precios.aspx.vb
' ============================================================
Namespace Modules.CatalogoInventario

    Partial Public Class Precios
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarProductos()
                CargarAlmacenes()
                CargarFiltroMes()
                LimpiarNichos()
                txtFechaInicio.Text = DateTime.Now.ToString("yyyy-MM-dd")
                CargarHistorialTodos()

                Dim refParam As String = Request.QueryString("ref")
                Dim precioParam As String = Request.QueryString("precio")
                Dim readonlyParam As String = Request.QueryString("readonly")

                ' *** CAMBIE AHORITA: se leen los nuevos parametros hip y detpe del QueryString.
                ' hip   = ID del BOD_HISTORIAL_PRECIO semilla creado al agregar el item al pedido.
                ' detpe = ID del BOD_DETALLE_PEDIDO (referencia para trazabilidad).
                Dim hipParam As String = Request.QueryString("hip")
                Dim detpeParam As String = Request.QueryString("detpe")
                ' *** FIN CAMBIE AHORITA

                If Not String.IsNullOrEmpty(refParam) Then
                    Dim item = ddlProducto.Items.FindByValue(refParam)
                    If item IsNot Nothing Then
                        ddlProducto.SelectedValue = refParam
                        ddlProducto_SelectedIndexChanged(Nothing, EventArgs.Empty)
                    End If
                End If

                ' Modo solo-lectura: viene desde Pedidos → Recibido
                If readonlyParam = "1" Then
                    ddlProducto.Enabled = False
                    txtFechaInicio.ReadOnly = True

                    ' *** CAMBIE AHORITA: se guardan hip y detpe en los hidden fields del ASPX
                    ' para que btnRegistrar_Click los use al momento de confirmar el precio.
                    hfHipSemilla.Value = If(String.IsNullOrEmpty(hipParam), "0", hipParam)
                    hfDetpeId.Value = If(String.IsNullOrEmpty(detpeParam), "0", detpeParam)
                    ' *** FIN CAMBIE AHORITA

                    ' Pre-cargar precio desde la Orden de Compra (no editable)
                    If Not String.IsNullOrEmpty(precioParam) Then
                        txtPrecio.Text = precioParam
                        txtPrecio.ReadOnly = True
                    End If

                    ' *** CAMBIE AHORITA: se carga Producto y Material desde BOD_PRODUCTO
                    ' usando la pro_referencia del QueryString y se muestran en el panel
                    ' readonly pnlReadonlyProducto (no editable). El dropdown se oculta.
                    If Not String.IsNullOrEmpty(refParam) Then
                        Try
                            Dim dtProd As DataTable = ProductoService.Listar()
                            Dim filaProd As DataRow() = dtProd.Select("PRO_REFERENCIA = '" & refParam & "'")
                            If filaProd.Length > 0 Then
                                lblROProducto.Text = filaProd(0)("PRO_NOMBRE").ToString()
                                lblROMaterial.Text = If(dtProd.Columns.Contains("MAT_DESCRIPCION"),
                                                        filaProd(0)("MAT_DESCRIPCION").ToString(), "")
                                pnlReadonlyProducto.Visible = True
                            End If
                        Catch
                            ' Si falla el join, se queda el dropdown con el valor preseleccionado
                        End Try
                    End If
                    ' *** FIN CAMBIE AHORITA

                    ' Mostrar banner informativo
                    Dim pedidoParam As String = Request.QueryString("pedido")
                    MostrarInfo("Registrando precio de recepcion desde el Pedido #" & pedidoParam &
                        ". Producto y precio pre-cargados desde la Orden de Compra. Selecciona el almacen y nicho.")
                End If
            End If
        End Sub

        ' =============================================
        ' DROPDOWNS PRINCIPALES
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

        Private Sub LimpiarNichos()
            ddlNicho.Items.Clear()
            ddlNicho.Items.Add(New ListItem("-- Primero seleccione un almacen --", ""))
        End Sub

        ' =============================================
        ' FILTRO POR MES
        ' =============================================
        Private Sub CargarFiltroMes()
            ddlMes.Items.Clear()
            ddlMes.Items.Add(New ListItem("-- Todos --", "0"))
            ddlMes.Items.Add(New ListItem("Enero", "1"))
            ddlMes.Items.Add(New ListItem("Febrero", "2"))
            ddlMes.Items.Add(New ListItem("Marzo", "3"))
            ddlMes.Items.Add(New ListItem("Abril", "4"))
            ddlMes.Items.Add(New ListItem("Mayo", "5"))
            ddlMes.Items.Add(New ListItem("Junio", "6"))
            ddlMes.Items.Add(New ListItem("Julio", "7"))
            ddlMes.Items.Add(New ListItem("Agosto", "8"))
            ddlMes.Items.Add(New ListItem("Septiembre", "9"))
            ddlMes.Items.Add(New ListItem("Octubre", "10"))
            ddlMes.Items.Add(New ListItem("Noviembre", "11"))
            ddlMes.Items.Add(New ListItem("Diciembre", "12"))

            ddlAnio.Items.Clear()
            Dim anioActual As Integer = DateTime.Now.Year
            For i As Integer = anioActual To 2023 Step -1
                ddlAnio.Items.Add(New ListItem(i.ToString(), i.ToString()))
            Next
        End Sub

        Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs)
            Dim mes As Integer = Convert.ToInt32(ddlMes.SelectedValue)
            If mes = 0 Then
                CargarHistorialTodos()
            Else
                Dim anio As Integer = Convert.ToInt32(ddlAnio.SelectedValue)
                Try
                    gvHistorial.DataSource = HistorialPrecioService.ListarPorMes(mes, anio)
                    gvHistorial.DataBind()
                Catch ex As Exception
                    MostrarError("Error al filtrar: " & ex.Message)
                End Try
            End If
        End Sub

        ' =============================================
        ' CASCADA PRODUCTO → ALMACEN → NICHO
        ' =============================================
        Protected Sub ddlProducto_SelectedIndexChanged(sender As Object, e As EventArgs)
            pnlInfoProducto.Visible = False
            pnlPrecioNicho.Visible = False
            LimpiarNichos()
            If ddlProducto.SelectedValue = "" Then
                CargarHistorialTodos()
                Return
            End If
            Try
                Dim dt As DataTable = ProductoService.Listar()
                Dim fila As DataRow() = dt.Select("PRO_REFERENCIA = '" & ddlProducto.SelectedValue & "'")
                If fila.Length > 0 Then
                    lblNombreProducto.Text = fila(0)("PRO_NOMBRE").ToString()
                    If dt.Columns.Contains("TIP_DESCRIPCION") Then
                        lblTipo.Text = fila(0)("TIP_DESCRIPCION").ToString()
                    ElseIf dt.Columns.Contains("TIP_TIPO") Then
                        lblTipo.Text = fila(0)("TIP_TIPO").ToString()
                    Else
                        lblTipo.Text = ""
                    End If
                    If dt.Columns.Contains("MAT_DESCRIPCION") Then
                        lblMaterial.Text = fila(0)("MAT_DESCRIPCION").ToString()
                    ElseIf dt.Columns.Contains("MAT_MATERIAL") Then
                        lblMaterial.Text = fila(0)("MAT_MATERIAL").ToString()
                    Else
                        lblMaterial.Text = ""
                    End If
                    pnlInfoProducto.Visible = True
                End If
                CargarHistorial(ddlProducto.SelectedValue)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub ddlAlmacen_SelectedIndexChanged(sender As Object, e As EventArgs)
            pnlPrecioNicho.Visible = False
            LimpiarNichos()
            If ddlAlmacen.SelectedValue = "" Then Return
            Try
                ddlNicho.DataSource = NicAlmService.ListarPorAlmacen(Convert.ToDecimal(ddlAlmacen.SelectedValue))
                ddlNicho.DataTextField = "NIC_DISPLAY"
                ddlNicho.DataValueField = "NIC_NICHO"
                ddlNicho.DataBind()
                ddlNicho.Items.Insert(0, New ListItem("-- Seleccione un nicho --", ""))
            Catch ex As Exception
                MostrarError("Error al cargar nichos: " & ex.Message)
            End Try
        End Sub

        Protected Sub ddlNicho_SelectedIndexChanged(sender As Object, e As EventArgs)
            pnlPrecioNicho.Visible = False
            If ddlNicho.SelectedValue = "" OrElse ddlProducto.SelectedValue = "" Then Return
            Try
                Dim dtVigente As DataTable = HistorialPrecioService.Vigente(
                    ddlProducto.SelectedValue,
                    Convert.ToDecimal(ddlNicho.SelectedValue)
                )
                If dtVigente.Rows.Count > 0 Then
                    Dim precioActual As Decimal = Convert.ToDecimal(dtVigente.Rows(0)("HIP_PRECIO"))
                    ' Solo mostrar el badge si el vigente tiene precio real (no es semilla)
                    If precioActual > 0 Then
                        lblPrecioNicho.Text = String.Format("{0:C2}", precioActual)
                        pnlPrecioNicho.Visible = True
                    End If
                End If
            Catch ex As Exception
                ' Sin precio vigente aun
            End Try
        End Sub

        ' =============================================
        ' HISTORIAL
        ' =============================================
        Private Sub CargarHistorialTodos()
            Try
                gvHistorial.DataSource = HistorialPrecioService.ListarTodos()
                gvHistorial.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar historial: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarHistorial(referencia As String)
            Try
                gvHistorial.DataSource = HistorialPrecioService.ListarPorProducto(referencia)
                gvHistorial.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar historial: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' REGISTRAR PRECIO
        ' =============================================
        Protected Sub btnRegistrar_Click(sender As Object, e As EventArgs)
            ' *** CAMBIE AHORITA: validaciones server-side reforzadas (complementan la validacion JS)
            If ddlProducto.SelectedValue = "" Then MostrarError("Debe seleccionar un producto.") : Return
            If ddlAlmacen.SelectedValue = "" Then MostrarError("Debe seleccionar un almacen.") : Return
            If ddlNicho.SelectedValue = "" Then MostrarError("Debe seleccionar un nicho.") : Return
            If txtPrecio.Text.Trim() = "" Then MostrarError("El precio es obligatorio.") : Return
            Dim precioValidar As Decimal
            If Not Decimal.TryParse(txtPrecio.Text.Trim(), precioValidar) OrElse precioValidar <= 0 Then
                MostrarError("El precio debe ser un numero mayor a 0.") : Return
            End If
            If txtFechaInicio.Text.Trim() = "" Then MostrarError("La fecha de inicio es obligatoria.") : Return
            ' *** FIN CAMBIE AHORITA

            Try
                Dim proRef As String = ddlProducto.SelectedValue
                Dim nichoId As Decimal = Convert.ToDecimal(ddlNicho.SelectedValue)
                Dim precio As Decimal = Convert.ToDecimal(txtPrecio.Text.Trim())
                Dim fechaInicio As Date = Convert.ToDateTime(txtFechaInicio.Text.Trim())
                Dim readonlyParam As String = Request.QueryString("readonly")

                ' *** CAMBIE AHORITA: flujo completamente reescrito para modo readonly.
                ' Cuando viene desde Pedidos → Recibido se ACTUALIZA la semilla existente
                ' en lugar de crear un registro nuevo. Logica:
                '   a) Si ya hay un vigente real (precio > 0) con DIFERENTE precio:
                '      cerrar el vigente anterior y actualizar la semilla con datos reales.
                '   b) Si el vigente tiene el MISMO precio: solo actualizar la semilla
                '      (sin duplicar registros).
                '   c) Si no hay vigente real previo: actualizar la semilla directamente.
                ' En todos los casos de readonly se llama a ActualizarSemilla para
                ' completar la semilla con nicho, precio y fecha reales.
                If readonlyParam = "1" Then
                    Dim hipSemilla As Decimal = Convert.ToDecimal(hfHipSemilla.Value)

                    ' Buscar si ya hay un vigente real (precio > 0) para este producto y nicho
                    Dim dtVigente As DataTable = HistorialPrecioService.Vigente(proRef, nichoId)
                    Dim precioVigente As Decimal = 0
                    Dim hayVigenteReal As Boolean = False

                    If dtVigente IsNot Nothing AndAlso dtVigente.Rows.Count > 0 Then
                        Dim pvTemp As Decimal = Convert.ToDecimal(dtVigente.Rows(0)("HIP_PRECIO"))
                        ' Se ignora la propia semilla (precio=0) como "vigente anterior"
                        If pvTemp > 0 Then
                            precioVigente = pvTemp
                            hayVigenteReal = True
                        End If
                    End If

                    If hayVigenteReal AndAlso precioVigente <> precio Then
                        ' Caso a: precio diferente → cerrar el anterior, actualizar semilla
                        HistorialPrecioService.CerrarVigente(proRef, nichoId, fechaInicio)
                        HistorialPrecioService.ActualizarSemilla(hipSemilla, nichoId, precio, fechaInicio)
                    Else
                        ' Caso b y c: mismo precio o sin vigente real → solo actualizar semilla
                        HistorialPrecioService.ActualizarSemilla(hipSemilla, nichoId, precio, fechaInicio)
                    End If

                    ' Redirigir de vuelta a Pedidos para que el usuario finalice
                    Dim pedidoParam As String = Request.QueryString("pedido")
                    If Not String.IsNullOrEmpty(pedidoParam) Then
                        Response.Redirect(ResolveUrl("~/Modules/ComprasProveedor/Pedidos.aspx") &
                                          "?pedido=" & pedidoParam)
                        Return
                    End If
                Else
                    ' *** FIN CAMBIE AHORITA (inicio flujo normal sin cambios)
                    ' Flujo normal (no viene de pedido): cerrar vigente y registrar nuevo
                    HistorialPrecioService.CerrarVigente(proRef, nichoId, fechaInicio)
                    HistorialPrecioService.Registrar(proRef, nichoId, precio, fechaInicio)
                End If

                ' Flujo normal: mensaje y limpieza
                MostrarExito("Precio registrado correctamente.")
                txtPrecio.Text = ""
                txtFechaInicio.Text = DateTime.Now.ToString("yyyy-MM-dd")
                ddlNicho_SelectedIndexChanged(Nothing, EventArgs.Empty)
                CargarHistorial(proRef)
            Catch ex As Exception
                MostrarError("Error al registrar: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
        End Sub

        Private Sub LimpiarFormulario()
            ddlProducto.SelectedIndex = 0
            ddlAlmacen.SelectedIndex = 0
            txtPrecio.Text = ""
            txtFechaInicio.Text = DateTime.Now.ToString("yyyy-MM-dd")
            pnlInfoProducto.Visible = False
            pnlPrecioNicho.Visible = False
            pnlMsg.Visible = False
            LimpiarNichos()
            CargarHistorialTodos()
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

        Private Sub MostrarInfo(msg As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert-ok"
            pnlMsg.Visible = True
        End Sub

    End Class

End Namespace