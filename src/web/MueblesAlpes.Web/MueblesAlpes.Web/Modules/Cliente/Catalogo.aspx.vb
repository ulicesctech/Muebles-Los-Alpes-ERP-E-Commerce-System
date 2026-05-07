Imports System.Data

Namespace Modules.Cliente

    Public Class Catalogo
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarCategorias()
                CargarProductos()
            End If
        End Sub

        Private Sub CargarCategorias()
            Try
                Dim dt As DataTable = CatalogoClienteService.ListarCategorias()
                rptCategorias.DataSource = dt
                rptCategorias.DataBind()
            Catch
            End Try
        End Sub

        Private Sub CargarProductos()
            Dim dt As DataTable = CatalogoClienteService.Listar()
            BindProductos(dt)
        End Sub

        Private Sub BindProductos(dt As DataTable)
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

        Private Sub MostrarMensaje(msg As String, esError As Boolean)
            lblMsg.Text = msg
            lblMsg.CssClass = If(esError, "alert-err", "alert-ok")
            pnlMsg.Visible = True
        End Sub

        Private Sub OcultarMensaje()
            pnlMsg.Visible = False
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            OcultarMensaje()
            Dim texto As String = txtBuscar.Text.Trim()
            Dim categoria As Integer = Convert.ToInt32(hfCatActiva.Value)
            Dim dt As DataTable = CatalogoClienteService.Buscar(texto, categoria)
            BindProductos(dt)
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            OcultarMensaje()
            txtBuscar.Text = ""
            hfCatActiva.Value = "0"
            CargarProductos()
        End Sub

        Protected Sub rptCategorias_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
            If e.CommandName = "FiltrarCategoria" Then
                OcultarMensaje()
                hfCatActiva.Value = e.CommandArgument.ToString()
                Dim categoria As Integer = Convert.ToInt32(e.CommandArgument)
                Dim dt As DataTable
                If categoria = 0 Then
                    dt = CatalogoClienteService.Listar()
                Else
                    dt = CatalogoClienteService.Buscar("", categoria)
                End If
                BindProductos(dt)
            End If
        End Sub

        Protected Sub rptProductos_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
            OcultarMensaje()

            If e.CommandName = "VerDetalle" Then
                Dim referencia As String = e.CommandArgument.ToString()
                Response.Redirect("~/Modules/Cliente/DetalleProducto.aspx?ref=" &
                    Server.UrlEncode(referencia))

            ElseIf e.CommandName = "AgregarCarrito" Then
                Try
                    Dim hipId As String = e.CommandArgument.ToString()

                    Dim dtCatalogo As DataTable = CatalogoClienteService.Listar()
                    Dim filas As DataRow() = dtCatalogo.Select("HIP_HISTORIAL_PRECIO = " & hipId)
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
                    MostrarMensaje("✓ Has agregado <strong>" & nombreProducto &
                        "</strong> al <a href='/Modules/Cliente/Carrito.aspx' style='color:#276749;font-weight:bold;'>carrito de compras</a>.", False)

                Catch ex As Exception
                    MostrarMensaje("Error al agregar al carrito: " & ex.Message, True)
                End Try
            End If
        End Sub

    End Class

End Namespace