Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class AscensoService
    Private Const PKG As String = "PKG_RH_ASCENSO"

    Public Shared Function Crear(puestoId As Integer, empleadoId As Integer,
                                  fechaInicio As Date, fechaFinal As Date?) As Integer
        Dim pId As New OracleParameter("p_id", OracleDbType.Decimal, ParameterDirection.Output)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id_puesto", OracleDbType.Decimal, puestoId, ParameterDirection.Input),
            New OracleParameter("p_id_empleado", OracleDbType.Decimal, empleadoId, ParameterDirection.Input),
            pId
        }
        OracleDb.ExecNonQuery(PKG & ".ascen_crear", ps)
        Return Convert.ToInt32(pId.Value.ToString())
    End Function

    Public Shared Sub ActualizarFechaFinal(id As Integer, fechaFinal As Date)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id_ascenso", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ascen_cerrar", ps)
    End Sub

    Public Shared Sub Eliminar(id As Integer)
        Dim ps As New List(Of OracleParameter) From {
        New OracleParameter("p_id_ascenso", OracleDbType.Decimal, id, ParameterDirection.Input)
    }
        OracleDb.ExecNonQuery(PKG & ".ascen_eliminar", ps)
    End Sub

    Public Shared Function Listar() As DataTable
        Dim dtEmp As DataTable = EmpleadoService.Listar()
        Dim result As New DataTable()
        result.Columns.Add("asc_ascenso")
        result.Columns.Add("em_empleado")
        result.Columns.Add("em_nombre_completo")
        result.Columns.Add("pue_puestos")
        result.Columns.Add("pue_nombre")
        result.Columns.Add("asc_fecha_inicio", GetType(Object))
        result.Columns.Add("asc_fecha_final", GetType(Object))

        For Each rowEmp As DataRow In dtEmp.Rows
            Dim empId As Integer = Convert.ToInt32(rowEmp("em_empleado"))
            Dim nombre As String = rowEmp("em_primer_nombre").ToString().Trim() & " " &
                               rowEmp("em_primer_apellido").ToString().Trim()
            Try
                Dim dtAsc As DataTable = ListarPorEmpleado(empId)
                For Each rowAsc As DataRow In dtAsc.Rows
                    Dim newRow = result.NewRow()
                    newRow("asc_ascenso") = rowAsc("asc_ascenso")
                    newRow("em_empleado") = empId
                    newRow("em_nombre_completo") = nombre
                    newRow("pue_puestos") = rowAsc("pue_puestos")
                    newRow("pue_nombre") = rowAsc("pue_nombre")
                    newRow("asc_fecha_inicio") = rowAsc("asc_fecha_inicio")
                    newRow("asc_fecha_final") = If(IsDBNull(rowAsc("asc_fecha_final")), DBNull.Value, rowAsc("asc_fecha_final"))
                    result.Rows.Add(newRow)
                Next
            Catch
            End Try
        Next
        Return result
    End Function

    Public Shared Function ListarPorEmpleado(empleadoId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id_empleado", OracleDbType.Decimal, empleadoId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ascen_listar_por_emp", ps, "p_data")
    End Function

    Public Shared Function Buscar(id As Integer) As DataTable
        Dim dt As DataTable = Listar()
        Dim result As DataTable = dt.Clone()
        For Each row As DataRow In dt.Rows
            If Convert.ToInt32(row("asc_ascenso")) = id Then
                result.ImportRow(row)
            End If
        Next
        Return result
    End Function
End Class