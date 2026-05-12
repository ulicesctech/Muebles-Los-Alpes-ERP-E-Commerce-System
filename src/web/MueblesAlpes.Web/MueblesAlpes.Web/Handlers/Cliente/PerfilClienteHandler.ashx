<%@ WebHandler Language="VB" Class="PerfilClienteHandler" %>
Imports System.Web
Imports System.Data
Imports System.Collections.Generic
Imports Newtonsoft.Json
Imports Oracle.ManagedDataAccess.Client

Public Class PerfilClienteHandler
    Implements IHttpHandler

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        Dim action As String = context.Request("action")

        Try
            Select Case action
                Case "obtener" : ObtenerPerfil(context)
                Case "actualizar" : ActualizarPerfil(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""ok"": false, ""mensaje"": ""Accion no reconocida.""}")
            End Select
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write("{""ok"": false, ""mensaje"": """ & ex.Message.Replace("""", "\""") & """}")
        End Try
    End Sub

    Private Sub ObtenerPerfil(context As HttpContext)
        Dim clienteId As Integer = Convert.ToInt32(context.Request("clienteId"))
        Dim dt As DataTable = OracleDb.ExecRefCursor(
            "PKG_CLI_CLIENTE.CLI_BUSCAR",
            New List(Of OracleParameter) From {
                New OracleParameter("p_texto", OracleDbType.Varchar2, "", ParameterDirection.Input)
            }, "p_data")

        For Each row As DataRow In dt.Rows
            If Convert.ToInt32(row("CLI_CLIENTE")) = clienteId Then
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok = True,
                    .data = New With {
                        .CLI_TIPODOCUMENTO = row("CLI_TIPODOCUMENTO"),
                        .CLI_NUMDOCUMENTO = row("CLI_NUMDOCUMENTO"),
                        .CLI_NIT = If(IsDBNull(row("CLI_NIT")), "", row("CLI_NIT")),
                        .CLI_PRIMER_NOMBRE = row("CLI_PRIMER_NOMBRE"),
                        .CLI_SEGUNDO_NOMBRE = If(IsDBNull(row("CLI_SEGUNDO_NOMBRE")), "", row("CLI_SEGUNDO_NOMBRE")),
                        .CLI_PRIMER_APELLIDO = row("CLI_PRIMER_APELLIDO"),
                        .CLI_SEGUNDO_APELLIDO = If(IsDBNull(row("CLI_SEGUNDO_APELLIDO")), "", row("CLI_SEGUNDO_APELLIDO")),
                        .CLI_EMAIL = row("CLI_EMAIL"),
                        .CLI_PROFESION = If(IsDBNull(row("CLI_PROFESION")), "", row("CLI_PROFESION")),
                        .CLI_PRIMER_TELEFONO = row("CLI_PRIMER_TELEFONO"),
                        .CLI_SEGUNDO_TELEFONO = If(IsDBNull(row("CLI_SEGUNDO_TELEFONO")), "", row("CLI_SEGUNDO_TELEFONO")),
                        .CLI_PAIS = row("CLI_PAIS"),
                        .CLI_DEPARTAMENTO = row("CLI_DEPARTAMENTO"),
                        .CLI_MUNICIPIO = row("CLI_MUNICIPIO"),
                        .CLI_ZONA = row("CLI_ZONA"),
                        .CLI_CODIGO_POSTAL = If(IsDBNull(row("CLI_CODIGO_POSTAL")), "", row("CLI_CODIGO_POSTAL")),
                        .CLI_DIRECCION = row("CLI_DIRECCION")
                    }
                }))
                Return
            End If
        Next
        context.Response.StatusCode = 404
        context.Response.Write("{""ok"": false, ""mensaje"": ""Cliente no encontrado.""}")
    End Sub

    Private Sub ActualizarPerfil(context As HttpContext)
        Dim clienteId As Integer = Convert.ToInt32(context.Request("clienteId"))
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_id", OracleDbType.Decimal, clienteId, ParameterDirection.Input),
            New OracleParameter("p_tipodoc", OracleDbType.Varchar2, context.Request("tipoDoc"), ParameterDirection.Input),
            New OracleParameter("p_numdoc", OracleDbType.Varchar2, context.Request("numDoc"), ParameterDirection.Input),
            New OracleParameter("p_p_nom", OracleDbType.Varchar2, context.Request("primerNombre"), ParameterDirection.Input),
            New OracleParameter("p_s_nom", OracleDbType.Varchar2, If(context.Request("segundoNombre"), ""), ParameterDirection.Input),
            New OracleParameter("p_p_ape", OracleDbType.Varchar2, context.Request("primerApellido"), ParameterDirection.Input),
            New OracleParameter("p_s_ape", OracleDbType.Varchar2, If(context.Request("segundoApellido"), ""), ParameterDirection.Input),
            New OracleParameter("p_pais", OracleDbType.Varchar2, If(context.Request("pais"), "Guatemala"), ParameterDirection.Input),
            New OracleParameter("p_dep", OracleDbType.Varchar2, If(context.Request("departamento"), "Guatemala"), ParameterDirection.Input),
            New OracleParameter("p_mun", OracleDbType.Varchar2, If(context.Request("municipio"), "Guatemala"), ParameterDirection.Input),
            New OracleParameter("p_zona", OracleDbType.Varchar2, If(context.Request("zona"), "0"), ParameterDirection.Input),
            New OracleParameter("p_dir", OracleDbType.Varchar2, If(context.Request("direccion"), ""), ParameterDirection.Input),
            New OracleParameter("p_cp", OracleDbType.Varchar2, If(context.Request("codigoPostal"), ""), ParameterDirection.Input),
            New OracleParameter("p_tel1", OracleDbType.Varchar2, If(context.Request("tel1"), ""), ParameterDirection.Input),
            New OracleParameter("p_tel2", OracleDbType.Varchar2, If(context.Request("tel2"), ""), ParameterDirection.Input),
            New OracleParameter("p_email", OracleDbType.Varchar2, context.Request("email"), ParameterDirection.Input),
            New OracleParameter("p_prof", OracleDbType.Varchar2, If(context.Request("profesion"), ""), ParameterDirection.Input),
            New OracleParameter("p_tipocli", OracleDbType.Varchar2, "NATURAL", ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery("PKG_CLI_CLIENTE.CLI_ACTUALIZAR", ps)
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True}))
    End Sub

End Class