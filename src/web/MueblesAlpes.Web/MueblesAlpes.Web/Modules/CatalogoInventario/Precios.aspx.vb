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

                    ' Pre-cargar precio desde el pedido
                    If Not String.IsNullOrEmpty(precioParam) Then
                        txtPrecio.Text = precioParam
                        txtPrecio.ReadOnly = True
                    End If

                    ' Mostrar banner informativo
                    Dim pedidoParam As String = Request.QueryString("pedido")
                    MostrarInfo("Registrando precio de recepcion desde el Pedido #" & pedidoParam &
                        ". Producto y precio pre-cargados. Solo selecciona el almacen y nicho.")
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
            ' Meses
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

            ' Anios — desde 2023 hasta el actual
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
                    ' Verificacion segura — columnas con JOIN pueden variar
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
                    lblPrecioNicho.Text = String.Format("{0:C2}", dtVigente.Rows(0)("HIP_PRECIO"))
                    pnlPrecioNicho.Visible = True
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
            If ddlProducto.SelectedValue = "" Then MostrarError("Debe seleccionar un producto.") : Return
            If ddlAlmacen.SelectedValue = "" Then MostrarError("Debe seleccionar un almacen.") : Return
            If ddlNicho.SelectedValue = "" Then MostrarError("Debe seleccionar un nicho.") : Return
            If txtPrecio.Text.Trim() = "" Then MostrarError("El precio es obligatorio.") : Return
            If txtFechaInicio.Text.Trim() = "" Then MostrarError("La fecha de inicio es obligatoria.") : Return

            Try
                Dim proRef As String = ddlProducto.SelectedValue
                Dim nichoId As Decimal = Convert.ToDecimal(ddlNicho.SelectedValue)
                Dim precio As Decimal = Convert.ToDecimal(txtPrecio.Text.Trim())
                Dim fechaInicio As Date = Convert.ToDateTime(txtFechaInicio.Text.Trim())
                Dim readonlyParam As String = Request.QueryString("readonly")

                ' Si viene de Recibido: primero cerrar el vigente anterior con la fecha actual
                If readonlyParam = "1" Then
                    HistorialPrecioService.CerrarVigente(proRef, nichoId, fechaInicio)
                End If

                ' Registrar nuevo precio (sin cerrar nada — eso ya se hizo arriba si aplica)
                HistorialPrecioService.Registrar(proRef, nichoId, precio, fechaInicio)

                ' Si vino desde Pedidos, redirigir de vuelta
                Dim pedidoParam As String = Request.QueryString("pedido")
                If Not String.IsNullOrEmpty(pedidoParam) Then
                    Response.Redirect(ResolveUrl("~/Modules/ComprasProveedor/Pedidos.aspx") &
                                      "?pedido=" & pedidoParam)
                    Return
                End If

                ' Flujo normal
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