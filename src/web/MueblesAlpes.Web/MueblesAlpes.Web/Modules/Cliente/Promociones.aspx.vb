Imports System.Data

Namespace Modules.Cliente

    Public Class Promociones
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPromociones()
            End If
        End Sub

        Private Sub CargarPromociones()
            Dim dt As DataTable = CatalogoClienteService.ListarPromociones()
            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                rptProductos.DataSource = dt
                rptProductos.DataBind()
                lblConteo.Text = dt.Rows.Count.ToString()
                pnlEmpty.Visible = False
            Else
                rptProductos.DataSource = Nothing
                rptProductos.DataBind()
                lblConteo.Text = "0"
                pnlEmpty.Visible = True
            End If
        End Sub

        Protected Sub rptProductos_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
            If e.CommandName = "VerDetalle" Then
                Response.Redirect("~/Modules/Cliente/DetalleProducto.aspx?ref=" &
                    Server.UrlEncode(e.CommandArgument.ToString()))

            ElseIf e.CommandName = "AgregarCarrito" Then
                Try
                    Dim hipId As String = e.CommandArgument.ToString()

                    Dim dtCatalogo As DataTable = CatalogoClienteService.ListarPromociones()
                    Dim filas As DataRow() = dtCatalogo.Select("HV_HISTORIAL_PRECIO_VENTA = " & hipId)
                    Dim nombreProducto As String = "Producto"
                    If filas.Length > 0 Then
                        nombreProducto = filas(0)("PRO_NOMBRE").ToString()
                    End If

                    Dim carrito As List(Of Dictionary(Of String, String))
                    If Session("CARRITO_TEMP") Is Nothing Then
                        carrito = New List(Of Dictionary(Of String, String))
                    Else
                        carrito = CType(Session("CARRITO_TEMP"), List(Of Dictionary(Of String, String)))
                    End If

                    Dim existe As Boolean = False
                    For Each item As Dictionary(Of String, String) In carrito
                        If item("HIP_ID") = hipId Then
                            item("CANTIDAD") = (Convert.ToInt32(item("CANTIDAD")) + 1).ToString()
                            existe = True
                            Exit For
                        End If
                    Next

                    If Not existe Then
                        Dim nuevo As New Dictionary(Of String, String)
                        nuevo("HIP_ID") = hipId
                        nuevo("CANTIDAD") = "1"
                        carrito.Add(nuevo)
                    End If

                    Session("CARRITO_TEMP") = carrito
                    lblMsg.Text = "✓ Has agregado <strong>" & nombreProducto &
                        "</strong> al <a href='/Modules/Cliente/Carrito.aspx' style='color:#276749;font-weight:bold;'>carrito de compras</a>."
                    lblMsg.CssClass = "alert-ok"
                    pnlMsg.Visible = True

                Catch ex As Exception
                    lblMsg.Text = "Error al agregar al carrito: " & ex.Message
                    lblMsg.CssClass = "alert-err"
                    pnlMsg.Visible = True
                End Try
            End If
        End Sub

    End Class

End Namespace