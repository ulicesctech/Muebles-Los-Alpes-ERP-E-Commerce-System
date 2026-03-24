Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/CategoriaService.vb
' ============================================================
Public Class CategoriaService

    Private Const PKG As String = "PKG_BOD_CATEGORIA"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Buscar(texto As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_texto", OracleDbType.Varchar2, If(texto, ""), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".BUSCAR", ps, "p_data")
    End Function

    Public Shared Function Crear(descripcion As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CREAR", ps, "p_id")
    End Function

    Public Shared Sub Actualizar(id As Decimal, descripcion As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input)
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