Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class FacturaClienteService

    Public Shared Function Crear(carritoId As Integer, empleadoId As Integer, formaPago As String, tipoEntrega As String, almacenId As Integer) As String
        Dim ps As New List(Of OracleParameter) From {
        New OracleParameter("p_presupuesto", OracleDbType.Decimal, carritoId, ParameterDirection.Input),
        New OracleParameter("p_empleado", OracleDbType.Decimal, empleadoId, ParameterDirection.Input),
        New OracleParameter("p_forma_pago", OracleDbType.Varchar2, formaPago, ParameterDirection.Input),
        New OracleParameter("p_tipo_entrega", OracleDbType.Varchar2, tipoEntrega, ParameterDirection.Input),
        New OracleParameter("p_almacen", OracleDbType.Decimal, If(almacenId = 0, CObj(DBNull.Value), CObj(almacenId)), ParameterDirection.Input),
        New OracleParameter("p_codigo_factura", OracleDbType.Varchar2, Nothing, ParameterDirection.Output)
    }
        ps(5).Size = 100
        OracleDb.ExecNonQuery("PKG_FAC_FACTURA_CLIENTE.FACTURA_CREAR", ps)
        Return ps(5).Value.ToString()
    End Function

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor("PKG_FAC_FACTURA_CLIENTE.FACTURA_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Buscar(carritoId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_presupuesto", OracleDbType.Decimal, carritoId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor("PKG_FAC_FACTURA_CLIENTE.FACTURA_BUSCAR", ps, "p_data")
    End Function
    Public Shared Function ListarPorCliente(clienteId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_cliente", OracleDbType.Decimal, clienteId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor("PKG_FAC_FACTURA_CLIENTE.FACTURA_LISTAR_POR_CLIENTE", ps, "p_data")
    End Function
End Class