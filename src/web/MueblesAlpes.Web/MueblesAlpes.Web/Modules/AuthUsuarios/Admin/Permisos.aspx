<%@ Page Title="Permisos" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Permisos.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.Admin.PermisosPage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .page-title { font-size:22px; color:#5C3A1E; font-family:Georgia,serif; margin:0 0 20px; }
    .alert-ok  { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; display:block; }
    .alert-err { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; display:block; }
    .form-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; margin-bottom:24px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .form-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:14px 20px; }
    .form-card-head span { color:#f0d9a0; font-size:14px; font-weight:bold; }
    .form-card-body { padding:20px; }
    .form-row { display:grid; grid-template-columns:repeat(6,1fr); gap:12px; }
    .form-group { margin-bottom:16px; }
    .form-group label { display:block; font-size:12px; font-weight:bold; color:#5C3A1E; margin-bottom:6px; font-family:Arial,sans-serif; }
    .form-control { width:100%; padding:10px 12px; border:1px solid #e8d8c0; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; color:#333; box-sizing:border-box; }
    .form-control:focus { outline:none; border-color:#C9973A; }
    .toggle-row { display:grid; grid-template-columns:repeat(6,1fr); gap:12px; margin-bottom:20px; }
    .toggle-item { text-align:center; }
    .toggle-item label { display:block; font-size:12px; font-weight:bold; color:#5C3A1E; margin-bottom:8px; font-family:Arial,sans-serif; }
    .toggle-switch { position:relative; display:inline-block; width:48px; height:26px; }
    .toggle-switch input { opacity:0; width:0; height:0; }
    .slider { position:absolute; cursor:pointer; top:0; left:0; right:0; bottom:0; background:#e8d8c0; border-radius:26px; transition:.3s; }
    .slider:before { position:absolute; content:""; height:20px; width:20px; left:3px; bottom:3px; background:white; border-radius:50%; transition:.3s; }
    input:checked + .slider { background:#C9973A; }
    input:checked + .slider:before { transform:translateX(22px); }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; cursor:pointer; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; cursor:pointer; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); overflow-x:auto; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:14px 18px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; white-space:nowrap; text-align:center; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; }
    .table-card tbody tr:hover { background:#fdf8f3; }
    .table-card tbody td { padding:12px 18px; font-size:13px; text-align:center; }
    .badge-id { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; }
    .badge-ok { background:#f0fff4; color:#276749; padding:3px 10px; border-radius:12px; font-size:12px; font-weight:bold; }
    .badge-no { background:#fff5f5; color:#c53030; padding:3px 10px; border-radius:12px; font-size:12px; font-weight:bold; }
    .actions-cell { display:flex; gap:8px; justify-content:center; }
    .btn-edit-t { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; }
    .btn-edit-t:hover { background:#C9973A; color:white; }
    .btn-del-t { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; }
    .btn-del-t:hover { background:#e53e3e; color:white; }
    .empty-state { text-align:center; padding:40px; color:#aaa; }
    .hint-box { background:#fdf6ec; border:1px solid #e8d8c0; border-radius:8px; padding:12px 16px; margin-bottom:20px; font-size:12px; color:#8B5E3C; font-family:Arial,sans-serif; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Index.aspx") %>'>🏠 Auth & Usuarios</a> /
    <strong style="color:#5C3A1E;">Permisos</strong>
</div>

<div class="page-title">⚙️ Gestión de Permisos</div>

<asp:Label ID="lblMensaje" runat="server" CssClass="alert-ok"  Visible="false" />
<asp:Label ID="lblError"   runat="server" CssClass="alert-err" Visible="false" />

<div class="hint-box">
    💡 Cada permiso define qué módulos puede acceder un grupo. <strong>1 = Acceso permitido</strong>, <strong>0 = Acceso negado</strong>.
    Luego asigna este permiso a un Grupo en <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Admin/GrupoUsuario.aspx") %>'>Gestión de Grupos</a>.
</div>

<div class="form-card">
    <div class="form-card-head"><span>🔧 Nuevo / Editar Permiso</span></div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfId" runat="server" />

        <div class="toggle-row">
            <div class="toggle-item">
                <label>👑 Admin</label>
                <label class="toggle-switch">
                    <asp:CheckBox ID="chkAdmin" runat="server" />
                    <span class="slider"></span>
                </label>
            </div>
            <div class="toggle-item">
                <label>👥 RH</label>
                <label class="toggle-switch">
                    <asp:CheckBox ID="chkRH" runat="server" />
                    <span class="slider"></span>
                </label>
            </div>
            <div class="toggle-item">
                <label>🧾 Facturación</label>
                <label class="toggle-switch">
                    <asp:CheckBox ID="chkFac" runat="server" />
                    <span class="slider"></span>
                </label>
            </div>
            <div class="toggle-item">
                <label>🛒 Clientes</label>
                <label class="toggle-switch">
                    <asp:CheckBox ID="chkCli" runat="server" />
                    <span class="slider"></span>
                </label>
            </div>
            <div class="toggle-item">
                <label>📦 Bodega</label>
                <label class="toggle-switch">
                    <asp:CheckBox ID="chkBod" runat="server" />
                    <span class="slider"></span>
                </label>
            </div>
            <div class="toggle-item">
                <label>🎁 Promociones</label>
                <label class="toggle-switch">
                    <asp:CheckBox ID="chkPromo" runat="server" />
                    <span class="slider"></span>
                </label>
            </div>
        </div>

        <div style="display:flex; gap:10px;">
            <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar"
                CssClass="btn-gold tiempoInhabilitado" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnNuevo" runat="server" Text="🆕 Nuevo"
                CssClass="btn-outline tiempoInhabilitado" OnClick="btnNuevo_Click" />
        </div>
    </div>
</div>

<div class="table-card">
    <asp:GridView ID="gvPermisos" runat="server" AutoGenerateColumns="false"
        OnRowCommand="gvPermisos_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID" ItemStyle-Width="60px">
                <ItemTemplate>
                    <span class="badge-id"><%# Eval("per_permisos") %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="👑 Admin">
                <ItemTemplate>
                    <%# If(Eval("per_admin").ToString()="1","<span class='badge-ok'>✓ Sí</span>","<span class='badge-no'>✗ No</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="👥 RH">
                <ItemTemplate>
                    <%# If(Eval("per_rh").ToString()="1","<span class='badge-ok'>✓ Sí</span>","<span class='badge-no'>✗ No</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="🧾 Facturación">
                <ItemTemplate>
                    <%# If(Eval("per_fac").ToString()="1","<span class='badge-ok'>✓ Sí</span>","<span class='badge-no'>✗ No</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="🛒 Clientes">
                <ItemTemplate>
                    <%# If(Eval("per_cli").ToString()="1","<span class='badge-ok'>✓ Sí</span>","<span class='badge-no'>✗ No</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="📦 Bodega">
                <ItemTemplate>
                    <%# If(Eval("per_bod").ToString()="1","<span class='badge-ok'>✓ Sí</span>","<span class='badge-no'>✗ No</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="🎁 Promociones">
                <ItemTemplate>
                    <%# If(Eval("per_promo").ToString()="1","<span class='badge-ok'>✓ Sí</span>","<span class='badge-no'>✗ No</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <div class="actions-cell">
                        <asp:LinkButton runat="server" Text="✏️" CommandName="Editar"
                            CommandArgument='<%# Eval("per_permisos") %>' CssClass="btn-edit-t tiempoInhabilitado" />
                        <asp:LinkButton runat="server" Text="🗑" CommandName="Eliminar"
                            CommandArgument='<%# Eval("per_permisos") %>' CssClass="btn-del-t tiempoInhabilitado"
                            OnClientClick="return confirm('¿Eliminar este permiso?');" />
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="empty-state">
                <div style="font-size:40px;">⚙️</div>
                <p>No hay permisos registrados.</p>
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
</asp:Content>