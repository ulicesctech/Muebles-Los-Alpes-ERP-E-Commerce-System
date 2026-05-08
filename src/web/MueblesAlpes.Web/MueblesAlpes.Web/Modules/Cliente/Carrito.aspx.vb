Imports System.Data

Namespace Modules.Cliente

    Public Class Carrito
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarCarrito()
            End If
        End Sub

        Private Sub CargarCarrito()
            Dim carrito As List(Of Dictionary(Of String, String)) = ObtenerCarritoSession()

            If carrito Is Nothing OrElse carrito.Count = 0 Then
                pnlVacio.Visible = True
                pnlCarrito.Visible = False
                Return
            End If

            Dim dtCatalogo As DataTable = CatalogoClienteService.Listar()

            Dim dtCarrito As New DataTable()
            dtCarrito.Columns.Add("HIP_ID")
            dtCarrito.Columns.Add("PRO_REFERENCIA")
            dtCarrito.Columns.Add("PRO_NOMBRE")
            dtCarrito.Columns.Add("PRO_PRECIO", GetType(Decimal))
            dtCarrito.Columns.Add("PRECIO_FINAL", GetType(Decimal))
            dtCarrito.Columns.Add("CANTIDAD", GetType(Integer))
            dtCarrito.Columns.Add("CAMP_NOMBRE")

            Dim totalFinal As Decimal = 0

            For Each item As Dictionary(Of String, String) In carrito
                Dim hipId As String = item("HIP_ID")
                Dim cantidad As Integer = Convert.ToInt32(item("CANTIDAD"))

                Dim filas As DataRow() = dtCatalogo.Select("HV_HISTORIAL_PRECIO_VENTA = " & hipId)
                If filas.Length > 0 Then
                    Dim fila As DataRow = filas(0)
                    Dim precioOriginal As Decimal = Convert.ToDecimal(fila("PRO_PRECIO"))
                    Dim precioFinal As Decimal = Convert.ToDecimal(fila("PRECIO_FINAL"))
                    Dim dr As DataRow = dtCarrito.NewRow()
                    dr("HIP_ID") = hipId
                    dr("PRO_REFERENCIA") = fila("PRO_REFERENCIA").ToString()
                    dr("PRO_NOMBRE") = fila("PRO_NOMBRE").ToString()
                    dr("PRO_PRECIO") = precioOriginal
                    dr("PRECIO_FINAL") = precioFinal
                    dr("CANTIDAD") = cantidad
                    dr("CAMP_NOMBRE") = If(IsDBNull(fila("CAMP_NOMBRE")), "", fila("CAMP_NOMBRE").ToString())
                    dtCarrito.Rows.Add(dr)
                    totalFinal += precioFinal * cantidad
                End If
            Next

            rptCarrito.DataSource = dtCarrito
            rptCarrito.DataBind()
            rptResumenPrecios.DataSource = dtCarrito
            rptResumenPrecios.DataBind()
            lblCantItemsHead.Text = dtCarrito.Rows.Count.ToString()

            lblTotal.Text = totalFinal.ToString("N2")
            pnlVacio.Visible = False
            pnlCarrito.Visible = True
            Dim totalCantidad As Integer = 0
            For Each row As DataRow In dtCarrito.Rows
                totalCantidad += Convert.ToInt32(row("CANTIDAD"))
            Next
            lblCantItemsResumen.Text = totalCantidad.ToString()
        End Sub

        Protected Sub rptCarrito_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
            Dim hipId As String = e.CommandArgument.ToString()
            Dim carrito As List(Of Dictionary(Of String, String)) = ObtenerCarritoSession()

            Select Case e.CommandName
                Case "Sumar"
                    For Each item As Dictionary(Of String, String) In carrito
                        If item("HIP_ID") = hipId Then
                            item("CANTIDAD") = (Convert.ToInt32(item("CANTIDAD")) + 1).ToString()
                            Exit For
                        End If
                    Next
                Case "Restar"
                    Dim itemAQuitar As Dictionary(Of String, String) = Nothing
                    For Each item As Dictionary(Of String, String) In carrito
                        If item("HIP_ID") = hipId Then
                            Dim cant As Integer = Convert.ToInt32(item("CANTIDAD")) - 1
                            If cant <= 0 Then
                                itemAQuitar = item
                            Else
                                item("CANTIDAD") = cant.ToString()
                            End If
                            Exit For
                        End If
                    Next
                    If itemAQuitar IsNot Nothing Then carrito.Remove(itemAQuitar)
                Case "Quitar"
                    Dim itemAQuitar As Dictionary(Of String, String) = Nothing
                    For Each item As Dictionary(Of String, String) In carrito
                        If item("HIP_ID") = hipId Then
                            itemAQuitar = item
                            Exit For
                        End If
                    Next
                    If itemAQuitar IsNot Nothing Then carrito.Remove(itemAQuitar)
            End Select

            Session("CARRITO_TEMP") = carrito
            CargarCarrito()
        End Sub

        Protected Sub btnPagar_Click(sender As Object, e As EventArgs)
            If Session("CLI_CLIENTE") Is Nothing Then
                Response.Redirect("~/Modules/Cliente/Login.aspx?returnUrl=/Modules/Cliente/Factura.aspx")
            Else
                Response.Redirect("~/Modules/Cliente/Factura.aspx")
            End If
            Dim carrito = ObtenerCarritoSession()
            Dim dtCatalogo As DataTable = CatalogoClienteService.Listar()
            For Each item As Dictionary(Of String, String) In carrito
                Dim hipId As Integer = Convert.ToInt32(item("HIP_ID"))
                Dim cantidad As Integer = Convert.ToInt32(item("CANTIDAD"))
                Dim filas As DataRow() = dtCatalogo.Select("HV_HISTORIAL_PRECIO_VENTA = " & hipId)
                If filas.Length > 0 Then
                    Dim stockDisponible As Integer = Convert.ToInt32(filas(0)("STO_DISPONIBLE"))
                    Dim nombreProducto As String = filas(0)("PRO_NOMBRE").ToString()
                    If cantidad > stockDisponible Then
                        lblMsg.Text = "Lo sentimos, solo hay " & stockDisponible & " unidad(es) disponible(s) de """ & nombreProducto & """. Por favor ajusta la cantidad."
                        lblMsg.CssClass = "alert-err"
                        pnlMsg.Visible = True
                        Return
                    End If
                End If
            Next

            Response.Redirect("~/Modules/Cliente/Factura.aspx")
        End Sub

        Private Function ObtenerCarritoSession() As List(Of Dictionary(Of String, String))
            If Session("CARRITO_TEMP") Is Nothing Then
                Return New List(Of Dictionary(Of String, String))
            End If
            Return CType(Session("CARRITO_TEMP"), List(Of Dictionary(Of String, String)))
        End Function

    End Class

End Namespace