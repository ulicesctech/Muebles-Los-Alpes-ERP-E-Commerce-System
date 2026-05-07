Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class CatalogoClienteService

    Private Const PKG As String = "PKG_CLI_CATALOGO"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function ListarPorCategoria(categoria As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_categoria", OracleDbType.Decimal, categoria, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_CATEGORIA", ps, "p_data")
    End Function

    Public Shared Function Buscar(texto As String, categoria As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_texto", OracleDbType.Varchar2, If(texto, ""), ParameterDirection.Input),
            New OracleParameter("p_categoria", OracleDbType.Decimal, categoria, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".BUSCAR", ps, "p_data")
    End Function

    Public Shared Function ListarCategorias() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_CATEGORIAS", Nothing, "p_data")
    End Function

    Public Shared Function ListarPromociones() As DataTable
        Return OracleDb.ExecRefCursor("PKG_CLI_CATALOGO.LISTAR_PROMOCIONES", Nothing, "p_data")
    End Function

End Class