Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class OrdenCompraService
    Private Shared ReadOnly PKG As String = "PKG_CP_BOD_ORDEN_COMPRA"

    Public Shared Sub Crear(orcKey As String, codigo As String, proveedorId As Decimal, total As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input),
            New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
            New OracleParameter("p_prov_id", OracleDbType.Decimal, proveedorId, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ORC_CREAR", ps)
    End Sub

    Public Shared Sub Actualizar(orcKey As String, codigo As String, proveedorId As Decimal, total As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input),
            New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
            New OracleParameter("p_prov_id", OracleDbType.Decimal, proveedorId, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ORC_ACTUALIZAR", ps)
    End Sub

    Public Shared Sub ActualizarTotal(orcKey As String, total As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ORC_ACTUALIZAR_TOTAL", ps)
    End Sub

    Public Shared Sub Eliminar(orcKey As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ORC_ELIMINAR", ps)
    End Sub

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".ORC_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function ObtenerPorId(orcKey As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ORC_LISTAR_ID", ps, "p_data")
    End Function

    Public Shared Function Buscar(filtro As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_codigo", OracleDbType.Varchar2, filtro, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ORC_BUSCAR", ps, "p_data")
    End Function

    ''' <summary>Busca pedidos: devuelve UNA fila por pedido (cabecera).</summary>
    Public Shared Function BuscarPedidos(texto As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_texto", OracleDbType.Varchar2,
                                If(String.IsNullOrEmpty(texto), "", texto),
                                ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ORC_BUSCAR_PEDIDOS", ps, "p_data")
    End Function

    ''' <summary>Devuelve todos los items (detalles) de un pedido especifico.</summary>
    Public Shared Function DetallesPedido(pedidoId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_ped_id", OracleDbType.Int32, pedidoId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ORC_DETALLES_PEDIDO", ps, "p_data")
    End Function

End Class
