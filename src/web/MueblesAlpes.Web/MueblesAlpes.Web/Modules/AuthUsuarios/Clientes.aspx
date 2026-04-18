<%@ Page Title="Clientes" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Clientes.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.ClientesPage" %>

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
    .badge-id  { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; }
    .badge-nat { background:#ebf8ff; color:#2b6cb0; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; }
    .badge-jur { background:#faf5ff; color:#6b46c1; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; }
    .actions-cell { display:flex; gap:8px; justify-content:flex-end; }
    .btn-edit-t { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; }
    .btn-edit-t:hover { background:#C9973A; color:white; }
    .btn-del-t { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; }
    .btn-del-t:hover { background:#e53e3e; color:white; }
    .empty-state { text-align:center; padding:40px; color:#aaa; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Index.aspx") %>'>🏠 Auth & Usuarios</a> /
    <strong style="color:#5C3A1E;">Clientes</strong>
</div>

<div class="page-title">🛒 Gestión de Clientes</div>

<asp:Label ID="lblMensaje" runat="server" CssClass="alert-ok"  Visible="false" />
<asp:Label ID="lblError"   runat="server" CssClass="alert-err" Visible="false" />

<div class="form-card">
    <div class="form-card-head"><span>🔧 Nuevo / Editar Cliente</span></div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfId" runat="server" />

        <div class="section-title">📄 Documento</div>
        <div class="form-row">
            <div class="form-group">
                <label>Tipo Documento *</label>
                <asp:DropDownList ID="ddlTipoDoc" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">-- Seleccione --</asp:ListItem>
                    <asp:ListItem Value="DPI">DPI</asp:ListItem>
                    <asp:ListItem Value="Pasaporte">Pasaporte</asp:ListItem>
                    <asp:ListItem Value="NIT">NIT</asp:ListItem>
                    <asp:ListItem Value="Otro">Otro</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="form-group">
                <label>Número Documento * <small style="color:#888;">(DPI: 13 dígitos)</small></label>
                <asp:TextBox ID="txtNumDoc" runat="server" CssClass="form-control"
                    placeholder="Ej: 1234567890101" MaxLength="13" />
                <span class="hint-text">📌 Será el password del cliente</span>
            </div>
        </div>
        <div class="form-row">
            <div class="form-group">
                <label>NIT <small style="color:#888;">(mínimo 6 dígitos)</small></label>
                <asp:TextBox ID="txtNIT" runat="server" CssClass="form-control" placeholder="NIT..." MaxLength="20" />
            </div>
            <div class="form-group">
                <label>Tipo Cliente *</label>
                <asp:DropDownList ID="ddlTipoCliente" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">-- Seleccione --</asp:ListItem>
                    <asp:ListItem Value="NATURAL">Natural</asp:ListItem>
                    <asp:ListItem Value="JURIDICA">Jurídica</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="section-title">👤 Datos Personales</div>
        <div class="form-row">
            <div class="form-group">
                <label>Primer Nombre *</label>
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
        <div class="form-row">
            <div class="form-group">
                <label>Email * <small style="color:#888;">(será su usuario)</small></label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email..." />
            </div>
            <div class="form-group">
                <label>Profesión</label>
                <asp:TextBox ID="txtProfesion" runat="server" CssClass="form-control" placeholder="Profesión..." />
            </div>
        </div>

        <div class="section-title">📞 Contacto</div>
        <div class="form-row">
            <div class="form-group">
                <label>Teléfono Principal * <small style="color:#888;">(8 dígitos)</small></label>
                <asp:TextBox ID="txtTelefono1" runat="server" CssClass="form-control"
                    placeholder="Ej: 55551001" MaxLength="8" />
            </div>
            <div class="form-group">
                <label>Teléfono Secundario <small style="color:#888;">(8 dígitos)</small></label>
                <asp:TextBox ID="txtTelefono2" runat="server" CssClass="form-control"
                    placeholder="Opcional..." MaxLength="8" />
            </div>
        </div>

        <div class="section-title">📍 Dirección</div>
        <div class="form-row-3">
            <div class="form-group">
                <label>País *</label>
                <asp:TextBox ID="txtPais" runat="server" CssClass="form-control" placeholder="País..." />
            </div>
            <div class="form-group">
                <label>Departamento *</label>
                <asp:TextBox ID="txtDepartamento" runat="server" CssClass="form-control" placeholder="Departamento..." />
            </div>
            <div class="form-group">
                <label>Municipio *</label>
                <asp:TextBox ID="txtMunicipio" runat="server" CssClass="form-control" placeholder="Municipio..." />
            </div>
        </div>
        <div class="form-row-3">
            <div class="form-group">
                <label>Zona *</label>
                <asp:TextBox ID="txtZona" runat="server" CssClass="form-control" placeholder="Zona..." />
            </div>
            <div class="form-group">
                <label>Dirección *</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" placeholder="Dirección..." />
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
        <label>🔍 Buscar por Email</label>
        <asp:TextBox ID="txtBuscarEmail" runat="server" CssClass="form-control" placeholder="Email..." />
    </div>
    <div class="form-group">
        <label>🔍 Buscar por Documento</label>
        <asp:TextBox ID="txtBuscarDoc" runat="server" CssClass="form-control" placeholder="Número documento..." />
    </div>
    <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar"
        CssClass="btn-gold" OnClick="btnBuscar_Click" />
    <asp:Button ID="btnVerTodos" runat="server" Text="📋 Ver Todos"
        CssClass="btn-outline" OnClick="btnVerTodos_Click" />
</div>

<div class="table-card">
    <asp:GridView ID="gvClientes" runat="server" AutoGenerateColumns="false"
        OnRowCommand="gvClientes_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID" ItemStyle-Width="70px">
                <ItemTemplate>
                    <span class="badge-id"><%# Eval("cli_cliente") %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="cli_tipodocumento"   HeaderText="Tipo Doc" />
            <asp:BoundField DataField="cli_numdocumento"    HeaderText="Documento" />
            <asp:TemplateField HeaderText="Nombre">
                <ItemTemplate>
                    <%# Eval("cli_primer_nombre").ToString().Trim() & " " & Eval("cli_primer_apellido").ToString().Trim() %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="cli_email"           HeaderText="Email" />
            <asp:BoundField DataField="cli_primer_telefono" HeaderText="Teléfono" />
            <asp:BoundField DataField="cli_pais"            HeaderText="País" />
            <asp:TemplateField HeaderText="Tipo">
                <ItemTemplate>
                    <%# If(Eval("cli_tipocliente").ToString()="NATURAL",
                        "<span class='badge-nat'>Natural</span>",
                        "<span class='badge-jur'>Jurídica</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <div class="actions-cell">
                        <asp:LinkButton runat="server" Text="✏️" CommandName="Editar"
                            CommandArgument='<%# Eval("cli_cliente") %>' CssClass="btn-edit-t" />
                        <asp:LinkButton runat="server" Text="🗑" CommandName="Eliminar"
                            CommandArgument='<%# Eval("cli_cliente") %>' CssClass="btn-del-t"
                            OnClientClick="return confirm('¿Eliminar este cliente?');" />
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="empty-state">
                <div style="font-size:40px;">🛒</div>
                <p>No hay clientes registrados.</p>
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
</asp:Content>