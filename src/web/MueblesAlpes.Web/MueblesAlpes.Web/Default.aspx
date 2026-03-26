<%@ Page Title="Dashboard" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="MueblesAlpes.Web._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    /* WELCOME BANNER */
    .welcome-banner {
        background: linear-gradient(135deg, #1a0e05 0%, #2d1a08 50%, #3a2210 100%);
        border-radius: 16px;
        padding: 36px 40px;
        margin-bottom: 28px;
        border-left: 6px solid #C9973A;
        display: flex;
        align-items: center;
        justify-content: space-between;
        box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        position: relative;
        overflow: hidden;
    }
    .welcome-banner::after {
        content: '';
        position: absolute;
        bottom: -40px;
        right: 120px;
        width: 200px;
        height: 200px;
        background: radial-gradient(circle, rgba(201,151,58,0.08) 0%, transparent 70%);
        border-radius: 50%;
    }
    .welcome-banner h2 {
        color: #C9973A;
        font-size: 28px;
        margin: 0 0 6px;
        font-family: Georgia, serif;
        letter-spacing: 0.5px;
    }
    .welcome-banner p {
        color: rgba(240,217,160,0.65);
        margin: 0;
        font-size: 14px;
        font-family: Arial, sans-serif;
    }
    .welcome-banner .date-tag {
        display: inline-block;
        background: rgba(201,151,58,0.12);
        color: #C9973A;
        padding: 5px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-family: Arial, sans-serif;
        margin-top: 10px;
        border: 1px solid rgba(201,151,58,0.25);
        letter-spacing: 0.3px;
    }
    .welcome-banner .big-icon {
        font-size: 90px;
        opacity: 0.08;
        position: relative;
        z-index: 1;
    }

    /* STATS */
    .stats-row {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 16px;
        margin-bottom: 28px;
    }
    .stat-box {
        background: white;
        border-radius: 14px;
        padding: 22px 20px;
        border: 1px solid #e0d0b8;
        display: flex;
        align-items: center;
        gap: 16px;
        box-shadow: 0 2px 12px rgba(92,58,30,0.07);
        transition: all 0.25s;
        position: relative;
        overflow: hidden;
    }
    .stat-box::before {
        content: '';
        position: absolute;
        top: 0; left: 0;
        width: 4px;
        height: 100%;
        background: #C9973A;
        border-radius: 4px 0 0 4px;
    }
    .stat-box:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 24px rgba(201,151,58,0.15);
        border-color: #C9973A;
    }
    .stat-box .s-icon {
        width: 52px; height: 52px;
        border-radius: 12px;
        background: #fdf6ec;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        flex-shrink: 0;
    }
    .stat-box .s-data h3 {
        font-size: 28px;
        font-weight: 900;
        color: #1a0e05;
        margin: 0;
        line-height: 1;
        font-family: Arial, sans-serif;
    }
    .stat-box .s-data p {
        font-size: 12px;
        color: #999;
        margin: 5px 0 0;
        font-family: Arial, sans-serif;
    }

    /* SECTION LABEL */
    .sec-label {
        font-size: 12px;
        font-weight: bold;
        color: #5C3A1E;
        margin: 0 0 16px;
        padding: 10px 16px;
        background: linear-gradient(135deg, #fdf6ec, #f5e8d0);
        border-radius: 8px;
        border-left: 4px solid #C9973A;
        font-family: Arial, sans-serif;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    /* MODULE CARDS */
    .mod-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 18px;
        margin-bottom: 10px;
    }
    .mod-card {
        background: white;
        border-radius: 14px;
        border: 1px solid #e0d0b8;
        overflow: hidden;
        transition: all 0.25s;
        text-decoration: none;
        display: block;
        color: inherit;
        box-shadow: 0 2px 12px rgba(92,58,30,0.07);
    }
    .mod-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 16px 40px rgba(92,58,30,0.15);
        text-decoration: none;
        color: inherit;
        border-color: #C9973A;
    }
    .mod-card .mc-body {
        padding: 24px 20px 16px;
    }
    .mod-card .mc-ico {
        width: 52px; height: 52px;
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 26px;
        margin-bottom: 14px;
    }
    .mod-card h4 {
        margin: 0 0 6px;
        font-size: 15px;
        font-family: Georgia, serif;
        color: #1a0e05;
        font-weight: bold;
    }
    .mod-card p {
        margin: 0;
        font-size: 12px;
        color: #aaa;
        font-family: Arial, sans-serif;
        line-height: 1.6;
    }
    .mod-card .mc-foot {
        padding: 12px 20px;
        border-top: 1px solid #f5ece0;
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-size: 13px;
        font-weight: bold;
        font-family: Arial, sans-serif;
    }

    @media (max-width: 900px) {
        .stats-row, .mod-grid { grid-template-columns: repeat(2, 1fr); }
    }
</style>

<%-- WELCOME --%>
<div class="welcome-banner">
    <div>
        <h2>Panel Administrativo</h2>
        <p>Muebles Los Alpes — Santos &amp; Familia, Desde 1978</p>
        
    </div>
    <div class="big-icon">&#128241;</div>
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
<div class="sec-label">Modulos del Sistema</div>
<div class="mod-grid">

    <a class="mod-card" href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>
        <div class="mc-body">
            <div class="mc-ico" style="background:#fdf6ec;">&#128230;</div>
            <h4>Catalogo &amp; Inventario</h4>
            <p>Productos, categorias, materiales, almacenes y nichos.</p>
        </div>
        <div class="mc-foot" style="color:#C9973A;">
            <span>Gestionar</span><span>&#8594;</span>
        </div>
    </a>

    <a class="mod-card" href='<%: ResolveUrl("~/Modules/AuthUsuarios/") %>'>
        <div class="mc-body">
            <div class="mc-ico" style="background:#f0f4ff;">&#128100;</div>
            <h4>Auth &amp; Usuarios</h4>
            <p>Usuarios, roles y permisos del sistema.</p>
        </div>
        <div class="mc-foot" style="color:#5C3A1E;">
            <span>Gestionar</span><span>&#8594;</span>
        </div>
    </a>

    <a class="mod-card" href='<%: ResolveUrl("~/Modules/ComprasProveedor/") %>'>
        <div class="mc-body">
            <div class="mc-ico" style="background:#f0fff4;">&#128722;</div>
            <h4>Compras &amp; Proveedor</h4>
            <p>Ordenes de compra y gestion de proveedores.</p>
        </div>
        <div class="mc-foot" style="color:#2d7a2d;">
            <span>Gestionar</span><span>&#8594;</span>
        </div>
    </a>

    <a class="mod-card" href='<%: ResolveUrl("~/Modules/VentasFacturacion/") %>'>
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
