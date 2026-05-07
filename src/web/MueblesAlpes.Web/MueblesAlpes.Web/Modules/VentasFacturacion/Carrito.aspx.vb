Imports System.Data
Imports VentasFacturacion

Namespace Modules.VentasFacturacion
    Public Class Carrito
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarClientes()
                CargarCarritos()
                CargarProductos()
            End If
        End Sub

        Private Sub CargarClientes()
            Try
                Dim dt As DataTable = ClienteService.Listar()
                ddlCliente.DataSource = dt
                ddlCliente.DataTextField = "CLI_PRIMER_NOMBRE"
                ddlCliente.DataValueField = "CLI_CLIENTE"
                ddlCliente.DataBind()
                ddlCliente.Items.Insert(0, New ListItem("-- Seleccione --", ""))
            Catch ex As Exception
                MostrarMensaje("Error al cargar clientes: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Private Sub CargarProductos()
            Try
                Dim dt As DataTable = CarritoVentasService.ListarProductosConPrecio()
                ddlProducto.DataSource = dt
                ddlProducto.DataTextField = "PRO_NOMBRE"
                ddlProducto.DataValueField = "HV_HISTORIAL_PRECIO_VENTA"
                ddlProducto.DataBind()
                ddlProducto.Items.Insert(0, New ListItem("-- Seleccione --", ""))
            Catch ex As Exception
                MostrarMensaje("Error al cargar productos: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Private Sub CargarCarritos()
            Try
                gvCarritos.DataSource = CarritoVentasService.Listar()
                gvCarritos.DataBind()
            Catch ex As Exception
                MostrarMensaje("Error al cargar carritos: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Private Sub CargarProductosCarrito(ByVal carritoId As Decimal)
            Try
                gvProductosCarrito.DataSource = CarritoVentasService.ListarProductosCarrito(carritoId)
                gvProductosCarrito.DataBind()
            Catch ex As Exception
                MostrarMensaje("Error al cargar productos del carrito: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs)
            If ddlCliente.SelectedValue = "" Then
                MostrarMensaje("Debe seleccionar un cliente.", "alert-danger")
                Return
            End If
            Try
                CarritoVentasService.Crear(Convert.ToDecimal(ddlCliente.SelectedValue))
                MostrarMensaje("Carrito creado exitosamente.", "alert-success")
                LimpiarFormulario()
                CargarCarritos()
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Protected Sub btnCerrarDetalle_Click(ByVal sender As Object, ByVal e As EventArgs)
            pnlDetalle.Visible = False
            hfCarritoDetalle.Value = ""
            lblCarritoSeleccionado.Text = ""
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "cerrarModal", "cerrarModal();", True)
        End Sub

        Protected Sub btnAgregarProducto_Click(ByVal sender As Object, ByVal e As EventArgs)
            If ddlProducto.SelectedValue = "" Then
                MostrarMensaje("Debe seleccionar un producto.", "alert-danger")
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "abrirModal", "abrirModal();", True)
                Return
            End If
            Try
                CarritoVentasService.AgregarDetalle(
                    Convert.ToDecimal(hfCarritoDetalle.Value),
                    Convert.ToDecimal(ddlProducto.SelectedValue),
                    Convert.ToDecimal(txtCantidad.Text.Trim()))
                MostrarMensaje("Producto agregado exitosamente.", "alert-success")
                CargarProductosCarrito(Convert.ToDecimal(hfCarritoDetalle.Value))
                CargarCarritos()
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "abrirModal", "abrirModal();", True)
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, "alert-danger")
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "abrirModal", "abrirModal();", True)
            End Try
        End Sub

        Protected Sub gvCarritos_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
            If e.CommandName = "VerResumen" Then
                Response.Redirect("DetalleCarrito.aspx?carrito=" & e.CommandArgument.ToString())
            ElseIf e.CommandName = "VerDetalle" Then
                hfCarritoDetalle.Value = e.CommandArgument.ToString()
                lblCarritoSeleccionado.Text = e.CommandArgument.ToString()
                pnlDetalle.Visible = True
                CargarProductosCarrito(Convert.ToDecimal(e.CommandArgument.ToString()))
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "abrirModal", "abrirModal();", True)
            ElseIf e.CommandName = "Vaciar" Then
                Try
                    CarritoVentasService.Vaciar(Convert.ToDecimal(e.CommandArgument.ToString()))
                    MostrarMensaje("Carrito vaciado exitosamente.", "alert-success")
                    CargarCarritos()
                    pnlDetalle.Visible = False
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "cerrarModal", "cerrarModal();", True)
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, "alert-danger")
                End Try
            ElseIf e.CommandName = "Eliminar" Then
                Try
                    CarritoVentasService.Eliminar(Convert.ToDecimal(e.CommandArgument.ToString()))
                    MostrarMensaje("Carrito eliminado exitosamente.", "alert-success")
                    CargarCarritos()
                    pnlDetalle.Visible = False
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "cerrarModal", "cerrarModal();", True)
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, "alert-danger")
                End Try
            End If
        End Sub

        Protected Sub gvProductosCarrito_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
            If e.CommandName = "EliminarDetalle" Then
                Try
                    CarritoVentasService.EliminarDetalle(Convert.ToDecimal(e.CommandArgument.ToString()))
                    MostrarMensaje("Producto eliminado del carrito.", "alert-success")
                    CargarProductosCarrito(Convert.ToDecimal(hfCarritoDetalle.Value))
                    CargarCarritos()
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "abrirModal", "abrirModal();", True)
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, "alert-danger")
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "abrirModal", "abrirModal();", True)
                End Try
            End If
        End Sub

        Private Sub LimpiarFormulario()
            ddlCliente.SelectedIndex = 0
            hfCarrito.Value = ""
            hfModo.Value = "C"
        End Sub

        Private Sub MostrarMensaje(ByVal msg As String, ByVal css As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert " & css
            pnlMsg.Visible = True
        End Sub

    End Class
End Namespace