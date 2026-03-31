<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="FacturasProveedor.aspx.vb" Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.FacturasProveedor" MasterPageFile="~/Site.Master" ResponseEncoding="utf-8" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    /* Estilos originales preservados al 100% */
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .page-title { font-size:22px; color:#5C3A1E; font-family:Georgia,serif; margin:0 0 20px; }
    .alert-ok  { padding:12px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:20px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; }
    .alert-err { padding:12px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:20px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; }
    .form-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; margin-bottom:24px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .form-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:14px 20px; }
    .form-card-head span { color:#f0d9a0; font-size:14px; font-weight:bold; font-family:Arial,sans-serif; }
    .form-card-body { padding:20px; }
    .f-row { display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; }
    .f-group { display:flex; flex-direction:column; gap:6px; flex:1; min-width:200px; }
    .f-group label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .f-group .form-control { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; width:100%; outline:none; }
    .f-group .form-control:focus { border-color:#C9973A; background:white; }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .search-bar { background:white; border-radius:12px; border:1px solid #e8d8c0; padding:16px 20px; margin-bottom:20px; display:flex; gap:10px; align-items:center; flex-wrap:wrap; }
    .search-wrap { flex:1; position:relative; min-width:200px; }
    .search-wrap input { width:100%; padding:10px 14px 10px 38px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; background:#fdf8f3; outline:none; }
    .search-icon-abs { position:absolute; left:12px; top:50%; transform:translateY(-50%); font-size:15px; color:#aaa; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:14px 18px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; text-align:left; }
    .table-card tbody td { padding:12px 18px; font-size:13px; color:#444; border-bottom:1px solid #f5ece0; }
    .badge-fac { background:#f0fdf4; color:#276749; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #c6f6d5; }
    .badge-key { background:#fdf6ec; color:#C9973A; padding:3px 8px; border-radius:20px; font-size:11px; font-weight:bold; border:1px solid #e8d8c0; }
</style>

<div class="breadcrumb-mod">🏠 Inicio / Cuentas por Pagar / <strong>Facturas de Proveedor</strong></div>
<div class="page-title">🧾 Gestión de Facturas de Proveedor</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server"></asp:Label>
</asp:Panel>

<div class="form-card">
    <div class="form-card-head">
        <span>✏️ <asp:Label ID="lblTituloForm" runat="server" Text="Registrar Factura"></asp:Label></span>
    </div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfKey" runat="server" />
        <asp:HiddenField ID="hfModo" runat="server" Value="nuevo" />
        <div class="f-row">
            <div class="f-group">
                <label>Orden de Compra *</label>
                <asp:DropDownList ID="ddlOrden" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div class="f-group">
                <label>Código de Factura *</label>
                <asp:TextBox ID="txtCodigoFac" runat="server" CssClass="form-control" placeholder="Ej: FAC-001"></asp:TextBox>
            </div>
        </div>
        <div class="f-row" style="margin-top:16px; justify-content:flex-end;">
            <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar" CssClass="btn-gold" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="✕ Cancelar" CssClass="btn-outline" OnClick="btnCancelar_Click" />
        </div>
    </div>
</div>

<div class="search-bar">
    <div class="search-wrap">
        <span class="search-icon-abs">🔍</span>
        <asp:TextBox ID="txtBuscar" runat="server" placeholder="Buscar por código o Cod.FActura..."></asp:TextBox>
    </div>
    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn-gold" OnClick="btnBuscar_Click" />
    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-outline" OnClick="btnLimpiar_Click" />
</div>

<div class="table-card">
    <asp:GridView ID="gvFacturas" runat="server" AutoGenerateColumns="false" CssClass="table" OnRowCommand="gvFacturas_RowCommand" GridLines="None" Width="100%">
        <Columns>
            <asp:TemplateField HeaderText="Orden de Compra">
                <ItemTemplate><span class="badge-key"><%# Eval("ORC_CODIGO") %></span></ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Cód. Factura">
                <ItemTemplate><span class="badge-fac"><%# Eval("FACPRO_CODIGO_FACTURA") %></span></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="FACPRO_FECHA" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <asp:LinkButton CommandName="Editar" CommandArgument='<%# Eval("ORC_ORDEN_COMPRA") %>' runat="server" style="color:#C9973A; font-weight:bold; margin-right:15px; text-decoration:none;">✏️ Editar</asp:LinkButton>
                    <asp:LinkButton CommandName="Eliminar" CommandArgument='<%# Eval("ORC_ORDEN_COMPRA") %>' runat="server" OnClientClick="return confirm('¿Eliminar?');" style="color:#e53e3e; font-weight:bold; text-decoration:none;">🗑 Borrar</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>
</asp:Content>