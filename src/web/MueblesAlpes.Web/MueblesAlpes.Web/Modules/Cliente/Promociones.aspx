<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Promociones.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.Cliente.Promociones"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    * { box-sizing: border-box; }
    .cat-breadcrumb { font-size: 13px; font-family: Arial,sans-serif; color: #888; margin-bottom: 16px; }
    .cat-breadcrumb a { color: #C9973A; text-decoration: none; }
    .promo-hero { background: linear-gradient(135deg,#8B1A1A,#C53030);
        padding: 28px 30px; border-radius: 14px; margin-bottom: 24px;
        display: flex; align-items: center; gap: 16px; }
    .promo-hero-icon { font-size: 48px; }
    .promo-hero-title { color: white; font-size: 26px; font-family: Georgia,serif; margin: 0; }
    .promo-hero-sub { color: rgba(255,255,255,0.8); font-size: 13px; font-family: Arial,sans-serif; margin: 4px 0 0; }
    .toolbar { display: flex; justify-content: space-between; align-items: center;
        margin-bottom: 16px; flex-wrap: wrap; gap: 8px; }
    .resultado-info { font-size: 13px; color: #888; font-family: Arial,sans-serif; }
    .resultado-info strong { color: #5C3A1E; }
    .cards-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px; }
    .prod-card { background: white; border-radius: 12px; border: 1px solid #e8d8c0;
        overflow: hidden; box-shadow: 0 2px 8px rgba(92,58,30,0.06);
        transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; }
    .prod-card:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(92,58,30,0.12); }
    .card-img-wrap { position: relative; height: 180px; overflow: hidden; background: #fdf8f3; }
    .card-img-wrap img { width: 100%; height: 100%; object-fit: cover; display: block; }
    .card-img-placeholder { width: 100%; height: 100%; display: flex; align-items: center;
        justify-content: center; font-size: 50px; color: #e8d8c0; }
    .badge-promo { position: absolute; top: 8px; left: 8px;
        background: #e53e3e; color: white; padding: 3px 8px; border-radius: 20px;
        font-size: 10px; font-weight: bold; font-family: Arial,sans-serif; }
    .badge-disponible { position: absolute; top: 8px; right: 8px;
        background: rgba(39,103,73,0.85); color: white; padding: 3px 8px;
        border-radius: 20px; font-size: 10px; font-weight: bold; font-family: Arial,sans-serif; }
    .badge-agotado { position: absolute; top: 8px; right: 8px;
        background: rgba(0,0,0,0.55); color: white; padding: 3px 8px;
        border-radius: 20px; font-size: 10px; font-weight: bold; font-family: Arial,sans-serif; }
    .card-body { padding: 12px; flex: 1; display: flex; flex-direction: column; gap: 4px; }
    .card-categoria { font-size: 10px; font-weight: bold; text-transform: uppercase;
        letter-spacing: 0.8px; color: #C9973A; font-family: Arial,sans-serif; }
    .card-nombre { font-size: 14px; font-weight: bold; color: #3a2a1a;
        font-family: Georgia,serif; line-height: 1.3; }
    .card-tipo { font-size: 11px; color: #888; font-family: Arial,sans-serif; }
    .card-precio-wrap { margin-top: auto; padding-top: 8px; }
    .card-precio-original { font-size: 12px; color: #aaa; text-decoration: line-through; font-family: Arial,sans-serif; }
    .card-precio-final { font-size: 18px; font-weight: bold; color: #e53e3e; font-family: Georgia,serif; }
    .card-footer { padding: 10px 12px; border-top: 1px solid #f5ece0; display: flex; gap: 8px; }
    .btn-detalle { flex: 1; background: #fdf6ec; color: #C9973A;
        border: 1px solid #e8d8c0; padding: 8px; border-radius: 6px;
        font-size: 11px; font-weight: bold; cursor: pointer; text-align: center;
        font-family: Arial,sans-serif; text-decoration: none; display: block; }
    .btn-detalle:hover { background: #C9973A; color: white; }
    .btn-carrito { flex: 2; background: linear-gradient(135deg,#5C3A1E,#8B5E3C); color: white;
        border: none; padding: 8px; border-radius: 6px; font-size: 11px; font-weight: bold;
        cursor: pointer; font-family: Arial,sans-serif; }
    .btn-carrito:hover { background: linear-gradient(135deg,#3a2010,#5C3A1E); }
    .btn-carrito:disabled { background: #ccc; cursor: not-allowed; }
    .empty-cat { text-align: center; padding: 60px 20px; color: #aaa; font-family: Arial,sans-serif; }
    .empty-cat .ei { font-size: 64px; margin-bottom: 12px; }
    .alert-ok { position: fixed; top: 0; left: 0; right: 0; z-index: 99999;
        padding: 14px 24px; font-size: 14px; background: #f0fff4; color: #276749;
        border-bottom: 3px solid #48bb78; font-family: Arial,sans-serif;
        text-align: center; animation: slideDown 0.3s ease; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
    .alert-err { position: fixed; top: 0; left: 0; right: 0; z-index: 99999;
        padding: 14px 24px; font-size: 14px; background: #fff5f5; color: #c53030;
        border-bottom: 3px solid #fc8181; font-family: Arial,sans-serif;
        text-align: center; animation: slideDown 0.3s ease; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
    @keyframes slideDown {
        from { transform: translateY(-100%); opacity: 0; }
        to   { transform: translateY(0); opacity: 1; }
    }
</style>

<div class="cat-breadcrumb">
    <a href="/Modules/Cliente/Catalogo.aspx"> Inicio</a> /
    <strong style="color:#5C3A1E;">Promociones</strong>
</div>

<div class="promo-hero">
    <div>
        <div class="promo-hero-title">Ofertas y Promociones</div>
        <div class="promo-hero-sub">Productos con descuento activos hoy</div>
    </div>
</div>

<asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Conditional">
<ContentTemplate>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false">
        <asp:Label ID="lblMsg" runat="server" />
    </asp:Panel>

    <div class="toolbar">
        <div class="resultado-info">
            <strong><asp:Label ID="lblConteo" runat="server" Text="0" /></strong> promocion(es) activas
        </div>
    </div>

    <div class="cards-grid">
        <asp:Repeater ID="rptProductos" runat="server" OnItemCommand="rptProductos_ItemCommand">
            <ItemTemplate>
                <div class="prod-card">
                    <div class="card-img-wrap">
                        <img src='<%# ResolveUrl("~/Handlers/CatalogoInventario/FotoProductoHandler.ashx?ref=" & Eval("PRO_REFERENCIA").ToString()) %>'
                             alt='<%# Eval("PRO_NOMBRE") %>'
                             onerror="this.style.display='none';this.nextElementSibling.style.display='flex';" />
                        <div class="card-img-placeholder" style="display:none;"></div>
                        <span class="badge-promo">-<%# Eval("PROM_PORCENTAJE") %>%</span>
                        <%# If(Convert.ToInt32(Eval("STO_DISPONIBLE")) > 0,
                            "<span class='badge-disponible'>✓ Disponible</span>",
                            "<span class='badge-agotado'>✗ Agotado</span>") %>
                    </div>
                    <div class="card-body">
                        <div class="card-categoria"><%# Eval("CAT_DESCRIPCION") %></div>
                        <div class="card-nombre"><%# Eval("PRO_NOMBRE") %></div>
                        <div class="card-tipo"><%# Eval("TIP_DESCRIPCION") %> · <%# Eval("MAT_DESCRIPCION") %></div>
                        <div class="card-precio-wrap">
                            <div class="card-precio-original">Q <%# String.Format("{0:N2}", Eval("PRO_PRECIO")) %></div>
                            <div class="card-precio-final">Q <%# String.Format("{0:N2}", Eval("PRECIO_FINAL")) %></div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <asp:LinkButton CommandName="VerDetalle"
                            CommandArgument='<%# Eval("PRO_REFERENCIA") %>'
                            runat="server" CssClass="btn-detalle">  Ver</asp:LinkButton>
                        <asp:LinkButton CommandName="AgregarCarrito"
                            CommandArgument='<%# Eval("HIP_HISTORIAL_PRECIO") %>'
                            runat="server" CssClass="btn-carrito"
                            Enabled='<%# Convert.ToInt32(Eval("STO_DISPONIBLE")) > 0 %>'>
                            🛒 Agregar
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div class="empty-cat">
            <div class="ei"></div>
            <p>No hay promociones activas en este momento.</p>
            <a href="/Modules/Cliente/Catalogo.aspx"
               style="display:inline-block; margin-top:16px; padding:12px 28px;
                      background:#C9973A; color:white; border-radius:8px;
                      text-decoration:none; font-weight:bold; font-family:Arial,sans-serif;">
                Ver Catálogo
            </a>
        </div>
    </asp:Panel>

</ContentTemplate>
</asp:UpdatePanel>

<script>
    function ocultarMensaje() {
        var pnl = document.getElementById('<%= pnlMsg.ClientID %>');
        if (pnl) {
            pnl.style.animation = 'slideDown 0.3s ease reverse';
            setTimeout(function() { pnl.style.display = 'none'; }, 300);
        }
    }
    window.addEventListener('load', function () {
        var pnl = document.getElementById('<%= pnlMsg.ClientID %>');
        if (pnl && pnl.style.display !== 'none') {
            setTimeout(ocultarMensaje, 4000);
        }
    });
    if (typeof Sys !== 'undefined') {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            var pnl = document.getElementById('<%= pnlMsg.ClientID %>');
            if (pnl && pnl.style.display !== 'none') {
                setTimeout(ocultarMensaje, 4000);
            }
        });
    }
</script>
</asp:Content>