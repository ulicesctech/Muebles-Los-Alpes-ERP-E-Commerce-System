Imports System.IO
Imports System.Web

Public Class SecurityLogger

    Private Shared Function GetLogPath() As String
        Dim appPath As String = AppDomain.CurrentDomain.BaseDirectory
        Dim dataPath As String = Path.Combine(appPath, "App_Data")
        If Not Directory.Exists(dataPath) Then
            Directory.CreateDirectory(dataPath)
        End If
        Return Path.Combine(dataPath, "seguridad.log")
    End Function

    Private Shared Function GetErrorLogPath() As String
        Dim appPath As String = AppDomain.CurrentDomain.BaseDirectory
        Dim dataPath As String = Path.Combine(appPath, "App_Data")
        If Not Directory.Exists(dataPath) Then
            Directory.CreateDirectory(dataPath)
        End If
        Return Path.Combine(dataPath, "error_log.txt")
    End Function

    Public Shared Sub LogLoginExitoso(usuario As String, ip As String)
        Escribir("LOGIN_OK", usuario, ip)
    End Sub

    Public Shared Sub LogLoginFallido(usuario As String, ip As String)
        Escribir("LOGIN_FAIL", usuario, ip)
    End Sub

    Public Shared Sub LogCuentaBloqueada(ip As String)
        Escribir("BLOQUEADO", "N/A", ip)
    End Sub

    Private Shared Sub Escribir(evento As String, usuario As String, ip As String)
        Try
            Dim linea As String = String.Format(
            "[{0}] {1} | Usuario: {2} | IP: {3}{4}",
            DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
            evento,
            usuario,
            ip,
            Environment.NewLine)
            Dim appPath As String = AppDomain.CurrentDomain.BaseDirectory
            Dim dataPath As String = Path.Combine(appPath, "App_Data")
            If Not Directory.Exists(dataPath) Then Directory.CreateDirectory(dataPath)
            File.AppendAllText(Path.Combine(dataPath, "seguridad.log"), linea)
        Catch
        End Try
    End Sub

End Class