Imports Oracle.ManagedDataAccess.Client
Imports System.Data
' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/PromocionService.vb
' Package: PKG_PROMO_PROMOCION
' ============================================================
Public Class PromocionService
    Private Const PKG As String = "PKG_PROMO_PROMOCION"

    ' ============================================================
    ' CAMPANA — MAESTRO
    ' ============================================================
    Public Shared Function CampanaCrear(nombre As String,
                                        descripcion As String,
                                        fechaInicio As Date,
                                        fechaFinal As Date) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_nombre", OracleDbType.Varchar2, nombre, ParameterDirection.Input),
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, If(descripcion, ""), ParameterDirection.Input),
            New OracleParameter("p_fecha_inicio", OracleDbType.Date, fechaInicio, ParameterDirection.Input),
            New OracleParameter("p_fecha_final", OracleDbType.Date, fechaFinal, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CAMPANA_CREAR", ps, "p_id_out")
    End Function

    Public Shared Sub CampanaActualizar(id As Decimal,
                                        nombre As String,
                                        descripcion As String,
                                        estado As String,
                                        fechaInicio As Date,
                                        fechaFinal As Date)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_nombre", OracleDbType.Varchar2, nombre, ParameterDirection.Input),
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, If(descripcion, ""), ParameterDirection.Input),
            New OracleParameter("p_estado", OracleDbType.Varchar2, estado, ParameterDirection.Input),
            New OracleParameter("p_fecha_inicio", OracleDbType.Date, fechaInicio, ParameterDirection.Input),
            New OracleParameter("p_fecha_final", OracleDbType.Date, fechaFinal, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".CAMPANA_ACTUALIZAR", ps)
    End Sub

    Public Shared Sub CampanaEliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".CAMPANA_ELIMINAR", ps)
    End Sub

    Public Shared Function CampanaListar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".CAMPANA_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function CampanaBuscar(id As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".CAMPANA_BUSCAR", ps, "p_data")
    End Function

    ' ============================================================
    ' PROMOCION — DETALLE
    ' ============================================================
    Public Shared Function Crear(campCampana As Decimal,
                                  proReferencia As String,
                                  porcentaje As Decimal) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_camp_campana", OracleDbType.Decimal, campCampana, ParameterDirection.Input),
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input),
            New OracleParameter("p_porcentaje", OracleDbType.Decimal, porcentaje, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CREAR", ps, "p_id_out")
    End Function

    Public Shared Sub Eliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ELIMINAR", ps)
    End Sub

    Public Shared Function ListarPorCampana(campCampana As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_camp_campana", OracleDbType.Decimal, campCampana, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_CAMPANA", ps, "p_data")
    End Function

    Public Shared Function ListarPorProducto(proReferencia As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_PRODUCTO", ps, "p_data")
    End Function

    Public Shared Function Vigente(proReferencia As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_pro_referencia", OracleDbType.Varchar2, proReferencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".VIGENTE", ps, "p_data")
    End Function

End Class