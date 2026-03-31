Imports System
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: Modules/ComprasProveedor/ReclamosProveedor.aspx.vb
' ============================================================
Namespace Modules.ComprasProveedor

    Partial Public Class ReclamosProveedor
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarOrdenes()
                CargarGrilla()
            End If
        End Sub

        ' ── Carga órdenes en el dropdown (para asociar reclamo) ──────────────
        Private Sub CargarOrdenes()
            Try
                Dim dt As DataTable = OrdenCompraService.Listar()
                ddlOrden.DataSource     = dt
                ddlOrden.DataTextField  = "ORC_CODIGO"
                ddlOrden.DataValueField = "ORC_ORDEN_COMPRA"
                ddlOrden.DataBind()
                ddlOrden.Items.Insert(0, New ListItem("-- Seleccione una orden --", ""))
            Catch ex As Exception
                MostrarError("Error al cargar órdenes: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarGrilla()
            Try
                gvReclamos.DataSource = ReclamoProveedorService.Listar()
                gvReclamos.DataBind()
            Catch ex As OracleException
                MostrarError("Error Oracle: " & ex.Message)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            ' El paquete de reclamos no expone BUSCAR; se filtra en memoria
            Try
                Dim texto As String = txtBuscar.Text.Trim().ToLower()
                Dim dt As DataTable = ReclamoProveedorService.Listar()
                If Not String.IsNullOrWhiteSpace(texto) Then
                    Dim filas As DataRow() = dt.Select(
                        "LOWER(ORC_ORDEN_COMPRA) LIKE '%" & texto.Replace("'", "''") & "%' OR " &
                        "LOWER(REP_COMENTARIOS)  LIKE '%" & texto.Replace("'", "''") & "%' OR " &
                        "LOWER(REP_ESTADO)        LIKE '%" & texto.Replace("'", "''") & "%'")
                    Dim dtFiltrado As DataTable = dt.Clone()
                    For Each f As DataRow In filas
                        dtFiltrado.ImportRow(f)
                    Next
                    gvReclamos.DataSource = dtFiltrado
                Else
                    gvReclamos.DataSource = dt
                End If
                gvReclamos.DataBind()
            Catch ex As Exception
                MostrarError("Error al buscar: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            LimpiarFormulario()
            CargarGrilla()
        End Sub

        ' ── GUARDAR: Crear o actualizar comentarios ───────────────────────────
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If Not ValidarFormulario() Then Return
            Try
                Dim modo       As String  = hfModo.Value
                Dim id         As Decimal = Convert.ToDecimal(hfId.Value)
                Dim comentarios As String = txtComentarios.Text.Trim()

                If modo = "nuevo" Then
                    ' El paquete asigna: estado = INICIADO, fecha_inicio = SYSDATE, fecha_final = NULL
                    Dim orcKey As String = ddlOrden.SelectedValue
                    ReclamoProveedorService.Crear(orcKey, comentarios)
                    MostrarExito("Reclamo creado correctamente. Estado inicial: INICIADO.")
                Else
                    ' Solo actualiza comentarios; estado y fechas NO se tocan aquí
                    ReclamoProveedorService.Actualizar(id, comentarios)
                    MostrarExito("Comentarios actualizados correctamente.")
                End If
                LimpiarFormulario()
                CargarGrilla()
            Catch ex As OracleException
                MostrarError("Error Oracle: " & ex.Message)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            CargarGrilla()
        End Sub

        ' ── CAMBIAR ESTADO: Llama a REC_PROV_CAMBIAR_ESTADO ──────────────────
        ' Lógica:
        '   - FINALIZADO / RESUELTO / RECHAZADO → el paquete asigna fecha_final = SYSDATE
        '   - INICIADO / PENDIENTE              → el paquete deja fecha_final = NULL
        Protected Sub btnCambiarEstado_Click(sender As Object, e As EventArgs)
            Dim id     As Decimal = Convert.ToDecimal(hfId.Value)
            Dim estado As String  = ddlEstado.SelectedValue
            Try
                ReclamoProveedorService.CambiarEstado(id, estado)
                Dim esCierre As Boolean = ReclamoProveedorService.EsEstadoDeCierre(estado)
                Dim msgExtra As String = If(esCierre,
                    " La fecha de finalización fue registrada automáticamente.",
                    " La fecha de finalización fue eliminada (reclamo reabierto).")
                MostrarExito("Estado actualizado a <strong>" & estado & "</strong>." & msgExtra)
                LimpiarFormulario()
                CargarGrilla()
            Catch ex As OracleException
                MostrarError("Error Oracle: " & ex.Message)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        ' ── COMANDOS DE GRILLA ────────────────────────────────────────────────
        Protected Sub gvReclamos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)
            Select Case e.CommandName

                Case "Editar"
                    ' Carga datos para editar solo comentarios
                    Dim dt As DataTable = ReclamoProveedorService.ListarPorId(id)
                    If dt.Rows.Count > 0 Then
                        Dim fila As DataRow = dt.Rows(0)
                        hfId.Value          = id.ToString()
                        hfModo.Value        = "editar"
                        txtComentarios.Text = fila("REP_COMENTARIOS").ToString()

                        ' La orden no cambia en edición
                        ddlOrden.Enabled = False
                        Dim orcKey As String = fila("ORC_ORDEN_COMPRA").ToString()
                        Dim item As ListItem = ddlOrden.Items.FindByValue(orcKey)
                        If item IsNot Nothing Then ddlOrden.SelectedValue = orcKey

                        lblTituloForm.Text = "Editar Comentarios — Reclamo #" & id.ToString()
                        btnGuardar.Text    = "💾 Actualizar Comentarios"

                        ' Muestra el panel de cambio de estado con el estado actual seleccionado
                        lblIdEstado.Text = id.ToString()
                        Dim estadoActual As String = fila("REP_ESTADO").ToString()
                        Dim itemEstado As ListItem = ddlEstado.Items.FindByValue(estadoActual)
                        If itemEstado IsNot Nothing Then ddlEstado.SelectedValue = estadoActual
                        pnlCambioEstado.Visible = True
                    End If

                Case "CambiarEstado"
                    ' Solo muestra el panel de estado sin entrar en modo edición de comentarios
                    Dim dt2 As DataTable = ReclamoProveedorService.ListarPorId(id)
                    If dt2.Rows.Count > 0 Then
                        hfId.Value = id.ToString()
                        Dim estadoActual As String = dt2.Rows(0)("REP_ESTADO").ToString()
                        Dim itemEstado As ListItem = ddlEstado.Items.FindByValue(estadoActual)
                        If itemEstado IsNot Nothing Then ddlEstado.SelectedValue = estadoActual
                        lblIdEstado.Text        = id.ToString()
                        pnlCambioEstado.Visible = True
                        MostrarExito("Seleccione el nuevo estado y pulse 🔄 Aplicar Estado.")
                    End If

                Case "Eliminar"
                    Try
                        ReclamoProveedorService.Eliminar(id)
                        MostrarExito("Reclamo eliminado correctamente.")
                        LimpiarFormulario()
                        CargarGrilla()
                    Catch ex As OracleException
                        MostrarError("Error Oracle: " & ex.Message)
                    Catch ex As Exception
                        MostrarError("Error: " & ex.Message)
                    End Try

            End Select
        End Sub

        Private Function ValidarFormulario() As Boolean
            If hfModo.Value = "nuevo" AndAlso String.IsNullOrWhiteSpace(ddlOrden.SelectedValue) Then
                MostrarError("Debe seleccionar una orden de compra.") : Return False
            End If
            If String.IsNullOrWhiteSpace(txtComentarios.Text) Then
                MostrarError("Los comentarios son obligatorios.") : Return False
            End If
            Return True
        End Function

        Private Sub LimpiarFormulario()
            hfId.Value          = "0"
            hfModo.Value        = "nuevo"
            txtComentarios.Text = ""
            ddlOrden.Enabled    = True
            ddlOrden.SelectedIndex = 0
            ddlEstado.SelectedIndex = 0
            pnlCambioEstado.Visible = False
            lblTituloForm.Text  = "Nuevo Reclamo"
            btnGuardar.Text     = "💾 Guardar"
            pnlMsg.Visible      = False
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text     = "<span>⚠️ " & msg & "</span>"
            pnlMsg.CssClass = "alert-err"
            pnlMsg.Visible  = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text     = "<span>✅ " & msg & "</span>"
            pnlMsg.CssClass = "alert-ok"
            pnlMsg.Visible  = True
        End Sub

    End Class

End Namespace
