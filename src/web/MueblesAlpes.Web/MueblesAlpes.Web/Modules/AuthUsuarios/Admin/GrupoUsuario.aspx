<%@ Page Title="Grupos de Usuario" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="GrupoUsuario.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.Admin.GrupoUsuarioPage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .page-title { font-size:22px; color:#5C3A1E; font-family:Georgia,serif; margin:0 0 20px; }
    .alert-ok  { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; display:block; }
    .alert-err { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; display:block; }
    .form-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; margin-bottom:24px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .form-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:14px 20px; display:flex; justify-content:space-between; align-items:center; cursor:pointer; user-select:none; }
    .form-card-head span { color:#f0d9a0; font-size:14px; font-weight:bold; }
    .form-card-head .toggle-icon { color:#f0d9a0; font-size:18px; }
    .form-card-body { padding:20px; display:none; }
    .form-card-body.open { display:block; }
    .form-card-body.editing .form-control { border-color:#7c3aed; background:#faf5ff; }
    .form-card-body.editing label { color:#7c3aed; }
    .form-card-body.editing .section-title { color:#7c3aed; border-color:#7c3aed; }
    .form-row { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
    .form-group { margin-bottom:16px; }
    .form-group label { display:block; font-size:13px; font-weight:bold; color:#5C3A1E; margin-bottom:6px; font-family:Arial,sans-serif; transition:color 0.2s; }
    .form-control { width:100%; padding:10px 12px; border:1px solid #e8d8c0; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; color:#333; box-sizing:border-box; transition:border-color 0.2s, background 0.2s; }
    .form-control:focus { outline:none; border-color:#C9973A; }
    .section-title { font-size:13px; font-weight:bold; color:#8B5E3C; font-family:Arial,sans-serif; margin:16px 0 10px; padding-bottom:6px; border-bottom:1px solid #e8d8c0; transition:color 0.2s; }
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
    .table-wrap { overflow-x:auto; }
    .table-wrap table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .gv-table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .gv-table thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .gv-table thead th { padding:14px 18px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; white-space:nowrap; text-align:center; }
    .gv-table tbody tr { border-bottom:1px solid #f5ece0; }
    .gv-table tbody tr:hover { background:#fdf8f3; }
    .gv-table tbody td { padding:12px 18px; font-size:13px; text-align:center; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); margin-bottom:24px; overflow-x:auto; }
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
    .btn-usar-t { background:#ebf8ff; color:#2b6cb0; border:1px solid #bee3f8; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; }
    .btn-usar-t:hover { background:#2b6cb0; color:white; }
    .btn-del-t { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; }
    .btn-del-t:hover { background:#e53e3e; color:white; }
    .empty-state { text-align:center; padding:40px; color:#aaa; }
    .editing-badge { background:#ede9fe; color:#7c3aed; border:1px solid #c4b5fd; border-radius:8px; padding:8px 14px; font-size:12px; font-family:Arial,sans-serif; margin-bottom:16px; display:flex; align-items:center; gap:8px; }
    .arrow-link { text-align:center; padding:16px; background:#fdf6ec; border:1px dashed #C9973A; border-radius:8px; margin-bottom:24px; font-family:Arial,sans-serif; font-size:13px; color:#8B5E3C; }
    .permiso-preview { background:#fdf8f3; border:1px solid #e8d8c0; border-radius:8px; padding:12px 16px; margin-bottom:16px; font-size:12px; font-family:Arial,sans-serif; color:#5C3A1E; display:none; }
    .permiso-preview.visible { display:block; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Index.aspx") %>'>🏠 Auth & Usuarios</a> /
    <strong style="color:#5C3A1E;">Permisos & Grupos</strong>
</div>

<div class="page-title">⚙️ Gestión de Permisos & Grupos</div>

<asp:Label ID="lblMensaje" runat="server" CssClass="alert-ok"  Visible="false" />
<asp:Label ID="lblError"   runat="server" CssClass="alert-err" Visible="false" />

<%-- ===== PASO 1: CREAR PERMISO ===== --%>
<div class="form-card">
    <div class="form-card-head" id="formCardHeadPermiso" onclick="toggleForm('Permiso')">
        <span id="formCardTitlePermiso">➕ Paso 1: Crear Permiso — clic para desplegar</span>
        <span class="toggle-icon" id="toggleIconPermiso">+</span>
    </div>
    <div class="form-card-body" id="formCardBodyPermiso">
        <asp:HiddenField ID="hfPermisoId" runat="server" />

        <div id="editingBadgePermiso" style="display:none;" class="editing-badge">
            ✏️ <strong>Modo edición</strong> — Modifica los toggles y guarda.
        </div>

        <div class="section-title">🔐 Módulos con acceso</div>
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
            <asp:Button ID="btnGuardarPermiso" runat="server" Text="💾 Guardar Permiso"
                CssClass="btn-gold" OnClick="btnGuardarPermiso_Click" />
            <asp:Button ID="btnNuevoPermiso" runat="server" Text="❌ Cancelar"
                CssClass="btn-outline" OnClick="btnNuevoPermiso_Click" />
        </div>
    </div>
</div>

<%-- ===== TABLA PERMISOS DESPLEGABLE ===== --%>
<div class="form-card">
    <div class="form-card-head" id="formCardHeadTablaPermisos" onclick="toggleTablaPermisos()">
        <span>📋 Ver Permisos Registrados — clic para desplegar</span>
        <span class="toggle-icon" id="toggleIconTablaPermisos">+</span>
    </div>
    <div id="formCardBodyTablaPermisos" style="display:none; overflow-x:auto; padding:0;">
        <asp:GridView ID="gvPermisos" runat="server" AutoGenerateColumns="false"
            OnRowCommand="gvPermisos_RowCommand" GridLines="None"
            CssClass="gv-table">
            <HeaderStyle CssClass="gv-thead" />
            <Columns>
                <asp:TemplateField HeaderText="ID">
                    <ItemTemplate>
                        <span class="badge-id"><%# Eval("per_permisos") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="👑 Admin">
                    <ItemTemplate>
                        <%# If(Eval("per_admin").ToString()="1","<span class='badge-ok'>✓</span>","<span class='badge-no'>✗</span>") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="👥 RH">
                    <ItemTemplate>
                        <%# If(Eval("per_rh").ToString()="1","<span class='badge-ok'>✓</span>","<span class='badge-no'>✗</span>") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="🧾 Fac">
                    <ItemTemplate>
                        <%# If(Eval("per_fac").ToString()="1","<span class='badge-ok'>✓</span>","<span class='badge-no'>✗</span>") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="🛒 Cli">
                    <ItemTemplate>
                        <%# If(Eval("per_cli").ToString()="1","<span class='badge-ok'>✓</span>","<span class='badge-no'>✗</span>") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="📦 Bod">
                    <ItemTemplate>
                        <%# If(Eval("per_bod").ToString()="1","<span class='badge-ok'>✓</span>","<span class='badge-no'>✗</span>") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="🎁 Promo">
                    <ItemTemplate>
                        <%# If(Eval("per_promo").ToString()="1","<span class='badge-ok'>✓</span>","<span class='badge-no'>✗</span>") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Acciones">
                    <ItemTemplate>
                        <div class="actions-cell">
                            <asp:LinkButton runat="server" Text="✏️" CommandName="EditarPermiso"
                                CommandArgument='<%# Eval("per_permisos") %>' CssClass="btn-edit-t" />
                            <asp:LinkButton runat="server" Text="👥 Usar" CommandName="UsarPermiso"
                                CommandArgument='<%# Eval("per_permisos") %>' CssClass="btn-usar-t" />
                            <asp:LinkButton runat="server" Text="🗑" CommandName="EliminarPermiso"
                                CommandArgument='<%# Eval("per_permisos") %>' CssClass="btn-del-t"
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
</div>

<%-- FLECHA --%>
<div class="arrow-link">
    ⬇️ Selecciona un permiso con <strong>👥 Usar</strong> para asignarlo al grupo de usuario
</div>

<%-- ===== PASO 2: CREAR GRUPO ===== --%>
<div class="form-card">
    <div class="form-card-head" id="formCardHeadGrupo" onclick="toggleForm('Grupo')">
        <span id="formCardTitleGrupo">➕ Paso 2: Crear Grupo de Usuario — clic para desplegar</span>
        <span class="toggle-icon" id="toggleIconGrupo">+</span>
    </div>
    <div class="form-card-body" id="formCardBodyGrupo">
        <asp:HiddenField ID="hfGrupoId" runat="server" />

        <div id="editingBadgeGrupo" style="display:none;" class="editing-badge">
            ✏️ <strong>Modo edición</strong> — Modifica los datos y guarda.
        </div>

        <div id="permisoPreview" class="permiso-preview">
            📋 Permiso seleccionado: <strong id="permisoPreviewText"></strong>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>📝 Descripción del Grupo *</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control"
                    placeholder="Ej: Encargado de Ventas..." autocomplete="off" />
            </div>
            <div class="form-group">
                <label>🔐 Permiso Asignado *</label>
                <asp:DropDownList ID="ddlPermisos" runat="server" CssClass="form-control"
                    onchange="onPermisoChange(this)" />
            </div>
        </div>

        <div style="display:flex; gap:10px;">
            <asp:Button ID="btnGuardarGrupo" runat="server" Text="💾 Guardar Grupo"
                CssClass="btn-gold" OnClick="btnGuardarGrupo_Click" />
            <asp:Button ID="btnNuevoGrupo" runat="server" Text="❌ Cancelar"
                CssClass="btn-outline" OnClick="btnNuevoGrupo_Click" />
        </div>
    </div>
</div>

<%-- TABLA GRUPOS --%>
<div class="table-card">
    <asp:GridView ID="gvGrupos" runat="server" AutoGenerateColumns="false"
        OnRowCommand="gvGrupos_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID">
                <ItemTemplate>
                    <span class="badge-id"><%# Eval("grupus_grupo_usuario") %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="grupus_descripcion" HeaderText="Grupo" />
            <asp:BoundField DataField="per_permisos"       HeaderText="Permiso ID" />
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <div class="actions-cell">
                        <asp:LinkButton runat="server" Text="✏️" CommandName="EditarGrupo"
                            CommandArgument='<%# Eval("grupus_grupo_usuario") %>' CssClass="btn-edit-t" />
                        <asp:LinkButton runat="server" Text="🗑" CommandName="EliminarGrupo"
                            CommandArgument='<%# Eval("grupus_grupo_usuario") %>' CssClass="btn-del-t"
                            OnClientClick="return confirm('¿Eliminar este grupo?');" />
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="empty-state">
                <div style="font-size:40px;">👥</div>
                <p>No hay grupos registrados.</p>
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>

<asp:HiddenField ID="hfPermisoFormOpen"     runat="server" Value="false" />
<asp:HiddenField ID="hfPermisoEditing"      runat="server" Value="false" />
<asp:HiddenField ID="hfGrupoFormOpen"       runat="server" Value="false" />
<asp:HiddenField ID="hfGrupoEditing"        runat="server" Value="false" />
<asp:HiddenField ID="hfPermisoSeleccionado" runat="server" Value="" />

<script>
    function toggleForm(which) {
        var body = document.getElementById('formCardBody' + which);
        var icon = document.getElementById('toggleIcon'   + which);
        var hf   = document.getElementById(which === 'Permiso'
                        ? '<%: hfPermisoFormOpen.ClientID %>'
                        : '<%: hfGrupoFormOpen.ClientID %>');
        if (body.classList.contains('open')) {
            body.classList.remove('open');
            icon.textContent = '+';
            hf.value = 'false';
        } else {
            body.classList.add('open');
            icon.textContent = '×';
            hf.value = 'true';
        }
    }

    function toggleTablaPermisos() {
        var body = document.getElementById('formCardBodyTablaPermisos');
        var icon = document.getElementById('toggleIconTablaPermisos');
        if (body.style.display === 'none' || body.style.display === '') {
            body.style.display = 'block';
            icon.textContent = '×';
        } else {
            body.style.display = 'none';
            icon.textContent = '+';
        }
    }

    function onPermisoChange(sel) {
        var preview     = document.getElementById('permisoPreview');
        var previewText = document.getElementById('permisoPreviewText');
        if (sel.value && sel.value !== '0') {
            preview.classList.add('visible');
            previewText.textContent = 'ID ' + sel.value + ' — ' + sel.options[sel.selectedIndex].text;
        } else {
            preview.classList.remove('visible');
        }
    }

    window.onload = function () {
        var configs = [
            {
                formOpen : '<%: hfPermisoFormOpen.ClientID %>',
                editing  : '<%: hfPermisoEditing.ClientID %>',
                body     : 'formCardBodyPermiso',
                icon     : 'toggleIconPermiso',
                title    : 'formCardTitlePermiso',
                badge    : 'editingBadgePermiso',
                editLabel: '✏️ Editando Permiso'
            },
            {
                formOpen : '<%: hfGrupoFormOpen.ClientID %>',
                editing  : '<%: hfGrupoEditing.ClientID %>',
                body     : 'formCardBodyGrupo',
                icon     : 'toggleIconGrupo',
                title    : 'formCardTitleGrupo',
                badge    : 'editingBadgeGrupo',
                editLabel: '✏️ Editando Grupo'
            }
        ];

        configs.forEach(function(c) {
            var hfOpen = document.getElementById(c.formOpen);
            var hfEdit = document.getElementById(c.editing);
            var body   = document.getElementById(c.body);
            var icon   = document.getElementById(c.icon);
            var title  = document.getElementById(c.title);
            var badge  = document.getElementById(c.badge);

            if (hfOpen && hfOpen.value === 'true') {
                body.classList.add('open');
                icon.textContent = '×';
            }
            if (hfEdit && hfEdit.value === 'true') {
                body.classList.add('editing');
                if (badge) badge.style.display = 'flex';
                if (title) title.textContent = c.editLabel;
                icon.textContent = '×';
            }
        });

        var hfSel = document.getElementById('<%: hfPermisoSeleccionado.ClientID %>');
        var ddl   = document.getElementById('<%: ddlPermisos.ClientID %>');
        if (hfSel && hfSel.value !== '' && ddl) {
            ddl.value = hfSel.value;
            onPermisoChange(ddl);
        }
    };
</script>
</asp:Content>