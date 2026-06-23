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
            context.Response.Write("{""ok"": false, ""mensaje"": ""No se pudo procesar la solicitud.""}")
        End Try
    End Sub

    Private Function Valor(row As DataRow, columna As String, Optional defecto As Object = Nothing) As Object
        If row.Table.Columns.Contains(columna) AndAlso Not IsDBNull(row(columna)) Then
            Return row(columna)
        End If
        Return defecto
    End Function

    ' Construye la URL absoluta de la foto del producto
    Private Function GetFotoUrl(context As HttpContext, referencia As String) As String
        Dim baseUrl As String = context.Request.Url.GetLeftPart(UriPartial.Authority)
        Return baseUrl & "/Handlers/CatalogoInventario/FotoProductoHandler.ashx?ref=" & Uri.EscapeDataString(referencia)
    End Function

    Private Sub ListarProductos(context As HttpContext)
        Dim dt As DataTable = CatalogoClienteService.Listar()
        Dim lst As New List(Of Object)

        For Each row As DataRow In dt.Rows
            Dim ref As String = Valor(row, "PRO_REFERENCIA", "").ToString()
            lst.Add(New With {
                .PRO_REFERENCIA = ref,
                .PRO_NOMBRE = Valor(row, "PRO_NOMBRE", ""),
                .PRO_DESCRIPCION = Valor(row, "PRO_DESCRIPCION", ""),
                .PRO_PRECIO = Valor(row, "PRO_PRECIO", 0),
                .PRECIO_FINAL = Valor(row, "PRECIO_FINAL", 0),
                .HV_HISTORIAL_PRECIO_VENTA = Valor(row, "HV_HISTORIAL_PRECIO_VENTA", Nothing),
                .CAT_DESCRIPCION = Valor(row, "CAT_DESCRIPCION", ""),
                .TIP_DESCRIPCION = Valor(row, "TIP_DESCRIPCION", ""),
                .MAT_DESCRIPCION = Valor(row, "MAT_DESCRIPCION", ""),
                .PROM_PORCENTAJE = Valor(row, "PROM_PORCENTAJE", Nothing),
                .CAMP_NOMBRE = Valor(row, "CAMP_NOMBRE", ""),
                .STO_DISPONIBLE = Valor(row, "STO_DISPONIBLE", 0),
                .FOTO_URL = GetFotoUrl(context, ref)
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub ListarCategorias(context As HttpContext)
        Dim dt As DataTable = CatalogoClienteService.ListarCategorias()
        Dim lst As New List(Of Object)

        For Each row As DataRow In dt.Rows
            lst.Add(New With {
                .CAT_CATEGORIA = Valor(row, "CAT_CATEGORIA", 0),
                .CAT_DESCRIPCION = Valor(row, "CAT_DESCRIPCION", "")
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
            Dim ref As String = Valor(row, "PRO_REFERENCIA", "").ToString()
            lst.Add(New With {
                .PRO_REFERENCIA = ref,
                .PRO_NOMBRE = Valor(row, "PRO_NOMBRE", ""),
                .PRO_DESCRIPCION = Valor(row, "PRO_DESCRIPCION", ""),
                .PRO_PRECIO = Valor(row, "PRO_PRECIO", 0),
                .PRECIO_FINAL = Valor(row, "PRECIO_FINAL", 0),
                .HV_HISTORIAL_PRECIO_VENTA = Valor(row, "HV_HISTORIAL_PRECIO_VENTA", Nothing),
                .CAT_DESCRIPCION = Valor(row, "CAT_DESCRIPCION", ""),
                .TIP_DESCRIPCION = Valor(row, "TIP_DESCRIPCION", ""),
                .MAT_DESCRIPCION = Valor(row, "MAT_DESCRIPCION", ""),
                .PROM_PORCENTAJE = Valor(row, "PROM_PORCENTAJE", Nothing),
                .CAMP_NOMBRE = Valor(row, "CAMP_NOMBRE", ""),
                .STO_DISPONIBLE = Valor(row, "STO_DISPONIBLE", 0),
                .FOTO_URL = GetFotoUrl(context, ref)
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
                .PRO_REFERENCIA = Valor(row, "PRO_REFERENCIA", ""),
                .PRO_NOMBRE = Valor(row, "PRO_NOMBRE", ""),
                .PRO_DESCRIPCION = Valor(row, "PRO_DESCRIPCION", ""),
                .PRO_PRECIO = Valor(row, "PRO_PRECIO", 0),
                .PRO_COLOR = Valor(row, "PRO_COLOR", "N/A"),
                .PRO_ALTO_CM = Valor(row, "PRO_ALTO_CM", 0),
                .PRO_ANCHO_CM = Valor(row, "PRO_ANCHO_CM", 0),
                .PRO_PROFUNDIDAD_CM = Valor(row, "PRO_PROFUNDIDAD_CM", 0),
                .PRO_PESO = Valor(row, "PRO_PESO", 0),
                .PRECIO_FINAL = Valor(row, "PRECIO_FINAL", 0),
                .HV_HISTORIAL_PRECIO_VENTA = Valor(row, "HV_HISTORIAL_PRECIO_VENTA", Nothing),
                .CAT_DESCRIPCION = Valor(row, "CAT_DESCRIPCION", ""),
                .TIP_DESCRIPCION = Valor(row, "TIP_DESCRIPCION", ""),
                .MAT_DESCRIPCION = Valor(row, "MAT_DESCRIPCION", ""),
                .PROM_PORCENTAJE = Valor(row, "PROM_PORCENTAJE", Nothing),
                .CAMP_NOMBRE = Valor(row, "CAMP_NOMBRE", ""),
                .STO_DISPONIBLE = Valor(row, "STO_DISPONIBLE", 0),
                .FOTO_URL = GetFotoUrl(context, ref)
            }
        }))
    End Sub

    Private Sub ListarPromociones(context As HttpContext)
        Dim dt As DataTable = CatalogoClienteService.ListarPromociones()
        Dim lst As New List(Of Object)

        For Each row As DataRow In dt.Rows
            Dim ref As String = Valor(row, "PRO_REFERENCIA", "").ToString()
            lst.Add(New With {
                .PRO_REFERENCIA = ref,
                .PRO_NOMBRE = Valor(row, "PRO_NOMBRE", ""),
                .PRO_DESCRIPCION = Valor(row, "PRO_DESCRIPCION", ""),
                .PRO_PRECIO = Valor(row, "PRO_PRECIO", 0),
                .PRECIO_FINAL = Valor(row, "PRECIO_FINAL", 0),
                .HV_HISTORIAL_PRECIO_VENTA = Valor(row, "HV_HISTORIAL_PRECIO_VENTA", Nothing),
                .CAT_DESCRIPCION = Valor(row, "CAT_DESCRIPCION", ""),
                .TIP_DESCRIPCION = Valor(row, "TIP_DESCRIPCION", ""),
                .MAT_DESCRIPCION = Valor(row, "MAT_DESCRIPCION", ""),
                .PROM_PORCENTAJE = Valor(row, "PROM_PORCENTAJE", Nothing),
                .CAMP_NOMBRE = Valor(row, "CAMP_NOMBRE", ""),
                .STO_DISPONIBLE = Valor(row, "STO_DISPONIBLE", 0),
                .FOTO_URL = GetFotoUrl(context, ref)
            })
        Next

        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

End Class
