Imports System
Namespace MueblesAlpes.Web.Modules.AuthUsuarios
    Partial Public Class IndexPage
        Inherits System.Web.UI.Page
        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                MostrarPaneles()
            End If
        End Sub
        Private Sub MostrarPaneles()
            If Session("UsuarioId") Is Nothing Then
                pnlAcceso.Visible = True
                pnlBienvenida.Visible = False
                pnlAdmin.Visible = False
                pnlRH.Visible = False
                pnlClientes.Visible = False
                pnlFac.Visible = False
            Else
                Dim tipo As String = Session("UsuarioTipo").ToString()
                pnlAcceso.Visible = False
                pnlBienvenida.Visible = True
                lblNombre.Text = Session("UsuarioNombre").ToString()
                lblGrupo.Text = If(tipo = "EMPLEADO",
                                    "🏢 " & Session("UsuarioGrupo").ToString(),
                                    "🛒 Cliente")
                If tipo = "EMPLEADO" Then
                    pnlAdmin.Visible = CType(Session("PerAdmin"), Boolean)
                    pnlRH.Visible = CType(Session("PerRH"), Boolean)
                    pnlClientes.Visible = CType(Session("PerCli"), Boolean)
                    pnlFac.Visible = CType(Session("PerFac"), Boolean)
                End If
            End If
        End Sub
        Protected Sub btnCerrarSesion_Click(sender As Object, e As EventArgs)
            Session.Clear()
            Session.Abandon()
            Response.Redirect("~/Modules/AuthUsuarios/Index.aspx")
        End Sub
    End Class
End Namespace