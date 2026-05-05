Imports Oracle.ManagedDataAccess.Client
Imports System.Data

' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/AlmacenService.vb
' ============================================================
Public Class AlmacenService

    Private Const PKG As String = "PKG_BOD_ALMACEN"

    Public Shared Function Listar() As DataTable
        ' Retorna: ALM_ALMACEN, ALM_NOMBRE, ALM_PAIS, ALM_UBICACION
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Crear(nombre As String, pais As String, ubicacion As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_nombre", OracleDbType.Varchar2, nombre, ParameterDirection.Input),
            New OracleParameter("p_pais", OracleDbType.Varchar2, pais, ParameterDirection.Input),
            New OracleParameter("p_ubicacion", OracleDbType.Varchar2, ubicacion, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CREAR", ps, "p_id")
    End Function

    Public Shared Sub Actualizar(id As Decimal, nombre As String, pais As String, ubicacion As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_nombre", OracleDbType.Varchar2, nombre, ParameterDirection.Input),
            New OracleParameter("p_pais", OracleDbType.Varchar2, pais, ParameterDirection.Input),
            New OracleParameter("p_ubicacion", OracleDbType.Varchar2, ubicacion, ParameterDirection.Input)
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