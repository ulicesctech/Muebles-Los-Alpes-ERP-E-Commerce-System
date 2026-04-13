<%@ Page Title="Control de Stock" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Stock.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Stock" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .mod-header { background:linear-gradient(135deg,#1a1a1a,#2a1a0a); border-radius:12px; padding:24px 30px; margin-bottom:24px; border-left:5px solid #C9973A; display:flex; align-items:center; justify-content:space-between; box-shadow:0 4px 16px rgba(0,0,0,0.12); }
    .mod-header h2 { color:#C9973A; font-family:Georgia,serif; margin:0 0 5px; font-size:22px; }
    .mod-header p { color:rgba(240,217,160,0.6); margin:0; font-size:13px; font-family:Arial,sans-serif; }
    .mod-header .mod-icon { font-size:48px; opacity:0.12; }
    .alert-ok  { background:#f0fff4; border:1px solid #9ae6b4; color:#276749; padding:12px 16px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:16px; }
    .alert-err { background:#fff5f5; border:1px solid #fed7d7; color:#c53030; padding:12px 16px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:16px; }
    .step-card { background:white; border-radius:12px; border:1px solid #e8d8c0; padding:22px 24px; margin-bottom:16px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .step-card h4 { color:#5C3A1E; font-family:Georgia,serif; font-size:15px; margin:0 0 14px; display:flex; align-items:center; gap:10px; }
    .step-num { background:#C9973A; color:#1a0e05; width:26px; height:26px; border-radius:50%; display:inline-flex; align-items:center; justify-content:center; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; flex-shrink:0; }
    .f-row { display:flex; gap:14px; align-items:flex-end; flex-wrap:wrap; }
    .f-group { display:flex; flex-direction:column; gap:5px; flex:1; min-width:180px; }
    .f-group label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .f-group select, .f-group input { padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none; transition:border 0.2s; width:100%; }
    .f-group select:focus, .f-group input:focus { border-color:#C9973A; }
    .f-group input[readonly] { background:#f5f0eb; color:#888; cursor:not-allowed; }
    .info-badge { background:#fdf6ec; border:1px solid #e8d0a0; border-radius:8px; padding:10px 14px; font-size:13px; font-family:Arial,sans-serif; color:#5C3A1E; margin-top:8px; }
    .info-badge strong { color:#C9973A; }
    .btn-gold { background:#C9973A; color:#1a0e05; border:none; padding:10px 22px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; transition:all 0.2s; }
    .btn-gold:hover { background:#a87a2e; color:white; }
    .btn-green { background:#2d7a2d; color:white; border:none; padding:10px 22px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; transition:all 0.2s; margin-left:8px; }
    .btn-green:hover { background:#1e5c1e; }
    .btn-outline { background:white; color:#5C3A1E; border:1.5px solid #e0d0b8; padding:10px 22px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; transition:all 0.2s; margin-left:8px; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .stock-actual { background:#f0f7ff; border:1px solid #b0c8f0; border-radius:10px; padding:16px 20px; margin-bottom:16px; }
    .stock-actual h5 { color:#3060c0; font-family:Arial,sans-serif; font-size:13px; font-weight:bold; margin:0 0 12px; text-transform:uppercase; letter-spacing:0.5px; }
    .stock-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:10px; }
    .stock-item { background:white; border-radius:8px; padding:12px; text-align:center; border:1px solid #e0d0b8; }
    .stock-item .sv { font-size:22px; font-weight:900; color:#1a0e05; font-family:Arial,sans-serif; }
    .stock-item .sl { font-size:11px; color:#aaa; font-family:Arial,sans-serif; margin-top:3px; text-transform:uppercase; }
    .stock-item.bajo { border-color:#fed7d7; background:#fff5f5; }
    .stock-item.bajo .sv { color:#c53030; }
    .stock-item.alto { border-color:#e8d0a0; background:#fdf6ec; }
    .stock-item.alto .sv { color:#C9973A; }
    .precio-actual { background:#f0fff4; border:1px solid #9ae6b4; border-radius:8px; padding:10px 14px; margin-bottom:12px; font-size:13px; font-family:Arial,sans-serif; color:#276749; }
    .precio-actual strong { font-size:16px; }
    .aviso-precio { background:#fff8e1; border:1px solid #ffe082; border-radius:8px; padding:12px 16px; margin-bottom:12px; font-size:13px; font-family:Arial,sans-serif; color:#7a5818; }
    .entrada-card { background:#f0fff4; border:1px solid #9ae6b4; border-radius:10px; padding:16px 20px; margin-bottom:16px; }
    .entrada-card h5 { color:#276749; font-family:Arial,sans-serif; font-size:13px; font-weight:bold; margin:0 0 12px; text-transform:uppercase; letter-spacing:0.5px; }
    .section-label { font-size:12px; font-weight:bold; color:#5C3A1E; margin:0 0 14px; padding:8px 14px; background:linear-gradient(135deg,#fdf6ec,#f5e8d0); border-radius:8px; border-left:4px solid #C9973A; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); margin-bottom:20px; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; font-size:13px; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#7a4f2a); }
    .table-card thead th { color:#f0d9a0; padding:12px 16px; text-align:left; font-size:11px; text-transform:uppercase; letter-spacing:0.5px; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf6ec; }
    .table-card tbody td { padding:11px 16px; color:#333; vertical-align:middle; }
    .badge-normal { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; background:#f0fff4; color:#2d7a2d; border:1px solid #9ae6b4; }
    .badge-bajo   { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; background:#fff5f5; color:#c53030; border:1px solid #fed7d7; }
    .badge-alto   { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; background:#fdf6ec; color:#C9973A; border:1px solid #e8d0a0; }
    .back-link { display:inline-flex; align-items:center; gap:6px; color:#C9973A; font-size:13px; font-family:Arial,sans-serif; text-decoration:none; margin-top:20px; padding:8px 14px; border-radius:6px; border:1px solid #e8d8c0; background:white; transition:all 0.2s; }
    .back-link:hover { border-color:#C9973A; background:#fdf6ec; text-decoration:none; color:#C9973A; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>Catalogo &amp; Inventario</a> /
    <strong style="color:#5C3A1E;">Control de Stock</strong>
</div>

<div class="mod-header">
    <div>
        <h2>Control de Stock</h2>
        <p>Gestiona limites y registra entradas de mercancia por producto y nicho.</p>
    </div>
    <div class="mod-icon">&#128230;</div>
</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<%-- PASO 1 --%>
<div class="step-card">
    <h4><span class="step-num">1</span> Selecciona el Producto</h4>
    <div class="f-row">
        <div class="f-group">
            <label>Producto</label>
            <asp:DropDownList ID="ddlProducto" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlProducto_SelectedIndexChanged" />
        </div>
    </div>
    <asp:Panel ID="pnlInfoProducto" runat="server" Visible="false">
        <div class="info-badge" style="margin-top:10px;">
            Tipo: <strong><asp:Label ID="lblTipo" runat="server" /></strong>
            &nbsp;|&nbsp;
            Material: <strong><asp:Label ID="lblMaterial" runat="server" /></strong>
        </div>
    </asp:Panel>
</div>

<%-- PASO 2 --%>
<asp:Panel ID="pnlPaso2" runat="server" Visible="false">
    <div class="step-card">
        <h4><span class="step-num">2</span> Selecciona el Almacen</h4>
        <div class="f-row">
            <div class="f-group">
                <label>Almacen</label>
                <asp:DropDownList ID="ddlAlmacen" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlAlmacen_SelectedIndexChanged" />
            </div>
        </div>
    </div>
</asp:Panel>

<%-- PASO 3 --%>
<asp:Panel ID="pnlPaso3" runat="server" Visible="false">
    <div class="step-card">
        <h4><span class="step-num">3</span> Selecciona el Nicho</h4>
        <div class="f-row">
            <div class="f-group">
                <label>Nicho</label>
                <asp:DropDownList ID="ddlNicho" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlNicho_SelectedIndexChanged" />
            </div>
        </div>
    </div>
</asp:Panel>

<%-- PASO 4 --%>
<asp:Panel ID="pnlPaso4" runat="server" Visible="false">
    <div class="step-card">
        <h4><span class="step-num">4</span> Gestionar Stock</h4>
        <asp:HiddenField ID="hfHipId" runat="server" Value="" />

        <%-- Precio vigente --%>
        <asp:Panel ID="pnlPrecioVigente" runat="server" Visible="false">
            <div class="precio-actual">
                Precio vigente: <strong><asp:Label ID="lblPrecioVigente" runat="server" /></strong>
            </div>
        </asp:Panel>

        <%-- Aviso sin precio --%>
        <asp:Panel ID="pnlAvisoPrecio" runat="server" Visible="false">
            <div class="aviso-precio">
                No hay precio registrado en este nicho. Ve a Historial de Precios y registra el precio primero.
            </div>
        </asp:Panel>

        <%-- Stock actual (solo lectura) --%>
        <asp:Panel ID="pnlStockActual" runat="server" Visible="false">
            <div class="stock-actual">
                <h5>Stock Actual</h5>
                <div class="stock-grid">
                    <div class="stock-item" id="cardDisponible" runat="server">
                        <div class="sv"><asp:Label ID="lblDisponible" runat="server" Text="0" /></div>
                        <div class="sl">Disponible</div>
                    </div>
                    <div class="stock-item">
                        <div class="sv"><asp:Label ID="lblMinimo" runat="server" Text="0" /></div>
                        <div class="sl">Minimo</div>
                    </div>
                    <div class="stock-item">
                        <div class="sv"><asp:Label ID="lblMaximo" runat="server" Text="0" /></div>
                        <div class="sl">Maximo</div>
                    </div>
                </div>
            </div>

            <%-- Entrada de mercancia --%>
            <div class="entrada-card">
                <h5>Registrar Entrada de Mercancia</h5>
                <div class="f-row">
                    <div class="f-group" style="max-width:200px;">
                        <label>Cantidad que ingresa *</label>
                        <asp:TextBox ID="txtCantidadEntrada" runat="server" placeholder="0" />
                    </div>
                    <div style="display:flex; align-items:flex-end;">
                        <asp:Button ID="btnEntrada" runat="server" Text="Registrar Entrada" CssClass="btn-green" OnClick="btnEntrada_Click" />
                    </div>
                </div>
            </div>

            <%-- Editar limites --%>
            <div style="margin-bottom:14px; font-size:12px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px;">
                Ajustar Limites
            </div>
            <div class="f-row" style="margin-bottom:16px;">
                <div class="f-group" style="max-width:200px;">
                    <label>Disponible (solo lectura)</label>
                    <asp:TextBox ID="txtDisponible" runat="server" ReadOnly="true" />
                </div>
                <div class="f-group" style="max-width:200px;">
                    <label>Minimo *</label>
                    <asp:TextBox ID="txtMinimo" runat="server" placeholder="0" />
                </div>
                <div class="f-group" style="max-width:200px;">
                    <label>Maximo *</label>
                    <asp:TextBox ID="txtMaximo" runat="server" placeholder="0" />
                </div>
            </div>
            <asp:Button ID="btnGuardar"  runat="server" Text="Guardar Limites" CssClass="btn-gold"    OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar"        CssClass="btn-outline" OnClick="btnCancelar_Click" CausesValidation="false" />
        </asp:Panel>

        <%-- Sin stock aun --%>
        <asp:Panel ID="pnlSinStock" runat="server" Visible="false">
            <div class="aviso-precio" style="margin-bottom:14px;">
                Este producto no tiene stock registrado en este nicho aun.
            </div>
            <div class="f-row" style="margin-bottom:16px;">
                <div class="f-group" style="max-width:200px;">
                    <label>Disponible inicial *</label>
                    <asp:TextBox ID="txtDisponibleNuevo" runat="server" placeholder="0" />
                </div>
                <div class="f-group" style="max-width:200px;">
                    <label>Minimo *</label>
                    <asp:TextBox ID="txtMinimoNuevo" runat="server" placeholder="0" />
                </div>
                <div class="f-group" style="max-width:200px;">
                    <label>Maximo *</label>
                    <asp:TextBox ID="txtMaximoNuevo" runat="server" placeholder="0" />
                </div>
            </div>
            <asp:Button ID="btnCrearStock"  runat="server" Text="Crear Stock" CssClass="btn-gold"    OnClick="btnCrearStock_Click" />
            <asp:Button ID="btnCancelar2"   runat="server" Text="Cancelar"    CssClass="btn-outline" OnClick="btnCancelar_Click" CausesValidation="false" />
        </asp:Panel>

    </div>
</asp:Panel>

<%-- TABLA --%>
<div class="section-label">Stock General</div>
<div class="table-card">
    <asp:GridView ID="gvStock" runat="server" AutoGenerateColumns="false"
        EmptyDataText="No hay stock registrado." style="width:100%;">
        <Columns>
            <asp:BoundField DataField="PRO_NOMBRE"         HeaderText="Producto" />
            <asp:BoundField DataField="ALM_NOMBRE"         HeaderText="Almacen"        ItemStyle-Width="130px" />
            <asp:BoundField DataField="NIC_NUMERO"         HeaderText="Nicho"          ItemStyle-Width="70px" />
            <asp:BoundField DataField="NIC_CARACTERISTICA" HeaderText="Caracteristica" />
            <asp:BoundField DataField="HIP_PRECIO"         HeaderText="Precio Venta"   DataFormatString="{0:C2}" ItemStyle-Width="100px" />
            <asp:BoundField DataField="STO_DISPONIBLE"     HeaderText="Disponible"     ItemStyle-Width="85px" />
            <asp:BoundField DataField="STO_MINIMO"         HeaderText="Minimo"         ItemStyle-Width="75px" />
            <asp:BoundField DataField="STO_MAXIMO"         HeaderText="Maximo"         ItemStyle-Width="75px" />
            <asp:TemplateField HeaderText="Estado" ItemStyle-Width="80px">
                <ItemTemplate>
                    <%# If(Eval("ESTADO_STOCK").ToString() = "BAJO",
                        "<span class='badge-bajo'>Bajo</span>",
                        If(Eval("ESTADO_STOCK").ToString() = "ALTO",
                            "<span class='badge-alto'>Alto</span>",
                            "<span class='badge-normal'>Normal</span>")) %>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>

<a class="back-link" href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>&#8592; Volver a Catalogo &amp; Inventario</a>

</asp:Content>