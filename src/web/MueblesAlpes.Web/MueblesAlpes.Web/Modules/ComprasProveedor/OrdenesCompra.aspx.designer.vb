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

    Partial Public Class OrdenesCompra

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
        '''Control btnNuevaOrden.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnNuevaOrden As Global.System.Web.UI.WebControls.Button

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
        '''Control gvOrdenes.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents gvOrdenes As Global.System.Web.UI.WebControls.GridView

        '''<summary>
        '''Control pnlFormCabecera.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlFormCabecera As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control hfKey.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfKey As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control ddlProveedor.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlProveedor As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control txtBuscarPedido.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtBuscarPedido As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control btnBuscarPedido.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnBuscarPedido As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control pnlResultadosPedidos.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlResultadosPedidos As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control gvBuscarPedidos.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents gvBuscarPedidos As Global.System.Web.UI.WebControls.GridView

        '''<summary>
        '''Control pnlItemsPedido.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlItemsPedido As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control hfPedidoVinculado.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfPedidoVinculado As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control lblPedidoId.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblPedidoId As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control lblPedidoCodigo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblPedidoCodigo As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control lnkQuitarPedido.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lnkQuitarPedido As Global.System.Web.UI.WebControls.LinkButton

        '''<summary>
        '''Control gvItemsPedido.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents gvItemsPedido As Global.System.Web.UI.WebControls.GridView

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
        '''Control pnlDetalleOrden.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlDetalleOrden As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control lblOrdenSeleccionada.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblOrdenSeleccionada As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control btnCerrarDetalle.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnCerrarDetalle As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control hfOrdenActiva.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfOrdenActiva As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control gvItemsOrden.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents gvItemsOrden As Global.System.Web.UI.WebControls.GridView

        '''<summary>
        '''Control lblTotalOrden.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblTotalOrden As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control btnFinalizarOrden.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnFinalizarOrden As Global.System.Web.UI.WebControls.Button
    End Class
End Namespace
