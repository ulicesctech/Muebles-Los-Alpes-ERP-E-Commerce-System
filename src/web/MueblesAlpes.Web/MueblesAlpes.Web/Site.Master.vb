Imports System.Web.UI
Imports System.Data

Partial Public Class SiteMaster
    Inherits MasterPage

    Protected Sub Page_Load(sender As Object, e As EventArgs)
        Dim url As String = Request.AppRelativeCurrentExecutionFilePath.ToLower()
        Dim esVistaCliente As Boolean = url.Contains("modules/cliente/")
        pnlNavAdmin.Visible = Not esVistaCliente
        pnlNavCliente.Visible = esVistaCliente

        If Session("CLI_CLIENTE") IsNot Nothing Then
            pnlNoLogueado.Visible = False
            pnlLogueado.Visible = True
            pnlNavLogueado.Visible = True
            pnlNavNoLogueado.Visible = False
            Dim nombre As String = If(Session("CLI_NOMBRE") IsNot Nothing,
        Session("CLI_NOMBRE").ToString().Split(" ")(0), "Cliente")
            lblNombreCliente.Text = nombre
            lblNavNombre.Text = nombre
        Else
            pnlNoLogueado.Visible = True
            pnlLogueado.Visible = False
            pnlNavLogueado.Visible = False
            pnlNavNoLogueado.Visible = True
        End If

        ActualizarContadorCarrito()
    End Sub

    Private Sub ActualizarContadorCarrito()
        Dim count As Integer = 0
        Dim total As Decimal = 0
        Try
            If Session("CARRITO_TEMP") IsNot Nothing Then
                Dim carrito = CType(Session("CARRITO_TEMP"), List(Of Dictionary(Of String, String)))
                Dim dtCatalogo As DataTable = Nothing
                Try
                    dtCatalogo = CatalogoClienteService.Listar()
                Catch
                End Try

                Dim dtDrop As New DataTable()
                dtDrop.Columns.Add("PRO_REFERENCIA")
                dtDrop.Columns.Add("PRO_NOMBRE")
                dtDrop.Columns.Add("PRECIO_FINAL", GetType(Decimal))
                dtDrop.Columns.Add("CANTIDAD", GetType(Integer))

                For Each item As Dictionary(Of String, String) In carrito
                    count += Convert.ToInt32(item("CANTIDAD"))
                    If dtCatalogo IsNot Nothing Then
                        Dim filas As DataRow() = dtCatalogo.Select("HIP_HISTORIAL_PRECIO = " & item("HIP_ID"))
                        If filas.Length > 0 Then
                            Dim precio As Decimal = Convert.ToDecimal(filas(0)("PRECIO_FINAL"))
                            Dim cant As Integer = Convert.ToInt32(item("CANTIDAD"))
                            total += precio * cant
                            Dim dr As DataRow = dtDrop.NewRow()
                            dr("PRO_REFERENCIA") = filas(0)("PRO_REFERENCIA").ToString()
                            dr("PRO_NOMBRE") = filas(0)("PRO_NOMBRE").ToString()
                            dr("PRECIO_FINAL") = precio
                            dr("CANTIDAD") = cant
                            dtDrop.Rows.Add(dr)
                        End If
                    End If
                Next

                rptDropCarrito.DataSource = dtDrop
                rptDropCarrito.DataBind()
                lblDropTotal.Text = total.ToString("N2")
                lblDropCartCount.Text = count.ToString()
                pnlDropVacio.Visible = (count = 0)
            Else
                rptDropCarrito.DataSource = Nothing
                rptDropCarrito.DataBind()
                pnlDropVacio.Visible = True
            End If
        Catch
        End Try

        lblCartCount.Text = count.ToString()
        lblCartCount.Style("display") = If(count > 0, "flex", "none")
    End Sub

    Protected Sub btnCerrarSesion_Click(sender As Object, e As EventArgs)
        Session.Remove("CLI_CLIENTE")
        Session.Remove("CLI_NOMBRE")
        Session.Remove("CLI_EMAIL")
        Session.Remove("CARRITO_TEMP")
        Response.Redirect("~/Modules/Cliente/Catalogo.aspx")
    End Sub

End Class