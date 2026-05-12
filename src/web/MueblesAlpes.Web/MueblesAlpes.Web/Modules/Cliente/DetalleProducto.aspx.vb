Imports System.Data

Namespace Modules.Cliente

    Public Class DetalleProducto
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                Dim ref As String = Request.QueryString("ref")
                If String.IsNullOrEmpty(ref) Then
                    pnlNoEncontrado.Visible = True
                    Return
                End If
                CargarProducto(ref)
            End If
        End Sub

        Private Sub CargarProducto(ref As String)
            Try
                Dim dt As DataTable = CatalogoClienteService.Listar()
                Dim filas As DataRow() = dt.Select("PRO_REFERENCIA = '" & ref.Replace("'", "''") & "'")

                If filas.Length = 0 Then
                    pnlNoEncontrado.Visible = True
                    Return
                End If

                Dim fila As DataRow = filas(0)

                ' Breadcrumb y titulo
                lblBreadcrumb.Text = fila("PRO_NOMBRE").ToString()
                Page.Title = fila("PRO_NOMBRE").ToString()

                ' Foto
                imgProducto.ImageUrl = ResolveUrl("~/Handlers/CatalogoInventario/FotoProductoHandler.ashx?ref=" & ref)
                imgProducto.AlternateText = fila("PRO_NOMBRE").ToString()

                ' Info
                lblCategoria.Text = fila("CAT_DESCRIPCION").ToString()
                lblNombre.Text = fila("PRO_NOMBRE").ToString()
                lblTipo.Text = fila("TIP_DESCRIPCION").ToString() & " · " & fila("MAT_DESCRIPCION").ToString()

                ' Precio
                Dim precioOriginal As Decimal = Convert.ToDecimal(fila("PRO_PRECIO"))
                Dim precioFinal As Decimal = Convert.ToDecimal(fila("PRECIO_FINAL"))
                Dim tienePromo As Boolean = fila("PROM_PORCENTAJE") IsNot DBNull.Value

                If tienePromo Then
                    lblPrecioOriginal.Text = "Q " & precioOriginal.ToString("N2")
                    lblPrecioOriginal.Visible = True
                    lblPrecioFinal.CssClass = "det-precio-final promo"
                    lblBadgePromo.Text = "-" & fila("PROM_PORCENTAJE").ToString() & "%"
                    lblBadgePromo.Visible = True
                End If
                lblPrecioFinal.Text = "Q " & precioFinal.ToString("N2")

                ' Stock
                Dim stock As Integer = Convert.ToInt32(fila("STO_DISPONIBLE"))
                If stock > 0 Then
                    lblStock.Text = "<span class='det-stock disponible'> Disponible </span>"
                    btnAgregar.Enabled = True
                Else
                    lblStock.Text = "<span class='det-stock agotado'> Agotado </span>"
                    btnAgregar.Enabled = False
                End If

                ' Specs
                lblMaterial.Text = fila("MAT_DESCRIPCION").ToString()
                lblColor.Text = If(fila("PRO_COLOR") Is DBNull.Value, "N/A", fila("PRO_COLOR").ToString())
                lblAlto.Text = fila("PRO_ALTO_CM").ToString()
                lblAncho.Text = fila("PRO_ANCHO_CM").ToString()
                lblProfundidad.Text = fila("PRO_PROFUNDIDAD_CM").ToString()
                lblPeso.Text = fila("PRO_PESO").ToString()

                ' HIP ID para carrito
                hfHipId.Value = If(fila("HV_HISTORIAL_PRECIO_VENTA") Is DBNull.Value, "", fila("HV_HISTORIAL_PRECIO_VENTA").ToString())

                pnlProducto.Visible = True

            Catch ex As Exception
                pnlNoEncontrado.Visible = True
            End Try
        End Sub

        Protected Sub btnAgregar_Click(sender As Object, e As EventArgs)
            Try
                Dim hipId As String = hfHipId.Value
                Dim cantidad As Integer = Convert.ToInt32(hfCantidad.Value)

                Dim carrito As List(Of Dictionary(Of String, String))
                If Session("CARRITO_TEMP") Is Nothing Then
                    carrito = New List(Of Dictionary(Of String, String))
                Else
                    carrito = CType(Session("CARRITO_TEMP"), List(Of Dictionary(Of String, String)))
                End If

                Dim existe As Boolean = False
                For Each item As Dictionary(Of String, String) In carrito
                    If item("HIP_ID") = hipId Then
                        item("CANTIDAD") = (Convert.ToInt32(item("CANTIDAD")) + cantidad).ToString()
                        existe = True
                        Exit For
                    End If
                Next

                If Not existe Then
                    Dim nuevo As New Dictionary(Of String, String)
                    nuevo("HIP_ID") = hipId
                    nuevo("CANTIDAD") = cantidad.ToString()
                    carrito.Add(nuevo)
                End If

                Session("CARRITO_TEMP") = carrito
                lblMsg.Text = "✓ Producto agregado al carrito."
                lblMsg.CssClass = "alert-ok"
                pnlMsg.Visible = True

            Catch ex As Exception
                lblMsg.Text = "Error: " & ex.Message
                lblMsg.CssClass = "alert-err"
                pnlMsg.Visible = True
            End Try
        End Sub

    End Class

End Namespace