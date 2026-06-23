Imports System.Data
Imports System.Linq
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.Cliente

    Public Class Factura
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                If Session("CLI_CLIENTE") IsNot Nothing Then
                    pnlDocumento.Visible = True
                    ddlTipoDoc.Enabled = False
                    txtNumDoc.ReadOnly = True
                    txtNombre.ReadOnly = True
                    txtEmail.ReadOnly = True
                    txtTelefono.ReadOnly = True
                    CargarDatosCliente()
                Else
                    pnlDocumento.Visible = True
                End If
                If Session("CARRITO_TEMP") IsNot Nothing Then
                    Dim carrito = CType(Session("CARRITO_TEMP"), List(Of Dictionary(Of String, String)))
                    If carrito.Count > 0 Then
                        CargarResumen()
                        CargarAlmacenes()
                    End If
                End If
            End If
        End Sub

        Private Sub CargarAlmacenes()
            Try
                Dim carrito = CType(Session("CARRITO_TEMP"), List(Of Dictionary(Of String, String)))
                If carrito Is Nothing OrElse carrito.Count = 0 Then Return

                Dim hvIds As String = String.Join(",", carrito.Select(Function(i) i("HIP_ID")).ToArray())
                Dim dt As DataTable = CarritoService.AlmacenesConStock(hvIds)

                ddlSucursal.Items.Clear()
                ddlSucursal.Items.Add(New System.Web.UI.WebControls.ListItem("-- Selecciona una sucursal --", ""))

                If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                    For Each row As DataRow In dt.Rows
                        Dim item As New System.Web.UI.WebControls.ListItem(
                            row("ALM_NOMBRE").ToString() & " — " & row("ALM_UBICACION").ToString(),
                            row("ALM_ALMACEN").ToString())
                        ddlSucursal.Items.Add(item)
                    Next
                Else
                    ddlSucursal.Items.Clear()
                    ddlSucursal.Items.Add(New System.Web.UI.WebControls.ListItem("No hay sucursales con stock disponible", ""))
                End If
            Catch
            End Try
        End Sub

        Private Sub CargarDatosCliente()
            Try
                Dim clienteId As Integer = Convert.ToInt32(Session("CLI_CLIENTE"))
                Dim dt As DataTable = ClienteService.BuscarPorId(clienteId)
                If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                    Dim row As DataRow = dt.Rows(0)
                    txtNumDoc.Text = row("CLI_NUMDOCUMENTO").ToString()
                    ddlTipoDoc.SelectedValue = row("CLI_TIPODOCUMENTO").ToString()
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
                End If
            Catch
            End Try
        End Sub

        Private Sub CargarResumen()
            Try
                Dim carrito = CType(Session("CARRITO_TEMP"), List(Of Dictionary(Of String, String)))
                Dim dtCatalogo As DataTable = CatalogoClienteService.Listar()

                Dim dtResumen As New DataTable()
                dtResumen.Columns.Add("PRO_REFERENCIA")
                dtResumen.Columns.Add("PRO_NOMBRE")
                dtResumen.Columns.Add("PRO_PRECIO", GetType(Decimal))
                dtResumen.Columns.Add("PRECIO_FINAL", GetType(Decimal))
                dtResumen.Columns.Add("CANTIDAD", GetType(Integer))
                dtResumen.Columns.Add("CAMP_NOMBRE")

                Dim total As Decimal = 0

                For Each item As Dictionary(Of String, String) In carrito
                    Dim filas As DataRow() = dtCatalogo.Select("HV_HISTORIAL_PRECIO_VENTA = " & item("HIP_ID"))
                    If filas.Length > 0 Then
                        Dim precio As Decimal = Convert.ToDecimal(filas(0)("PRECIO_FINAL"))
                        Dim precioOriginal As Decimal = Convert.ToDecimal(filas(0)("PRO_PRECIO"))
                        Dim cant As Integer = Convert.ToInt32(item("CANTIDAD"))
                        Dim dr As DataRow = dtResumen.NewRow()
                        dr("PRO_REFERENCIA") = filas(0)("PRO_REFERENCIA").ToString()
                        dr("PRO_NOMBRE") = filas(0)("PRO_NOMBRE").ToString()
                        dr("PRO_PRECIO") = precioOriginal
                        dr("PRECIO_FINAL") = precio
                        dr("CANTIDAD") = cant
                        dr("CAMP_NOMBRE") = If(IsDBNull(filas(0)("CAMP_NOMBRE")), "", filas(0)("CAMP_NOMBRE").ToString())
                        dtResumen.Rows.Add(dr)
                        total += precio * cant
                    End If
                Next

                rptResumen.DataSource = dtResumen
                rptResumen.DataBind()
                lblTotal.Text = total.ToString("N2")
            Catch
            End Try
        End Sub

        Protected Sub btnConfirmar_Click(sender As Object, e As EventArgs)
            If Session("CARRITO_TEMP") Is Nothing Then
                MostrarError("Tu carrito está vacío. Por favor vuelve al catálogo.")
                Return
            End If

            If Session("CLI_CLIENTE") Is Nothing Then
                If ddlTipoDoc.SelectedValue = "DPI" AndAlso txtNumDoc.Text.Trim().Length <> 13 Then
                    MostrarError("El DPI debe tener exactamente 13 dígitos.")
                    Return
                End If
                If String.IsNullOrWhiteSpace(txtNumDoc.Text) Then
                    MostrarError("Por favor ingresa tu número de documento.")
                    Return
                End If
            End If

            If String.IsNullOrWhiteSpace(txtEmail.Text) Then
                MostrarError("Por favor ingresa tu email.")
                Return
            End If

            Dim tipoEntrega As String = hfTipoEntrega.Value
            If tipoEntrega = "SUCURSAL" Then
                If String.IsNullOrWhiteSpace(ddlSucursal.SelectedValue) Then
                    MostrarError("Por favor selecciona una sucursal.")
                    Return
                End If
            Else
                If String.IsNullOrWhiteSpace(txtCodigoPostal.Text) Then
                    MostrarError("Por favor ingresa tu código postal.")
                    Return
                End If
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

                    If hipId = 0 Then
                        MostrarError("Uno o más productos de tu carrito no tienen precio disponible. Por favor contáctanos.")
                        Return
                    End If

                    CarritoService.AgregarDetalle(carritoId, hipId, cantidad)
                Next

                CarritoService.Facturar(carritoId)

                Dim empleadoId As Integer = ObtenerEmpleadoAdmin()
                Dim almacenId As Integer = 0
                If tipoEntrega = "SUCURSAL" AndAlso Not String.IsNullOrWhiteSpace(ddlSucursal.SelectedValue) Then
                    almacenId = Convert.ToInt32(ddlSucursal.SelectedValue)
                End If

                Dim codigoFactura As String = FacturaClienteService.Crear(
                    carritoId, empleadoId, hfFormaPago.Value, tipoEntrega, almacenId)

                Session.Remove("CARRITO_TEMP")

                lblCodigoFactura.Text = codigoFactura
                lblTipoEntregaConfirmacion.Text = If(tipoEntrega = "SUCURSAL",
                    "📍 Recoge en: <strong>" & ddlSucursal.SelectedItem.Text & "</strong>",
                    "🏠 Envío a domicilio")
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
                Dim ps As New List(Of OracleParameter) From {
                    New OracleParameter("p_id", OracleDbType.Decimal, Nothing, ParameterDirection.Output)
                }
                OracleDb.ExecNonQuery("PKG_RH_EMPLEADO.EMP_OBTENER_ADMIN", ps)
                Dim val As String = ps(0).Value.ToString()
                If Not String.IsNullOrEmpty(val) AndAlso val <> "null" Then
                    Return Convert.ToInt32(val)
                End If
            Catch
            End Try
            Return 0
        End Function

        Private Function CrearClienteInvitado() As Integer
            Try
                Dim dt As DataTable = ClienteService.BuscarPorEmail(txtEmail.Text.Trim())
                If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                    Return Convert.ToInt32(dt.Rows(0)("CLI_CLIENTE"))
                End If
            Catch
            End Try

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