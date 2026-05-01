Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' ============================================================
' RUTA: App_Code/Services/ComprasProveedor/PedidoService.vb
' Package: PKG_CP_BOD_PEDIDO
' ============================================================
Public Class PedidoService

    Private Const PKG As String = "PKG_CP_BOD_PEDIDO"

    ''' <summary>
    ''' Crea un pedido y devuelve el ID generado por Oracle.
    ''' El codigo (ej: PED-12) lo genera el propio paquete Oracle usando
    ''' la constante C_PREFIJO_PEDIDO definida en PKG_CP_BOD_PEDIDO body.
    ''' Para cambiar el prefijo edita esa constante en Oracle; no hay nada
    ''' que modificar en este servicio ni en el code-behind.
    ''' </summary>
    Public Shared Function Crear(formaPago As String, total As Decimal) As Decimal
        Dim pId As New OracleParameter("p_id", OracleDbType.Decimal)
        pId.Direction = ParameterDirection.Output
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_forma_pago", OracleDbType.Varchar2, formaPago, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input),
            pId
        }
        OracleDb.ExecNonQuery(PKG & ".PED_CREAR", ps)
        If pId.Value IsNot Nothing AndAlso Not IsDBNull(pId.Value) Then
            Return Convert.ToDecimal(pId.Value.ToString())
        End If
        Return 0
    End Function

    ''' <summary>Obtiene un pedido por ID.</summary>
    Public Shared Function ObtenerPorId(id As Decimal) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".PED_OBTENER_ID", ps, "p_data")
    End Function

    ''' <summary>Actualiza cabecera del pedido.</summary>
    Public Shared Sub Actualizar(id As Decimal, codigo As String, formaPago As String, total As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_codigo", OracleDbType.Varchar2, codigo, ParameterDirection.Input),
            New OracleParameter("p_forma_pago", OracleDbType.Varchar2, formaPago, ParameterDirection.Input),
            New OracleParameter("p_total", OracleDbType.Decimal, total, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".PED_ACTUALIZAR", ps)
    End Sub

    ''' <summary>Lista todos los pedidos.</summary>
    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".PED_LISTAR", Nothing, "p_data")
    End Function

    ''' <summary>Busca pedidos por codigo, producto o material.</summary>
    Public Shared Function Buscar(codigo As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_codigo", OracleDbType.Varchar2, If(codigo, String.Empty), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".PED_BUSCAR", ps, "p_data")
    End Function

    ''' <summary>Elimina el pedido y sus detalles.</summary>
    Public Shared Sub Eliminar(id As Decimal)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".PED_ELIMINAR", ps)
    End Sub

    ''' <summary>
    ''' Devuelve las formas de pago configuradas en PKG_CP_BOD_PEDIDO (funcion C_FORMAS_PAGO).
    ''' Columnas: FORMA_PAGO (valor), DESCRIPCION (texto para UI).
    ''' Para agregar o quitar formas de pago edita el array C_FORMAS_PAGO en el package body.
    ''' </summary>
    Public Shared Function ListarFormasPago() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".PED_LISTAR_FORMAS_PAGO", Nothing, "p_data")
    End Function

End Class