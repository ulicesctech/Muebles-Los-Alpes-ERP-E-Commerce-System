' ============================================================
' RUTA: Modules/ComprasProveedor/ReclamosProveedor.aspx.vb
' ============================================================
Imports System
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.ComprasProveedor

    Partial Public Class ReclamosProveedor
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarOrdenes()
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarOrdenes()
            Try
                Dim dt As DataTable = OrdenCompraService.Listar()
                ddlOrden.DataSource = dt
                ddlOrden.DataTextField = "ORC_CODIGO"
                ddlOrden.DataValueField = "ORC_ORDEN_COMPRA"
                ddlOrden.DataBind()
                ddlOrden.Items.Insert(0, New ListItem("-- Seleccione una orden --", ""))
            Catch ex As Exception
                MostrarError("No pudimos cargar la lista de órdenes de compra. Por favor, intenta de nuevo.")
            End Try
        End Sub

        Private Sub CargarGrilla()
            Try
                gvReclamos.DataSource = ReclamoProveedorService.Listar()
                gvReclamos.DataBind()
            Catch ex As Exception
                MostrarError("Tuvimos un problema al obtener la lista de reclamos. Intenta refrescar la página.")
            End Try
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
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
                MostrarError("No logramos realizar la búsqueda. Por favor, intenta con términos más sencillos.")
            End Try
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            pnlMsg.Visible = False
            LimpiarFormulario()
            CargarGrilla()
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If Not ValidarFormulario() Then Return

            Try
                Dim modo As String = hfModo.Value
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                Dim comentarios As String = txtComentarios.Text.Trim()

                If modo = "nuevo" Then
                    Dim orcKey As String = ddlOrden.SelectedValue
                    ReclamoProveedorService.Crear(orcKey, comentarios)
                    MostrarExito("¡Hecho! El reclamo ha sido creado con éxito en estado 'INICIADO'.")
                Else
                    ReclamoProveedorService.Actualizar(id, comentarios)
                    MostrarExito("Los comentarios del reclamo han sido actualizados correctamente.")
                End If

                LimpiarFormulario()
                CargarGrilla()
            Catch ex As OracleException
                If ex.Message.Contains("ORA-00001") Then
                    MostrarError("Parece que ya existe un reclamo similar registrado. Por favor, verifica la información.")
                Else
                    MostrarError("Hubo un inconveniente con la base de datos al guardar: " & ex.Message)
                End If
            Catch ex As Exception
                MostrarError("Tuvimos un problema técnico al intentar guardar. ¿Podrías intentar nuevamente?")
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            pnlMsg.Visible = False
        End Sub

        Protected Sub btnCambiarEstado_Click(sender As Object, e As EventArgs)
            Dim id As Decimal = Convert.ToDecimal(hfId.Value)
            Dim estado As String = ddlEstado.SelectedValue
            Try
                ReclamoProveedorService.CambiarEstado(id, estado)
                Dim esCierre As Boolean = ReclamoProveedorService.EsEstadoDeCierre(estado)

                Dim msgExtra As String = If(esCierre,
                    " El reclamo ha sido cerrado y se registró la fecha de finalización.",
                    " El estado ha sido actualizado. El reclamo sigue abierto para seguimiento.")

                MostrarExito("¡Estado actualizado! Ahora el reclamo #" & id & " está en: <strong>" & estado & "</strong>." & msgExtra)

                LimpiarFormulario()
                CargarGrilla()
            Catch ex As Exception
                MostrarError("No pudimos cambiar el estado del reclamo. Por favor, verifica la conexión.")
            End Try
        End Sub

        Protected Sub gvReclamos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandArgument Is Nothing OrElse String.IsNullOrEmpty(e.CommandArgument.ToString()) Then Return

            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)

            Select Case e.CommandName
                Case "Editar"
                    Try
                        Dim dt As DataTable = ReclamoProveedorService.ListarPorId(id)
                        If dt.Rows.Count > 0 Then
                            Dim fila As DataRow = dt.Rows(0)
                            hfId.Value = id.ToString()
                            hfModo.Value = "editar"
                            txtComentarios.Text = fila("REP_COMENTARIOS").ToString()

                            ddlOrden.Enabled = False
                            Dim orcKey As String = fila("ORC_ORDEN_COMPRA").ToString()
                            Dim item As ListItem = ddlOrden.Items.FindByValue(orcKey)
                            If item IsNot Nothing Then ddlOrden.SelectedValue = orcKey

                            lblTituloForm.Text = "📝 Editando Reclamo #" & id.ToString()
                            btnGuardar.Text = "💾 Actualizar Comentarios"

                            lblIdEstado.Text = id.ToString()
                            Dim estadoActual As String = fila("REP_ESTADO").ToString()
                            Dim itemEstado As ListItem = ddlEstado.Items.FindByValue(estadoActual)
                            If itemEstado IsNot Nothing Then ddlEstado.SelectedValue = estadoActual
                            pnlCambioEstado.Visible = True
                            pnlMsg.Visible = False
                        End If
                    Catch
                        MostrarError("No logramos recuperar los datos del reclamo para su edición.")
                    End Try

                Case "CambiarEstado"
                    Try
                        Dim dt2 As DataTable = ReclamoProveedorService.ListarPorId(id)
                        If dt2.Rows.Count > 0 Then
                            hfId.Value = id.ToString()
                            Dim estadoActual As String = dt2.Rows(0)("REP_ESTADO").ToString()
                            Dim itemEstado As ListItem = ddlEstado.Items.FindByValue(estadoActual)
                            If itemEstado IsNot Nothing Then ddlEstado.SelectedValue = estadoActual
                            lblIdEstado.Text = id.ToString()
                            pnlCambioEstado.Visible = True
                            MostrarExito("Selecciona el nuevo estado y presiona 'Aplicar Estado' para confirmar.")
                        End If
                    Catch
                        MostrarError("No se pudo cargar el panel de cambio de estado.")
                    End Try

                Case "Eliminar"
                    Try
                        ReclamoProveedorService.Eliminar(id)
                        LimpiarFormulario()
                        CargarGrilla()
                        MostrarExito("El reclamo ha sido eliminado del sistema de forma segura.")
                    Catch ex As Exception
                        If ex.Message.Contains("ORA-02292") Then
                            MostrarError("No es posible eliminar este reclamo porque tiene historial o documentos asociados.")
                        Else
                            MostrarError("No se pudo eliminar el registro. Intenta de nuevo en unos momentos.")
                        End If
                    End Try
            End Select
        End Sub

        Private Function ValidarFormulario() As Boolean
            If hfModo.Value = "nuevo" AndAlso String.IsNullOrWhiteSpace(ddlOrden.SelectedValue) Then
                MostrarError("Por favor, selecciona la orden de compra a la que pertenece el reclamo.") : Return False
            End If
            If String.IsNullOrWhiteSpace(txtComentarios.Text) Then
                MostrarError("Necesitamos que escribas los detalles o comentarios del reclamo.") : Return False
            End If
            Return True
        End Function

        Private Sub LimpiarFormulario()
            hfId.Value = "0"
            hfModo.Value = "nuevo"
            txtComentarios.Text = ""
            ddlOrden.Enabled = True
            ddlOrden.SelectedIndex = 0
            ddlEstado.SelectedIndex = 0
            pnlCambioEstado.Visible = False
            lblTituloForm.Text = "➕ Nuevo Reclamo"
            btnGuardar.Text = "💾 Guardar"
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = "<span><strong>Lo sentimos:</strong> " & msg & "</span>"
            pnlMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = "<span><strong>¡Hecho!</strong> " & msg & "</span>"
            pnlMsg.CssClass = "alert-ok"
            pnlMsg.Visible = True
        End Sub

    End Class
End Namespace