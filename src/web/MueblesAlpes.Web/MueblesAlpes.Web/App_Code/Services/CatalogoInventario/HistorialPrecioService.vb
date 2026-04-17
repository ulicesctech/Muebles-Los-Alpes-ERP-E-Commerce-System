Imports System.Data
Imports Oracle.ManagedDataAccess.Client
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

    ' *** CAMBIE AHORITA: nuevo metodo que llama a REGISTRAR_SEMILLA en Oracle.
    ' Inserta un historial con precio=0 y nicho placeholder sin validaciones,
    ' solo para vincular la pro_referencia al BOD_DETALLE_PEDIDO al agregar
    ' un item al pedido antes de tener Orden de Compra.
    ' Retorna el hip_historial_precio generado.
    Public Shared Function RegistrarSemilla(proReferencia As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".REGISTRAR_SEMILLA", ps, "p_id_out")
    End Function
    ' *** FIN CAMBIE AHORITA

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

    Public Shared Sub CerrarVigente(proReferencia As String,
                                    nicNicho As Decimal,
                                    fechaCierre As Date)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_nic_nicho", OracleDbType.Decimal, nicNicho, ParameterDirection.Input),
            New OracleParameter("p_fecha_cierre", OracleDbType.Date, fechaCierre, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".CERRAR_VIGENTE", ps)
    End Sub

    Public Shared Sub ActualizarSemilla(hipId As Decimal,
                                        nicNicho As Decimal,
                                        precio As Decimal,
                                        fechaInicio As Date)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_hip_id", OracleDbType.Decimal, hipId, ParameterDirection.Input),
            New OracleParameter("p_nic_nicho", OracleDbType.Decimal, nicNicho, ParameterDirection.Input),
            New OracleParameter("p_precio", OracleDbType.Decimal, precio, ParameterDirection.Input),
            New OracleParameter("p_fecha_inicio", OracleDbType.Date, fechaInicio, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ACTUALIZAR_SEMILLA", ps)
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

    Public Shared Function ListarPorMes(mes As Integer, anio As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_mes", OracleDbType.Decimal, mes, ParameterDirection.Input),
            New OracleParameter("p_anio", OracleDbType.Decimal, anio, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_MES", ps, "p_data")
    End Function

End Class