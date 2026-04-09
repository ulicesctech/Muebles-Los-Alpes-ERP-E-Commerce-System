<%@ Page Title="Ascensos" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Ascensos.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.AscensosPage" %>

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
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; cursor:pointer; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; cursor:pointer; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
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
    <strong style="color:#5C3A1E;">Ascensos</strong>
</div>

<div class="page-title">📈 Gestión de Ascensos</div>

<asp:Label ID="lblMensaje" runat="server" CssClass="alert-ok"  Visible="false" />
<asp:Label ID="lblError"   runat="server" CssClass="alert-err" Visible="false" />

<div class="form-card">
    <div class="form-card-head"><span>🔧 Nuevo / Editar Ascenso</span></div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfId"   runat="server" />
        <asp:HiddenField ID="hfMode" runat="server" Value="crear" />

        <div class="form-row">
            <div class="form-group">
                <label>Empleado *</label>
                <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="form-control" />
            </div>
            <div class="form-group">
                <label>Puesto *</label>
                <asp:DropDownList ID="ddlPuesto" runat="server" CssClass="form-control" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group">
                <label>Fecha Inicio *</label>
                <asp:TextBox ID="txtFechaInicio" runat="server" CssClass="form-control"
                    TextMode="Date" />
            </div>
            <div class="form-group">
                <label>Fecha Final <small style="color:#aaa;">(opcional)</small></label>
                <asp:TextBox ID="txtFechaFinal" runat="server" CssClass="form-control"
                    TextMode="Date" />
            </div>
        </div>

        <div style="display:flex; gap:10px;">
            <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar"
                CssClass="btn-gold" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnNuevo" runat="server" Text="🆕 Nuevo"
                CssClass="btn-outline" OnClick="btnNuevo_Click" />
        </div>
    </div>
</div>

<div class="table-card">
    <asp:GridView ID="gvAscensos" runat="server" AutoGenerateColumns="false"
        OnRowCommand="gvAscensos_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID" ItemStyle-Width="70px">
                <ItemTemplate>
                    <span class="badge-id"><%# Eval("asc_ascenso") %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="em_nombre_completo" HeaderText="Empleado" />
            <asp:BoundField DataField="pue_nombre"         HeaderText="Puesto" />
            <asp:BoundField DataField="asc_fecha_inicio"   HeaderText="Fecha Inicio" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="asc_fecha_final"    HeaderText="Fecha Final"  DataFormatString="{0:dd/MM/yyyy}" NullDisplayText="—" />
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <div class="actions-cell">
                        <asp:LinkButton runat="server" Text="✏️" CommandName="Editar"
                            CommandArgument='<%# Eval("asc_ascenso") %>' CssClass="btn-edit-t" />
                        <asp:LinkButton runat="server" Text="🗑" CommandName="Eliminar"
                            CommandArgument='<%# Eval("asc_ascenso") %>' CssClass="btn-del-t"
                            OnClientClick="return confirm('¿Eliminar este ascenso?');" />
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="empty-state">
                <div style="font-size:40px;">📈</div>
                <p>No hay ascensos registrados.</p>
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
</asp:Content>