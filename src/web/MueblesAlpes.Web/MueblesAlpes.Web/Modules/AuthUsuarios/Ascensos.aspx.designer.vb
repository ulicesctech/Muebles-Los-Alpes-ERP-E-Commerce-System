Option Strict On
Option Explicit On

Namespace MueblesAlpes.Web.Modules.AuthUsuarios
    Partial Public Class AscensosPage
        Protected WithEvents lblMensaje As Global.System.Web.UI.WebControls.Label
        Protected WithEvents lblError As Global.System.Web.UI.WebControls.Label
        Protected WithEvents hfId As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfMode As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents ddlEmpleado As Global.System.Web.UI.WebControls.DropDownList
        Protected WithEvents pnlPuestoActual As Global.System.Web.UI.WebControls.Panel
        Protected WithEvents litPuestoActual As Global.System.Web.UI.WebControls.Literal
        Protected WithEvents litSalarioActual As Global.System.Web.UI.WebControls.Literal
        Protected WithEvents ddlPuesto As Global.System.Web.UI.WebControls.DropDownList
        Protected WithEvents pnlSinPuestos As Global.System.Web.UI.WebControls.Panel
        Protected WithEvents btnGuardar As Global.System.Web.UI.WebControls.Button
        Protected WithEvents btnNuevo As Global.System.Web.UI.WebControls.Button
        Protected WithEvents gvAscensos As Global.System.Web.UI.WebControls.GridView
    End Class
End Namespace