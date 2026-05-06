Option Strict On
Option Explicit On

Namespace MueblesAlpes.Web.Modules.AuthUsuarios
    Partial Public Class ClientesPage
        Protected WithEvents lblMensaje As Global.System.Web.UI.WebControls.Label
        Protected WithEvents lblError As Global.System.Web.UI.WebControls.Label
        Protected WithEvents hfId As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfFormOpen As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfFormEditing As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents ddlTipoDoc As Global.System.Web.UI.WebControls.DropDownList
        Protected WithEvents txtNumDoc As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtNIT As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents ddlTipoCliente As Global.System.Web.UI.WebControls.DropDownList
        Protected WithEvents txtPrimerNombre As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtSegundoNombre As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtPrimerApellido As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtSegundoApellido As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtEmail As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtProfesion As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtPassword As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtTelefono1 As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtTelefono2 As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtPais As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtDepartamento As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtMunicipio As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtZona As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtDireccion As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtCodigoPostal As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents btnGuardar As Global.System.Web.UI.WebControls.Button
        Protected WithEvents btnNuevo As Global.System.Web.UI.WebControls.Button
        Protected WithEvents txtBuscarEmail As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents txtBuscarDoc As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents btnBuscar As Global.System.Web.UI.WebControls.Button
        Protected WithEvents btnVerTodos As Global.System.Web.UI.WebControls.Button
        Protected WithEvents gvClientes As Global.System.Web.UI.WebControls.GridView
        Protected WithEvents lblResultado As Global.System.Web.UI.WebControls.Label
    End Class
End Namespace