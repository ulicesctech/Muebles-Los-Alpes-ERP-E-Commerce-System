Imports Oracle.ManagedDataAccess.Client
Imports Oracle.ManagedDataAccess.Types
Imports System.Configuration
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios.Admin

    Partial Public Class Permisos
        Inherits System.Web.UI.Page

        '══════════════════════════════════════
        ' PAGE LOAD
        '══════════════════════════════════════
        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPermisos()
            End If
        End Sub

        '══════════════════════════════════════
        ' CARGAR GRID
        '══════════════════════════════════════
        Private Sub CargarPermisos()
            Try
                Using conn As New OracleConnection(
                    ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)

                    conn.Open()
                    Using cmd As New OracleCommand("PKG_ADMIN_PERMISOS.per_listar", conn)
                        cmd.CommandType = CommandType.StoredProcedure

                        Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
                        pCursor.Direction = ParameterDirection.Output
                        cmd.Parameters.Add(pCursor)

                        Dim adapter As New OracleDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)

                        gvPermisos.DataSource = dt
                        gvPermisos.DataBind()
                    End Using
                End Using

                lblMensaje.Visible = False
                lblError.Visible = False

            Catch ex As Exception
                lblError.Text = "Error al cargar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '══════════════════════════════════════
        ' GUARDAR — Crear o Actualizar
        '══════════════════════════════════════
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Try
                Using conn As New OracleConnection(
                    ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)

                    conn.Open()

                    If hfId.Value <> "" Then
                        '── ACTUALIZAR ──────────────────────────
                        Using cmd As New OracleCommand("PKG_ADMIN_PERMISOS.per_actualizar", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.Add("p_id", OracleDbType.Int32).Value = Convert.ToInt32(hfId.Value)
                            cmd.Parameters.Add("p_admin", OracleDbType.Int32).Value = If(chkAdmin.Checked, 1, 0)
                            cmd.Parameters.Add("p_rh", OracleDbType.Int32).Value = If(chkRH.Checked, 1, 0)
                            cmd.Parameters.Add("p_fac", OracleDbType.Int32).Value = If(chkFac.Checked, 1, 0)
                            cmd.Parameters.Add("p_cli", OracleDbType.Int32).Value = If(chkCli.Checked, 1, 0)
                            cmd.Parameters.Add("p_bod", OracleDbType.Int32).Value = If(chkBod.Checked, 1, 0)
                            cmd.Parameters.Add("p_promo", OracleDbType.Int32).Value = If(chkPromo.Checked, 1, 0)
                            cmd.ExecuteNonQuery()
                        End Using
                        lblMensaje.Text = "✅ Permiso actualizado correctamente."
                    Else
                        '── CREAR ────────────────────────────────
                        Using cmd As New OracleCommand("PKG_ADMIN_PERMISOS.per_crear", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.Add("p_admin", OracleDbType.Int32).Value = If(chkAdmin.Checked, 1, 0)
                            cmd.Parameters.Add("p_rh", OracleDbType.Int32).Value = If(chkRH.Checked, 1, 0)
                            cmd.Parameters.Add("p_fac", OracleDbType.Int32).Value = If(chkFac.Checked, 1, 0)
                            cmd.Parameters.Add("p_cli", OracleDbType.Int32).Value = If(chkCli.Checked, 1, 0)
                            cmd.Parameters.Add("p_bod", OracleDbType.Int32).Value = If(chkBod.Checked, 1, 0)
                            cmd.Parameters.Add("p_promo", OracleDbType.Int32).Value = If(chkPromo.Checked, 1, 0)

                            Dim pId As New OracleParameter("p_id", OracleDbType.Int32)
                            pId.Direction = ParameterDirection.Output
                            cmd.Parameters.Add(pId)
                            cmd.ExecuteNonQuery()

                            Dim nuevoId As Integer = Convert.ToInt32(pId.Value.ToString())
                            lblMensaje.Text = "✅ Permiso creado con ID: " & nuevoId
                        End Using
                    End If

                    lblMensaje.Visible = True
                    lblError.Visible = False
                End Using

                LimpiarFormulario()
                CargarPermisos()

            Catch ex As Exception
                lblError.Text = "Error al guardar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '══════════════════════════════════════
        ' NUEVO
        '══════════════════════════════════════
        Protected Sub btnNuevo_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            lblMensaje.Visible = False
            lblError.Visible = False
        End Sub

        '══════════════════════════════════════
        ' GRID — Editar y Eliminar
        '══════════════════════════════════════
        Protected Sub gvPermisos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Using conn As New OracleConnection(
                        ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)

                        conn.Open()
                        Using cmd As New OracleCommand(
                            "SELECT per_admin,per_rh,per_fac,per_cli,per_bod,per_promo " &
                            "FROM ADMIN_PERMISOS WHERE per_permisos = :id", conn)

                            cmd.Parameters.Add("id", OracleDbType.Int32).Value = id
                            Dim reader = cmd.ExecuteReader()

                            If reader.Read() Then
                                hfId.Value = id.ToString()
                                chkAdmin.Checked = (reader("per_admin").ToString() = "1")
                                chkRH.Checked = (reader("per_rh").ToString() = "1")
                                chkFac.Checked = (reader("per_fac").ToString() = "1")
                                chkCli.Checked = (reader("per_cli").ToString() = "1")
                                chkBod.Checked = (reader("per_bod").ToString() = "1")
                                chkPromo.Checked = (reader("per_promo").ToString() = "1")
                            End If
                        End Using
                    End Using

                    lblMensaje.Text = "✏️ Editando permiso ID: " & id
                    lblMensaje.Visible = True

                Catch ex As Exception
                    lblError.Text = "Error al cargar: " & ex.Message
                    lblError.Visible = True
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    Using conn As New OracleConnection(
                        ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)

                        conn.Open()
                        Using cmd As New OracleCommand("PKG_ADMIN_PERMISOS.per_eliminar", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.Add("p_id", OracleDbType.Int32).Value = id
                            cmd.ExecuteNonQuery()
                        End Using
                    End Using

                    lblMensaje.Text = "🗑️ Permiso ID " & id & " eliminado."
                    lblMensaje.Visible = True

                Catch ex As Exception
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
            End If

            CargarPermisos()
        End Sub

        '══════════════════════════════════════
        ' LIMPIAR FORMULARIO
        '══════════════════════════════════════
        Private Sub LimpiarFormulario()
            hfId.Value = ""
            chkAdmin.Checked = False
            chkRH.Checked = False
            chkFac.Checked = False
            chkCli.Checked = False
            chkBod.Checked = False
            chkPromo.Checked = False
        End Sub

    End Class
End Namespace