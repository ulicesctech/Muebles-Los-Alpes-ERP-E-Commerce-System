<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="OrdenesCompra.aspx.vb" Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.OrdenesCompra" MasterPageFile="~/Site.Master" ResponseEncoding="utf-8" ContentType="text/html; charset=UTF-8" %>
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
    .note-auto { font-size:11px; color:#888; font-style:italic; margin-top:4px; }
    .btn-gold    { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .search-bar { background:white; border-radius:12px; border:1px solid #e8d8c0; padding:16px 20px; margin-bottom:20px; display:flex; gap:10px; align-items:center; flex-wrap:wrap; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .search-wrap { flex:1; position:relative; min-width:200px; }
    .search-wrap input { width:100%; padding:10px 14px 10px 38px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; outline:none; }
    .search-wrap input:focus { border-color:#C9973A; background:white; }
    .search-icon-abs { position:absolute; left:12px; top:50%; transform:translateY(-50%); font-size:15px; color:#aaa; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:14px 18px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; letter-spacing:0.5px; border:none; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf8f3; }
    .table-card tbody tr:last-child { border-bottom:none; }
    .table-card tbody td { padding:12px 18px; font-size:13px; color:#444; vertical-align:middle; border:none; }
    .badge-key { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; border:1px solid #e8d8c0; display:inline-block; max-width:160px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; vertical-align:middle; }
    .actions-cell { display:flex; gap:8px; align-items:center; justify-content:flex-end; }
    .btn-edit-t { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:6px 14px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-edit-t:hover { background:#C9973A; color:white !important; border-color:#C9973A; text-decoration:none; }
    .btn-del-t { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:6px 14px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-del-t:hover { background:#e53e3e; color:white !important; border-color:#e53e3e; text-decoration:none; }
    .empty-state { text-align:center; padding:50px 20px; color:#aaa; font-family:Arial,sans-serif; }
    .empty-state .ei { font-size:48px; margin-bottom:10px; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>🏠 Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Index.aspx") %>'>💳 Compras proveedores</a> /
    <strong style="color:#5C3A1E;">Órdenes de Compra</strong>
</div>
<div class="page-title">🛒 Gestión de Órdenes de Compra</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server"></asp:Label>
</asp:Panel>

<div class="form-card">
    <div class="form-card-head">
        <span>✏️ <asp:Label ID="lblTituloForm" runat="server" Text="Nueva Orden de Compra"></asp:Label></span>
    </div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfKey"  runat="server" Value="" />
        <asp:HiddenField ID="hfModo" runat="server" Value="nuevo" />

        <div class="f-row">
            <div class="f-group">
                <label>Código <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control" MaxLength="50" placeholder="Ej: OC-2025-001"></asp:TextBox>
            </div>
            <div class="f-group">
                <label>Proveedor <span style="color:#e53e3e;">*</span></label>
                <asp:DropDownList ID="ddlProveedor" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div class="f-group">
                <label>Total (Q) <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtTotal" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
            </div>
        </div>
        <div class="f-row" style="margin-top:8px;">
            <div class="note-auto">📅 La fecha de la orden se registra automáticamente al crear.</div>
        </div>
        <div class="f-row" style="margin-top:16px; justify-content:flex-end;">
            <asp:Button ID="btnGuardar"  runat="server" Text="💾 Guardar"  CssClass="btn-gold"    OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="✕ Cancelar" CssClass="btn-outline" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>
</div>

<div class="search-bar">
    <div class="search-wrap">
        <span class="search-icon-abs">🔍</span>
        <asp:TextBox ID="txtBuscar" runat="server" placeholder="Buscar por código de orden..."></asp:TextBox>
    </div>
    <asp:Button ID="btnBuscar"  runat="server" Text="Buscar"  CssClass="btn-gold"    OnClick="btnBuscar_Click"  CausesValidation="false" />
    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-outline" OnClick="btnLimpiar_Click" CausesValidation="false" />
</div>

<div class="table-card">
    <asp:GridView ID="gvOrdenes" runat="server" AutoGenerateColumns="false" CssClass="table"
                  OnRowCommand="gvOrdenes_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="Código OC">
                <ItemTemplate>
                    <%-- Corregido: Se muestra ORC_CODIGO (OC1, OC2) en lugar del GUID largo --%>
                    <span class="badge-key" title='ID Técnico: <%# Eval("ORC_ORDEN_COMPRA") %>'>
                        <%# Eval("ORC_CODIGO") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:BoundField DataField="PROV_NOMBRE"   HeaderText="Proveedor" />
            <asp:BoundField DataField="ORC_FECHA"      HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="ORC_TOTAL_PRECIO" HeaderText="Total (Q)" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
            
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="180px">
                <ItemTemplate>
                    <div class="actions-cell">
                        <%-- Se sigue usando ORC_ORDEN_COMPRA en CommandArgument porque es la llave primaria --%>
                        <asp:LinkButton CommandName="Editar"   CommandArgument='<%# Eval("ORC_ORDEN_COMPRA") %>' runat="server" CssClass="btn-edit-t">✏️ Editar</asp:LinkButton>
                        <asp:LinkButton CommandName="Eliminar" CommandArgument='<%# Eval("ORC_ORDEN_COMPRA") %>' runat="server" CssClass="btn-del-t" OnClientClick="return confirm('¿Eliminar esta orden de compra?');">🗑 Eliminar</asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="empty-state"><div class="ei">🛒</div><p>No hay órdenes de compra registradas.</p></div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
</asp:Content>