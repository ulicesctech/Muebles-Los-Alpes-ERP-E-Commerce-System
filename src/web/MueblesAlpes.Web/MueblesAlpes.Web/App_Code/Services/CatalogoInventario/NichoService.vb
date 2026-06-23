Imports Oracle.ManagedDataAccess.Client
Imports System.Data
' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/NichoService.vb
' Package: PKG_BOD_NICHO
' ============================================================
Public Class NichoService
    Private Const PKG As String = "PKG_BOD_NICHO"

    ''' <summary>
    ''' Crea el nicho y lo asigna al almacen en una sola transaccion.
    ''' </summary>
    Public Shared Sub CrearYAsignar(numero As String,
                                    zona As String,
                                    caracteristica As String,
                                    almacenId As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_numero", OracleDbType.Varchar2, numero, ParameterDirection.Input),
            New OracleParameter("p_zona", OracleDbType.Varchar2, zona, ParameterDirection.Input),
            New OracleParameter("p_caracteristica", OracleDbType.Varchar2, caracteristica, ParameterDirection.Input),
            New OracleParameter("p_alm_almacen", OracleDbType.Decimal, almacenId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".CREAR_Y_ASIGNAR", ps)
    End Sub

    ''' <summary>Actualiza datos de un nicho existente.</summary>
    Public Shared Sub Actualizar(id As Decimal, numero As String, zona As String, caracteristica As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_numero", OracleDbType.Varchar2, numero, ParameterDirection.Input),
            New OracleParameter("p_zona", OracleDbType.Varchar2, zona, ParameterDirection.Input),
            New OracleParameter("p_caracteristica", OracleDbType.Varchar2, caracteristica, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ACTUALIZAR", ps)
    End Sub

    ''' <summary>Elimina el nicho y su asignacion. Solo si no tiene historial de precio.</summary>
    Public Shared Sub Eliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ELIMINAR", ps)
    End Sub

    ''' <summary>Lista todos los nichos con su almacen.</summary>
    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    ''' <summary>Lista los nichos de un almacen especifico.</summary>
    Public Shared Function ListarPorAlmacen(almacenId As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_alm_almacen", OracleDbType.Decimal, almacenId, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR_POR_ALMACEN", ps, "p_data")
    End Function

End Class