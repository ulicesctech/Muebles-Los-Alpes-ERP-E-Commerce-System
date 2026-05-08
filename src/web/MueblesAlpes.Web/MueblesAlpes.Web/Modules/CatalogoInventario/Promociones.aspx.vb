Imports System.Data

Namespace Modules.CatalogoInventario

    Partial Public Class Promociones
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                txtFechaInicio.Text = DateTime.Now.ToString("yyyy-MM-dd")
                txtFechaFinal.Text = DateTime.Now.AddMonths(1).ToString("yyyy-MM-dd")
                CargarCampanas()
                CargarProductos()
                CargarCategorias()
            End If
        End Sub

        ' ============================================================
        ' CAMPAÑA
        ' ============================================================
        Private Sub CargarCampanas()
            Try
                gvCampanas.DataSource = PromocionService.CampanaListar()
                gvCampanas.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar campañas: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCrearCampana_Click(sender As Object, e As EventArgs)
            If txtNombre.Text.Trim() = "" Then
                MostrarError("El nombre de la campaña es obligatorio.")
                Return
            End If
            If txtFechaInicio.Text.Trim() = "" OrElse txtFechaFinal.Text.Trim() = "" Then
                MostrarError("Las fechas son obligatorias.")
                Return
            End If
            If Convert.ToDateTime(txtFechaFinal.Text) < Convert.ToDateTime(txtFechaInicio.Text) Then
                MostrarError("La fecha final debe ser mayor o igual a la fecha de inicio.")
                Return
            End If
            Try
                PromocionService.CampanaCrear(
                    txtNombre.Text.Trim(),
                    txtDescripcion.Text.Trim(),
                    Convert.ToDateTime(txtFechaInicio.Text),
                    Convert.ToDateTime(txtFechaFinal.Text)
                )
                MostrarExito("Campaña creada correctamente.")
                LimpiarFormulario()
                CargarCampanas()
            Catch ex As Exception
                MostrarError("Error al crear campaña: " & ex.Message)
            End Try
        End Sub

        Protected Sub gvCampanas_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "VerDetalle" Then
                Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)
                hfCampanaActiva.Value = id.ToString()
                Dim dt As DataTable = PromocionService.CampanaBuscar(id)
                If dt.Rows.Count > 0 Then
                    lblCampanaNombre.Text = dt.Rows(0)("CAMP_NOMBRE").ToString()
                End If
                CargarDetalle(id)
                pnlDetalle.Visible = True

            ElseIf e.CommandName = "Activar" Then
                Try
                    Dim partes() As String = e.CommandArgument.ToString().Split("|")
                    PromocionService.CampanaActualizar(
                        Convert.ToDecimal(partes(0)), partes(1), partes(2), "ACTIVA",
                        Convert.ToDateTime(partes(3)), Convert.ToDateTime(partes(4))
                    )
                    MostrarExito("Campaña activada correctamente.")
                    CargarCampanas()
                Catch ex As Exception
                    MostrarError("Error al activar campaña: " & ex.Message)
                End Try

            ElseIf e.CommandName = "Desactivar" Then
                Try
                    Dim partes() As String = e.CommandArgument.ToString().Split("|")
                    PromocionService.CampanaActualizar(
                        Convert.ToDecimal(partes(0)), partes(1), partes(2), "INACTIVA",
                        Convert.ToDateTime(partes(3)), Convert.ToDateTime(partes(4))
                    )
                    MostrarExito("Campaña desactivada correctamente.")
                    CargarCampanas()
                Catch ex As Exception
                    MostrarError("Error al desactivar campaña: " & ex.Message)
                End Try

            ElseIf e.CommandName = "EliminarCampana" Then
                Try
                    PromocionService.CampanaEliminar(Convert.ToDecimal(e.CommandArgument))
                    MostrarExito("Campaña eliminada correctamente.")
                    pnlDetalle.Visible = False
                    CargarCampanas()
                Catch ex As Exception
                    MostrarError("Error al eliminar campaña: " & ex.Message)
                End Try
            End If
        End Sub

        ' ============================================================
        ' DETALLE — PRODUCTOS
        ' ============================================================
        Private Sub CargarProductos()
            Try
                ddlProducto.DataSource = ProductoService.Listar()
                ddlProducto.DataTextField = "PRO_NOMBRE"
                ddlProducto.DataValueField = "PRO_REFERENCIA"
                ddlProducto.DataBind()
                ddlProducto.Items.Insert(0, New ListItem("-- Seleccione --", ""))
            Catch ex As Exception
                MostrarError("Error al cargar productos: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarCategorias()
            Try
                ddlCategoria.DataSource = CategoriaService.Listar()
                ddlCategoria.DataTextField = "CAT_DESCRIPCION"
                ddlCategoria.DataValueField = "CAT_CATEGORIA"
                ddlCategoria.DataBind()
                ddlCategoria.Items.Insert(0, New ListItem("-- Todas las categorías --", "0"))
            Catch ex As Exception
                MostrarError("Error al cargar categorías: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarDetalle(campanaId As Decimal)
            Try
                gvDetalle.DataSource = PromocionService.ListarPorCampana(campanaId)
                gvDetalle.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar detalle: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnAgregarCategoria_Click(sender As Object, e As EventArgs)
            If hfCampanaActiva.Value = "" Then
                MostrarError("Seleccione una campaña primero.")
                Return
            End If
            If txtPorcentaje.Text.Trim() = "" Then
                MostrarError("El porcentaje es obligatorio.")
                Return
            End If
            Try
                Dim campanaId As Decimal = Convert.ToDecimal(hfCampanaActiva.Value)
                Dim porcentaje As Decimal = Convert.ToDecimal(txtPorcentaje.Text.Trim())
                Dim categoriaId As Integer = Convert.ToInt32(ddlCategoria.SelectedValue)
                Dim dt As DataTable

                If categoriaId = 0 Then
                    dt = ProductoService.Listar()
                Else
                    dt = ProductoService.ListarPorCategoria(categoriaId)
                End If

                Dim agregados As Integer = 0
                For Each row As DataRow In dt.Rows
                    Try
                        PromocionService.Crear(campanaId, row("PRO_REFERENCIA").ToString(), porcentaje)
                        agregados += 1
                    Catch
                        ' Si el producto ya está en la campaña, lo omite
                    End Try
                Next

                MostrarExito(agregados & " producto(s) agregado(s) a la campaña.")
                CargarDetalle(campanaId)
            Catch ex As Exception
                MostrarError("Error al agregar por categoría: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnAgregarTodos_Click(sender As Object, e As EventArgs)
            If hfCampanaActiva.Value = "" Then
                MostrarError("Seleccione una campaña primero.")
                Return
            End If
            If txtPorcentaje.Text.Trim() = "" Then
                MostrarError("El porcentaje es obligatorio.")
                Return
            End If
            Try
                Dim campanaId As Decimal = Convert.ToDecimal(hfCampanaActiva.Value)
                Dim porcentaje As Decimal = Convert.ToDecimal(txtPorcentaje.Text.Trim())
                Dim dt As DataTable = ProductoService.Listar()
                Dim agregados As Integer = 0
                For Each row As DataRow In dt.Rows
                    Try
                        PromocionService.Crear(campanaId, row("PRO_REFERENCIA").ToString(), porcentaje)
                        agregados += 1
                    Catch
                        ' Si ya existe lo omite
                    End Try
                Next
                MostrarExito(agregados & " producto(s) agregado(s) a la campaña.")
                CargarDetalle(campanaId)
            Catch ex As Exception
                MostrarError("Error al agregar todos: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnAgregarProducto_Click(sender As Object, e As EventArgs)
            If hfCampanaActiva.Value = "" Then
                MostrarError("Seleccione una campaña primero.")
                Return
            End If
            If ddlProducto.SelectedValue = "" Then
                MostrarError("Seleccione un producto.")
                Return
            End If
            If txtPorcentajeInd.Text.Trim() = "" Then
                MostrarError("El porcentaje es obligatorio.")
                Return
            End If
            Try
                PromocionService.Crear(
                    Convert.ToDecimal(hfCampanaActiva.Value),
                    ddlProducto.SelectedValue,
                    Convert.ToDecimal(txtPorcentajeInd.Text.Trim())
                )
                MostrarExito("Producto agregado a la campaña.")
                CargarDetalle(Convert.ToDecimal(hfCampanaActiva.Value))
            Catch ex As Exception
                MostrarError("Error al agregar producto: " & ex.Message)
            End Try
        End Sub

        Protected Sub gvDetalle_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "EliminarDetalle" Then
                Try
                    Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)
                    PromocionService.Eliminar(id)
                    MostrarExito("Producto eliminado de la campaña.")
                    If hfCampanaActiva.Value <> "" Then
                        CargarDetalle(Convert.ToDecimal(hfCampanaActiva.Value))
                    End If
                Catch ex As Exception
                    MostrarError("Error al eliminar ID=" & e.CommandArgument & ": " & ex.Message)
                End Try
            End If
        End Sub

        ' ============================================================
        ' HELPERS
        ' ============================================================
        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
        End Sub

        Private Sub LimpiarFormulario()
            txtNombre.Text = ""
            txtDescripcion.Text = ""
            txtFechaInicio.Text = DateTime.Now.ToString("yyyy-MM-dd")
            txtFechaFinal.Text = DateTime.Now.AddMonths(1).ToString("yyyy-MM-dd")
            pnlMsg.Visible = False
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