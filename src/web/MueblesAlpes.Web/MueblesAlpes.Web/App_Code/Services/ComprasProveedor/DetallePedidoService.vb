Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class DetallePedidoService
    Private Const PKG As String = "PKG_BOD_DETALLE_PEDIDO"

    ''' <summary>
    ''' Inserta un nuevo renglón de detalle en un pedido existente.
    ''' </summary>
    Public Shared Sub Insertar(pedidoId As Integer, historialId As Integer,
                               cantSolicitada As Integer,
                               Optional cantRecibida As Integer = 0)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_ped_pedido",     OracleDbType.Decimal,  pedidoId,      ParameterDirection.Input),
            New OracleParameter("p_hip_historial",  OracleDbType.Decimal,  historialId,   ParameterDirection.Input),
            New OracleParameter("p_cant_solicitada",OracleDbType.Decimal,  cantSolicitada,ParameterDirection.Input),
            New OracleParameter("p_cant_recibida",  OracleDbType.Decimal,  cantRecibida,  ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".DET_PED_INSERTAR", ps)
    End Sub

    ''' <summary>
    ''' Actualiza las cantidades de un detalle de pedido específico.
    ''' </summary>
    Public Shared Sub Actualizar(detalleId As Integer,
                                 cantSolicitada As Integer,
                                 cantRecibida As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_detpe_id",        OracleDbType.Decimal, detalleId,      ParameterDirection.Input),
            New OracleParameter("p_cant_solicitada", OracleDbType.Decimal, cantSolicitada, ParameterDirection.Input),
            New OracleParameter("p_cant_recibida",   OracleDbType.Decimal, cantRecibida,   ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".DET_PED_ACTUALIZAR", ps)
    End Sub

    ''' <summary>
    ''' Elimina un detalle de pedido por su ID único.
    ''' </summary>
    Public Shared Sub Eliminar(detalleId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_detpe_id", OracleDbType.Decimal, detalleId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".DET_PED_ELIMINAR", ps)
    End Sub

    ''' <summary>
    ''' Lista todos los productos y cantidades asociados a un pedido.
    ''' Devuelve columnas: DETPE_DETALLE_PEDIDO, PED_PEDIDO, DETPE_CANTIDAD_SOLICITADA,
    '''                    DETPE_CANTIDAD_RECIBIDA, HIP_PRECIO, PRO_NOMBRE.
    ''' </summary>
    Public Shared Function ListarPorPedido(pedidoId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_ped_pedido", OracleDbType.Decimal, pedidoId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".DET_PED_LISTAR_POR_PEDIDO", ps, "p_data")
    End Function

    ''' <summary>
    ''' Devuelve todos los productos con su historial de precio vigente
    ''' para poblar el DropDownList de la pantalla de Pedidos.
    ''' Devuelve columnas: HIP_HISTORIAL_PRECIO, PRO_NOMBRE, HIP_PRECIO.
    ''' Llama a PKG_BOD_DETALLE_PEDIDO.DET_PED_LISTAR_PRODUCTOS.
    ''' </summary>
    Public Shared Function ListarProductosDisponibles() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".DET_PED_LISTAR_PRODUCTOS", Nothing, "p_data")
    End Function

End Class
