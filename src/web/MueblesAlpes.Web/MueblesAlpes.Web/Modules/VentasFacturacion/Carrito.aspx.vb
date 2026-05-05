Imports Oracle.ManagedDataAccess.Client

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
            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("SELECT CLI_CLIENTE, CLI_PRIMER_NOMBRE || ' ' || CLI_PRIMER_APELLIDO AS NOMBRE_COMPLETO FROM CLI_CLIENTE", conn)
            Try
                conn.Open()
                Dim da As New OracleDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                ddlCliente.DataSource = dt
                ddlCliente.DataTextField = "NOMBRE_COMPLETO"
                ddlCliente.DataValueField = "CLI_CLIENTE"
                ddlCliente.DataBind()
                ddlCliente.Items.Insert(0, New ListItem("-- Seleccione --", ""))
            Catch ex As Exception
                MostrarMensaje("Error al cargar clientes: " & ex.Message, "alert-danger")
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
                gvCarritos.DataSource = dt
                gvCarritos.DataBind()
            Catch ex As Exception
                MostrarMensaje("Error al cargar carritos: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Private Sub CargarProductosCarrito(ByVal carritoId As Integer)
            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("SELECT cd.DETCAR_DETALLE_CARRITO, bh.PRO_REFERENCIA, cd.DETPRE_CANTIDAD FROM CLI_DETALLE_CARRITO cd JOIN BOD_HISTORIAL_PRECIO bh ON cd.HIP_HISTORIAL_PRECIO = bh.HIP_HISTORIAL_PRECIO WHERE cd.PRE_CARRITO = :p_carrito", conn)
            cmd.Parameters.Add("p_carrito", OracleDbType.Int32).Value = carritoId
            Try
                conn.Open()
                Dim da As New OracleDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                gvProductosCarrito.DataSource = dt
                gvProductosCarrito.DataBind()
            Catch ex As Exception
                MostrarMensaje("Error al cargar productos del carrito: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs)
            If ddlCliente.SelectedValue = "" Then
                MostrarMensaje("Debe seleccionar un cliente.", "alert-danger")
                Return
            End If
            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("PKG_CLI_CARRITO.CARRITO_CREAR", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_cliente", OracleDbType.Int32).Value = Convert.ToInt32(ddlCliente.SelectedValue)
            Dim pId As New OracleParameter("p_id", OracleDbType.Int32)
            pId.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pId)
            Try
                conn.Open()
                cmd.ExecuteNonQuery()
                MostrarMensaje("Carrito creado exitosamente.", "alert-success")
                LimpiarFormulario()
                CargarCarritos()
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs)
            LimpiarFormulario()
        End Sub

        Protected Sub btnCerrarDetalle_Click(ByVal sender As Object, ByVal e As EventArgs)
            pnlDetalle.Visible = False
            hfCarritoDetalle.Value = ""
            lblCarritoSeleccionado.Text = ""
        End Sub

        Protected Sub btnAgregarProducto_Click(ByVal sender As Object, ByVal e As EventArgs)
            If ddlProducto.SelectedValue = "" Then
                MostrarMensaje("Debe seleccionar un producto.", "alert-danger")
                Return
            End If
            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("PKG_CLI_CARRITO.CARRITO_AGREGAR_DETALLE", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_carrito", OracleDbType.Int32).Value = Convert.ToInt32(hfCarritoDetalle.Value)
            cmd.Parameters.Add("p_hist_precio", OracleDbType.Int32).Value = Convert.ToInt32(ddlProducto.SelectedValue)
            cmd.Parameters.Add("p_cantidad", OracleDbType.Int32).Value = Convert.ToInt32(txtCantidad.Text.Trim())
            Dim pId As New OracleParameter("p_id", OracleDbType.Int32)
            pId.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pId)
            Try
                conn.Open()
                cmd.ExecuteNonQuery()
                MostrarMensaje("Producto agregado exitosamente.", "alert-success")
                CargarProductosCarrito(Convert.ToInt32(hfCarritoDetalle.Value))
                CargarCarritos()
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Protected Sub gvCarritos_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
            If e.CommandName = "VerDetalle" Then
                hfCarritoDetalle.Value = e.CommandArgument.ToString()
                lblCarritoSeleccionado.Text = e.CommandArgument.ToString()
                pnlDetalle.Visible = True
                CargarProductosCarrito(Convert.ToInt32(e.CommandArgument.ToString()))
            ElseIf e.CommandName = "Vaciar" Then
                Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
                Dim cmd As New OracleCommand("PKG_CLI_CARRITO.CARRITO_VACIAR", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("p_carrito", OracleDbType.Int32).Value = Convert.ToInt32(e.CommandArgument.ToString())
                Try
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    MostrarMensaje("Carrito vaciado exitosamente.", "alert-success")
                    CargarCarritos()
                    pnlDetalle.Visible = False
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, "alert-danger")
                Finally
                    conn.Close()
                End Try
            ElseIf e.CommandName = "Eliminar" Then
                Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
                Dim cmd As New OracleCommand("DELETE FROM CLI_CARRITO WHERE PRE_CARRITO = :p_id", conn)
                cmd.Parameters.Add("p_id", OracleDbType.Int32).Value = Convert.ToInt32(e.CommandArgument.ToString())
                Try
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    MostrarMensaje("Carrito eliminado exitosamente.", "alert-success")
                    CargarCarritos()
                    pnlDetalle.Visible = False
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, "alert-danger")
                Finally
                    conn.Close()
                End Try
            End If
        End Sub

        Protected Sub gvProductosCarrito_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
            If e.CommandName = "EliminarDetalle" Then
                Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
                Dim cmd As New OracleCommand("PKG_CLI_CARRITO.CARRITO_ELIMINAR_DETALLE", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("p_id", OracleDbType.Int32).Value = Convert.ToInt32(e.CommandArgument.ToString())
                Try
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    MostrarMensaje("Producto eliminado del carrito.", "alert-success")
                    CargarProductosCarrito(Convert.ToInt32(hfCarritoDetalle.Value))
                    CargarCarritos()
                Catch ex As Exception
                    MostrarMensaje("Error: " & ex.Message, "alert-danger")
                Finally
                    conn.Close()
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