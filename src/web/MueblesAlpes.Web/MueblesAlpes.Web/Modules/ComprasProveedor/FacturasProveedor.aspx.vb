' ============================================================
' RUTA: Modules/ComprasProveedor/FacturasProveedor.aspx.vb
' ============================================================
Imports System.Data

Namespace Modules.ComprasProveedor

    Partial Public Class FacturasProveedor
        Inherits BasePage

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarOrdenes()
                CargarGrilla()
            End If
        End Sub

        ' =============================================
        ' CARGA DE DATOS
        ' =============================================
        Private Sub CargarOrdenes()
            Try
                Dim dt As DataTable = OrdenCompraService.Listar()
                ddlOrden.DataSource = dt
                ddlOrden.DataTextField = "ORC_KEY"
                ddlOrden.DataValueField = "ORC_KEY"
                ddlOrden.DataBind()
                ddlOrden.Items.Insert(0, New ListItem("-- Seleccione una orden --", ""))
            Catch ex As Exception
                MostrarError("No logramos cargar las ordenes de compra: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarGrilla()
            Try
                gvFacturas.DataSource = FacturaProveedorService.Listar()
                gvFacturas.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar facturas: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' MENSAJES
        ' =============================================
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

        ' =============================================
        ' LIMPIAR FORMULARIO
        ' =============================================
        Private Sub Limpiar()
            hfKey.Value = ""
            hfModo.Value = "nuevo"
            txtCodigoFac.Text = ""
            If ddlOrden.Items.Count > 0 Then ddlOrden.SelectedIndex = 0
            lblTituloForm.Text = "Registrar Factura"
            btnGuardar.Text = "💾 Guardar"
            pnlOrdenNuevo.Visible = True
            pnlOrdenEditar.Visible = False
            lblOrdenEditar.Text = ""
            pnlMsg.Visible = False
        End Sub

        ' =============================================
        ' BUSCAR Y LIMPIAR
        ' =============================================
        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            Try
                Dim texto As String = txtBuscar.Text.Trim()
                Dim fechaDesde As Object = Nothing
                Dim fechaHasta As Object = Nothing

                If Not String.IsNullOrWhiteSpace(txtFechaDesde.Text) Then fechaDesde = Convert.ToDateTime(txtFechaDesde.Text)
                If Not String.IsNullOrWhiteSpace(txtFechaHasta.Text) Then fechaHasta = Convert.ToDateTime(txtFechaHasta.Text)

                If fechaDesde IsNot Nothing AndAlso fechaHasta IsNot Nothing Then
                    If CDate(fechaDesde) > CDate(fechaHasta) Then
                        MostrarError("La fecha desde no puede ser mayor que la fecha hasta.")
                        Exit Sub
                    End If
                End If

                ' Llama BuscarFiltro pasando Nothing en orcKey para ignorar ese filtro
                gvFacturas.DataSource = FacturaProveedorService.BuscarFiltro(texto, Nothing, fechaDesde, fechaHasta)
                gvFacturas.DataBind()
            Catch ex As Exception
                MostrarError("Error al buscar: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            txtFechaDesde.Text = ""
            txtFechaHasta.Text = ""
            Limpiar()
            CargarGrilla()
        End Sub

        ' =============================================
        ' GUARDAR (registrar o actualizar)
        ' =============================================
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If hfModo.Value = "nuevo" AndAlso String.IsNullOrWhiteSpace(ddlOrden.SelectedValue) Then
                MostrarError("Selecciona la orden de compra que deseas facturar.") : Return
            End If
            If String.IsNullOrWhiteSpace(txtCodigoFac.Text) Then
                MostrarError("Ingresa el numero o codigo de la factura.") : Return
            End If

            Try
                Dim codigo As String = txtCodigoFac.Text.Trim()

                If hfModo.Value = "nuevo" Then
                    FacturaProveedorService.Registrar(ddlOrden.SelectedValue, codigo)
                    Limpiar()
                    CargarGrilla()
                    MostrarExito("Factura registrada correctamente.")
                Else
                    ' En edicion la orden no cambia: old = new = hfKey
                    FacturaProveedorService.Actualizar(hfKey.Value, hfKey.Value, codigo)
                    Limpiar()
                    CargarGrilla()
                    MostrarExito("Factura actualizada correctamente.")
                End If
            Catch ex As Exception
                MostrarError("Error al guardar: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            Limpiar()
        End Sub

        ' =============================================
        ' COMANDOS DE GRILLA
        ' =============================================
        Protected Sub gvFacturas_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandArgument Is Nothing OrElse
               String.IsNullOrEmpty(e.CommandArgument.ToString()) Then Return

            Dim idOriginal As String = e.CommandArgument.ToString()

            If e.CommandName = "Editar" Then
                Try
                    Dim dt As DataTable = FacturaProveedorService.Listar()
                    Dim filas As DataRow() = dt.Select("ORC_ORDEN_COMPRA = '" & idOriginal.Replace("'", "''") & "'")

                    If filas.Length > 0 Then
                        Dim fila As DataRow = filas(0)
                        hfKey.Value = idOriginal
                        hfModo.Value = "editar"
                        txtCodigoFac.Text = fila("FACPRO_CODIGO_FACTURA").ToString()

                        pnlOrdenNuevo.Visible = False
                        pnlOrdenEditar.Visible = True
                        lblOrdenEditar.Text = idOriginal

                        lblTituloForm.Text = "Editar Factura — Orden: " & idOriginal
                        btnGuardar.Text = "💾 Actualizar"
                        pnlMsg.Visible = False
                    End If
                Catch ex As Exception
                    MostrarError("No se pudo cargar la factura para editar: " & ex.Message)
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    FacturaProveedorService.Eliminar(idOriginal)
                    Limpiar()
                    CargarGrilla()
                    MostrarExito("Factura eliminada correctamente.")
                Catch ex As Exception
                    MostrarError("Error al eliminar: " & ex.Message)
                End Try
            End If
        End Sub

    End Class
End Namespace