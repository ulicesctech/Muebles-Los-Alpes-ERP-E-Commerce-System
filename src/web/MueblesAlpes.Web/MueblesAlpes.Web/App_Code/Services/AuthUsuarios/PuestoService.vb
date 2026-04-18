Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class PuestoService
    Private Const PKG As String = "PKG_RH_PUESTO"

    Public Shared Function Crear(nombre As String, salario As Decimal, descripcion As String) As Integer
        Dim pId As New OracleParameter("p_nuevo_id", OracleDbType.Decimal, ParameterDirection.Output)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pue_nombre", OracleDbType.Varchar2, nombre, ParameterDirection.Input),
            New OracleParameter("p_pue_salario", OracleDbType.Decimal, salario, ParameterDirection.Input),
            New OracleParameter("p_pue_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input),
            pId
        }
        OracleDb.ExecNonQuery(PKG & ".pue_crear", ps)
        Return Convert.ToInt32(pId.Value.ToString())
    End Function

    Public Shared Sub Actualizar(id As Integer, nombre As String, salario As Decimal, descripcion As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pue_puestos", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_pue_nombre", OracleDbType.Varchar2, nombre, ParameterDirection.Input),
            New OracleParameter("p_pue_salario", OracleDbType.Decimal, salario, ParameterDirection.Input),
            New OracleParameter("p_pue_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".pue_actualizar", ps)
    End Sub

    Public Shared Sub Eliminar(id As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pue_puestos", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".pue_eliminar", ps)
    End Sub

    Public Shared Function Listar() As DataTable
        Dim pPuesto As New OracleParameter("p_pue_puestos", OracleDbType.Decimal, ParameterDirection.Input)
        pPuesto.Value = DBNull.Value
        Dim ps As New List(Of OracleParameter) From {pPuesto}
        Return OracleDb.ExecRefCursor(PKG & ".pue_listar", ps, "p_data")
    End Function

    Public Shared Function Buscar(id As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pue_puestos", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".pue_obtener", ps, "p_data")
    End Function
End Class