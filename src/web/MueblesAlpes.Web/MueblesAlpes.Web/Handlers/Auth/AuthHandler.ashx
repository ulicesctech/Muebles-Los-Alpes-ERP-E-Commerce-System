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
                    Case "login-empleado"
                        LoginEmpleado(context)
                    Case "login-cliente"
                        LoginCliente(context)
                    Case "registro"
                        RegistroCliente(context)
                    Case Else
                        context.Response.StatusCode = 400
                        context.Response.Write(JsonConvert.SerializeObject(New With {
                            .ok      = False,
                            .mensaje = "Accion no reconocida. Use: login-empleado, login-cliente, registro"
                        }))
                End Select
            Catch ex As Exception
                context.Response.StatusCode = 500
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok      = False,
                    .mensaje = "Error interno: " & ex.Message
                }))
            End Try
        End Sub

        Private Sub LoginEmpleado(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok = False, .mensaje = "Use POST."
                }))
                Return
            End If

            Dim body     As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos    As Object = JsonConvert.DeserializeObject(body)
            Dim usuario  As String = datos("usuario").ToString().Trim()
            Dim password As String = datos("password").ToString().Trim()

            If String.IsNullOrWhiteSpace(usuario) OrElse String.IsNullOrWhiteSpace(password) Then
                context.Response.StatusCode = 400
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok = False, .mensaje = "usuario y password son obligatorios."
                }))
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
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok      = False,
                    .mensaje = "Usuario o contrasena incorrectos."
                }))
            End If
        End Sub

        Private Sub LoginCliente(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok = False, .mensaje = "Use POST."
                }))
                Return
            End If

            Dim body     As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos    As Object = JsonConvert.DeserializeObject(body)
            Dim usuario  As String = datos("usuario").ToString().Trim()
            Dim password As String = datos("password").ToString().Trim()

            If String.IsNullOrWhiteSpace(usuario) OrElse String.IsNullOrWhiteSpace(password) Then
                context.Response.StatusCode = 400
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok = False, .mensaje = "usuario y password son obligatorios."
                }))
                Return
            End If

            Dim result As LoginClienteResult = LoginClienteService.Validar(usuario, password)

            If result.Resultado = 1 Then
                Dim dt As System.Data.DataTable = ClienteService.BuscarPorId(result.ClienteId)
                Dim nombre As String = ""
                Dim email  As String = ""
                If dt.Rows.Count > 0 Then
                    Dim row = dt.Rows(0)
                    nombre = row("cli_primer_nombre").ToString() & " " &
                             row("cli_primer_apellido").ToString()
                    email  = row("cli_email").ToString()
                End If
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok          = True,
                    .rol         = "CLIENTE",
                    .cli_cliente = result.ClienteId,
                    .nombre      = nombre,
                    .email       = email
                }))
            Else
                context.Response.StatusCode = 401
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok      = False,
                    .mensaje = "Email o contrasena incorrectos."
                }))
            End If
        End Sub

        Private Sub RegistroCliente(context As HttpContext)
            If context.Request.HttpMethod <> "POST" Then
                context.Response.StatusCode = 405
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok = False, .mensaje = "Use POST."
                }))
                Return
            End If

            Dim body As String = New StreamReader(context.Request.InputStream).ReadToEnd()
            Dim datos As Object = JsonConvert.DeserializeObject(body)

            Dim tipoDoc        As String = ObtenerCampo(datos, "tipodocumento")
            Dim numDoc         As String = ObtenerCampo(datos, "numdocumento")
            Dim primerNombre   As String = ObtenerCampo(datos, "primer_nombre")
            Dim primerApellido As String = ObtenerCampo(datos, "primer_apellido")
            Dim email          As String = ObtenerCampo(datos, "email")
            Dim telefono       As String = ObtenerCampo(datos, "primer_telefono")
            Dim pais           As String = ObtenerCampo(datos, "pais")
            Dim departamento   As String = ObtenerCampo(datos, "departamento")
            Dim municipio      As String = ObtenerCampo(datos, "municipio")
            Dim zona           As String = ObtenerCampo(datos, "zona")
            Dim direccion      As String = ObtenerCampo(datos, "direccion")
            Dim codigoPostal   As String = ObtenerCampo(datos, "codigo_postal")
            Dim tipoCliente    As String = ObtenerCampo(datos, "tipocliente", "NATURAL")
            Dim segundoNombre   As String = ObtenerCampo(datos, "segundo_nombre")
            Dim segundoApellido As String = ObtenerCampo(datos, "segundo_apellido")
            Dim nit             As String = ObtenerCampo(datos, "nit")
            Dim profesion       As String = ObtenerCampo(datos, "profesion")
            Dim telefono2       As String = ObtenerCampo(datos, "segundo_telefono")

            If String.IsNullOrWhiteSpace(tipoDoc) OrElse
               String.IsNullOrWhiteSpace(numDoc) OrElse
               String.IsNullOrWhiteSpace(primerNombre) OrElse
               String.IsNullOrWhiteSpace(primerApellido) OrElse
               String.IsNullOrWhiteSpace(email) OrElse
               String.IsNullOrWhiteSpace(telefono) OrElse
               String.IsNullOrWhiteSpace(pais) OrElse
               String.IsNullOrWhiteSpace(departamento) OrElse
               String.IsNullOrWhiteSpace(municipio) OrElse
               String.IsNullOrWhiteSpace(zona) OrElse
               String.IsNullOrWhiteSpace(direccion) OrElse
               String.IsNullOrWhiteSpace(codigoPostal) Then
                context.Response.StatusCode = 400
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok      = False,
                    .mensaje = "Faltan campos obligatorios."
                }))
                Return
            End If

            Try
                Dim nuevoId As Integer = ClienteService.Crear(
                    tipoDoc, numDoc, nit,
                    primerNombre, segundoNombre,
                    primerApellido, segundoApellido,
                    pais, departamento, municipio,
                    zona, direccion, codigoPostal,
                    telefono, telefono2,
                    email, profesion, tipoCliente)

                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok          = True,
                    .cli_cliente = nuevoId,
                    .mensaje     = "Cliente registrado exitosamente."
                }))
            Catch ex As Exception
                Dim msg As String = If(ex.Message.Contains("20006") OrElse
                                       ex.Message.ToLower().Contains("ya registrado"),
                                       "El email o documento ya esta registrado.",
                                       "Error al registrar: " & ex.Message)
                context.Response.StatusCode = 409
                context.Response.Write(JsonConvert.SerializeObject(New With {
                    .ok = False, .mensaje = msg
                }))
            End Try
        End Sub

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