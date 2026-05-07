Imports Oracle.ManagedDataAccess.Client

Namespace Modules.CatalogoInventario

    Partial Public Class Materiales
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarGrilla(Optional texto As String = "")
            Try
                If String.IsNullOrWhiteSpace(texto) Then
                    gvMateriales.DataSource = MaterialService.Listar()
                Else
                    gvMateriales.DataSource = MaterialService.Buscar(texto)
                End If
                gvMateriales.DataBind()
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
                    MaterialService.Crear(txtDescripcion.Text.Trim())
                    MostrarExito("Material creado correctamente.")
                Else
                    MaterialService.Actualizar(id, txtDescripcion.Text.Trim())
                    MostrarExito("Material actualizado correctamente.")
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

        Protected Sub gvMateriales_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)
            Select Case e.CommandName
                Case "Editar"
                    Dim dt As DataTable = MaterialService.Listar()
                    Dim fila As DataRow() = dt.Select("MAT_MATERIAL = " & id)
                    If fila.Length > 0 Then
                        hfId.Value = id.ToString()
                        txtDescripcion.Text = fila(0)("MAT_DESCRIPCION").ToString()
                        lblTituloForm.Text = "Editar Material"
                        btnGuardar.Text = "Actualizar"
                    End If
                Case "Eliminar"
                    Try
                        MaterialService.Eliminar(id)
                        MostrarExito("Material eliminado correctamente.")
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
            hfId.Value = "0" : txtDescripcion.Text = ""
            lblTituloForm.Text = "Nuevo Material" : btnGuardar.Text = "Guardar"
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