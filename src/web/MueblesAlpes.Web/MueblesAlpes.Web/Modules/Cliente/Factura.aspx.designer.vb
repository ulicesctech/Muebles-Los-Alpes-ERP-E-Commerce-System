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

Namespace Modules.Cliente

    Partial Public Class Factura

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
        '''Control pnlCheckout.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlCheckout As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control ddlTipoDoc.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlTipoDoc As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control txtNumDoc.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtNumDoc As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtNombre.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtNombre As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtEmail.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtEmail As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtTelefono.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtTelefono As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtDireccion.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtDireccion As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtMunicipio.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtMunicipio As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtDepartamento.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtDepartamento As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtZona.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtZona As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtCodigoPostal.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtCodigoPostal As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control ddlFormaPago.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlFormaPago As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control txtNit.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtNit As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control rptResumen.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents rptResumen As Global.System.Web.UI.WebControls.Repeater

        '''<summary>
        '''Control lblSubtotal.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblSubtotal As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control lblTotal.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblTotal As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control btnConfirmar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnConfirmar As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control pnlConfirmacion.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlConfirmacion As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control lblCodigoFactura.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblCodigoFactura As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control pnlCrearCuenta.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlCrearCuenta As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control pnlLogueadoOk.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlLogueadoOk As Global.System.Web.UI.WebControls.Panel
    End Class
End Namespace
