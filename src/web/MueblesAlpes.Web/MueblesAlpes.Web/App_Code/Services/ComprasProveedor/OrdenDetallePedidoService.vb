Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class OrdenDetallePedidoService
    Private Const PKG As String = "PKG_BOD_ORDEN_DETALLE_PEDIDO"

    Public Shared Sub Insertar(orcKey As String, pedidoId As Integer,
                               material As String, producto As String,
                               precio As Decimal, cantidad As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input),
            New OracleParameter("p_ped_id", OracleDbType.Int32, pedidoId, ParameterDirection.Input),
            New OracleParameter("p_material", OracleDbType.Varchar2, material, ParameterDirection.Input),
            New OracleParameter("p_producto", OracleDbType.Varchar2, producto, ParameterDirection.Input),
            New OracleParameter("p_precio", OracleDbType.Decimal, precio, ParameterDirection.Input),
            New OracleParameter("p_cantidad", OracleDbType.Int32, cantidad, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ODP_INSERTAR", ps)
    End Sub

    Public Shared Sub Actualizar(odpId As Integer, material As String, producto As String,
                                 precio As Decimal, cantidad As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_odp_id", OracleDbType.Int32, odpId, ParameterDirection.Input),
            New OracleParameter("p_material", OracleDbType.Varchar2, material, ParameterDirection.Input),
            New OracleParameter("p_producto", OracleDbType.Varchar2, producto, ParameterDirection.Input),
            New OracleParameter("p_precio", OracleDbType.Decimal, precio, ParameterDirection.Input),
            New OracleParameter("p_cantidad", OracleDbType.Int32, cantidad, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ODP_ACTUALIZAR", ps)
    End Sub

    Public Shared Sub Eliminar(odpId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_odp_id", OracleDbType.Int32, odpId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ODP_ELIMINAR", ps)
    End Sub

    Public Shared Function ListarPorOrden(orcKey As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ODP_LISTAR_POR_ORDEN", ps, "p_data")
    End Function

    Public Shared Function BuscarPorPedido(pedidoId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_ped_id", OracleDbType.Int32, pedidoId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ODP_LISTAR_POR_PEDIDO", ps, "p_data")
    End Function

End Class