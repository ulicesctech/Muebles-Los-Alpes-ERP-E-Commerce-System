Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class DetallePedidoService
    Private Const PKG As String = "PKG_BOD_DETALLE_PEDIDO"

    Public Shared Sub Insertar(pedidoId As Integer, historialId As Integer,
                               cantSolicitada As Integer,
                               precioUnitario As Decimal,
                               Optional cantRecibida As Integer = 0)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_ped_pedido", OracleDbType.Decimal, pedidoId, ParameterDirection.Input),
            New OracleParameter("p_hip_historial", OracleDbType.Decimal, historialId, ParameterDirection.Input),
            New OracleParameter("p_cant_solicitada", OracleDbType.Decimal, cantSolicitada, ParameterDirection.Input),
            New OracleParameter("p_precio_unitario", OracleDbType.Decimal, precioUnitario, ParameterDirection.Input),
            New OracleParameter("p_cant_recibida", OracleDbType.Decimal, cantRecibida, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".DET_PED_INSERTAR", ps)
    End Sub

    Public Shared Sub Actualizar(detalleId As Integer,
                                 cantSolicitada As Integer,
                                 cantRecibida As Integer,
                                 precioUnitario As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_detpe_id", OracleDbType.Decimal, detalleId, ParameterDirection.Input),
            New OracleParameter("p_cant_solicitada", OracleDbType.Decimal, cantSolicitada, ParameterDirection.Input),
            New OracleParameter("p_cant_recibida", OracleDbType.Decimal, cantRecibida, ParameterDirection.Input),
            New OracleParameter("p_precio_unitario", OracleDbType.Decimal, precioUnitario, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".DET_PED_ACTUALIZAR", ps)
    End Sub

    Public Shared Sub Eliminar(detalleId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_detpe_id", OracleDbType.Decimal, detalleId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".DET_PED_ELIMINAR", ps)
    End Sub

    ''' Devuelve: DETPE_DETALLE_PEDIDO, PED_PEDIDO, DETPE_CANTIDAD_SOLICITADA,
    '''           DETPE_CANTIDAD_RECIBIDA, DETPE_PRECIO_UNITARIO, PRO_NOMBRE
    Public Shared Function ListarPorPedido(pedidoId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_ped_pedido", OracleDbType.Decimal, pedidoId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".DET_PED_LISTAR_POR_PEDIDO", ps, "p_data")
    End Function

    ''' Devuelve: HIP_HISTORIAL_PRECIO, PRO_NOMBRE, HIP_PRECIO
    Public Shared Function ListarProductosDisponibles() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".DET_PED_LISTAR_PRODUCTOS", Nothing, "p_data")
    End Function

End Class