Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.Cliente

    Public Class Factura
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                If Session("CLI_CLIENTE") IsNot Nothing Then
                    CargarDatosCliente()
                End If
                If Session("CARRITO_TEMP") IsNot Nothing Then
                    Dim carrito = CType(Session("CARRITO_TEMP"), List(Of Dictionary(Of String, String)))
                    If carrito.Count > 0 Then
                        CargarResumen()
                    End If
                End If
            End If
        End Sub

        Private Sub CargarDatosCliente()
            Try
                Dim clienteId As Integer = Convert.ToInt32(Session("CLI_CLIENTE"))
                Dim dt As DataTable = OracleDb.ExecRefCursor(
                    "PKG_CLI_CLIENTE.CLI_BUSCAR",
                    New List(Of OracleParameter) From {
                        New OracleParameter("p_texto", OracleDbType.Varchar2, "", ParameterDirection.Input)
                    }, "p_data")

                For Each row As DataRow In dt.Rows
                    If Convert.ToInt32(row("CLI_CLIENTE")) = clienteId Then
                        txtNombre.Text = row("CLI_PRIMER_NOMBRE").ToString() & " " &
                                         row("CLI_PRIMER_APELLIDO").ToString()
                        txtEmail.Text = row("CLI_EMAIL").ToString()
                        txtTelefono.Text = row("CLI_PRIMER_TELEFONO").ToString()
                        txtDireccion.Text = row("CLI_DIRECCION").ToString()
                        txtMunicipio.Text = row("CLI_MUNICIPIO").ToString()
                        txtDepartamento.Text = row("CLI_DEPARTAMENTO").ToString()
                        txtZona.Text = row("CLI_ZONA").ToString()
                        txtCodigoPostal.Text = If(row("CLI_CODIGO_POSTAL") Is DBNull.Value, "", row("CLI_CODIGO_POSTAL").ToString())
                        txtNit.Text = If(row("CLI_NIT") Is DBNull.Value, "CF", row("CLI_NIT").ToString())
                        Exit For
                    End If
                Next
            Catch
            End Try
        End Sub

        Private Sub CargarResumen()
            Dim carrito = CType(Session("CARRITO_TEMP"), List(Of Dictionary(Of String, String)))
            Dim dtCatalogo As DataTable = CatalogoClienteService.Listar()

            Dim dtResumen As New DataTable()
            dtResumen.Columns.Add("PRO_REFERENCIA")
            dtResumen.Columns.Add("PRO_NOMBRE")
            dtResumen.Columns.Add("PRECIO_FINAL", GetType(Decimal))
            dtResumen.Columns.Add("CANTIDAD", GetType(Integer))

            Dim total As Decimal = 0

            For Each item As Dictionary(Of String, String) In carrito
                Dim filas As DataRow() = dtCatalogo.Select("HIP_HISTORIAL_PRECIO = " & item("HIP_ID"))
                If filas.Length > 0 Then
                    Dim precio As Decimal = Convert.ToDecimal(filas(0)("PRECIO_FINAL"))
                    Dim cant As Integer = Convert.ToInt32(item("CANTIDAD"))
                    Dim dr As DataRow = dtResumen.NewRow()
                    dr("PRO_REFERENCIA") = filas(0)("PRO_REFERENCIA").ToString()
                    dr("PRO_NOMBRE") = filas(0)("PRO_NOMBRE").ToString()
                    dr("PRECIO_FINAL") = precio
                    dr("CANTIDAD") = cant
                    dtResumen.Rows.Add(dr)
                    total += precio * cant
                End If
            Next

            rptResumen.DataSource = dtResumen
            rptResumen.DataBind()
            lblSubtotal.Text = total.ToString("N2")
            lblTotal.Text = total.ToString("N2")
        End Sub

        Protected Sub btnConfirmar_Click(sender As Object, e As EventArgs)
            If Session("CARRITO_TEMP") Is Nothing Then
                MostrarError("Tu carrito está vacío. Por favor vuelve al catálogo.")
                Return
            End If

            If String.IsNullOrWhiteSpace(txtNumDoc.Text) Then
                MostrarError("Por favor ingresa tu número de documento.")
                Return
            End If
            If String.IsNullOrWhiteSpace(txtEmail.Text) Then
                MostrarError("Por favor ingresa tu email.")
                Return
            End If
            If String.IsNullOrWhiteSpace(txtCodigoPostal.Text) Then
                MostrarError("Por favor ingresa tu código postal.")
                Return
            End If

            Try
                Dim carrito = CType(Session("CARRITO_TEMP"), List(Of Dictionary(Of String, String)))
                Dim clienteId As Integer

                If Session("CLI_CLIENTE") Is Nothing Then
                    clienteId = CrearClienteInvitado()
                Else
                    clienteId = Convert.ToInt32(Session("CLI_CLIENTE"))
                End If

                Dim carritoId As Integer = CarritoService.Crear(clienteId)

                Dim dtCatalogo As DataTable = CatalogoClienteService.Listar()
                For Each item As Dictionary(Of String, String) In carrito
                    Dim hipId As Integer = Convert.ToInt32(item("HIP_ID"))
                    Dim cantidad As Integer = Convert.ToInt32(item("CANTIDAD"))
                    CarritoService.AgregarDetalle(carritoId, hipId, cantidad)
                Next

                CarritoService.Facturar(carritoId)

                Dim empleadoId As Integer = ObtenerEmpleadoAdmin()
                Dim codigoFactura As String = FacturaClienteService.Crear(carritoId, empleadoId)

                Session.Remove("CARRITO_TEMP")

                lblCodigoFactura.Text = codigoFactura
                pnlCrearCuenta.Visible = (Session("CLI_CLIENTE") Is Nothing)
                pnlLogueadoOk.Visible = (Session("CLI_CLIENTE") IsNot Nothing)
                pnlCheckout.Visible = False
                pnlConfirmacion.Visible = True

            Catch ex As Exception
                If ex.Message.Contains("ORA-20012") OrElse ex.Message.Contains("stock insuficiente") Then
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modalStock",
            "document.getElementById('modalStock').style.display='flex';" &
            "document.getElementById('modalStockMsg').innerHTML='Lo sentimos, no hay suficiente stock para uno o más productos de tu carrito. Por favor ajusta las cantidades antes de continuar.';", True)
                Else
                    MostrarError("Error al procesar el pedido: " & ex.Message)
                End If
            End Try
        End Sub
        Private Function ObtenerEmpleadoAdmin() As Integer
            Try
                Using conn As New OracleConnection(
            System.Configuration.ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
                    Using cmd As New OracleCommand(
                "SELECT MIN(em_empleado) FROM RH_EMPLEADO", conn)
                        conn.Open()
                        Dim resultado As Object = cmd.ExecuteScalar()
                        If resultado IsNot Nothing AndAlso resultado IsNot DBNull.Value Then
                            Return Convert.ToInt32(resultado)
                        End If
                    End Using
                End Using
            Catch
            End Try
            Return 0
        End Function

        Private Function CrearClienteInvitado() As Integer
            ' Verificar si el email ya existe
            Try
                Dim dt As DataTable = OracleDb.ExecRefCursor(
            "PKG_CLI_CLIENTE.CLI_BUSCAR",
            New List(Of OracleParameter) From {
                New OracleParameter("p_texto", OracleDbType.Varchar2, txtEmail.Text.Trim(), ParameterDirection.Input)
            }, "p_data")

                For Each row As DataRow In dt.Rows
                    If row("CLI_EMAIL").ToString().ToLower() = txtEmail.Text.Trim().ToLower() Then
                        Return Convert.ToInt32(row("CLI_CLIENTE"))
                    End If
                Next
            Catch
            End Try

            ' Si no existe, crear nuevo cliente
            Dim partes As String() = txtNombre.Text.Trim().Split(" "c)
            Dim primerNombre As String = partes(0)
            Dim segundoNombre As String = ""
            Dim primerApellido As String = If(partes.Length > 1, partes(1), "Invitado")
            Dim segundoApellido As String = If(partes.Length > 2, partes(2), "")

            Dim clienteId As Integer = AuthClienteService.RegistrarCliente(
        ddlTipoDoc.SelectedValue,
        txtNumDoc.Text.Trim(),
        primerNombre,
        segundoNombre,
        primerApellido,
        segundoApellido,
        "Guatemala",
        If(String.IsNullOrWhiteSpace(txtDepartamento.Text), "Guatemala", txtDepartamento.Text.Trim()),
        If(String.IsNullOrWhiteSpace(txtMunicipio.Text), "Guatemala", txtMunicipio.Text.Trim()),
        If(String.IsNullOrWhiteSpace(txtZona.Text), "0", txtZona.Text.Trim()),
        If(String.IsNullOrWhiteSpace(txtDireccion.Text), "Sin dirección", txtDireccion.Text.Trim()),
        txtCodigoPostal.Text.Trim(),
        If(String.IsNullOrWhiteSpace(txtTelefono.Text), "00000000", txtTelefono.Text.Trim()),
        "",
        txtEmail.Text.Trim(),
        "",
        "NATURAL")

            Return clienteId
        End Function

        Private Sub MostrarError(msg As String)
            lblMsg.Text = msg
            lblMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

    End Class

End Namespace