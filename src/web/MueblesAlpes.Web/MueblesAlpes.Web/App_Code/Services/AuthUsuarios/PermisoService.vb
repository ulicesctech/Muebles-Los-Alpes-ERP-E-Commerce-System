Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class PermisoService
    Private Const PKG As String = "PKG_ADMIN_PERMISOS"

    Public Shared Function Crear(admin As Integer, rh As Integer, fac As Integer,
                                  cli As Integer, bod As Integer, promo As Integer) As Integer
        Dim pId As New OracleParameter("p_id", OracleDbType.Decimal, ParameterDirection.Output)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_admin", OracleDbType.Decimal, admin, ParameterDirection.Input),
            New OracleParameter("p_rh", OracleDbType.Decimal, rh, ParameterDirection.Input),
            New OracleParameter("p_fac", OracleDbType.Decimal, fac, ParameterDirection.Input),
            New OracleParameter("p_cli", OracleDbType.Decimal, cli, ParameterDirection.Input),
            New OracleParameter("p_bod", OracleDbType.Decimal, bod, ParameterDirection.Input),
            New OracleParameter("p_promo", OracleDbType.Decimal, promo, ParameterDirection.Input),
            pId
        }
        OracleDb.ExecNonQuery(PKG & ".per_crear", ps)
        Return Convert.ToInt32(pId.Value.ToString())
    End Function

    Public Shared Sub Actualizar(id As Integer, admin As Integer, rh As Integer,
                                  fac As Integer, cli As Integer, bod As Integer, promo As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_admin", OracleDbType.Decimal, admin, ParameterDirection.Input),
            New OracleParameter("p_rh", OracleDbType.Decimal, rh, ParameterDirection.Input),
            New OracleParameter("p_fac", OracleDbType.Decimal, fac, ParameterDirection.Input),
            New OracleParameter("p_cli", OracleDbType.Decimal, cli, ParameterDirection.Input),
            New OracleParameter("p_bod", OracleDbType.Decimal, bod, ParameterDirection.Input),
            New OracleParameter("p_promo", OracleDbType.Decimal, promo, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".per_actualizar", ps)
    End Sub

    Public Shared Sub Eliminar(id As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".per_eliminar", ps)
    End Sub

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".per_listar", Nothing, "p_cursor")
    End Function
End Class