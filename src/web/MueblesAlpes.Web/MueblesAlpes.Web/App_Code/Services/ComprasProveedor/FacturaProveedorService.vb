Imports Oracle.ManagedDataAccess.Client
Imports System.Data

' ============================================================
' RUTA: App_Code/Services/ComprasProveedor/FacturaProveedorService.vb
' ============================================================
Public Class FacturaProveedorService

    Private Const PKG As String = "PKG_CP_FAC_FACTURA_PROV"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".FAC_PROV_LISTAR", Nothing, "p_data")
    End Function

    ' Cambiado para que coincida con el parámetro p_texto del paquete corregido
    Public Shared Function Buscar(texto As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_texto", OracleDbType.Varchar2, If(texto, ""), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".FAC_PROV_BUSCAR", ps, "p_data")
    End Function

    Public Shared Sub Registrar(orcKey As String, codigoFactura As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input),
            New OracleParameter("p_fac_cod", OracleDbType.Varchar2, codigoFactura, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".FAC_PROV_REGISTRAR", ps)
    End Sub

    ''' <summary>
    ''' Actualiza un registro permitiendo cambiar su clave (Orden de Compra).
    ''' </summary>
    ''' <param name="orcKeyOld">La orden de compra original (llave para el WHERE).</param>
    ''' <param name="orcKeyNew">La nueva orden de compra seleccionada.</param>
    ''' <param name="codigoFactura">El nuevo código de factura.</param>
    Public Shared Sub Actualizar(orcKeyOld As String, orcKeyNew As String, codigoFactura As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key_old", OracleDbType.Varchar2, orcKeyOld, ParameterDirection.Input),
            New OracleParameter("p_orc_key_new", OracleDbType.Varchar2, orcKeyNew, ParameterDirection.Input),
            New OracleParameter("p_fac_cod", OracleDbType.Varchar2, codigoFactura, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".FAC_PROV_ACTUALIZAR", ps)
    End Sub

    Public Shared Sub Eliminar(orcKey As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".FAC_PROV_ELIMINAR", ps)
    End Sub

End Class