Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class LoginEmpleadoService
    Private Const PKG As String = "PKG_ADMIN_LOGIN_EMPLEADO"

    Public Shared Function Login(usuario As String, password As String) As LoginEmpleadoResult
        Dim result As New LoginEmpleadoResult()
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_usuario", OracleDbType.Varchar2, usuario, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input),
            New OracleParameter("p_em_empleado", OracleDbType.Decimal, 500, ParameterDirection.Output),
            New OracleParameter("p_nombre", OracleDbType.Varchar2, 500, ParameterDirection.Output),
            New OracleParameter("p_grupo", OracleDbType.Varchar2, 255, ParameterDirection.Output),
            New OracleParameter("p_per_admin", OracleDbType.Decimal, ParameterDirection.Output),
            New OracleParameter("p_per_rh", OracleDbType.Decimal, ParameterDirection.Output),
            New OracleParameter("p_per_fac", OracleDbType.Decimal, ParameterDirection.Output),
            New OracleParameter("p_per_cli", OracleDbType.Decimal, ParameterDirection.Output),
            New OracleParameter("p_per_bod", OracleDbType.Decimal, ParameterDirection.Output),
            New OracleParameter("p_per_promo", OracleDbType.Decimal, ParameterDirection.Output),
            New OracleParameter("p_resultado", OracleDbType.Decimal, ParameterDirection.Output)
        }
        OracleDb.ExecNonQuery(PKG & ".log_em_login", ps)

        result.Resultado = Convert.ToInt32(ps(11).Value.ToString())
        If result.Resultado = 1 Then
            result.EmpleadoId = Convert.ToInt32(ps(2).Value.ToString())
            result.Nombre = ps(3).Value.ToString()
            result.Grupo = ps(4).Value.ToString()
            result.PerAdmin = Convert.ToInt32(ps(5).Value.ToString())
            result.PerRH = Convert.ToInt32(ps(6).Value.ToString())
            result.PerFac = Convert.ToInt32(ps(7).Value.ToString())
            result.PerCli = Convert.ToInt32(ps(8).Value.ToString())
            result.PerBod = Convert.ToInt32(ps(9).Value.ToString())
            result.PerPromo = Convert.ToInt32(ps(10).Value.ToString())
        End If
        Return result
    End Function

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".log_em_listar", Nothing, "p_cursor")
    End Function

    Public Shared Sub ActualizarPassword(emId As Integer, password As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_em_empleado", OracleDbType.Decimal, emId, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".log_em_actualizar_pass", ps)
    End Sub

    Public Shared Sub Eliminar(emId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_em_empleado", OracleDbType.Decimal, emId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".log_em_eliminar", ps)
    End Sub
End Class

Public Class LoginEmpleadoResult
    Public Property Resultado As Integer
    Public Property EmpleadoId As Integer
    Public Property Nombre As String
    Public Property Grupo As String
    Public Property PerAdmin As Integer
    Public Property PerRH As Integer
    Public Property PerFac As Integer
    Public Property PerCli As Integer
    Public Property PerBod As Integer
    Public Property PerPromo As Integer
End Class