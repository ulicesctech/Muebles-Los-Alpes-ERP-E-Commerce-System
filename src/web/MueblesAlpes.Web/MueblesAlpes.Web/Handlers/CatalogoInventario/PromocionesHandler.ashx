<%@ WebHandler Language="VB" Class="PromocionesHandler" %>
Imports System
Imports Microsoft.VisualBasic
Imports System.IO
Imports Newtonsoft.Json
Imports System.Web
Imports System.Data

' ============================================================
' RUTA: Handlers/CatalogoInventario/PromocionesHandler.ashx
' ============================================================
Public Class PromocionesHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.Charset = "utf-8"
        context.Response.Cache.SetNoStore()
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        Dim action As String = context.Request.QueryString("action")

        Try
            Select Case action
                Case "listar-campanas"
                    ListarCampanas(context)
                Case "crear-campana"
                    CrearCampana(context)
                Case "actualizar-campana"
                    ActualizarCampana(context)
                Case "eliminar-campana"
                    EliminarCampana(context)
                Case "listar-por-campana"
                    ListarPorCampana(context)
                Case "crear-promo"
                    CrearPromo(context)
                Case "eliminar-promo"
                    EliminarPromo(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write(JsonConvert.SerializeObject(New With {
                        .ok = False,
                        .mensaje = "Accion no reconocida."
                    }))
            End Select
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {
                .ok = False,
                .mensaje = ex.Message
            }))
        End Try
    End Sub

    Private Sub ListarCampanas(context As HttpContext)
        Dim dt As System.Data.DataTable = PromocionService.CampanaListar()
        Dim lst As New List(Of Object)

        For Each row As System.Data.DataRow In dt.Rows
            lst.Add(New With {
                .CAMP_CAMPANA = row("CAMP_CAMPANA"),
                .CAMP_NOMBRE = row("CAMP_NOMBRE"),
                .CAMP_DESCRIPCION = row("CAMP_DESCRIPCION"),
                .CAMP_ESTADO = row("CAMP_ESTADO"),
                .CAMP_FECHA_INICIO = row("CAMP_FECHA_INICIO"),
                .CAMP_FECHA_FINAL = row("CAMP_FECHA_FINAL")
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True,
            .data = lst
        }))
    End Sub

    Private Sub CrearCampana(context As HttpContext)
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)

        Dim id As Decimal = PromocionService.CampanaCrear(
            datos("nombre").ToString(),
            datos("descripcion").ToString(),
            Convert.ToDateTime(datos("fechaInicio").ToString()),
            Convert.ToDateTime(datos("fechaFinal").ToString())
        )

        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True,
            .id = id
        }))
    End Sub

    Private Sub ActualizarCampana(context As HttpContext)
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)

        PromocionService.CampanaActualizar(
            Convert.ToDecimal(datos("id").ToString()),
            datos("nombre").ToString(),
            datos("descripcion").ToString(),
            datos("estado").ToString(),
            Convert.ToDateTime(datos("fechaInicio").ToString()),
            Convert.ToDateTime(datos("fechaFinal").ToString())
        )

        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True
        }))
    End Sub

    Private Sub EliminarCampana(context As HttpContext)
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)

        PromocionService.CampanaEliminar(Convert.ToDecimal(datos("id").ToString()))

        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True
        }))
    End Sub

    Private Sub ListarPorCampana(context As HttpContext)
        Dim id As Decimal = Convert.ToDecimal(context.Request.QueryString("id"))
        Dim dt As System.Data.DataTable = PromocionService.ListarPorCampana(id)
        Dim lst As New List(Of Object)

        For Each row As System.Data.DataRow In dt.Rows
            lst.Add(New With {
                .PROM_PROMOCION = row("PROM_PROMOCION"),
                .PRO_REFERENCIA = row("PRO_REFERENCIA"),
                .PRO_NOMBRE = row("PRO_NOMBRE"),
                .PROM_PORCENTAJE = row("PROM_PORCENTAJE")
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True,
            .data = lst
        }))
    End Sub

    Private Sub CrearPromo(context As HttpContext)
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)

        Dim id As Decimal = PromocionService.Crear(
            Convert.ToDecimal(datos("campanaId").ToString()),
            datos("proReferencia").ToString(),
            Convert.ToDecimal(datos("porcentaje").ToString())
        )

        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True,
            .id = id
        }))
    End Sub

    Private Sub EliminarPromo(context As HttpContext)
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)

        PromocionService.Eliminar(Convert.ToDecimal(datos("id").ToString()))

        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True
        }))
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class