Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/NicAlmService.vb
' Package: PKG_BOD_NIC_ALM
' ============================================================
Public Class NicAlmService

    Private Const PKG As String = "PKG_BOD_NIC_ALM"

    ''' <summary>
    ''' Asigna un nicho a un almacén. Devuelve el ID generado.
    ''' </summary>
    Public Shared Function Asignar(nicNicho As Decimal, almAlmacen As Decimal) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_nic_nicho", OracleDbType.Decimal, nicNicho, ParameterDirection.Input),
            New OracleParameter("p_alm_almacen", OracleDbType.Decimal, almAlmacen, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".ASIGNAR", ps, "p_id")
    End Function

    ''' <summary>
    ''' Quita (elimina) la asignación nicho-almacén por su ID.
    ''' </summary>
    Public Shared Sub Quitar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".QUITAR", ps)
    End Sub

    ''' <summary>
    ''' Lista todas las asignaciones nicho-almacén.
    ''' </summary>
    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    ''' <summary>
    ''' Lista los nichos asignados a un almacén específico.
    ''' </summary>
    Public Shared Function ListarPorAlmacen(almAlmacen As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_alm_almacen", OracleDbType.Decimal, almAlmacen, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_ALMACEN", ps, "p_data")
    End Function

End Class