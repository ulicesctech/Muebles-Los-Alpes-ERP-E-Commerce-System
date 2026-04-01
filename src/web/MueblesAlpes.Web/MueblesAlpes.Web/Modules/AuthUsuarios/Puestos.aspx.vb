Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Namespace MueblesAlpes.Web.Modules.RH

    Partial Class Puestos
        Inherits System.Web.UI.Page

        Dim conn As New OracleConnection("DATA SOURCE=XE;USER ID=tu_usuario;PASSWORD=tu_clave")

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
                conn.Open()

                Dim cmd As OracleCommand

                If hfId.Value = "" Then
                    ' INSERT
                    cmd = New OracleCommand("PKG_RH_PUESTO.PUE_CREAR", conn)
                    cmd.CommandType = CommandType.StoredProcedure

                    cmd.Parameters.Add("p_pue_nombre", OracleDbType.Varchar2).Value = txtNombre.Text
                    cmd.Parameters.Add("p_pue_salario", OracleDbType.Decimal).Value = Convert.ToDecimal(txtSalario.Text)
                    cmd.Parameters.Add("p_pue_descripcion", OracleDbType.Varchar2).Value = txtDescripcion.Text

                    cmd.Parameters.Add("p_nuevo_id", OracleDbType.Int32).Direction = ParameterDirection.Output

                    cmd.ExecuteNonQuery()

                    lblMensaje.Text = "Insertado correctamente"

                Else
                    ' UPDATE
                    cmd = New OracleCommand("PKG_RH_PUESTO.PUE_ACTUALIZAR", conn)
                    cmd.CommandType = CommandType.StoredProcedure

                    cmd.Parameters.Add("p_pue_puestos", OracleDbType.Int32).Value = Convert.ToInt32(hfId.Value)
                    cmd.Parameters.Add("p_pue_nombre", OracleDbType.Varchar2).Value = txtNombre.Text
                    cmd.Parameters.Add("p_pue_salario", OracleDbType.Decimal).Value = Convert.ToDecimal(txtSalario.Text)
                    cmd.Parameters.Add("p_pue_descripcion", OracleDbType.Varchar2).Value = txtDescripcion.Text

                    cmd.ExecuteNonQuery()

                    lblMensaje.Text = "Actualizado correctamente"
                End If

                conn.Close()
                Limpiar()
                CargarPuestos()

            Catch ex As Exception
                lblMensaje.Text = ex.Message
                conn.Close()
            End Try
        End Sub

        ' =========================
        ' LISTAR
        ' =========================
        Private Sub CargarPuestos()
            conn.Open()

            Dim cmd As New OracleCommand("PKG_RH_PUESTO.PUE_LISTAR", conn)
            cmd.CommandType = CommandType.StoredProcedure

            ' Parámetro de entrada
            cmd.Parameters.Add("p_pue_puestos", OracleDbType.Int32).Value = DBNull.Value

            ' RETORNO (cursor)
            cmd.Parameters.Add("RETURN_VALUE", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue

            Dim da As New OracleDataAdapter(cmd)
            Dim dt As New DataTable()

            da.Fill(dt)

            gvPuestos.DataSource = dt
            gvPuestos.DataBind()

            conn.Close()
        End Sub

        ' =========================
        ' GRID EVENTOS
        ' =========================
        Protected Sub gvPuestos_RowCommand(sender As Object, e As GridViewCommandEventArgs)

            If e.CommandName = "Editar" Or e.CommandName = "Eliminar" Then

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

            conn.Open()

            Dim cmd As New OracleCommand("PKG_RH_PUESTO.PUE_LISTAR", conn)
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.Add("p_pue_puestos", OracleDbType.Int32).Value = id
            cmd.Parameters.Add("RETURN_VALUE", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue

            Dim da As New OracleDataAdapter(cmd)
            Dim dt As New DataTable()

            da.Fill(dt)

            If dt.Rows.Count > 0 Then
                hfId.Value = dt.Rows(0)("pue_puestos").ToString()
                txtNombre.Text = dt.Rows(0)("pue_nombre").ToString()
                txtSalario.Text = dt.Rows(0)("pue_salario").ToString()
                txtDescripcion.Text = dt.Rows(0)("pue_descripcion").ToString()
            End If

            conn.Close()
        End Sub

        ' =========================
        ' ELIMINAR
        ' =========================
        Private Sub Eliminar(id As Integer)
            Try
                conn.Open()

                Dim cmd As New OracleCommand("PKG_RH_PUESTO.PUE_ELIMINAR", conn)
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("p_pue_puestos", OracleDbType.Int32).Value = id

                cmd.ExecuteNonQuery()

                conn.Close()
                CargarPuestos()

            Catch ex As Exception
                lblMensaje.Text = ex.Message
                conn.Close()
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