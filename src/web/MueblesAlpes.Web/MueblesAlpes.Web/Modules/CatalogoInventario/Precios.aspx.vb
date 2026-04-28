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
        ' FILTRO MES/AÑO (original)
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
        ' Aplica: mes/año (via Oracle) + producto y estado (en memoria)
        ' =============================================
        Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs)
            Try
                Dim mes As Integer = Convert.ToInt32(ddlMes.SelectedValue)
                Dim dt As DataTable

                ' 1. Obtener datos base (mes/año o todos)
                If mes = 0 Then
                    dt = HistorialPrecioService.ListarTodos()
                Else
                    Dim anio As Integer = Convert.ToInt32(ddlAnio.SelectedValue)
                    dt = HistorialPrecioService.ListarPorMes(mes, anio)
                End If

                ' 2. Aplicar filtros en memoria
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
            ddlFiltroEstado.SelectedIndex = 0
            CargarHistorialTodos()
        End Sub

        ' =============================================
        ' FILTROS EN MEMORIA
        ' Columnas disponibles: PRO_NOMBRE, HIP_FECHA_FINAL
        ' Estado: VIGENTE  = HIP_FECHA_FINAL IS NULL
        '         HISTORICO = HIP_FECHA_FINAL IS NOT NULL
        ' =============================================
        Private Function AplicarFiltrosEnMemoria(dt As DataTable) As DataTable
            If dt Is Nothing OrElse dt.Rows.Count = 0 Then Return dt

            Dim filtroProd As String = txtFiltroProducto.Text.Trim().ToUpper()
            Dim filtroEstado As String = ddlFiltroEstado.SelectedValue

            Dim filas As IEnumerable(Of DataRow) = dt.AsEnumerable()

            ' Filtro producto
            If Not String.IsNullOrEmpty(filtroProd) Then
                filas = filas.Where(Function(r)
                                        Return r("PRO_NOMBRE").ToString().ToUpper().Contains(filtroProd)
                                    End Function)
            End If

            ' Filtro estado
            If filtroEstado = "VIGENTE" Then
                filas = filas.Where(Function(r) IsDBNull(r("HIP_FECHA_FINAL")) OrElse r("HIP_FECHA_FINAL").ToString() = "")
            ElseIf filtroEstado = "HISTORICO" Then
                filas = filas.Where(Function(r) Not IsDBNull(r("HIP_FECHA_FINAL")) AndAlso r("HIP_FECHA_FINAL").ToString() <> "")
            End If

            Dim dtResultado As DataTable = dt.Clone()
            For Each fila As DataRow In filas
                dtResultado.ImportRow(fila)
            Next
            Return dtResultado
        End Function

        ' =============================================
        ' CARGAR HISTORIAL COMPLETO
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