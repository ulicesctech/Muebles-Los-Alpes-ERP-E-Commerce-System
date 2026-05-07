<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="FacturasProveedor.aspx.vb" Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.FacturasProveedor" MasterPageFile="~/Site.Master" ResponseEncoding="utf-8" MaintainScrollPositionOnPostback="true" %>
<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .page-title { font-size:22px; color:#5C3A1E; font-family:Georgia,serif; margin:0 0 20px; }
    .alert-ok  { padding:12px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:20px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; }
    .alert-err { padding:12px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:20px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; }
    .form-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:visible; margin-bottom:24px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .form-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:14px 20px; border-radius:12px 12px 0 0; }
    .form-card-head span { color:#f0d9a0; font-size:14px; font-weight:bold; font-family:Arial,sans-serif; }
    .form-card-body { padding:20px; }
    .f-row { display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; }
    .f-group { display:flex; flex-direction:column; gap:6px; flex:1; min-width:180px; }
    .f-group label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .f-group .form-control { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; width:100%; outline:none; min-width:0; box-sizing:border-box; }
    .f-group .form-control:focus { border-color:#C9973A; background:white; }
    .orden-readonly { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#f0f0f0; color:#888; width:100%; box-sizing:border-box; cursor:not-allowed; min-width:0; }
    .btn-gold    { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .flabel { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; display:block; margin-bottom:4px; }
    .fctl { padding:10px 12px; border:2px solid #e8d8c0; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; background:#fdf8f3; outline:none; width:100%; box-sizing:border-box; min-width:0; }
    .fctl:focus { border-color:#C9973A; background:white; }
    .search-bar { background:white; border-radius:12px; border:1px solid #e8d8c0; padding:16px 20px; margin-bottom:20px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .search-inner { display:flex; gap:10px; align-items:flex-end; flex-wrap:wrap; }
    .search-wrap { position:relative; }
    .search-wrap input { padding:10px 14px 10px 38px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; outline:none; width:100%; box-sizing:border-box; }
    .search-wrap input:focus { border-color:#C9973A; background:white; }
    .search-icon-abs { position:absolute; left:12px; top:50%; transform:translateY(-50%); font-size:15px; color:#aaa; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:14px 18px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; text-align:left; border:none; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf8f3; }
    .table-card tbody tr:last-child { border-bottom:none; }
    .table-card tbody td { padding:12px 18px; font-size:13px; color:#444; border:none; vertical-align:middle; }
    .badge-fac { background:#f0fdf4; color:#276749; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #c6f6d5; display:inline-block; }
    .badge-key { background:#fdf6ec; color:#C9973A; padding:3px 8px; border-radius:20px; font-size:11px; font-weight:bold; border:1px solid #e8d8c0; display:inline-block; }
    .actions-cell { display:flex; gap:6px; align-items:center; }
    .btn-edit-t { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-edit-t:hover { background:#C9973A; color:white !important; border-color:#C9973A; }
    .btn-del-t  { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-del-t:hover { background:#e53e3e; color:white !important; border-color:#e53e3e; }
    .empty-state { text-align:center; padding:50px 20px; color:#aaa; font-family:Arial,sans-serif; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>🏠 Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Index.aspx") %>'>💳 Cuentas por Pagar</a> /
    <strong style="color:#5C3A1E;">Facturas de Proveedor</strong>
</div>
<div class="page-title">🧾 Gestión de Facturas de Proveedor</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server"></asp:Label>
</asp:Panel>

<div class="form-card">
    <div class="form-card-head">
        <span>✏️ <asp:Label ID="lblTituloForm" runat="server" Text="Registrar Factura"></asp:Label></span>
    </div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfKey"  runat="server" />
        <asp:HiddenField ID="hfModo" runat="server" Value="nuevo" />

        <div class="f-row">
            <div class="f-group">
                <label>Orden de Compra <span style="color:#e53e3e;">*</span></label>
                <%-- Modo nuevo: dropdown --%>
                <asp:Panel ID="pnlOrdenNuevo" runat="server" Visible="true">
                    <asp:DropDownList ID="ddlOrden" runat="server"
                        style="width:100%; min-width:180px; padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; box-sizing:border-box;" />
                </asp:Panel>
                <%-- Modo editar: readonly --%>
                <asp:Panel ID="pnlOrdenEditar" runat="server" Visible="false">
                    <div class="orden-readonly">
                        <asp:Label ID="lblOrdenEditar" runat="server" />
                    </div>
                    <div style="font-size:11px; color:#888; font-style:italic; margin-top:4px;">
                        La orden de compra no se puede modificar en edicion.
                    </div>
                </asp:Panel>
            </div>

            <div class="f-group">
                <label>Código de Factura <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtCodigoFac" runat="server" CssClass="form-control" placeholder="Ej: FAC-001" />
            </div>
        </div>

        <div class="f-row" style="margin-top:16px; justify-content:flex-end;">
            <asp:Button ID="btnGuardar"  runat="server" Text="💾 Guardar"  CssClass="btn-gold tiempoInhabilitado"    OnClick="btnGuardar_Click tiempoInhabilitado" />
            <asp:Button ID="btnCancelar" runat="server" Text="✕ Cancelar" CssClass="btn-outline tiempoInhabilitado" OnClick="btnCancelar_Click tiempoInhabilitado" CausesValidation="false" />
        </div>
    </div>
</div>

<%-- BARRA DE BUSQUEDA — texto libre + rango de fechas (sin filtro por orden) --%>
<div class="search-bar">
    <div class="search-inner">
        <div style="display:flex; flex-direction:column; gap:4px; flex:3; min-width:200px;">
            <label class="flabel">Buscar</label>
            <div class="search-wrap">
                <span class="search-icon-abs">🔍</span>
                <asp:TextBox ID="txtBuscar" runat="server" placeholder="Codigo factura u orden de compra..." />
            </div>
        </div>
        <div style="display:flex; flex-direction:column; gap:4px; min-width:150px;">
            <label class="flabel">Fecha desde</label>
            <asp:TextBox ID="txtFechaDesde" runat="server" TextMode="Date" CssClass="fctl" />
        </div>
        <div style="display:flex; flex-direction:column; gap:4px; min-width:150px;">
            <label class="flabel">Fecha hasta</label>
            <asp:TextBox ID="txtFechaHasta" runat="server" TextMode="Date" CssClass="fctl" />
        </div>
        <div style="display:flex; gap:8px; align-items:flex-end; padding-bottom:1px;">
            <asp:Button ID="btnBuscar"  runat="server" Text="Buscar"  CssClass="btn-gold tiempoInhabilitado "    OnClick="btnBuscar_Click"  CausesValidation="false" />
            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-outline tiempoInhabilitado" OnClick="btnLimpiar_Click" CausesValidation="false" />
        </div>
    </div>
</div>

<div class="table-card">
    <asp:GridView ID="gvFacturas" runat="server" AutoGenerateColumns="false" CssClass="table"
                  OnRowCommand="gvFacturas_RowCommand" GridLines="None" Width="100%">
        <Columns>
            <%-- Solo ORC_ORDEN_COMPRA, sin ORC_CODIGO --%>
            <asp:TemplateField HeaderText="Orden de Compra">
                <ItemTemplate><span class="badge-key"><%# Eval("ORC_ORDEN_COMPRA") %></span></ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Cód. Factura">
                <ItemTemplate><span class="badge-fac"><%# Eval("FACPRO_CODIGO_FACTURA") %></span></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="FACPRO_FECHA" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-Width="110px" />
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="150px">
                <ItemTemplate>
                    <div class="actions-cell">
                        <asp:LinkButton CommandName="Editar"
                            CommandArgument='<%# Eval("ORC_ORDEN_COMPRA") %>'
                            runat="server" CssClass="btn-edit-t tiempoInhabilitado">✏️ Editar</asp:LinkButton>
                        <asp:LinkButton CommandName="Eliminar"
                            CommandArgument='<%# Eval("ORC_ORDEN_COMPRA") %>'
                            runat="server" CssClass="btn-del-t tiempoInhabilitado"
                            OnClientClick="return confirm('¿Eliminar esta factura?');">🗑 Borrar</asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="empty-state"><p>No hay facturas registradas.</p></div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
</asp:Content>
