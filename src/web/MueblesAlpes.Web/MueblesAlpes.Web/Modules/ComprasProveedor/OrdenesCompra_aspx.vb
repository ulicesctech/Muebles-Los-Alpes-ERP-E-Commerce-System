Imports System.Data

Namespace Modules.ComprasProveedor

    Public Class OrdenesCompra
        Inherits System.Web.UI.Page

        Private Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarOrdenes()
                CargarProveedores()
            End If
        End Sub

        ' ================================
        ' 🔹 CARGAS INICIALES
        ' ================================
        Private Sub CargarOrdenes()
            gvOrdenes.DataSource = OrdenCompraService.Listar()
            gvOrdenes.DataBind()
        End Sub

        Private Sub CargarProveedores()
            Dim dt As DataTable = ProveedorService.Listar()

            ddlProveedor.DataSource = dt
            ddlProveedor.DataTextField = "NOMBRE"
            ddlProveedor.DataValueField = "ID_PROVEEDOR"
            ddlProveedor.DataBind()
        End Sub

        ' ================================
        ' 🔹 BOTONES PRINCIPALES
        ' ================================
        Protected Sub btnNuevaOrden_Click(sender As Object, e As EventArgs)
            pnlFormCabecera.Visible = True
            pnlDetalleOrden.Visible = False

            txtIDOrden.Text = ""
            txtCodigo.Text = ""
            ddlProveedor.SelectedIndex = 0

            txtIDOrden.ReadOnly = False
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Dim orcKey As String = txtIDOrden.Text.Trim()
            Dim codigo As String = txtCodigo.Text.Trim()
            Dim provId As Decimal = Convert.ToDecimal(ddlProveedor.SelectedValue)

            OrdenCompraService.Crear(orcKey, codigo, provId, 0)

            txtIDOrden.ReadOnly = True

            CargarOrdenes()

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "scroll", "window.scrollTo(0, document.body.scrollHeight);", True)
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            pnlFormCabecera.Visible = False
            pnlDetalleOrden.Visible = False
        End Sub

        ' ================================
        ' 🔹 GRID PRINCIPAL
        ' ================================
        Protected Sub gvOrdenes_RowEditing(sender As Object, e As GridViewEditEventArgs)
            gvOrdenes.EditIndex = e.NewEditIndex
            CargarOrdenes()

            Dim ddlEdit As DropDownList = CType(gvOrdenes.Rows(e.NewEditIndex).FindControl("ddlEditProv"), DropDownList)
            If ddlEdit IsNot Nothing Then
                CargarProveedoresEnDropDown(ddlEdit)
            End If
        End Sub

        Protected Sub gvOrdenes_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
            gvOrdenes.EditIndex = -1
            CargarOrdenes()
        End Sub

        Protected Sub gvOrdenes_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)

            Dim row As GridViewRow = gvOrdenes.Rows(e.RowIndex)

            Dim orcKey As String = gvOrdenes.DataKeys(e.RowIndex).Value.ToString()
            Dim codigo As String = CType(row.FindControl("txtEditCodigo"), TextBox).Text
            Dim provId As Decimal = Convert.ToDecimal(CType(row.FindControl("ddlEditProv"), DropDownList).SelectedValue)

            OrdenCompraService.Actualizar(orcKey, codigo, provId, 0)

            gvOrdenes.EditIndex = -1
            CargarOrdenes()
        End Sub

        Protected Sub gvOrdenes_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
            Dim orcKey As String = gvOrdenes.DataKeys(e.RowIndex).Value.ToString()

            OrdenCompraService.Eliminar(orcKey)

            CargarOrdenes()
        End Sub

        ' ================================
        '  ABRIR DETALLE
        ' ================================
        Protected Sub gvOrdenes_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "VerDetalle" Then

                Dim index As Integer = Convert.ToInt32(e.CommandArgument)
                Dim orcKey As String = gvOrdenes.DataKeys(index).Value.ToString()

                ViewState("ORC_KEY") = orcKey

                pnlDetalleOrden.Visible = True
                CargarDetalle(orcKey)
            End If
        End Sub

        ' ================================
        ' 🔹 DETALLE
        ' ================================
        Private Sub CargarDetalle(orcKey As String)
            gvItemsOrden.DataSource = OrdenDetallePedidoService.ListarPorOrden(orcKey)
            gvItemsOrden.DataBind()
        End Sub

        Protected Sub btnAddMat_Click(sender As Object, e As EventArgs)
            Dim orcKey As String = ViewState("ORC_KEY").ToString()

            OrdenDetallePedidoService.Insertar(
                orcKey,
                1,
                txtMaterial.Text,
                Convert.ToDecimal(txtPrecio.Text),
                Convert.ToInt32(txtCantidad.Text)
            )

            CargarDetalle(orcKey)

            txtMaterial.Text = ""
            txtPrecio.Text = ""
            txtCantidad.Text = ""
        End Sub

        Protected Sub btnCerrarDetalle_Click(sender As Object, e As EventArgs)
            pnlDetalleOrden.Visible = False
        End Sub

        Protected Sub gvItemsOrden_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
            Dim odpId As Integer = Convert.ToInt32(gvItemsOrden.DataKeys(e.RowIndex).Value)

            OrdenDetallePedidoService.Eliminar(odpId)

            CargarDetalle(ViewState("ORC_KEY").ToString())
        End Sub

        ' ================================
        ' 🔹 HELPERS
        ' ================================
        Private Sub CargarProveedoresEnDropDown(ddl As DropDownList)
            Dim dt As DataTable = ProveedorService.Listar()

            ddl.DataSource = dt
            ddl.DataTextField = "NOMBRE"
            ddl.DataValueField = "ID_PROVEEDOR"
            ddl.DataBind()
        End Sub

    End Class

End Namespace