<%@ Page Title="Panel Administrativo" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="MueblesAlpes.Web._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .welcome-banner {
        background: linear-gradient(135deg, #1a0e05 0%, #2d1a08 50%, #3a2210 100%);
        border-radius: 14px;
        padding: 32px 36px;
        margin-bottom: 28px;
        border-left: 5px solid #C9973A;
        display: flex;
        align-items: center;
        justify-content: space-between;
        box-shadow: 0 6px 24px rgba(0,0,0,0.18);
    }
    .welcome-banner h2 {
        color: #C9973A;
        font-size: 26px;
        margin: 0 0 6px;
        font-family: Georgia, serif;
    }
    .welcome-banner p {
        color: rgba(240,217,160,0.65);
        margin: 0 0 10px;
        font-size: 13px;
        font-family: Arial, sans-serif;
    }
    .welcome-banner .date-tag {
        display: inline-block;
        background: rgba(201,151,58,0.12);
        color: #C9973A;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 11px;
        font-family: Arial, sans-serif;
        border: 1px solid rgba(201,151,58,0.25);
    }
    .welcome-banner .big-num {
        font-size: 80px;
        opacity: 0.06;
        font-family: Georgia, serif;
        color: #C9973A;
    }

    .stats-row {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 16px;
        margin-bottom: 28px;
    }
    .stat-box {
        background: white;
        border-radius: 12px;
        padding: 20px 18px;
        border: 1px solid #e0d0b8;
        display: flex;
        align-items: center;
        gap: 14px;
        box-shadow: 0 2px 8px rgba(92,58,30,0.06);
        transition: all 0.2s;
        border-left: 4px solid #C9973A;
    }
    .stat-box:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(201,151,58,0.12);
    }
    .stat-box .s-icon {
        width: 48px; height: 48px;
        border-radius: 10px;
        background: #fdf6ec;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
        flex-shrink: 0;
    }
    .stat-box .s-data h3 {
        font-size: 26px;
        font-weight: 900;
        color: #1a0e05;
        margin: 0;
        font-family: Arial, sans-serif;
    }
    .stat-box .s-data p {
        font-size: 11px;
        color: #aaa;
        margin: 4px 0 0;
        font-family: Arial, sans-serif;
    }

    .section-label {
        font-size: 12px;
        font-weight: bold;
        color: #5C3A1E;
        margin: 0 0 16px;
        padding: 9px 14px;
        background: linear-gradient(135deg, #fdf6ec, #f5e8d0);
        border-radius: 8px;
        border-left: 4px solid #C9973A;
        font-family: Arial, sans-serif;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .mod-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 18px;
    }
    .mod-card {
        background: white;
        border-radius: 12px;
        border: 1px solid #e0d0b8;
        overflow: hidden;
        transition: all 0.25s;
        text-decoration: none;
        display: block;
        color: inherit;
        box-shadow: 0 2px 8px rgba(92,58,30,0.06);
    }
    .mod-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 32px rgba(92,58,30,0.14);
        text-decoration: none;
        color: inherit;
        border-color: #C9973A;
    }
    .mod-card .mc-head {
        height: 6px;
    }
    .mod-card .mc-body { padding: 22px 20px 14px; }
    .mod-card .mc-ico {
        width: 48px; height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        margin-bottom: 12px;
    }
    .mod-card h4 {
        margin: 0 0 5px;
        font-size: 15px;
        font-family: Georgia, serif;
        color: #1a0e05;
    }
    .mod-card p {
        margin: 0;
        font-size: 12px;
        color: #aaa;
        font-family: Arial, sans-serif;
        line-height: 1.6;
    }
    .mod-card .mc-foot {
        padding: 11px 20px;
        border-top: 1px solid #f5ece0;
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-size: 13px;
        font-weight: bold;
        font-family: Arial, sans-serif;
    }
</style>

<%-- WELCOME --%>
<div class="welcome-banner">
    <div>
        <h2>Panel Administrativo</h2>
        <p>Muebles Los Alpes — Santos &amp; Familia, Desde 1978</p>
        <span class="date-tag"><%: DateTime.Now.ToString("dddd, dd 'de' MMMM 'de' yyyy", New System.Globalization.CultureInfo("es-GT")) %></span>
    </div>
    <div class="big-num">ERP</div>
</div>

<%-- STATS --%>
<div class="stats-row">
    <div class="stat-box">
        <div class="s-icon">&#128230;</div>
        <div class="s-data"><h3>4</h3><p>Modulos activos</p></div>
    </div>
    <div class="stat-box">
        <div class="s-icon">&#128715;</div>
        <div class="s-data"><h3>—</h3><p>Productos en catalogo</p></div>
    </div>
    <div class="stat-box">
        <div class="s-icon">&#127981;</div>
        <div class="s-data"><h3>—</h3><p>Almacenes registrados</p></div>
    </div>
    <div class="stat-box">
        <div class="s-icon">&#128101;</div>
        <div class="s-data"><h3>4</h3><p>Desarrolladores</p></div>
    </div>
</div>

<%-- MODULOS --%>
<div class="section-label">Modulos del Sistema</div>
<div class="mod-grid">

    <a class="mod-card" href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>
        <div class="mc-head" style="background:#C9973A;"></div>
        <div class="mc-body">
            <div class="mc-ico" style="background:#fdf6ec;">&#128230;</div>
            <h4>Catalogo &amp; Inventario</h4>
            <p>Productos, categorias, materiales, almacenes y nichos.</p>
        </div>
        <div class="mc-foot" style="color:#C9973A;">
            <span>Gestionar</span><span>&#8594;</span>
        </div>
    </a>

    <a class="mod-card" href='<%: ResolveUrl("~/Modules/AuthUsuarios/Index.aspx") %>'>
        <div class="mc-head" style="background:#5C3A1E;"></div>
        <div class="mc-body">
            <div class="mc-ico" style="background:#f5f0f0;">&#128100;</div>
            <h4>Auth &amp; Usuarios</h4>
            <p>Usuarios, roles y permisos del sistema.</p>
        </div>
        <div class="mc-foot" style="color:#5C3A1E;">
            <span>Gestionar</span><span>&#8594;</span>
        </div>
    </a>

    <a class="mod-card" href='<%: ResolveUrl("~/Modules/ComprasProveedor/Index.aspx") %>'>
        <div class="mc-head" style="background:#2d7a2d;"></div>
        <div class="mc-body">
            <div class="mc-ico" style="background:#f0fff4;">&#128722;</div>
            <h4>Compras &amp; Proveedor</h4>
            <p>Ordenes de compra y gestion de proveedores.</p>
        </div>
        <div class="mc-foot" style="color:#2d7a2d;">
            <span>Gestionar</span><span>&#8594;</span>
        </div>
    </a>

    <a class="mod-card" href='<%: ResolveUrl("~/Modules/VentasFacturacion/Index.aspx") %>'>
        <div class="mc-head" style="background:#c53030;"></div>
        <div class="mc-body">
            <div class="mc-ico" style="background:#fff5f5;">&#128203;</div>
            <h4>Ventas &amp; Facturacion</h4>
            <p>Ventas, facturas y reportes gerenciales.</p>
        </div>
        <div class="mc-foot" style="color:#c53030;">
            <span>Gestionar</span><span>&#8594;</span>
        </div>
    </a>

</div>
</asp:Content>