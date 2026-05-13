Imports System.Web

Namespace MueblesAlpes.Web.Security

    Public Module SecurityGuard

        Public Sub EscribirError(context As HttpContext, statusCode As Integer, mensaje As String)
            context.Response.StatusCode = statusCode
            context.Response.ContentType = "application/json"
            context.Response.Write("{""ok"":false,""mensaje"":""" & mensaje.Replace("""", "\""") & """}")
        End Sub

        Public Function RequiereCliente(context As HttpContext) As Boolean
            If context.Session Is Nothing OrElse context.Session("UsuarioTipo") Is Nothing Then
                EscribirError(context, 401, "Sesion no valida.")
                Return False
            End If

            If context.Session("UsuarioTipo").ToString() <> "CLIENTE" Then
                EscribirError(context, 403, "No tiene permisos para esta accion.")
                Return False
            End If

            Return True
        End Function

        Public Function RequiereEmpleado(context As HttpContext) As Boolean
            If context.Session Is Nothing OrElse context.Session("UsuarioTipo") Is Nothing Then
                EscribirError(context, 401, "Sesion no valida.")
                Return False
            End If

            If context.Session("UsuarioTipo").ToString() <> "EMPLEADO" Then
                EscribirError(context, 403, "No tiene permisos para esta accion.")
                Return False
            End If

            Return True
        End Function

        Public Function ClienteIdActual(context As HttpContext) As Integer
            If context.Session Is Nothing OrElse context.Session("ClienteId") Is Nothing Then
                Return 0
            End If

            Return Convert.ToInt32(context.Session("ClienteId"))
        End Function

        Public Function EmpleadoIdActual(context As HttpContext) As Integer
            If context.Session Is Nothing OrElse context.Session("EmpleadoId") Is Nothing Then
                Return 0
            End If

            Return Convert.ToInt32(context.Session("EmpleadoId"))
        End Function

    End Module

End Namespace