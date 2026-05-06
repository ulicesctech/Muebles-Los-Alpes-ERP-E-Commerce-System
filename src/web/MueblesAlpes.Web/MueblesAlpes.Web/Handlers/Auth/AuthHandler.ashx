<%@ WebHandler Language="VB" Class="MueblesAlpes.Web.Handlers.Auth.AuthHandler" %>

Imports System.Web
Imports System.Web.SessionState
Imports System.IO
Imports Newtonsoft.Json

Namespace MueblesAlpes.Web.Handlers.Auth

    Public Class AuthHandler
        Implements IHttpHandler, IRequiresSessionState

        Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
            Get
                Return False
            End Get
        End Property

        Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
            context.Response.ContentType = "application/json"
            context.Response.Charset     = "utf-8"
            context.Response.Cache.SetNoStore()
            context.Response.AddHeader("Access-Control-Allow-Origin",  "*")
            context.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
            context.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

            If context.Request.HttpMethod = "OPTIONS" Then
                context.Response.StatusCode = 200
                Return
            End If

            Dim action As String = context.Request.QueryString("action")

            Try
                Select Case action
                    Case "login-empleado" : LoginEmpleado(context)
                    Case "login-cliente" : LoginCliente(context)
                    Case "registro" : RegistroCliente(context)
                    Case "listar-empleados" : ListarEmpleados(context)
                    Case "crear-empleado" : CrearEmpleado(context)
                    Case "actualizar-empleado" : ActualizarEmpleado(context)
                    Case "eliminar-empleado" : EliminarEmpleado(context)
                    Case "listar-clientes" : ListarClientes(context)
                    Case "crear-cliente" : CrearCliente(context)
                    Case "actualizar-cliente" : ActualizarCliente(context)
                    Case "eliminar-cliente" : EliminarCliente(context)
                    Case "listar-puestos" : ListarPuestos(context)
                    Case "crear-puesto" : CrearPuesto(context)
                    Case "actualizar-puesto" : ActualizarPuesto(context)
                    Case "eliminar-puesto" : EliminarPuesto(context)
                    Case "listar-ascensos" : ListarAscensos(context)
                    Case "crear-ascenso" : CrearAscenso(context)
                    Case "cerrar-ascenso" : CerrarAscenso(context)
                    Case "eliminar-ascenso" : EliminarAscenso(context)
                    Case "listar-permisos" : ListarPermisos(context)
                    Case "crear-permiso" : CrearPermiso(context)
                    Case "actualizar-permiso" : ActualizarPermiso(context)
                    Case "eliminar-permiso" : EliminarPermiso(context)
                    Case "listar-grupos" : ListarGrupos(context)
                    Case "crear-grupo" : CrearGrupo(context)
                    Case "actualizar-grupo" : ActualizarGrupo(context)
                    Case "eliminar-grupo" : EliminarGrupo(context)
                    Case Else
                        context.Response.StatusCode = 400
                        context.Response.Write(JsonConvert.SerializeObject(New With {
                            .ok = False, .mensaje = "Accion no reconocida."
                        }))
                End Select
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok = False, .mensaje = "Error interno: " & ex.Message
                }))
            End Try
        End Sub

        '══════════════════════════════════════════════════════
        ' AUTH
        '══════════════════════════════════════════════════════
        Private Sub LoginEmpleado(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body     As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos    As Object = JsonConvert.DeserializeObject(body)
            Dim usuario  As String = ObtenerCampo(datos, "usuario")
            Dim password As String = ObtenerCampo(datos, "password")
            If String.IsNullOrWhiteSpace(usuario) OrElse String.IsNullOrWhiteSpace(password) Then
                context.Response.StatusCode = 400
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "usuario y password son obligatorios."}))
                Return
            End If
            Dim result As LoginEmpleadoResult = LoginEmpleadoService.Login(usuario, password)
            If result.Resultado = 1 Then
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok          = True,
                    .rol         = "EMPLEADO",
                    .em_empleado = result.EmpleadoId,
                    .nombre      = result.Nombre,
                    .grupo       = result.Grupo,
                    .permisos    = New With {
                        .admin = result.PerAdmin,
                        .rh    = result.PerRH,
                        .fac   = result.PerFac,
                        .cli   = result.PerCli,
                        .bod   = result.PerBod,
                        .promo = result.PerPromo
                    }
                }))
            Else
                context.Response.StatusCode = 401
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Usuario o contrasena incorrectos."}))
            End If
        End Sub

        Private Sub LoginCliente(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body     As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos    As Object = JsonConvert.DeserializeObject(body)
            Dim usuario  As String = ObtenerCampo(datos, "usuario")
            Dim password As String = ObtenerCampo(datos, "password")
            If String.IsNullOrWhiteSpace(usuario) OrElse String.IsNullOrWhiteSpace(password) Then
                context.Response.StatusCode = 400
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "usuario y password son obligatorios."}))
                Return
            End If
            Dim result As LoginClienteResult = LoginClienteService.Validar(usuario, password)
            If result.Resultado = 1 Then
                Dim dt     As System.Data.DataTable = ClienteService.BuscarPorId(result.ClienteId)
                Dim nombre As String = ""
                Dim email  As String = ""
                If dt.Rows.Count > 0 Then
                    nombre = dt.Rows(0)("cli_primer_nombre").ToString() & " " & dt.Rows(0)("cli_primer_apellido").ToString()
                    email  = dt.Rows(0)("cli_email").ToString()
                End If
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok = True, .rol = "CLIENTE", .cli_cliente = result.ClienteId, .nombre = nombre, .email = email
                }))
            Else
                context.Response.StatusCode = 401
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Email o contrasena incorrectos."}))
            End If
        End Sub

        Private Sub RegistroCliente(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Dim tipoDoc         As String = ObtenerCampo(datos, "tipodocumento")
            Dim numDoc          As String = ObtenerCampo(datos, "numdocumento")
            Dim primerNombre    As String = ObtenerCampo(datos, "primer_nombre")
            Dim primerApellido  As String = ObtenerCampo(datos, "primer_apellido")
            Dim email           As String = ObtenerCampo(datos, "email")
            Dim telefono        As String = ObtenerCampo(datos, "primer_telefono")
            Dim pais            As String = ObtenerCampo(datos, "pais")
            Dim departamento    As String = ObtenerCampo(datos, "departamento")
            Dim municipio       As String = ObtenerCampo(datos, "municipio")
            Dim zona            As String = ObtenerCampo(datos, "zona")
            Dim direccion       As String = ObtenerCampo(datos, "direccion")
            Dim codigoPostal    As String = ObtenerCampo(datos, "codigo_postal")
            Dim tipoCliente     As String = ObtenerCampo(datos, "tipocliente", "NATURAL")
            Dim segundoNombre   As String = ObtenerCampo(datos, "segundo_nombre")
            Dim segundoApellido As String = ObtenerCampo(datos, "segundo_apellido")
            Dim nit             As String = ObtenerCampo(datos, "nit")
            Dim profesion       As String = ObtenerCampo(datos, "profesion")
            Dim telefono2       As String = ObtenerCampo(datos, "segundo_telefono")
            Dim password        As String = ObtenerCampo(datos, "password")
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
                    .ok = True, .cli_cliente = nuevoId, .mensaje = "Cliente registrado exitosamente."
                }))
            Catch ex As Exception
                Dim msg As String = If(ex.Message.Contains("20006"), "El email o documento ya esta registrado.", "Error: " & ex.Message)
                context.Response.StatusCode = 409
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = msg}))
            End Try
        End Sub

        '══════════════════════════════════════════════════════
        ' EMPLEADOS
        '══════════════════════════════════════════════════════
        Private Sub ListarEmpleados(context As HttpContext)
            Dim dt  As System.Data.DataTable = EmpleadoService.Listar()
            Dim lst As New List(Of Object)
            For Each row As System.Data.DataRow In dt.Rows
                lst.Add(New With {
                    .em_empleado         = row("em_empleado"),
                    .em_DPI              = row("em_DPI"),
                    .em_primer_nombre    = row("em_primer_nombre"),
                    .em_segundo_nombre   = row("em_segundo_nombre"),
                    .em_primer_apellido  = row("em_primer_apellido"),
                    .em_segundo_apellido = row("em_segundo_apellido"),
                    .em_direccion        = row("em_direccion"),
                    .em_avenida          = row("em_avenida"),
                    .em_codigo_postal    = row("em_codigo_postal"),
                    .em_primer_telefono  = row("em_primer_telefono"),
                    .em_segundo_telefono = row("em_segundo_telefono"),
                    .rolus_rol_usuario   = row("rolus_rol_usuario"),
                    .rol_nombre          = row("rol_nombre")
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
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
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
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub ActualizarEmpleado(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
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
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub EliminarEmpleado(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                EmpleadoService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "em_empleado")))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Empleado eliminado."}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        '══════════════════════════════════════════════════════
        ' CLIENTES
        '══════════════════════════════════════════════════════
        Private Sub ListarClientes(context As HttpContext)
            Dim dt  As System.Data.DataTable = ClienteService.Listar()
            Dim lst As New List(Of Object)
            For Each row As System.Data.DataRow In dt.Rows
                lst.Add(New With {
                    .cli_cliente         = row("cli_cliente"),
                    .cli_tipodocumento   = row("cli_tipodocumento"),
                    .cli_numdocumento    = row("cli_numdocumento"),
                    .cli_primer_nombre   = row("cli_primer_nombre"),
                    .cli_primer_apellido = row("cli_primer_apellido"),
                    .cli_email           = row("cli_email"),
                    .cli_primer_telefono = row("cli_primer_telefono"),
                    .cli_pais            = row("cli_pais"),
                    .cli_tipocliente     = row("cli_tipocliente")
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
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
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
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub ActualizarCliente(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
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
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub EliminarCliente(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                ClienteService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "cli_cliente")))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Cliente eliminado."}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        '══════════════════════════════════════════════════════
        ' PUESTOS
        '══════════════════════════════════════════════════════
        Private Sub ListarPuestos(context As HttpContext)
            Dim dt  As System.Data.DataTable = PuestoService.Listar()
            Dim lst As New List(Of Object)
            For Each row As System.Data.DataRow In dt.Rows
                lst.Add(New With {
                    .pue_puestos     = row("pue_puestos"),
                    .pue_nombre      = row("pue_nombre"),
                    .pue_salario     = row("pue_salario"),
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
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                Dim nuevoId As Integer = PuestoService.Crear(
                    ObtenerCampo(datos, "nombre"),
                    Convert.ToDecimal(ObtenerCampo(datos, "salario", "0")),
                    ObtenerCampo(datos, "descripcion"))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .pue_puestos = nuevoId}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub ActualizarPuesto(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
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
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub EliminarPuesto(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                PuestoService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "pue_puestos")))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Puesto eliminado."}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        '══════════════════════════════════════════════════════
        ' ASCENSOS
        '══════════════════════════════════════════════════════
        Private Sub ListarAscensos(context As HttpContext)
            Dim dt As System.Data.DataTable = AscensoService.Listar()
            Dim lst As New List(Of Object)
            For Each row As System.Data.DataRow In dt.Rows
                lst.Add(New With {
                    .asc_ascenso = row("asc_ascenso"),
                    .pue_puestos = row("pue_puestos"),
                    .em_empleado = row("em_empleado"),
                    .asc_fecha_inicio = row("asc_fecha_inicio"),
                    .asc_fecha_final = row("asc_fecha_final"),
                    .pue_nombre = row("pue_nombre"),
                    .em_nombre = row("em_nombre_completo")
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
                Dim fechaInicio As Date = Date.Now
                Dim fechaFinalStr As String = ObtenerCampo(datos, "fecha_final")
                Dim fechaFinal As Date? = Nothing
                If Not String.IsNullOrWhiteSpace(fechaFinalStr) Then
                    fechaFinal = Convert.ToDateTime(fechaFinalStr)
                End If
                Dim nuevoId As Integer = AscensoService.Crear(
                    Convert.ToInt32(ObtenerCampo(datos, "pue_puestos")),
                    Convert.ToInt32(ObtenerCampo(datos, "em_empleado")),
                    fechaInicio,
                    fechaFinal)
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .asc_ascenso = nuevoId}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
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
                    Date.Now)
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Ascenso cerrado."}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub EliminarAscenso(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                AscensoService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "asc_ascenso")))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Ascenso eliminado."}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        '══════════════════════════════════════════════════════
        ' PERMISOS
        '══════════════════════════════════════════════════════
        Private Sub ListarPermisos(context As HttpContext)
            Dim dt  As System.Data.DataTable = PermisoService.Listar()
            Dim lst As New List(Of Object)
            For Each row As System.Data.DataRow In dt.Rows
                lst.Add(New With {
                    .per_permisos = row("per_permisos"),
                    .per_admin    = row("per_admin"),
                    .per_rh       = row("per_rh"),
                    .per_fac      = row("per_fac"),
                    .per_cli      = row("per_cli"),
                    .per_bod      = row("per_bod"),
                    .per_promo    = row("per_promo")
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
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                Dim nuevoId As Integer = PermisoService.Crear(
                    Convert.ToInt32(ObtenerCampo(datos, "admin", "0")),
                    Convert.ToInt32(ObtenerCampo(datos, "rh",    "0")),
                    Convert.ToInt32(ObtenerCampo(datos, "fac",   "0")),
                    Convert.ToInt32(ObtenerCampo(datos, "cli",   "0")),
                    Convert.ToInt32(ObtenerCampo(datos, "bod",   "0")),
                    Convert.ToInt32(ObtenerCampo(datos, "promo", "0")))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .per_permisos = nuevoId}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub ActualizarPermiso(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                PermisoService.Actualizar(
                    Convert.ToInt32(ObtenerCampo(datos, "per_permisos")),
                    Convert.ToInt32(ObtenerCampo(datos, "admin", "0")),
                    Convert.ToInt32(ObtenerCampo(datos, "rh",    "0")),
                    Convert.ToInt32(ObtenerCampo(datos, "fac",   "0")),
                    Convert.ToInt32(ObtenerCampo(datos, "cli",   "0")),
                    Convert.ToInt32(ObtenerCampo(datos, "bod",   "0")),
                    Convert.ToInt32(ObtenerCampo(datos, "promo", "0")))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Permiso actualizado."}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub EliminarPermiso(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                PermisoService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "per_permisos")))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Permiso eliminado."}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        '══════════════════════════════════════════════════════
        ' GRUPOS
        '══════════════════════════════════════════════════════
        Private Sub ListarGrupos(context As HttpContext)
            Dim dt  As System.Data.DataTable = GrupoUsuarioService.Listar()
            Dim lst As New List(Of Object)
            For Each row As System.Data.DataRow In dt.Rows
                lst.Add(New With {
                    .grupus_grupo_usuario = row("grupus_grupo_usuario"),
                    .grupus_descripcion   = row("grupus_descripcion"),
                    .per_permisos         = row("per_permisos")
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
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                Dim nuevoId As Integer = GrupoUsuarioService.Crear(
                    ObtenerCampo(datos, "descripcion"),
                    Convert.ToInt32(ObtenerCampo(datos, "per_permisos")))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .grupus_grupo_usuario = nuevoId}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub ActualizarGrupo(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                GrupoUsuarioService.Actualizar(
                    Convert.ToInt32(ObtenerCampo(datos, "grupus_grupo_usuario")),
                    ObtenerCampo(datos, "descripcion"),
                    Convert.ToInt32(ObtenerCampo(datos, "per_permisos")))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Grupo actualizado."}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        Private Sub EliminarGrupo(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = "Use POST."}))
                Return
            End If
            Dim body  As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)
            Try
                GrupoUsuarioService.Eliminar(Convert.ToInt32(ObtenerCampo(datos, "grupus_grupo_usuario")))
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = True, .mensaje = "Grupo eliminado."}))
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {.ok = False, .mensaje = ex.Message}))
            End Try
        End Sub

        '══════════════════════════════════════════════════════
        ' HELPER
        '══════════════════════════════════════════════════════
        Private Function ObtenerCampo(datos As Object, campo As String,
                                       Optional defVal As String = "") As String
            Try
                Dim val = datos(campo)
                If val Is Nothing Then Return defVal
                Return val.ToString().Trim()
            Catch
                Return defVal
            End Try
        End Function

    End Class
End Namespace