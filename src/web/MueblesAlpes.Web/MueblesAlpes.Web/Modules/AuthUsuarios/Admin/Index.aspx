<%@ Page Title="Compras & Proveedor" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Index.aspx.vb" Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.Index" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; box-shadow:0 1px 4px rgba(92,58,30,0.06); }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }

    .mod-header { background:linear-gradient(135deg,#1a1a1a,#0a2a0a); border-radius:12px; padding:28px 32px; margin-bottom:28px; border-left:5px solid #2d7a2d; display:flex; align-items:center; justify-content:space-between; box-shadow:0 4px 16px rgba(0,0,0,0.15); }
    .mod-header h2 { color:#4aaa4a; font-family:Georgia,serif; margin:0 0 6px; font-size:24px; }
    .mod-header p { color:rgba(200,240,200,0.7); margin:0; font-size:13px; font-family:Arial,sans-serif; }
    .mod-header .mod-icon { font-size:55px; opacity:0.15; }

    .section-label { font-size:12px; font-weight:bold; color:#5C3A1E; margin:24px 0 14px; padding:8px 14px; background:linear-gradient(135deg,#fdf6ec,#f5e8d0); border-radius:8px; border-left:4px solid #C9973A; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }

    .crud-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:10px; }
    .crud-grid.two-col { grid-template-columns:repeat(2,1fr); max-width:600px; }
    .crud-grid.three-col { grid-template-columns:repeat(3,1fr); }

    .crud-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; transition:all 0.2s; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .crud-card:hover { box-shadow:0 8px 24px rgba(45,122,45,0.15); transform:translateY(-4px); border-color:#2d7a2d; }
    .crud-card-body { padding:22px 18px 14px; text-align:center; }
    .crud-card .crud-icon { font-size:40px; margin-bottom:10px; }
    .crud-card h4 { color:#1a1a1a; font-size:14px; margin:0 0 6px; font-family:Georgia,serif; }
    .crud-card p { color:#999; font-size:12px; margin:0; font-family:Arial,sans-serif; line-height:1.5; }
    .crud-card-footer { padding:12px 18px; border-top:1px solid #f5ece0; display:flex; align-items:center; justify-content:space-between; }
    .crud-card-footer a { font-size:13px; font-weight:bold; font-family:Arial,sans-serif; text-decoration:none; display:flex; align-items:center; gap:6px; transition:gap 0.2s; }
    .crud-card-footer a:hover { gap:10px; text-decoration:none; }

    .back-link { display:inline-flex; align-items:center; gap:6px; color:#C9973A; font-size:13px; font-family:Arial,sans-serif; text-decoration:none; margin-top:20px; padding:8px 14px; border-radius:6px; border:1px solid #e8d8c0; background:white; transition:all 0.2s; }
    .back-link:hover { border-color:#C9973A; background:#fdf6ec; text-decoration:none; color:#C9973A; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>Inicio</a> /
    <strong style="color:#2d7a2d;">Compras &amp; Proveedor</strong>
</div>

<div class="mod-header">
    <div>
        <h2>Compras &amp; Proveedor</h2>
        <p>Gestion de ordenes de compra, pedidos, proveedores y facturacion.</p>
    </div>
    <div class="mod-icon">&#128722;</div>
</div>

<div class="section-label">Proveedores</div>
<div class="crud-grid two-col">
    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">&#127970;</div>
            <h4>Proveedores</h4>
            <p>Registro y gestion de proveedores de la empresa.</p>
        </div>
        <div class="crud-card-footer" style="background:#f0fff4;">
            <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Proveedores.aspx") %>' style="color:#2d7a2d;">Gestionar <span>&#8594;</span></a>
        </div>
    </div>
    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">&#128203;</div>
            <h4>Reclamos</h4>
            <p>Gestion de reclamos a proveedores.</p>
        </div>
        <div class="crud-card-footer" style="background:#fff5f5;">
            <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/ReclamosProveedor.aspx") %>' style="color:#c53030;">Gestionar <span>&#8594;</span></a>
        </div>
    </div>
</div>

<div class="section-label">Ordenes y Pedidos</div>
<div class="crud-grid two-col">
    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">&#128230;</div>
            <h4>Ordenes de Compra</h4>
            <p>Registro y seguimiento de ordenes de compra.</p>
        </div>
        <div class="crud-card-footer" style="background:#f0fff4;">
            <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/OrdenesCompra.aspx") %>' style="color:#2d7a2d;">Gestionar <span>&#8594;</span></a>
        </div>
    </div>
    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">&#128667;</div>
            <h4>Pedidos</h4>
            <p>Control y seguimiento de pedidos activos.</p>
        </div>
        <div class="crud-card-footer" style="background:#f0fff4;">
            <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Pedidos.aspx") %>' style="color:#2d7a2d;">Gestionar <span>&#8594;</span></a>
        </div>
    </div>
</div>

<div class="section-label">Facturacion</div>
<div class="crud-grid two-col">
    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">&#128196;</div>
            <h4>Facturas de Proveedor</h4>
            <p>Gestion de facturas recibidas de proveedores.</p>
        </div>
        <div class="crud-card-footer" style="background:#f0fff4;">
            <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/FacturasProveedor.aspx") %>' style="color:#2d7a2d;">Gestionar <span>&#8594;</span></a>
        </div>
    </div>
</div>

<a class="back-link" href='<%: ResolveUrl("~/") %>'>&#8592; Volver al Panel Principal</a>
</asp:Content>