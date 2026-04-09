Imports System
Imports System.Data

' ============================================================
' RUTA: Modules/CatalogoInventario/Promociones.aspx.vb
' ============================================================
Namespace Modules.CatalogoInventario

    Partial Public Class Promociones
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarProductos()
                txtFechaInicio.Text = DateTime.Now.ToString("yyyy-MM-dd")
                txtFechaFinal.Text = DateTime.Now.AddMonths(1).ToString("yyyy-MM-dd")
            End If
        End Sub

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
            If ddlProducto.SelectedValue <> "" Then
                CargarPromociones(ddlProducto.SelectedValue)
                CargarVigente(ddlProducto.SelectedValue)
            Else
                gvPromociones.DataSource = Nothing
                gvPromociones.DataBind()
                pnlVigente.Visible = False
            End If
        End Sub

        Private Sub CargarPromociones(referencia As String)
            Try
                gvPromociones.DataSource = PromocionService.ListarPorProducto(referencia)
                gvPromociones.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar promociones: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarVigente(referencia As String)
            Try
                Dim dt As DataTable = PromocionService.Vigente(referencia)
                If dt.Rows.Count > 0 Then
                    lblPorcentaje.Text = dt.Rows(0)("PRO_PORCENTAJE").ToString()
                    lblFechaInicio.Text = Convert.ToDateTime(dt.Rows(0)("PRO_FECHA_INICIO")).ToString("dd/MM/yyyy")
                    lblFechaFinal.Text = Convert.ToDateTime(dt.Rows(0)("PRO_FECHA_FINAL")).ToString("dd/MM/yyyy")
                    pnlVigente.Visible = True
                Else
                    pnlVigente.Visible = False
                End If
            Catch ex As Exception
                pnlVigente.Visible = False
            End Try
        End Sub

        Protected Sub btnCrear_Click(sender As Object, e As EventArgs)
            If ddlProducto.SelectedValue = "" Then
                MostrarError("Debe seleccionar un producto.")
                Return
            End If
            If txtPorcentaje.Text.Trim() = "" Then
                MostrarError("El porcentaje es obligatorio.")
                Return
            End If
            If txtFechaInicio.Text.Trim() = "" OrElse txtFechaFinal.Text.Trim() = "" Then
                MostrarError("Las fechas son obligatorias.")
                Return
            End If
            If Convert.ToDateTime(txtFechaFinal.Text) <= Convert.ToDateTime(txtFechaInicio.Text) Then
                MostrarError("La fecha final debe ser mayor a la fecha de inicio.")
                Return
            End If

            Try
                PromocionService.Crear(
                    ddlProducto.SelectedValue,
                    Convert.ToDecimal(txtPorcentaje.Text.Trim()),
                    Convert.ToDateTime(txtFechaInicio.Text.Trim()),
                    Convert.ToDateTime(txtFechaFinal.Text.Trim())
                )
                MostrarExito("Promocion creada correctamente.")
                CargarPromociones(ddlProducto.SelectedValue)
                CargarVigente(ddlProducto.SelectedValue)
                LimpiarFormulario()
            Catch ex As Exception
                MostrarError("Error al crear promocion: " & ex.Message)
            End Try
        End Sub

        Protected Sub gvPromociones_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "Eliminar" Then
                Try
                    Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)
                    PromocionService.Eliminar(id)
                    MostrarExito("Promocion eliminada correctamente.")
                    If ddlProducto.SelectedValue <> "" Then
                        CargarPromociones(ddlProducto.SelectedValue)
                        CargarVigente(ddlProducto.SelectedValue)
                    End If
                Catch ex As Exception
                    MostrarError("Error al eliminar: " & ex.Message)
                End Try
            End If
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
        End Sub

        Private Sub LimpiarFormulario()
            txtPorcentaje.Text = ""
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