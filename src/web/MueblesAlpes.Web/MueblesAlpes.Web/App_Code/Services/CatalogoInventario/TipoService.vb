Imports Oracle.ManagedDataAccess.Client
Imports System.Data

' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/TipoService.vb
' ============================================================
Public Class TipoService

    Private Const PKG As String = "PKG_BOD_TIPO"

    Public Shared Function Listar() As DataTable
        ' Retorna: TIP_TIPO, TIP_DESCRIPCION, CAT_CATEGORIA, CATEGORIA
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function ListarPorCategoria(catId As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_cat_categoria", OracleDbType.Decimal, catId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_CATEGORIA", ps, "p_data")
    End Function

    Public Shared Function Crear(descripcion As String, catCategoria As Decimal) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input),
            New OracleParameter("p_cat_categoria", OracleDbType.Decimal, catCategoria, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CREAR", ps, "p_id")
    End Function

    Public Shared Sub Actualizar(id As Decimal, descripcion As String, catCategoria As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input),
            New OracleParameter("p_cat_categoria", OracleDbType.Decimal, catCategoria, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ACTUALIZAR", ps)
    End Sub

    Public Shared Sub Eliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ELIMINAR", ps)
    End Sub

End Class