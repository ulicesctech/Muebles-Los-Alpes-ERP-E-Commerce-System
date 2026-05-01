Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: App_Code/Services/ComprasProveedor/OrdenCompraService.vb
' Package: PKG_CP_BOD_ORDEN_COMPRA
' ============================================================
Public Class OrdenCompraService

    Private Shared ReadOnly PKG As String = "PKG_CP_BOD_ORDEN_COMPRA"

    ''' <summary>
    ''' Crea una orden de compra.
    ''' El key (orc_orden_compra) y el codigo (orc_codigo) los genera Oracle
    ''' internamente con los prefijos C_PREFIJO_ORC y C_PREFIJO_COD del package body.
    ''' Devuelve el key generado para usarlo en los inserts de detalle.
    ''' Para cambiar los prefijos edita esas constantes en Oracle; nada cambia aqui.
    ''' </summary>
    Public Shared Function Crear(provId As Integer, total As Decimal) As String
        Dim pKey As New OracleParameter("p_orc_key_out", OracleDbType.Varchar2, 50)
        pKey.Direction = ParameterDirection.Output

        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_prov_id", OracleDbType.Decimal, provId, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input),
            pKey
        }
        OracleDb.ExecNonQuery(PKG & ".ORC_CREAR", ps)

        If pKey.Value IsNot Nothing AndAlso Not IsDBNull(pKey.Value) Then
            Return pKey.Value.ToString()
        End If
        Return String.Empty
    End Function

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