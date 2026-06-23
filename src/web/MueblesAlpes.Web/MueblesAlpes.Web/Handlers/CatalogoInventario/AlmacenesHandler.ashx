
<%@ WebHandler Language="VB" Class="AlmacenHandler" %>

Imports System
Imports System.Web
Imports System.Data
Imports System.IO
Imports System.Web.Script.Serialization
Imports System.Collections.Generic

Public Class AlmacenHandler : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        ' 1. Configurar Cabeceras y CORS (Crucial para que React Native pueda consumirlo)
        context.Response.ContentType = "application/json"
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        ' Responder a las peticiones "Preflight" de seguridad de las apps
        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        ' 2. Leer la acción requerida y preparar el serializador JSON
        Dim action As String = context.Request.QueryString("action")
        Dim serializer As New JavaScriptSerializer()

        Try
            Select Case action
                Case "listar"
                    ' Ejecutamos el servicio
                    Dim dt As DataTable = AlmacenService.Listar()

                    ' Convertimos el DataTable a una lista de Diccionarios para serializarlo a JSON
                    Dim rows As New List(Of Dictionary(Of String, Object))
                    For Each dr As DataRow In dt.Rows
                        Dim row As New Dictionary(Of String, Object)
                        For Each col As DataColumn In dt.Columns
                            row.Add(col.ColumnName, dr(col))
                        Next
                        rows.Add(row)
                    Next

                    ' Devolvemos la respuesta a React Native
                    context.Response.Write(serializer.Serialize(New With {.status = "success", .data = rows}))

                Case "crear"
                    ' Leer el cuerpo JSON de la petición
                    Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
                    Dim data As Dictionary(Of String, Object) = serializer.Deserialize(Of Dictionary(Of String, Object))(json)

                    ' Llamar al servicio
                    Dim newId As Decimal = AlmacenService.Crear(data("nombre").ToString(), data("pais").ToString(), data("ubicacion").ToString())

                    context.Response.Write(serializer.Serialize(New With {.status = "success", .id = newId, .message = "Almacén creado exitosamente"}))

                Case "actualizar"
                    Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
                    Dim data As Dictionary(Of String, Object) = serializer.Deserialize(Of Dictionary(Of String, Object))(json)

                    AlmacenService.Actualizar(Convert.ToDecimal(data("id")), data("nombre").ToString(), data("pais").ToString(), data("ubicacion").ToString())

                    context.Response.Write(serializer.Serialize(New With {.status = "success", .message = "Almacén actualizado"}))

                Case "eliminar"
                    Dim json As String = New StreamReader(context.Request.InputStream).ReadToEnd()
                    Dim data As Dictionary(Of String, Object) = serializer.Deserialize(Of Dictionary(Of String, Object))(json)

                    AlmacenService.Eliminar(Convert.ToDecimal(data("id")))

                    context.Response.Write(serializer.Serialize(New With {.status = "success", .message = "Almacén eliminado"}))

                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write(serializer.Serialize(New With {.status = "error", .message = "Acción no proporcionada o inválida"}))
            End Select

        Catch ex As Exception
            ' Captura de errores (Ej. Fallo en Oracle)
            context.Response.StatusCode = 500
            context.Response.Write(serializer.Serialize(New With {.status = "error", .message = ex.Message}))
        End Try
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class