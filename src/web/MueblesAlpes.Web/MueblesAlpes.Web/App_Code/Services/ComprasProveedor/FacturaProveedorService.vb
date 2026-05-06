Imports System.Data
Imports Oracle.ManagedDataAccess.Client
' ============================================================
' RUTA: App_Code/Services/ComprasProveedor/FacturaProveedorService.vb
' ============================================================
Public Class FacturaProveedorService
    Private Const PKG As String = "PKG_CP_FAC_FACTURA_PROV"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".FAC_PROV_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Buscar(texto As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_texto", OracleDbType.Varchar2, If(texto, ""), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".FAC_PROV_BUSCAR", ps, "p_data")
    End Function

    ''' <summary>
    ''' Busca con filtros de texto libre y rango de fechas.
    ''' El filtro por orden (p_orc_key) siempre se pasa como NULL para ignorarlo.
    ''' </summary>
    Public Shared Function BuscarFiltro(texto As String,
                                         orcKey As Object,
                                         fechaDesde As Object,
                                         fechaHasta As Object) As DataTable
        Dim pTexto As New OracleParameter("p_texto", OracleDbType.Varchar2)
        pTexto.Direction = ParameterDirection.Input
        pTexto.Value = If(String.IsNullOrWhiteSpace(CStr(texto)), DBNull.Value, CObj(texto.ToString().Trim()))

        ' orcKey siempre NULL — filtro por orden eliminado de la UI
        Dim pOrc As New OracleParameter("p_orc_key", OracleDbType.Varchar2)
        pOrc.Direction = ParameterDirection.Input
        pOrc.Value = DBNull.Value

        Dim pDesde As New OracleParameter("p_fecha_desde", OracleDbType.Date)
        pDesde.Direction = ParameterDirection.Input
        pDesde.Value = If(fechaDesde Is Nothing, DBNull.Value, fechaDesde)

        Dim pHasta As New OracleParameter("p_fecha_hasta", OracleDbType.Date)
        pHasta.Direction = ParameterDirection.Input
        pHasta.Value = If(fechaHasta Is Nothing, DBNull.Value, fechaHasta)

        Dim ps As New List(Of OracleParameter) From {pTexto, pOrc, pDesde, pHasta}
        Return OracleDb.ExecRefCursor(PKG & ".FAC_PROV_BUSCAR_FILTRO", ps, "p_data")
    End Function

    Public Shared Sub Registrar(orcKey As String, codigoFactura As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input),
            New OracleParameter("p_fac_cod", OracleDbType.Varchar2, codigoFactura, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".FAC_PROV_REGISTRAR", ps)
    End Sub

    Public Shared Sub Actualizar(orcKeyOld As String, orcKeyNew As String, codigoFactura As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key_old", OracleDbType.Varchar2, orcKeyOld, ParameterDirection.Input),
            New OracleParameter("p_orc_key_new", OracleDbType.Varchar2, orcKeyNew, ParameterDirection.Input),
            New OracleParameter("p_fac_cod", OracleDbType.Varchar2, codigoFactura, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".FAC_PROV_ACTUALIZAR", ps)
    End Sub

    Public Shared Sub Eliminar(orcKey As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".FAC_PROV_ELIMINAR", ps)
    End Sub

End Class