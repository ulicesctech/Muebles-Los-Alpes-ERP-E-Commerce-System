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
        Dim codigo As String = ""
        Using conn As New OracleConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Using cmd As New OracleCommand(PKG & ".FACTURA_CREAR", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.BindByName = True
                cmd.Parameters.Add(New OracleParameter("p_presupuesto", OracleDbType.Decimal, presupuesto, ParameterDirection.Input))
                cmd.Parameters.Add(New OracleParameter("p_empleado", OracleDbType.Decimal, empleado, ParameterDirection.Input))
                Dim pOut As New OracleParameter("p_codigo_factura", OracleDbType.Varchar2, 50)
                pOut.Direction = ParameterDirection.Output
                cmd.Parameters.Add(pOut)
                conn.Open()
                cmd.ExecuteNonQuery()
                codigo = pOut.Value.ToString()
            End Using
        End Using
        Return codigo
    End Function

    Public Shared Function Buscar(presupuesto As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_presupuesto", OracleDbType.Decimal, presupuesto, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".FACTURA_BUSCAR", ps, "p_data")
    End Function

End Class