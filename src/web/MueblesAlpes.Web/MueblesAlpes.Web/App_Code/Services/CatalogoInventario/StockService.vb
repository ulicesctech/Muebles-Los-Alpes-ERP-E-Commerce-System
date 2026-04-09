Imports System.Data
Imports Oracle.ManagedDataAccess.Client
' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/StockService.vb
' Package: PKG_BOD_STOCK
' ============================================================
Public Class StockService
    Private Const PKG As String = "PKG_BOD_STOCK"

    ''' <summary>Guarda o actualiza el stock de un historial de precio.</summary>
    Public Shared Sub Guardar(hipHistorialPrecio As Decimal,
                               minimo As Decimal,
                               maximo As Decimal,
                               reservado As Decimal,
                               disponible As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_hip_historial_precio", OracleDbType.Decimal, hipHistorialPrecio, ParameterDirection.Input),
            New OracleParameter("p_minimo", OracleDbType.Decimal, minimo, ParameterDirection.Input),
            New OracleParameter("p_maximo", OracleDbType.Decimal, maximo, ParameterDirection.Input),
            New OracleParameter("p_reservado", OracleDbType.Decimal, reservado, ParameterDirection.Input),
            New OracleParameter("p_disponible", OracleDbType.Decimal, disponible, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".GUARDAR", ps)
    End Sub

    ''' <summary>Obtiene el stock de un historial con info completa de producto, nicho y almacen.</summary>
    Public Shared Function Obtener(hipHistorialPrecio As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_hip_historial_precio", OracleDbType.Decimal, hipHistorialPrecio, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".OBTENER", ps, "p_data")
    End Function

    ''' <summary>Lista todo el stock con info completa — producto, nicho, almacen y estado.</summary>
    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    ''' <summary>Lista el stock de un producto especifico.</summary>
    Public Shared Function ListarPorProducto(proReferencia As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_PRODUCTO", ps, "p_data")
    End Function

End Class