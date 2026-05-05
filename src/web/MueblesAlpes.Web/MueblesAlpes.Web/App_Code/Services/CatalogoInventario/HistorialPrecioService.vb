Imports Oracle.ManagedDataAccess.Client
Imports System.Data
' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/HistorialPrecioService.vb
' Package: PKG_BOD_HISTORIAL_PRECIO
' ============================================================
Public Class HistorialPrecioService
    Private Const PKG As String = "PKG_BOD_HISTORIAL_PRECIO"

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

    Public Shared Sub RegistrarEnTodos(proReferencia As String,
                                        precio As Decimal,
                                        fechaInicio As Date)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_precio", OracleDbType.Decimal, precio, ParameterDirection.Input),
            New OracleParameter("p_fecha_inicio", OracleDbType.Date, fechaInicio, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".REGISTRAR_EN_TODOS", ps)
    End Sub

    Public Shared Function Vigente(proReferencia As String, nicNicho As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_nic_nicho", OracleDbType.Decimal, nicNicho, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".VIGENTE", ps, "p_data")
    End Function

    Public Shared Function ListarPorProducto(proReferencia As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_PRODUCTO", ps, "p_data")
    End Function

    Public Shared Function ListarTodos() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_TODOS", Nothing, "p_data")
    End Function

    ''' <summary>Lista precios vigentes durante un mes y anio especifico.</summary>
    Public Shared Function ListarPorMes(mes As Integer, anio As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_mes", OracleDbType.Decimal, mes, ParameterDirection.Input),
            New OracleParameter("p_anio", OracleDbType.Decimal, anio, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_MES", ps, "p_data")
    End Function

End Class