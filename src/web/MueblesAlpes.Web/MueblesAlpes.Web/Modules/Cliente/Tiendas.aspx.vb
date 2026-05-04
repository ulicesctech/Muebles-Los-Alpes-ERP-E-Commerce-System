Imports System.Data

Namespace Modules.Cliente

    Public Class Tiendas
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarTiendas()
            End If
        End Sub

        Private Sub CargarTiendas()
            Try
                Dim dt As DataTable = OracleDb.ExecRefCursor(
                    "PKG_BOD_ALMACEN.LISTAR", Nothing, "p_data")
                rptTiendas.DataSource = dt
                rptTiendas.DataBind()
            Catch ex As Exception
            End Try
        End Sub

    End Class

End Namespace