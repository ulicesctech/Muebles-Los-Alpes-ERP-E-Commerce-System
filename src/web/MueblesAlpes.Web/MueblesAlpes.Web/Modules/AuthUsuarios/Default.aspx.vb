Imports System
Imports System.Configuration
Imports System.Web
Imports System.Web.UI
Imports Oracle.ManagedDataAccess.Client

Namespace MueblesAlpes.Web.Modules.AuthUsuarios
    Partial Public Class DefaultPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        End Sub

        Protected Sub btnTest_Click(sender As Object, e As EventArgs)
            Try
                Dim connString As String = ConfigurationManager.ConnectionStrings("MUEBLEDB_PRUEBA").ConnectionString
                Using conn As New OracleConnection(connString)
                    conn.Open()
                    Dim cmd As New OracleCommand("SELECT COUNT(*) FROM ADMIN_PERMISOS", conn)
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    Dim script As String = "alert('OK! Permisos: " & count & "');"
                    ClientScript.RegisterStartupScript(Me.GetType(), "testOk", script, True)
                End Using
            Catch ex As Exception
                Dim msg As String = HttpUtility.JavaScriptStringEncode(ex.Message)
                Dim scriptErr As String = "alert('ERROR: " & msg & "');"
                ClientScript.RegisterStartupScript(Me.GetType(), "testErr", scriptErr, True)
            End Try
        End Sub
    End Class
End Namespace