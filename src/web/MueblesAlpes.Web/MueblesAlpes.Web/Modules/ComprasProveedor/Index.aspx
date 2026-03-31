<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Index.aspx.vb" Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.Index" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    /* Estilos de Navegación */
    .breadcrumb-mod { background: white; border: 1px solid #e8d8c0; border-radius: 8px; padding: 10px 16px; margin-bottom: 20px; font-size: 13px; color: #888; font-family: Arial, sans-serif; }
    .breadcrumb-mod a { color: #C9973A; text-decoration: none; }
    .breadcrumb-mod a:hover { text-decoration: underline; }
    
    /* Encabezado del Módulo */
    .mod-header {
        background: linear-gradient(135deg, #1a1a1a, #2a1a0a);
        border-radius: 12px; padding: 28px 32px; margin-bottom: 28px;
        border-left: 5px solid #C9973A; display: flex; align-items: center; justify-content: space-between;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .mod-header h2 { color: #fff; margin: 0; font-weight: 600; letter-spacing: 0.5px; font-family: Georgia, serif; }
    .mod-header p { color: #a89a8e; margin: 6px 0 0 0; font-size: 15px; font-family: Arial, sans-serif; }

    /* Etiquetas de Sección */
    .section-label { font-size: 12px; font-weight: 700; text-transform: uppercase; color: #b08d57; margin-bottom: 16px; letter-spacing: 1px; font-family: Arial, sans-serif; }
    
    /* Grid de Tarjetas */
    .crud-grid { display: grid; gap: 20px; margin-bottom: 35px; }
    .one-col { grid-template-columns: 1fr; }
    .two-col { grid-template-columns: repeat(2, 1fr); }
    .three-col { grid-template-columns: repeat(3, 1fr); }

    /* Estilo de Tarjetas (Cards) */
    .crud-card { background: white; border: 1px solid #efeae4; border-radius: 12px; display: flex; flex-direction: column; transition: all 0.3s ease; text-decoration: none !important; }
    .crud-card:hover { transform: translateY(-4px); box-shadow: 0 12px 24px rgba(92,58,30,0.12); border-color: #C9973A; }
    
    .crud-card-body { padding: 24px; flex-grow: 1; }
    .crud-icon { font-size: 32px; margin-bottom: 16px; }
    .crud-card h4 { margin: 0 0 8px 0; color: #2a1a0a; font-weight: 600; font-family: Georgia, serif; }
    .crud-card p { margin: 0; color: #7a6e65; font-size: 13px; line-height: 1.5; font-family: Arial, sans-serif; }
    
    .crud-card-footer { padding: 16px 24px; border-top: 1px solid #f9f7f5; border-radius: 0 0 12px 12px; }
    .crud-card-footer a { font-size: 13px; font-weight: 600; text-decoration: none; display: flex; align-items: center; justify-content: space-between; font-family: Arial, sans-serif; }
    .arrow { transition: transform 0.2s; }
    .crud-card:hover .arrow { transform: translateX(5px); }

    /* Responsive */
    @media (max-width: 992px) {
        .three-col, .two-col { grid-template-columns: 1fr; }
    }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/Default.aspx") %>'>🏠 Inicio</a> / 💳 Cuentas proveedores
</div>

<div class="mod-header">
    <div>
        <h2>Módulo de Compras</h2>
        <p>Gestión de abastecimiento, proveedores y control de facturación externa.</p>
    </div>
    <div style="font-size: 48px; opacity: 0.8;">🛒</div>
</div>

<div class="section-label">🤝 Relaciones Comerciales</div>
<div class="crud-grid one-col">
    <div class="crud-card" style="max-width: 400px;">
        <div class="crud-card-body">
            <div class="crud-icon">🏢</div>
            <h4>Proveedores</h4>
            <p>Registro de empresas, NIT, contactos y direcciones de proveedores locales e internacionales.</p>
        </div>
        <div class="crud-card-footer" style="background:#fdfcfb;">
            <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Proveedores.aspx") %>' style="color:#C9973A;">
                Gestionar Proveedores <span class="arrow">→</span>
            </a>
        </div>
    </div>
</div>

<div class="section-label">📝 Documentación y Órdenes</div>
<div class="crud-grid three-col">
    
    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">📦</div>
            <h4>Pedidos de Bodega</h4>
            <p>Gestión de solicitudes de mercadería, códigos internos y control de totales por pedido.</p>
        </div>
        <div class="crud-card-footer" style="background:#fdfcfb;">
            <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Pedidos.aspx") %>' style="color:#C9973A;">
                Gestionar Pedidos <span class="arrow">→</span>
            </a>
        </div>
    </div>

    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">📋</div>
            <h4>Órdenes de Compra</h4>
            <p>Generación y vinculación de órdenes de compra con pedidos de bodega.</p>
        </div>
        <div class="crud-card-footer" style="background:#f8f9fa;">
            <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/OrdenesCompra.aspx") %>' style="color:#2a1a0a;">
                Gestionar Órdenes <span class="arrow">→</span>
            </a>
        </div>
    </div>

    <div class="crud-card">
        <div class="crud-card-body">
            <div class="crud-icon">🧾</div>
            <h4>Facturas de Proveedor</h4>
            <p>Registro de facturas recibidas y control de pagos por orden de compra.</p>
        </div>
        <div class="crud-card-footer" style="background:#fdf6ec;">
            <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/FacturasProveedor.aspx") %>' style="color:#C9973A;">
                Ver Facturación <span class="arrow">→</span>
            </a>
        </div>
    </div>
</div>

<div class="section-label">⚠️ Seguimiento</div>
<div class="crud-grid one-col">
    <div class="crud-card" style="max-width: 400px;">
        <div class="crud-card-body">
            <div class="crud-icon">📢</div>
            <h4>Reclamos</h4>
            <p>Gestión de incidencias y reclamos realizados a proveedores por mercadería dañada o faltantes.</p>
        </div>
        <div class="crud-card-footer" style="background:#f5f0eb;">
            <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/ReclamosProveedor.aspx") %>' style="color:#5C3A1E;">
                Gestionar Reclamos <span class="arrow">→</span>
            </a>
        </div>
    </div>
</div>

</asp:Content>