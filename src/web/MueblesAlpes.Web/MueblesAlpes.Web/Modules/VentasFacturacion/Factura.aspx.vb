Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.VentasFacturacion
    Public Class Factura
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarCarritos()
                CargarEmpleados()
                CargarFacturas()
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

        Private Sub CargarEmpleados()
            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("SELECT EM_EMPLEADO, EM_PRIMER_NOMBRE || ' ' || EM_PRIMER_APELLIDO AS NOMBRE_COMPLETO FROM RH_EMPLEADO", conn)
            Try
                conn.Open()
                Dim da As New OracleDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                ddlEmpleado.DataSource = dt
                ddlEmpleado.DataTextField = "NOMBRE_COMPLETO"
                ddlEmpleado.DataValueField = "EM_EMPLEADO"
                ddlEmpleado.DataBind()
                ddlEmpleado.Items.Insert(0, New ListItem("-- Seleccione --", ""))
            Catch ex As Exception
                MostrarMensaje("Error al cargar empleados: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Private Sub CargarFacturas()
            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("PKG_FAC_FACTURA_CLIENTE.FACTURA_LISTAR", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_data", OracleDbType.RefCursor).Direction = ParameterDirection.Output
            Try
                conn.Open()
                Dim da As New OracleDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                gvFacturas.DataSource = dt
                gvFacturas.DataBind()
            Catch ex As Exception
                MostrarMensaje("Error al cargar facturas: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Dim cmd As New OracleCommand("PKG_FAC_FACTURA_CLIENTE.FACTURA_CREAR", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_presupuesto", OracleDbType.Int32).Value = ddlCarrito.SelectedValue
            cmd.Parameters.Add("p_empleado", OracleDbType.Int32).Value = ddlEmpleado.SelectedValue
            Dim pCodigo As New OracleParameter("p_codigo_factura", OracleDbType.Varchar2, 50)
            pCodigo.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pCodigo)
            Try
                conn.Open()
                cmd.ExecuteNonQuery()
                txtCodigoFactura.Text = pCodigo.Value.ToString()
                MostrarMensaje("Factura generada exitosamente. Código: " & txtCodigoFactura.Text, "alert-success")
                CargarFacturas()
            Catch ex As Exception
                MostrarMensaje("Error: " & ex.Message, "alert-danger")
            Finally
                conn.Close()
            End Try
        End Sub

        Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs)
            LimpiarFormulario()
        End Sub

        Private Sub LimpiarFormulario()
            txtCodigoFactura.Text = ""
            ddlCarrito.SelectedIndex = 0
            ddlEmpleado.SelectedIndex = 0
        End Sub

        Private Sub MostrarMensaje(ByVal msg As String, ByVal css As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert " & css
            pnlMsg.Visible = True
        End Sub

    End Class
End Namespace