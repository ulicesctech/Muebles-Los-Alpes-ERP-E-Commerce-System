Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Namespace MueblesAlpes.Web.Modules.RH

    Partial Class Puestos
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPuestos()
            End If
        End Sub

        ' =========================
        ' INSERT / UPDATE
        ' =========================
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Try
                If hfId.Value = "" Then
                    Dim ps As New List(Of OracleParameter) From {
                        New OracleParameter("p_pue_nombre", OracleDbType.Varchar2, txtNombre.Text, ParameterDirection.Input),
                        New OracleParameter("p_pue_salario", OracleDbType.Decimal, Convert.ToDecimal(txtSalario.Text), ParameterDirection.Input),
                        New OracleParameter("p_pue_descripcion", OracleDbType.Varchar2, txtDescripcion.Text, ParameterDirection.Input)
                    }
                    OracleDb.ExecNonQuery("PKG_RH_PUESTO.PUE_CREAR", ps)
                    lblMensaje.Text = "Puesto creado correctamente."
                Else
                    Dim ps As New List(Of OracleParameter) From {
                        New OracleParameter("p_pue_puestos", OracleDbType.Int32, Convert.ToInt32(hfId.Value), ParameterDirection.Input),
                        New OracleParameter("p_pue_nombre", OracleDbType.Varchar2, txtNombre.Text, ParameterDirection.Input),
                        New OracleParameter("p_pue_salario", OracleDbType.Decimal, Convert.ToDecimal(txtSalario.Text), ParameterDirection.Input),
                        New OracleParameter("p_pue_descripcion", OracleDbType.Varchar2, txtDescripcion.Text, ParameterDirection.Input)
                    }
                    OracleDb.ExecNonQuery("PKG_RH_PUESTO.PUE_ACTUALIZAR", ps)
                    lblMensaje.Text = "Puesto actualizado correctamente."
                End If

                Limpiar()
                CargarPuestos()

            Catch ex As Exception
                lblMensaje.Text = "Error: " & ex.Message
            End Try
        End Sub

        ' =========================
        ' LISTAR
        ' =========================
        Private Sub CargarPuestos()
            Try
                Dim ps As New List(Of OracleParameter) From {
                    New OracleParameter("p_pue_puestos", OracleDbType.Int32, DBNull.Value, ParameterDirection.Input)
                }
                gvPuestos.DataSource = OracleDb.ExecRefCursor("PKG_RH_PUESTO.PUE_LISTAR", ps, "RETURN_VALUE")
                gvPuestos.DataBind()
            Catch ex As Exception
                lblMensaje.Text = "Error al cargar: " & ex.Message
            End Try
        End Sub

        ' =========================
        ' GRID EVENTOS
        ' =========================
        Protected Sub gvPuestos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "Editar" OrElse e.CommandName = "Eliminar" Then
                Dim index As Integer = Convert.ToInt32(e.CommandArgument)
                Dim id As Integer = Convert.ToInt32(gvPuestos.Rows(index).Cells(0).Text)

                If e.CommandName = "Editar" Then
                    CargarRegistro(id)
                ElseIf e.CommandName = "Eliminar" Then
                    Eliminar(id)
                End If
            End If
        End Sub

        ' =========================
        ' CARGAR REGISTRO (EDITAR)
        ' =========================
        Private Sub CargarRegistro(id As Integer)
            Try
                Dim ps As New List(Of OracleParameter) From {
                    New OracleParameter("p_pue_puestos", OracleDbType.Int32, id, ParameterDirection.Input)
                }
                Dim dt As DataTable = OracleDb.ExecRefCursor("PKG_RH_PUESTO.PUE_LISTAR", ps, "RETURN_VALUE")

                If dt.Rows.Count > 0 Then
                    hfId.Value = dt.Rows(0)("pue_puestos").ToString()
                    txtNombre.Text = dt.Rows(0)("pue_nombre").ToString()
                    txtSalario.Text = dt.Rows(0)("pue_salario").ToString()
                    txtDescripcion.Text = dt.Rows(0)("pue_descripcion").ToString()
                End If
            Catch ex As Exception
                lblMensaje.Text = "Error al cargar registro: " & ex.Message
            End Try
        End Sub

        ' =========================
        ' ELIMINAR
        ' =========================
        Private Sub Eliminar(id As Integer)
            Try
                Dim ps As New List(Of OracleParameter) From {
                    New OracleParameter("p_pue_puestos", OracleDbType.Int32, id, ParameterDirection.Input)
                }
                OracleDb.ExecNonQuery("PKG_RH_PUESTO.PUE_ELIMINAR", ps)
                lblMensaje.Text = "Puesto eliminado correctamente."
                CargarPuestos()
            Catch ex As Exception
                lblMensaje.Text = "Error al eliminar: " & ex.Message
            End Try
        End Sub

        ' =========================
        ' LIMPIAR
        ' =========================
        Private Sub Limpiar()
            hfId.Value = ""
            txtNombre.Text = ""
            txtSalario.Text = ""
            txtDescripcion.Text = ""
        End Sub

        Protected Sub btnNuevo_Click(sender As Object, e As EventArgs)
            Limpiar()
        End Sub

    End Class

End Namespace