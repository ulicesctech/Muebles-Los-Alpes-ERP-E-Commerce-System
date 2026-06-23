Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class CarritoService

    Public Shared Function Crear(clienteId As Integer) As Integer
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_cliente", OracleDbType.Decimal, clienteId, ParameterDirection.Input),
            New OracleParameter("p_id", OracleDbType.Decimal, Nothing, ParameterDirection.Output)
        }
        OracleDb.ExecNonQuery("PKG_CLI_CARRITO.CARRITO_CREAR", ps)
        Return Convert.ToInt32(ps(1).Value.ToString())
    End Function

    Public Shared Function BuscarPorCliente(clienteId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_cliente", OracleDbType.Decimal, clienteId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor("PKG_CLI_CARRITO.CARRITO_BUSCAR", ps, "p_data")
    End Function

    Public Shared Sub AgregarDetalle(carritoId As Integer, hipId As Integer, cantidad As Integer)
        Dim ps As New List(Of OracleParameter) From {
        New OracleParameter("p_carrito", OracleDbType.Decimal, carritoId, ParameterDirection.Input),
        New OracleParameter("p_hv_precio", OracleDbType.Decimal, hipId, ParameterDirection.Input),
        New OracleParameter("p_cantidad", OracleDbType.Decimal, cantidad, ParameterDirection.Input)
    }
        OracleDb.ExecOutNumber("PKG_CLI_CARRITO.CARRITO_AGREGAR_DETALLE", ps, "p_id")
    End Sub

    Public Shared Sub EliminarDetalle(detalleId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, detalleId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery("PKG_CLI_CARRITO.CARRITO_ELIMINAR_DETALLE", ps)
    End Sub

    Public Shared Sub Vaciar(carritoId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_carrito", OracleDbType.Decimal, carritoId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery("PKG_CLI_CARRITO.CARRITO_VACIAR", ps)
    End Sub

    Public Shared Sub Facturar(carritoId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_carrito", OracleDbType.Decimal, carritoId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery("PKG_CLI_CARRITO.CARRITO_FACTURAR", ps)
    End Sub
    Public Shared Function AlmacenesConStock(hvIds As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_hv_ids", OracleDbType.Varchar2, hvIds, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor("PKG_CLI_CARRITO.ALMACENES_CON_STOCK", ps, "p_data")
    End Function
End Class