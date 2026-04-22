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
        '''Control hfHipAnterior.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfHipAnterior As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfHipDestino.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfHipDestino As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfMinDestino.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfMinDestino As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfMaxDestino.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfMaxDestino As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfDispDestino.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfDispDestino As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfHipOrigen.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfHipOrigen As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfMinOrigen.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfMinOrigen As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfMaxOrigen.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfMaxOrigen As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfDispOrigen.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfDispOrigen As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control hfProductoTraslado.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents hfProductoTraslado As Global.System.Web.UI.WebControls.HiddenField

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
        '''Control gvStock.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents gvStock As Global.System.Web.UI.WebControls.GridView

        '''<summary>
        '''Control pnlTraslado.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlTraslado As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control HiddenField1.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents HiddenField1 As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control HiddenField2.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents HiddenField2 As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control HiddenField3.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents HiddenField3 As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control HiddenField4.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents HiddenField4 As Global.System.Web.UI.WebControls.HiddenField

        '''<summary>
        '''Control lblOrigenInfo.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblOrigenInfo As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control txtCantidadTraslado.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents txtCantidadTraslado As Global.System.Web.UI.WebControls.TextBox

        '''<summary>
        '''Control ddlAlmacenDestino.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlAlmacenDestino As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control ddlNichoDestino.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents ddlNichoDestino As Global.System.Web.UI.WebControls.DropDownList

        '''<summary>
        '''Control pnlResumenDestino.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlResumenDestino As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control lblResumenDispDestino.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblResumenDispDestino As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control lblResumenMinDestino.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblResumenMinDestino As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control lblResumenMaxDestino.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents lblResumenMaxDestino As Global.System.Web.UI.WebControls.Label

        '''<summary>
        '''Control pnlDestinoSinStock.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents pnlDestinoSinStock As Global.System.Web.UI.WebControls.Panel

        '''<summary>
        '''Control btnConfirmarTraslado.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnConfirmarTraslado As Global.System.Web.UI.WebControls.Button

        '''<summary>
        '''Control btnCancelarTraslado.
        '''</summary>
        '''<remarks>
        '''Campo generado automáticamente.
        '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
        '''</remarks>
        Protected WithEvents btnCancelarTraslado As Global.System.Web.UI.WebControls.Button
    End Class
End Namespace
