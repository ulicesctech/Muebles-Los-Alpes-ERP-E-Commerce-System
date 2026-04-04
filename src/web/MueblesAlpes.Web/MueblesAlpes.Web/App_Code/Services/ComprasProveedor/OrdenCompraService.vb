Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class OrdenCompraService
    Private Const PKG As String = "PKG_CP_BOD_ORDEN_COMPRA"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".ORC_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Sub Crear(codigo As String, proveedorId As Decimal, total As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, "", ParameterDirection.Input),
            New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
            New OracleParameter("p_prov_id", OracleDbType.Decimal, proveedorId, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ORC_CREAR", ps)
    End Sub

    Public Shared Sub Actualizar(orcKey As String, codigo As String, proveedorId As Decimal, total As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input),
            New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
            New OracleParameter("p_prov_id", OracleDbType.Decimal, proveedorId, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ORC_ACTUALIZAR", ps)
    End Sub

    Public Shared Sub Eliminar(orcKey As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ORC_ELIMINAR", ps)
    End Sub

    Public Shared Function Buscar(codigo As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_codigo", OracleDbType.Varchar2, If(codigo, ""), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ORC_BUSCAR", ps, "p_data")
    End Function
End Class