Imports System.Collections.Generic
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class ClienteService
    Private Const PKG As String = "PKG_CLI_CLIENTE"

    Public Shared Function Crear(tipoDoc As String, numDoc As String, nit As String,
                                  primerNombre As String, segundoNombre As String,
                                  primerApellido As String, segundoApellido As String,
                                  pais As String, departamento As String, municipio As String,
                                  zona As String, direccion As String, codigoPostal As String,
                                  primerTelefono As String, segundoTelefono As String,
                                  email As String, profesion As String,
                                  tipoCliente As String) As Integer
        Dim pId As New OracleParameter("p_id", OracleDbType.Decimal, ParameterDirection.Output)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_tipodocumento", OracleDbType.Varchar2, tipoDoc, ParameterDirection.Input),
            New OracleParameter("p_numdocumento", OracleDbType.Varchar2, numDoc, ParameterDirection.Input),
            New OracleParameter("p_nit", OracleDbType.Varchar2, If(String.IsNullOrEmpty(nit), " ", nit), ParameterDirection.Input),
            New OracleParameter("p_primer_nombre", OracleDbType.Varchar2, primerNombre, ParameterDirection.Input),
            New OracleParameter("p_segundo_nombre", OracleDbType.Varchar2, If(String.IsNullOrEmpty(segundoNombre), " ", segundoNombre), ParameterDirection.Input),
            New OracleParameter("p_primer_apellido", OracleDbType.Varchar2, primerApellido, ParameterDirection.Input),
            New OracleParameter("p_segundo_apellido", OracleDbType.Varchar2, If(String.IsNullOrEmpty(segundoApellido), " ", segundoApellido), ParameterDirection.Input),
            New OracleParameter("p_pais", OracleDbType.Varchar2, pais, ParameterDirection.Input),
            New OracleParameter("p_departamento", OracleDbType.Varchar2, departamento, ParameterDirection.Input),
            New OracleParameter("p_municipio", OracleDbType.Varchar2, municipio, ParameterDirection.Input),
            New OracleParameter("p_zona", OracleDbType.Varchar2, zona, ParameterDirection.Input),
            New OracleParameter("p_direccion", OracleDbType.Varchar2, direccion, ParameterDirection.Input),
            New OracleParameter("p_codigo_postal", OracleDbType.Varchar2, codigoPostal, ParameterDirection.Input),
            New OracleParameter("p_primer_telefono", OracleDbType.Varchar2, primerTelefono, ParameterDirection.Input),
            New OracleParameter("p_segundo_telefono", OracleDbType.Varchar2, If(String.IsNullOrEmpty(segundoTelefono), " ", segundoTelefono), ParameterDirection.Input),
            New OracleParameter("p_email", OracleDbType.Varchar2, email, ParameterDirection.Input),
            New OracleParameter("p_profesion", OracleDbType.Varchar2, If(String.IsNullOrEmpty(profesion), " ", profesion), ParameterDirection.Input),
            New OracleParameter("p_tipocliente", OracleDbType.Varchar2, tipoCliente, ParameterDirection.Input),
            pId
        }
        OracleDb.ExecNonQuery(PKG & ".cli_crear", ps)
        Return Convert.ToInt32(pId.Value.ToString())
    End Function

    Public Shared Sub Actualizar(id As Integer, tipoDoc As String, numDoc As String,
                                  nit As String, primerNombre As String, segundoNombre As String,
                                  primerApellido As String, segundoApellido As String,
                                  pais As String, departamento As String, municipio As String,
                                  zona As String, direccion As String, codigoPostal As String,
                                  primerTelefono As String, segundoTelefono As String,
                                  email As String, profesion As String, tipoCliente As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input),
            New OracleParameter("p_tipodocumento", OracleDbType.Varchar2, tipoDoc, ParameterDirection.Input),
            New OracleParameter("p_numdocumento", OracleDbType.Varchar2, numDoc, ParameterDirection.Input),
            New OracleParameter("p_nit", OracleDbType.Varchar2, If(String.IsNullOrEmpty(nit), " ", nit), ParameterDirection.Input),
            New OracleParameter("p_primer_nombre", OracleDbType.Varchar2, primerNombre, ParameterDirection.Input),
            New OracleParameter("p_segundo_nombre", OracleDbType.Varchar2, If(String.IsNullOrEmpty(segundoNombre), " ", segundoNombre), ParameterDirection.Input),
            New OracleParameter("p_primer_apellido", OracleDbType.Varchar2, primerApellido, ParameterDirection.Input),
            New OracleParameter("p_segundo_apellido", OracleDbType.Varchar2, If(String.IsNullOrEmpty(segundoApellido), " ", segundoApellido), ParameterDirection.Input),
            New OracleParameter("p_pais", OracleDbType.Varchar2, pais, ParameterDirection.Input),
            New OracleParameter("p_departamento", OracleDbType.Varchar2, departamento, ParameterDirection.Input),
            New OracleParameter("p_municipio", OracleDbType.Varchar2, municipio, ParameterDirection.Input),
            New OracleParameter("p_zona", OracleDbType.Varchar2, zona, ParameterDirection.Input),
            New OracleParameter("p_direccion", OracleDbType.Varchar2, direccion, ParameterDirection.Input),
            New OracleParameter("p_codigo_postal", OracleDbType.Varchar2, codigoPostal, ParameterDirection.Input),
            New OracleParameter("p_primer_telefono", OracleDbType.Varchar2, primerTelefono, ParameterDirection.Input),
            New OracleParameter("p_segundo_telefono", OracleDbType.Varchar2, If(String.IsNullOrEmpty(segundoTelefono), " ", segundoTelefono), ParameterDirection.Input),
            New OracleParameter("p_email", OracleDbType.Varchar2, email, ParameterDirection.Input),
            New OracleParameter("p_profesion", OracleDbType.Varchar2, If(String.IsNullOrEmpty(profesion), " ", profesion), ParameterDirection.Input),
            New OracleParameter("p_tipocliente", OracleDbType.Varchar2, tipoCliente, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".cli_actualizar", ps)
    End Sub

    Public Shared Sub Eliminar(id As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".cli_eliminar", ps)
    End Sub

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".cli_listar", Nothing, "p_cursor")
    End Function

    Public Shared Function BuscarPorId(id As Integer) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, id, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".cli_buscar_id", ps, "p_cursor")
    End Function

    Public Shared Function BuscarPorEmail(email As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_email", OracleDbType.Varchar2, email, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".cli_buscar_email", ps, "p_cursor")
    End Function

    Public Shared Function BuscarPorDocumento(numDoc As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_numdocumento", OracleDbType.Varchar2, numDoc, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".cli_buscar_documento", ps, "p_cursor")
    End Function
End Class