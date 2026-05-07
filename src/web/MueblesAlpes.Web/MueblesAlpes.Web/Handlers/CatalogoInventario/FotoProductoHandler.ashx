<%@ WebHandler Language="VB" Class="FotoProductoHandler" %>
Imports System.Web
Imports Oracle.ManagedDataAccess.Client

Public Class FotoProductoHandler : Implements IHttpHandler

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim ref As String = context.Request.QueryString("ref")
        If String.IsNullOrEmpty(ref) Then
            context.Response.StatusCode = 404
            Return
        End If

        Try
            Dim foto As Byte() = Nothing
            Using conn As New OracleConnection(
                System.Configuration.ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
                Dim cmd As New OracleCommand("PKG_BOD_PRODUCTO.OBTENER_FOTO", conn)
                cmd.CommandType = System.Data.CommandType.StoredProcedure
                cmd.Parameters.Add("p_referencia", OracleDbType.Varchar2).Value = ref
                Dim pFoto As New OracleParameter("p_foto", OracleDbType.Blob)
                pFoto.Direction = System.Data.ParameterDirection.Output
                cmd.Parameters.Add(pFoto)
                conn.Open()
                cmd.ExecuteNonQuery()
                If pFoto.Value IsNot DBNull.Value AndAlso pFoto.Value IsNot Nothing Then
                    Dim blob As Oracle.ManagedDataAccess.Types.OracleBlob =
                        CType(pFoto.Value, Oracle.ManagedDataAccess.Types.OracleBlob)
                    foto = blob.Value
                End If
            End Using

            If foto IsNot Nothing AndAlso foto.Length > 0 Then
                context.Response.ContentType = "image/jpeg"
                context.Response.Cache.SetCacheability(HttpCacheability.Public)
                context.Response.Cache.SetExpires(DateTime.Now.AddHours(24))
                context.Response.BinaryWrite(foto)
            Else
                context.Response.Redirect("~/Images/no-foto.png")
            End If
        Catch
            context.Response.Redirect("~/Images/no-foto.png")
        End Try
    End Sub

    Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
        Get
            Return True
        End Get
    End Property

End Class