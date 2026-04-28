Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: App_Code/Services/ComprasProveedor/OrdenCompraService.vb
' ============================================================
Public Class OrdenCompraService

    Private Shared ReadOnly PKG As String = "PKG_CP_BOD_ORDEN_COMPRA"

    ''' <summary>
    ''' Consulta el siguiente numero disponible para la orden desde Oracle.
    ''' Extrae el numero del campo orc_orden_compra con formato OC-N
    ''' y devuelve MAX(N) + 1. Si no hay registros devuelve 1.
    ''' </summary>
    Public Shared Function SiguienteNumero() As Integer
        Dim pNum As New OracleParameter("p_numero", OracleDbType.Decimal)
        pNum.Direction = ParameterDirection.Output

        Dim ps As New List(Of OracleParameter) From {pNum}
        OracleDb.ExecNonQuery(PKG & ".ORC_SIGUIENTE_NUMERO", ps)

        If pNum.Value Is Nothing OrElse IsDBNull(pNum.Value) Then Return 1
        Return Convert.ToInt32(pNum.Value.ToString())
    End Function

    Public Shared Sub Crear(orcKey As String, codigo As String, provId As Integer, total As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input),
            New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
            New OracleParameter("p_prov_id", OracleDbType.Decimal, provId, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ORC_CREAR", ps)
    End Sub

    Public Shared Sub Actualizar(orcKey As String, codigo As String, provId As Integer, total As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input),
            New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
            New OracleParameter("p_prov_id", OracleDbType.Decimal, provId, ParameterDirection.Input),
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

    Public Shared Function ListarPorId(orcKey As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ORC_LISTAR_ID", ps, "p_data")
    End Function

    Public Shared Function Buscar(codigo As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_codigo", OracleDbType.Varchar2, If(codigo, String.Empty), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ORC_BUSCAR", ps, "p_data")
    End Function

    Public Shared Function BuscarPedidos(texto As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_texto", OracleDbType.Varchar2, If(texto, String.Empty), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ORC_BUSCAR_PEDIDOS", ps, "p_data")
    End Function

    Public Shared Function DetallesPedido(pedId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_ped_id", OracleDbType.Decimal, pedId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".ORC_DETALLES_PEDIDO", ps, "p_data")
    End Function

End Class