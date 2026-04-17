Imports System.Data
Imports Oracle.ManagedDataAccess.Client
' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/HistorialPrecioService.vb
' Package: PKG_BOD_HISTORIAL_PRECIO
'
' CAMBIOS vs version anterior:
'   + CerrarTodos    : llama a PKG.CERRAR_TODOS (sin filtro de nicho).
'   + RegistrarGlobal: llama a PKG.REGISTRAR_GLOBAL (atomico).
' ============================================================
Public Class HistorialPrecioService
    Private Const PKG As String = "PKG_BOD_HISTORIAL_PRECIO"

    ' Inserta un precio real nuevo (nicho y precio obligatorios).
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

    ' Inserta semilla con nic_nicho=NULL y hip_precio=NULL.
    ' Se usa al agregar un item al pedido antes de tener Orden de Compra.
    Public Shared Function RegistrarSemilla(proReferencia As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".REGISTRAR_SEMILLA", ps, "p_id_out")
    End Function

    ' Cierra el vigente de un nicho especifico (se conserva para usos puntuales).
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

    ' NUEVO: Cierra TODOS los vigentes del producto sin importar nicho/almacen.
    ' Incluye semillas (nic_nicho IS NULL) que aun no tienen hip_fecha_final.
    ' Se llama en el flujo readonly ANTES de ActualizarSemilla.
    Public Shared Sub CerrarTodos(proReferencia As String, fechaCierre As Date)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_fecha_cierre", OracleDbType.Date, fechaCierre, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".CERRAR_TODOS", ps)
    End Sub

    ' NUEVO: Atomico en Oracle: cierra todos los vigentes del producto
    ' e inserta el nuevo registro vigente unico con el nicho seleccionado.
    ' Reemplaza el par CerrarVigente + Registrar en el flujo normal de Precios.aspx.
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

    ' Actualiza la semilla con nicho, precio y fecha reales
    ' al confirmar la recepcion desde Precios.aspx (flujo readonly).
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

    ' Retorna el vigente REAL (precio NOT NULL) de un producto/nicho.
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