Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class AuthClienteService

    Public Shared Function Autenticar(usuario As String, password As String) As Integer
        ' Retorna cli_cliente si OK, lanza excepcion si credenciales incorrectas
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_usuario", OracleDbType.Varchar2, usuario, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input),
            New OracleParameter("p_id_cliente", OracleDbType.Decimal, Nothing, ParameterDirection.Output)
        }
        OracleDb.ExecNonQuery("PKG_ADMIN_LOGIN_CLIENTE.LOGC_AUTENTICAR", ps)
        Return Convert.ToInt32(ps(2).Value.ToString())
    End Function
    Public Shared Function AutenticarPorEmail(email As String, password As String) As Integer
        Try
            ' Buscar el usuario asociado al email
            Dim dt As DataTable = OracleDb.ExecRefCursor(
            "PKG_CLI_CLIENTE.CLI_BUSCAR",
            New List(Of OracleParameter) From {
                New OracleParameter("p_texto", OracleDbType.Varchar2, email, ParameterDirection.Input)
            }, "p_data")

            For Each row As DataRow In dt.Rows
                If row("CLI_EMAIL").ToString().ToLower() = email.ToLower() Then
                    Dim clienteId As Integer = Convert.ToInt32(row("CLI_CLIENTE"))
                    ' Buscar usuario en ADMIN_LOGIN_CLIENTE
                    Using conn As New OracleConnection(
                    System.Configuration.ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
                        Using cmd As New OracleCommand(
                            "SELECT logcli_usuario FROM ADMIN_LOGIN_CLIENTE WHERE cli_cliente = :id", conn)
                            cmd.Parameters.Add(New OracleParameter("id", clienteId))
                            conn.Open()
                            Dim usuario As Object = cmd.ExecuteScalar()
                            If usuario IsNot Nothing AndAlso usuario IsNot DBNull.Value Then
                                Return Autenticar(usuario.ToString(), password)
                            End If
                        End Using
                    End Using
                End If
            Next
        Catch
        End Try
        Return 0
    End Function
    Public Shared Function RegistrarCliente(
        tipodoc As String, numdoc As String,
        pNom As String, sNom As String,
        pApe As String, sApe As String,
        pais As String, dep As String, mun As String,
        zona As String, dir As String, cp As String,
        tel1 As String, tel2 As String,
        email As String, prof As String,
        tipocli As String) As Integer

        ' 1. Crear cliente → obtiene ID
        Dim psCliente As New List(Of OracleParameter) From {
            New OracleParameter("p_tipodoc", OracleDbType.Varchar2, tipodoc, ParameterDirection.Input),
            New OracleParameter("p_numdoc", OracleDbType.Varchar2, numdoc, ParameterDirection.Input),
            New OracleParameter("p_p_nom", OracleDbType.Varchar2, pNom, ParameterDirection.Input),
            New OracleParameter("p_s_nom", OracleDbType.Varchar2, sNom, ParameterDirection.Input),
            New OracleParameter("p_p_ape", OracleDbType.Varchar2, pApe, ParameterDirection.Input),
            New OracleParameter("p_s_ape", OracleDbType.Varchar2, sApe, ParameterDirection.Input),
            New OracleParameter("p_pais", OracleDbType.Varchar2, pais, ParameterDirection.Input),
            New OracleParameter("p_dep", OracleDbType.Varchar2, dep, ParameterDirection.Input),
            New OracleParameter("p_mun", OracleDbType.Varchar2, mun, ParameterDirection.Input),
            New OracleParameter("p_zona", OracleDbType.Varchar2, zona, ParameterDirection.Input),
            New OracleParameter("p_dir", OracleDbType.Varchar2, dir, ParameterDirection.Input),
            New OracleParameter("p_cp", OracleDbType.Varchar2, cp, ParameterDirection.Input),
            New OracleParameter("p_tel1", OracleDbType.Varchar2, tel1, ParameterDirection.Input),
            New OracleParameter("p_tel2", OracleDbType.Varchar2, tel2, ParameterDirection.Input),
            New OracleParameter("p_email", OracleDbType.Varchar2, email, ParameterDirection.Input),
            New OracleParameter("p_prof", OracleDbType.Varchar2, prof, ParameterDirection.Input),
            New OracleParameter("p_tipocli", OracleDbType.Varchar2, tipocli, ParameterDirection.Input),
            New OracleParameter("p_id", OracleDbType.Decimal, Nothing, ParameterDirection.Output)
        }
        OracleDb.ExecNonQuery("PKG_CLI_CLIENTE.CLI_CREAR", psCliente)
        Dim clienteId As Integer = Convert.ToInt32(psCliente(17).Value.ToString())
        Return clienteId
    End Function

    Public Shared Sub CrearLogin(clienteId As Integer, usuario As String, password As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id_cliente", OracleDbType.Decimal, clienteId, ParameterDirection.Input),
            New OracleParameter("p_usuario", OracleDbType.Varchar2, usuario, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery("PKG_ADMIN_LOGIN_CLIENTE.LOGC_CREAR", ps)
    End Sub

    Public Shared Sub ObtenerDatosCliente(clienteId As Integer, ByRef nombre As String, ByRef email As String)
        Dim dt As DataTable = OracleDb.ExecRefCursor(
            "PKG_CLI_CLIENTE.CLI_BUSCAR",
            New List(Of OracleParameter) From {
                New OracleParameter("p_texto", OracleDbType.Varchar2, "", ParameterDirection.Input)
            }, "p_data")
        ' Buscar por ID en el resultado
        For Each row As DataRow In dt.Rows
            If Convert.ToInt32(row("CLI_CLIENTE")) = clienteId Then
                nombre = row("CLI_PRIMER_NOMBRE").ToString() & " " & row("CLI_PRIMER_APELLIDO").ToString()
                email = row("CLI_EMAIL").ToString()
                Return
            End If
        Next
    End Sub

End Class