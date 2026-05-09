<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Carrito.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.Cliente.Carrito"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    * { box-sizing: border-box; }
    .cart-layout { display: grid; grid-template-columns: 1fr 320px; gap: 20px; align-items: start; }
    @media(max-width:768px) { .cart-layout { grid-template-columns: 1fr; } }

    .cart-main { background: white; border-radius: 12px; border: 1px solid #e8d8c0;
        box-shadow: 0 2px 8px rgba(92,58,30,0.06); overflow: hidden; }
    .cart-main-head { background: linear-gradient(135deg,#5C3A1E,#8B5E3C);
        padding: 16px 24px; display: flex; justify-content: space-between; align-items: center; }
    .cart-main-head span { color: #f0d9a0; font-size: 16px; font-weight: bold; font-family: Georgia,serif; }
    .cart-main-head small { color: #d4b896; font-size: 12px; font-family: Arial,sans-serif; }

    .cart-item { display: flex; gap: 20px; padding: 20px 24px;
        border-bottom: 1px solid #f5ece0; align-items: flex-start; }
    .cart-item:last-child { border-bottom: none; }

    .cart-item-img-wrap { flex-shrink: 0; width: 120px; height: 120px;
        border-radius: 8px; overflow: hidden; border: 1px solid #e8d8c0;
        background: #fdf8f3; display: flex; align-items: center; justify-content: center; }
    .cart-item-img-wrap img { width: 100%; height: 100%; object-fit: cover; display: block; }
    .cart-item-img-placeholder { font-size: 40px; color: #e8d8c0; }

    .cart-item-center { flex: 1; }
    .cart-item-nombre { font-size: 16px; font-weight: bold; color: #3a2a1a;
        font-family: Georgia,serif; margin-bottom: 4px; line-height: 1.3; }
    .cart-item-disponible { font-size: 12px; color: #276749; font-family: Arial,sans-serif;
        font-weight: bold; margin-bottom: 6px; }
    .cart-item-specs { font-size: 12px; color: #888; font-family: Arial,sans-serif;
        margin-bottom: 12px; line-height: 1.6; }

    .cart-item-actions { display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
    .qty-wrap { display: flex; align-items: center; border: 1px solid #d5d9d9;
        border-radius: 8px; overflow: hidden; }
    .qty-btn { width: 32px; height: 32px; background: #f0f2f2; border: none;
        color: #333; font-size: 18px; font-weight: bold; cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        font-family: Arial,sans-serif; transition: background 0.15s; }
    .qty-btn:hover { background: #e8d8c0; color: #5C3A1E; }
    .qty-val { min-width: 36px; text-align: center; font-size: 14px; font-weight: bold;
        color: #3a2a1a; font-family: Arial,sans-serif; padding: 0 4px; }
    .btn-del-item { background: none; border: none; color: #C9973A; font-size: 12px;
        font-family: Arial,sans-serif; cursor: pointer; padding: 0;
        text-decoration: underline; font-weight: bold; }
    .btn-del-item:hover { color: #e53e3e; }
    .btn-sep { color: #d5d9d9; font-size: 12px; }

    .cart-item-price { flex-shrink: 0; text-align: right; min-width: 130px; }
    .price-badge-wrap { display: flex; align-items: center; gap: 5px;
        justify-content: flex-end; margin-bottom: 4px; }
    .price-badge-pct { background: #e53e3e; color: white; font-size: 10px;
        font-weight: bold; padding: 2px 7px; border-radius: 4px; font-family: Arial,sans-serif; }
    .price-badge-promo { background: #fff3cd; color: #856404; font-size: 10px;
        font-weight: bold; padding: 2px 7px; border-radius: 4px; font-family: Arial,sans-serif; }
    .price-final { font-size: 20px; font-weight: bold; font-family: Georgia,serif;
        color: #5C3A1E; }
    .price-final.promo { color: #B12704; }
    .price-recomendado-label { font-size: 11px; color: #888; font-family: Arial,sans-serif;
        margin-top: 2px; }
    .price-original { font-size: 13px; color: #aaa; text-decoration: line-through;
        font-family: Arial,sans-serif; }

    /* RESUMEN */
    .resumen-card { background: white; border-radius: 12px; border: 1px solid #e8d8c0;
        box-shadow: 0 2px 8px rgba(92,58,30,0.06); overflow: hidden; position: sticky; top: 20px; }
    .resumen-head { background: linear-gradient(135deg,#5C3A1E,#8B5E3C); padding: 14px 20px; }
    .resumen-head span { color: #f0d9a0; font-size: 15px; font-weight: bold; font-family: Georgia,serif; }
    .resumen-body { padding: 20px; }
    .resumen-subtotal { font-size: 14px; font-family: Arial,sans-serif; color: #333;
        margin-bottom: 8px; }
    .resumen-subtotal strong { font-family: Georgia,serif; color: #5C3A1E; font-size: 16px; }
    .resumen-row { display: flex; justify-content: space-between; align-items: center;
        padding: 6px 0; font-family: Arial,sans-serif; font-size: 13px; color: #555; }
    .resumen-row.descuento { color: #e53e3e; }
    .resumen-divider { border: none; border-top: 1px solid #e8d8c0; margin: 10px 0; }
    .resumen-total { display: flex; justify-content: space-between; align-items: center;
        padding: 10px 0; font-family: Arial,sans-serif; font-size: 18px;
        font-weight: bold; color: #3a2a1a; }
    .resumen-total span:last-child { font-family: Georgia,serif; color: #5C3A1E; }

    .btn-pagar { width: 100%; background: linear-gradient(135deg,#276749,#1a4d35);
        color: white; border: none; padding: 14px; border-radius: 8px; font-size: 15px;
        font-weight: bold; cursor: pointer; font-family: Arial,sans-serif; margin-top: 14px;
        display: block; text-align: center; }
    .btn-pagar:hover { background: linear-gradient(135deg,#1a4d35,#0f3020); }
    .btn-seguir { width: 100%; background: #fdf6ec; color: #C9973A; border: 2px solid #e8d8c0;
        padding: 11px; border-radius: 8px; font-size: 13px; font-weight: bold;
        cursor: pointer; font-family: Arial,sans-serif; margin-top: 8px; text-align: center;
        display: block; text-decoration: none; }
    .btn-seguir:hover { background: #C9973A; color: white; border-color: #C9973A; }

    .empty-cart { text-align: center; padding: 60px 20px; color: #aaa;
        font-family: Arial,sans-serif; background: white; border-radius: 12px;
        border: 1px solid #e8d8c0; }
    .empty-cart .ei { font-size: 64px; margin-bottom: 12px; }
    .alert-ok { padding: 12px 18px; border-radius: 8px; font-size: 13px; margin-bottom: 20px;
        background: #f0fff4; color: #276749; border-left: 4px solid #48bb78; font-family: Arial,sans-serif; }
    .alert-err { padding: 12px 18px; border-radius: 8px; font-size: 13px; margin-bottom: 20px;
        background: #fff5f5; color: #c53030; border-left: 4px solid #fc8181; font-family: Arial,sans-serif; }

    .cart-page-title { font-size: 24px; font-family: Georgia,serif; color: #3a2a1a;
        margin-bottom: 16px; font-weight: bold; }
</style>

<div class="cart-page-title">Mi Carrito</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<%-- Carrito vacío --%>
<asp:Panel ID="pnlVacio" runat="server" Visible="false">
    <div class="empty-cart">
        <div class="ei">🛒</div>
        <p style="font-size:16px; margin-bottom:8px;">Tu carrito está vacío.</p>
        <p style="font-size:13px; color:#aaa; margin-bottom:20px;">
            Agrega productos desde el catálogo para comenzar.
        </p>
        <a href='<%: ResolveUrl("~/Modules/Cliente/Catalogo.aspx") %>'
           style="display:inline-block; padding:12px 28px; background:#C9973A; color:white;
                  border-radius:8px; text-decoration:none; font-weight:bold; font-family:Arial,sans-serif;">
            Ver Catálogo
        </a>
    </div>
</asp:Panel>

<%-- Carrito con productos --%>
<asp:Panel ID="pnlCarrito" runat="server" Visible="false">
<div class="cart-layout">

    <%-- Izquierda: productos --%>
    <div class="cart-main">
            <div class="cart-main-head">
                <span>Productos en tu carrito</span>
                <small><asp:Label ID="lblCantItemsHead" runat="server" Text="0" /> artículo(s)</small>
            </div>
        <asp:Repeater ID="rptCarrito" runat="server" OnItemCommand="rptCarrito_ItemCommand">
            <ItemTemplate>
                <div class="cart-item">
                    <%-- Imagen --%>
                    <div class="cart-item-img-wrap">
                        <img src='<%# ResolveUrl("~/Handlers/CatalogoInventario/FotoProductoHandler.ashx?ref=" & Eval("PRO_REFERENCIA").ToString()) %>'
                             alt='<%# Eval("PRO_NOMBRE") %>'
                             onerror="this.style.display='none';this.nextElementSibling.style.display='flex';" />
                        <div class="cart-item-img-placeholder" style="display:none;">🛋️</div>
                    </div>

                    <%-- Centro --%>
                    <div class="cart-item-center">
                        <div class="cart-item-nombre"><%# Eval("PRO_NOMBRE") %></div>
                        <div class="cart-item-disponible">✓ En stock</div>
                        <div class="cart-item-specs">
                            Cant: <%# Eval("CANTIDAD") %>
                        </div>
                        <div class="cart-item-actions">
                            <div class="qty-wrap">
                                <asp:LinkButton CommandName="Restar" CommandArgument='<%# Eval("HIP_ID") %>'
                                    runat="server" CssClass="qty-btn tiempoInhabilitado">−</asp:LinkButton>
                                <span class="qty-val"><%# Eval("CANTIDAD") %></span>
                                <asp:LinkButton CommandName="Sumar" CommandArgument='<%# Eval("HIP_ID") %>'
                                    runat="server" CssClass="qty-btn tiempoInhabilitado">+</asp:LinkButton>
                            </div>
                            <span class="btn-sep">|</span>
                            <asp:LinkButton CommandName="Quitar" CommandArgument='<%# Eval("HIP_ID") %>'
                                runat="server" CssClass="btn-del-item tiempoInhabilitado">Eliminar</asp:LinkButton>
                        </div>
                    </div>

                    <%-- Precio --%>
                    <div class="cart-item-price">
                       <%# If(Convert.ToDecimal(Eval("PRO_PRECIO")) > Convert.ToDecimal(Eval("PRECIO_FINAL")),
                                        "<div class='price-badge-wrap'>" &
                                        "<span class='price-badge-pct'>-" & Math.Round((1 - Convert.ToDecimal(Eval("PRECIO_FINAL")) / Convert.ToDecimal(Eval("PRO_PRECIO"))) * 100).ToString() & "%</span>" &
                                        "<span class='price-badge-promo'> " & Eval("CAMP_NOMBRE") & "</span>" &
                                        "</div>" &
                                        "<div class='price-final promo'>Q " & String.Format("{0:N2}", Eval("PRECIO_FINAL")) & "</div>" &
                                        "<div class='price-recomendado-label'>Precio recomendado:</div>" &
                                        "<div class='price-original'>Q " & String.Format("{0:N2}", Eval("PRO_PRECIO")) & "</div>",
                                        "<div class='price-final'>Q " & String.Format("{0:N2}", Eval("PRECIO_FINAL")) & "</div>") %>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <%-- Derecha: resumen --%>
    <div class="resumen-card">
        <div class="resumen-head">
            <span>Resumen del pedido</span>
        </div>
        <div class="resumen-body">
            <asp:Repeater ID="rptResumenPrecios" runat="server">
                <ItemTemplate>
                    <%# If(Convert.ToDecimal(Eval("PRO_PRECIO")) > Convert.ToDecimal(Eval("PRECIO_FINAL")),
                                                "<div style='margin-bottom:10px; padding-bottom:10px; border-bottom:1px solid #f5ece0;'>" &
                                                "<div style='display:flex; gap:5px; margin-bottom:4px; flex-wrap:wrap;'>" &
                                                "<span style='background:#e53e3e; color:white; font-size:10px; font-weight:bold; padding:2px 7px; border-radius:4px; font-family:Arial,sans-serif;'>-" &
                                                Math.Round((1 - Convert.ToDecimal(Eval("PRECIO_FINAL")) / Convert.ToDecimal(Eval("PRO_PRECIO"))) * 100).ToString() & "%</span>" &
                                                "<span style='background:#fff3cd; color:#856404; font-size:10px; font-weight:bold; padding:2px 7px; border-radius:4px; font-family:Arial,sans-serif;'>🛍️ " & Eval("CAMP_NOMBRE") & "</span>" &
                                                "</div>" &
                                                "<div style='font-size:20px; font-weight:bold; color:#B12704; font-family:Georgia,serif;'>Q " & String.Format("{0:N2}", Eval("PRECIO_FINAL")) & "</div>" &
                                                "<div style='font-size:11px; color:#888; font-family:Arial,sans-serif;'>Precio recomendado:</div>" &
                                                "<div style='font-size:12px; color:#aaa; text-decoration:line-through; font-family:Arial,sans-serif;'>Q " & String.Format("{0:N2}", Eval("PRO_PRECIO")) & "</div>" &
                                                "</div>",
                                                "<div style='font-size:20px; font-weight:bold; color:#5C3A1E; font-family:Georgia,serif; margin-bottom:10px; padding-bottom:10px; border-bottom:1px solid #f5ece0;'>Q " & String.Format("{0:N2}", Eval("PRECIO_FINAL")) & "</div>") %>
                </ItemTemplate>
            </asp:Repeater>

            <div class="resumen-row">
                <span>Envío</span>
                <span style="color:#276749; font-weight:bold;">Gratis</span>
            </div>
            <hr class="resumen-divider" />
            <div class="resumen-total">
                <span>Total (<asp:Label ID="lblCantItemsResumen" runat="server" Text="0" /> producto(s))</span>
                <span>Q <asp:Label ID="lblTotal" runat="server" Text="0.00" /></span>
            </div>
            <asp:Button ID="btnPagar" runat="server" Text="✓ Proceder al Pago"
                CssClass="btn-pagar tiempoInhabilitado" OnClick="btnPagar_Click" />
            <a href='<%: ResolveUrl("~/Modules/Cliente/Catalogo.aspx") %>'
               class="btn-seguir">← Seguir comprando</a>
        </div>
    </div>

</div>
</asp:Panel>

</asp:Content>