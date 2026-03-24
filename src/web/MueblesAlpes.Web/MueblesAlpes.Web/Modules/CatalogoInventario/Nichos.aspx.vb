Imports System
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.CatalogoInventario

    Partial Public Class Nichos
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarGrilla()
            Try
                gvNichos.DataSource = NichoService.Listar()
                gvNichos.DataBind()
            Catch ex As OracleException
                MostrarError("Error Oracle: " & ex.Message)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtNumero.Text) Then MostrarError("El número es obligatorio.") : Return
            If String.IsNullOrWhiteSpace(txtZona.Text) Then MostrarError("La zona es obligatoria.") : Return
            If String.IsNullOrWhiteSpace(txtCaracteristica.Text) Then MostrarError("La característica es obligatoria.") : Return
            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                If id = 0 Then
                    NichoService.Crear(txtNumero.Text.Trim(), txtZona.Text.Trim(), txtCaracteristica.Text.Trim())
                    MostrarExito("Nicho creado correctamente.")
                Else
                    NichoService.Actualizar(id, txtNumero.Text.Trim(), txtZona.Text.Trim(), txtCaracteristica.Text.Trim())
                    MostrarExito("Nicho actualizado correctamente.")
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

        Protected Sub gvNichos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)
            Select Case e.CommandName
                Case "Editar"
                    Dim dt As DataTable = NichoService.Listar()
                    Dim fila As DataRow() = dt.Select("NIC_NICHO = " & id)
                    If fila.Length > 0 Then
                        hfId.Value = id.ToString()
                        txtNumero.Text = fila(0)("NIC_NUMERO").ToString()
                        txtZona.Text = fila(0)("NIC_ZONA").ToString()
                        txtCaracteristica.Text = fila(0)("NIC_CARACTERISTICA").ToString()
                        lblTituloForm.Text = "Editar Nicho" : btnGuardar.Text = "Actualizar"
                    End If
                Case "Eliminar"
                    Try
                        NichoService.Eliminar(id)
                        MostrarExito("Nicho eliminado correctamente.")
                        LimpiarFormulario() : CargarGrilla()
                    Catch ex As OracleException
                        MostrarError("Error Oracle: " & ex.Message)
                    Catch ex As Exception
                        MostrarError("Error: " & ex.Message)
                    End Try
            End Select
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = "0" : txtNumero.Text = "" : txtZona.Text = "" : txtCaracteristica.Text = ""
            lblTituloForm.Text = "Nuevo Nicho" : btnGuardar.Text = "Guardar"
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