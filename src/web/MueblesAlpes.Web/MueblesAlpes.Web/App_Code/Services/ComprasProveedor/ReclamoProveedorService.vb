Imports System.Data
Imports Oracle.ManagedDataAccess.Client
' ============================================================
' RUTA: App_Code/Services/ComprasProveedor/ReclamoProveedorService.vb
' ============================================================
Public Class ReclamoProveedorService

    Private Const PKG As String = "PKG_CP_FAC_RECLAMO_PROV"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".REC_PROV_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function ListarPorId(id As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".REC_PROV_LISTAR_ID", ps, "p_data")
    End Function

    Public Shared Function ListarEstados() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".REC_PROV_LISTAR_ESTADOS", Nothing, "p_data")
    End Function

    Public Shared Function Buscar(texto As String,
                                   estado As String,
                                   fechaDesde As Object,
                                   fechaHasta As Object) As DataTable
        Dim pTexto As New OracleParameter("p_texto", OracleDbType.Varchar2)
        pTexto.Direction = ParameterDirection.Input
        pTexto.Value = If(String.IsNullOrWhiteSpace(texto), DBNull.Value, CObj(texto.Trim()))

        Dim pEstado As New OracleParameter("p_estado", OracleDbType.Varchar2)
        pEstado.Direction = ParameterDirection.Input
        pEstado.Value = If(String.IsNullOrWhiteSpace(estado) OrElse estado = "TODOS", DBNull.Value, CObj(estado.Trim()))

        Dim pDesde As New OracleParameter("p_fecha_desde", OracleDbType.Date)
        pDesde.Direction = ParameterDirection.Input
        pDesde.Value = If(fechaDesde Is Nothing, DBNull.Value, fechaDesde)

        Dim pHasta As New OracleParameter("p_fecha_hasta", OracleDbType.Date)
        pHasta.Direction = ParameterDirection.Input
        pHasta.Value = If(fechaHasta Is Nothing, DBNull.Value, fechaHasta)

        Dim ps As New List(Of OracleParameter) From {pTexto, pEstado, pDesde, pHasta}
        Return OracleDb.ExecRefCursor(PKG & ".REC_PROV_BUSCAR", ps, "p_data")
    End Function

    ''' <summary>Crea un reclamo. Comentarios queda NULL hasta RESUELTO o RECHAZADO.</summary>
    Public Shared Function Crear(orcKey As String, descripcion As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey, ParameterDirection.Input),
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".REC_PROV_CREAR", ps, "p_id")
    End Function

    ''' <summary>Actualiza descripcion — solo cuando estado es INICIADO o PENDIENTE.</summary>
    Public Shared Sub Actualizar(id As Decimal, descripcion As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".REC_PROV_ACTUALIZAR", ps)
    End Sub

    ''' <summary>Actualiza solo comentarios — cuando estado es RESUELTO o RECHAZADO.</summary>
    Public Shared Sub ActualizarComentarios(id As Decimal, comentarios As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_coment", OracleDbType.Varchar2, comentarios, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".REC_PROV_ACTUALIZAR_COMENTARIOS", ps)
    End Sub

    ''' <summary>
    ''' Cambia el estado con orden estricto.
    ''' RESUELTO/RECHAZADO guardan comentarios y fecha_final automaticamente.
    ''' </summary>
    Public Shared Sub CambiarEstado(id As Decimal, estado As String, comentarios As String)
        Dim pComent As New OracleParameter("p_coment", OracleDbType.Varchar2)
        pComent.Direction = ParameterDirection.Input
        pComent.Value = If(String.IsNullOrWhiteSpace(comentarios), DBNull.Value, CObj(comentarios.Trim()))

        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_estado", OracleDbType.Varchar2, estado, ParameterDirection.Input),
            pComent
        }
        OracleDb.ExecNonQuery(PKG & ".REC_PROV_CAMBIAR_ESTADO", ps)
    End Sub

    Public Shared Sub Eliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".REC_PROV_ELIMINAR", ps)
    End Sub

    Public Shared Function EsEstadoDeCierre(estado As String) As Boolean
        Dim pEstado As New OracleParameter("p_estado", OracleDbType.Varchar2, estado, ParameterDirection.Input)
        Dim pResultado As New OracleParameter("p_resultado", OracleDbType.Decimal)
        pResultado.Direction = ParameterDirection.Output

        Dim ps As New List(Of OracleParameter) From {pEstado, pResultado}
        OracleDb.ExecNonQuery(PKG & ".REC_PROV_ES_CIERRE", ps)

        If pResultado.Value IsNot Nothing AndAlso Not IsDBNull(pResultado.Value) Then
            Return Convert.ToInt32(pResultado.Value.ToString()) = 1
        End If
        Return False
    End Function

End Class