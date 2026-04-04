Imports System.Data
Imports Oracle.ManagedDataAccess.Client
' ============================================================
' RUTA: App_Code/Services/VentasFacturacion/CarritoService.vb
' ============================================================
Public Class CarritoService
    Private Const PKG As String = "PKG_CLI_CARRITO"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".CARRITO_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Crear(cliente As Decimal) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_cliente", OracleDbType.Decimal, cliente, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CARRITO_CREAR", ps, "p_id")
    End Function

    Public Shared Sub Vaciar(carrito As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_carrito", OracleDbType.Decimal, carrito, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".CARRITO_VACIAR", ps)
    End Sub

    Public Shared Sub Eliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".CARRITO_ELIMINAR", ps)
    End Sub

    Public Shared Function AgregarDetalle(carrito As Decimal, histPrecio As Decimal, cantidad As Decimal) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_carrito", OracleDbType.Decimal, carrito, ParameterDirection.Input),
            New OracleParameter("p_hist_precio", OracleDbType.Decimal, histPrecio, ParameterDirection.Input),
            New OracleParameter("p_cantidad", OracleDbType.Decimal, cantidad, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CARRITO_AGREGAR_DETALLE", ps, "p_id")
    End Function

    Public Shared Sub EliminarDetalle(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".CARRITO_ELIMINAR_DETALLE", ps)
    End Sub

    Public Shared Function ListarProductosCarrito(carrito As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_carrito", OracleDbType.Decimal, carrito, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor("SELECT cd.DETCAR_DETALLE_CARRITO, bh.PRO_REFERENCIA, cd.DETPRE_CANTIDAD FROM CLI_DETALLE_CARRITO cd JOIN BOD_HISTORIAL_PRECIO bh ON cd.HIP_HISTORIAL_PRECIO = bh.HIP_HISTORIAL_PRECIO WHERE cd.PRE_CARRITO = :p_carrito", ps, "p_data")
    End Function

End Class