Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public NotInheritable Class OracleDb

    Private Sub New()
    End Sub

    Private Shared Function GetConnection() As OracleConnection
        Dim cs As String = ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString
        Return New OracleConnection(cs)
    End Function

    Public Shared Function ExecRefCursor(spName As String,
                                         params As IEnumerable(Of OracleParameter),
                                         outCursorParamName As String) As DataTable
        Dim dt As New DataTable()

        Using conn As OracleConnection = GetConnection()
            Using cmd As New OracleCommand(spName, conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.BindByName = True

                If params IsNot Nothing Then
                    For Each p In params
                        cmd.Parameters.Add(p)
                    Next
                End If

                cmd.Parameters.Add(New OracleParameter(outCursorParamName, OracleDbType.RefCursor, ParameterDirection.Output))

                conn.Open()
                Using da As New OracleDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        Return dt
    End Function

    Public Shared Sub ExecNonQuery(spName As String,
                                   params As IEnumerable(Of OracleParameter))
        Using conn As OracleConnection = GetConnection()
            Using cmd As New OracleCommand(spName, conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.BindByName = True

                If params IsNot Nothing Then
                    For Each p In params
                        cmd.Parameters.Add(p)
                    Next
                End If

                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Function ExecOutNumber(spName As String,
                                         params As IEnumerable(Of OracleParameter),
                                         outParamName As String) As Decimal
        Using conn As OracleConnection = GetConnection()
            Using cmd As New OracleCommand(spName, conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.BindByName = True

                If params IsNot Nothing Then
                    For Each p In params
                        cmd.Parameters.Add(p)
                    Next
                End If

                Dim pOut As New OracleParameter(outParamName, OracleDbType.Decimal, ParameterDirection.Output)
                cmd.Parameters.Add(pOut)

                conn.Open()
                cmd.ExecuteNonQuery()

                If pOut.Value Is Nothing OrElse pOut.Value Is DBNull.Value Then
                    Return 0D
                End If

                Return Convert.ToDecimal(pOut.Value.ToString())
            End Using
        End Using
    End Function

End Class