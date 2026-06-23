Option Strict On
Option Explicit On

Namespace MueblesAlpes.Web.Modules.AuthUsuarios.Admin
    Partial Public Class GrupoUsuarioPage
        Protected WithEvents lblMensaje As Global.System.Web.UI.WebControls.Label
        Protected WithEvents lblError As Global.System.Web.UI.WebControls.Label
        Protected WithEvents hfPermisoId As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfGrupoId As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfPermisoFormOpen As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfPermisoEditing As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfGrupoFormOpen As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfGrupoEditing As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfPermisoSeleccionado As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents chkAdmin As Global.System.Web.UI.WebControls.CheckBox
        Protected WithEvents chkRH As Global.System.Web.UI.WebControls.CheckBox
        Protected WithEvents chkFac As Global.System.Web.UI.WebControls.CheckBox
        Protected WithEvents chkCli As Global.System.Web.UI.WebControls.CheckBox
        Protected WithEvents chkBod As Global.System.Web.UI.WebControls.CheckBox
        Protected WithEvents chkPromo As Global.System.Web.UI.WebControls.CheckBox
        Protected WithEvents btnGuardarPermiso As Global.System.Web.UI.WebControls.Button
        Protected WithEvents btnNuevoPermiso As Global.System.Web.UI.WebControls.Button
        Protected WithEvents gvPermisos As Global.System.Web.UI.WebControls.GridView
        Protected WithEvents txtDescripcion As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents ddlPermisos As Global.System.Web.UI.WebControls.DropDownList
        Protected WithEvents btnGuardarGrupo As Global.System.Web.UI.WebControls.Button
        Protected WithEvents btnNuevoGrupo As Global.System.Web.UI.WebControls.Button
        Protected WithEvents gvGrupos As Global.System.Web.UI.WebControls.GridView
    End Class
End Namespace