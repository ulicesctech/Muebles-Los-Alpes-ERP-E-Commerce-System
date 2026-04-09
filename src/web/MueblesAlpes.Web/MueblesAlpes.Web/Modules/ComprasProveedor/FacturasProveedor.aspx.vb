' ============================================================
' RUTA: Modules/ComprasProveedor/FacturasProveedor.aspx.vb
' ============================================================
Imports System.Data

Namespace Modules.ComprasProveedor
    Partial Public Class FacturasProveedor
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarOrdenes()
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarOrdenes()
            Try
                ddlOrden.DataSource = OrdenCompraService.Listar()
                ddlOrden.DataTextField = "ORC_CODIGO"
                ddlOrden.DataValueField = "ORC_ORDEN_COMPRA"
                ddlOrden.DataBind()
                ddlOrden.Items.Insert(0, New ListItem("-- Seleccione una orden --", ""))
            Catch ex As Exception
                MostrarError("No logramos cargar las órdenes de compra. Intenta recargar la página.")
            End Try
        End Sub

        Private Sub CargarGrilla(Optional texto As String = "")
            gvFacturas.DataSource = If(String.IsNullOrWhiteSpace(texto), FacturaProveedorService.Listar(), FacturaProveedorService.Buscar(texto))
            gvFacturas.DataBind()
            Catch ex As Exception
            MostrarError("Tuvimos un problema al mostrar la lista de facturas.")
            End Try
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            ' Validación amigable
            If ddlOrden.SelectedIndex = 0 Then
                MostrarError("Por favor, selecciona la orden de compra que deseas facturar.")
                Return
            End If

            If String.IsNullOrWhiteSpace(txtCodigoFac.Text) Then
                MostrarError("Necesitamos que ingreses el número de la factura para continuar.")
                Return
            End If

            Try
                Dim modo As String = hfModo.Value
                Dim orcNueva As String = ddlOrden.SelectedValue
                Dim codigo As String = txtCodigoFac.Text.Trim()

                If modo = "nuevo" Then
                    FacturaProveedorService.Registrar(orcNueva, codigo)
                    MostrarExito("Factura registrada correctamente.")
                Else
                    ' SOLUCIÓN AL ERROR BC30057:
                    ' hfKey.Value contiene la OC original antes del cambio
                    FacturaProveedorService.Actualizar(hfKey.Value, orcNueva, codigo)
                    MostrarExito("Factura actualizada correctamente.")
                End If

                Limpiar()
                CargarGrilla()
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub gvFacturas_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandArgument Is Nothing OrElse String.IsNullOrEmpty(e.CommandArgument.ToString()) Then Return

            Dim idOriginal As String = e.CommandArgument.ToString()

            If e.CommandName = "Editar" Then
                Try
                    Dim dt As DataTable = FacturaProveedorService.Listar()
                    Dim filas As DataRow() = dt.Select("ORC_ORDEN_COMPRA = '" & idOriginal & "'")

                    If filas.Length > 0 Then
                        Dim fila As DataRow = filas(0)
                        hfKey.Value = idOriginal ' Llave primaria original
                        hfModo.Value = "editar"
                        txtCodigoFac.Text = fila("FACPRO_CODIGO_FACTURA").ToString()
                        ddlOrden.SelectedValue = idOriginal
                        ddlOrden.Enabled = True ' Se permite cambiar la orden
                        lblTituloForm.Text = "Editar Factura"
                        btnGuardar.Text = "💾 Actualizar"
                        pnlMsg.Visible = False
                    End If
                Catch
                    MostrarError("No pudimos recuperar la información para editar esta factura.")
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    FacturaProveedorService.Eliminar(idOriginal)
                    Limpiar()
                    CargarGrilla()
                    MostrarExito("Factura eliminada.")
            End If
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            CargarGrilla(txtBuscar.Text.Trim())
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            Limpiar()
            CargarGrilla()
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            Limpiar()
            pnlMsg.Visible = False
        End Sub

        Private Sub Limpiar()
            hfKey.Value = ""
            hfModo.Value = "nuevo"
            txtCodigoFac.Text = ""
            ddlOrden.Enabled = True
            ddlOrden.SelectedIndex = 0
            lblTituloForm.Text = "Registrar Factura"
            btnGuardar.Text = "💾 Guardar"
            pnlMsg.Visible = False
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            Limpiar()
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = "⚠️ " & msg
            pnlMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = "✅ " & msg
            pnlMsg.CssClass = "alert-ok"
            pnlMsg.Visible = True
        End Sub
    End Class
End Namespace