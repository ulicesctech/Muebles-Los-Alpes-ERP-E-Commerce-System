Imports System.Data
Imports System.Text

Namespace Modules.VentasFacturacion
    Public Class HistorialPrecioVenta
        Inherits BasePage

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarProductos()
                CargarPrecios()
            End If
        End Sub

        Private Sub CargarProductos()
            Try
                Dim dt As DataTable = ProductoService.Listar()
                ddlProducto.DataSource = dt
                ddlProducto.DataTextField = "PRO_NOMBRE"
                ddlProducto.DataValueField = "PRO_REFERENCIA"
                ddlProducto.DataBind()
                ddlProducto.Items.Insert(0, New ListItem("-- Seleccione --", ""))
            Catch ex As Exception
                MostrarMensaje("Error al cargar productos: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Private Sub CargarPrecios()
            Try
                Dim dt As DataTable = HistorialPrecioVentaService.Listar()
                gvPrecios.DataSource = dt
                gvPrecios.DataBind()
                hfPrecios.Value = BuildPreciosJson(dt)
            Catch ex As Exception
                MostrarMensaje("Error al cargar precios: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Private Function BuildPreciosJson(dt As DataTable) As String
            Dim sb As New StringBuilder("{")
            For Each row As DataRow In dt.Rows
                Dim ref As String = row("PRO_REFERENCIA").ToString().Replace("""", "")
                Dim precio As String = row("PRECIO_COMPRA").ToString()
                sb.Append("""" & ref & """:" & precio & ",")
            Next
            If sb.Length > 1 Then sb.Length -= 1
            sb.Append("}")
            Return sb.ToString()
        End Function

        Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs)
            If ddlProducto.SelectedValue = "" Then
                MostrarMensaje("Debe seleccionar un producto.", "alert-danger")
                Return
            End If
            Dim porcetaje As Decimal
            If Not Decimal.TryParse(txtPorcetaje.Text.Trim(), porcetaje) OrElse porcetaje < 0 Then
                MostrarMensaje("Ingrese un porcentaje válido.", "alert-danger")
                Return
            End If
            Try
                HistorialPrecioVentaService.Registrar(ddlProducto.SelectedValue, porcetaje)
                MostrarMensaje("Precio registrado exitosamente.", "alert-success")
                txtPorcetaje.Text = ""
                txtPrecioFinal.Text = ""
                CargarPrecios()
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Private Sub MostrarMensaje(ByVal msg As String, ByVal css As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert " & css
            pnlMsg.Visible = True
        End Sub

    End Class
End Namespace
