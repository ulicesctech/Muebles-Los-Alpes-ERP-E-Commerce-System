<%@ WebHandler Language="VB" Class="OrdenCompraHandler" %>

Imports System
Imports System.Data
Imports System.Web
Imports System.Text

' ============================================================
' RUTA: Handlers/ComprasProveedor/OrdenCompraHandler.ashx
' Services: OrdenCompraService, OrdenDetallePedidoService
'
' GET  ?action=listar                          → OrdenCompraService.Listar()
' GET  ?action=buscar&q=texto                  → OrdenCompraService.Buscar(texto)
' GET  ?action=buscarPedidos&q=texto           → OrdenCompraService.BuscarPedidos(texto)
' GET  ?action=detallesPedido&pedId=N          → OrdenCompraService.DetallesPedido(N)
' GET  ?action=itemsOrden&orcKey=X             → OrdenDetallePedidoService.ListarPorOrden(X)
' POST ?action=crear                           → OrdenCompraService.Crear + ODP por cada item
' POST ?action=eliminar                        → OrdenCompraService.Eliminar(orcKey)
' POST ?action=eliminarItem                    → OrdenDetallePedidoService.Eliminar(odpId)
' ============================================================
Public Class OrdenCompraHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.Charset     = "utf-8"

        context.Response.AddHeader("Access-Control-Allow-Origin",  "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        If context.Request.HttpMethod.ToUpper() = "OPTIONS" Then
            context.Response.StatusCode = 200
            context.Response.End()
            Return
        End If

        Dim method As String = context.Request.HttpMethod.ToUpper()
        Dim action As String = If(context.Request.QueryString("action"), "").ToLower().Trim()

        Try
            Select Case method
                Case "GET"
                    Select Case action
                        Case "listar"         : Listar(context)
                        Case "buscar"         : Buscar(context)
                        Case "buscarpedidos"  : BuscarPedidos(context)
                        Case "detallespedido" : DetallesPedido(context)
                        Case "itemsorden"     : ItemsOrden(context)
                        Case Else
                            Responder(context, 400, "action GET invalida. Opciones: listar, buscar, buscarPedidos, detallesPedido, itemsOrden")
                    End Select
                Case "POST"
                    Select Case action
                        Case "crear"        : Crear(context)
                        Case "eliminar"     : Eliminar(context)
                        Case "eliminaritem" : EliminarItem(context)
                        Case Else
                            Responder(context, 400, "action POST invalida. Opciones: crear, eliminar, eliminarItem")
                    End Select
                Case Else
                    Responder(context, 405, "Metodo HTTP no permitido.")
            End Select
        Catch ex As Exception
            Responder(context, 500, "Error interno: " & ex.Message)
        End Try
    End Sub

    ' =============================================
    ' GET — listar
    ' =============================================
    Private Sub Listar(context As HttpContext)
        context.Response.Write(DataTableToJson(OrdenCompraService.Listar()))
    End Sub

    ' =============================================
    ' GET — buscar&q=texto
    ' =============================================
    Private Sub Buscar(context As HttpContext)
        Dim q As String = If(context.Request.QueryString("q"), "").Trim()
        context.Response.Write(DataTableToJson(OrdenCompraService.Buscar(q)))
    End Sub

    ' =============================================
    ' GET — buscarPedidos&q=texto
    ' Devuelve pedidos disponibles para vincular
    ' =============================================
    Private Sub BuscarPedidos(context As HttpContext)
        Dim q As String = If(context.Request.QueryString("q"), "").Trim()
        context.Response.Write(DataTableToJson(OrdenCompraService.BuscarPedidos(q)))
    End Sub

    ' =============================================
    ' GET — detallesPedido&pedId=N
    ' Devuelve los items de un pedido (con forma pago)
    ' =============================================
    Private Sub DetallesPedido(context As HttpContext)
        Dim pedIdStr As String = If(context.Request.QueryString("pedId"), "").Trim()
        Dim pedId As Integer = 0
        If Not Integer.TryParse(pedIdStr, pedId) OrElse pedId <= 0 Then
            Responder(context, 422, "Parametro 'pedId' invalido.") : Return
        End If
        context.Response.Write(DataTableToJson(OrdenCompraService.DetallesPedido(pedId)))
    End Sub

    ' =============================================
    ' GET — itemsOrden&orcKey=X
    ' Devuelve los ODP de una orden existente
    ' =============================================
    Private Sub ItemsOrden(context As HttpContext)
        Dim orcKey As String = If(context.Request.QueryString("orcKey"), "").Trim()
        If String.IsNullOrEmpty(orcKey) Then
            Responder(context, 422, "Parametro 'orcKey' requerido.") : Return
        End If
        context.Response.Write(DataTableToJson(OrdenDetallePedidoService.ListarPorOrden(orcKey)))
    End Sub

    ' =============================================
    ' POST — crear
    ' Body: provId, pedidoId
    '       items  = JSON array: [{material, producto, precio, cantidad}, ...]
    ' Devuelve: { "ok":true, "orcKey":"OC-12" }
    ' =============================================
    Private Sub Crear(context As HttpContext)
        Dim provIdStr  As String = If(context.Request.Form("provId"),   "").Trim()
        Dim pedIdStr   As String = If(context.Request.Form("pedidoId"), "").Trim()
        Dim itemsJson  As String = If(context.Request.Form("items"),    "").Trim()

        Dim provId As Integer = 0
        Dim pedId  As Integer = 0

        If Not Integer.TryParse(provIdStr, provId) OrElse provId <= 0 Then
            Responder(context, 422, "Campo 'provId' invalido.") : Return
        End If
        If Not Integer.TryParse(pedIdStr, pedId) OrElse pedId <= 0 Then
            Responder(context, 422, "Campo 'pedidoId' invalido.") : Return
        End If
        If String.IsNullOrEmpty(itemsJson) Then
            Responder(context, 422, "Campo 'items' requerido.") : Return
        End If

        ' Parsear items del JSON simple (sin dependencias externas)
        Dim items As List(Of ItemInput) = ParseItemsJson(itemsJson)
        If items Is Nothing OrElse items.Count = 0 Then
            Responder(context, 422, "Debes ingresar precio para al menos un item.") : Return
        End If

        ' Oracle genera key y codigo; recibimos el key resultante
        Dim orcKey As String = OrdenCompraService.Crear(provId, 0)
        If String.IsNullOrEmpty(orcKey) Then
            Responder(context, 500, "No se pudo generar el identificador de la orden.") : Return
        End If

        Try
            For Each item As ItemInput In items
                OrdenDetallePedidoService.Insertar(orcKey, pedId, item.Material, item.Producto, item.Precio, item.Cantidad)
            Next

            ' Calcular y guardar total
            Dim dt As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
            Dim total As Decimal = 0
            For Each row As DataRow In dt.Rows
                Dim p As Decimal = If(IsDBNull(row("ODP_PRECIO")),   0D, Convert.ToDecimal(row("ODP_PRECIO")))
                Dim c As Decimal = If(IsDBNull(row("ODP_CANTIDAD")), 0D, Convert.ToDecimal(row("ODP_CANTIDAD")))
                total += p * c
            Next
            OrdenCompraService.ActualizarTotal(orcKey, total)

            context.Response.Write("{""ok"":true,""orcKey"":""" & orcKey & """}")
        Catch ex As Exception
            ' Si falla el insert de items, limpiar la orden huerfana
            Try : OrdenCompraService.Eliminar(orcKey) : Catch : End Try
            Throw
        End Try
    End Sub

    ' =============================================
    ' POST — eliminar
    ' Body: orcKey
    ' Devuelve: { "ok":true }
    ' =============================================
    Private Sub Eliminar(context As HttpContext)
        Dim orcKey As String = If(context.Request.Form("orcKey"), "").Trim()
        If String.IsNullOrEmpty(orcKey) Then
            Responder(context, 422, "Campo 'orcKey' requerido.") : Return
        End If

        ' Verificar que no tenga mercancia recibida
        Dim dtOdp As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
        If dtOdp IsNot Nothing AndAlso dtOdp.Rows.Count > 0 AndAlso dtOdp.Columns.Contains("PED_PEDIDO") Then
            Dim pedId As Integer = Convert.ToInt32(dtOdp.Rows(0)("PED_PEDIDO"))
            Dim dtDet As DataTable = DetallePedidoService.ListarPorPedido(pedId)
            If dtDet IsNot Nothing Then
                For Each row As DataRow In dtDet.Rows
                    Dim cant As Integer = 0
                    If Not IsDBNull(row("DETPE_CANTIDAD_RECIBIDA")) Then
                        cant = Convert.ToInt32(row("DETPE_CANTIDAD_RECIBIDA"))
                    End If
                    If cant > 0 Then
                        Responder(context, 409, "No se puede eliminar: ya se registro recepcion de mercancia para esta orden.")
                        Return
                    End If
                Next
            End If
        End If

        Try
            OrdenCompraService.Eliminar(orcKey)
            context.Response.Write("{""ok"":true}")
        Catch ex As Exception
            If ex.Message.Contains("ORA-02292") Then
                Responder(context, 409, "No se puede eliminar: esta orden tiene facturas o reclamos vinculados.")
            Else
                Throw
            End If
        End Try
    End Sub

    ' =============================================
    ' POST — eliminarItem
    ' Body: odpId
    ' Devuelve: { "ok":true, "orcKeyEliminada":"OC-5" | null }
    ' Si era el ultimo item elimina la orden completa
    ' =============================================
    Private Sub EliminarItem(context As HttpContext)
        Dim odpIdStr As String = If(context.Request.Form("odpId"), "").Trim()
        Dim orcKey   As String = If(context.Request.Form("orcKey"), "").Trim()
        Dim odpId    As Integer = 0

        If Not Integer.TryParse(odpIdStr, odpId) OrElse odpId <= 0 Then
            Responder(context, 422, "Campo 'odpId' invalido.") : Return
        End If
        If String.IsNullOrEmpty(orcKey) Then
            Responder(context, 422, "Campo 'orcKey' requerido.") : Return
        End If

        OrdenDetallePedidoService.Eliminar(odpId)

        Dim dtRestantes As DataTable = OrdenDetallePedidoService.ListarPorOrden(orcKey)
        If dtRestantes Is Nothing OrElse dtRestantes.Rows.Count = 0 Then
            Try
                OrdenCompraService.Eliminar(orcKey)
                context.Response.Write("{""ok"":true,""orcKeyEliminada"":""" & orcKey & """}")
            Catch ex As Exception
                ' FK: tiene facturas/reclamos, no se elimina pero el item ya fue borrado
                context.Response.Write("{""ok"":true,""orcKeyEliminada"":null,""advertencia"":""La orden quedo sin items pero no se pudo eliminar automaticamente porque tiene facturas o reclamos vinculados.""}")
            End Try
        Else
            ' Recalcular total
            Dim total As Decimal = 0
            For Each row As DataRow In dtRestantes.Rows
                Dim p As Decimal = If(IsDBNull(row("ODP_PRECIO")),   0D, Convert.ToDecimal(row("ODP_PRECIO")))
                Dim c As Decimal = If(IsDBNull(row("ODP_CANTIDAD")), 0D, Convert.ToDecimal(row("ODP_CANTIDAD")))
                total += p * c
            Next
            OrdenCompraService.ActualizarTotal(orcKey, total)
            context.Response.Write("{""ok"":true,""orcKeyEliminada"":null}")
        End If
    End Sub

    ' =============================================
    ' HELPER — parsea JSON de items sin librerías
    ' Formato esperado: [{"material":"X","producto":"Y","precio":10.5,"cantidad":2}, ...]
    ' =============================================
    Private Class ItemInput
        Public Material As String
        Public Producto As String
        Public Precio   As Decimal
        Public Cantidad As Integer
    End Class

    Private Function ParseItemsJson(json As String) As List(Of ItemInput)
        Dim result As New List(Of ItemInput)
        json = json.Trim()
        If Not json.StartsWith("[") Then Return result

        ' Extraer cada objeto { ... }
        Dim depth As Integer = 0
        Dim start As Integer = -1
        For i As Integer = 0 To json.Length - 1
            Dim ch As Char = json(i)
            If ch = "{"c Then
                If depth = 0 Then start = i
                depth += 1
            ElseIf ch = "}"c Then
                depth -= 1
                If depth = 0 AndAlso start >= 0 Then
                    Dim obj As String = json.Substring(start, i - start + 1)
                    Dim item As ItemInput = ParseItemObj(obj)
                    If item IsNot Nothing AndAlso item.Precio > 0 Then
                        result.Add(item)
                    End If
                    start = -1
                End If
            End If
        Next
        Return result
    End Function

    Private Function ParseItemObj(obj As String) As ItemInput
        Try
            Dim item As New ItemInput()
            item.Material = ExtraerStr(obj, "material")
            item.Producto = ExtraerStr(obj, "producto")
            Dim precioStr As String = ExtraerVal(obj, "precio")
            Dim cantStr   As String = ExtraerVal(obj, "cantidad")
            Decimal.TryParse(precioStr,
                System.Globalization.NumberStyles.Any,
                System.Globalization.CultureInfo.InvariantCulture,
                item.Precio)
            Integer.TryParse(cantStr, item.Cantidad)
            If item.Cantidad <= 0 Then item.Cantidad = 1
            Return item
        Catch
            Return Nothing
        End Try
    End Function

    ' Extrae el valor de una clave string: "clave":"valor"
    Private Function ExtraerStr(obj As String, clave As String) As String
        Dim patron As String = """" & clave & """:"
        Dim idx As Integer = obj.IndexOf(patron)
        If idx < 0 Then Return ""
        Dim ini As Integer = obj.IndexOf("""", idx + patron.Length)
        If ini < 0 Then Return ""
        Dim fin As Integer = obj.IndexOf("""", ini + 1)
        If fin < 0 Then Return ""
        Return obj.Substring(ini + 1, fin - ini - 1)
    End Function

    ' Extrae el valor de una clave numerica: "clave":123
    Private Function ExtraerVal(obj As String, clave As String) As String
        Dim patron As String = """" & clave & """:"
        Dim idx As Integer = obj.IndexOf(patron)
        If idx < 0 Then Return "0"
        Dim ini As Integer = idx + patron.Length
        Do While ini < obj.Length AndAlso obj(ini) = " "c : ini += 1 : Loop
        Dim fin As Integer = ini
        Do While fin < obj.Length AndAlso (Char.IsDigit(obj(fin)) OrElse obj(fin) = "."c OrElse obj(fin) = "-"c)
            fin += 1
        Loop
        Return obj.Substring(ini, fin - ini)
    End Function

    ' =============================================
    ' HELPER — { "ok":false, "error":"..." }
    ' =============================================
    Private Sub Responder(context As HttpContext, statusCode As Integer, mensaje As String)
        context.Response.StatusCode = statusCode
        context.Response.Write("{""ok"":false,""error"":""" &
            mensaje.Replace("\", "\\").Replace("""", "\""") & """}")
    End Sub

    ' =============================================
    ' HELPER — DataTable a JSON
    ' =============================================
    Private Function DataTableToJson(dt As DataTable) As String
        If dt Is Nothing OrElse dt.Rows.Count = 0 Then Return "[]"
        Dim sb As New StringBuilder()
        sb.Append("[")
        For i As Integer = 0 To dt.Rows.Count - 1
            If i > 0 Then sb.Append(",")
            sb.Append("{")
            For j As Integer = 0 To dt.Columns.Count - 1
                If j > 0 Then sb.Append(",")
                Dim col As String = dt.Columns(j).ColumnName
                Dim val As Object = dt.Rows(i)(j)
                sb.Append("""" & col & """:")
                If IsDBNull(val) Then
                    sb.Append("null")
                ElseIf TypeOf val Is Boolean Then
                    sb.Append(If(CBool(val), "true", "false"))
                ElseIf TypeOf val Is Date Then
                    sb.Append("""" & CDate(val).ToString("yyyy-MM-dd") & """")
                ElseIf TypeOf val Is Decimal OrElse TypeOf val Is Integer OrElse
                       TypeOf val Is Long    OrElse TypeOf val Is Double Then
                    sb.Append(val.ToString())
                Else
                    sb.Append("""" &
                        val.ToString() _
                            .Replace("\", "\\") _
                            .Replace("""", "\""") _
                            .Replace(vbCr, "") _
                            .Replace(vbLf, " ") &
                        """")
                End If
            Next
            sb.Append("}")
        Next
        sb.Append("]")
        Return sb.ToString()
    End Function

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
