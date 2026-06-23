Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class LoginClienteService
    Private Const PKG As String = "PKG_ADMIN_LOGIN_CLIENTE"

    Public Shared Function Validar(usuario As String, password As String) As LoginClienteResult
        Dim result As New LoginClienteResult()
        Dim pIdCliente As New OracleParameter("p_id_cliente", OracleDbType.Decimal, ParameterDirection.Output)

        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_usuario", OracleDbType.Varchar2, usuario, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input),
            pIdCliente
        }
        OracleDb.ExecNonQuery(PKG & ".logc_autenticar", ps)
        Try
            Dim val As String = pIdCliente.Value.ToString()
            If Not String.IsNullOrEmpty(val) AndAlso val <> "null" Then
                result.Resultado = 1
                result.ClienteId = Convert.ToInt32(val)
            Else
                result.Resultado = 0
            End If
        Catch
            result.Resultado = 0
        End Try
        Return result
    End Function

    Public Shared Sub Crear(cliId As Integer, usuario As String, password As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id_cliente", OracleDbType.Decimal, cliId, ParameterDirection.Input),
            New OracleParameter("p_usuario", OracleDbType.Varchar2, usuario, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".logc_crear", ps)
    End Sub

    Public Shared Sub ActualizarPassword(cliId As Integer, password As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id_cliente", OracleDbType.Decimal, cliId, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".logc_actualizar_pwd", ps)
    End Sub

    Public Shared Sub Eliminar(cliId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id_cliente", OracleDbType.Decimal, cliId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".logc_eliminar", ps)
    End Sub
End Class

Public Class LoginClienteResult
    Public Property Resultado As Integer
    Public Property ClienteId As Integer
End Class