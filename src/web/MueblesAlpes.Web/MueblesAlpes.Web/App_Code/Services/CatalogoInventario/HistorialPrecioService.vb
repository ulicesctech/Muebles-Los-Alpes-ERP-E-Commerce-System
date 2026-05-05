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

    Public Shared Function RegistrarSemilla(proReferencia As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".REGISTRAR_SEMILLA", ps, "p_id_out")
    End Function

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

    Public Shared Sub CerrarTodos(proReferencia As String, fechaCierre As Date)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_fecha_cierre", OracleDbType.Date, fechaCierre, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".CERRAR_TODOS", ps)
    End Sub

    ' NUEVO: Cierra unicamente la semilla indicada por su hip_id.
    ' Se usa cuando el precio del pedido coincide con el vigente real,
    ' para no dejar la semilla huerfana sin generar un nuevo historial.
    Public Shared Sub CerrarSemilla(hipId As Decimal, fechaCierre As Date)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_hip_id", OracleDbType.Decimal, hipId, ParameterDirection.Input),
            New OracleParameter("p_fecha_cierre", OracleDbType.Date, fechaCierre, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".CERRAR_SEMILLA", ps)
    End Sub

    Public Shared Function RegistrarGlobal(proReferencia As String,
                                           nicNicho As Decimal,
                                           precio As Decimal,
                                           fechaInicio As Date) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_nic_nicho", OracleDbType.Decimal, nicNicho, ParameterDirection.Input),
            New OracleParameter("p_precio", OracleDbType.Decimal, precio, ParameterDirection.Input),
            New OracleParameter("p_fecha_inicio", OracleDbType.Date, fechaInicio, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".REGISTRAR_GLOBAL", ps, "p_id_out")
    End Function

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

    Public Shared Function ObtenerAnios() As List(Of Integer)
        Dim dt As DataTable = OracleDb.ExecRefCursor(PKG & ".OBTENER_ANIOS", Nothing, "p_data")
        Dim lista As New List(Of Integer)
        If dt IsNot Nothing Then
            For Each row As DataRow In dt.Rows
                lista.Add(Convert.ToInt32(row("ANIO")))
            Next
        End If
        Return lista
    End Function

End Class