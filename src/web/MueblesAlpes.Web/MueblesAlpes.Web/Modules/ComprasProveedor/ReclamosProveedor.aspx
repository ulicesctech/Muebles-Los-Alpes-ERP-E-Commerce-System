<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="ReclamosProveedor.aspx.vb" Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.ReclamosProveedor" MasterPageFile="~/Site.Master" ResponseEncoding="utf-8" ContentType="text/html; charset=UTF-8" %>
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
    .form-card-head.estado-head { background:linear-gradient(135deg,#2b6cb0,#2c5282); }
    .form-card-body { padding:20px; }
    .f-row { display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; }
    .f-group { display:flex; flex-direction:column; gap:6px; flex:1; min-width:200px; }
    .f-group label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .f-group .form-control { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; width:100%; outline:none; }
    .f-group .form-control:focus { border-color:#C9973A; background:white; }
    .note-auto { font-size:11px; color:#888; font-style:italic; margin-top:4px; }
    .note-cierre { font-size:11px; color:#c05621; font-weight:bold; margin-top:4px; }
    .btn-gold    { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-blue    { background:linear-gradient(135deg,#3182ce,#2b6cb0); color:white; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-blue:hover { background:linear-gradient(135deg,#2b6cb0,#1e4e8c); color:white; }
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
    .badge-id { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; display:inline-block; }
    /* Badges de estado */
    .estado-INICIADO   { background:#ebf8ff; color:#2b6cb0; border:1px solid #bee3f8; }
    .estado-PENDIENTE  { background:#fffbeb; color:#b7791f; border:1px solid #fef3c7; }
    .estado-FINALIZADO { background:#f0fff4; color:#276749; border:1px solid #c6f6d5; }
    .estado-RESUELTO   { background:#f0fff4; color:#276749; border:1px solid #c6f6d5; }
    .estado-RECHAZADO  { background:#fff5f5; color:#c53030; border:1px solid #fed7d7; }
    .badge-estado { padding:4px 12px; border-radius:20px; font-size:11px; font-weight:bold; display:inline-block; }
    .actions-cell { display:flex; gap:6px; align-items:center; justify-content:flex-end; flex-wrap:wrap; }
    .btn-edit-t   { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-edit-t:hover { background:#C9973A; color:white !important; border-color:#C9973A; text-decoration:none; }
    .btn-estado-t { background:#ebf8ff; color:#2b6cb0; border:1px solid #bee3f8; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-estado-t:hover { background:#2b6cb0; color:white !important; border-color:#2b6cb0; text-decoration:none; }
    .btn-del-t    { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-del-t:hover { background:#e53e3e; color:white !important; border-color:#e53e3e; text-decoration:none; }
    .empty-state { text-align:center; padding:50px 20px; color:#aaa; font-family:Arial,sans-serif; }
    .empty-state .ei { font-size:48px; margin-bottom:10px; }
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

<%-- ══════════════════════════════════════════
     PANEL 1: Crear / Editar comentarios
     ══════════════════════════════════════════ --%>
<div class="form-card">
    <div class="form-card-head">
        <span>✏️ <asp:Label ID="lblTituloForm" runat="server" Text="Nuevo Reclamo"></asp:Label></span>
    </div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfId"   runat="server" Value="0" />
        <asp:HiddenField ID="hfModo" runat="server" Value="nuevo" />

        <div class="f-row">
            <div class="f-group">
                <label>Orden de Compra <span style="color:#e53e3e;">*</span></label>
                <asp:DropDownList ID="ddlOrden" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div class="f-group" style="flex:2;">
                <label>Comentarios <span style="color:#e53e3e;">*</span></label>
                <asp:TextBox ID="txtComentarios" runat="server" CssClass="form-control" MaxLength="500"
                             TextMode="MultiLine" Rows="3" placeholder="Describa el motivo del reclamo..."></asp:TextBox>
            </div>
        </div>
        <div class="f-row" style="margin-top:8px;">
            <div class="note-auto">
                📅 Al crear: estado inicial <strong>INICIADO</strong>, fecha de inicio = hoy, fecha final = vacía.<br/>
                ✏️ En edición: solo se pueden cambiar los comentarios (use el botón 🔄 Estado para cambiar el flujo).
            </div>
        </div>
        <div class="f-row" style="margin-top:16px; justify-content:flex-end;">
            <asp:Button ID="btnGuardar"  runat="server" Text="💾 Guardar"  CssClass="btn-gold"    OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="✕ Cancelar" CssClass="btn-outline" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>
</div>

<%-- ══════════════════════════════════════════
     PANEL 2: Cambio de Estado (solo en edición)
     ══════════════════════════════════════════ --%>
<asp:Panel ID="pnlCambioEstado" runat="server" Visible="false">
    <div class="form-card">
        <div class="form-card-head estado-head">
            <span>🔄 Cambiar Estado del Reclamo #<asp:Label ID="lblIdEstado" runat="server"></asp:Label></span>
        </div>
        <div class="form-card-body">
            <div class="f-row">
                <div class="f-group">
                    <label>Nuevo Estado <span style="color:#e53e3e;">*</span></label>
                    <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-control">
                        <asp:ListItem Value="INICIADO"   Text="INICIADO" />
                        <asp:ListItem Value="PENDIENTE"  Text="PENDIENTE" />
                        <asp:ListItem Value="FINALIZADO" Text="FINALIZADO — registra fecha final automáticamente" />
                        <asp:ListItem Value="RESUELTO"   Text="RESUELTO — registra fecha final automáticamente" />
                        <asp:ListItem Value="RECHAZADO"  Text="RECHAZADO — registra fecha final automáticamente" />
                    </asp:DropDownList>
                </div>
            </div>
            <div class="f-row" style="margin-top:8px;">
                <div class="note-cierre">
                    ⚡ Estados de cierre (FINALIZADO / RESUELTO / RECHAZADO): asignan la fecha final automáticamente.<br/>
                    Estados abiertos (INICIADO / PENDIENTE): dejan la fecha final vacía.
                </div>
            </div>
            <div class="f-row" style="margin-top:16px; justify-content:flex-end;">
                <asp:Button ID="btnCambiarEstado" runat="server" Text="🔄 Aplicar Estado" CssClass="btn-blue" OnClick="btnCambiarEstado_Click" />
            </div>
        </div>
    </div>
</asp:Panel>

<div class="search-bar">
    <div class="search-wrap">
        <span class="search-icon-abs">🔍</span>
        <asp:TextBox ID="txtBuscar" runat="server" placeholder="Buscar reclamos..."></asp:TextBox>
    </div>
    <asp:Button ID="btnBuscar"  runat="server" Text="Buscar"  CssClass="btn-gold"    OnClick="btnBuscar_Click"  CausesValidation="false" />
    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-outline" OnClick="btnLimpiar_Click" CausesValidation="false" />
</div>

<div class="table-card">
    <asp:GridView ID="gvReclamos" runat="server" AutoGenerateColumns="false" CssClass="table"
                  OnRowCommand="gvReclamos_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID" ItemStyle-Width="70px">
                <ItemTemplate><span class="badge-id"><%# Eval("REP_RECLAMO_PROVEEDOR") %></span></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ORC_ORDEN_COMPRA" HeaderText="Orden Compra" />
            <asp:BoundField DataField="REP_COMENTARIOS"  HeaderText="Comentarios" />
            <asp:TemplateField HeaderText="Estado">
                <ItemTemplate>
                    <span class='badge-estado estado-<%# Eval("REP_ESTADO") %>'><%# Eval("REP_ESTADO") %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="REP_FECHA_INICIO" HeaderText="Inicio"      DataFormatString="{0:dd/MM/yyyy}" />
            <asp:TemplateField HeaderText="Fin">
                <ItemTemplate>
                    <%# If(IsDBNull(Eval("REP_FECHA_FINAL")), "<span style='color:#aaa;font-size:12px;'>—</span>", Convert.ToDateTime(Eval("REP_FECHA_FINAL")).ToString("dd/MM/yyyy")) %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="220px">
                <ItemTemplate>
                    <div class="actions-cell">
                        <asp:LinkButton CommandName="Editar"       CommandArgument='<%# Eval("REP_RECLAMO_PROVEEDOR") %>' runat="server" CssClass="btn-edit-t">✏️ Editar</asp:LinkButton>
                        <asp:LinkButton CommandName="CambiarEstado" CommandArgument='<%# Eval("REP_RECLAMO_PROVEEDOR") %>' runat="server" CssClass="btn-estado-t">🔄 Estado</asp:LinkButton>
                        <asp:LinkButton CommandName="Eliminar"     CommandArgument='<%# Eval("REP_RECLAMO_PROVEEDOR") %>' runat="server" CssClass="btn-del-t" OnClientClick="return confirm('¿Eliminar este reclamo?');">🗑</asp:LinkButton>
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