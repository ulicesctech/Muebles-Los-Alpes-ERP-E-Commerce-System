Imports System

Namespace MueblesAlpes.Web.Modules.AuthUsuarios.Admin

    Partial Public Class PermisosPage
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarPermisos()
            End If
        End Sub

        Private Sub CargarPermisos()
            Try
                gvPermisos.DataSource = PermisoService.Listar()
                gvPermisos.DataBind()
            Catch ex As Exception
                lblError.Text = "Error al cargar permisos: " & ex.Message
                lblError.Visible = True
            End Try
        End Sub

    End Class
End Namespace