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

    Partial Public Class Stock

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
        '''Control hfFromPed.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfFromPed As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfPedParam.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfPedParam As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfHipSemilla.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfHipSemilla As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfDetpeParam.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfDetpeParam As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfPrecioODP.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfPrecioODP As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfCantRecibida.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfCantRecibida As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfCantTotalRecib.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfCantTotalRecib As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfHipAnterior.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfHipAnterior As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control pnlAvisoPedido.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlAvisoPedido As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control pnlPaso1.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlPaso1 As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control ddlProducto.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlProducto As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control pnlInfoProducto.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlInfoProducto As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control lblTipo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblTipo As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control lblMaterial.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblMaterial As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control pnlPaso2.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlPaso2 As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control ddlAlmacen.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlAlmacen As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control pnlPaso3.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlPaso3 As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control ddlNicho.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlNicho As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control pnlPaso4.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlPaso4 As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control hfHipId.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfHipId As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control pnlPrecioVigente.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlPrecioVigente As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control lblPrecioVigente.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblPrecioVigente As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control pnlAvisoPrecio.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlAvisoPrecio As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control pnlStockActual.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlStockActual As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control cardDisponible.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents cardDisponible As Global.System.Web.UI.HtmlControls.HtmlGenericControl

        '''<summary>
        '''Control lblDisponible.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblDisponible As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control lblMinimo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblMinimo As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control lblMaximo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblMaximo As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control pnlSumaInfo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlSumaInfo As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control lblSumaInfo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblSumaInfo As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control pnlEntradaMercancia.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlEntradaMercancia As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control lblCantEntradaLabel.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblCantEntradaLabel As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control txtCantidadEntrada.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtCantidadEntrada As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control btnEntrada.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnEntrada As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control txtDisponible.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtDisponible As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtMinimo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtMinimo As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtMaximo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtMaximo As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control btnGuardar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnGuardar As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control pnlEditarLimites.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlEditarLimites As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control btnEditarLimites.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnEditarLimites As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control pnlCancelarLimites.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlCancelarLimites As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control btnCancelarLimites.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnCancelarLimites As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control btnCancelar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnCancelar As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control pnlSinStock.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlSinStock As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control lblDisponibleNuevoLabel.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblDisponibleNuevoLabel As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control txtDisponibleNuevo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtDisponibleNuevo As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtMinimoNuevo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtMinimoNuevo As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control txtMaximoNuevo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtMaximoNuevo As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control btnCrearStock.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnCrearStock As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control btnCancelar2.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnCancelar2 As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control txtFiltroProducto.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtFiltroProducto As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control ddlFiltroAlmacen.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlFiltroAlmacen As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control ddlFiltroNicho.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlFiltroNicho As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control btnFiltrar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnFiltrar As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control btnLimpiar.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnLimpiar As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control lblContador.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblContador As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control gvStock.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents gvStock As Global.System.Web.UI.WebControls.GridView
    End Class
End Namespace
