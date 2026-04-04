Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: App_Code/Services/ComprasProveedor/ReclamoProveedorService.vb
' ============================================================
Public Class ReclamoProveedorService

    Private Const PKG As String = "PKG_CP_FAC_RECLAMO_PROV"

    ' Estados válidos definidos en el paquete Oracle
    ' Estados de cierre (activan rep_fecha_final automáticamente): FINALIZADO, RESUELTO, RECHAZADO
    ' Estados abiertos (rep_fecha_final queda NULL):               INICIADO, PENDIENTE
    Public Shared ReadOnly EstadosDisponibles As String() = {
        "INICIADO", "PENDIENTE", "FINALIZADO", "RESUELTO", "RECHAZADO"
    }
    Public Shared ReadOnly EstadosCierre As String() = {"FINALIZADO", "RESUELTO", "RECHAZADO"}

    ''' <summary>
    ''' Lista todos los reclamos con JOIN a orden de compra y proveedor.
    ''' </summary>
    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".REC_PROV_LISTAR", Nothing, "p_data")
    End Function

    ''' <summary>
    ''' Devuelve un reclamo específico por su ID.
    ''' </summary>
    Public Shared Function ListarPorId(id As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".REC_PROV_LISTAR_ID", ps, "p_data")
    End Function

    ''' <summary>
    ''' Crea un reclamo. El paquete fija estado='INICIADO', fecha_inicio=SYSDATE, fecha_final=NULL.
    ''' Devuelve el ID generado.
    ''' </summary>
    Public Shared Function Crear(orcKey As String, comentarios As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_orc_key", OracleDbType.Varchar2, orcKey,       ParameterDirection.Input),
            New OracleParameter("p_coment",  OracleDbType.Varchar2, comentarios,  ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".REC_PROV_CREAR", ps, "p_id")
    End Function

    ''' <summary>
    ''' Actualiza solo los comentarios del reclamo (no toca estado ni fechas).
    ''' </summary>
    Public Shared Sub Actualizar(id As Decimal, comentarios As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id",     OracleDbType.Decimal,  id,          ParameterDirection.Input),
            New OracleParameter("p_coment", OracleDbType.Varchar2, comentarios, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".REC_PROV_ACTUALIZAR", ps)
    End Sub

    ''' <summary>
    ''' Cambia el estado del reclamo.
    ''' Si el estado es FINALIZADO/RESUELTO/RECHAZADO, el paquete asigna rep_fecha_final=SYSDATE.
    ''' Si el estado es INICIADO/PENDIENTE, rep_fecha_final queda NULL.
    ''' </summary>
    Public Shared Sub CambiarEstado(id As Decimal, estado As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id",     OracleDbType.Decimal,  id,     ParameterDirection.Input),
            New OracleParameter("p_estado", OracleDbType.Varchar2, estado, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".REC_PROV_CAMBIAR_ESTADO", ps)
    End Sub

    Public Shared Sub Eliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".REC_PROV_ELIMINAR", ps)
    End Sub

    ''' <summary>Indica si un estado provoca el cierre automático del reclamo.</summary>
    Public Shared Function EsEstadoDeCierre(estado As String) As Boolean
        Return Array.Exists(EstadosCierre, Function(e) e = estado.ToUpper().Trim())
    End Function

End Class
