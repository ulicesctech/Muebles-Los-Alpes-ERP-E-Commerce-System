<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Factura.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.Cliente.Factura"
    MasterPageFile="~/Site.Master"
    EnableViewStateMac="false" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    * { box-sizing: border-box; }
    .checkout-wrap { display: grid; grid-template-columns: 1fr 380px; gap: 24px; }
    @media(max-width:768px) { .checkout-wrap { grid-template-columns: 1fr; } }
    .checkout-card { background: white; border-radius: 12px; border: 1px solid #e8d8c0;
        box-shadow: 0 2px 8px rgba(92,58,30,0.06); overflow: hidden; margin-bottom: 20px; }
    .checkout-card-head { background: linear-gradient(135deg,#5C3A1E,#8B5E3C); padding: 14px 20px; }
    .checkout-card-head span { color: #f0d9a0; font-size: 14px; font-weight: bold; font-family: Arial,sans-serif; }
    .checkout-card-body { padding: 24px; }
    .f-row { display: flex; gap: 16px; flex-wrap: wrap; margin-bottom: 16px; }
    .f-group { display: flex; flex-direction: column; gap: 5px; flex: 1; min-width: 200px; }
    .f-group label { font-size: 11px; font-weight: bold; color: #5C3A1E;
        text-transform: uppercase; letter-spacing: 0.4px; font-family: Arial,sans-serif; }
    .f-group .form-control { padding: 10px 14px; border: 2px solid #e8d8c0;
        border-radius: 8px; font-size: 14px; background: #fdf8f3; outline: none;
        width: 100%; font-family: Arial,sans-serif; color: #333; }
    .f-group .form-control:focus { border-color: #C9973A; background: white; }
    .resumen-card { background: white; border-radius: 12px; border: 1px solid #e8d8c0;
        box-shadow: 0 2px 8px rgba(92,58,30,0.06); overflow: hidden; position: sticky; top: 20px; }
    .resumen-head { background: linear-gradient(135deg,#5C3A1E,#8B5E3C); padding: 14px 20px; }
    .resumen-head span { color: #f0d9a0; font-size: 14px; font-weight: bold; font-family: Arial,sans-serif; }
    .resumen-body { padding: 20px; }
    .resumen-item { display: flex; gap: 10px; align-items: center; padding: 10px 0; border-bottom: 1px solid #f5ece0; }
    .resumen-item:last-child { border-bottom: none; }
    .resumen-item img { width: 50px; height: 50px; object-fit: cover; border-radius: 6px; background: #fdf8f3; }
    .resumen-item-info { flex: 1; }
    .resumen-item-nombre { font-size: 13px; font-weight: bold; color: #3a2a1a; font-family: Arial,sans-serif; }
    .resumen-item-precio { font-size: 12px; color: #888; font-family: Arial,sans-serif; }
    .resumen-item-total { font-size: 14px; font-weight: bold; color: #5C3A1E; font-family: Georgia,serif; white-space: nowrap; }
    .resumen-totales { border-top: 2px solid #e8d8c0; margin-top: 12px; padding-top: 12px; }
    .resumen-row { display: flex; justify-content: space-between; padding: 6px 0; font-family: Arial,sans-serif; font-size: 14px; color: #555; }
    .resumen-row.total { font-size: 18px; font-weight: bold; color: #3a2a1a; border-top: 1px solid #e8d8c0; margin-top: 6px; padding-top: 12px; }
    .resumen-row.total span:last-child { font-family: Georgia,serif; color: #5C3A1E; }
    .btn-confirmar { width: 100%; background: linear-gradient(135deg,#276749,#1a4d35);
        color: white; border: none; padding: 16px; border-radius: 8px; font-size: 16px;
        font-weight: bold; cursor: pointer; font-family: Arial,sans-serif; margin-top: 16px; }
    .btn-confirmar:hover { background: linear-gradient(135deg,#1a4d35,#0f3020); }
    .btn-volver { display: block; text-align: center; margin-top: 10px; color: #C9973A;
        font-size: 13px; font-family: Arial,sans-serif; text-decoration: none; }
    .steps-bar { display: flex; align-items: center; margin-bottom: 28px; }
    .step { display: flex; align-items: center; gap: 8px; font-family: Arial,sans-serif; font-size: 13px; font-weight: bold; }
    .step-num { width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: bold; }
    .step.active .step-num { background: #C9973A; color: white; }
    .step.done .step-num { background: #276749; color: white; }
    .step.inactive .step-num { background: #e8d8c0; color: #888; }
    .step.active span { color: #5C3A1E; }
    .step.inactive span { color: #aaa; }
    .step-line { flex: 1; height: 2px; background: #e8d8c0; margin: 0 8px; }
    .alert-ok  { padding: 12px 18px; border-radius: 8px; font-size: 13px; margin-bottom: 20px;
        background: #f0fff4; color: #276749; border-left: 4px solid #48bb78; font-family: Arial,sans-serif; }
    .alert-err { padding: 12px 18px; border-radius: 8px; font-size: 13px; margin-bottom: 20px;
        background: #fff5f5; color: #c53030; border-left: 4px solid #fc8181; font-family: Arial,sans-serif; }
    .confirmacion-wrap { text-align: center; padding: 60px 20px; }
    .confirmacion-icon { font-size: 80px; margin-bottom: 16px; }
    .confirmacion-titulo { font-size: 28px; font-weight: bold; color: #276749; font-family: Georgia,serif; margin-bottom: 8px; }
    .confirmacion-sub { font-size: 15px; color: #555; font-family: Arial,sans-serif; margin-bottom: 24px; }
    .confirmacion-codigo { display: inline-block; background: #f0fff4; border: 2px solid #48bb78;
        border-radius: 8px; padding: 12px 24px; font-size: 18px; font-weight: bold;
        color: #276749; font-family: Georgia,serif; margin-bottom: 24px; }
    .btn-seguir-comprando { display: inline-block; padding: 12px 32px; background: #C9973A;
        color: white; border-radius: 8px; text-decoration: none; font-weight: bold;
        font-family: Arial,sans-serif; font-size: 14px; }
</style>

<div class="steps-bar">
    <div class="step done"><div class="step-num">✓</div><span>Carrito</span></div>
    <div class="step-line"></div>
    <div class="step active"><div class="step-num">2</div><span>Datos de envío</span></div>
    <div class="step-line"></div>
    <div class="step inactive"><div class="step-num">3</div><span>Confirmación</span></div>
</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<asp:Panel ID="pnlCheckout" runat="server">
<div class="checkout-wrap">

<%-- Izquierda: datos --%>
    <div>
        <div class="checkout-card">
            <div class="checkout-card-head"><span>👤 Datos de entrega</span></div>
            <div class="checkout-card-body">
                <div class="f-row">
                    <div class="f-group">
                        <label>Tipo de documento</label>
                        <asp:DropDownList ID="ddlTipoDoc" runat="server" CssClass="form-control">
                            <asp:ListItem Text="DPI" Value="DPI" />
                            <asp:ListItem Text="Cédula de vecindad" Value="CEDULA" />
                            <asp:ListItem Text="Pasaporte" Value="PASAPORTE" />
                            <asp:ListItem Text="NIT" Value="NIT" />
                        </asp:DropDownList>
                    </div>
                    <div class="f-group">
                        <label>Número de documento</label>
                        <asp:TextBox ID="txtNumDoc" runat="server" CssClass="form-control" placeholder="Tu número de documento" />
                    </div>
                </div>
                <div class="f-row">
                    <div class="f-group">
                        <label>Nombre completo</label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Tu nombre completo" />
                    </div>
                </div>
                <div class="f-row">
                    <div class="f-group">
                        <label>Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="tu@email.com" />
                    </div>
                    <div class="f-group">
                        <label>Teléfono</label>
                        <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="Ej. 5555-1234" />
                    </div>
                </div>
                <div class="f-row">
                    <div class="f-group">
                        <label>Dirección</label>
                        <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" placeholder="Calle, número, colonia" />
                    </div>
                </div>
                <div class="f-row">
                    <div class="f-group">
                        <label>Municipio</label>
                        <asp:TextBox ID="txtMunicipio" runat="server" CssClass="form-control" placeholder="Municipio" />
                    </div>
                    <div class="f-group">
                        <label>Departamento</label>
                        <asp:TextBox ID="txtDepartamento" runat="server" CssClass="form-control" placeholder="Departamento" />
                    </div>
                    <div class="f-group" style="max-width:120px;">
                        <label>Zona</label>
                        <asp:TextBox ID="txtZona" runat="server" CssClass="form-control" placeholder="Zona" />
                    </div>
                    <div class="f-group" style="max-width:120px;">
                        <label>Código Postal</label>
                        <asp:TextBox ID="txtCodigoPostal" runat="server" CssClass="form-control" placeholder="01001" />
                    </div>
                </div>
            </div>
        </div>

        <div class="checkout-card">
            <div class="checkout-card-head"><span>💳 Método de pago</span></div>
            <div class="checkout-card-body">
                <div class="f-row">
                    <div class="f-group">
                        <label>Forma de pago</label>
                        <asp:DropDownList ID="ddlFormaPago" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Efectivo al recibir" Value="EFECTIVO" />
                            <asp:ListItem Text="Tarjeta de crédito" Value="TARJETA" />
                            <asp:ListItem Text="Transferencia bancaria" Value="TRANSFERENCIA" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="f-row">
                    <div class="f-group">
                        <label>NIT (opcional)</label>
                        <asp:TextBox ID="txtNit" runat="server" CssClass="form-control" placeholder="CF o tu NIT" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Derecha: resumen --%>
    <div class="resumen-card">
        <div class="resumen-head"><span>📦 Resumen del pedido</span></div>
        <div class="resumen-body">
            <asp:Repeater ID="rptResumen" runat="server">
                <ItemTemplate>
                    <div class="resumen-item">
                        <img src='<%# ResolveUrl("~/Handlers/CatalogoInventario/FotoProductoHandler.ashx?ref=" & Eval("PRO_REFERENCIA").ToString()) %>'
                             onerror="this.style.display='none'" alt="" />
                        <div class="resumen-item-info">
                            <div class="resumen-item-nombre"><%# Eval("PRO_NOMBRE") %></div>
                            <div class="resumen-item-precio">Q <%# String.Format("{0:N2}", Eval("PRECIO_FINAL")) %> × <%# Eval("CANTIDAD") %></div>
                        </div>
                        <div class="resumen-item-total">
                            Q <%# String.Format("{0:N2}", Convert.ToDecimal(Eval("PRECIO_FINAL")) * Convert.ToInt32(Eval("CANTIDAD"))) %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <div class="resumen-totales">
                <div class="resumen-row">
                    <span>Subtotal</span>
                    <span>Q <asp:Label ID="lblSubtotal" runat="server" Text="0.00" /></span>
                </div>
                <div class="resumen-row">
                    <span>Envío</span>
                    <span style="color:#276749; font-weight:bold;">Gratis</span>
                </div>
                <div class="resumen-row total">
                    <span>Total</span>
                    <span>Q <asp:Label ID="lblTotal" runat="server" Text="0.00" /></span>
                </div>
            </div>
            <asp:Button ID="btnConfirmar" runat="server" Text="✓ Confirmar Pedido"
                CssClass="btn-confirmar" OnClick="btnConfirmar_Click" />
            <a href="/Modules/Cliente/Carrito.aspx" class="btn-volver">← Volver al carrito</a>
        </div>
    </div>

</div>
</asp:Panel>

<asp:Panel ID="pnlConfirmacion" runat="server" Visible="false">
    <div class="confirmacion-wrap">
        <div class="confirmacion-icon">🎉</div>
        <div class="confirmacion-titulo">¡Pedido confirmado!</div>
        <div class="confirmacion-sub">Gracias por tu compra. Tu pedido ha sido registrado exitosamente.</div>
        <div class="confirmacion-codigo">
            Código: <asp:Label ID="lblCodigoFactura" runat="server" />
        </div>
        <br />
        <asp:Panel ID="pnlCrearCuenta" runat="server" Visible="false">
            <div style="background:#fdf8f3; border:1px solid #e8d8c0; border-radius:10px;
                        padding:20px; margin:20px auto; max-width:400px; text-align:left;">
                <p style="font-size:14px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; margin-bottom:8px;">
                    ¿Quieres guardar tus datos para próximas compras?
                </p>
                <p style="font-size:13px; color:#888; font-family:Arial,sans-serif; margin-bottom:14px;">
                    Crea una cuenta gratis y da seguimiento a tus pedidos.
                </p>
                <a href="/Modules/Cliente/Registro.aspx"
                   style="display:inline-block; padding:10px 24px; background:#C9973A; color:white;
                          border-radius:8px; text-decoration:none; font-weight:bold; font-family:Arial,sans-serif; font-size:13px;">
                    Crear cuenta
                </a>
                &nbsp;
                <a href="/Modules/Cliente/Catalogo.aspx"
                   style="display:inline-block; padding:10px 24px; background:white; color:#888;
                          border:1px solid #ddd; border-radius:8px; text-decoration:none; font-family:Arial,sans-serif; font-size:13px;">
                    No, gracias
                </a>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlLogueadoOk" runat="server" Visible="false">
            <a href="/Modules/Cliente/Catalogo.aspx" class="btn-seguir-comprando">
                Seguir comprando
            </a>
        </asp:Panel>
    </div>
</asp:Panel>
    <%-- Modal de stock insuficiente --%>
<div id="modalStock" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
     background:rgba(0,0,0,0.5); z-index:99999; align-items:center; justify-content:center;">
    <div style="background:white; border-radius:16px; padding:36px; max-width:420px; width:90%;
                text-align:center; box-shadow:0 20px 60px rgba(0,0,0,0.3); animation:popIn 0.3s ease;">
        <div style="font-size:64px; margin-bottom:12px;">😔</div>
        <div style="font-size:20px; font-weight:bold; color:#3a2a1a; font-family:Georgia,serif;
                    margin-bottom:10px;">Stock insuficiente</div>
        <div id="modalStockMsg" style="font-size:14px; color:#666; font-family:Arial,sans-serif;
             margin-bottom:24px; line-height:1.6;"></div>
        <a href="/Modules/Cliente/Carrito.aspx"
           style="display:inline-block; padding:12px 28px; background:linear-gradient(135deg,#5C3A1E,#8B5E3C);
                  color:white; border-radius:8px; text-decoration:none; font-weight:bold;
                  font-family:Arial,sans-serif; font-size:14px; margin-right:8px;">
            ← Ir al carrito
        </a>
        <button onclick="document.getElementById('modalStock').style.display='none';"
                style="padding:12px 20px; background:#f5f5f5; color:#666; border:1px solid #ddd;
                       border-radius:8px; font-family:Arial,sans-serif; font-size:14px; cursor:pointer;">
            Cerrar
        </button>
    </div>
</div>
<style>
@keyframes popIn {
    from { transform: scale(0.8); opacity: 0; }
    to   { transform: scale(1); opacity: 1; }
}
</style>
</asp:Content>