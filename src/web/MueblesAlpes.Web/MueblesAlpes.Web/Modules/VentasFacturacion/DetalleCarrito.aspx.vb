Imports System.Data

Namespace Modules.VentasFacturacion
    Public Class DetalleCarrito
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                Dim qs As String = Request.QueryString("carrito")
                If String.IsNullOrEmpty(qs) Then
                    CargarListado()
                Else
                    CargarResumen(Convert.ToDecimal(qs))
                End If
            End If
        End Sub

        Private Sub CargarListado()
            Try
                Dim dt As DataTable = CarritoVentasService.Listar()
                gvListado.DataSource = dt
                gvListado.DataBind()
                pnlListado.Visible = True
            Catch ex As Exception
                MostrarMensaje("Error al cargar carritos: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Private Sub CargarResumen(carritoId As Decimal)
            Try
                Dim dt As DataTable = CarritoVentasService.Resumen(carritoId)
                gvDetalles.DataSource = dt
                gvDetalles.DataBind()
                If dt.Rows.Count > 0 Then
                    Dim total As Decimal = Convert.ToDecimal(dt.Rows(0)("TOTAL"))
                    lblTotal.Text = "Total del carrito: Q " & total.ToString("N2")
                    lblTotal.Visible = True
                End If
                pnlDetalle.Visible = True
            Catch ex As Exception
                MostrarMensaje("Error al cargar detalles: " & ex.Message, "alert-danger")
            End Try
        End Sub

        Private Sub MostrarMensaje(ByVal msg As String, ByVal css As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert " & css
            pnlMsg.Visible = True
        End Sub

    End Class
End Namespace
