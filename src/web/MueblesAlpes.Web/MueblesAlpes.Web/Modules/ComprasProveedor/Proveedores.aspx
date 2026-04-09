<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Proveedores.aspx.vb" Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.Proveedores" MasterPageFile="~/Site.Master" ResponseEncoding="utf-8" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
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
    .f-group { display:flex; flex-direction:column; gap:6px; flex:1; min-width:180px; }
    .f-group label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .f-group .form-control { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; width:100%; outline:none; }
    .f-group .form-control:focus { border-color:#C9973A; background:white; }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .search-bar { background:white; border-radius:12px; border:1px solid #e8d8c0; padding:16px 20px; margin-bottom:20px; display:flex; gap:10px; align-items:center; flex-wrap:wrap; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .search-wrap { flex:1; position:relative; min-width:200px; }
    .search-wrap input { width:100%; padding:10px 14px 10px 38px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; outline:none; }
    .search-icon-abs { position:absolute; left:12px; top:50%; transform:translateY(-50%); font-size:15px; color:#aaa; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:14px 18px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; letter-spacing:0.5px; border:none; text-align:left; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf8f3; }
    .table-card tbody td { padding:12px 18px; font-size:13px; color:#444; vertical-align:middle; border:none; }
    .badge-id { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; display:inline-block; }
    .actions-cell { display:flex; gap:8px; align-items:center; justify-content:flex-end; }
    .btn-edit-t { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:6px 14px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; }
    .btn-del-t { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:6px 14px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>🏠 Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Index.aspx") %>'>💳 Cuentas por Pagar</a> /
    <strong style="color:#5C3A1E;">Proveedores</strong>
</div>

<div class="page-title">🏭 Gestión de Proveedores</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server"></asp:Label>
</asp:Panel>

<div class="form-card">
    <div class="form-card-head">
        <span>✏️ <asp:Label ID="lblTituloForm" runat="server" Text="Nuevo Proveedor"></asp:Label></span>
    </div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfId" runat="server" Value="0" />
        <div class="f-row">
            <div class="f-group">
                <label>NIT <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtNit" runat="server" CssClass="form-control" placeholder="Ej: 12345678-9"></asp:TextBox>
            </div>
            <div class="f-group">
                <label>Nombre <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Razón social"></asp:TextBox>
            </div>
            <div class="f-group">
                <label>Teléfono <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="Ej: 2222-3333"></asp:TextBox>
            </div>
        </div>
        <div class="f-row" style="margin-top:12px;">
            <div class="f-group">
                <label>Avenida <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtAvenida" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="f-group">
                <label>Zona <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtZona" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="f-group" style="flex:2;">
                <label>Dirección <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
        </div>
        <div class="f-row" style="margin-top:16px; justify-content:flex-end;">
            <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar" CssClass="btn-gold" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="✕ Cancelar" CssClass="btn-outline" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>
</div>

<div class="search-bar">
    <div class="search-wrap">
        <span class="search-icon-abs">🔍</span>
        <asp:TextBox ID="txtBuscar" runat="server" placeholder="Buscar por nombre o NIT..."></asp:TextBox>
    </div>
    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn-gold" OnClick="btnBuscar_Click" CausesValidation="false" />
    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-outline" OnClick="btnLimpiar_Click" CausesValidation="false" />
</div>

<div class="table-card">
    <asp:GridView ID="gvProveedores" runat="server" AutoGenerateColumns="false" CssClass="table" OnRowCommand="gvProveedores_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID" ItemStyle-Width="70px">
                <ItemTemplate><span class="badge-id"><%# Eval("PROV_PROVEEDOR") %></span></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="PROV_NIT" HeaderText="NIT" />
            <asp:BoundField DataField="PROV_NOMBRE" HeaderText="Nombre" />
            <asp:BoundField DataField="PROV_TELEFONO" HeaderText="Teléfono" />
            <asp:BoundField DataField="PROV_AVENIDA" HeaderText="Avenida" />
            <asp:BoundField DataField="PROV_ZONA" HeaderText="Zona" />
            <asp:BoundField DataField="PROV_DIRECCION" HeaderText="Dirección" />
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="180px">
                <ItemTemplate>
                    <div class="actions-cell">
                        <asp:LinkButton CommandName="Editar" CommandArgument='<%# Eval("PROV_PROVEEDOR") %>' runat="server" CssClass="btn-edit-t">✏️ Editar</asp:LinkButton>
                        <asp:LinkButton CommandName="Eliminar" CommandArgument='<%# Eval("PROV_PROVEEDOR") %>' runat="server" CssClass="btn-del-t" OnClientClick="return confirm('¿Eliminar?');">🗑 Eliminar</asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>
</asp:Content>