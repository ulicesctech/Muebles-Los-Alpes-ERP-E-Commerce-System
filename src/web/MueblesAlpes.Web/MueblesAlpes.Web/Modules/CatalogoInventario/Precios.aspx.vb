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
        ' FILTRO MES/AÑO
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

        ' =============================================
        ' BOTON FILTRAR
        ' 1. Obtiene datos base desde Oracle (por mes o todos)
        ' 2. Aplica filtros en memoria: producto y estado vigente
        ' =============================================
        Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs)
            Try
                Dim mes As Integer = Convert.ToInt32(ddlMes.SelectedValue)
                Dim dt As DataTable

                If mes = 0 Then
                    dt = HistorialPrecioService.ListarTodos()
                Else
                    Dim anio As Integer = Convert.ToInt32(ddlAnio.SelectedValue)
                    dt = HistorialPrecioService.ListarPorMes(mes, anio)
                End If

                dt = AplicarFiltrosEnMemoria(dt)

                gvHistorial.DataSource = dt
                gvHistorial.DataBind()
                lblContador.Text = If(dt IsNot Nothing, dt.Rows.Count.ToString(), "0")
            Catch ex As Exception
                MostrarError("Error al filtrar: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' BOTON LIMPIAR
        ' =============================================
        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            ddlMes.SelectedIndex = 0
            ddlAnio.SelectedIndex = 0
            txtFiltroProducto.Text = ""
            chkSoloVigentes.Checked = False
            pnlMsg.Visible = False
            CargarHistorialTodos()
        End Sub

        ' =============================================
        ' FILTROS EN MEMORIA
        ' - Producto: contiene el texto en PRO_NOMBRE (insensible a mayúsculas)
        ' - Solo vigentes: HIP_FECHA_FINAL IS NULL
        '
        ' Ambos filtros son independientes y se acumulan (AND).
        ' =============================================
        Private Function AplicarFiltrosEnMemoria(dt As DataTable) As DataTable
            If dt Is Nothing OrElse dt.Rows.Count = 0 Then Return dt

            Dim filtroProd As String = txtFiltroProducto.Text.Trim()
            Dim soloVigentes As Boolean = chkSoloVigentes.Checked
            Dim hayFiltro As Boolean = Not String.IsNullOrEmpty(filtroProd) OrElse soloVigentes

            ' Si no hay ningún filtro activo devolvemos el DataTable tal cual
            If Not hayFiltro Then Return dt

            Dim filtroUp As String = filtroProd.ToUpper()
            Dim filas As IEnumerable(Of DataRow) = dt.AsEnumerable()

            ' Filtro por nombre de producto (contiene, insensible a mayúsculas)
            If Not String.IsNullOrEmpty(filtroProd) Then
                filas = filas.Where(Function(r)
                                        If IsDBNull(r("PRO_NOMBRE")) Then Return False
                                        Return r("PRO_NOMBRE").ToString().ToUpper().Contains(filtroUp)
                                    End Function)
            End If

            ' Filtro solo vigentes: fecha final nula
            If soloVigentes Then
                filas = filas.Where(Function(r) IsDBNull(r("HIP_FECHA_FINAL")))
            End If

            Dim dtResultado As DataTable = dt.Clone()
            For Each fila As DataRow In filas
                dtResultado.ImportRow(fila)
            Next

            Return dtResultado
        End Function

        ' =============================================
        ' CARGAR HISTORIAL COMPLETO (sin filtros)
        ' =============================================
        Private Sub CargarHistorialTodos()
            Try
                Dim dt As DataTable = HistorialPrecioService.ListarTodos()
                gvHistorial.DataSource = dt
                gvHistorial.DataBind()
                lblContador.Text = If(dt IsNot Nothing, dt.Rows.Count.ToString(), "0")
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