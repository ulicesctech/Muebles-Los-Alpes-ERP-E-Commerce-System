Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class AscensoService
    Private Const PKG As String = "PKG_RH_ASCENSO"

    Public Shared Function Crear(puestoId As Integer, empleadoId As Integer,
                                  fechaInicio As Date, fechaFinal As Date?) As Integer
        Dim pId As New OracleParameter("p_id", OracleDbType.Decimal, ParameterDirection.Output)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pue_puestos", OracleDbType.Decimal, puestoId, ParameterDirection.Input),
            New OracleParameter("p_em_empleado", OracleDbType.Decimal, empleadoId, ParameterDirection.Input),
            New OracleParameter("p_fecha_inicio", OracleDbType.Date, fechaInicio, ParameterDirection.Input),
            New OracleParameter("p_fecha_final", OracleDbType.Date, If(fechaFinal.HasValue, CObj(fechaFinal.Value), DBNull.Value), ParameterDirection.Input),
            pId
        }
        OracleDb.ExecNonQuery(PKG & ".asc_crear", ps)
        Return Convert.ToInt32(pId.Value.ToString())
    End Function

    Public Shared Sub ActualizarFechaFinal(id As Integer, fechaFinal As Date)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_fecha_final", OracleDbType.Date, fechaFinal, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".asc_actualizar_fecha_final", ps)
    End Sub

    Public Shared Sub Eliminar(id As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".asc_eliminar", ps)
    End Sub

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".asc_listar", Nothing, "p_cursor")
    End Function

    Public Shared Function ListarPorEmpleado(empleadoId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_em_empleado", OracleDbType.Decimal, empleadoId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".asc_listar_por_empleado", ps, "p_cursor")
    End Function

    Public Shared Function Buscar(id As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".asc_buscar", ps, "p_cursor")
    End Function
End Class