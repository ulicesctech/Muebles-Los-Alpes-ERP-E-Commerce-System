Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class FacturaClienteService

    Public Shared Function Crear(carritoId As Integer, empleadoId As Integer) As String
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_presupuesto", OracleDbType.Decimal, carritoId, ParameterDirection.Input),
            New OracleParameter("p_empleado", OracleDbType.Decimal, empleadoId, ParameterDirection.Input),
            New OracleParameter("p_codigo_factura", OracleDbType.Varchar2, Nothing, ParameterDirection.Output)
        }
        ps(2).Size = 100
        OracleDb.ExecNonQuery("PKG_FAC_FACTURA_CLIENTE.FACTURA_CREAR", ps)
        Return ps(2).Value.ToString()
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