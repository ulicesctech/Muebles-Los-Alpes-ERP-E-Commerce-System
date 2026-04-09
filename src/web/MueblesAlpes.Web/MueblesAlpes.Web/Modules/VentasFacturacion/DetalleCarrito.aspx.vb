Imports System.Data

Namespace Modules.VentasFacturacion
    Public Class DetalleCarrito
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarResumen()
            End If
        End Sub

        Private Sub CargarResumen()
            Try
                gvDetalles.DataSource = CarritoService.Resumen()
                gvDetalles.DataBind()
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