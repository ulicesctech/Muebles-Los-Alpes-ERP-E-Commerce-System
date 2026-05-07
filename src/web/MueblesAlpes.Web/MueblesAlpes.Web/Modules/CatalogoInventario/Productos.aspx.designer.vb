'------------------------------------------------------------------------------
' <generado automáticamente>
'     Este código fue generado por una herramienta.
'
'     Los cambios en este archivo podrían causar un comportamiento incorrecto y se perderán si
'     se vuelve a generar el código. 
' </generado automáticamente>
'------------------------------------------------------------------------------

Option Strict On
Option Explicit On

Namespace Modules.CatalogoInventario

    Partial Public Class Productos

        '''<summary>
        '''Control pnlMsg.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlMsg As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control lblMsg.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblMsg As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control lblTituloForm.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblTituloForm As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control hfReferencia.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfReferencia As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfModo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfModo As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control txtReferencia.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtReferencia As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtNombre.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtNombre As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtColor.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtColor As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtPeso.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtPeso As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtDescripcion.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtDescripcion As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control ddlCategoria.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlCategoria As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control ddlTipo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlTipo As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control ddlMaterial.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlMaterial As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control txtAlto.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtAlto As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtAncho.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtAncho As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtProfundidad.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtProfundidad As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control fuFoto.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents fuFoto As Global.System.Web.UI.WebControls.FileUpload

        '''<summary>
        '''Control btnGuardar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnGuardar As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control btnCancelar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnCancelar As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control txtBuscar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtBuscar As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control btnBuscar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnBuscar As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control btnLimpiar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnLimpiar As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control gvProductos.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents gvProductos As Global.System.Web.UI.WebControls.GridView
    End Class
End Namespace
