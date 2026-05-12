<%@ WebHandler Language="VB" Class="CatalogoClienteHandler" %>
Imports System.Web
Imports System.Data
Imports Newtonsoft.Json

Public Class CatalogoClienteHandler
    Implements IHttpHandler

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        Dim action As String = context.Request("action")

        Try
            Select Case action
                Case "listar" : ListarProductos(context)
                Case "categorias" : ListarCategorias(context)
                Case "buscar" : BuscarProductos(context)
                Case "promociones" : ListarPromociones(context)
                Case "detalle" : DetalleProducto(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""ok"": false, ""mensaje"": ""Accion no reconocida.""}")
            End Select
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write("{""ok"": false, ""mensaje"": """ & ex.Message.Replace("""", "\""") & """}")
        End Try
    End Sub

    Private Sub ListarProductos(context As HttpContext)
        Dim dt As DataTable = CatalogoClienteService.Listar()
        Dim lst As New List(Of Object)

        For Each row As DataRow In dt.Rows
            lst.Add(New With {
                .PRO_REFERENCIA = row("PRO_REFERENCIA"),
                .PRO_NOMBRE = row("PRO_NOMBRE"),
                .PRO_DESCRIPCION = row("PRO_DESCRIPCION"),
                .PRO_PRECIO = row("PRO_PRECIO"),
                .PRECIO_FINAL = row("PRECIO_FINAL"),
                .HV_HISTORIAL_PRECIO_VENTA = If(IsDBNull(row("HV_HISTORIAL_PRECIO_VENTA")), Nothing, row("HV_HISTORIAL_PRECIO_VENTA")),
                .CAT_DESCRIPCION = row("CAT_DESCRIPCION"),
                .TIP_DESCRIPCION = row("TIP_DESCRIPCION"),
                .MAT_DESCRIPCION = row("MAT_DESCRIPCION"),
                .PROM_PORCENTAJE = If(IsDBNull(row("PROM_PORCENTAJE")), Nothing, row("PROM_PORCENTAJE")),
                .CAMP_NOMBRE = If(IsDBNull(row("CAMP_NOMBRE")), "", row("CAMP_NOMBRE")),
                .STO_DISPONIBLE = row("STO_DISPONIBLE")
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub ListarCategorias(context As HttpContext)
        Dim dt As DataTable = CatalogoClienteService.ListarCategorias()
        Dim lst As New List(Of Object)

        For Each row As DataRow In dt.Rows
            lst.Add(New With {
                .CAT_CATEGORIA = row("CAT_CATEGORIA"),
                .CAT_DESCRIPCION = row("CAT_DESCRIPCION")
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub BuscarProductos(context As HttpContext)
        Dim texto As String = If(context.Request("texto"), "")
        Dim categoria As Integer = 0

        If context.Request("categoria") IsNot Nothing AndAlso context.Request("categoria") <> "" Then
            categoria = Convert.ToInt32(Convert.ToDecimal(context.Request("categoria")))
        End If

        Dim dt As DataTable = CatalogoClienteService.Buscar(texto, categoria)
        Dim lst As New List(Of Object)

        For Each row As DataRow In dt.Rows
            lst.Add(New With {
                .PRO_REFERENCIA = row("PRO_REFERENCIA"),
                .PRO_NOMBRE = row("PRO_NOMBRE"),
                .PRO_DESCRIPCION = row("PRO_DESCRIPCION"),
                .PRO_PRECIO = row("PRO_PRECIO"),
                .PRECIO_FINAL = row("PRECIO_FINAL"),
                .HV_HISTORIAL_PRECIO_VENTA = If(IsDBNull(row("HV_HISTORIAL_PRECIO_VENTA")), Nothing, row("HV_HISTORIAL_PRECIO_VENTA")),
                .CAT_DESCRIPCION = row("CAT_DESCRIPCION"),
                .TIP_DESCRIPCION = row("TIP_DESCRIPCION"),
                .MAT_DESCRIPCION = row("MAT_DESCRIPCION"),
                .PROM_PORCENTAJE = If(IsDBNull(row("PROM_PORCENTAJE")), Nothing, row("PROM_PORCENTAJE")),
                .CAMP_NOMBRE = If(IsDBNull(row("CAMP_NOMBRE")), "", row("CAMP_NOMBRE")),
                .STO_DISPONIBLE = row("STO_DISPONIBLE")
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub DetalleProducto(context As HttpContext)
        Dim ref As String = context.Request("ref")
        If String.IsNullOrEmpty(ref) Then
            context.Response.StatusCode = 400
            context.Response.Write("{""ok"": false, ""mensaje"": ""Referencia obligatoria.""}")
            Return
        End If
        Dim dt As DataTable = CatalogoClienteService.Listar()
        Dim filas As DataRow() = dt.Select("PRO_REFERENCIA = '" & ref.Replace("'", "''") & "'")
        If filas.Length = 0 Then
            context.Response.StatusCode = 404
            context.Response.Write("{""ok"": false, ""mensaje"": ""Producto no encontrado.""}")
            Return
        End If
        Dim row As DataRow = filas(0)
        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True,
            .data = New With {
                .PRO_REFERENCIA = row("PRO_REFERENCIA"),
                .PRO_NOMBRE = row("PRO_NOMBRE"),
                .PRO_DESCRIPCION = row("PRO_DESCRIPCION"),
                .PRO_PRECIO = row("PRO_PRECIO"),
                .PRO_COLOR = If(IsDBNull(row("PRO_COLOR")), "N/A", row("PRO_COLOR")),
                .PRO_ALTO_CM = row("PRO_ALTO_CM"),
                .PRO_ANCHO_CM = row("PRO_ANCHO_CM"),
                .PRO_PROFUNDIDAD_CM = row("PRO_PROFUNDIDAD_CM"),
                .PRO_PESO = row("PRO_PESO"),
                .PRECIO_FINAL = row("PRECIO_FINAL"),
                .HV_HISTORIAL_PRECIO_VENTA = If(IsDBNull(row("HV_HISTORIAL_PRECIO_VENTA")), Nothing, row("HV_HISTORIAL_PRECIO_VENTA")),
                .CAT_DESCRIPCION = row("CAT_DESCRIPCION"),
                .TIP_DESCRIPCION = row("TIP_DESCRIPCION"),
                .MAT_DESCRIPCION = row("MAT_DESCRIPCION"),
                .PROM_PORCENTAJE = If(IsDBNull(row("PROM_PORCENTAJE")), Nothing, row("PROM_PORCENTAJE")),
                .CAMP_NOMBRE = If(IsDBNull(row("CAMP_NOMBRE")), "", row("CAMP_NOMBRE")),
                .STO_DISPONIBLE = row("STO_DISPONIBLE")
            }
        }))
    End Sub

    Private Sub ListarPromociones(context As HttpContext)
        Dim dt As DataTable = CatalogoClienteService.ListarPromociones()
        Dim lst As New List(Of Object)

        For Each row As DataRow In dt.Rows
            lst.Add(New With {
                .PRO_REFERENCIA = row("PRO_REFERENCIA"),
                .PRO_NOMBRE = row("PRO_NOMBRE"),
                .PRO_DESCRIPCION = row("PRO_DESCRIPCION"),
                .PRO_PRECIO = row("PRO_PRECIO"),
                .PRECIO_FINAL = row("PRECIO_FINAL"),
                .HV_HISTORIAL_PRECIO_VENTA = If(IsDBNull(row("HV_HISTORIAL_PRECIO_VENTA")), Nothing, row("HV_HISTORIAL_PRECIO_VENTA")),
                .CAT_DESCRIPCION = row("CAT_DESCRIPCION"),
                .TIP_DESCRIPCION = row("TIP_DESCRIPCION"),
                .MAT_DESCRIPCION = row("MAT_DESCRIPCION"),
                .PROM_PORCENTAJE = If(IsDBNull(row("PROM_PORCENTAJE")), Nothing, row("PROM_PORCENTAJE")),
                .CAMP_NOMBRE = If(IsDBNull(row("CAMP_NOMBRE")), "", row("CAMP_NOMBRE")),
                .STO_DISPONIBLE = row("STO_DISPONIBLE")
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

End Class