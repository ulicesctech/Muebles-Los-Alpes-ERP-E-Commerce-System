Imports Oracle.ManagedDataAccess.Client

Namespace Modules.CatalogoInventario

    Partial Public Class Tipos
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarCategorias()
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarCategorias()
            Try
                Dim dt As DataTable = CategoriaService.Listar()
                ddlCategoria.Items.Clear()
                ddlCategoria.Items.Add(New ListItem("-- Seleccione --", "0"))
                For Each row As DataRow In dt.Rows
                    ddlCategoria.Items.Add(New ListItem(row("CAT_DESCRIPCION").ToString(), row("CAT_CATEGORIA").ToString()))
                Next
                ddlFiltroCategoria.Items.Clear()
                ddlFiltroCategoria.Items.Add(New ListItem("-- Todas --", "0"))
                For Each row As DataRow In dt.Rows
                    ddlFiltroCategoria.Items.Add(New ListItem(row("CAT_DESCRIPCION").ToString(), row("CAT_CATEGORIA").ToString()))
                Next
            Catch ex As Exception
                MostrarError("Error cargando categorías: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarGrilla()
            Try
                Dim catId As Decimal = Convert.ToDecimal(ddlFiltroCategoria.SelectedValue)
                If catId = 0 Then
                    gvTipos.DataSource = TipoService.Listar()
                Else
                    gvTipos.DataSource = TipoService.ListarPorCategoria(catId)
                End If
                gvTipos.DataBind()
            Catch ex As OracleException
                MostrarError("Error Oracle: " & ex.Message)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub ddlFiltroCategoria_SelectedIndexChanged(sender As Object, e As EventArgs)
            CargarGrilla()
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtDescripcion.Text) Then
                MostrarError("La descripción es obligatoria.") : Return
            End If
            If ddlCategoria.SelectedValue = "0" Then
                MostrarError("Debe seleccionar una categoría.") : Return
            End If
            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                Dim catId As Decimal = Convert.ToDecimal(ddlCategoria.SelectedValue)
                If id = 0 Then
                    TipoService.Crear(txtDescripcion.Text.Trim(), catId)
                    MostrarExito("Tipo creado correctamente.")
                Else
                    TipoService.Actualizar(id, txtDescripcion.Text.Trim(), catId)
                    MostrarExito("Tipo actualizado correctamente.")
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
            LimpiarFormulario() : CargarGrilla()
        End Sub

        Protected Sub gvTipos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)
            Select Case e.CommandName
                Case "Editar"
                    Dim dt As DataTable = TipoService.Listar()
                    Dim fila As DataRow() = dt.Select("TIP_TIPO = " & id)
                    If fila.Length > 0 Then
                        hfId.Value = id.ToString()
                        txtDescripcion.Text = fila(0)("TIP_DESCRIPCION").ToString()
                        ddlCategoria.SelectedValue = fila(0)("CAT_CATEGORIA").ToString()
                        lblTituloForm.Text = "Editar Tipo" : btnGuardar.Text = "Actualizar"
                    End If
                Case "Eliminar"
                    Try
                        TipoService.Eliminar(id)
                        MostrarExito("Tipo eliminado correctamente.")
                        LimpiarFormulario() : CargarGrilla()
                    Catch ex As OracleException
                        MostrarError("Error Oracle: " & ex.Message)
                    Catch ex As Exception
                        MostrarError("Error: " & ex.Message)
                    End Try
            End Select
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = "0" : txtDescripcion.Text = ""
            ddlCategoria.SelectedIndex = 0
            lblTituloForm.Text = "Nuevo Tipo" : btnGuardar.Text = "Guardar"
            pnlMsg.Visible = False
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = msg : pnlMsg.CssClass = "alert alert-danger" : pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = msg : pnlMsg.CssClass = "alert alert-success" : pnlMsg.Visible = True
        End Sub

    End Class
End Namespace