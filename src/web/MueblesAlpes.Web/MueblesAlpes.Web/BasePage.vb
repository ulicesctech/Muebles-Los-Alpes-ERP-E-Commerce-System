Imports System.Web
Imports System.Web.UI

Public Class BasePage
    Inherits System.Web.UI.Page

    Protected Overrides Sub OnInit(e As System.EventArgs)
        MyBase.OnInit(e)
        AplicarNoCache()
        ValidarSesion()
    End Sub

    Private Sub AplicarNoCache()
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache)
        HttpContext.Current.Response.Cache.SetNoStore()
        HttpContext.Current.Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1))
        HttpContext.Current.Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches)
    End Sub

    Private Sub ValidarSesion()
        Dim url As String = HttpContext.Current.Request.AppRelativeCurrentExecutionFilePath.ToLower()
        Dim esVistaCliente As Boolean = url.Contains("modules/cliente/") OrElse
                                        url.Contains("modules/authusuarios/logincliente")
        Dim esPaginaLogin As Boolean = url.Contains("authusuarios/loginempleado") OrElse
                                       url.Contains("authusuarios/logincliente")

        If Not esVistaCliente AndAlso Not esPaginaLogin Then
            If HttpContext.Current.Session("UsuarioId") Is Nothing Then
                HttpContext.Current.Response.Redirect("~/Modules/AuthUsuarios/LoginEmpleado.aspx")
            End If
        End If
    End Sub

End Class