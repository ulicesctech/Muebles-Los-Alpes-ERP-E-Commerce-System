Imports System.Data

Namespace Modules.Cliente

    Public Class MisCompras
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                If Session("CLI_CLIENTE") Is Nothing Then
                    pnlVacio.Visible = True
                Else
                    CargarCompras()
                End If
            End If
        End Sub

        Private Sub CargarCompras()
            Try
                Dim clienteId As Integer = Convert.ToInt32(Session("CLI_CLIENTE"))
                Dim dt As DataTable = FacturaClienteService.ListarPorCliente(clienteId)

                If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                    rptCompras.DataSource = dt
                    rptCompras.DataBind()
                    pnlCompras.Visible = True
                Else
                    pnlVacio.Visible = True
                End If
            Catch ex As Exception
                pnlVacio.Visible = True
            End Try
        End Sub

    End Class

End Namespace