Imports System.Data

Namespace Modules.ComprasProveedor

    Partial Public Class OrdenesCompra
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarOrdenes()
                CargarProveedores()
            End If
        End Sub

        '========================
        ' LISTADO
        '========================
        Private Sub CargarOrdenes()
            gvOrdenes.DataSource = OrdenCompraService.Listar()
            gvOrdenes.DataBind()
        End Sub

        Private Sub CargarProveedores()
            CargarProveedoresEnDropDown(ddlProveedor)
        End Sub

        Private Sub CargarProveedoresEnDropDown(ddl As DropDownList)
            Dim dt As DataTable = ProveedorService.Listar()
            ddl.DataSource = dt
            ddl.DataTextField = "PROV_NOMBRE"
            ddl.DataValueField = "PROV_PROVEEDOR"
            ddl.DataBind()
            ddl.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
        End Sub

        Private Sub MostrarMsg(texto As String, esError As Boolean)
            lblMsg.Text = texto
            lblMsg.CssClass = If(esError, "alert-err", "alert-ok")
            pnlMsg.Visible = True
        End Sub

        '========================
        ' HELPERS ESTADO CABECERA
        '========================
        Private Sub BloquearCabecera()
            txtIDOrden.ReadOnly = True
            txtCodigo.ReadOnly = True
            ddlProveedor.Enabled = False
            btnGuardar.Enabled = False
        End Sub

        Private Sub DesbloquearCabecera()
            txtIDOrden.ReadOnly = False
            txtCodigo.ReadOnly = False
            ddlProveedor.Enabled = True
            btnGuardar.Enabled = True
        End Sub

        Private Sub CerrarTodosLosPaneles()
            pnlFormCabecera.Visible = False
            pnlDetalleOrden.Visible = False
            pnlMsg.Visible = False
            DesbloquearCabecera()
        End Sub

        '========================
        ' BOTONES CABECERA
        '========================
        Protected Sub btnNuevaOrden_Click(sender As Object, e As EventArgs)
            pnlFormCabecera.Visible = True
            pnlDetalleOrden.Visible = False
            pnlMsg.Visible = False
            txtIDOrden.Text = ""
            txtCodigo.Text = ""
            DesbloquearCabecera()
            If ddlProveedor.Items.Count > 0 Then ddlProveedor.SelectedIndex = 0
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            CerrarTodosLosPaneles()
        End Sub

        Protected Sub btnCerrarDetalle_Click(sender As Object, e As EventArgs)
            CerrarTodosLosPaneles()
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Try
                Dim orcKey As String = txtIDOrden.Text.Trim()
                Dim codigo As String = txtCodigo.Text.Trim()
                Dim provId As Decimal = Convert.ToDecimal(ddlProveedor.SelectedValue)

                If String.IsNullOrEmpty(orcKey) OrElse String.IsNullOrEmpty(codigo) OrElse provId = 0 Then
                    MostrarMsg("Complete todos los campos requeridos.", True)
                    Exit Sub
                End If

                OrdenCompraService.Crear(orcKey, codigo, provId, 0)

                BloquearCabecera()

                hfOrdenActiva.Value = orcKey
                lblOrdenSeleccionada.Text = orcKey
                pnlDetalleOrden.Visible = True

                CargarOrdenes()
                CargarDetalle(orcKey)
                MostrarMsg("Orden creada. Agrega los items y presiona 'Finalizar Orden'.", False)
            Catch ex As Exception
                MostrarMsg("Error: " & ex.Message, True)
            End Try
        End Sub

        Protected Sub btnFinalizarOrden_Click(sender As Object, e As EventArgs)
            Try
                Dim orcKey As String = hfOrdenActiva.Value
                If Not String.IsNullOrEmpty(orcKey) Then
                    ActualizarTotalOrden(orcKey)
                End If
                CargarOrdenes()
                CerrarTodosLosPaneles()
                MostrarMsg("Orden finalizada y guardada correctamente.", False)
            Catch ex As Exception
                MostrarMsg("Error al finalizar: " & ex.Message, True)
            End Try
        End Sub

        '========================
        ' GRID ORDENES
        '========================
        Protected Sub gvOrdenes_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "VerDetalle" Then
                Dim orcKey As String = e.CommandArgument.ToString()
                hfOrdenActiva.Value = orcKey
                lblOrdenSeleccionada.Text = orcKey
                pnlDetalleOrden.Visible = True
                pnlFormCabecera.Visible = False
                gvItemsOrden.EditIndex = -1
                CargarDetalle(orcKey)
            End If
        End Sub

        Protected Sub gvOrdenes_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
            Try
                Dim orcKey As String = gvOrdenes.DataKeys(e.RowIndex).Value.ToString()
                OrdenCompraService.Eliminar(orcKey)
                If hfOrdenActiva.Value = orcKey Then
                    pnlDetalleOrden.Visible = False
                End If
                CargarOrdenes()
                MostrarMsg("Orden eliminada.", False)
            Catch ex As Exception
                MostrarMsg("Error: " & ex.Message, True)
            End Try
        End Sub

        Protected Sub gvOrdenes_RowEditing(sender As Object, e As GridViewEditEventArgs)
            gvOrdenes.EditIndex = e.NewEditIndex
            CargarOrdenes()
        End Sub

        Protected Sub gvOrdenes_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
            gvOrdenes.EditIndex = -1
            CargarOrdenes()
        End Sub

        Protected Sub gvOrdenes_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
            Try
                Dim row As GridViewRow = gvOrdenes.Rows(e.RowIndex)
                Dim orcKey As String = gvOrdenes.DataKeys(e.RowIndex).Value.ToString()
                Dim codigo As String = CType(row.FindControl("txtEditCodigo"), TextBox).Text
                Dim provId As Decimal = Convert.ToDecimal(CType(row.FindControl("ddlEditProv"), DropDownList).SelectedValue)

                OrdenCompraService.Actualizar(orcKey, codigo, provId, 0)
                gvOrdenes.EditIndex = -1
                CargarOrdenes()
            Catch ex As Exception
                MostrarMsg("Error: " & ex.Message, True)
            End Try
        End Sub

        ' Sub-grid de ítems dentro de cada fila del listado principal
        Protected Sub gvOrdenes_RowDataBound(sender As Object, e As GridViewRowEventArgs)
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim orcKey As String = gvOrdenes.DataKeys(e.Row.RowIndex).Value.ToString()
                Dim gvSub As GridView = CType(e.Row.FindControl("gvSubItems"), GridView)
                If gvSub IsNot Nothing Then
                    Dim dt As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
                    gvSub.DataSource = dt
                    gvSub.DataBind()
                    gvSub.Visible = (dt.Rows.Count > 0)
                End If
            End If
        End Sub

        '========================
        ' DETALLE ORDEN (panel edición)
        '========================
        Private Sub CargarDetalle(orcKey As String)
            Dim dt As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
            gvItemsOrden.DataSource = dt
            gvItemsOrden.DataBind()
            CalcularTotal(dt)
        End Sub

        Private Sub CalcularTotal(dt As DataTable)
            Dim total As Decimal = 0
            For Each row As DataRow In dt.Rows
                Dim precio As Decimal = If(IsDBNull(row("ODP_PRECIO")), 0D, Convert.ToDecimal(row("ODP_PRECIO")))
                Dim cantidad As Decimal = If(IsDBNull(row("ODP_CANTIDAD")), 0D, Convert.ToDecimal(row("ODP_CANTIDAD")))
                total += precio * cantidad
            Next
            lblTotalOrden.Text = total.ToString("N2")
        End Sub

        '========================
        ' AGREGAR ITEM
        '========================
        Protected Sub btnAddMat_Click(sender As Object, e As EventArgs)
            Try
                Dim orcKey As String = hfOrdenActiva.Value
                Dim material As String = txtMat.Text.Trim()
                Dim precio As Decimal
                Dim cantidad As Integer

                If String.IsNullOrEmpty(material) Then
                    MostrarMsg("Ingrese el material.", True) : Exit Sub
                End If
                If Not Decimal.TryParse(txtPre.Text, precio) Then
                    MostrarMsg("Precio invalido.", True) : Exit Sub
                End If
                If Not Integer.TryParse(txtCan.Text, cantidad) Then
                    MostrarMsg("Cantidad invalida.", True) : Exit Sub
                End If

                OrdenDetallePedidoService.Insertar(orcKey, 1, material, precio, cantidad)

                txtMat.Text = ""
                txtPre.Text = ""
                txtCan.Text = ""

                CargarDetalle(orcKey)
                ActualizarTotalOrden(orcKey)
                CargarOrdenes()
            Catch ex As Exception
                MostrarMsg("Error: " & ex.Message, True)
            End Try
        End Sub

        Private Sub ActualizarTotalOrden(orcKey As String)
            Dim dt As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
            Dim total As Decimal = 0
            For Each row As DataRow In dt.Rows
                Dim p As Decimal = If(IsDBNull(row("ODP_PRECIO")), 0D, Convert.ToDecimal(row("ODP_PRECIO")))
                Dim c As Decimal = If(IsDBNull(row("ODP_CANTIDAD")), 0D, Convert.ToDecimal(row("ODP_CANTIDAD")))
                total += p * c
            Next
            OrdenCompraService.ActualizarTotal(orcKey, total)
        End Sub

        '========================
        ' GRID DETALLE — edición inline
        '========================
        Protected Sub gvItemsOrden_RowEditing(sender As Object, e As GridViewEditEventArgs)
            gvItemsOrden.EditIndex = e.NewEditIndex
            CargarDetalle(hfOrdenActiva.Value)
        End Sub

        Protected Sub gvItemsOrden_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
            gvItemsOrden.EditIndex = -1
            CargarDetalle(hfOrdenActiva.Value)
        End Sub

        Protected Sub gvItemsOrden_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
            Try
                Dim row As GridViewRow = gvItemsOrden.Rows(e.RowIndex)
                Dim id As Integer = Convert.ToInt32(gvItemsOrden.DataKeys(e.RowIndex).Value)
                Dim material As String = CType(row.FindControl("txtEMat"), TextBox).Text.Trim()
                Dim precio As Decimal = Convert.ToDecimal(CType(row.FindControl("txtEPre"), TextBox).Text)
                Dim cantidad As Integer = Convert.ToInt32(CType(row.FindControl("txtECan"), TextBox).Text)

                OrdenDetallePedidoService.Actualizar(id, material, precio, cantidad)

                gvItemsOrden.EditIndex = -1
                CargarDetalle(hfOrdenActiva.Value)
                ActualizarTotalOrden(hfOrdenActiva.Value)
                CargarOrdenes()
            Catch ex As Exception
                MostrarMsg("Error al guardar: " & ex.Message, True)
            End Try
        End Sub

        Protected Sub gvItemsOrden_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "BorrarItem" Then
                Try
                    OrdenDetallePedidoService.Eliminar(Convert.ToInt32(e.CommandArgument))
                    CargarDetalle(hfOrdenActiva.Value)
                    ActualizarTotalOrden(hfOrdenActiva.Value)
                    CargarOrdenes()
                Catch ex As Exception
                    MostrarMsg("Error: " & ex.Message, True)
                End Try
            End If
        End Sub

        '========================
        ' BUSCAR / LIMPIAR
        '========================
        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            Dim filtro As String = txtBuscar.Text.Trim()
            If String.IsNullOrEmpty(filtro) Then
                CargarOrdenes()
            Else
                gvOrdenes.DataSource = OrdenCompraService.Buscar(filtro)
                gvOrdenes.DataBind()
            End If
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            pnlMsg.Visible = False
            CargarOrdenes()
        End Sub

    End Class

End Namespace