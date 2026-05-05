Imports Oracle.ManagedDataAccess.Client

Namespace Modules.VentasFacturacion
    Public Class DetalleCarrito
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarCarritos()
                CargarProductos()
                CargarDetalles()
            End If
        End Sub

        Private Sub CargarCarritos()
            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("PKG_CLI_CARRITO.CARRITO_LISTAR", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_data", OracleDbType.RefCursor).Direction = ParameterDirection.Output
            Try
                conn.Open()
                Dim da As New OracleDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                ddlCarrito.DataSource = dt
                ddlCarrito.DataTextField = "PRE_CORRELATIVO"
                ddlCarrito.DataValueField = "PRE_CARRITO"
                ddlCarrito.DataBind()
                ddlCarrito.Items.Insert(0, New ListItem("-- Seleccione --", ""))
            Catch ex As Exception
                MostrarMensaje("Error al cargar carritos: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Private Sub CargarProductos()
            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("SELECT HIP_HISTORIAL_PRECIO, PRO_REFERENCIA FROM BOD_HISTORIAL_PRECIO", conn)
            Try
                conn.Open()
                Dim da As New OracleDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                ddlProducto.DataSource = dt
                ddlProducto.DataTextField = "PRO_REFERENCIA"
                ddlProducto.DataValueField = "HIP_HISTORIAL_PRECIO"
                ddlProducto.DataBind()
                ddlProducto.Items.Insert(0, New ListItem("-- Seleccione --", ""))
            Catch ex As Exception
                MostrarMensaje("Error al cargar productos: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Private Sub CargarDetalles()
            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("SELECT c.PRE_CORRELATIVO, LISTAGG(bh.PRO_REFERENCIA, ', ') WITHIN GROUP (ORDER BY bh.PRO_REFERENCIA) AS PRODUCTOS, SUM(cd.DETPRE_CANTIDAD) AS TOTAL_CANTIDAD FROM CLI_DETALLE_CARRITO cd JOIN CLI_CARRITO c ON cd.PRE_CARRITO = c.PRE_CARRITO JOIN BOD_HISTORIAL_PRECIO bh ON cd.HIP_HISTORIAL_PRECIO = bh.HIP_HISTORIAL_PRECIO GROUP BY c.PRE_CORRELATIVO ORDER BY c.PRE_CORRELATIVO", conn)
            Try
                conn.Open()
                Dim da As New OracleDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                gvDetalles.DataSource = dt
                gvDetalles.DataBind()
            Catch ex As Exception
                MostrarMensaje("Error al cargar detalles: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs)
            If ddlCarrito.SelectedValue = "" Then
                MostrarMensaje("Debe seleccionar un carrito.", "alert-danger")
                Return
            End If
            If ddlProducto.SelectedValue = "" Then
                MostrarMensaje("Debe seleccionar un producto.", "alert-danger")
                Return
            End If
            If txtCantidad.Text.Trim() = "" Then
                MostrarMensaje("Debe ingresar una cantidad.", "alert-danger")
                Return
            End If

            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("PKG_CLI_CARRITO.CARRITO_AGREGAR_DETALLE", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_carrito", OracleDbType.Int32).Value = Convert.ToInt32(ddlCarrito.SelectedValue)
            cmd.Parameters.Add("p_hist_precio", OracleDbType.Int32).Value = Convert.ToInt32(ddlProducto.SelectedValue)
            cmd.Parameters.Add("p_cantidad", OracleDbType.Int32).Value = Convert.ToInt32(txtCantidad.Text.Trim())
            Dim pId As New OracleParameter("p_id", OracleDbType.Int32)
            pId.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pId)
            Try
                conn.Open()
                cmd.ExecuteNonQuery()
                MostrarMensaje("Producto agregado al carrito exitosamente.", "alert-success")
                LimpiarFormulario()
                CargarDetalles()
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs)
            LimpiarFormulario()
        End Sub

        Protected Sub gvDetalles_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
            If e.CommandName = "Eliminar" Then
                Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
                Dim cmd As New OracleCommand("PKG_CLI_CARRITO.CARRITO_ELIMINAR_DETALLE", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("p_id", OracleDbType.Int32).Value = e.CommandArgument.ToString()
                Try
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    MostrarMensaje("Producto eliminado del carrito.", "alert-success")
                    CargarDetalles()
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, "alert-danger")
                Finally
                    conn.Close()
                End Try
            End If
        End Sub

        Private Sub LimpiarFormulario()
            txtCantidad.Text = "1"
            ddlCarrito.SelectedIndex = 0
            ddlProducto.SelectedIndex = 0
            hfDetalle.Value = ""
        End Sub

        Private Sub MostrarMensaje(ByVal msg As String, ByVal css As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert " & css
            pnlMsg.Visible = True
        End Sub

    End Class
End Namespace