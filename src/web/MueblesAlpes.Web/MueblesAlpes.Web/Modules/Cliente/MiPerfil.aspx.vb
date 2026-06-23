Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.Cliente

    Public Class MiPerfil
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                If Session("CLI_CLIENTE") Is Nothing Then
                    pnlNoLogin.Visible = True
                    Return
                End If
                pnlPerfil.Visible = True
                CargarDatos()
            End If
        End Sub

        Private Sub CargarDatos()
            Try
                Dim clienteId As Integer = Convert.ToInt32(Session("CLI_CLIENTE"))
                Dim dt As DataTable = OracleDb.ExecRefCursor(
                    "PKG_CLI_CLIENTE.CLI_BUSCAR",
                    New List(Of OracleParameter) From {
                        New OracleParameter("p_texto", OracleDbType.Varchar2, "", ParameterDirection.Input)
                    }, "p_data")

                For Each row As DataRow In dt.Rows
                    If Convert.ToInt32(row("CLI_CLIENTE")) = clienteId Then
                        ddlTipoDoc.SelectedValue = row("CLI_TIPODOCUMENTO").ToString()
                        txtNumDoc.Text = row("CLI_NUMDOCUMENTO").ToString()
                        txtNit.Text = If(row("CLI_NIT") Is DBNull.Value, "", row("CLI_NIT").ToString())
                        txtPrimerNombre.Text = row("CLI_PRIMER_NOMBRE").ToString()
                        txtSegundoNombre.Text = If(row("CLI_SEGUNDO_NOMBRE") Is DBNull.Value, "", row("CLI_SEGUNDO_NOMBRE").ToString())
                        txtPrimerApellido.Text = row("CLI_PRIMER_APELLIDO").ToString()
                        txtSegundoApellido.Text = If(row("CLI_SEGUNDO_APELLIDO") Is DBNull.Value, "", row("CLI_SEGUNDO_APELLIDO").ToString())
                        txtEmail.Text = row("CLI_EMAIL").ToString()
                        txtProfesion.Text = If(row("CLI_PROFESION") Is DBNull.Value, "", row("CLI_PROFESION").ToString())
                        txtTel1.Text = row("CLI_PRIMER_TELEFONO").ToString()
                        txtTel2.Text = If(row("CLI_SEGUNDO_TELEFONO") Is DBNull.Value, "", row("CLI_SEGUNDO_TELEFONO").ToString())
                        txtPais.Text = row("CLI_PAIS").ToString()
                        txtDepartamento.Text = row("CLI_DEPARTAMENTO").ToString()
                        txtMunicipio.Text = row("CLI_MUNICIPIO").ToString()
                        txtZona.Text = row("CLI_ZONA").ToString()
                        txtCodigoPostal.Text = If(row("CLI_CODIGO_POSTAL") Is DBNull.Value, "", row("CLI_CODIGO_POSTAL").ToString())
                        txtDireccion.Text = row("CLI_DIRECCION").ToString()
                        Exit For
                    End If
                Next
            Catch ex As Exception
                MostrarError("Error al cargar datos: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            Try
                Dim clienteId As Integer = Convert.ToInt32(Session("CLI_CLIENTE"))
                Dim ps As New List(Of OracleParameter) From {
                    New OracleParameter("p_id", OracleDbType.Decimal, clienteId, ParameterDirection.Input),
                    New OracleParameter("p_tipodoc", OracleDbType.Varchar2, ddlTipoDoc.SelectedValue, ParameterDirection.Input),
                    New OracleParameter("p_numdoc", OracleDbType.Varchar2, txtNumDoc.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_p_nom", OracleDbType.Varchar2, txtPrimerNombre.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_s_nom", OracleDbType.Varchar2, txtSegundoNombre.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_p_ape", OracleDbType.Varchar2, txtPrimerApellido.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_s_ape", OracleDbType.Varchar2, txtSegundoApellido.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_pais", OracleDbType.Varchar2, txtPais.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_dep", OracleDbType.Varchar2, txtDepartamento.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_mun", OracleDbType.Varchar2, txtMunicipio.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_zona", OracleDbType.Varchar2, txtZona.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_dir", OracleDbType.Varchar2, txtDireccion.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_cp", OracleDbType.Varchar2, txtCodigoPostal.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_tel1", OracleDbType.Varchar2, txtTel1.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_tel2", OracleDbType.Varchar2, txtTel2.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_email", OracleDbType.Varchar2, txtEmail.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_prof", OracleDbType.Varchar2, txtProfesion.Text.Trim(), ParameterDirection.Input),
                    New OracleParameter("p_tipocli", OracleDbType.Varchar2, "NATURAL", ParameterDirection.Input)
                }
                OracleDb.ExecNonQuery("PKG_CLI_CLIENTE.CLI_ACTUALIZAR", ps)
                Session("CLI_NOMBRE") = txtPrimerNombre.Text.Trim() & " " & txtPrimerApellido.Text.Trim()
                MostrarOk("✓ Datos actualizados correctamente.")
            Catch ex As Exception
                MostrarError("Error al guardar: " & ex.Message)
            End Try
        End Sub

        Private Sub MostrarOk(msg As String)
            lblMsg.Text = msg
            lblMsg.CssClass = "alert-ok"
            pnlMsg.Visible = True
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = msg
            lblMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

    End Class

End Namespace