Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class PedidoService
    Private Const PKG As String = "PKG_CP_BOD_PEDIDO"

    ''' <summary>
    ''' Crea un pedido y devuelve el ID generado por la base de datos.
    ''' </summary>
    Public Shared Function Crear(codigo As String, formaPago As String, total As Decimal) As Integer
        Dim pId As New OracleParameter("p_id", OracleDbType.Decimal, ParameterDirection.Output)
        Dim ps As New List(Of OracleParameter) From {
        New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
        New OracleParameter("p_forma_pago", OracleDbType.Varchar2, formaPago, ParameterDirection.Input),
        New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input),
        pId
    }

        OracleDb.ExecNonQuery(PKG & ".PED_CREAR", ps)

        ' Retornamos el ID generado por si necesitas usarlo de inmediato
        Return Convert.ToInt32(pId.Value.ToString())
    End Function

    Public Shared Sub Actualizar(id As Integer, codigo As String, formaPago As String, total As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
            New OracleParameter("p_forma_pago", OracleDbType.Varchar2, formaPago, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".PED_ACTUALIZAR", ps)
    End Sub

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".PED_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Buscar(codigo As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_codigo", OracleDbType.Varchar2, If(codigo, ""), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".PED_BUSCAR", ps, "p_data")
    End Function

    Public Shared Sub Eliminar(id As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".PED_ELIMINAR", ps)
    End Sub
End Class