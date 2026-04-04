Imports System.Data
Imports Oracle.ManagedDataAccess.Client
' ============================================================
' RUTA: App_Code/Services/VentasFacturacion/FacturaService.vb
' ============================================================
Public Class FacturaService
    Private Const PKG As String = "PKG_FAC_FACTURA_CLIENTE"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".FACTURA_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Crear(presupuesto As Decimal, empleado As Decimal) As String
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_presupuesto", OracleDbType.Decimal, presupuesto, ParameterDirection.Input),
            New OracleParameter("p_empleado", OracleDbType.Decimal, empleado, ParameterDirection.Input)
        }
        Dim pOut As New OracleParameter("p_codigo_factura", OracleDbType.Varchar2, 50)
        pOut.Direction = ParameterDirection.Output
        ps.Add(pOut)
        OracleDb.ExecNonQuery(PKG & ".FACTURA_CREAR", ps)
        Return pOut.Value.ToString()
    End Function

    Public Shared Function Buscar(presupuesto As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_presupuesto", OracleDbType.Decimal, presupuesto, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".FACTURA_BUSCAR", ps, "p_data")
    End Function

End Class