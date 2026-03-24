Imports System
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: Modules/CatalogoInventario/Categorias.aspx.vb
' ============================================================
Namespace Modules.CatalogoInventario

    Partial Public Class Categorias
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarGrilla(Optional texto As String = "")
            Try
                If String.IsNullOrWhiteSpace(texto) Then
                    gvCategorias.DataSource = CategoriaService.Listar()
                Else
                    gvCategorias.DataSource = CategoriaService.Buscar(texto)
                End If
                gvCategorias.DataBind()
            Catch ex As OracleException
                MostrarError("Error Oracle: " & ex.Message)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            CargarGrilla(txtBuscar.Text.Trim())
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            LimpiarFormulario()
            CargarGrilla()
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtDescripcion.Text) Then
                MostrarError("La descripción es obligatoria.")
                Return
            End If
            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                If id = 0 Then
                    CategoriaService.Crear(txtDescripcion.Text.Trim())
                    MostrarExito("Categoría creada correctamente.")
                Else
                    CategoriaService.Actualizar(id, txtDescripcion.Text.Trim())
                    MostrarExito("Categoría actualizada correctamente.")
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

        Protected Sub gvCategorias_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)
            Select Case e.CommandName
                Case "Editar"
                    Dim dt As DataTable = CategoriaService.Listar()
                    Dim fila As DataRow() = dt.Select("CAT_CATEGORIA = " & id)
                    If fila.Length > 0 Then
                        hfId.Value = id.ToString()
                        txtDescripcion.Text = fila(0)("CAT_DESCRIPCION").ToString()
                        lblTituloForm.Text = "Editar Categoría"
                        btnGuardar.Text = "Actualizar"
                    End If
                Case "Eliminar"
                    Try
                        CategoriaService.Eliminar(id)
                        MostrarExito("Categoría eliminada correctamente.")
                        LimpiarFormulario()
                        CargarGrilla()
                    Catch ex As OracleException
                        MostrarError("Error Oracle: " & ex.Message)
                    Catch ex As Exception
                        MostrarError("Error: " & ex.Message)
                    End Try
            End Select
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = "0"
            txtDescripcion.Text = ""
            lblTituloForm.Text = "Nueva Categoría"
            btnGuardar.Text = "Guardar"
            pnlMsg.Visible = False
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert alert-danger"
            pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert alert-success"
            pnlMsg.Visible = True
        End Sub

    End Class

End Namespace