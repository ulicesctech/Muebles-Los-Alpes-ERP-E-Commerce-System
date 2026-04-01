Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: App_Code/Services/ComprasProveedor/ProveedorService.vb
' ============================================================
Public Class ProveedorService

    Private Const PKG As String = "PKG_CP_BOD_PROVEEDOR"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".PROV_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Buscar(texto As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_texto", OracleDbType.Varchar2, If(texto, ""), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".PROV_BUSCAR", ps, "p_data")
    End Function

    Public Shared Function Crear(nit As String, nombre As String, avenida As String,
                                  zona As String, direccion As String, telefono As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_nit",       OracleDbType.Varchar2, nit,       ParameterDirection.Input),
            New OracleParameter("p_nombre",    OracleDbType.Varchar2, nombre,    ParameterDirection.Input),
            New OracleParameter("p_avenida",   OracleDbType.Varchar2, avenida,   ParameterDirection.Input),
            New OracleParameter("p_zona",      OracleDbType.Varchar2, zona,      ParameterDirection.Input),
            New OracleParameter("p_direccion", OracleDbType.Varchar2, direccion, ParameterDirection.Input),
            New OracleParameter("p_telefono",  OracleDbType.Varchar2, telefono,  ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".PROV_CREAR", ps, "p_id")
    End Function

    Public Shared Sub Actualizar(id As Decimal, nit As String, nombre As String, avenida As String,
                                  zona As String, direccion As String, telefono As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id",        OracleDbType.Decimal,  id,        ParameterDirection.Input),
            New OracleParameter("p_nit",       OracleDbType.Varchar2, nit,       ParameterDirection.Input),
            New OracleParameter("p_nombre",    OracleDbType.Varchar2, nombre,    ParameterDirection.Input),
            New OracleParameter("p_avenida",   OracleDbType.Varchar2, avenida,   ParameterDirection.Input),
            New OracleParameter("p_zona",      OracleDbType.Varchar2, zona,      ParameterDirection.Input),
            New OracleParameter("p_direccion", OracleDbType.Varchar2, direccion, ParameterDirection.Input),
            New OracleParameter("p_telefono",  OracleDbType.Varchar2, telefono,  ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".PROV_ACTUALIZAR", ps)
    End Sub

    Public Shared Sub Eliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".PROV_ELIMINAR", ps)
    End Sub

End Class
