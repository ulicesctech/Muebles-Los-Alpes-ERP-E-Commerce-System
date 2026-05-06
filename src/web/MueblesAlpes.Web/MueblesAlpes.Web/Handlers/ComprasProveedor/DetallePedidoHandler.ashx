<%@ WebHandler Language="VB" Class="DetallePedidoHandler" %>

Imports System
Imports System.Data
Imports System.Web
Imports System.Text

' ============================================================
' RUTA: Handlers/ComprasProveedor/DetallePedidoHandler.ashx
' Service: DetallePedidoService (PKG_BOD_DETALLE_PEDIDO)
'
' GET  ?action=listar-por-pedido&id=1       → DetallePedidoService.ListarPorPedido(pedidoId)
' GET  ?action=listar-productos             → DetallePedidoService.ListarProductos()
' GET  ?action=listar-productos-base        → DetallePedidoService.ListarProductosBase()
' GET  ?action=listar-todos-productos       → DetallePedidoService.ListarTodosProductos()
' POST ?action=insertar                     → DetallePedidoService.Insertar(ped_id, hip_id, pro_referencia, cantidad)
' POST ?action=actualizar                   → DetallePedidoService.Actualizar(detpe_id, cant_solicitada, cant_recibida)
' POST ?action=actualizar-historial         → DetallePedidoService.ActualizarHistorial(detpe_id, hip_id)
' POST ?action=actualizar-semilla           → DetallePedidoService.ActualizarSemilla(hip_id, nic_nicho, precio, fecha_inicio)
' POST ?action=eliminar                     → DetallePedidoService.Eliminar(detpe_id)
' ============================================================
Public Class DetallePedidoHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.Charset = "utf-8"

        Dim method As String = context.Request.HttpMethod.ToUpper()
        Dim action As String = If(context.Request.QueryString("action"), "").ToLower().Trim()

        Try
            Select Case method
                Case "GET"
                    Select Case action
                        Case "listar-por-pedido"      : ListarPorPedido(context)
                        Case "listar-productos"        : ListarProductos(context)
                        Case "listar-productos-base"   : ListarProductosBase(context)
                        Case "listar-todos-productos"  : ListarTodosProductos(context)
                        Case Else
                            Responder(context, 400, "action GET invalida. Opciones: listar-por-pedido, listar-productos, listar-productos-base, listar-todos-productos")
                    End Select
                Case "POST"
                    Select Case action
                        Case "insertar"             : Insertar(context)
                        Case "actualizar"           : Actualizar(context)
                        Case "actualizar-historial" : ActualizarHistorial(context)
                        Case "actualizar-semilla"   : ActualizarSemilla(context)
                        Case "eliminar"             : Eliminar(context)
                        Case Else
                            Responder(context, 400, "action POST invalida. Opciones: insertar, actualizar, actualizar-historial, actualizar-semilla, eliminar")
                    End Select
                Case Else
                    Responder(context, 405, "Metodo HTTP no permitido.")
            End Select
        Catch ex As Exception
            Responder(context, 500, "Error interno: " & ex.Message)
        End Try
    End Sub

    ' GET — listar-por-pedido&id=1
    Private Sub ListarPorPedido(context As HttpContext)
        Dim idStr As String = context.Request.QueryString("id")
        If String.IsNullOrEmpty(idStr) Then
            Responder(context, 400, "Parametro 'id' requerido.") : Return
        End If
        context.Response.Write(DataTableToJson(DetallePedidoService.ListarPorPedido(Convert.ToInt32(idStr))))
    End Sub

    ' GET — listar-productos
    Private Sub ListarProductos(context As HttpContext)
        context.Response.Write(DataTableToJson(DetallePedidoService.ListarProductos()))
    End Sub

    ' GET — listar-productos-base
    Private Sub ListarProductosBase(context As HttpContext)
        context.Response.Write(DataTableToJson(DetallePedidoService.ListarProductosBase()))
    End Sub

    ' GET — listar-todos-productos
    Private Sub ListarTodosProductos(context As HttpContext)
        context.Response.Write(DataTableToJson(DetallePedidoService.ListarTodosProductos()))
    End Sub

    ' POST — insertar
    ' Body: ped_id, hip_id, pro_referencia, cantidad
    Private Sub Insertar(context As HttpContext)
        Dim pedIdStr As String = context.Request.Form("ped_id")
        Dim hipIdStr As String = context.Request.Form("hip_id")
        Dim proRef   As String = context.Request.Form("pro_referencia")
        Dim cantStr  As String = context.Request.Form("cantidad")

        If String.IsNullOrEmpty(pedIdStr) OrElse String.IsNullOrEmpty(hipIdStr) OrElse
           String.IsNullOrEmpty(proRef)   OrElse String.IsNullOrEmpty(cantStr) Then
            Responder(context, 400, "Campos requeridos: ped_id, hip_id, pro_referencia, cantidad") : Return
        End If

        DetallePedidoService.Insertar(Convert.ToInt32(pedIdStr), Convert.ToInt32(hipIdStr),
                                      proRef.Trim(), Convert.ToInt32(cantStr))
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — actualizar
    ' Body: detpe_id, cant_solicitada, cant_recibida
    Private Sub Actualizar(context As HttpContext)
        Dim detpeIdStr As String = context.Request.Form("detpe_id")
        Dim cantSolStr As String = context.Request.Form("cant_solicitada")
        Dim cantRecStr As String = context.Request.Form("cant_recibida")

        If String.IsNullOrEmpty(detpeIdStr) OrElse String.IsNullOrEmpty(cantSolStr) OrElse
           String.IsNullOrEmpty(cantRecStr) Then
            Responder(context, 400, "Campos requeridos: detpe_id, cant_solicitada, cant_recibida") : Return
        End If

        DetallePedidoService.Actualizar(Convert.ToInt32(detpeIdStr),
                                        Convert.ToInt32(cantSolStr),
                                        Convert.ToInt32(cantRecStr))
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — actualizar-historial
    ' Body: detpe_id, hip_id
    Private Sub ActualizarHistorial(context As HttpContext)
        Dim detpeIdStr As String = context.Request.Form("detpe_id")
        Dim hipIdStr   As String = context.Request.Form("hip_id")

        If String.IsNullOrEmpty(detpeIdStr) OrElse String.IsNullOrEmpty(hipIdStr) Then
            Responder(context, 400, "Campos requeridos: detpe_id, hip_id") : Return
        End If

        DetallePedidoService.ActualizarHistorial(Convert.ToInt32(detpeIdStr), Convert.ToInt32(hipIdStr))
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — actualizar-semilla
    ' Body: hip_id, nic_nicho, precio, fecha_inicio (yyyy-MM-dd)
    Private Sub ActualizarSemilla(context As HttpContext)
        Dim hipIdStr As String = context.Request.Form("hip_id")
        Dim nicStr   As String = context.Request.Form("nic_nicho")
        Dim precStr  As String = context.Request.Form("precio")
        Dim fechaStr As String = context.Request.Form("fecha_inicio")

        If String.IsNullOrEmpty(hipIdStr) OrElse String.IsNullOrEmpty(nicStr) OrElse
           String.IsNullOrEmpty(precStr)  OrElse String.IsNullOrEmpty(fechaStr) Then
            Responder(context, 400, "Campos requeridos: hip_id, nic_nicho, precio, fecha_inicio (yyyy-MM-dd)") : Return
        End If

        Dim fechaInicio As Date
        If Not Date.TryParse(fechaStr, fechaInicio) Then
            Responder(context, 400, "Formato de fecha invalido. Use yyyy-MM-dd.") : Return
        End If

        DetallePedidoService.ActualizarSemilla(Convert.ToDecimal(hipIdStr),
                                               Convert.ToDecimal(nicStr),
                                               Convert.ToDecimal(precStr),
                                               fechaInicio)
        context.Response.Write("{""ok"":true}")
    End Sub

    ' POST — eliminar
    ' Body: detpe_id
    Private Sub Eliminar(context As HttpContext)
        Dim detpeIdStr As String = context.Request.Form("detpe_id")
        If String.IsNullOrEmpty(detpeIdStr) Then
            Responder(context, 400, "Campo 'detpe_id' requerido.") : Return
        End If
        DetallePedidoService.Eliminar(Convert.ToInt32(detpeIdStr))
        context.Response.Write("{""ok"":true}")
    End Sub

    Private Sub Responder(context As HttpContext, statusCode As Integer, mensaje As String)
        context.Response.StatusCode = statusCode
        context.Response.Write("{""ok"":false,""error"":""" & mensaje.Replace("\", "\\").Replace("""", "\""") & """}")
    End Sub

    Private Function DataTableToJson(dt As DataTable) As String
        If dt Is Nothing OrElse dt.Rows.Count = 0 Then Return "[]"
        Dim sb As New StringBuilder
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
                    sb.Append("""" & val.ToString().Replace("\", "\\").Replace("""", "\""").Replace(vbCr, "").Replace(vbLf, " ") & """")
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
