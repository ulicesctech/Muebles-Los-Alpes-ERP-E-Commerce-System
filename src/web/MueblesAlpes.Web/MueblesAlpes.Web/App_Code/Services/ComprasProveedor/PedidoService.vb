Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class PedidoService
    Private Const PKG As String = "PKG_CP_BOD_PEDIDO"

    ''' <summary>
    ''' Crea un pedido y devuelve el ID generado por la base de datos.
    ''' </summary>
    Public Shared Function Crear(codigo As String, formaPago As String, total As Decimal) As Decimal
        ' Importante: Definir el parámetro de salida explícitamente
        Dim pId As New OracleParameter("p_id", OracleDbType.Decimal)
        pId.Direction = ParameterDirection.Output

        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
            New OracleParameter("p_forma_pago", OracleDbType.Varchar2, formaPago, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input),
            pId
        }

        ' Ejecutamos
        OracleDb.ExecNonQuery(PKG & ".PED_CREAR", ps)

        ' Validación de seguridad para el retorno
        If pId.Value IsNot Nothing AndAlso Not IsDBNull(pId.Value) Then
            Return Convert.ToDecimal(pId.Value.ToString())
        End If

        Return 0
    End Function

    ''' <summary>
    ''' Recupera un registro único. 
    ''' SI SIGUE DANDO ERROR: Verifica si en el Package de Oracle el nombre es 
    ''' exacto: PED_OBTENER_ID
    ''' </summary>
    Public Shared Function ObtenerPorId(id As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        ' Cambié el nombre del parámetro de salida a "p_data" para que coincida con tu OracleDb.ExecRefCursor
        Return OracleDb.ExecRefCursor(PKG & ".PED_OBTENER_ID", ps, "p_data")
    End Function

    Public Shared Sub Actualizar(id As Decimal, codigo As String, formaPago As String, total As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
            New OracleParameter("p_forma_pago", OracleDbType.Varchar2, formaPago, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".PED_ACTUALIZAR", ps)
    End Sub

    Public Shared Function Listar() As DataTable
        ' Enviamos Nothing en parámetros ya que Listar usualmente solo requiere el cursor de salida
        Return OracleDb.ExecRefCursor(PKG & ".PED_LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Buscar(codigo As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_codigo", OracleDbType.Varchar2, If(codigo, String.Empty), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".PED_BUSCAR", ps, "p_data")
    End Function

    Public Shared Sub Eliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".PED_ELIMINAR", ps)
    End Sub
End Class