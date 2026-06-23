Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class ClienteService
    Private Const PKG As String = "PKG_CLI_CLIENTE"

    Public Shared Function Crear(tipoDoc As String, numDoc As String, nit As String,
                              primerNombre As String, segundoNombre As String,
                              primerApellido As String, segundoApellido As String,
                              pais As String, departamento As String, municipio As String,
                              zona As String, direccion As String, codigoPostal As String,
                              primerTelefono As String, segundoTelefono As String,
                              email As String, profesion As String,
                              tipoCliente As String,
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

        Dim pProf As New OracleParameter("p_prof", OracleDbType.Varchar2, 100)
        pProf.Direction = ParameterDirection.Input
        pProf.Value = If(String.IsNullOrWhiteSpace(profesion), DBNull.Value, CObj(profesion.Trim()))

        Dim ps As New List(Of OracleParameter) From {
        New OracleParameter("p_tipodoc", OracleDbType.Varchar2, tipoDoc, ParameterDirection.Input),
        New OracleParameter("p_numdoc", OracleDbType.Varchar2, numDoc, ParameterDirection.Input),
        New OracleParameter("p_p_nom", OracleDbType.Varchar2, primerNombre, ParameterDirection.Input),
        pSegNom,
        New OracleParameter("p_p_ape", OracleDbType.Varchar2, primerApellido, ParameterDirection.Input),
        pSegApe,
        New OracleParameter("p_pais", OracleDbType.Varchar2, pais, ParameterDirection.Input),
        New OracleParameter("p_dep", OracleDbType.Varchar2, departamento, ParameterDirection.Input),
        New OracleParameter("p_mun", OracleDbType.Varchar2, municipio, ParameterDirection.Input),
        New OracleParameter("p_zona", OracleDbType.Varchar2, zona, ParameterDirection.Input),
        New OracleParameter("p_dir", OracleDbType.Varchar2, direccion, ParameterDirection.Input),
        New OracleParameter("p_cp", OracleDbType.Varchar2, codigoPostal, ParameterDirection.Input),
        New OracleParameter("p_tel1", OracleDbType.Varchar2, primerTelefono, ParameterDirection.Input),
        pTel2,
        New OracleParameter("p_email", OracleDbType.Varchar2, email, ParameterDirection.Input),
        pProf,
        New OracleParameter("p_tipocli", OracleDbType.Varchar2, tipoCliente, ParameterDirection.Input),
        pId
    }
        OracleDb.ExecNonQuery(PKG & ".cli_crear", ps)
        Dim nuevoId As Integer = Convert.ToInt32(pId.Value.ToString())

        ' Crear login: usuario=email, password=elegido por cliente o asignado por admin
        LoginClienteService.Crear(nuevoId, email.ToLower().Trim(), password.Trim())
        Return nuevoId
    End Function

    Public Shared Sub Actualizar(id As Integer, tipoDoc As String, numDoc As String,
                                  nit As String, primerNombre As String, segundoNombre As String,
                                  primerApellido As String, segundoApellido As String,
                                  pais As String, departamento As String, municipio As String,
                                  zona As String, direccion As String, codigoPostal As String,
                                  primerTelefono As String, segundoTelefono As String,
                                  email As String, profesion As String, tipoCliente As String)

        Dim pSegNom As New OracleParameter("p_s_nom", OracleDbType.Varchar2, 100)
        pSegNom.Direction = ParameterDirection.Input
        pSegNom.Value = If(String.IsNullOrWhiteSpace(segundoNombre), DBNull.Value, CObj(segundoNombre.Trim()))

        Dim pSegApe As New OracleParameter("p_s_ape", OracleDbType.Varchar2, 100)
        pSegApe.Direction = ParameterDirection.Input
        pSegApe.Value = If(String.IsNullOrWhiteSpace(segundoApellido), DBNull.Value, CObj(segundoApellido.Trim()))

        Dim pTel2 As New OracleParameter("p_tel2", OracleDbType.Varchar2, 20)
        pTel2.Direction = ParameterDirection.Input
        pTel2.Value = If(String.IsNullOrWhiteSpace(segundoTelefono), DBNull.Value, CObj(segundoTelefono.Trim()))

        Dim pProf As New OracleParameter("p_prof", OracleDbType.Varchar2, 100)
        pProf.Direction = ParameterDirection.Input
        pProf.Value = If(String.IsNullOrWhiteSpace(profesion), DBNull.Value, CObj(profesion.Trim()))

        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_tipodoc", OracleDbType.Varchar2, tipoDoc, ParameterDirection.Input),
            New OracleParameter("p_numdoc", OracleDbType.Varchar2, numDoc, ParameterDirection.Input),
            New OracleParameter("p_p_nom", OracleDbType.Varchar2, primerNombre, ParameterDirection.Input),
            pSegNom,
            New OracleParameter("p_p_ape", OracleDbType.Varchar2, primerApellido, ParameterDirection.Input),
            pSegApe,
            New OracleParameter("p_pais", OracleDbType.Varchar2, pais, ParameterDirection.Input),
            New OracleParameter("p_dep", OracleDbType.Varchar2, departamento, ParameterDirection.Input),
            New OracleParameter("p_mun", OracleDbType.Varchar2, municipio, ParameterDirection.Input),
            New OracleParameter("p_zona", OracleDbType.Varchar2, zona, ParameterDirection.Input),
            New OracleParameter("p_dir", OracleDbType.Varchar2, direccion, ParameterDirection.Input),
            New OracleParameter("p_cp", OracleDbType.Varchar2, codigoPostal, ParameterDirection.Input),
            New OracleParameter("p_tel1", OracleDbType.Varchar2, primerTelefono, ParameterDirection.Input),
            pTel2,
            New OracleParameter("p_email", OracleDbType.Varchar2, email, ParameterDirection.Input),
            pProf,
            New OracleParameter("p_tipocli", OracleDbType.Varchar2, tipoCliente, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".cli_actualizar", ps)
    End Sub

    Public Shared Sub Eliminar(id As Integer)
        OracleDb.ExecNonQuery(PKG & ".cli_eliminar",
            New List(Of OracleParameter) From {
                New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
            })
    End Sub

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".cli_listar", Nothing, "p_data")
    End Function

    Public Shared Function BuscarPorId(clienteId As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
        New OracleParameter("p_id", OracleDbType.Decimal, clienteId, ParameterDirection.Input)
    }
        Return OracleDb.ExecRefCursor("PKG_CLI_CLIENTE.CLI_BUSCAR_POR_ID", ps, "p_data")
    End Function

    Public Shared Function BuscarPorEmail(email As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
        New OracleParameter("p_email", OracleDbType.Varchar2, email, ParameterDirection.Input)
    }
        Return OracleDb.ExecRefCursor("PKG_CLI_CLIENTE.CLI_BUSCAR_POR_EMAIL", ps, "p_data")
    End Function

    Public Shared Function BuscarPorDocumento(numDoc As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_texto", OracleDbType.Varchar2, numDoc, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".cli_buscar", ps, "p_data")
    End Function
End Class