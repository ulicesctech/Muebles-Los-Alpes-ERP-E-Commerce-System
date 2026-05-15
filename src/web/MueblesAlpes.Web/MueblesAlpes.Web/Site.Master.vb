Imports System.Web.UI
Imports System.Data
Imports System.Web

Partial Public Class SiteMaster
    Inherits MasterPage

    Protected Sub Page_Load(sender As Object, e As EventArgs)

        ' Evita que el navegador guarde páginas viejas en caché.
        ' Esto ayuda a que catálogo, precios, promociones y carrito carguen datos frescos.
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.Cache.SetNoStore()
        Response.Cache.SetExpires(DateTime.UtcNow.AddDays(-1))
        Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches)

        Dim url As String = Request.AppRelativeCurrentExecutionFilePath.ToLower()

        Dim esVistaCliente As Boolean = url.Contains("modules/cliente/") OrElse
                                    url.Contains("modules/authusuarios/logincliente")

        Dim esPaginaLogin As Boolean = url.Contains("authusuarios/loginempleado") OrElse
                                   url.Contains("authusuarios/logincliente")

        If Not esVistaCliente AndAlso Not esPaginaLogin Then
            If Session("UsuarioId") Is Nothing Then
                Response.Redirect("~/Modules/AuthUsuarios/LoginEmpleado.aspx")
                Return
            End If
        End If

        pnlHeader.Visible = Not url.Contains("authusuarios/loginempleado")
        lnkLogo.NavigateUrl = If(esVistaCliente, "~/Modules/Cliente/Catalogo.aspx", "~/")
        pnlNavAdmin.Visible = Not esVistaCliente AndAlso Not esPaginaLogin
        pnlNavCliente.Visible = esVistaCliente AndAlso Not esPaginaLogin

        pnlCarritoHeader.Visible = esVistaCliente

        If esVistaCliente Then
            If Session("CLI_CLIENTE") IsNot Nothing Then
                pnlNoLogueado.Visible = False
                pnlLogueado.Visible = True
                pnlNavLogueado.Visible = True
                pnlNavNoLogueado.Visible = False
                liMisCompras.Visible = True

                Dim nombre As String = If(Session("CLI_NOMBRE") IsNot Nothing,
                    Session("CLI_NOMBRE").ToString().Split(" ")(0), "Cliente")

                lblNombreCliente.Text = nombre
                lblNavNombre.Text = nombre
            Else
                pnlNoLogueado.Visible = True
                pnlLogueado.Visible = False
                pnlNavLogueado.Visible = False
                pnlNavNoLogueado.Visible = True
                liMisCompras.Visible = False
                lnkLogin.NavigateUrl = "~/Modules/AuthUsuarios/LoginCliente.aspx"
            End If

        ElseIf Not esPaginaLogin Then
            If Session("UsuarioId") IsNot Nothing Then
                pnlNoLogueado.Visible = False
                pnlLogueado.Visible = True
                pnlNavLogueado.Visible = False
                pnlNavNoLogueado.Visible = False
                liMisCompras.Visible = False

                lblNombreCliente.Text = If(Session("UsuarioNombre") IsNot Nothing,
                    Session("UsuarioNombre").ToString().Split(" ")(0), "Admin")
            Else
                pnlNoLogueado.Visible = False
                pnlLogueado.Visible = False
                pnlNavLogueado.Visible = False
                pnlNavNoLogueado.Visible = False
                liMisCompras.Visible = False
            End If

        Else
            pnlNoLogueado.Visible = False
            pnlLogueado.Visible = False
            pnlNavLogueado.Visible = False
            pnlNavNoLogueado.Visible = False
            liMisCompras.Visible = False
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
                        Dim filas As DataRow() = dtCatalogo.Select("HV_HISTORIAL_PRECIO_VENTA = " & item("HIP_ID"))

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
        If Session("UsuarioId") IsNot Nothing Then
            Session.Remove("UsuarioId")
            Session.Remove("UsuarioNombre")
            Session.Remove("UsuarioGrupo")
            Session.Remove("UsuarioTipo")

            Response.Redirect("~/Modules/AuthUsuarios/LoginEmpleado.aspx")
        Else
            Session.Remove("CLI_CLIENTE")
            Session.Remove("CLI_NOMBRE")
            Session.Remove("CLI_EMAIL")
            Session.Remove("CARRITO_TEMP")

            Response.Redirect("~/Modules/Cliente/Catalogo.aspx")
        End If
    End Sub

End Class