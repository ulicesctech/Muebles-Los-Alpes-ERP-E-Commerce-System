Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/NichoService.vb
' ============================================================
Public Class NichoService

    Private Const PKG As String = "PKG_BOD_NICHO"

    Public Shared Function Listar() As DataTable
        ' Retorna: NIC_NICHO, NIC_NUMERO, NIC_ZONA, NIC_CARACTERISTICA
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Crear(numero As String, zona As String, caracteristica As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_numero", OracleDbType.Varchar2, numero, ParameterDirection.Input),
            New OracleParameter("p_zona", OracleDbType.Varchar2, zona, ParameterDirection.Input),
            New OracleParameter("p_caracteristica", OracleDbType.Varchar2, caracteristica, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CREAR", ps, "p_id")
    End Function

    Public Shared Sub Actualizar(id As Decimal, numero As String, zona As String, caracteristica As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_numero", OracleDbType.Varchar2, numero, ParameterDirection.Input),
            New OracleParameter("p_zona", OracleDbType.Varchar2, zona, ParameterDirection.Input),
            New OracleParameter("p_caracteristica", OracleDbType.Varchar2, caracteristica, ParameterDirection.Input)
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