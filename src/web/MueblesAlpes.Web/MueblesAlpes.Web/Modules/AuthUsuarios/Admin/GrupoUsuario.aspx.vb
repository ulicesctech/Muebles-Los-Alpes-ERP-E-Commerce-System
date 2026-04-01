Imports Oracle.ManagedDataAccess.Client
Imports System.Configuration
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios.Admin

    Partial Public Class GrupoUsuario
        Inherits System.Web.UI.Page

        '══════════════════════════════════════
        ' PAGE LOAD
        '══════════════════════════════════════
        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPermisos()   ' Llena el DropDownList
                CargarGrupos()     ' Llena el GridView
            End If
        End Sub

        '══════════════════════════════════════
        ' LLENAR DROPDOWNLIST DE PERMISOS
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

                        ddlPermisos.DataSource = dt
                        ddlPermisos.DataTextField = "per_permisos"  ' Lo que ve el usuario
                        ddlPermisos.DataValueField = "per_permisos"  ' El valor que se guarda
                        ddlPermisos.DataBind()
                        ddlPermisos.Items.Insert(0, New ListItem("-- Seleccione permiso --", "0"))
                    End Using
                End Using

            Catch ex As Exception
                lblError.Text = "Error al cargar permisos: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '══════════════════════════════════════
        ' CARGAR GRID DE GRUPOS
        '══════════════════════════════════════
        Private Sub CargarGrupos()
            Try
                Using conn As New OracleConnection(
                    ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)

                    conn.Open()
                    Using cmd As New OracleCommand("PKG_ADMIN_GRUPO_USUARIO.gru_listar", conn)
                        cmd.CommandType = CommandType.StoredProcedure

                        Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
                        pCursor.Direction = ParameterDirection.Output
                        cmd.Parameters.Add(pCursor)

                        Dim adapter As New OracleDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)

                        gvGrupos.DataSource = dt
                        gvGrupos.DataBind()
                    End Using
                End Using

                lblMensaje.Visible = False
                lblError.Visible = False

            Catch ex As Exception
                lblError.Text = "Error al cargar grupos: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '══════════════════════════════════════
        ' GUARDAR — Crear o Actualizar
        '══════════════════════════════════════
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            ' Validar descripción
            If String.IsNullOrWhiteSpace(txtDescripcion.Text) Then
                lblError.Text = "⚠️ La descripción es obligatoria."
                lblError.Visible = True
                Return
            End If

            ' Validar permiso seleccionado
            If ddlPermisos.SelectedValue = "0" Then
                lblError.Text = "⚠️ Debe seleccionar un permiso."
                lblError.Visible = True
                Return
            End If

            Try
                Using conn As New OracleConnection(
                    ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)

                    conn.Open()

                    If hfId.Value <> "" Then
                        '── ACTUALIZAR ──────────────────────────
                        Using cmd As New OracleCommand("PKG_ADMIN_GRUPO_USUARIO.gru_actualizar", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.Add("p_id", OracleDbType.Int32).Value = Convert.ToInt32(hfId.Value)
                            cmd.Parameters.Add("p_descripcion", OracleDbType.Varchar2).Value = txtDescripcion.Text.Trim()
                            cmd.Parameters.Add("p_permisos", OracleDbType.Int32).Value = Convert.ToInt32(ddlPermisos.SelectedValue)
                            cmd.ExecuteNonQuery()
                        End Using
                        lblMensaje.Text = "✅ Grupo actualizado correctamente."
                    Else
                        '── CREAR ────────────────────────────────
                        Using cmd As New OracleCommand("PKG_ADMIN_GRUPO_USUARIO.gru_crear", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.Add("p_descripcion", OracleDbType.Varchar2).Value = txtDescripcion.Text.Trim()
                            cmd.Parameters.Add("p_permisos", OracleDbType.Int32).Value = Convert.ToInt32(ddlPermisos.SelectedValue)

                            Dim pId As New OracleParameter("p_id", OracleDbType.Int32)
                            pId.Direction = ParameterDirection.Output
                            cmd.Parameters.Add(pId)
                            cmd.ExecuteNonQuery()

                            Dim nuevoId As Integer = Convert.ToInt32(pId.Value.ToString())
                            lblMensaje.Text = "✅ Grupo creado con ID: " & nuevoId
                        End Using
                    End If

                    lblMensaje.Visible = True
                    lblError.Visible = False
                End Using

                LimpiarFormulario()
                CargarGrupos()

            Catch ex As Exception
                lblError.Text = "Error al guardar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        '══════════════════════════════════════
        ' NUEVO — limpiar formulario
        '══════════════════════════════════════
        Protected Sub btnNuevo_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            lblMensaje.Visible = False
            lblError.Visible = False
        End Sub

        '══════════════════════════════════════
        ' GRID — Editar y Eliminar
        '══════════════════════════════════════
        Protected Sub gvGrupos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Using conn As New OracleConnection(
                        ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString)

                        conn.Open()
                        Using cmd As New OracleCommand("PKG_ADMIN_GRUPO_USUARIO.gru_buscar", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.Add("p_id", OracleDbType.Int32).Value = id

                            Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
                            pCursor.Direction = ParameterDirection.Output
                            cmd.Parameters.Add(pCursor)

                            Dim adapter As New OracleDataAdapter(cmd)
                            Dim dt As New DataTable()
                            adapter.Fill(dt)

                            If dt.Rows.Count > 0 Then
                                Dim row = dt.Rows(0)
                                hfId.Value = id.ToString()
                                txtDescripcion.Text = row("grupus_descripcion").ToString()
                                ddlPermisos.SelectedValue = row("per_permisos").ToString()
                            End If
                        End Using
                    End Using

                    lblMensaje.Text = "✏️ Editando grupo ID: " & id
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
                        Using cmd As New OracleCommand("PKG_ADMIN_GRUPO_USUARIO.gru_eliminar", conn)
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.Add("p_id", OracleDbType.Int32).Value = id
                            cmd.ExecuteNonQuery()
                        End Using
                    End Using

                    lblMensaje.Text = "🗑️ Grupo ID " & id & " eliminado."
                    lblMensaje.Visible = True

                Catch ex As Exception
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
            End If

            CargarGrupos()
        End Sub

        '══════════════════════════════════════
        ' LIMPIAR FORMULARIO
        '══════════════════════════════════════
        Private Sub LimpiarFormulario()
            hfId.Value = ""
            txtDescripcion.Text = ""
            If ddlPermisos.Items.Count > 0 Then
                ddlPermisos.SelectedIndex = 0
            End If
        End Sub

    End Class
End Namespace