<%@ WebHandler Language="VB" Class="AuthHandler" %>

Imports System
Imports System.Web
Imports System.Web.SessionState
Imports System.IO
Imports System.Collections.Generic
Imports Newtonsoft.Json

Public Class AuthHandler
    Implements IHttpHandler, IRequiresSessionState

    Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        context.Response.Charset = "utf-8"
        context.Response.Cache.SetNoStore()
        context.Response.AddHeader("Access-Control-Allow-Origin", "*")
        context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Cookie")
        context.Response.AddHeader("Access-Control-Allow-Credentials", "true")

        If context.Request.HttpMethod = "OPTIONS" Then
            context.Response.StatusCode = 200
            Return
        End If

        Dim action As String = context.Request.QueryString("action")

        Try
            Select Case action

                Case "login-empleado"
                    LoginEmpleado(context)

                Case "login-cliente"
                    LoginCliente(context)

                Case "registro"
                    RegistroCliente(context)

                Case "logout"
                    CerrarSesion(context)

                Case "listar-empleados"
                    If Not RequiereEmpleado(context) Then Return
                    ListarEmpleados(context)

                Case "crear-empleado"
                    If Not RequiereEmpleado(context) Then Return
                    CrearEmpleado(context)

                Case "actualizar-empleado"
                    If Not RequiereEmpleado(context) Then Return
                    ActualizarEmpleado(context)

                Case "eliminar-empleado"
                    If Not RequiereEmpleado(context) Then Return
                    EliminarEmpleado(context)

                Case "listar-clientes"
                    If Not RequiereEmpleado(context) Then Return
                    ListarClientes(context)

                Case "crear-cliente"
                    If Not RequiereEmpleado(context) Then Return
                    CrearCliente(context)

                Case "actualizar-cliente"
                    If Not RequiereEmpleado(context) Then Return
                    ActualizarCliente(context)

                Case "eliminar-cliente"
                    If Not RequiereEmpleado(context) Then Return
                    EliminarCliente(context)

                Case "listar-puestos"
                    If Not RequiereEmpleado(context) Then Return
                    ListarPuestos(context)

                Case "crear-puesto"
                    If Not RequiereEmpleado(context) Then Return
                    CrearPuesto(context)

                Case "actualizar-puesto"
                    If Not RequiereEmpleado(context) Then Return
                    ActualizarPuesto(context)

                Case "eliminar-puesto"
                    If Not RequiereEmpleado(context) Then Return
                    EliminarPuesto(context)

                Case "listar-ascensos"
                    If Not RequiereEmpleado(context) Then Return
                    ListarAscensos(context)

                Case "crear-ascenso"
                    If Not RequiereEmpleado(context) Then Return
                    CrearAscenso(context)

                Case "cerrar-ascenso"
                    If Not RequiereEmpleado(context) Then Return
                    CerrarAscenso(context)

                Case "eliminar-ascenso"
                    If Not RequiereEmpleado(context) Then Return
                    EliminarAscenso(context)

                Case "listar-permisos"
                    If Not RequiereEmpleado(context) Then Return
                    ListarPermisos(context)

                Case "crear-permiso"
                    If Not RequiereEmpleado(context) Then Return
                    CrearPermiso(context)

                Case "actualizar-permiso"
                    If Not RequiereEmpleado(context) Then Return
                    ActualizarPermiso(context)

                Case "eliminar-permiso"
                    If Not RequiereEmpleado(context) Then Return
                    EliminarPermiso(context)

                Case "listar-grupos"
                    If Not RequiereEmpleado(context) Then Return
                    ListarGrupos(context)

                Case "crear-grupo"
                    If Not RequiereEmpleado(context) Then Return
                    CrearGrupo(context)

                Case "actualizar-grupo"
                    If Not RequiereEmpleado(context) Then Return
                    ActualizarGrupo(context)

                Case "eliminar-grupo"
                    If Not RequiereEmpleado(context) Then Return
                    EliminarGrupo(context)

                Case Else
                    context.Response.StatusCode = 400
                    context.Response.Write(JsonConvert.SerializeObject(New With {
                        .ok = False,
                        .mensaje = "Accion no reconocida."
                    }))
            End Select

        Catch ex As Exception
            context.Response.StatusCode = 500

            Dim mensaje As String = "No se pudo procesar la solicitud."

            If action = "login-cliente" OrElse action = "login-empleado" Then
                context.Response.StatusCode = 401
                mensaje = "Credenciales invalidas. Verifica tu usuario y contrasena."
            End If

            context.Response.Write(JsonConvert.SerializeObject(New With {
                .ok = False,
                .mensaje = mensaje
            }))
        End Try
    End Sub

    Private Function RequiereEmpleado(context As HttpContext) As Boolean
        If context.Session Is Nothing OrElse context.Session("UsuarioTipo") Is Nothing Then
            context.Response.StatusCode = 401
            context.Response.Write(JsonConvert.SerializeObject(New With {
                .ok = False,
                .mensaje = "Sesion no valida."
            }))
            Return False
        End If

        If context.Session("UsuarioTipo").ToString() <> "EMPLEADO" Then
            context.Response.StatusCode = 403
            context.Response.Write(JsonConvert.SerializeObject(New With {
                .ok = False,
                .mensaje = "No tiene permisos para esta accion."
            }))
            Return False
        End If

        Return True
    End Function

    Private Function RequiereCliente(context As HttpContext) As Boolean
        If context.Session Is Nothing OrElse context.Session("UsuarioTipo") Is Nothing Then
            context.Response.StatusCode = 401
            context.Response.Write(JsonConvert.SerializeObject(New With {
                .ok = False,
                .mensaje = "Sesion no valida."
            }))
            Return False
        End If

        If context.Session("UsuarioTipo").ToString() <> "CLIENTE" Then
            context.Response.StatusCode = 403
            context.Response.Write(JsonConvert.SerializeObject(New With {
                .ok = False,
                .mensaje = "No tiene permisos para esta accion."
            }))
            Return False
        End If

        Return True
    End Function

    Private Sub CerrarSesion(context As HttpContext)
        If context.Session IsNot Nothing Then
            context.Session.Clear()
            context.Session.Abandon()
        End If
        context.Response.Write(JsonConvert.SerializeObject(New With {
            .ok = True,
            .mensaje = "Sesion cerrada."
        }))
    End Sub

    Private Sub LoginEmpleado(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Metodo no permitido. Use POST."}))
            Return
        End If

        Try
            Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Dim usuario As String = ObtenerCampo(datos, "usuario")
            Dim password As String = ObtenerCampo(datos, "password")

            If String.IsNullOrWhiteSpace(usuario) OrElse String.IsNullOrWhiteSpace(password) Then
                context.Response.StatusCode = 400
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Debe ingresar usuario y contrasena."}))
                Return
            End If

            Dim result As LoginEmpleadoResult = Nothing
            Try
                result = LoginEmpleadoService.Login(usuario, password)
            Catch
                context.Response.StatusCode = 401
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Credenciales invalidas. Verifica tu usuario y contrasena."}))
                Return
            End Try

            If result Is Nothing OrElse result.Resultado <> 1 Then
                context.Response.StatusCode = 401
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Credenciales invalidas. Verifica tu usuario y contrasena."}))
                Return
            End If

            context.Session("UsuarioTipo") = "EMPLEADO"
            context.Session("EmpleadoId") = result.EmpleadoId
            context.Session("EmpleadoNombre") = result.Nombre
            context.Session("Grupo") = result.Grupo
            context.Session("PerAdmin") = result.PerAdmin
            context.Session("PerRH") = result.PerRH
            context.Session("PerFac") = result.PerFac
            context.Session("PerCli") = result.PerCli
            context.Session("PerBod") = result.PerBod
            context.Session("PerPromo") = result.PerPromo

            context.Response.Write(JsonConvert.SerializeObject(New With {
                .ok = True,
                .rol = "EMPLEADO",
                .em_empleado = result.EmpleadoId,
                .nombre = result.Nombre,
                .grupo = result.Grupo,
                .sessionId = context.Session.SessionID,
                .permisos = New With {
                    .admin = result.PerAdmin,
                    .rh = result.PerRH,
                    .fac = result.PerFac,
                    .cli = result.PerCli,
                    .bod = result.PerBod,
                    .promo = result.PerPromo
                }
            }))

        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo iniciar sesion. Intenta nuevamente."}))
        End Try
    End Sub

    Private Sub LoginCliente(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Metodo no permitido. Use POST."}))
            Return
        End If

        Try
            Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Dim usuario As String = ObtenerCampo(datos, "usuario")
            Dim password As String = ObtenerCampo(datos, "password")

            If String.IsNullOrWhiteSpace(usuario) OrElse String.IsNullOrWhiteSpace(password) Then
                context.Response.StatusCode = 400
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Debe ingresar usuario y contrasena."}))
                Return
            End If

            Dim result As LoginClienteResult = Nothing
            Try
                result = LoginClienteService.Validar(usuario, password, 2)
            Catch
                context.Response.StatusCode = 401
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Credenciales invalidas. Verifica tu usuario y contrasena."}))
                Return
            End Try

            If result Is Nothing OrElse result.Resultado <> 1 Then
                context.Response.StatusCode = 401
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Credenciales invalidas. Verifica tu usuario y contrasena."}))
                Return
            End If

            Dim dt As System.Data.DataTable = ClienteService.BuscarPorId(result.ClienteId)
            Dim nombre As String = ""
            Dim email As String = ""

            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                nombre = dt.Rows(0)("cli_primer_nombre").ToString() & " " & dt.Rows(0)("cli_primer_apellido").ToString()
                email = dt.Rows(0)("cli_email").ToString()
            End If

            context.Session("UsuarioTipo") = "CLIENTE"
            context.Session("ClienteId") = result.ClienteId
            context.Session("ClienteNombre") = nombre
            context.Session("ClienteEmail") = email

            context.Response.Write(JsonConvert.SerializeObject(New With {
                .ok = True,
                .rol = "CLIENTE",
                .cli_cliente = result.ClienteId,
                .nombre = nombre,
                .email = email,
                .sessionId = context.Session.SessionID
            }))

        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo iniciar sesion. Intenta nuevamente."}))
        End Try
    End Sub

    Private Sub RegistroCliente(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If

        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)

        Dim tipoDoc As String = ObtenerCampo(datos, "tipodocumento")
        Dim numDoc As String = ObtenerCampo(datos, "numdocumento")
        Dim primerNombre As String = ObtenerCampo(datos, "primer_nombre")
        Dim primerApellido As String = ObtenerCampo(datos, "primer_apellido")
        Dim email As String = ObtenerCampo(datos, "email")
        Dim telefono As String = ObtenerCampo(datos, "primer_telefono")
        Dim pais As String = ObtenerCampo(datos, "pais")
        Dim departamento As String = ObtenerCampo(datos, "departamento")
        Dim municipio As String = ObtenerCampo(datos, "municipio")
        Dim zona As String = ObtenerCampo(datos, "zona")
        Dim direccion As String = ObtenerCampo(datos, "direccion")
        Dim codigoPostal As String = ObtenerCampo(datos, "codigo_postal")
        Dim tipoCliente As String = ObtenerCampo(datos, "tipocliente", "NATURAL")
        Dim segundoNombre As String = ObtenerCampo(datos, "segundo_nombre")
        Dim segundoApellido As String = ObtenerCampo(datos, "segundo_apellido")
        Dim nit As String = ObtenerCampo(datos, "nit")
        Dim profesion As String = ObtenerCampo(datos, "profesion")
        Dim telefono2 As String = ObtenerCampo(datos, "segundo_telefono")
        Dim password As String = ObtenerCampo(datos, "password")

        If String.IsNullOrWhiteSpace(tipoDoc) OrElse String.IsNullOrWhiteSpace(numDoc) OrElse
           String.IsNullOrWhiteSpace(primerNombre) OrElse String.IsNullOrWhiteSpace(primerApellido) OrElse
           String.IsNullOrWhiteSpace(email) OrElse String.IsNullOrWhiteSpace(telefono) OrElse
           String.IsNullOrWhiteSpace(pais) OrElse String.IsNullOrWhiteSpace(departamento) OrElse
           String.IsNullOrWhiteSpace(municipio) OrElse String.IsNullOrWhiteSpace(zona) OrElse
           String.IsNullOrWhiteSpace(direccion) OrElse String.IsNullOrWhiteSpace(codigoPostal) OrElse
           String.IsNullOrWhiteSpace(password) Then
            context.Response.StatusCode = 400
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Faltan campos obligatorios."}))
            Return
        End If

        Try
            Dim nuevoId As Integer = ClienteService.Crear(
                tipoDoc, numDoc, nit, primerNombre, segundoNombre,
                primerApellido, segundoApellido, pais, departamento,
                municipio, zona, direccion, codigoPostal,
                telefono, telefono2, email, profesion, tipoCliente, password)

            context.Response.Write(JsonConvert.SerializeObject(New With {
                .ok = True,
                .cli_cliente = nuevoId,
                .mensaje = "Cliente registrado exitosamente."
            }))
        Catch ex As Exception
            Dim msg As String = If(ex.Message.Contains("20006"), "El email o documento ya esta registrado.", "No se pudo registrar el cliente.")
            context.Response.StatusCode = 409
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = msg}))
        End Try
    End Sub

    Private Sub ListarEmpleados(context As HttpContext)
        Dim dt As System.Data.DataTable = EmpleadoService.Listar()
        Dim lst As New List(Of Object)
        For Each row As System.Data.DataRow In dt.Rows
            lst.Add(New With {
                .em_empleado = row("em_empleado"),
                .em_DPI = row("em_DPI"),
                .em_primer_nombre = row("em_primer_nombre"),
                .em_segundo_nombre = row("em_segundo_nombre"),
                .em_primer_apellido = row("em_primer_apellido"),
                .em_segundo_apellido = row("em_segundo_apellido"),
                .em_direccion = row("em_direccion"),
                .em_avenida = row("em_avenida"),
                .em_codigo_postal = row("em_codigo_postal"),
                .em_primer_telefono = row("em_primer_telefono"),
                .em_segundo_telefono = row("em_segundo_telefono"),
                .rolus_rol_usuario = row("rolus_rol_usuario"),
                .rol_nombre = row("rol_nombre")
            })
        Next
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub CrearEmpleado(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            Dim nuevoId As Integer = EmpleadoService.Crear(
                ObtenerCampo(datos, "dpi"),
                ObtenerCampo(datos, "primer_nombre"),
                ObtenerCampo(datos, "segundo_nombre", " "),
                ObtenerCampo(datos, "primer_apellido"),
                ObtenerCampo(datos, "segundo_apellido", " "),
                ObtenerCampo(datos, "direccion"),
                ObtenerCampo(datos, "avenida"),
                ObtenerCampo(datos, "codigo_postal"),
                ObtenerCampo(datos, "primer_telefono"),
                ObtenerCampo(datos, "segundo_telefono", " "),
                Convert.ToInt32(ObtenerCampo(datos, "rol", "0")),
                ObtenerCampo(datos, "password"))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .em_empleado = nuevoId}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo crear el empleado."}))
        End Try
    End Sub

    Private Sub ActualizarEmpleado(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            EmpleadoService.Actualizar(
                Convert.ToInt32(ObtenerCampo(datos, "em_empleado")),
                ObtenerCampo(datos, "dpi"),
                ObtenerCampo(datos, "primer_nombre"),
                ObtenerCampo(datos, "segundo_nombre", " "),
                ObtenerCampo(datos, "primer_apellido"),
                ObtenerCampo(datos, "segundo_apellido", " "),
                ObtenerCampo(datos, "direccion"),
                ObtenerCampo(datos, "avenida"),
                ObtenerCampo(datos, "codigo_postal"),
                ObtenerCampo(datos, "primer_telefono"),
                ObtenerCampo(datos, "segundo_telefono", " "),
                Convert.ToInt32(ObtenerCampo(datos, "rol", "0")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Empleado actualizado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo actualizar el empleado."}))
        End Try
    End Sub

    Private Sub EliminarEmpleado(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            EmpleadoService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "em_empleado")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Empleado eliminado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo eliminar el empleado."}))
        End Try
    End Sub

    Private Sub ListarClientes(context As HttpContext)
        Dim dt As System.Data.DataTable = ClienteService.Listar()
        Dim lst As New List(Of Object)
        For Each row As System.Data.DataRow In dt.Rows
            lst.Add(New With {
                .cli_cliente = row("cli_cliente"),
                .cli_tipodocumento = row("cli_tipodocumento"),
                .cli_numdocumento = row("cli_numdocumento"),
                .cli_primer_nombre = row("cli_primer_nombre"),
                .cli_primer_apellido = row("cli_primer_apellido"),
                .cli_email = row("cli_email"),
                .cli_primer_telefono = row("cli_primer_telefono"),
                .cli_pais = row("cli_pais"),
                .cli_tipocliente = row("cli_tipocliente")
            })
        Next
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub CrearCliente(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            Dim nuevoId As Integer = ClienteService.Crear(
                ObtenerCampo(datos, "tipodocumento"),
                ObtenerCampo(datos, "numdocumento"),
                ObtenerCampo(datos, "nit", " "),
                ObtenerCampo(datos, "primer_nombre"),
                ObtenerCampo(datos, "segundo_nombre", " "),
                ObtenerCampo(datos, "primer_apellido"),
                ObtenerCampo(datos, "segundo_apellido", " "),
                ObtenerCampo(datos, "pais"),
                ObtenerCampo(datos, "departamento"),
                ObtenerCampo(datos, "municipio"),
                ObtenerCampo(datos, "zona"),
                ObtenerCampo(datos, "direccion"),
                ObtenerCampo(datos, "codigo_postal"),
                ObtenerCampo(datos, "primer_telefono"),
                ObtenerCampo(datos, "segundo_telefono", " "),
                ObtenerCampo(datos, "email"),
                ObtenerCampo(datos, "profesion", " "),
                ObtenerCampo(datos, "tipocliente", "NATURAL"),
                ObtenerCampo(datos, "password"))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .cli_cliente = nuevoId}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo crear el cliente."}))
        End Try
    End Sub

    Private Sub ActualizarCliente(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            ClienteService.Actualizar(
                Convert.ToInt32(ObtenerCampo(datos, "cli_cliente")),
                ObtenerCampo(datos, "tipodocumento"),
                ObtenerCampo(datos, "numdocumento"),
                ObtenerCampo(datos, "nit", " "),
                ObtenerCampo(datos, "primer_nombre"),
                ObtenerCampo(datos, "segundo_nombre", " "),
                ObtenerCampo(datos, "primer_apellido"),
                ObtenerCampo(datos, "segundo_apellido", " "),
                ObtenerCampo(datos, "pais"),
                ObtenerCampo(datos, "departamento"),
                ObtenerCampo(datos, "municipio"),
                ObtenerCampo(datos, "zona"),
                ObtenerCampo(datos, "direccion"),
                ObtenerCampo(datos, "codigo_postal"),
                ObtenerCampo(datos, "primer_telefono"),
                ObtenerCampo(datos, "segundo_telefono", " "),
                ObtenerCampo(datos, "email"),
                ObtenerCampo(datos, "profesion", " "),
                ObtenerCampo(datos, "tipocliente", "NATURAL"))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Cliente actualizado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo actualizar el cliente."}))
        End Try
    End Sub

    Private Sub EliminarCliente(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            ClienteService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "cli_cliente")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Cliente eliminado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo eliminar el cliente."}))
        End Try
    End Sub

    Private Sub ListarPuestos(context As HttpContext)
        Dim dt As System.Data.DataTable = PuestoService.Listar()
        Dim lst As New List(Of Object)
        For Each row As System.Data.DataRow In dt.Rows
            lst.Add(New With {
                .pue_puestos = row("pue_puestos"),
                .pue_nombre = row("pue_nombre"),
                .pue_salario = row("pue_salario"),
                .pue_descripcion = row("pue_descripcion")
            })
        Next
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub CrearPuesto(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            Dim nuevoId As Integer = PuestoService.Crear(
                ObtenerCampo(datos, "nombre"),
                Convert.ToDecimal(ObtenerCampo(datos, "salario", "0")),
                ObtenerCampo(datos, "descripcion"))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .pue_puestos = nuevoId}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo crear el puesto."}))
        End Try
    End Sub

    Private Sub ActualizarPuesto(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            PuestoService.Actualizar(
                Convert.ToInt32(ObtenerCampo(datos, "pue_puestos")),
                ObtenerCampo(datos, "nombre"),
                Convert.ToDecimal(ObtenerCampo(datos, "salario", "0")),
                ObtenerCampo(datos, "descripcion"))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Puesto actualizado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo actualizar el puesto."}))
        End Try
    End Sub

    Private Sub EliminarPuesto(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            PuestoService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "pue_puestos")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Puesto eliminado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo eliminar el puesto."}))
        End Try
    End Sub

    Private Sub ListarAscensos(context As HttpContext)
        Dim dt As System.Data.DataTable = AscensoService.Listar()
        Dim lst As New List(Of Object)
        For Each row As System.Data.DataRow In dt.Rows
            Dim fechaFin As Object = row("asc_fecha_final")
            Dim estaActivo As Boolean = IsDBNull(fechaFin)
            lst.Add(New With {
                .asc_ascenso = row("asc_ascenso"),
                .pue_puestos = row("pue_puestos"),
                .em_empleado = row("em_empleado"),
                .asc_fecha_inicio = If(IsDBNull(row("asc_fecha_inicio")), "", Convert.ToDateTime(row("asc_fecha_inicio")).ToString("yyyy-MM-dd")),
                .asc_fecha_fin = If(estaActivo, Nothing, Convert.ToDateTime(fechaFin).ToString("yyyy-MM-dd")),
                .puesto_nombre = row("pue_nombre"),
                .empleado_nombre = row("em_nombre_completo"),
                .asc_estado = If(estaActivo, "ACTIVO", "CERRADO")
            })
        Next
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub CrearAscenso(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            Dim fechaInicioTexto As String = ObtenerCampo(datos, "fecha_inicio")
            Dim fechaFinalTexto As String = ObtenerCampo(datos, "fecha_final")

            Dim fechaInicio As Date
            If String.IsNullOrWhiteSpace(fechaInicioTexto) Then
                fechaInicio = Date.Today
            Else
                fechaInicio = Convert.ToDateTime(fechaInicioTexto)
            End If

            Dim fechaFinal As Date? = Nothing
            If Not String.IsNullOrWhiteSpace(fechaFinalTexto) Then
                fechaFinal = Convert.ToDateTime(fechaFinalTexto)
            End If

            Dim nuevoId As Integer = AscensoService.Crear(
                Convert.ToInt32(ObtenerCampo(datos, "pue_puestos")),
                Convert.ToInt32(ObtenerCampo(datos, "em_empleado")),
                fechaInicio,
                fechaFinal)

            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .asc_ascenso = nuevoId}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo crear el ascenso."}))
        End Try
    End Sub

    Private Sub CerrarAscenso(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            AscensoService.ActualizarFechaFinal(
                Convert.ToInt32(ObtenerCampo(datos, "asc_ascenso")),
                Date.Today)
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Ascenso cerrado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo cerrar el ascenso."}))
        End Try
    End Sub

    Private Sub EliminarAscenso(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            AscensoService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "asc_ascenso")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Ascenso eliminado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo eliminar el ascenso."}))
        End Try
    End Sub

    Private Sub ListarPermisos(context As HttpContext)
        Dim dt As System.Data.DataTable = PermisoService.Listar()
        Dim lst As New List(Of Object)
        For Each row As System.Data.DataRow In dt.Rows
            lst.Add(New With {
                .per_permisos = row("per_permisos"),
                .per_admin = row("per_admin"),
                .per_rh = row("per_rh"),
                .per_fac = row("per_fac"),
                .per_cli = row("per_cli"),
                .per_bod = row("per_bod"),
                .per_promo = row("per_promo")
            })
        Next
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub CrearPermiso(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            Dim nuevoId As Integer = PermisoService.Crear(
                Convert.ToInt32(ObtenerCampo(datos, "admin", "0")),
                Convert.ToInt32(ObtenerCampo(datos, "rh", "0")),
                Convert.ToInt32(ObtenerCampo(datos, "fac", "0")),
                Convert.ToInt32(ObtenerCampo(datos, "cli", "0")),
                Convert.ToInt32(ObtenerCampo(datos, "bod", "0")),
                Convert.ToInt32(ObtenerCampo(datos, "promo", "0")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .per_permisos = nuevoId}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo crear el permiso."}))
        End Try
    End Sub

    Private Sub ActualizarPermiso(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            PermisoService.Actualizar(
                Convert.ToInt32(ObtenerCampo(datos, "per_permisos")),
                Convert.ToInt32(ObtenerCampo(datos, "admin", "0")),
                Convert.ToInt32(ObtenerCampo(datos, "rh", "0")),
                Convert.ToInt32(ObtenerCampo(datos, "fac", "0")),
                Convert.ToInt32(ObtenerCampo(datos, "cli", "0")),
                Convert.ToInt32(ObtenerCampo(datos, "bod", "0")),
                Convert.ToInt32(ObtenerCampo(datos, "promo", "0")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Permiso actualizado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo actualizar el permiso."}))
        End Try
    End Sub

    Private Sub EliminarPermiso(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            PermisoService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "per_permisos")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Permiso eliminado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo eliminar el permiso."}))
        End Try
    End Sub

    Private Sub ListarGrupos(context As HttpContext)
        Dim dt As System.Data.DataTable = GrupoUsuarioService.Listar()
        Dim lst As New List(Of Object)
        For Each row As System.Data.DataRow In dt.Rows
            lst.Add(New With {
                .grupus_grupo_usuario = row("grupus_grupo_usuario"),
                .grupus_descripcion = row("grupus_descripcion"),
                .per_permisos = row("per_permisos")
            })
        Next
        context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .data = lst}))
    End Sub

    Private Sub CrearGrupo(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            Dim nuevoId As Integer = GrupoUsuarioService.Crear(
                ObtenerCampo(datos, "descripcion"),
                Convert.ToInt32(ObtenerCampo(datos, "per_permisos")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .grupus_grupo_usuario = nuevoId}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo crear el grupo."}))
        End Try
    End Sub

    Private Sub ActualizarGrupo(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            GrupoUsuarioService.Actualizar(
                Convert.ToInt32(ObtenerCampo(datos, "grupus_grupo_usuario")),
                ObtenerCampo(datos, "descripcion"),
                Convert.ToInt32(ObtenerCampo(datos, "per_permisos")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Grupo actualizado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo actualizar el grupo."}))
        End Try
    End Sub

    Private Sub EliminarGrupo(context As HttpContext)
        If context.Request.HttpMethod <> "POST" Then
            context.Response.StatusCode = 405
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
            Return
        End If
        Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
        Dim datos As Object = JsonConvert.DeserializeObject(body)
        Try
            GrupoUsuarioService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "grupus_grupo_usuario")))
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Grupo eliminado."}))
        Catch ex As Exception
            context.Response.StatusCode = 500
            context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "No se pudo eliminar el grupo."}))
        End Try
    End Sub

    Private Function ObtenerCampo(datos As Object, campo As String, Optional defVal As String = "") As String
        Try
            Dim val = datos(campo)
            If val Is Nothing Then Return defVal
            Return val.ToString().Trim()
        Catch
            Return defVal
        End Try
    End Function

End Class