Imports System.Data
Imports Oracle.ManagedDataAccess.Client
' ============================================================
' RUTA: App_Code/Services/VentasFacturacion/HistorialPrecioVentaService.vb
' ============================================================
Public Class HistorialPrecioVentaService
    Private Const PKG As String = "PKG_BOD_HISTORIAL_PRECIO_VENTA"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Registrar(proReferencia As String, porcetaje As Decimal) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_porcetaje", OracleDbType.Decimal, porcetaje, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".REGISTRAR", ps, "p_id")
    End Function

End Class
