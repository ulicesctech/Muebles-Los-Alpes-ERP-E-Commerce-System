<%@ WebHandler Language="VB" Class="StockHandler" %>
Imports System
Imports Microsoft.VisualBasic
Imports System.Web
Imports System.Data
Imports System.IO
Imports Newtonsoft.Json

' ============================================================
' RUTA: Handlers/CatalogoInventario/StockHandler.ashx
' ============================================================
Public Class StockHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")
        If context.Request.HttpMethod = "OPTIONS" Then context.Response.StatusCode = 200 : Return

        Dim action As String = context.Request("action")
        Try
            Select Case action
                Case "listar"              : Listar(context)
                Case "listar_por_producto" : ListarPorProducto(context)
                Case "obtener"             : Obtener(context)
                Case "obtener_por_nicho"   : ObtenerPorNicho(context)
                Case "guardar"             : Guardar(context)
                Case "entrada"             : Entrada(context)
                Case "salida"              : Salida(context)
                Case "eliminar"            : Eliminar(context)
                Case "recibir_desde_pedido": RecibirDesdePedido(context)
                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write("{""error"": ""Accion no valida: " & action & """}")
            End Select
        Catch ex As Exception
            context.Response.StatusCode = 500
            Dim msg As String = ex.Message.Replace("""", "\""").Replace(vbCrLf, " ")
            context.Response.Write("{""error"": """ & msg & """}")
        End Try
    End Sub

    ' ── Helpers ──────────────────────────────────────────────────────────────

    Private Function LeerBody(context As HttpContext) As Dictionary(Of String, Object)
        Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        If String.IsNullOrWhiteSpace(json) Then Return New Dictionary(Of String, Object)
        Return JsonConvert.DeserializeObject(Of Dictionary(Of String, Object))(json)
    End Function

    Private Function Dec_(d As Dictionary(Of String, Object), key As String) As Decimal
        If d.ContainsKey(key) AndAlso d(key) IsNot Nothing Then Return Convert.ToDecimal(d(key))
        Return 0
    End Function

    ' ── Métodos existentes (sin cambios) ─────────────────────────────────────

    Private Sub Listar(c As HttpContext)
        c.Response.Write(JsonConvert.SerializeObject(StockService.Listar()))
    End Sub

    Private Sub ListarPorProducto(c As HttpContext)
        c.Response.Write(JsonConvert.SerializeObject(StockService.ListarPorProducto(c.Request("proReferencia"))))
    End Sub

    Private Sub Obtener(c As HttpContext)
        c.Response.Write(JsonConvert.SerializeObject(StockService.Obtener(Convert.ToDecimal(c.Request("hipHistorialPrecio")))))
    End Sub

    Private Sub ObtenerPorNicho(c As HttpContext)
        c.Response.Write(JsonConvert.SerializeObject(
            StockService.ObtenerPorNicho(c.Request("proReferencia"), Convert.ToDecimal(c.Request("nicNicho")))))
    End Sub

    Private Sub Guardar(c As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(c)
        StockService.Guardar(Dec_(d, "hip_historial_precio"), Dec_(d, "minimo"), Dec_(d, "maximo"), Dec_(d, "disponible"))
        c.Response.Write("{""mensaje"": ""Stock guardado con exito""}")
    End Sub

    Private Sub Entrada(c As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(c)
        StockService.Entrada(Dec_(d, "hip_historial_precio"), Dec_(d, "cantidad"))
        c.Response.Write("{""mensaje"": ""Entrada registrada con exito""}")
    End Sub

    Private Sub Salida(c As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(c)
        StockService.Salida(Dec_(d, "hip_historial_precio"), Dec_(d, "cantidad"))
        c.Response.Write("{""mensaje"": ""Salida registrada con exito""}")
    End Sub

    Private Sub Eliminar(c As HttpContext)
        Dim d As Dictionary(Of String, Object) = LeerBody(c)
        StockService.Eliminar(Dec_(d, "hip_historial_precio"))
        c.Response.Write("{""mensaje"": ""Registro de stock eliminado con exito""}")
    End Sub

    ' ── NUEVA ACCIÓN: RecibirDesdePedido ─────────────────────────────────────
    ' Replica exactamente btnEntrada_Click + btnCrearStock_Click de Stock.aspx.vb
    ' Parámetros via querystring (context.Request):
    '   proReferencia, hipSemilla, nichoId, precio, cantRecibida,
    '   cantTotal, detpeId, pedidoId, minimo, maximo
    '
    ' Flujo:
    '   1. ResolverHipParaRecepcion — igual que la función privada de Stock.aspx.vb
    '      Si precio vigente == precio OC → CerrarSemilla + usa HIP vigente
    '      Si precio cambió              → CerrarTodos + ActualizarSemilla (nuevo historial)
    '   2. GuardarStockSumando — igual que la función privada de Stock.aspx.vb
    '      Si tiene stock en ese nicho  → suma disponible + migra HIP si cambió
    '      Si no tiene stock            → crea registro nuevo con minimo/maximo del formulario
    '   3. DetallePedidoService.Actualizar — actualiza cant_recibida en BOD_DETALLE_PEDIDO

    Private Sub RecibirDesdePedido(context As HttpContext)
        Dim proRef        As String  = context.Request("proReferencia")
        Dim hipSemilla    As Decimal = Convert.ToDecimal(context.Request("hipSemilla"))
        Dim nichoId       As Decimal = Convert.ToDecimal(context.Request("nichoId"))
        Dim precio        As Decimal = Decimal.Parse(
                                          context.Request("precio"),
                                          System.Globalization.CultureInfo.InvariantCulture)
        Dim cantIncremento As Decimal = Convert.ToDecimal(context.Request("cantRecibida"))
        Dim cantTotal      As Integer = Convert.ToInt32(context.Request("cantTotal"))
        Dim detpeId        As Integer = Convert.ToInt32(context.Request("detpeId"))
        Dim pedidoId       As Integer = Convert.ToInt32(context.Request("pedidoId"))
        Dim minimoParam    As Decimal = Convert.ToDecimal(If(context.Request("minimo") <> "" AndAlso context.Request("minimo") IsNot Nothing, context.Request("minimo"), "0"))
        Dim maximoParam    As Decimal = Convert.ToDecimal(If(context.Request("maximo") <> "" AndAlso context.Request("maximo") IsNot Nothing, context.Request("maximo"), "0"))
        Dim fechaHoy       As Date    = Date.Today

        ' ── PASO 1: Obtener stock existente en ese nicho ──────────────────────
        ' (igual que ddlNicho_SelectedIndexChanged en Stock.aspx.vb)
        Dim dtExistente    As DataTable = StockService.ObtenerPorNicho(proRef, nichoId)
        Dim minimoFallback As Decimal   = minimoParam
        Dim maximoFallback As Decimal   = maximoParam

        ' Si no tiene stock en ese nicho, intentar recuperar min/max del HIP anterior
        If dtExistente Is Nothing OrElse dtExistente.Rows.Count = 0 Then
            ' Buscar HIP semilla para obtener mínimo/máximo previos
            Dim dtPrev As DataTable = StockService.Obtener(hipSemilla)
            If dtPrev IsNot Nothing AndAlso dtPrev.Rows.Count > 0 Then
                minimoFallback = Convert.ToDecimal(dtPrev.Rows(0)("STO_MINIMO"))
                maximoFallback = Convert.ToDecimal(dtPrev.Rows(0)("STO_MAXIMO"))
            End If
        End If

        ' ── PASO 2: ResolverHipParaRecepcion ─────────────────────────────────
        ' Replica exactamente la función privada de Stock.aspx.vb
        Dim hipFinal As Decimal = hipSemilla
        Dim dtVigenteNicho As DataTable = HistorialPrecioService.Vigente(proRef, nichoId)

        If dtVigenteNicho IsNot Nothing AndAlso dtVigenteNicho.Rows.Count > 0 Then
            Dim precioVigente As Decimal = Convert.ToDecimal(dtVigenteNicho.Rows(0)("HIP_PRECIO"))
            Dim hipVigente    As Decimal = Convert.ToDecimal(dtVigenteNicho.Rows(0)("HIP_HISTORIAL_PRECIO"))
            If precioVigente = precio Then
                ' Precio no cambió → cerrar semilla y usar HIP vigente
                HistorialPrecioService.CerrarSemilla(hipSemilla, fechaHoy)
                hipFinal = hipVigente
            Else
                ' Precio cambió → cerrar todos los vigentes + actualizar semilla (nuevo historial)
                HistorialPrecioService.CerrarTodos(proRef, fechaHoy)
                HistorialPrecioService.ActualizarSemilla(hipSemilla, nichoId, precio, fechaHoy)
                hipFinal = hipSemilla
            End If
        Else
            ' No hay precio vigente en ese nicho → la semilla se convierte en el nuevo historial
            HistorialPrecioService.CerrarTodos(proRef, fechaHoy)
            HistorialPrecioService.ActualizarSemilla(hipSemilla, nichoId, precio, fechaHoy)
            hipFinal = hipSemilla
        End If

        ' ── PASO 3: GuardarStockSumando ──────────────────────────────────────
        ' Replica exactamente la función privada de Stock.aspx.vb
        If dtExistente IsNot Nothing AndAlso dtExistente.Rows.Count > 0 Then
            Dim hipExistente    As Decimal = Convert.ToDecimal(dtExistente.Rows(0)("HIP_HISTORIAL_PRECIO"))
            Dim dispActual      As Decimal = Convert.ToDecimal(dtExistente.Rows(0)("STO_DISPONIBLE"))
            Dim minActual       As Decimal = Convert.ToDecimal(dtExistente.Rows(0)("STO_MINIMO"))
            Dim maxActual       As Decimal = Convert.ToDecimal(dtExistente.Rows(0)("STO_MAXIMO"))
            Dim nuevoDisponible As Decimal = dispActual + cantIncremento
            ' Si el HIP cambió (precio nuevo), eliminar el registro viejo antes de crear el nuevo
            If hipExistente <> hipFinal Then
                StockService.Eliminar(hipExistente)
            End If
            StockService.Guardar(hipFinal, minActual, maxActual, nuevoDisponible)
        Else
            ' Sin stock previo en ese nicho → crear con disponible = cantRecibida
            StockService.Guardar(hipFinal, minimoFallback, maximoFallback, cantIncremento)
        End If

        ' ── PASO 4: Actualizar cant_recibida en BOD_DETALLE_PEDIDO ───────────
        ' Igual que DetallePedidoService.Actualizar al final de btnEntrada_Click
        Dim dtDetalle   As DataTable = DetallePedidoService.ListarPorPedido(pedidoId)
        Dim filaDetalle As DataRow() = dtDetalle.Select("DETPE_DETALLE_PEDIDO = " & detpeId)
        Dim cantSol     As Integer   = If(filaDetalle.Length > 0,
                                          Convert.ToInt32(filaDetalle(0)("DETPE_CANTIDAD_SOLICITADA")),
                                          cantTotal)
        DetallePedidoService.Actualizar(detpeId, cantSol, cantTotal)

        ' Respuesta con info para el móvil
        Dim resultado As New Dictionary(Of String, Object) From {
            {"mensaje", "Recepcion registrada correctamente. Stock e historial actualizados."},
            {"hip_final", hipFinal},
            {"precio_cambio", hipFinal = hipSemilla},
            {"cant_total_recibida", cantTotal}
        }
        context.Response.Write(JsonConvert.SerializeObject(resultado))
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
