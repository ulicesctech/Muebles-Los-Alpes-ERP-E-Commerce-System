<%@ Page Title="Login Empleado" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="LoginEmpleado.aspx.vb" 
    Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.LoginEmpleado" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .page-title { font-size:22px; color:#5C3A1E; font-family:Georgia,serif; margin:0 0 20px; }
    .alert-ok  { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; }
    .alert-err { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; }
    .form-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; margin-bottom:24px; box-shadow:0 2px 8px rgba(92,58,30,0.06); max-width:500px; margin-left:auto; margin-right:auto; }
    .form-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:14px 20px; }
    .form-card-head span { color:#f0d9a0; font-size:14px; font-weight:bold; }
    .form-card-body { padding:24px; }
    .form-group { margin-bottom:16px; }
    .form-group label { display:block; font-size:13px; font-weight:bold; color:#5C3A1E; margin-bottom:6px; font-family:Arial,sans-serif; }
    .form-control { width:100%; padding:10px 12px; border:1px solid #e8d8c0; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; color:#333; box-sizing:border-box; }
    .form-control:focus { outline:none; border-color:#C9973A; }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:12px; border-radius:8px; font-size:14px; font-weight:bold; cursor:pointer; width:100%; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); margin-top:30px; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:14px 18px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; }
    .table-card tbody tr:hover { background:#fdf8f3; }
    .table-card tbody td { padding:14px 18px; font-size:13px; }
    .badge-id { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; }
    .actions-cell { display:flex; gap:8px; justify-content:flex-end; }
    .btn-del-t { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; }
    .btn-del-t:hover { background:#e53e3e; color:white; }
    .empty-state { text-align:center; padding:40px; color:#aaa; }
    .tabs { display:flex; gap:10px; margin-bottom:24px; }
    .tab-btn { padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; cursor:pointer; border:2px solid #e8d8c0; background:white; color:#5C3A1E; font-family:Arial,sans-serif; }
    .tab-btn.active { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); color:#f0d9a0; border-color:transparent; }
    .tab-panel { display:none; }
    .tab-panel.active { display:block; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>🏠 Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Default.aspx") %>'>🔐 Auth</a> /
    <strong style="color:#5C3A1E;">Login Empleado</strong>
</div>

<div class="page-title">👨‍💼 Gestión de Login Empleados</div>

<asp:Label ID="lblMensaje" runat="server" CssClass="alert-ok"  Visible="false" />
<asp:Label ID="lblError"   runat="server" CssClass="alert-err" Visible="false" />

<!-- TABS -->
<div class="tabs">
    <button class="tab-btn active" onclick="showTab('tabCrear', this)">➕ Crear Login</button>
    <button class="tab-btn"        onclick="showTab('tabActPass', this)">🔑 Cambiar Password</button>
    <button class="tab-btn"        onclick="showTab('tabActUsr', this)">✏️ Cambiar Usuario</button>
    <button class="tab-btn"        onclick="showTab('tabValidar', this)">🔒 Validar Login</button>
</div>

<!-- TAB: CREAR -->
<div id="tabCrear" class="tab-panel active">
    <div class="form-card">
        <div class="form-card-head"><span>➕ Crear Login de Empleado</span></div>
        <div class="form-card-body">
            <div class="form-group">
                <label>ID Empleado</label>
                <asp:TextBox ID="txtCrearId" runat="server" CssClass="form-control" placeholder="ID del empleado..." />
            </div>
            <div class="form-group">
                <label>Usuario</label>
                <asp:TextBox ID="txtCrearUsuario" runat="server" CssClass="form-control" placeholder="Nombre de usuario..." />
            </div>
            <div class="form-group">
                <label>Password</label>
                <asp:TextBox ID="txtCrearPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password..." />
            </div>
            <asp:Button ID="btnCrear" runat="server" Text="💾 Crear Login"
                CssClass="btn-gold" OnClick="btnCrear_Click" />
        </div>
    </div>
</div>

<!-- TAB: CAMBIAR PASSWORD -->
<div id="tabActPass" class="tab-panel">
    <div class="form-card">
        <div class="form-card-head"><span>🔑 Cambiar Password</span></div>
        <div class="form-card-body">
            <div class="form-group">
                <label>ID Empleado</label>
                <asp:TextBox ID="txtPassId" runat="server" CssClass="form-control" placeholder="ID del empleado..." />
            </div>
            <div class="form-group">
                <label>Nuevo Password</label>
                <asp:TextBox ID="txtNuevoPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Nuevo password..." />
            </div>
            <asp:Button ID="btnActPass" runat="server" Text="🔑 Actualizar Password"
                CssClass="btn-gold" OnClick="btnActPass_Click" />
        </div>
    </div>
</div>

<!-- TAB: CAMBIAR USUARIO -->
<div id="tabActUsr" class="tab-panel">
    <div class="form-card">
        <div class="form-card-head"><span>✏️ Cambiar Usuario</span></div>
        <div class="form-card-body">
            <div class="form-group">
                <label>ID Empleado</label>
                <asp:TextBox ID="txtUsrId" runat="server" CssClass="form-control" placeholder="ID del empleado..." />
            </div>
            <div class="form-group">
                <label>Nuevo Usuario</label>
                <asp:TextBox ID="txtNuevoUsr" runat="server" CssClass="form-control" placeholder="Nuevo usuario..." />
            </div>
            <asp:Button ID="btnActUsr" runat="server" Text="✏️ Actualizar Usuario"
                CssClass="btn-gold" OnClick="btnActUsr_Click" />
        </div>
    </div>
</div>

<!-- TAB: VALIDAR -->
<div id="tabValidar" class="tab-panel">
    <div class="form-card">
        <div class="form-card-head"><span>🔒 Validar Credenciales</span></div>
        <div class="form-card-body">
            <div class="form-group">
                <label>Usuario</label>
                <asp:TextBox ID="txtValUsr" runat="server" CssClass="form-control" placeholder="Usuario..." />
            </div>
            <div class="form-group">
                <label>Password</label>
                <asp:TextBox ID="txtValPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password..." />
            </div>
            <asp:Button ID="btnValidar" runat="server" Text="🔒 Validar"
                CssClass="btn-gold" OnClick="btnValidar_Click" />
        </div>
    </div>
</div>

<!-- GRID -->
<div class="table-card">
    <asp:GridView ID="gvLogins" runat="server" AutoGenerateColumns="false"
        OnRowCommand="gvLogins_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID" ItemStyle-Width="80px">
                <ItemTemplate>
                    <span class="badge-id"><%# Eval("em_empleado") %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="logem_usuario"       HeaderText="Usuario" />
            <asp:BoundField DataField="em_nombre_completo"  HeaderText="Nombre" />
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <div class="actions-cell">
                        <asp:LinkButton runat="server" Text="🗑"
                            CommandName="Eliminar"
                            CommandArgument='<%# Eval("em_empleado") %>'
                            CssClass="btn-del-t"
                            OnClientClick="return confirm('¿Eliminar este login?');" />
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="empty-state">
                <div style="font-size:40px;">👨‍💼</div>
                <p>No hay logins de empleados registrados.</p>
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>

<script>
    function showTab(tabId, btn) {
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.getElementById(tabId).classList.add('active');
        btn.classList.add('active');
    }
</script>

</asp:Content>