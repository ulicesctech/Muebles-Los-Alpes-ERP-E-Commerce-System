<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="DetalleProducto.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.Cliente.DetalleProducto"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    * { box-sizing: border-box; }
    .det-wrap { display: grid; grid-template-columns: 1fr 1fr; gap: 32px; }
    @media(max-width:768px) { .det-wrap { grid-template-columns: 1fr; } }
    .det-img-card { background: white; border-radius: 14px; border: 1px solid #e8d8c0;
        overflow: hidden; box-shadow: 0 2px 10px rgba(92,58,30,0.07); }
    .det-img { width: 100%; height: 400px; object-fit: cover; display: block; }
    .det-img-placeholder { width: 100%; height: 400px; display: flex; align-items: center;
        justify-content: center; font-size: 100px; color: #e8d8c0; background: #fdf8f3; }
    .det-info-card { background: white; border-radius: 14px; border: 1px solid #e8d8c0;
        padding: 28px; box-shadow: 0 2px 10px rgba(92,58,30,0.07); }
    .det-categoria { font-size: 11px; font-weight: bold; text-transform: uppercase;
        letter-spacing: 1px; color: #C9973A; font-family: Arial,sans-serif; margin-bottom: 8px; }
    .det-nombre { font-size: 28px; font-weight: bold; color: #3a2a1a;
        font-family: Georgia,serif; line-height: 1.2; margin-bottom: 8px; }
    .det-tipo { font-size: 14px; color: #888; font-family: Arial,sans-serif; margin-bottom: 20px; }
    .det-precio-wrap { margin-bottom: 20px; }
    .det-precio-original { font-size: 16px; color: #aaa; text-decoration: line-through;
        font-family: Arial,sans-serif; }
    .det-precio-final { font-size: 36px; font-weight: bold; color: #5C3A1E;
        font-family: Georgia,serif; }
    .det-precio-final.promo { color: #e53e3e; }
    .det-badge-promo { display: inline-block; background: #e53e3e; color: white;
        padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: bold;
        font-family: Arial,sans-serif; margin-left: 8px; vertical-align: middle; }
    .det-stock { display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px;
        border-radius: 20px; font-size: 13px; font-weight: bold; font-family: Arial,sans-serif;
        margin-bottom: 20px; }
    .det-stock.disponible { background: #e6f4ea; color: #276749; border: 1px solid #b7dfc2; }
    .det-stock.agotado { background: #f5f5f5; color: #888; border: 1px solid #ddd; }
    .det-specs { background: #fdf8f3; border-radius: 10px; padding: 16px 20px;
        margin-bottom: 20px; }
    .det-specs h4 { font-size: 11px; font-weight: bold; text-transform: uppercase;
        letter-spacing: 1px; color: #C9973A; font-family: Arial,sans-serif; margin-bottom: 12px; }
    .det-spec-row { display: flex; justify-content: space-between; padding: 6px 0;
        border-bottom: 1px solid #f0e8d8; font-family: Arial,sans-serif; font-size: 13px; }
    .det-spec-row:last-child { border-bottom: none; }
    .det-spec-row span:first-child { color: #888; }
    .det-spec-row span:last-child { color: #3a2a1a; font-weight: bold; }
    .qty-wrap { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; }
    .qty-label { font-size: 13px; font-weight: bold; color: #5C3A1E;
        text-transform: uppercase; letter-spacing: 0.5px; font-family: Arial,sans-serif; }
    .qty-btn { width: 36px; height: 36px; border: 2px solid #e8d8c0; border-radius: 8px;
        background: white; color: #5C3A1E; font-size: 20px; font-weight: bold;
        cursor: pointer; display: flex; align-items: center; justify-content: center; }
    .qty-btn:hover { border-color: #C9973A; color: #C9973A; }
    .qty-val { font-size: 18px; font-weight: bold; color: #3a2a1a; min-width: 32px;
        text-align: center; font-family: Arial,sans-serif; }
    .btn-agregar { width: 100%; background: linear-gradient(135deg,#5C3A1E,#8B5E3C);
        color: white; border: none; padding: 16px; border-radius: 10px; font-size: 16px;
        font-weight: bold; cursor: pointer; font-family: Arial,sans-serif; margin-bottom: 10px; }
    .btn-agregar:hover { background: linear-gradient(135deg,#3a2010,#5C3A1E); }
    .btn-agregar:disabled { background: #ccc; cursor: not-allowed; }
    .breadcrumb-mod { background: white; border: 1px solid #e8d8c0; border-radius: 8px;
        padding: 10px 16px; margin-bottom: 20px; font-size: 13px; font-family: Arial,sans-serif; color: #888; }
    .breadcrumb-mod a { color: #C9973A; text-decoration: none; }
    .alert-ok  { padding: 12px 18px; border-radius: 8px; font-size: 13px; margin-bottom: 20px;
        background: #f0fff4; color: #276749; border-left: 4px solid #48bb78; font-family: Arial,sans-serif; }
    .alert-err { padding: 12px 18px; border-radius: 8px; font-size: 13px; margin-bottom: 20px;
        background: #fff5f5; color: #c53030; border-left: 4px solid #fc8181; font-family: Arial,sans-serif; }
</style>

<div class="breadcrumb-mod">
    <a href='/Modules/Cliente/Catalogo.aspx'>&#127968; Catálogo</a> /
    <strong style="color:#5C3A1E;"><asp:Label ID="lblBreadcrumb" runat="server" /></strong>
</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<asp:Panel ID="pnlProducto" runat="server" Visible="false">
<div class="det-wrap">

    <%-- Imagen --%>
    <div class="det-img-card">
        <asp:Image ID="imgProducto" runat="server" CssClass="det-img"
            onerror="this.style.display='none';this.nextElementSibling.style.display='flex';" />
        <div class="det-img-placeholder" id="divPlaceholder" style="display:none;">🛋️</div>
    </div>

    <%-- Info --%>
    <div class="det-info-card">
        <div class="det-categoria">
            <asp:Label ID="lblCategoria" runat="server" />
        </div>
        <div class="det-nombre">
            <asp:Label ID="lblNombre" runat="server" />
        </div>
        <div class="det-tipo">
            <asp:Label ID="lblTipo" runat="server" />
        </div>

        <%-- Precio --%>
        <div class="det-precio-wrap">
            <asp:Label ID="lblPrecioOriginal" runat="server" CssClass="det-precio-original" Visible="false" />
            <asp:Label ID="lblPrecioFinal" runat="server" CssClass="det-precio-final" />
            <asp:Label ID="lblBadgePromo" runat="server" CssClass="det-badge-promo" Visible="false" />
        </div>

        <%-- Stock --%>
        <asp:Label ID="lblStock" runat="server" />

        <%-- Specs --%>
        <div class="det-specs">
            <h4>Especificaciones</h4>
            <div class="det-spec-row">
                <span>Material</span>
                <span><asp:Label ID="lblMaterial" runat="server" /></span>
            </div>
            <div class="det-spec-row">
                <span>Color</span>
                <span><asp:Label ID="lblColor" runat="server" /></span>
            </div>
            <div class="det-spec-row">
                <span>Alto</span>
                <span><asp:Label ID="lblAlto" runat="server" /> cm</span>
            </div>
            <div class="det-spec-row">
                <span>Ancho</span>
                <span><asp:Label ID="lblAncho" runat="server" /> cm</span>
            </div>
            <div class="det-spec-row">
                <span>Profundidad</span>
                <span><asp:Label ID="lblProfundidad" runat="server" /> cm</span>
            </div>
            <div class="det-spec-row">
                <span>Peso</span>
                <span><asp:Label ID="lblPeso" runat="server" /> g</span>
            </div>
        </div>

        <%-- Cantidad --%>
        <div class="qty-wrap">
            <span class="qty-label">Cantidad:</span>
            <button type="button" class="qty-btn" onclick="cambiarCantidad(-1)">−</button>
            <span class="qty-val" id="spnCantidad">1</span>
            <button type="button" class="qty-btn" onclick="cambiarCantidad(1)">+</button>
            <asp:HiddenField ID="hfCantidad" runat="server" Value="1" />
            <asp:HiddenField ID="hfHipId" runat="server" />
        </div>

        <asp:Button ID="btnAgregar" runat="server" Text="🛒 Agregar al Carrito"
            CssClass="btn-agregar" OnClick="btnAgregar_Click" />
    </div>

</div>
</asp:Panel>

<asp:Panel ID="pnlNoEncontrado" runat="server" Visible="false">
    <div style="text-align:center; padding:60px; color:#aaa; font-family:Arial,sans-serif;">
        <div style="font-size:64px;">🔍</div>
        <p>Producto no encontrado.</p>
        <a href="/Modules/Cliente/Catalogo.aspx"
           style="display:inline-block; margin-top:16px; padding:12px 28px;
                  background:#C9973A; color:white; border-radius:8px;
                  text-decoration:none; font-weight:bold; font-family:Arial,sans-serif;">
            Ver Catálogo
        </a>
    </div>
</asp:Panel>

<script>
    function cambiarCantidad(delta) {
        var spn = document.getElementById('spnCantidad');
        var hf = document.getElementById('<%= hfCantidad.ClientID %>');
        var val = parseInt(spn.innerText) + delta;
        if (val < 1) val = 1;
        if (val > 99) val = 99;
        spn.innerText = val;
        hf.value = val;
    }
</script>
</asp:Content>