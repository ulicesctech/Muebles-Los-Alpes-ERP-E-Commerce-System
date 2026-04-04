<%@ Page Title="Empleados" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Empleados.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.EmpleadosPage" %>

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
    .form-row { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
    .form-row-3 { display:grid; grid-template-columns:1fr 1fr 1fr; gap:16px; }
    .form-group { margin-bottom:16px; }
    .form-group label { display:block; font-size:13px; font-weight:bold; color:#5C3A1E; margin-bottom:6px; font-family:Arial,sans-serif; }
    .form-control { width:100%; padding:10px 12px; border:1px solid #e8d8c0; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; color:#333; box-sizing:border-box; }
    .form-control:focus { outline:none; border-color:#C9973A; }
    .section-title { font-size:13px; font-weight:bold; color:#8B5E3C; font-family:Arial,sans-serif; margin:16px 0 10px; padding-bottom:6px; border-bottom:1px solid #e8d8c0; }
    .hint-text { font-size:11px; color:#aaa; font-family:Arial,sans-serif; margin-top:3px; }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; cursor:pointer; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; cursor:pointer; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .search-bar { background:white; border-radius:12px; border:1px solid #e8d8c0; padding:16px 20px; margin-bottom:20px; box-shadow:0 2px 8px rgba(92,58,30,0.06); display:flex; gap:10px; align-items:flex-end; flex-wrap:wrap; }
    .search-bar .form-group { margin-bottom:0; flex:1; min-width:200px; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); overflow-x:auto; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:14px 18px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; white-space:nowrap; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; }
    .table-card tbody tr:hover { background:#fdf8f3; }
    .table-card tbody td { padding:14px 18px; font-size:13px; white-space:nowrap; }
    .badge-id { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; }
    .actions-cell { display:flex; gap:8px; justify-content:flex-end; }
    .btn-edit-t { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; }
    .btn-edit-t:hover { background:#C9973A; color:white; }
    .btn-del-t { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; }
    .btn-del-t:hover { background:#e53e3e; color:white; }
    .empty-state { text-align:center; padding:40px; color:#aaa; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Index.aspx") %>'>🏠 Auth & Usuarios</a> /
    <strong style="color:#5C3A1E;">Empleados</strong>
</div>

<div class="page-title">👨‍💼 Gestión de Empleados</div>

<asp:Label ID="lblMensaje" runat="server" CssClass="alert-ok"  Visible="false" />
<asp:Label ID="lblError"   runat="server" CssClass="alert-err" Visible="false" />

<div class="form-card">
    <div class="form-card-head"><span>🔧 Nuevo / Editar Empleado</span></div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfId" runat="server" />

        <div class="section-title">👤 Datos Personales</div>
        <div class="form-row">
            <div class="form-group">
                <label>DPI * <small style="color:#888;">(13 dígitos)</small></label>
                <asp:TextBox ID="txtDPI" runat="server" CssClass="form-control" placeholder="Ej: 1234567890101" MaxLength="13" />
                <span class="hint-text">📌 Será el password del empleado</span>
            </div>
            <div class="form-group">
                <label>Rol / Grupo *</label>
                <asp:DropDownList ID="ddlRol" runat="server" CssClass="form-control" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group">
                <label>Primer Nombre * <small style="color:#888;">(será su usuario)</small></label>
                <asp:TextBox ID="txtPrimerNombre" runat="server" CssClass="form-control" placeholder="Primer nombre..." />
            </div>
            <div class="form-group">
                <label>Segundo Nombre</label>
                <asp:TextBox ID="txtSegundoNombre" runat="server" CssClass="form-control" placeholder="Segundo nombre..." />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group">
                <label>Primer Apellido *</label>
                <asp:TextBox ID="txtPrimerApellido" runat="server" CssClass="form-control" placeholder="Primer apellido..." />
            </div>
            <div class="form-group">
                <label>Segundo Apellido</label>
                <asp:TextBox ID="txtSegundoApellido" runat="server" CssClass="form-control" placeholder="Segundo apellido..." />
            </div>
        </div>

        <div class="section-title">📞 Contacto</div>
        <div class="form-row">
            <div class="form-group">
                <label>Teléfono Principal * <small style="color:#888;">(8 dígitos)</small></label>
                <asp:TextBox ID="txtTelefono1" runat="server" CssClass="form-control" placeholder="Ej: 55551001" MaxLength="8" />
            </div>
            <div class="form-group">
                <label>Teléfono Secundario <small style="color:#888;">(8 dígitos)</small></label>
                <asp:TextBox ID="txtTelefono2" runat="server" CssClass="form-control" placeholder="Opcional..." MaxLength="8" />
            </div>
        </div>

        <div class="section-title">📍 Dirección</div>
        <div class="form-row-3">
            <div class="form-group">
                <label>Dirección *</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" placeholder="Dirección..." />
            </div>
            <div class="form-group">
                <label>Avenida *</label>
                <asp:TextBox ID="txtAvenida" runat="server" CssClass="form-control" placeholder="Avenida..." />
            </div>
            <div class="form-group">
                <label>Código Postal *</label>
                <asp:TextBox ID="txtCodigoPostal" runat="server" CssClass="form-control" placeholder="Código postal..." />
            </div>
        </div>

        <div style="display:flex; gap:10px; margin-top:8px;">
            <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar"
                CssClass="btn-gold" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnNuevo" runat="server" Text="🆕 Nuevo"
                CssClass="btn-outline" OnClick="btnNuevo_Click" />
        </div>
    </div>
</div>

<div class="search-bar">
    <div class="form-group">
        <label>🔍 Buscar por DPI</label>
        <asp:TextBox ID="txtBuscarDPI" runat="server" CssClass="form-control"
            placeholder="Ingresa el DPI..." MaxLength="13" />
    </div>
    <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar"
        CssClass="btn-gold" OnClick="btnBuscar_Click" />
    <asp:Button ID="btnVerTodos" runat="server" Text="📋 Ver Todos"
        CssClass="btn-outline" OnClick="btnVerTodos_Click" />
</div>

<div class="table-card">
    <asp:GridView ID="gvEmpleados" runat="server" AutoGenerateColumns="false"
        OnRowCommand="gvEmpleados_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID" ItemStyle-Width="70px">
                <ItemTemplate>
                    <span class="badge-id"><%# Eval("em_empleado") %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="em_DPI"             HeaderText="DPI" />
            <asp:BoundField DataField="em_nombre_completo" HeaderText="Nombre" />
            <asp:BoundField DataField="em_primer_telefono" HeaderText="Teléfono" />
            <asp:BoundField DataField="em_direccion"       HeaderText="Dirección" />
            <asp:BoundField DataField="rol_descripcion"    HeaderText="Rol" />
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <div class="actions-cell">
                        <asp:LinkButton runat="server" Text="✏️" CommandName="Editar"
                            CommandArgument='<%# Eval("em_empleado") %>' CssClass="btn-edit-t" />
                        <asp:LinkButton runat="server" Text="🗑" CommandName="Eliminar"
                            CommandArgument='<%# Eval("em_empleado") %>' CssClass="btn-del-t"
                            OnClientClick="return confirm('¿Eliminar este empleado?');" />
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="empty-state">
                <div style="font-size:40px;">👨‍💼</div>
                <p>No hay empleados registrados.</p>
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
</asp:Content>