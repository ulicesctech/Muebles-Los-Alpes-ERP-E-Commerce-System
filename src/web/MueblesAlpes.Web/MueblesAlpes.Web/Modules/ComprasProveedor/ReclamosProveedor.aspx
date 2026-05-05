<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="ReclamosProveedor.aspx.vb" Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.ReclamosProveedor" MasterPageFile="~/Site.Master" ResponseEncoding="utf-8" ContentType="text/html; charset=UTF-8" MaintainScrollPositionOnPostback="true" %>
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
    .form-card-head.estado-head  { background:linear-gradient(135deg,#2b6cb0,#2c5282); }
    .form-card-head.coment-head  { background:linear-gradient(135deg,#276749,#1a4d35); }
    .form-card-body { padding:20px; }
    .f-row { display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; }
    .f-group { display:flex; flex-direction:column; gap:6px; flex:1; min-width:180px; }
    .f-group label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .f-group .form-control { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; width:100%; outline:none; min-width:0; box-sizing:border-box; }
    .f-group .form-control:focus { border-color:#C9973A; background:white; }
    .f-group .form-control-green { padding:10px 14px; border:2px solid #9ae6b4; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#f0fff4; width:100%; outline:none; min-width:0; box-sizing:border-box; }
    .f-group .form-control-green:focus { border-color:#276749; background:white; }
    .note-auto   { font-size:11px; color:#888; font-style:italic; margin-top:4px; }
    .note-cierre { font-size:11px; color:#276749; font-weight:bold; margin-top:4px; background:#f0fff4; padding:8px 12px; border-radius:6px; border-left:3px solid #48bb78; }
    .btn-gold    { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-blue    { background:linear-gradient(135deg,#3182ce,#2b6cb0); color:white; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-blue:hover { background:linear-gradient(135deg,#2b6cb0,#1e4e8c); color:white; }
    .btn-green   { background:linear-gradient(135deg,#276749,#1a4d35); color:white; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-green:hover { background:linear-gradient(135deg,#1a4d35,#0f3020); color:white; }
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
    .table-card thead th { padding:14px 18px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; letter-spacing:0.5px; border:none; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf8f3; }
    .table-card tbody tr:last-child { border-bottom:none; }
    .table-card tbody td { padding:12px 18px; font-size:13px; color:#444; vertical-align:middle; border:none; }
    .badge-id { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; display:inline-block; }
    .estado-INICIADO  { background:#ebf8ff; color:#2b6cb0; border:1px solid #bee3f8; }
    .estado-PENDIENTE { background:#fffbeb; color:#b7791f; border:1px solid #fef3c7; }
    .estado-RESUELTO  { background:#f0fff4; color:#276749; border:1px solid #c6f6d5; }
    .estado-RECHAZADO { background:#fff5f5; color:#c53030; border:1px solid #fed7d7; }
    .badge-estado { padding:4px 12px; border-radius:20px; font-size:11px; font-weight:bold; display:inline-block; }
    .actions-cell { display:flex; gap:6px; align-items:center; justify-content:flex-end; flex-wrap:wrap; }
    .btn-edit-t     { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-edit-t:hover { background:#C9973A; color:white !important; border-color:#C9973A; }
    .btn-estado-t   { background:#ebf8ff; color:#2b6cb0; border:1px solid #bee3f8; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-estado-t:hover { background:#2b6cb0; color:white !important; border-color:#2b6cb0; }
    .btn-coment-t   { background:#f0fff4; color:#276749; border:1px solid #9ae6b4; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-coment-t:hover { background:#276749; color:white !important; border-color:#276749; }
    .btn-del-t      { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-del-t:hover { background:#e53e3e; color:white !important; border-color:#e53e3e; }
    .btn-disabled-t { background:#f7f7f7; color:#bbb; border:1px solid #e0e0e0; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:not-allowed; text-decoration:none; display:inline-block; white-space:nowrap; }
    .empty-state { text-align:center; padding:50px 20px; color:#aaa; font-family:Arial,sans-serif; }
    .empty-state .ei { font-size:48px; margin-bottom:10px; }
    .info-row { background:#fdf8f3; border:1px solid #e8d8c0; border-radius:8px; padding:12px 16px; margin-bottom:14px; font-size:13px; font-family:Arial,sans-serif; color:#5C3A1E; }
    .info-row strong { color:#C9973A; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>🏠 Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Index.aspx") %>'>💳 Cuentas por Pagar</a> /
    <strong style="color:#5C3A1E;">Reclamos a Proveedor</strong>
</div>
<div class="page-title">⚠️ Gestión de Reclamos a Proveedor</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server"></asp:Label>
</asp:Panel>

<%-- Hidden fields globales --%>
<asp:HiddenField ID="hfId"   runat="server" Value="0" />
<asp:HiddenField ID="hfModo" runat="server" Value="nuevo" />

<%-- ══ PANEL 1: CREAR / EDITAR DESCRIPCION ══ --%>
<asp:Panel ID="pnlFormPrincipal" runat="server" Visible="true">
<div class="form-card">
    <div class="form-card-head">
        <span>✏️ <asp:Label ID="lblTituloForm" runat="server" Text="Nuevo Reclamo"></asp:Label></span>
    </div>
    <div class="form-card-body">
        <div class="f-row">
            <div class="f-group">
                <label>Orden de Compra <span style="color:#e53e3e;">*</span></label>
                <asp:DropDownList ID="ddlOrden" runat="server"
                    style="width:100%; min-width:180px; padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; box-sizing:border-box;" />
            </div>
            <div class="f-group" style="flex:2;">
                <label>Descripción del Problema <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" MaxLength="255"
                             TextMode="MultiLine" Rows="3" placeholder="Describa el problema o motivo del reclamo..." />
            </div>
        </div>
        <div class="f-row" style="margin-top:8px;">
            <div class="note-auto">
                📅 Al crear: estado inicial <strong>INICIADO</strong>, fecha de inicio = hoy.<br/>
                ✏️ En edición solo se puede cambiar la descripción.
            </div>
        </div>
        <div class="f-row" style="margin-top:16px; justify-content:flex-end;">
            <asp:Button ID="btnGuardar"  runat="server" Text="💾 Guardar"  CssClass="btn-gold"    OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="✕ Cancelar" CssClass="btn-outline" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>
</div>
</asp:Panel>

<%-- ══ PANEL 2: CAMBIAR ESTADO ══ --%>
<asp:Panel ID="pnlCambioEstado" runat="server" Visible="false">
<div class="form-card">
    <div class="form-card-head estado-head">
        <span>🔄 Cambiar Estado — Reclamo #<asp:Label ID="lblIdEstado" runat="server" /></span>
    </div>
    <div class="form-card-body">
        <div class="f-row">
            <div class="f-group">
                <label>Nuevo Estado <span style="color:#e53e3e;">*</span></label>
                <asp:DropDownList ID="ddlEstado" runat="server"
                    style="width:100%; min-width:220px; padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; box-sizing:border-box;"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlEstado_SelectedIndexChanged" />
            </div>
        </div>

        <asp:Panel ID="pnlComentariosCierre" runat="server" Visible="false">
        <div class="f-row" style="margin-top:14px;">
            <div class="f-group">
                <label>Comentarios de Resolución <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtComentariosCierre" runat="server" CssClass="form-control-green" MaxLength="255"
                             TextMode="MultiLine" Rows="3"
                             placeholder="Describa cómo se resolvió o por qué se rechazó el reclamo..." />
            </div>
        </div>
        <div class="f-row" style="margin-top:6px;">
            <div class="note-cierre">
                ✅ Al confirmar se registrará la fecha de finalización automáticamente y ya no se podrá cambiar el estado.
            </div>
        </div>
        </asp:Panel>

        <div class="f-row" style="margin-top:16px; justify-content:flex-end;">
            <asp:Button ID="btnCambiarEstado"  runat="server" Text="🔄 Aplicar Estado" CssClass="btn-blue"    OnClick="btnCambiarEstado_Click" />
            <asp:Button ID="btnCancelarEstado" runat="server" Text="✕ Cancelar"       CssClass="btn-outline" OnClick="btnCancelarEstado_Click" CausesValidation="false" />
        </div>
    </div>
</div>
</asp:Panel>

<%-- ══ PANEL 3: EDITAR COMENTARIOS (RESUELTO / RECHAZADO) ══ --%>
<asp:Panel ID="pnlEditarComentarios" runat="server" Visible="false">
<div class="form-card">
    <div class="form-card-head coment-head">
        <span>💬 Editar Comentarios — Reclamo #<asp:Label ID="lblIdComentarios" runat="server" /></span>
    </div>
    <div class="form-card-body">
        <div class="info-row">
            <strong>Orden:</strong> <asp:Label ID="lblComentOrden" runat="server" /> &nbsp;|&nbsp;
            <strong>Estado:</strong> <asp:Label ID="lblComentEstado" runat="server" /> &nbsp;|&nbsp;
            <strong>Descripción:</strong> <asp:Label ID="lblComentDescripcion" runat="server" />
        </div>
        <div class="f-row">
            <div class="f-group">
                <label>Comentarios de Resolución <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtComentariosEditar" runat="server" CssClass="form-control-green" MaxLength="255"
                             TextMode="MultiLine" Rows="4"
                             placeholder="Edita los comentarios de resolución o rechazo..." />
            </div>
        </div>
        <div class="f-row" style="margin-top:16px; justify-content:flex-end;">
            <asp:Button ID="btnGuardarComentarios"   runat="server" Text="💾 Guardar Comentarios" CssClass="btn-green"   OnClick="btnGuardarComentarios_Click" />
            <asp:Button ID="btnCancelarComentarios"  runat="server" Text="✕ Cancelar"             CssClass="btn-outline" OnClick="btnCancelarComentarios_Click" CausesValidation="false" />
        </div>
    </div>
</div>
</asp:Panel>

<%-- BARRA DE BUSQUEDA Y FILTROS --%>
<div class="search-bar">
    <div class="search-inner">
        <div style="display:flex; flex-direction:column; gap:4px; flex:3; min-width:200px;">
            <label class="flabel">Buscar</label>
            <div class="search-wrap">
                <span class="search-icon-abs">🔍</span>
                <asp:TextBox ID="txtBuscar" runat="server" placeholder="Orden de compra, descripcion o comentarios..." />
            </div>
        </div>
        <div style="display:flex; flex-direction:column; gap:4px; flex:1; min-width:160px;">
            <label class="flabel">Estado</label>
            <asp:DropDownList ID="ddlFiltroEstado" runat="server"
                style="width:100%; padding:10px 12px; border:2px solid #e8d8c0; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; background:#fdf8f3; box-sizing:border-box;" />
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
            <asp:Button ID="btnBuscar"  runat="server" Text="Buscar"  CssClass="btn-gold"    OnClick="btnBuscar_Click"  CausesValidation="false" />
            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-outline" OnClick="btnLimpiar_Click" CausesValidation="false" />
        </div>
    </div>
</div>

<div class="table-card">
    <asp:GridView ID="gvReclamos" runat="server" AutoGenerateColumns="false" CssClass="table"
                  OnRowCommand="gvReclamos_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID" ItemStyle-Width="70px">
                <ItemTemplate><span class="badge-id"><%# Eval("REP_RECLAMO_PROVEEDOR") %></span></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ORC_ORDEN_COMPRA" HeaderText="Orden Compra" />
            <asp:BoundField DataField="REP_DESCRIPCION"  HeaderText="Descripcion" />
            <asp:TemplateField HeaderText="Comentarios">
                <ItemTemplate>
                    <%# If(IsDBNull(Eval("REP_COMENTARIOS")) OrElse String.IsNullOrEmpty(Eval("REP_COMENTARIOS").ToString()),
                        "<span style='color:#aaa;font-size:12px;'>—</span>",
                        Eval("REP_COMENTARIOS").ToString()) %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Estado" ItemStyle-Width="110px">
                <ItemTemplate>
                    <span class='badge-estado estado-<%# Eval("REP_ESTADO") %>'><%# Eval("REP_ESTADO") %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="REP_FECHA_INICIO" HeaderText="Inicio" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-Width="90px" />
            <asp:TemplateField HeaderText="Fin" ItemStyle-Width="90px">
                <ItemTemplate>
                    <%# If(IsDBNull(Eval("REP_FECHA_FINAL")),
                        "<span style='color:#aaa;font-size:12px;'>—</span>",
                        Convert.ToDateTime(Eval("REP_FECHA_FINAL")).ToString("dd/MM/yyyy")) %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="260px">
                <ItemTemplate>
                    <div class="actions-cell">
                        <%-- Editar descripcion: solo INICIADO o PENDIENTE --%>
                        <asp:LinkButton CommandName="Editar"
                            CommandArgument='<%# Eval("REP_RECLAMO_PROVEEDOR") %>'
                            runat="server"
                            CssClass='<%# If(Eval("REP_ESTADO").ToString() = "RESUELTO" OrElse Eval("REP_ESTADO").ToString() = "RECHAZADO", "btn-disabled-t", "btn-edit-t") %>'
                            Enabled='<%# Eval("REP_ESTADO").ToString() <> "RESUELTO" AndAlso Eval("REP_ESTADO").ToString() <> "RECHAZADO" %>'>✏️ Desc.</asp:LinkButton>
                        <%-- Cambiar estado: solo INICIADO o PENDIENTE --%>
                        <asp:LinkButton CommandName="CambiarEstado"
                            CommandArgument='<%# Eval("REP_RECLAMO_PROVEEDOR") %>'
                            runat="server"
                            CssClass='<%# If(Eval("REP_ESTADO").ToString() = "RESUELTO" OrElse Eval("REP_ESTADO").ToString() = "RECHAZADO", "btn-disabled-t", "btn-estado-t") %>'
                            Enabled='<%# Eval("REP_ESTADO").ToString() <> "RESUELTO" AndAlso Eval("REP_ESTADO").ToString() <> "RECHAZADO" %>'>🔄 Estado</asp:LinkButton>
                        <%-- Editar comentarios: solo RESUELTO o RECHAZADO --%>
                        <asp:LinkButton CommandName="EditarComentarios"
                            CommandArgument='<%# Eval("REP_RECLAMO_PROVEEDOR") %>'
                            runat="server"
                            CssClass='<%# If(Eval("REP_ESTADO").ToString() = "RESUELTO" OrElse Eval("REP_ESTADO").ToString() = "RECHAZADO", "btn-coment-t", "btn-disabled-t") %>'
                            Enabled='<%# Eval("REP_ESTADO").ToString() = "RESUELTO" OrElse Eval("REP_ESTADO").ToString() = "RECHAZADO" %>'>💬 Coment.</asp:LinkButton>
                        <asp:LinkButton CommandName="Eliminar"
                            CommandArgument='<%# Eval("REP_RECLAMO_PROVEEDOR") %>'
                            runat="server" CssClass="btn-del-t"
                            OnClientClick="return confirm('¿Eliminar este reclamo?');">🗑</asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="empty-state"><div class="ei">⚠️</div><p>No hay reclamos registrados.</p></div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
</asp:Content>
