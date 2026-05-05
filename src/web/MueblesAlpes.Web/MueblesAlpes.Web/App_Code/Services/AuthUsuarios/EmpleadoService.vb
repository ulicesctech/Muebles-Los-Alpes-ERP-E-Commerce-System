Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class EmpleadoService
    Private Const PKG As String = "PKG_RH_EMPLEADO"

    Public Shared Function Crear(dpi As String, primerNombre As String, segundoNombre As String,
                              primerApellido As String, segundoApellido As String,
                              direccion As String, avenida As String, codigoPostal As String,
                              primerTelefono As String, segundoTelefono As String,
                              rolUsuario As Integer,
                              password As String) As Integer

        Dim pId As New OracleParameter("p_id", OracleDbType.Decimal, ParameterDirection.Output)

        Dim pSegNom As New OracleParameter("p_s_nom", OracleDbType.Varchar2, 100)
        pSegNom.Direction = ParameterDirection.Input
        pSegNom.Value = If(String.IsNullOrWhiteSpace(segundoNombre), DBNull.Value, CObj(segundoNombre.Trim()))

        Dim pSegApe As New OracleParameter("p_s_ape", OracleDbType.Varchar2, 100)
        pSegApe.Direction = ParameterDirection.Input
        pSegApe.Value = If(String.IsNullOrWhiteSpace(segundoApellido), DBNull.Value, CObj(segundoApellido.Trim()))

        Dim pTel2 As New OracleParameter("p_tel2", OracleDbType.Varchar2, 20)
        pTel2.Direction = ParameterDirection.Input
        pTel2.Value = If(String.IsNullOrWhiteSpace(segundoTelefono), DBNull.Value, CObj(segundoTelefono.Trim()))

        Dim ps As New List(Of OracleParameter) From {
        New OracleParameter("p_dpi", OracleDbType.Varchar2, dpi, ParameterDirection.Input),
        New OracleParameter("p_p_nom", OracleDbType.Varchar2, primerNombre, ParameterDirection.Input),
        pSegNom,
        New OracleParameter("p_p_ape", OracleDbType.Varchar2, primerApellido, ParameterDirection.Input),
        pSegApe,
        New OracleParameter("p_dir", OracleDbType.Varchar2, direccion, ParameterDirection.Input),
        New OracleParameter("p_ave", OracleDbType.Varchar2, avenida, ParameterDirection.Input),
        New OracleParameter("p_cp", OracleDbType.Varchar2, codigoPostal, ParameterDirection.Input),
        New OracleParameter("p_tel1", OracleDbType.Varchar2, primerTelefono, ParameterDirection.Input),
        pTel2,
        New OracleParameter("p_rol", OracleDbType.Decimal, rolUsuario, ParameterDirection.Input),
        pId
    }
        OracleDb.ExecNonQuery(PKG & ".emp_crear", ps)
        Dim nuevoId As Integer = Convert.ToInt32(pId.Value.ToString())

        ' Usuario = DPI, password = asignado por quien crea
        LoginEmpleadoService.Crear(nuevoId, dpi.Trim(), password.Trim())
        Return nuevoId
    End Function

    Public Shared Sub Actualizar(id As Integer, dpi As String, primerNombre As String,
                                  segundoNombre As String, primerApellido As String,
                                  segundoApellido As String, direccion As String,
                                  avenida As String, codigoPostal As String,
                                  primerTelefono As String, segundoTelefono As String,
                                  rolUsuario As Integer)

        Dim pSegNom As New OracleParameter("p_s_nom", OracleDbType.Varchar2, 100)
        pSegNom.Direction = ParameterDirection.Input
        pSegNom.Value = If(String.IsNullOrWhiteSpace(segundoNombre), DBNull.Value, CObj(segundoNombre.Trim()))

        Dim pSegApe As New OracleParameter("p_s_ape", OracleDbType.Varchar2, 100)
        pSegApe.Direction = ParameterDirection.Input
        pSegApe.Value = If(String.IsNullOrWhiteSpace(segundoApellido), DBNull.Value, CObj(segundoApellido.Trim()))

        Dim pTel2 As New OracleParameter("p_tel2", OracleDbType.Varchar2, 20)
        pTel2.Direction = ParameterDirection.Input
        pTel2.Value = If(String.IsNullOrWhiteSpace(segundoTelefono), DBNull.Value, CObj(segundoTelefono.Trim()))

        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_dpi", OracleDbType.Varchar2, dpi, ParameterDirection.Input),
            New OracleParameter("p_p_nom", OracleDbType.Varchar2, primerNombre, ParameterDirection.Input),
            pSegNom,
            New OracleParameter("p_p_ape", OracleDbType.Varchar2, primerApellido, ParameterDirection.Input),
            pSegApe,
            New OracleParameter("p_dir", OracleDbType.Varchar2, direccion, ParameterDirection.Input),
            New OracleParameter("p_ave", OracleDbType.Varchar2, avenida, ParameterDirection.Input),
            New OracleParameter("p_cp", OracleDbType.Varchar2, codigoPostal, ParameterDirection.Input),
            New OracleParameter("p_tel1", OracleDbType.Varchar2, primerTelefono, ParameterDirection.Input),
            pTel2,
            New OracleParameter("p_rol", OracleDbType.Decimal, rolUsuario, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".emp_actualizar", ps)
    End Sub

    Public Shared Sub Eliminar(id As Integer)
        OracleDb.ExecNonQuery(PKG & ".emp_eliminar",
            New List(Of OracleParameter) From {
                New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
            })
    End Sub

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".emp_listar", Nothing, "p_data")
    End Function

    Public Shared Function Buscar(id As Integer) As DataTable
        Dim dt As DataTable = Listar()
        Dim result As DataTable = dt.Clone()
        For Each row As DataRow In dt.Rows
            If Convert.ToInt32(row("em_empleado")) = id Then
                result.ImportRow(row)
            End If
        Next
        Return result
    End Function
End Class