Imports System
Imports System.Data

Namespace MueblesAlpes.Web.Modules.AuthUsuarios

    Partial Public Class AscensosPage
        Inherits BasePage

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarEmpleados()
                CargarAscensos()
            End If
        End Sub

        Private Sub CargarEmpleados()
            Try
                Dim dt As DataTable = EmpleadoService.Listar()
                ddlEmpleado.DataSource = dt
                ddlEmpleado.DataTextField = "em_primer_nombre"
                ddlEmpleado.DataValueField = "em_empleado"
                ddlEmpleado.DataBind()
                ddlEmpleado.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione empleado --", "0"))
                ddlPuesto.Items.Clear()
                ddlPuesto.Items.Add(New System.Web.UI.WebControls.ListItem("-- Seleccione empleado primero --", "0"))
            Catch ex As Exception
                lblError.Text = "Error al cargar empleados: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

        Protected Sub ddlEmpleado_SelectedIndexChanged(sender As Object, e As EventArgs)
            ddlPuesto.Items.Clear()
            pnlPuestoActual.Visible = False
            pnlSinPuestos.Visible = False

            If ddlEmpleado.SelectedValue = "0" Then
                ddlPuesto.Items.Add(New System.Web.UI.WebControls.ListItem("-- Seleccione empleado primero --", "0"))
                Return
            End If

            Try
                Dim empId As Integer = Convert.ToInt32(ddlEmpleado.SelectedValue)

                ' Obtener puesto actual del empleado (ascenso activo)
                Dim dtAsc As DataTable = AscensoService.ListarPorEmpleado(empId)
                Dim salarioActual As Decimal = 0
                Dim puestoActualNombre As String = "Sin puesto asignado"

                ' Buscar el ascenso activo (sin fecha final)
                For Each row As DataRow In dtAsc.Rows
                    If IsDBNull(row("asc_fecha_final")) Then
                        puestoActualNombre = row("pue_nombre").ToString()
                        ' Obtener salario del puesto actual
                        Dim dtPuestoActual As DataTable = PuestoService.Buscar(Convert.ToInt32(row("pue_puestos")))
                        If dtPuestoActual.Rows.Count > 0 Then
                            salarioActual = Convert.ToDecimal(dtPuestoActual.Rows(0)("pue_salario"))
                        End If
                        Exit For
                    End If
                Next

                ' Mostrar info del puesto actual
                litPuestoActual.Text = puestoActualNombre
                litSalarioActual.Text = String.Format("{0:N2}", salarioActual)
                pnlPuestoActual.Visible = True

                ' Cargar solo puestos con salario mayor al actual
                Dim dtTodos As DataTable = PuestoService.Listar()
                Dim superiores As Integer = 0

                ddlPuesto.Items.Add(New System.Web.UI.WebControls.ListItem("-- Seleccione puesto --", "0"))

                For Each row As DataRow In dtTodos.Rows
                    Dim sal As Decimal = Convert.ToDecimal(row("pue_salario"))
                    If sal > salarioActual Then
                        ddlPuesto.Items.Add(New System.Web.UI.WebControls.ListItem(
                            row("pue_nombre").ToString() & " (Q " & String.Format("{0:N2}", sal) & ")",
                            row("pue_puestos").ToString()))
                        superiores += 1
                    End If
                Next

                If superiores = 0 Then
                    ddlPuesto.Items.Clear()
                    pnlSinPuestos.Visible = True
                End If

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
            If ddlEmpleado.SelectedValue = "0" Then
                lblError.Text = "⚠️ Seleccione un empleado."
                lblError.Visible = True
                Return
            End If
            If ddlPuesto.Items.Count = 0 OrElse ddlPuesto.SelectedValue = "0" Then
                lblError.Text = "⚠️ Seleccione un puesto de ascenso."
                lblError.Visible = True
                Return
            End If

            Try
                Dim empId As Integer = Convert.ToInt32(ddlEmpleado.SelectedValue)
                Dim puestoId As Integer = Convert.ToInt32(ddlPuesto.SelectedValue)

                AscensoService.Crear(puestoId, empId, Date.Today, Nothing)

                lblMensaje.Text = "✅ Ascenso aplicado correctamente."
                lblMensaje.Visible = True
                lblError.Visible = False
                LimpiarFormulario()
                CargarEmpleados()
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

            If e.CommandName = "Cerrar" Then
                Try
                    AscensoService.ActualizarFechaFinal(id, Date.Today)
                    lblMensaje.Text = "🔒 Ascenso ID " & id & " cerrado."
                    lblMensaje.Visible = True
                    CargarAscensos()
                Catch ex As Exception
                    lblError.Text = "Error: " & ex.Message
                    lblError.Visible = True
                End Try

            ElseIf e.CommandName = "Eliminar" Then
                Try
                    AscensoService.Eliminar(id)
                    lblMensaje.Text = "🗑️ Ascenso ID " & id & " eliminado."
                    lblMensaje.Visible = True
                    CargarAscensos()
                Catch ex As Exception
                    lblError.Text = "Error: " & ex.Message
                    lblError.Visible = True
                End Try
            End If

            CargarAscensos()
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = ""
            hfMode.Value = "crear"
            If ddlEmpleado.Items.Count > 0 Then ddlEmpleado.SelectedIndex = 0
            ddlPuesto.Items.Clear()
            ddlPuesto.Items.Add(New System.Web.UI.WebControls.ListItem("-- Seleccione empleado primero --", "0"))
            pnlPuestoActual.Visible = False
            pnlSinPuestos.Visible = False
        End Sub

    End Class
End Namespace