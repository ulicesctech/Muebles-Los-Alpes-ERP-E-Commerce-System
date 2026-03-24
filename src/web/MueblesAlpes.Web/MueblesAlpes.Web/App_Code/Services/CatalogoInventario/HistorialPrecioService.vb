Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/HistorialPrecioService.vb
' Package: PKG_BOD_HISTORIAL_PRECIO
' ============================================================
Public Class HistorialPrecioService

    Private Const PKG As String = "PKG_BOD_HISTORIAL_PRECIO"

    ''' <summary>
    ''' Registra un nuevo precio para un producto en un nicho.
    ''' Devuelve el ID generado del historial.
    ''' </summary>
    Public Shared Function Registrar(proReferencia As String,
                                      nicNicho As Decimal,
                                      precio As Decimal,
                                      fechaInicio As Date) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_nic_nicho", OracleDbType.Decimal, nicNicho, ParameterDirection.Input),
            New OracleParameter("p_precio", OracleDbType.Decimal, precio, ParameterDirection.Input),
            New OracleParameter("p_fecha_inicio", OracleDbType.Date, fechaInicio, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".REGISTRAR", ps, "p_id_out")
    End Function

    ''' <summary>
    ''' Obtiene el precio vigente de un producto en un nicho específico.
    ''' </summary>
    Public Shared Function Vigente(proReferencia As String, nicNicho As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_nic_nicho", OracleDbType.Decimal, nicNicho, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".VIGENTE", ps, "p_data")
    End Function

    ''' <summary>
    ''' Lista todo el historial de precios de un producto.
    ''' </summary>
    Public Shared Function ListarPorProducto(proReferencia As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_PRODUCTO", ps, "p_data")
    End Function

End Class