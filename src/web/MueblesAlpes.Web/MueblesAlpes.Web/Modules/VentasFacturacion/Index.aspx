<%@ Page Title="Ventas & Facturacion" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Index.aspx.vb" Inherits="MueblesAlpes.Web.Modules.VentasFacturacion.Index" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; box-shadow:0 1px 4px rgba(92,58,30,0.06); }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }

    .mod-header { background:linear-gradient(135deg,#1a1a1a,#2a0a0a); border-radius:12px; padding:28px 32px; margin-bottom:28px; border-left:5px solid #c53030; display:flex; align-items:center; justify-content:space-between; box-shadow:0 4px 16px rgba(0,0,0,0.15); }
    .mod-header h2 { color:#e05050; font-family:Georgia,serif; margin:0 0 6px; font-size:24px; }
    .mod-header p { color:rgba(240,200,200,0.7); margin:0; font-size:13px; font-family:Arial,sans-serif; }
    .mod-header .mod-icon { font-size:55px; opacity:0.15; }

    .section-label { font-size:12px; font-weight:bold; color:#5C3A1E; margin:24px 0 14px; padding:8px 14px; background:linear-gradient(135deg,#fdf6ec,#f5e8d0); border-radius:8px; border-left:4px solid #C9973A; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }

    .crud-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:10px; }
    .crud-grid.two-col { grid-template-columns:repeat(2,1fr); max-width:600px; }
    .crud-grid.three-col { grid-template-columns:repeat(3,1fr); }

    .crud-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; transition:all 0.2s; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .crud-card:hover { box-shadow:0 8px 24px rgba(197,48,48,0.12); transform:translateY(-4px); border-color:#c53030; }
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
    <strong style="color:#c53030;">Ventas &amp; Facturacion</strong>
</div>

<div class="mod-header">
    <div>
        <h2>Ventas &amp; Facturacion</h2>
        <p>Gestion de ventas, carrito de compras y facturacion de clientes.</p>
    </div>
    <div class="mod-icon">&#128203;</div>
</div>

<div class="section-label">Proceso de Venta</div>
<div class="crud-grid three-col">
    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">&#128722;</div>
            <h4>Carrito</h4>
            <p>Gestion del carrito de compras de clientes.</p>
        </div>
        <div class="crud-card-footer" style="background:#fff5f5;">
            <a href='<%: ResolveUrl("~/Modules/VentasFacturacion/Carrito.aspx") %>' style="color:#c53030;">Gestionar <span>&#8594;</span></a>
        </div>
    </div>
    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">&#128230;</div>
            <h4>Detalle Carrito</h4>
            <p>Detalle de productos en el carrito activo.</p>
        </div>
        <div class="crud-card-footer" style="background:#fff5f5;">
            <a href='<%: ResolveUrl("~/Modules/VentasFacturacion/DetalleCarrito.aspx") %>' style="color:#c53030;">Gestionar <span>&#8594;</span></a>
        </div>
    </div>
    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">&#128196;</div>
            <h4>Factura</h4>
            <p>Generacion y gestion de facturas de venta.</p>
        </div>
        <div class="crud-card-footer" style="background:#fff5f5;">
            <a href='<%: ResolveUrl("~/Modules/VentasFacturacion/Factura.aspx") %>' style="color:#c53030;">Gestionar <span>&#8594;</span></a>
        </div>
    </div>
</div>

<a class="back-link" href='<%: ResolveUrl("~/") %>'>&#8592; Volver al Panel Principal</a>
</asp:Content>