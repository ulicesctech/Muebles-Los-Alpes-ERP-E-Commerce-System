Imports System
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: Modules/ComprasProveedor/OrdenesCompra.aspx.vb
' ============================================================
Namespace Modules.ComprasProveedor

    Partial Public Class OrdenesCompra
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarProveedores()
                LimpiarFormulario()
                CargarGrilla()
            End If
        End Sub

        ' ── Carga de datos ──────────────────────────────────
        Private Sub CargarProveedores()
            Try
                Dim dt As DataTable = ProveedorService.Listar()
                ddlProveedor.DataSource = dt
                ddlProveedor.DataTextField = "PROV_NOMBRE"
                ddlProveedor.DataValueField = "PROV_PROVEEDOR"
                ddlProveedor.DataBind()
                ddlProveedor.Items.Insert(0, New ListItem("-- Seleccione un proveedor --", "0"))
            Catch ex As Exception
                MostrarError("Error al cargar proveedores: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarGrilla(Optional texto As String = "")
            Try
                gvOrdenes.DataSource = If(String.IsNullOrWhiteSpace(texto),
                                          OrdenCompraService.Listar(),
                                          OrdenCompraService.Buscar(texto))
                gvOrdenes.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar la lista: " & ex.Message)
            End Try
        End Sub

        ' ── Acciones de búsqueda ────────────────────────────
        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            CargarGrilla(txtBuscar.Text.Trim())
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            LimpiarFormulario()
            CargarGrilla()
        End Sub

        ' ── Guardar / Actualizar ───────────────────────────
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If Not ValidarFormulario() Then Return
            Try
                Dim modo As String = hfModo.Value
                Dim codigo As String = txtCodigo.Text.Trim()
                Dim provId As Decimal = Convert.ToDecimal(ddlProveedor.SelectedValue)
                Dim total As Decimal = Convert.ToDecimal(txtTotal.Text.Trim())

                If modo = "nuevo" Then
                    ' El paquete de Oracle generará la PK internamente
                    OrdenCompraService.Crear(codigo, provId, total)
                    MostrarExito("Orden registrada correctamente.")
                Else
                    ' En edición usamos la llave original guardada
                    Dim orcKey As String = hfKey.Value
                    OrdenCompraService.Actualizar(orcKey, codigo, provId, total)
                    MostrarExito("Orden actualizada correctamente.")
                End If

                LimpiarFormulario()
                CargarGrilla()
            Catch ex As Exception
                MostrarError("Error al guardar: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            CargarGrilla()
        End Sub

        ' ── Eventos de la Grilla ────────────────────────────
        Protected Sub gvOrdenes_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim orcKey As String = e.CommandArgument.ToString()

            Select Case e.CommandName
                Case "Editar"
                    Dim dt As DataTable = OrdenCompraService.Listar()
                    Dim filas As DataRow() = dt.Select("ORC_ORDEN_COMPRA = '" & orcKey.Replace("'", "''") & "'")

                    If filas.Length > 0 Then
                        Dim fila As DataRow = filas(0)
                        hfKey.Value = orcKey
                        hfModo.Value = "editar"
                        txtCodigo.Text = fila("ORC_CODIGO").ToString()
                        txtTotal.Text = fila("ORC_TOTAL_PRECIO").ToString()

                        Dim provId As String = fila("PROV_PROVEEDOR").ToString()
                        Dim item As ListItem = ddlProveedor.Items.FindByValue(provId)
                        If item IsNot Nothing Then ddlProveedor.SelectedValue = provId


                        lblTituloForm.Text = "Editar Orden de Compra"
                        btnGuardar.Text = "💾 Actualizar"
                        pnlMsg.Visible = False
                    End If

                Case "Eliminar"
                    Try
                        OrdenCompraService.Eliminar(orcKey)
                        MostrarExito("Orden eliminada correctamente.")
                        LimpiarFormulario()
                        CargarGrilla()
                    Catch ex As Exception
                        MostrarError("Error al eliminar: " & ex.Message)
                    End Try
            End Select
        End Sub

        ' ── Métodos Auxiliares ──────────────────────────────
        Private Function ValidarFormulario() As Boolean
            If String.IsNullOrWhiteSpace(txtCodigo.Text) Then
                MostrarError("El código es obligatorio.") : Return False
            End If

            ' QUITA EL "AndAlso hfModo.Value = 'nuevo'"
            If ddlProveedor.SelectedValue = "0" Then
                MostrarError("Debe seleccionar un proveedor.") : Return False
            End If
            Dim total As Decimal
            If Not Decimal.TryParse(txtTotal.Text.Trim(), total) OrElse total < 0 Then
                MostrarError("Ingrese un total válido mayor o igual a 0.") : Return False
            End If
            Return True
        End Function

        Private Sub LimpiarFormulario()
            hfKey.Value = ""
            hfModo.Value = "nuevo"

            ' El usuario ingresa el código manualmente
            txtCodigo.Text = ""
            txtCodigo.ReadOnly = False

            txtTotal.Text = ""
            ddlProveedor.SelectedIndex = 0
            lblTituloForm.Text = "Nueva Orden de Compra"
            btnGuardar.Text = "💾 Guardar"
            pnlMsg.Visible = False
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = "<span>⚠️ " & msg & "</span>"
            pnlMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = "<span>✅ " & msg & "</span>"
            pnlMsg.CssClass = "alert-ok"
            pnlMsg.Visible = True
        End Sub

    End Class

End Namespace