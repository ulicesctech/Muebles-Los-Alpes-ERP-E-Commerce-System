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

    Public Shared Function Crear(presupuesto As Decimal, empleado As Decimal,
                                 Optional formaPago As String = "EFECTIVO",
                                 Optional tipoEntrega As String = "DOMICILIO",
                                 Optional almacen As Object = Nothing) As String
        Dim codigo As String = ""
        Using conn As New OracleConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
            Using cmd As New OracleCommand(PKG & ".FACTURA_CREAR", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.BindByName = True
                cmd.Parameters.Add(New OracleParameter("p_presupuesto", OracleDbType.Decimal, presupuesto, ParameterDirection.Input))
                cmd.Parameters.Add(New OracleParameter("p_empleado", OracleDbType.Decimal, empleado, ParameterDirection.Input))
                cmd.Parameters.Add(New OracleParameter("p_forma_pago", OracleDbType.Varchar2, formaPago, ParameterDirection.Input))
                cmd.Parameters.Add(New OracleParameter("p_tipo_entrega", OracleDbType.Varchar2, tipoEntrega, ParameterDirection.Input))
                Dim pAlmacen As New OracleParameter("p_almacen", OracleDbType.Decimal)
                pAlmacen.Direction = ParameterDirection.Input
                pAlmacen.Value = If(almacen Is Nothing, DBNull.Value, almacen)
                cmd.Parameters.Add(pAlmacen)
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