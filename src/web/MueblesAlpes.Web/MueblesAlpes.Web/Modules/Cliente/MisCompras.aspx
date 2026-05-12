<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="MisCompras.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.Cliente.MisCompras"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    * { box-sizing: border-box; }
    .hero { background: linear-gradient(135deg,#5C3A1E,#8B5E3C);
        padding: 28px 30px; border-radius: 14px; margin-bottom: 24px; }
    .hero-title { color: #f0d9a0; font-size: 24px; font-family: Georgia,serif; margin: 0; }
    .hero-sub { color: #d4b896; font-size: 13px; font-family: Arial,sans-serif; margin: 4px 0 0; }
    .compra-card { background: white; border-radius: 12px; border: 1px solid #e8d8c0;
        box-shadow: 0 2px 8px rgba(92,58,30,0.06); overflow: hidden; margin-bottom: 16px; }
    .compra-head { background: #fdf8f3; padding: 14px 20px;
        display: flex; justify-content: space-between; align-items: center;
        flex-wrap: wrap; gap: 8px; border-bottom: 1px solid #e8d8c0; }
    .compra-codigo { font-size: 14px; font-weight: bold; color: #5C3A1E;
        font-family: Georgia,serif; }
    .compra-fecha { font-size: 12px; color: #888; font-family: Arial,sans-serif; }
    .compra-total { font-size: 16px; font-weight: bold; color: #276749;
        font-family: Georgia,serif; }
    .compra-body { padding: 16px 20px; }
    .compra-item { display: flex; gap: 12px; align-items: center;
        padding: 8px 0; border-bottom: 1px solid #f5ece0; }
    .compra-item:last-child { border-bottom: none; }
    .compra-item img { width: 50px; height: 50px; object-fit: cover;
        border-radius: 6px; background: #fdf8f3; flex-shrink: 0; }
    .compra-item-info { flex: 1; }
    .compra-item-nombre { font-size: 13px; font-weight: bold; color: #3a2a1a;
        font-family: Arial,sans-serif; }
    .compra-item-precio { font-size: 12px; color: #888; font-family: Arial,sans-serif; }
    .compra-item-subtotal { font-size: 14px; font-weight: bold; color: #5C3A1E;
        font-family: Georgia,serif; white-space: nowrap; }
    .empty-wrap { text-align: center; padding: 60px 20px;
        color: #aaa; font-family: Arial,sans-serif; }
    .empty-icon { font-size: 64px; margin-bottom: 12px; }
    .btn-catalogo { display: inline-block; margin-top: 16px; padding: 12px 28px;
        background: #C9973A; color: white; border-radius: 8px;
        text-decoration: none; font-weight: bold; font-family: Arial,sans-serif; }
    .no-login { text-align: center; padding: 60px 20px;
        font-family: Arial,sans-serif; color: #555; }
    .no-login .icon { font-size: 64px; margin-bottom: 12px; }
    .btn-login { display: inline-block; margin-top: 16px; padding: 12px 28px;
        background: linear-gradient(135deg,#5C3A1E,#8B5E3C); color: white;
        border-radius: 8px; text-decoration: none; font-weight: bold;
        font-family: Arial,sans-serif; font-size: 14px; }
</style>

<div class="hero">
    <div class="hero-title">Mis Compras</div>
    <div class="hero-sub">Historial de todos tus pedidos</div>
</div>

<%-- Sin login --%>
<asp:Panel ID="pnlNoLogin" runat="server" Visible="false">
    <div class="no-login">
        <div class="icon"></div>
        <p>Debes iniciar sesión para ver tus compras.</p>
        <a href="/Modules/Cliente/Login.aspx?returnUrl=/Modules/Cliente/MisCompras.aspx"
           class="btn-login">Iniciar sesión</a>
    </div>
</asp:Panel>

<%-- Sin compras --%>
<asp:Panel ID="pnlVacio" runat="server" Visible="false">
    <div class="empty-wrap">
        <div class="empty-icon"></div>
        <p>Aún no has realizado ninguna compra.</p>
        <a href="/Modules/Cliente/Catalogo.aspx" class="btn-catalogo">
            Ver Catálogo
        </a>
    </div>
</asp:Panel>

<%-- Lista de compras --%>
<asp:Panel ID="pnlCompras" runat="server" Visible="false">
    <asp:Repeater ID="rptCompras" runat="server">
<ItemTemplate>
    <div class="compra-card">
        <div class="compra-head">
            <div>
                <div class="compra-codigo"> <%#: Eval("FACLI_CODIGO_FACTURA") %></div>
                <div class="compra-fecha"><%# String.Format("{0:dd/MM/yyyy HH:mm}", Eval("FACLI_FECHA")) %></div>
            </div>
            <div style="text-align:right;">
                <div class="compra-total">Q <%# String.Format("{0:N2}", Eval("TOTAL_REAL")) %></div>
                <div style="font-size:11px; color:#888; font-family:Arial,sans-serif; margin-top:2px;">
                    <%# If(Eval("FACLI_TIPO_ENTREGA").ToString() = "SUCURSAL",
                        " Recoger en: " & Eval("NOMBRE_ALMACEN").ToString(),
                        " Envío a domicilio") %>
                </div>
                <div style="font-size:11px; color:#888; font-family:Arial,sans-serif;">
                    💳 <%#: Eval("FACLI_FORMA_PAGO") %>
                </div>
            </div>
        </div>
        <div class="compra-body">
            <div style="font-size:12px; color:#555; font-family:Arial,sans-serif; line-height:1.8;">
                <%#: Eval("PRODUCTOS") %>
            </div>
        </div>
    </div>
</ItemTemplate>
    </asp:Repeater>
</asp:Panel>

</asp:Content>