Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class LoginEmpleadoService
    Private Const PKG As String = "PKG_ADMIN_LOGIN_EMPLEADO"

    Public Shared Function Login(usuario As String, password As String) As LoginEmpleadoResult
        Dim result As New LoginEmpleadoResult()
        Dim pResultado As New OracleParameter("p_resultado", OracleDbType.Decimal, ParameterDirection.Output)
        Dim pEmpleado As New OracleParameter("p_em_empleado", OracleDbType.Decimal, ParameterDirection.Output)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_usuario", OracleDbType.Varchar2, usuario, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input),
            pResultado,
            pEmpleado
        }
        OracleDb.ExecNonQuery(PKG & ".log_em_validar", ps)
        result.Resultado = Convert.ToInt32(pResultado.Value.ToString())

        If result.Resultado = 1 Then
            result.EmpleadoId = Convert.ToInt32(pEmpleado.Value.ToString())
            Dim dtEmp As DataTable = EmpleadoService.Buscar(result.EmpleadoId)
            If dtEmp.Rows.Count > 0 Then
                Dim rowEmp = dtEmp.Rows(0)
                result.Nombre = rowEmp("em_primer_nombre").ToString() & " " &
                                rowEmp("em_primer_apellido").ToString()
                Dim rolId As Integer = Convert.ToInt32(rowEmp("rolus_rol_usuario").ToString())
                Dim dtGru As DataTable = GrupoUsuarioService.Buscar(rolId)
                If dtGru.Rows.Count > 0 Then
                    Dim rowGru = dtGru.Rows(0)
                    result.Grupo = rowGru("grupus_descripcion").ToString()
                    Dim permisoId As Integer = Convert.ToInt32(rowGru("per_permisos").ToString())
                    Dim dtPer As DataTable = PermisoService.Listar()
                    For Each rowPer As DataRow In dtPer.Rows
                        If Convert.ToInt32(rowPer("per_permisos")) = permisoId Then
                            result.PerAdmin = Convert.ToInt32(rowPer("per_admin").ToString())
                            result.PerRH = Convert.ToInt32(rowPer("per_rh").ToString())
                            result.PerFac = Convert.ToInt32(rowPer("per_fac").ToString())
                            result.PerCli = Convert.ToInt32(rowPer("per_cli").ToString())
                            result.PerBod = Convert.ToInt32(rowPer("per_bod").ToString())
                            result.PerPromo = Convert.ToInt32(rowPer("per_promo").ToString())
                            Exit For
                        End If
                    Next
                End If
            End If
        End If
        Return result
    End Function

    Public Shared Sub Crear(emId As Integer, usuario As String, password As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_em_empleado", OracleDbType.Decimal, emId, ParameterDirection.Input),
            New OracleParameter("p_usuario", OracleDbType.Varchar2, usuario, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".log_em_crear", ps)
    End Sub

    Public Shared Sub ActualizarPassword(emId As Integer, password As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_em_empleado", OracleDbType.Decimal, emId, ParameterDirection.Input),
            New OracleParameter("p_password", OracleDbType.Varchar2, password, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".log_em_actualizar_pass", ps)
    End Sub

    Public Shared Sub Eliminar(emId As Integer)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_em_empleado", OracleDbType.Decimal, emId, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".log_em_eliminar", ps)
    End Sub
End Class

Public Class LoginEmpleadoResult
    Public Property Resultado As Integer
    Public Property EmpleadoId As Integer
    Public Property Nombre As String
    Public Property Grupo As String
    Public Property PerAdmin As Integer
    Public Property PerRH As Integer
    Public Property PerFac As Integer
    Public Property PerCli As Integer
    Public Property PerBod As Integer
    Public Property PerPromo As Integer
End Class