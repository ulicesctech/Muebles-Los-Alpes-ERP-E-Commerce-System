<%@ Page Title="Clientes" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Index.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.Clientes.Index" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; box-shadow:0 1px 4px rgba(92,58,30,0.06); }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }

    .mod-header { background:linear-gradient(135deg,#1a1a1a,#2a1a0a); border-radius:12px; padding:24px 30px; margin-bottom:24px; border-left:5px solid #C9973A; display:flex; align-items:center; justify-content:space-between; box-shadow:0 4px 16px rgba(0,0,0,0.12); }
    .mod-header h2 { color:#C9973A; font-family:Georgia,serif; margin:0 0 5px; font-size:22px; }
    .mod-header p { color:rgba(240,217,160,0.6); margin:0; font-size:13px; font-family:Arial,sans-serif; }
    .mod-header .mod-icon { font-size:48px; opacity:0.12; }

    .search-card { background:white; border-radius:12px; border:1px solid #e8d8c0; padding:20px 24px; margin-bottom:20px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .search-card label { font-size:12px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; display:block; margin-bottom:5px; text-transform:uppercase; letter-spacing:0.5px; }
    .search-card input[type=text] { width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; color:#333; outline:none; transition:border 0.2s; }
    .search-card input[type=text]:focus { border-color:#C9973A; }

    .btn-gold { background:#C9973A; color:#1a0e05; border:none; padding:10px 22px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; transition:all 0.2s; }
    .btn-gold:hover { background:#a87a2e; color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:1.5px solid #e0d0b8; padding:10px 22px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; transition:all 0.2s; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .btn-danger { background:#c53030; color:white; border:none; padding:7px 14px; border-radius:6px; font-size:12px; font-family:Arial,sans-serif; cursor:pointer; transition:all 0.2s; }
    .btn-danger:hover { background:#a02020; }

    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; font-size:13px; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#7a4f2a); }
    .table-card thead th { color:#f0d9a0; padding:12px 16px; text-align:left; font-size:11px; text-transform:uppercase; letter-spacing:0.5px; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf6ec; }
    .table-card tbody td { padding:11px 16px; color:#333; vertical-align:middle; }

    .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; font-family:Arial,sans-serif; }
    .badge-natural { background:#fdf6ec; color:#C9973A; border:1px solid #e8d0a0; }
    .badge-juridica { background:#f0f4ff; color:#3060c0; border:1px solid #b0c0e8; }

    .alert-ok { background:#f0fff4; border:1px solid #9ae6b4; color:#276749; padding:10px 16px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:16px; }
    .alert-err { background:#fff5f5; border:1px solid #fed7d7; color:#c53030; padding:10px 16px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:16px; }

    .back-link { display:inline-flex; align-items:center; gap:6px; color:#C9973A; font-size:13px; font-family:Arial,sans-serif; text-decoration:none; margin-top:20px; padding:8px 14px; border-radius:6px; border:1px solid #e8d8c0; background:white; transition:all 0.2s; }
    .back-link:hover { border-color:#C9973A; background:#fdf6ec; text-decoration:none; color:#C9973A; }
</style>

<%-- BREADCRUMB --%>
<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Default.aspx") %>'>Auth &amp; Usuarios</a> /
    <strong style="color:#5C3A1E;">Clientes</strong>
</div>

<%-- HEADER --%>
<div class="mod-header">
    <div>
        <h2>Administracion de Clientes</h2>
        <p>Registro, consulta, actualizacion y eliminacion de clientes.</p>
    </div>
    <div class="mod-icon">&#128100;</div>
</div>

<%-- MENSAJE --%>
<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<%-- BUSQUEDA --%>
<div class="search-card">
    <div style="display:grid; grid-template-columns:1fr 1fr 1fr auto auto; gap:14px; align-items:end;">
        <div>
            <label>Numero de Documento</label>
            <asp:TextBox ID="txtBuscarDoc" runat="server" placeholder="Buscar por documento..." style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
        </div>
        <div>
            <label>Nombre</label>
            <asp:TextBox ID="txtBuscarNombre" runat="server" placeholder="Buscar por nombre..." style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
        </div>
        <div>
            <label>Email</label>
            <asp:TextBox ID="txtBuscarEmail" runat="server" placeholder="Buscar por email..." style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
        </div>
        <div>
            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn-gold" OnClick="btnBuscar_Click" />
        </div>
        <div>
            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-outline" OnClick="btnLimpiar_Click" />
        </div>
    </div>
</div>

<%-- TABLA --%>
<div class="table-card">
    <asp:GridView ID="gvClientes" runat="server"
        AutoGenerateColumns="false"
        OnRowCommand="gvClientes_RowCommand"
        EmptyDataText="No se encontraron clientes."
        style="width:100%;">
        <Columns>
            <asp:BoundField DataField="CLI_NUM_DOCUMENTO" HeaderText="Num. Documento" />
            <asp:BoundField DataField="CLI_NOMBRE" HeaderText="Nombre Completo" />
            <asp:BoundField DataField="CLI_EMAIL" HeaderText="Email" />
            <asp:BoundField DataField="CLI_TELEFONO_RES" HeaderText="Telefono" />
            <asp:BoundField DataField="CLI_CIUDAD" HeaderText="Ciudad" />
            <asp:TemplateField HeaderText="Tipo">
                <ItemTemplate>
                    <%# If(Eval("CLI_TIPO_PERSONA").ToString() = "J",
                                    "<span class='badge badge-juridica'>Juridica</span>",
                                    "<span class='badge badge-natural'>Natural</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="Eliminar"
                        CommandArgument='<%# Eval("CLI_CLIENTE") %>'
                        style="background:#c53030; color:white; border:none; padding:6px 12px; border-radius:6px; font-size:12px; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none;"
                        OnClientClick="return confirm('¿Desea eliminar este cliente? Solo se puede eliminar si no ha realizado compras.');">
                        Eliminar
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>

<a class="back-link" href='<%: ResolveUrl("~/Modules/AuthUsuarios/Default.aspx") %>'>&#8592; Volver a Auth &amp; Usuarios</a>

</asp:Content>