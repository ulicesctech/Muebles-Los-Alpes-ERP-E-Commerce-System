Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client


Public Class EmpleadoService
    Private Const PKG As String = "PKG_RH_EMPLEADO"

    Public Shared Function Crear(dpi As String, primerNombre As String, segundoNombre As String,
                                  primerApellido As String, segundoApellido As String,
                                  direccion As String, avenida As String, codigoPostal As String,
                                  primerTelefono As String, segundoTelefono As String,
                                  rolUsuario As Integer) As Integer
        Dim pId As New OracleParameter("p_id", OracleDbType.Decimal, ParameterDirection.Output)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_dpi", OracleDbType.Varchar2, dpi, ParameterDirection.Input),
            New OracleParameter("p_primer_nombre", OracleDbType.Varchar2, primerNombre, ParameterDirection.Input),
            New OracleParameter("p_segundo_nombre", OracleDbType.Varchar2, segundoNombre, ParameterDirection.Input),
            New OracleParameter("p_primer_apellido", OracleDbType.Varchar2, primerApellido, ParameterDirection.Input),
            New OracleParameter("p_segundo_apellido", OracleDbType.Varchar2, segundoApellido, ParameterDirection.Input),
            New OracleParameter("p_direccion", OracleDbType.Varchar2, direccion, ParameterDirection.Input),
            New OracleParameter("p_avenida", OracleDbType.Varchar2, avenida, ParameterDirection.Input),
            New OracleParameter("p_codigo_postal", OracleDbType.Varchar2, codigoPostal, ParameterDirection.Input),
            New OracleParameter("p_primer_telefono", OracleDbType.Varchar2, primerTelefono, ParameterDirection.Input),
            New OracleParameter("p_segundo_telefono", OracleDbType.Varchar2, If(String.IsNullOrEmpty(segundoTelefono), " ", segundoTelefono), ParameterDirection.Input),
            New OracleParameter("p_rol_usuario", OracleDbType.Decimal, rolUsuario, ParameterDirection.Input),
            pId
        }
        OracleDb.ExecNonQuery(PKG & ".em_crear", ps)
        Return Convert.ToInt32(pId.Value.ToString())
    End Function

    Public Shared Sub Actualizar(id As Integer, dpi As String, primerNombre As String,
                                  segundoNombre As String, primerApellido As String,
                                  segundoApellido As String, direccion As String,
                                  avenida As String, codigoPostal As String,
                                  primerTelefono As String, segundoTelefono As String,
                                  rolUsuario As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_dpi", OracleDbType.Varchar2, dpi, ParameterDirection.Input),
            New OracleParameter("p_primer_nombre", OracleDbType.Varchar2, primerNombre, ParameterDirection.Input),
            New OracleParameter("p_segundo_nombre", OracleDbType.Varchar2, segundoNombre, ParameterDirection.Input),
            New OracleParameter("p_primer_apellido", OracleDbType.Varchar2, primerApellido, ParameterDirection.Input),
            New OracleParameter("p_segundo_apellido", OracleDbType.Varchar2, segundoApellido, ParameterDirection.Input),
            New OracleParameter("p_direccion", OracleDbType.Varchar2, direccion, ParameterDirection.Input),
            New OracleParameter("p_avenida", OracleDbType.Varchar2, avenida, ParameterDirection.Input),
            New OracleParameter("p_codigo_postal", OracleDbType.Varchar2, codigoPostal, ParameterDirection.Input),
            New OracleParameter("p_primer_telefono", OracleDbType.Varchar2, primerTelefono, ParameterDirection.Input),
            New OracleParameter("p_segundo_telefono", OracleDbType.Varchar2, If(String.IsNullOrEmpty(segundoTelefono), " ", segundoTelefono), ParameterDirection.Input),
            New OracleParameter("p_rol_usuario", OracleDbType.Decimal, rolUsuario, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".em_actualizar", ps)
    End Sub

    Public Shared Sub Eliminar(id As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".em_eliminar", ps)
    End Sub

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".em_listar", Nothing, "p_cursor")
    End Function

    Public Shared Function Buscar(id As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".em_buscar", ps, "p_cursor")
    End Function
End Class