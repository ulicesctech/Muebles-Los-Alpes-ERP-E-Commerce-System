Imports System
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.CatalogoInventario

    Partial Public Class Almacenes
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarGrilla()
            Try
                gvAlmacenes.DataSource = AlmacenService.Listar()
                gvAlmacenes.DataBind()
            Catch ex As OracleException
                MostrarError("Error Oracle: " & ex.Message)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtNombre.Text) Then MostrarError("El nombre es obligatorio.") : Return
            If String.IsNullOrWhiteSpace(txtPais.Text) Then MostrarError("El país es obligatorio.") : Return
            If String.IsNullOrWhiteSpace(txtUbicacion.Text) Then MostrarError("La ubicación es obligatoria.") : Return
            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                If id = 0 Then
                    AlmacenService.Crear(txtNombre.Text.Trim(), txtPais.Text.Trim(), txtUbicacion.Text.Trim())
                    MostrarExito("Almacén creado correctamente.")
                Else
                    AlmacenService.Actualizar(id, txtNombre.Text.Trim(), txtPais.Text.Trim(), txtUbicacion.Text.Trim())
                    MostrarExito("Almacén actualizado correctamente.")
                End If
                LimpiarFormulario() : CargarGrilla()
            Catch ex As OracleException
                MostrarError("Error Oracle: " & ex.Message)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario() : CargarGrilla()
        End Sub

        Protected Sub gvAlmacenes_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)
            Select Case e.CommandName
                Case "Editar"
                    Dim dt As DataTable = AlmacenService.Listar()
                    Dim fila As DataRow() = dt.Select("ALM_ALMACEN = " & id)
                    If fila.Length > 0 Then
                        hfId.Value = id.ToString()
                        txtNombre.Text = fila(0)("ALM_NOMBRE").ToString()
                        txtPais.Text = fila(0)("ALM_PAIS").ToString()
                        txtUbicacion.Text = fila(0)("ALM_UBICACION").ToString()
                        lblTituloForm.Text = "Editar Almacén" : btnGuardar.Text = "Actualizar"
                    End If
                Case "Eliminar"
                    Try
                        AlmacenService.Eliminar(id)
                        MostrarExito("Almacén eliminado correctamente.")
                        LimpiarFormulario() : CargarGrilla()
                    Catch ex As OracleException
                        MostrarError("Error Oracle: " & ex.Message)
                    Catch ex As Exception
                        MostrarError("Error: " & ex.Message)
                    End Try
            End Select
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = "0" : txtNombre.Text = "" : txtPais.Text = "" : txtUbicacion.Text = ""
            lblTituloForm.Text = "Nuevo Almacén" : btnGuardar.Text = "Guardar"
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