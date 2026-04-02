Imports Oracle.ManagedDataAccess.Client
Imports System.Configuration
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class LoginEmpleado
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarLogins()
            End If
        End Sub

        Private Sub CargarLogins()
            Try
                Using conn As New OracleConnection(
                    ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)
                    conn.Open()
                    Using cmd As New OracleCommand("PKG_ADMIN_LOGIN_EMPLEADO.log_em_listar", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
                        pCursor.Direction = ParameterDirection.Output
                        cmd.Parameters.Add(pCursor)
                        Dim adapter As New OracleDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        gvLogins.DataSource = dt
                        gvLogins.DataBind()
                    End Using
                End Using
                lblMensaje.Visible = False
                lblError.Visible = False
            Catch ex As Exception
                lblError.Text = "Error al cargar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '??????????????????????????????????????
        ' CREAR LOGIN
        '??????????????????????????????????????
        Protected Sub btnCrear_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtCrearId.Text) OrElse
               String.IsNullOrWhiteSpace(txtCrearUsuario.Text) OrElse
               String.IsNullOrWhiteSpace(txtCrearPassword.Text) Then
                lblError.Text = "?? Todos los campos son obligatorios."
                lblError.Visible = True
                Return
            End If
            Try
                Using conn As New OracleConnection(
                    ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)
                    conn.Open()
                    Using cmd As New OracleCommand("PKG_ADMIN_LOGIN_EMPLEADO.log_em_crear", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.Add("p_em_empleado", OracleDbType.Int32).Value = Convert.ToInt32(txtCrearId.Text)
                        cmd.Parameters.Add("p_usuario", OracleDbType.Varchar2).Value = txtCrearUsuario.Text.Trim()
                        cmd.Parameters.Add("p_password", OracleDbType.Varchar2).Value = txtCrearPassword.Text
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
                lblMensaje.Text = "? Login creado correctamente."
                lblMensaje.Visible = True
                lblError.Visible = False
                txtCrearId.Text = ""
                txtCrearUsuario.Text = ""
                txtCrearPassword.Text = ""
                CargarLogins()
            Catch ex As Exception
                lblError.Text = "Error al crear: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '??????????????????????????????????????
        ' ACTUALIZAR PASSWORD
        '??????????????????????????????????????
        Protected Sub btnActPass_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtPassId.Text) OrElse
               String.IsNullOrWhiteSpace(txtNuevoPass.Text) Then
                lblError.Text = "?? Todos los campos son obligatorios."
                lblError.Visible = True
                Return
            End If
            Try
                Using conn As New OracleConnection(
                    ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)
                    conn.Open()
                    Using cmd As New OracleCommand("PKG_ADMIN_LOGIN_EMPLEADO.log_em_actualizar_pass", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.Add("p_em_empleado", OracleDbType.Int32).Value = Convert.ToInt32(txtPassId.Text)
                        cmd.Parameters.Add("p_password", OracleDbType.Varchar2).Value = txtNuevoPass.Text
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
                lblMensaje.Text = "? Password actualizado correctamente."
                lblMensaje.Visible = True
                lblError.Visible = False
                txtPassId.Text = ""
                txtNuevoPass.Text = ""
                CargarLogins()
            Catch ex As Exception
                lblError.Text = "Error al actualizar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '??????????????????????????????????????
        ' ACTUALIZAR USUARIO
        '??????????????????????????????????????
        Protected Sub btnActUsr_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtUsrId.Text) OrElse
               String.IsNullOrWhiteSpace(txtNuevoUsr.Text) Then
                lblError.Text = "?? Todos los campos son obligatorios."
                lblError.Visible = True
                Return
            End If
            Try
                Using conn As New OracleConnection(
                    ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)
                    conn.Open()
                    Using cmd As New OracleCommand("PKG_ADMIN_LOGIN_EMPLEADO.log_em_actualizar_usuario", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.Add("p_em_empleado", OracleDbType.Int32).Value = Convert.ToInt32(txtUsrId.Text)
                        cmd.Parameters.Add("p_usuario", OracleDbType.Varchar2).Value = txtNuevoUsr.Text.Trim()
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
                lblMensaje.Text = "? Usuario actualizado correctamente."
                lblMensaje.Visible = True
                lblError.Visible = False
                txtUsrId.Text = ""
                txtNuevoUsr.Text = ""
                CargarLogins()
            Catch ex As Exception
                lblError.Text = "Error al actualizar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '??????????????????????????????????????
        ' VALIDAR LOGIN
        '??????????????????????????????????????
        Protected Sub btnValidar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtValUsr.Text) OrElse
               String.IsNullOrWhiteSpace(txtValPass.Text) Then
                lblError.Text = "?? Usuario y password obligatorios."
                lblError.Visible = True
                Return
            End If
            Try
                Using conn As New OracleConnection(
                    ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)
                    conn.Open()
                    Using cmd As New OracleCommand("PKG_ADMIN_LOGIN_EMPLEADO.log_em_validar", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.Add("p_usuario", OracleDbType.Varchar2).Value = txtValUsr.Text.Trim()
                        cmd.Parameters.Add("p_password", OracleDbType.Varchar2).Value = txtValPass.Text

                        Dim pResultado As New OracleParameter("p_resultado", OracleDbType.Int32)
                        pResultado.Direction = ParameterDirection.Output
                        cmd.Parameters.Add(pResultado)

                        Dim pId As New OracleParameter("p_em_empleado", OracleDbType.Int32)
                        pId.Direction = ParameterDirection.Output
                        cmd.Parameters.Add(pId)

                        cmd.ExecuteNonQuery()

                        Dim resultado As Integer = Convert.ToInt32(pResultado.Value.ToString())
                        If resultado = 1 Then
                            lblMensaje.Text = "? Login válido — Empleado ID: " & pId.Value.ToString()
                            lblMensaje.Visible = True
                            lblError.Visible = False
                        Else
                            lblError.Text = "? Usuario o password incorrecto."
                            lblError.Visible = True
                        End If
                    End Using
                End Using
                txtValUsr.Text = ""
                txtValPass.Text = ""
            Catch ex As Exception
                lblError.Text = "Error al validar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '??????????????????????????????????????
        ' GRID — Eliminar
        '??????????????????????????????????????
        Protected Sub gvLogins_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "Eliminar" Then
                Try
                    Using conn As New OracleConnection(
                        ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)
                        conn.Open()
                        Using cmd As New OracleCommand("PKG_ADMIN_LOGIN_EMPLEADO.log_em_eliminar", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.Add("p_em_empleado", OracleDbType.Int32).Value = Convert.ToInt32(e.CommandArgument)
                            cmd.ExecuteNonQuery()
                        End Using
                    End Using
                    lblMensaje.Text = "??? Login eliminado correctamente."
                    lblMensaje.Visible = True
                    lblError.Visible = False
                Catch ex As Exception
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
                CargarLogins()
            End If
        End Sub

    End Class
End Namespace