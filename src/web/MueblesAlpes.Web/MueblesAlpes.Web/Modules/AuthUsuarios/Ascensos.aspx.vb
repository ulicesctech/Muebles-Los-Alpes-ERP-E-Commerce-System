Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class AscensosPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarEmpleados()
                CargarPuestos()
                CargarAscensos()
            End If
        End Sub

        Private Sub CargarEmpleados()
            Try
                Dim dt As DataTable = EmpleadoService.Listar()
                ddlEmpleado.DataSource = dt
                ddlEmpleado.DataTextField = "em_nombre_completo"
                ddlEmpleado.DataValueField = "em_empleado"
                ddlEmpleado.DataBind()
                ddlEmpleado.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione empleado --", "0"))
            Catch ex As Exception
                lblError.Text = "Error al cargar empleados: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Private Sub CargarPuestos()
            Try
                Dim dt As DataTable = PuestoService.Listar()
                ddlPuesto.DataSource = dt
                ddlPuesto.DataTextField = "pue_nombre"
                ddlPuesto.DataValueField = "pue_puestos"
                ddlPuesto.DataBind()
                ddlPuesto.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione puesto --", "0"))
            Catch ex As Exception
                lblError.Text = "Error al cargar puestos: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Private Sub CargarAscensos()
            Try
                gvAscensos.DataSource = AscensoService.Listar()
                gvAscensos.DataBind()
                lblMensaje.Visible = False
                lblError.Visible = False
            Catch ex As Exception
                lblError.Text = "Error al cargar: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If ddlEmpleado.SelectedValue = "0" OrElse
               ddlPuesto.SelectedValue = "0" OrElse
               String.IsNullOrWhiteSpace(txtFechaInicio.Text) Then
                lblError.Text = "⚠️ Empleado, puesto y fecha inicio son obligatorios."
                lblError.Visible = True
                Return
            End If

            Dim fechaInicio As Date
            If Not Date.TryParse(txtFechaInicio.Text, fechaInicio) Then
                lblError.Text = "⚠️ Fecha inicio no válida."
                lblError.Visible = True
                Return
            End If

            Dim fechaFinal As Date? = Nothing
            If Not String.IsNullOrWhiteSpace(txtFechaFinal.Text) Then
                Dim fd As Date
                If Not Date.TryParse(txtFechaFinal.Text, fd) Then
                    lblError.Text = "⚠️ Fecha final no válida."
                    lblError.Visible = True
                    Return
                End If
                If fd < fechaInicio Then
                    lblError.Text = "⚠️ Fecha final no puede ser menor a fecha inicio."
                    lblError.Visible = True
                    Return
                End If
                fechaFinal = fd
            End If

            Try
                If hfId.Value <> "" AndAlso hfMode.Value = "editar" Then
                    ' Solo actualiza fecha final
                    If fechaFinal.HasValue Then
                        AscensoService.ActualizarFechaFinal(
                            Convert.ToInt32(hfId.Value), fechaFinal.Value)
                        lblMensaje.Text = "✅ Fecha final actualizada correctamente."
                    Else
                        lblError.Text = "⚠️ Al editar solo se puede actualizar la fecha final."
                        lblError.Visible = True
                        Return
                    End If
                Else
                    Dim nuevoId As Integer = AscensoService.Crear(
                        Convert.ToInt32(ddlPuesto.SelectedValue),
                        Convert.ToInt32(ddlEmpleado.SelectedValue),
                        fechaInicio,
                        fechaFinal)
                    lblMensaje.Text = "✅ Ascenso creado con ID: " & nuevoId
                End If
                lblMensaje.Visible = True
                lblError.Visible = False
                LimpiarFormulario()
                CargarAscensos()
            Catch ex As Exception
                lblError.Text = "Error: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub btnNuevo_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            lblMensaje.Visible = False
            lblError.Visible = False
        End Sub

        Protected Sub gvAscensos_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Try
                    Dim dt As DataTable = AscensoService.Buscar(id)
                    If dt.Rows.Count > 0 Then
                        Dim row = dt.Rows(0)
                        hfId.Value = id.ToString()
                        hfMode.Value = "editar"
                        ddlEmpleado.SelectedValue = row("em_empleado").ToString()
                        ddlPuesto.SelectedValue = row("pue_puestos").ToString()
                        txtFechaInicio.Text = Convert.ToDateTime(row("asc_fecha_inicio")).ToString("yyyy-MM-dd")
                        If Not IsDBNull(row("asc_fecha_final")) Then
                            txtFechaFinal.Text = Convert.ToDateTime(row("asc_fecha_final")).ToString("yyyy-MM-dd")
                        End If
                    End If
                    lblMensaje.Text = "✏️ Editando ascenso ID: " & id & " — solo puede modificar la fecha final."
                    lblMensaje.Visible = True
                Catch ex As Exception
                    lblError.Text = "Error al cargar: " & ex.Message
                    lblError.Visible = True
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    AscensoService.Eliminar(id)
                    lblMensaje.Text = "🗑️ Ascenso ID " & id & " eliminado."
                    lblMensaje.Visible = True
                    CargarAscensos()
                Catch ex As Exception
                    lblError.Text = "Error al eliminar: " & ex.Message
                    lblError.Visible = True
                End Try
            End If

            CargarAscensos()
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = ""
            hfMode.Value = "crear"
            If ddlEmpleado.Items.Count > 0 Then ddlEmpleado.SelectedIndex = 0
            If ddlPuesto.Items.Count > 0 Then ddlPuesto.SelectedIndex = 0
            txtFechaInicio.Text = ""
            txtFechaFinal.Text = ""
        End Sub

    End Class
End Namespace