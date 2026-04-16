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

                ' Verificar precio vigente
                Dim dtVigente As DataTable = HistorialPrecioService.Vigente(referencia, nicId)
                If dtVigente.Rows.Count = 0 Then
                    pnlAvisoPrecio.Visible = True
                    pnlPaso4.Visible = True
                    Return
                End If

                hfHipId.Value = dtVigente.Rows(0)("HIP_HISTORIAL_PRECIO").ToString()
                lblPrecioVigente.Text = String.Format("{0:C2}", dtVigente.Rows(0)("HIP_PRECIO"))
                pnlPrecioVigente.Visible = True

                ' Verificar si ya tiene stock
                Dim dtStock As DataTable = StockService.Obtener(Convert.ToDecimal(hfHipId.Value))
                If dtStock.Rows.Count > 0 Then
                    CargarDatosStock(dtStock.Rows(0))
                    pnlStockActual.Visible = True
                    pnlSinStock.Visible = False
                Else
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
            If txtDisponibleNuevo.Text.Trim() = "" OrElse txtMinimoNuevo.Text.Trim() = "" OrElse txtMaximoNuevo.Text.Trim() = "" Then
                MostrarError("Todos los campos son obligatorios.")
                Return
            End If
            Try
                StockService.Guardar(
                    Convert.ToDecimal(hfHipId.Value),
                    Convert.ToDecimal(txtMinimoNuevo.Text.Trim()),
                    Convert.ToDecimal(txtMaximoNuevo.Text.Trim()),
                    Convert.ToDecimal(txtDisponibleNuevo.Text.Trim())
                )
                MostrarExito("Stock creado correctamente.")
                ddlNicho_SelectedIndexChanged(Nothing, EventArgs.Empty)
                CargarTablaStock()
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' REGISTRAR ENTRADA DE MERCANCIA
        ' =============================================
        Protected Sub btnEntrada_Click(sender As Object, e As EventArgs)
            If txtCantidadEntrada.Text.Trim() = "" Then
                MostrarError("Ingresa la cantidad que entro.")
                Return
            End If
            Try
                Dim cantidad As Decimal = Convert.ToDecimal(txtCantidadEntrada.Text.Trim())
                StockService.Entrada(Convert.ToDecimal(hfHipId.Value), cantidad)
                MostrarExito("Entrada registrada. Se sumaron " & cantidad.ToString() & " unidades al disponible.")
                ddlNicho_SelectedIndexChanged(Nothing, EventArgs.Empty)
                CargarTablaStock()
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
                hfHipId.Value = ""
                txtDisponible.Text = ""
                txtMinimo.Text = ""
                txtMaximo.Text = ""
                txtCantidadEntrada.Text = ""
                txtDisponibleNuevo.Text = ""
                txtMinimoNuevo.Text = ""
                txtMaximoNuevo.Text = ""
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