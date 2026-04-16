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

Namespace Modules.ComprasProveedor

    Partial Public Class Pedidos

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
        '''Control btnNuevoPedido.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnNuevoPedido As Global.System.Web.UI.WebControls.Button

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
        '''Control gvPedidos.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents gvPedidos As Global.System.Web.UI.WebControls.GridView

        '''<summary>
        '''Control pnlFormCabecera.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlFormCabecera As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control txtCodigo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtCodigo As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control ddlFormaPago.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlFormaPago As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control btnGuardar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnGuardar As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control btnCancelarForm.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnCancelarForm As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control pnlDetalleContenedor.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlDetalleContenedor As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control lblIdSeleccionado.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblIdSeleccionado As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control btnCerrarDetalle.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnCerrarDetalle As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control hfPedidoActivo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfPedidoActivo As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfDetalleRecibir.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfDetalleRecibir As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control lblCabeceraCode.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblCabeceraCode As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control lblCabeceraFecha.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblCabeceraFecha As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control ddlCabeceraFormaPago.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlCabeceraFormaPago As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control btnGuardarCabecera.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnGuardarCabecera As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control ddlProducto.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlProducto As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control txtCantSolicitada.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtCantSolicitada As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control btnAgregarItem.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnAgregarItem As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control gvDetalles.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents gvDetalles As Global.System.Web.UI.WebControls.GridView

        '''<summary>
        '''Control lblTotalDetalle.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblTotalDetalle As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control btnFinalizarPedido.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnFinalizarPedido As Global.System.Web.UI.WebControls.Button
    End Class
End Namespace
