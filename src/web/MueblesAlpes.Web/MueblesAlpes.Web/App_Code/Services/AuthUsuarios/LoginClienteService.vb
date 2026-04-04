Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class LoginClienteService
    Private Const PKG As String = "PKG_ADMIN_LOGIN_CLIENTE"

    Public Shared Function Validar(usuario As String, password As String) As LoginClienteResult
        Dim result As New LoginClienteResult()
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_usuario", OracleDbType.Varchar2, usuario, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input),
            New OracleParameter("p_resultado", OracleDbType.Decimal, ParameterDirection.Output),
            New OracleParameter("p_cli_cliente", OracleDbType.Decimal, ParameterDirection.Output)
        }
        OracleDb.ExecNonQuery(PKG & ".log_cli_validar", ps)
        result.Resultado = Convert.ToInt32(ps(2).Value.ToString())
        If result.Resultado = 1 Then
            result.ClienteId = Convert.ToInt32(ps(3).Value.ToString())
        End If
        Return result
    End Function

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".log_cli_listar", Nothing, "p_cursor")
    End Function

    Public Shared Sub ActualizarPassword(cliId As Integer, password As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_cli_cliente", OracleDbType.Decimal, cliId, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".log_cli_actualizar_pass", ps)
    End Sub

    Public Shared Sub Eliminar(cliId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_cli_cliente", OracleDbType.Decimal, cliId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".log_cli_eliminar", ps)
    End Sub
End Class

Public Class LoginClienteResult
    Public Property Resultado As Integer
    Public Property ClienteId As Integer
End Class