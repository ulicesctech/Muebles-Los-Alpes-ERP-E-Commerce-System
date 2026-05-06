Imports System.Data

Namespace Modules.VentasFacturacion
    Public Class Factura
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarCarritos()
                CargarEmpleados()
                CargarFacturas()
            End If
        End Sub

        Private Sub CargarCarritos()
            Try
                Dim dt As DataTable = CarritoVentasService.Listar()
                ddlCarrito.DataSource = dt
                ddlCarrito.DataTextField = "PRE_CORRELATIVO"
                ddlCarrito.DataValueField = "PRE_CARRITO"
                ddlCarrito.DataBind()
                ddlCarrito.Items.Insert(0, New ListItem("-- Seleccione --", ""))
            Catch ex As Exception
                MostrarMensaje("Error al cargar carritos: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Private Sub CargarEmpleados()
            Try
                Dim dt As DataTable = EmpleadoService.Listar()
                ddlEmpleado.DataSource = dt
                ddlEmpleado.DataTextField = "EM_PRIMER_NOMBRE"
                ddlEmpleado.DataValueField = "EM_EMPLEADO"
                ddlEmpleado.DataBind()
                ddlEmpleado.Items.Insert(0, New ListItem("-- Seleccione --", ""))
            Catch ex As Exception
                MostrarMensaje("Error al cargar empleados: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Private Sub CargarFacturas()
            Try
                gvFacturas.DataSource = FacturaService.Listar()
                gvFacturas.DataBind()
            Catch ex As Exception
                MostrarMensaje("Error al cargar facturas: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs)
            Try
                Dim carrito As Decimal = Convert.ToDecimal(ddlCarrito.SelectedValue)
                Dim empleado As Decimal = Convert.ToDecimal(ddlEmpleado.SelectedValue)
                txtCodigoFactura.Text = FacturaService.Crear(carrito, empleado)
                CarritoVentasService.Facturar(carrito)
                MostrarMensaje("Factura generada exitosamente. Codigo: " & txtCodigoFactura.Text, "alert-success")
                CargarFacturas()
            Catch ex As Exception
                If ex.Message.Contains("ORA-20012") OrElse ex.Message.Contains("stock insuficiente") Then
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modalStock",
                "document.getElementById('modalStock').style.display='flex';" &
                "document.getElementById('modalStockMsg').innerHTML='Lo sentimos, no hay suficiente stock para uno o más productos. Verifique Su Stock.';", True)
                Else
                    MostrarMensaje("Error: " & ex.Message, "alert-danger")
                End If
            End Try
        End Sub

        Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs)
            LimpiarFormulario()
        End Sub

        Private Sub LimpiarFormulario()
            txtCodigoFactura.Text = ""
            ddlCarrito.SelectedIndex = 0
            ddlEmpleado.SelectedIndex = 0
        End Sub

        Private Sub MostrarMensaje(ByVal msg As String, ByVal css As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert " & css
            pnlMsg.Visible = True
        End Sub

    End Class
End Namespace
