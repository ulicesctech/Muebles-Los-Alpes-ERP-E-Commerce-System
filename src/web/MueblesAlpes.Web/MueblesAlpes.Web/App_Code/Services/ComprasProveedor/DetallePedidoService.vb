Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class DetallePedidoService
    Private Const PKG As String = "PKG_BOD_DETALLE_PEDIDO"

    Public Shared Sub Insertar(pedidoId As Integer, historialId As Integer,
                               cantSolicitada As Integer,
                               Optional cantRecibida As Integer = 0)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_ped_pedido", OracleDbType.Decimal, pedidoId, ParameterDirection.Input),
            New OracleParameter("p_hip_historial", OracleDbType.Decimal, historialId, ParameterDirection.Input),
            New OracleParameter("p_cant_solicitada", OracleDbType.Decimal, cantSolicitada, ParameterDirection.Input),
            New OracleParameter("p_cant_recibida", OracleDbType.Decimal, cantRecibida, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".DET_PED_INSERTAR", ps)
    End Sub

    ' Actualizar solo cantidades (sin precio — el precio va en historial)
    Public Shared Sub Actualizar(detalleId As Integer,
                                 cantSolicitada As Integer,
                                 cantRecibida As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_detpe_id", OracleDbType.Decimal, detalleId, ParameterDirection.Input),
            New OracleParameter("p_cant_solicitada", OracleDbType.Decimal, cantSolicitada, ParameterDirection.Input),
            New OracleParameter("p_cant_recibida", OracleDbType.Decimal, cantRecibida, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".DET_PED_ACTUALIZAR", ps)
    End Sub

    Public Shared Sub Eliminar(detalleId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_detpe_id", OracleDbType.Decimal, detalleId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".DET_PED_ELIMINAR", ps)
    End Sub

    Public Shared Function ListarPorPedido(pedidoId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_ped_pedido", OracleDbType.Decimal, pedidoId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".DET_PED_LISTAR_POR_PEDIDO", ps, "p_data")
    End Function

    Public Shared Function ListarProductosDisponibles() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".DET_PED_LISTAR_PRODUCTOS", Nothing, "p_data")
    End Function

    Public Shared Function ListarProductosBase() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".DET_PED_LISTAR_PRODUCTOS_BASE", Nothing, "p_data")
    End Function

    ' NUEVO: Todos los productos de BOD_PRODUCTO con precio sugerido si existe
    Public Shared Function ListarTodosProductos() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".DET_PED_LISTAR_TODOS_PRODUCTOS", Nothing, "p_data")
    End Function

End Class