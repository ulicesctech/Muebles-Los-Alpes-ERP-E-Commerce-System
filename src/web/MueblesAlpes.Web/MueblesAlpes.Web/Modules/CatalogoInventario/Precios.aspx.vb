Imports System
Imports System.Data

' ============================================================
' RUTA: Modules/CatalogoInventario/Precios.aspx.vb
' Solo listado — el registro de precios se hace desde Pedidos.
' ============================================================
Namespace Modules.CatalogoInventario

    Partial Public Class Precios
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarFiltroMes()
                CargarHistorialTodos()
            End If
        End Sub

        ' =============================================
        ' FILTRO POR MES
        ' =============================================
        Private Sub CargarFiltroMes()
            ddlMes.Items.Clear()
            ddlMes.Items.Add(New ListItem("-- Todos --", "0"))
            ddlMes.Items.Add(New ListItem("Enero", "1"))
            ddlMes.Items.Add(New ListItem("Febrero", "2"))
            ddlMes.Items.Add(New ListItem("Marzo", "3"))
            ddlMes.Items.Add(New ListItem("Abril", "4"))
            ddlMes.Items.Add(New ListItem("Mayo", "5"))
            ddlMes.Items.Add(New ListItem("Junio", "6"))
            ddlMes.Items.Add(New ListItem("Julio", "7"))
            ddlMes.Items.Add(New ListItem("Agosto", "8"))
            ddlMes.Items.Add(New ListItem("Septiembre", "9"))
            ddlMes.Items.Add(New ListItem("Octubre", "10"))
            ddlMes.Items.Add(New ListItem("Noviembre", "11"))
            ddlMes.Items.Add(New ListItem("Diciembre", "12"))

            ddlAnio.Items.Clear()
            Dim anioActual As Integer = DateTime.Now.Year
            For i As Integer = anioActual To 2023 Step -1
                ddlAnio.Items.Add(New ListItem(i.ToString(), i.ToString()))
            Next
        End Sub

        Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs)
            Dim mes As Integer = Convert.ToInt32(ddlMes.SelectedValue)
            If mes = 0 Then
                CargarHistorialTodos()
            Else
                Dim anio As Integer = Convert.ToInt32(ddlAnio.SelectedValue)
                Try
                    gvHistorial.DataSource = HistorialPrecioService.ListarPorMes(mes, anio)
                    gvHistorial.DataBind()
                Catch ex As Exception
                    MostrarError("Error al filtrar: " & ex.Message)
                End Try
            End If
        End Sub

        ' =============================================
        ' HISTORIAL
        ' =============================================
        Private Sub CargarHistorialTodos()
            Try
                gvHistorial.DataSource = HistorialPrecioService.ListarTodos()
                gvHistorial.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar historial: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' HELPERS
        ' =============================================
        Private Sub MostrarError(msg As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

    End Class

End Namespace