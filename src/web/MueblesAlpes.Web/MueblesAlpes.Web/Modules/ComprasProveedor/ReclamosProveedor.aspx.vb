' ============================================================
' RUTA: Modules/ComprasProveedor/ReclamosProveedor.aspx.vb
' ============================================================
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.ComprasProveedor

    Partial Public Class ReclamosProveedor
        Inherits BasePage

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarOrdenes()
                CargarEstadosFiltro()
                CargarEstadosFormulario()
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
                MostrarError("Error al cargar ordenes: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarEstadosFiltro()
            Try
                Dim dt As DataTable = ReclamoProveedorService.ListarEstados()
                ddlFiltroEstado.DataSource = dt
                ddlFiltroEstado.DataTextField = "DESCRIPCION"
                ddlFiltroEstado.DataValueField = "ESTADO"
                ddlFiltroEstado.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar estados: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarEstadosFormulario()
            Try
                Dim dt As DataTable = ReclamoProveedorService.ListarEstados()
                Dim dtSinTodos As DataTable = dt.Clone()
                For Each row As DataRow In dt.Rows
                    If row("ESTADO").ToString() <> "TODOS" Then dtSinTodos.ImportRow(row)
                Next
                ddlEstado.DataSource = dtSinTodos
                ddlEstado.DataTextField = "DESCRIPCION"
                ddlEstado.DataValueField = "ESTADO"
                ddlEstado.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar estados del formulario: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarGrilla()
            Try
                gvReclamos.DataSource = ReclamoProveedorService.Listar()
                gvReclamos.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar reclamos: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' CONTROL DE PANELES
        ' =============================================
        Private Sub MostrarPanelPrincipal()
            pnlFormPrincipal.Visible = True
            pnlCambioEstado.Visible = False
            pnlEditarComentarios.Visible = False
        End Sub

        Private Sub MostrarPanelEstado()
            pnlFormPrincipal.Visible = False
            pnlCambioEstado.Visible = True
            pnlEditarComentarios.Visible = False
        End Sub

        Private Sub MostrarPanelComentarios()
            pnlFormPrincipal.Visible = False
            pnlCambioEstado.Visible = False
            pnlEditarComentarios.Visible = True
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = "0"
            hfModo.Value = "nuevo"

            txtDescripcion.Text = ""
            txtDescripcion.Enabled = True
            ddlOrden.Enabled = True
            If ddlOrden.Items.Count > 0 Then ddlOrden.SelectedIndex = 0
            lblTituloForm.Text = "Nuevo Reclamo"
            btnGuardar.Text = "💾 Guardar"

            If ddlEstado.Items.Count > 0 Then ddlEstado.SelectedIndex = 0
            pnlComentariosCierre.Visible = False
            txtComentariosCierre.Text = ""

            txtComentariosEditar.Text = ""
            lblIdComentarios.Text = ""
            lblComentOrden.Text = ""
            lblComentEstado.Text = ""
            lblComentDescripcion.Text = ""

            pnlMsg.Visible = False
            MostrarPanelPrincipal()
        End Sub

        ' =============================================
        ' MENSAJES
        ' =============================================
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

        ' =============================================
        ' DROPDOWN ESTADO
        ' =============================================
        Protected Sub ddlEstado_SelectedIndexChanged(sender As Object, e As EventArgs)
            Dim esCierre As Boolean = ReclamoProveedorService.EsEstadoDeCierre(ddlEstado.SelectedValue)
            pnlComentariosCierre.Visible = esCierre
            If esCierre Then txtComentariosCierre.Text = ""
        End Sub

        ' =============================================
        ' BUSCAR Y LIMPIAR
        ' =============================================
        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            Try
                Dim texto As String = txtBuscar.Text.Trim()
                Dim estado As String = ddlFiltroEstado.SelectedValue
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

                gvReclamos.DataSource = ReclamoProveedorService.Buscar(texto, estado, fechaDesde, fechaHasta)
                gvReclamos.DataBind()
            Catch ex As Exception
                MostrarError("Error al buscar: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            txtFechaDesde.Text = ""
            txtFechaHasta.Text = ""
            If ddlFiltroEstado.Items.Count > 0 Then ddlFiltroEstado.SelectedIndex = 0
            LimpiarFormulario()
            CargarGrilla()
        End Sub

        ' =============================================
        ' PANEL 1 — CREAR / EDITAR DESCRIPCION
        ' =============================================
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If Not ValidarFormulario() Then Return
            Try
                Dim id As Decimal = Convert.ToDecimal(If(String.IsNullOrEmpty(hfId.Value), "0", hfId.Value))

                Select Case hfModo.Value
                    Case "nuevo"
                        ReclamoProveedorService.Crear(ddlOrden.SelectedValue, txtDescripcion.Text.Trim())
                        LimpiarFormulario()
                        CargarGrilla()
                        MostrarExito("Reclamo creado correctamente.")   ' ← MENSAJE GUARDAR
                    Case "editar"
                        ReclamoProveedorService.Actualizar(id, txtDescripcion.Text.Trim())
                        LimpiarFormulario()
                        CargarGrilla()
                        MostrarExito("Descripcion actualizada correctamente.")   ' ← MENSAJE ACTUALIZAR
                End Select
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

        ' =============================================
        ' PANEL 2 — CAMBIAR ESTADO
        ' =============================================
        Protected Sub btnCambiarEstado_Click(sender As Object, e As EventArgs)
            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                Dim estado As String = ddlEstado.SelectedValue
                Dim esCierre As Boolean = ReclamoProveedorService.EsEstadoDeCierre(estado)

                If esCierre AndAlso String.IsNullOrWhiteSpace(txtComentariosCierre.Text) Then
                    MostrarError("Debe ingresar los comentarios de resolucion para el estado " & estado & ".")
                    Exit Sub
                End If

                Dim comentarios As String = If(esCierre, txtComentariosCierre.Text.Trim(), "")
                ReclamoProveedorService.CambiarEstado(id, estado, comentarios)
                LimpiarFormulario()
                CargarGrilla()
                MostrarExito("Estado actualizado a <strong>" & estado & "</strong>.")   ' ← MENSAJE ACTUALIZAR
            Catch ex As OracleException
                If ex.Message.Contains("20070") Then
                    Dim inicio As Integer = ex.Message.IndexOf("20070") + 6
                    MostrarError(ex.Message.Substring(inicio).Trim().TrimStart(":"c).Trim())
                Else
                    MostrarError("Error Oracle: " & ex.Message)
                End If
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelarEstado_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
        End Sub

        ' =============================================
        ' PANEL 3 — EDITAR COMENTARIOS
        ' =============================================
        Protected Sub btnGuardarComentarios_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtComentariosEditar.Text) Then
                MostrarError("Los comentarios son obligatorios.") : Return
            End If
            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                ReclamoProveedorService.ActualizarComentarios(id, txtComentariosEditar.Text.Trim())
                LimpiarFormulario()
                CargarGrilla()
                MostrarExito("Comentarios actualizados correctamente.")   ' ← MENSAJE ACTUALIZAR
            Catch ex As Exception
                MostrarError("Error al guardar comentarios: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelarComentarios_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
        End Sub

        ' =============================================
        ' COMANDOS DE GRILLA
        ' =============================================
        Protected Sub gvReclamos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandArgument Is Nothing OrElse
               String.IsNullOrEmpty(e.CommandArgument.ToString()) Then Return

            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)

            Select Case e.CommandName

                Case "Editar"
                    Try
                        Dim dt As DataTable = ReclamoProveedorService.ListarPorId(id)
                        If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                            Dim fila As DataRow = dt.Rows(0)
                            hfId.Value = id.ToString()
                            hfModo.Value = "editar"

                            txtDescripcion.Text = If(IsDBNull(fila("REP_DESCRIPCION")), "", fila("REP_DESCRIPCION").ToString())
                            txtDescripcion.Enabled = True
                            ddlOrden.Enabled = False

                            Dim orcKey As String = fila("ORC_ORDEN_COMPRA").ToString()
                            Dim item As ListItem = ddlOrden.Items.FindByValue(orcKey)
                            If item IsNot Nothing Then ddlOrden.SelectedValue = orcKey

                            lblTituloForm.Text = "Editar Descripcion — Reclamo #" & id.ToString()
                            btnGuardar.Text = "💾 Actualizar Descripcion"
                            pnlMsg.Visible = False
                            MostrarPanelPrincipal()
                        End If
                    Catch ex As Exception
                        MostrarError("Error al cargar reclamo: " & ex.Message)
                    End Try

                Case "EditarComentarios"
                    Try
                        Dim dt As DataTable = ReclamoProveedorService.ListarPorId(id)
                        If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                            Dim fila As DataRow = dt.Rows(0)
                            hfId.Value = id.ToString()
                            hfModo.Value = "editar_comentarios"

                            lblIdComentarios.Text = id.ToString()
                            lblComentOrden.Text = fila("ORC_ORDEN_COMPRA").ToString()
                            lblComentEstado.Text = fila("REP_ESTADO").ToString()
                            lblComentDescripcion.Text = If(IsDBNull(fila("REP_DESCRIPCION")), "", fila("REP_DESCRIPCION").ToString())
                            txtComentariosEditar.Text = If(IsDBNull(fila("REP_COMENTARIOS")), "", fila("REP_COMENTARIOS").ToString())

                            pnlMsg.Visible = False
                            MostrarPanelComentarios()
                        End If
                    Catch ex As Exception
                        MostrarError("Error al cargar comentarios: " & ex.Message)
                    End Try

                Case "CambiarEstado"
                    Try
                        Dim dt As DataTable = ReclamoProveedorService.ListarPorId(id)
                        If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                            LimpiarFormulario()
                            hfId.Value = id.ToString()

                            Dim estadoActual As String = dt.Rows(0)("REP_ESTADO").ToString()
                            Dim itemEstado As ListItem = ddlEstado.Items.FindByValue(estadoActual)
                            If itemEstado IsNot Nothing Then ddlEstado.SelectedValue = estadoActual
                            pnlComentariosCierre.Visible = ReclamoProveedorService.EsEstadoDeCierre(ddlEstado.SelectedValue)

                            lblIdEstado.Text = id.ToString()
                            pnlMsg.Visible = False
                            MostrarPanelEstado()
                        End If
                    Catch ex As Exception
                        MostrarError("Error al cargar panel de estado: " & ex.Message)
                    End Try

                Case "Eliminar"
                    Try
                        ReclamoProveedorService.Eliminar(id)
                        LimpiarFormulario()
                        CargarGrilla()
                        MostrarExito("Reclamo eliminado correctamente.")   ' ← MENSAJE ELIMINAR
                    Catch ex As Exception
                        MostrarError("Error al eliminar: " & ex.Message)
                    End Try

            End Select
        End Sub

        ' =============================================
        ' VALIDACION
        ' =============================================
        Private Function ValidarFormulario() As Boolean
            If hfModo.Value = "nuevo" Then
                If String.IsNullOrWhiteSpace(ddlOrden.SelectedValue) Then
                    MostrarError("Debe seleccionar una orden de compra.") : Return False
                End If
            End If
            If String.IsNullOrWhiteSpace(txtDescripcion.Text) Then
                MostrarError("La descripcion del problema es obligatoria.") : Return False
            End If
            Return True
        End Function

    End Class
End Namespace