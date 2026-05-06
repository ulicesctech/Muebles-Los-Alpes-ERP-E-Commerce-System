Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class GrupoUsuarioService
    Private Const PKG As String = "PKG_ADMIN_GRUPO_USUARIO"

    Public Shared Function Crear(descripcion As String, permisos As Integer) As Integer
        Dim pId As New OracleParameter("p_id", OracleDbType.Decimal, ParameterDirection.Output)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input),
            New OracleParameter("p_permisos", OracleDbType.Decimal, permisos, ParameterDirection.Input),
            pId
        }
        OracleDb.ExecNonQuery(PKG & ".gru_crear", ps)
        Return Convert.ToInt32(pId.Value.ToString())
    End Function

    Public Shared Sub Actualizar(id As Integer, descripcion As String, permisos As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input),
            New OracleParameter("p_permisos", OracleDbType.Decimal, permisos, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".gru_actualizar", ps)
    End Sub

    Public Shared Sub Eliminar(id As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".gru_eliminar", ps)
    End Sub

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".gru_listar", Nothing, "p_cursor")
    End Function

    Public Shared Function Buscar(id As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".gru_buscar", ps, "p_cursor")
    End Function
End Class