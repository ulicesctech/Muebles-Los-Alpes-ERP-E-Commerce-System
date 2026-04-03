<%@ Page Title="Permisos" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Permisos.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.Admin.PermisosPage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .page-title { font-size:22px; color:#5C3A1E; font-family:Georgia,serif; margin:0 0 20px; }
    .alert-err { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; display:block; }
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
    .empty-state { text-align:center; padding:40px; color:#aaa; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Index.aspx") %>'>🏠 Auth & Usuarios</a> /
    <strong style="color:#5C3A1E;">Permisos</strong>
</div>

<div class="page-title">⚙️ Permisos del Sistema</div>

<asp:Label ID="lblError" runat="server" CssClass="alert-err" Visible="false" />

<div class="table-card">
    <asp:GridView ID="gvPermisos" runat="server" AutoGenerateColumns="false"
        GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID">
                <ItemTemplate>
                    <span class="badge-id"><%# Eval("per_permisos") %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Admin">
                <ItemTemplate>
                    <%# If(Eval("per_admin").ToString()="Aprobado",
                        "<span class='badge-ok'>✓ Aprobado</span>",
                        "<span class='badge-no'>✗ Negado</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="RH">
                <ItemTemplate>
                    <%# If(Eval("per_rh").ToString()="Aprobado",
                        "<span class='badge-ok'>✓ Aprobado</span>",
                        "<span class='badge-no'>✗ Negado</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Facturación">
                <ItemTemplate>
                    <%# If(Eval("per_fac").ToString()="Aprobado",
                        "<span class='badge-ok'>✓ Aprobado</span>",
                        "<span class='badge-no'>✗ Negado</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Clientes">
                <ItemTemplate>
                    <%# If(Eval("per_cli").ToString()="Aprobado",
                        "<span class='badge-ok'>✓ Aprobado</span>",
                        "<span class='badge-no'>✗ Negado</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Bodega">
                <ItemTemplate>
                    <%# If(Eval("per_bod").ToString()="Aprobado",
                        "<span class='badge-ok'>✓ Aprobado</span>",
                        "<span class='badge-no'>✗ Negado</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Promociones">
                <ItemTemplate>
                    <%# If(Eval("per_promo").ToString()="Aprobado",
                        "<span class='badge-ok'>✓ Aprobado</span>",
                        "<span class='badge-no'>✗ Negado</span>") %>
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