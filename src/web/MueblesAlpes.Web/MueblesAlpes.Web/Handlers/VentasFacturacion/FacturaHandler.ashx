<%@ WebHandler Language="VB" Class="FacturaHandler" %>

Imports System
Imports System.Text
Imports System.Web
Imports System.Data

Public Class FacturaHandler
    Implements IHttpHandler

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.Charset = "utf-8"

        Dim method As String = context.Request.HttpMethod.ToUpper()
        Dim action As String = If(context.Request("action"), "").ToLower()

        Try
            If method = "GET" Then
                Select Case action
                    Case "listar"
                        Dim dt As DataTable = FacturaService.Listar()
                        context.Response.Write(SerializeTable(dt))

                    Case Else
                        context.Response.StatusCode = 400
                        context.Response.Write("{""error"":""Accion GET no reconocida""}")
                End Select

            ElseIf method = "POST" Then
                Select Case action
                    Case "crear"
                        Dim carrito As Decimal = Convert.ToDecimal(context.Request("carrito"))
                        Dim empleado As Decimal = Convert.ToDecimal(context.Request("empleado"))
                        Dim formaPago As String = If(String.IsNullOrEmpty(context.Request("formaPago")), "EFECTIVO", context.Request("formaPago"))
                        Dim tipoEntrega As String = If(String.IsNullOrEmpty(context.Request("tipoEntrega")), "DOMICILIO", context.Request("tipoEntrega"))
                        Dim almacenRaw As String = context.Request("almacen")
                        Dim almacen As Object = If(String.IsNullOrEmpty(almacenRaw), Nothing, CType(Convert.ToDecimal(almacenRaw), Object))
                        Dim codigo As String = FacturaService.Crear(carrito, empleado, formaPago, tipoEntrega, almacen)
                        context.Response.Write("{""codigo"":""" & codigo.Replace("""", "\""") & """}")

                    Case Else
                        context.Response.StatusCode = 400
                        context.Response.Write("{""error"":""Accion POST no reconocida""}")
                End Select

            Else
                context.Response.StatusCode = 405
                context.Response.Write("{""error"":""Metodo no permitido""}")
            End If

        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write("{""error"":""" & ex.Message.Replace("\", "\\").Replace("""", "\""") & """}")
        End Try
    End Sub

    Private Function SerializeTable(dt As DataTable) As String
        Dim sb As New StringBuilder()
        sb.Append("[")
        Dim firstRow As Boolean = True
        For Each row As DataRow In dt.Rows
            If Not firstRow Then sb.Append(",")
            firstRow = False
            sb.Append("{")
            For i As Integer = 0 To dt.Columns.Count - 1
                If i > 0 Then sb.Append(",")
                sb.Append("""" & dt.Columns(i).ColumnName & """:")
                Dim val As Object = row(i)
                If IsDBNull(val) Then
                    sb.Append("null")
                ElseIf TypeOf val Is Date Then
                    sb.Append("""" & CDate(val).ToString("yyyy-MM-dd") & """")
                ElseIf TypeOf val Is Decimal OrElse TypeOf val Is Integer OrElse TypeOf val Is Long Then
                    sb.Append(val.ToString())
                Else
                    sb.Append("""" & val.ToString().Replace("\", "\\").Replace("""", "\""") & """")
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
