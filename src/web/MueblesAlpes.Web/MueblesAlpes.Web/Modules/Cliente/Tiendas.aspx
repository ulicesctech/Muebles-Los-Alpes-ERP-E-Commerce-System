<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Tiendas.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.Cliente.Tiendas"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    * { box-sizing: border-box; }
    .hero { background: linear-gradient(135deg,#5C3A1E,#8B5E3C);
        padding: 28px 30px; border-radius: 14px; margin-bottom: 24px; }
    .hero-title { color: #f0d9a0; font-size: 24px; font-family: Georgia,serif; margin: 0; }
    .hero-sub { color: #d4b896; font-size: 13px; font-family: Arial,sans-serif; margin: 4px 0 0; }
    .tiendas-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
    .tienda-card { background: white; border-radius: 12px; border: 1px solid #e8d8c0;
        box-shadow: 0 2px 8px rgba(92,58,30,0.06); overflow: hidden;
        transition: transform 0.2s, box-shadow 0.2s; }
    .tienda-card:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(92,58,30,0.12); }
    .tienda-card-head { background: linear-gradient(135deg,#5C3A1E,#8B5E3C);
        padding: 20px; text-align: center; }
    .tienda-icon { font-size: 48px; margin-bottom: 8px; }
    .tienda-nombre { color: #f0d9a0; font-size: 18px; font-family: Georgia,serif;
        font-weight: bold; margin: 0; }
    .tienda-card-body { padding: 20px; }
    .tienda-info-row { display: flex; align-items: flex-start; gap: 10px;
        padding: 10px 0; border-bottom: 1px solid #f5ece0;
        font-family: Arial,sans-serif; font-size: 13px; color: #555; }
    .tienda-info-row:last-child { border-bottom: none; }
    .tienda-info-icon { font-size: 16px; flex-shrink: 0; margin-top: 1px; }
    .tienda-info-label { font-size: 10px; font-weight: bold; text-transform: uppercase;
        letter-spacing: 0.5px; color: #C9973A; font-family: Arial,sans-serif; }
    .tienda-info-val { font-size: 13px; color: #3a2a1a; font-family: Arial,sans-serif; }
    .empty-tiendas { text-align: center; padding: 60px 20px; color: #aaa;
        font-family: Arial,sans-serif; }
</style>

<div class="hero">
    <div class="hero-title"> Nuestras Tiendas</div>
    <div class="hero-sub">Encuéntranos en Guatemala</div>
</div>

<div class="tiendas-grid">
    <asp:Repeater ID="rptTiendas" runat="server">
        <ItemTemplate>
            <div class="tienda-card">
                <div class="tienda-card-head">
                    <div class="tienda-icon">🏬</div>
                    <div class="tienda-nombre"><%# Eval("ALM_NOMBRE") %></div>
                </div>
                <div class="tienda-card-body">
                    <div class="tienda-info-row">
                        <span class="tienda-info-icon"></span>
                        <div>
                            <div class="tienda-info-label">País</div>
                            <div class="tienda-info-val"><%# Eval("ALM_PAIS") %></div>
                        </div>
                    </div>
                    <div class="tienda-info-row">
                        <span class="tienda-info-icon">📍</span>
                        <div>
                            <div class="tienda-info-label">Ubicación</div>
                            <div class="tienda-info-val"><%# Eval("ALM_UBICACION") %></div>
                        </div>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</div>

</asp:Content>