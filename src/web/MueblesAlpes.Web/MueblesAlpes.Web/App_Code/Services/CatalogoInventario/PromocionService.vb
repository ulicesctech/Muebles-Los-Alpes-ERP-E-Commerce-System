Imports Oracle.ManagedDataAccess.Client
Imports System.Data

' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/PromocionService.vb
' Package: PKG_PROMO_PROMOCION
' ============================================================
Public Class PromocionService

    Private Const PKG As String = "PKG_PROMO_PROMOCION"

    ''' <summary>
    ''' Crea una nueva promoción para un producto.
    ''' Devuelve el ID generado de la promoción.
    ''' </summary>
    Public Shared Function Crear(proReferencia As String,
                                  porcentaje As Decimal,
                                  fechaInicio As Date,
                                  fechaFinal As Date) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_porcentaje", OracleDbType.Decimal, porcentaje, ParameterDirection.Input),
            New OracleParameter("p_fecha_inicio", OracleDbType.Date, fechaInicio, ParameterDirection.Input),
            New OracleParameter("p_fecha_final", OracleDbType.Date, fechaFinal, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CREAR", ps, "p_id_out")
    End Function

    ''' <summary>
    ''' Elimina una promoción por su ID.
    ''' </summary>
    Public Shared Sub Eliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ELIMINAR", ps)
    End Sub

    ''' <summary>
    ''' Lista todas las promociones de un producto.
    ''' </summary>
    Public Shared Function ListarPorProducto(proReferencia As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_PRODUCTO", ps, "p_data")
    End Function

    ''' <summary>
    ''' Obtiene la promoción vigente de un producto (si existe).
    ''' </summary>
    Public Shared Function Vigente(proReferencia As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".VIGENTE", ps, "p_data")
    End Function

End Class