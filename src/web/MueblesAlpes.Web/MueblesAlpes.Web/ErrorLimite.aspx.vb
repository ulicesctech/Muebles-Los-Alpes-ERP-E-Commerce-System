Public Class ErrorLimite
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ' Verificamos si la petición viene de la App Móvil (fetchAPI)
        ' En tu apiClient.ts le configuramos: Accept: "application/json"
        Dim acceptHeader As String = Request.Headers("Accept")

        If acceptHeader IsNot Nothing AndAlso acceptHeader.Contains("application/json") Then
            ' Si es la App Móvil, limpiamos el HTML y solo devolvemos el JSON puro
            Response.Clear()
            Response.ContentType = "application/json"

            ' Aseguramos que los códigos CORS estén presentes por si acaso
            Response.AddHeader("Access-Control-Allow-Origin", "*")

            Dim json As String = "{""status"": ""error"", ""message"": ""Demasiadas peticiones. Por favor, espere un momento antes de volver a intentar.""}"
            Response.Write(json)
            Response.End()
        End If

        ' Si llega hasta aquí, significa que es un usuario en su PC viendo la Web.
        ' Simplemente dejamos que la página HTML bonita se renderice normal.
    End Sub

End Class