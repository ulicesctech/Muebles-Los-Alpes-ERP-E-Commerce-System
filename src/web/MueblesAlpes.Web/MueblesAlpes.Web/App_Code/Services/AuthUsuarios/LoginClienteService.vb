Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class LoginClienteService
    Private Const PKG As String = "PKG_ADMIN_LOGIN_CLIENTE"

    Public Shared Function Validar(usuario As String, password As String, plataforma As Integer) As LoginClienteResult
        Dim result As New LoginClienteResult()
        Dim pIdCliente As New OracleParameter("p_id_cliente", OracleDbType.Decimal, ParameterDirection.Output)

        Dim valorPlataforma As Integer = 1 ' Valor por defecto
        If plataforma = 2 Then
            valorPlataforma = 2
        ElseIf plataforma = 1 Then
            valorPlataforma = 1
        End If
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_usuario", OracleDbType.Varchar2, usuario, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input),
            New OracleParameter("p_plataforma", OracleDbType.Int32, valorPlataforma, ParameterDirection.Input),
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

    Public Shared Sub Crear(cliId As Integer, usuario As String, password As String, cam_campana As Integer, canal_registro As Integer)

        Dim valorCanal As Integer = 1 ' Valor por defecto
        If canal_registro = 2 Then
            valorCanal = 2
        ElseIf canal_registro = 1 Then
            valorCanal = 1
        End If
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id_cliente", OracleDbType.Decimal, cliId, ParameterDirection.Input),
            New OracleParameter("p_usuario", OracleDbType.Varchar2, usuario, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input),
            New OracleParameter("p_cam_campana", OracleDbType.Int32, cam_campana, ParameterDirection.Input),
            New OracleParameter("p_can_canal_reg", OracleDbType.Int32, valorCanal, ParameterDirection.Input)
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