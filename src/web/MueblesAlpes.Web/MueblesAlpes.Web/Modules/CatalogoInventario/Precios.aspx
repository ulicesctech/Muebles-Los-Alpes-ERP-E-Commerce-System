<%@ Page Title="Historial de Precios" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Precios.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Precios" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .mod-header { background:linear-gradient(135deg,#1a1a1a,#2a1a0a); border-radius:12px; padding:24px 30px; margin-bottom:24px; border-left:5px solid #C9973A; display:flex; align-items:center; justify-content:space-between; box-shadow:0 4px 16px rgba(0,0,0,0.12); }
    .mod-header h2 { color:#C9973A; font-family:Georgia,serif; margin:0 0 5px; font-size:22px; }
    .mod-header p { color:rgba(240,217,160,0.6); margin:0; font-size:13px; font-family:Arial,sans-serif; }
    .mod-header .mod-icon { font-size:48px; opacity:0.12; }
    .filter-bar { background:white; border-radius:12px; border:1px solid #e8d8c0; padding:16px 20px; margin-bottom:16px; display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .filter-bar .fg { display:flex; flex-direction:column; gap:5px; }
    .filter-bar .fg label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .filter-bar .fg select { padding:9px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none; }
    .btn-gold { background:#C9973A; color:#1a0e05; border:none; padding:10px 22px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; transition:all 0.2s; }
    .btn-gold:hover { background:#a87a2e; color:white; }
    .section-label { font-size:12px; font-weight:bold; color:#5C3A1E; margin:0 0 14px; padding:8px 14px; background:linear-gradient(135deg,#fdf6ec,#f5e8d0); border-radius:8px; border-left:4px solid #C9973A; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); margin-bottom:20px; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; font-size:13px; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#7a4f2a); }
    .table-card thead th { color:#f0d9a0; padding:12px 16px; text-align:left; font-size:11px; text-transform:uppercase; letter-spacing:0.5px; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf6ec; }
    .table-card tbody td { padding:11px 16px; color:#333; vertical-align:middle; }
    .badge-vigente   { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; background:#f0fff4; color:#2d7a2d; border:1px solid #9ae6b4; }
    .badge-historico { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; background:#fdf6ec; color:#C9973A; border:1px solid #e8d0a0; }
    .alert-ok  { background:#f0fff4; border:1px solid #9ae6b4; color:#276749; padding:10px 16px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:16px; }
    .alert-err { background:#fff5f5; border:1px solid #fed7d7; color:#c53030; padding:10px 16px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:16px; }
    .back-link { display:inline-flex; align-items:center; gap:6px; color:#C9973A; font-size:13px; font-family:Arial,sans-serif; text-decoration:none; margin-top:20px; padding:8px 14px; border-radius:6px; border:1px solid #e8d8c0; background:white; transition:all 0.2s; }
    .back-link:hover { border-color:#C9973A; background:#fdf6ec; text-decoration:none; color:#C9973A; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>Catalogo &amp; Inventario</a> /
    <strong style="color:#5C3A1E;">Historial de Precios</strong>
</div>

<div class="mod-header">
    <div>
        <h2>Historial de Precios</h2>
        <p>Registro de precios de venta por producto, almacen y nicho.</p>
    </div>
    <div class="mod-icon">&#128176;</div>
</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<%-- FILTRO --%>
<div class="section-label">Historial de Precios</div>
<div class="filter-bar">
    <div class="fg">
        <label>Mes</label>
        <asp:DropDownList ID="ddlMes" runat="server"
            style="padding:9px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
    </div>
    <div class="fg">
        <label>Anio</label>
        <asp:DropDownList ID="ddlAnio" runat="server"
            style="padding:9px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
    </div>
    <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn-gold" OnClick="btnFiltrar_Click" CausesValidation="false" />
</div>

<div class="table-card">
<asp:GridView ID="gvHistorial" runat="server"
    AutoGenerateColumns="false"
    EmptyDataText="No hay registros de precios."
    style="width:100%;">
    <Columns>
        <asp:BoundField DataField="HIP_HISTORIAL_PRECIO" HeaderText="ID"             ItemStyle-Width="50px" />
        <asp:BoundField DataField="PRO_NOMBRE"           HeaderText="Producto" />
        <asp:BoundField DataField="ALM_NOMBRE"           HeaderText="Almacen"        ItemStyle-Width="120px" />
        <asp:BoundField DataField="NIC_NUMERO"           HeaderText="Nicho"          ItemStyle-Width="70px" />
        <asp:BoundField DataField="NIC_CARACTERISTICA"   HeaderText="Caracteristica" />
        <asp:TemplateField HeaderText="Precio" ItemStyle-Width="110px">
            <ItemTemplate>
                Q <%# String.Format("{0:N2}", Eval("HIP_PRECIO")) %>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField DataField="HIP_FECHA_INICIO" HeaderText="Desde" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-Width="100px" />
        <asp:BoundField DataField="HIP_FECHA_FINAL"  HeaderText="Hasta" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-Width="100px" />
        <asp:TemplateField HeaderText="Estado" ItemStyle-Width="90px">
            <ItemTemplate>
                <%# If(Eval("HIP_FECHA_FINAL") Is DBNull.Value OrElse Eval("HIP_FECHA_FINAL").ToString() = "",
                    "<span class='badge-vigente'>Vigente</span>",
                    "<span class='badge-historico'>Historico</span>") %>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
</div>

<a class="back-link" href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>&#8592; Volver a Catalogo &amp; Inventario</a>

</asp:Content>
