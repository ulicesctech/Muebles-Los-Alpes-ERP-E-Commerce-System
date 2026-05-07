<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Almacenes.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Almacenes" MasterPageFile="~/Site.Master" %>
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
    .form-card-body { padding:20px; }
    .f-row { display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; }
    .f-group { display:flex; flex-direction:column; gap:6px; flex:1; min-width:180px; }
    .f-group label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .f-group .form-control { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; width:100%; outline:none; }
    .f-group .form-control:focus { border-color:#C9973A; background:white; }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .section-label { font-size:12px; font-weight:bold; color:#5C3A1E; margin:0 0 14px; padding:8px 14px; background:linear-gradient(135deg,#fdf6ec,#f5e8d0); border-radius:8px; border-left:4px solid #C9973A; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); margin-bottom:24px; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:14px 18px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; letter-spacing:0.5px; border:none; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf8f3; }
    .table-card tbody tr:last-child { border-bottom:none; }
    .table-card tbody td { padding:14px 18px; font-size:14px; color:#444; vertical-align:middle; border:none; }
    .badge-id { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; display:inline-block; }
    .actions-cell { display:flex; gap:8px; align-items:center; justify-content:flex-end; }
    .btn-edit-t { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:6px 14px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-edit-t:hover { background:#C9973A; color:white !important; border-color:#C9973A; text-decoration:none; }
    .btn-del-t { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:6px 14px; border-radius:6px; font-size:12px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-del-t:hover { background:#e53e3e; color:white !important; border-color:#e53e3e; text-decoration:none; }
    .nichos-panel { background:#fdf6ec; border-radius:12px; border:1px solid #e8d0a0; padding:22px; margin-bottom:24px; }
    .nichos-panel h4 { color:#5C3A1E; font-family:Georgia,serif; font-size:16px; margin:0 0 16px; padding-bottom:10px; border-bottom:2px solid #e8d0a0; }
    .empty-state { text-align:center; padding:30px 20px; color:#aaa; font-family:Arial,sans-serif; font-size:13px; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>Catalogo &amp; Inventario</a> /
    <strong style="color:#5C3A1E;">Almacenes</strong>
</div>

<div class="page-title">Gestion de Almacenes</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server"></asp:Label>
</asp:Panel>

<%-- FORMULARIO ALMACEN --%>
<div class="form-card">
    <div class="form-card-head">
        <span><asp:Label ID="lblTituloForm" runat="server" Text="Nuevo Almacen"></asp:Label></span>
    </div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfId" runat="server" Value="0" />
        <div class="f-row">
            <div class="f-group">
                <label>Nombre *</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="200" placeholder="Nombre del almacen"></asp:TextBox>
            </div>
            <div class="f-group">
                <label>Pais *</label>
                <asp:TextBox ID="txtPais" runat="server" CssClass="form-control" MaxLength="100" placeholder="Guatemala"></asp:TextBox>
            </div>
            <div class="f-group">
                <label>Ubicacion *</label>
                <asp:TextBox ID="txtUbicacion" runat="server" CssClass="form-control" MaxLength="300" placeholder="Direccion exacta"></asp:TextBox>
            </div>
        </div>
        <div class="f-row" style="margin-top:12px;">
            <asp:Button ID="btnGuardar"  runat="server" Text="Guardar"  CssClass="btn-gold tiempoInhabilitado"    OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-outline tiempoInhabilitado" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>
</div>

<%-- PANEL NICHOS — aparece justo aqui al editar un almacen --%>
<asp:Panel ID="pnlNichos" runat="server" Visible="false">
    <div class="nichos-panel">
        <h4>Nichos del Almacen: <asp:Label ID="lblAlmacenNombre" runat="server" /></h4>
        <asp:HiddenField ID="hfAlmacenId" runat="server" Value="0" />

        <div class="section-label">Agregar Nuevo Nicho</div>
        <div class="f-row" style="margin-bottom:16px;">
            <div class="f-group">
                <label>Numero *</label>
                <asp:TextBox ID="txtNicNumero" runat="server" CssClass="form-control" placeholder="A-01" MaxLength="50"></asp:TextBox>
            </div>
            <div class="f-group">
                <label>Zona *</label>
                <asp:TextBox ID="txtNicZona" runat="server" CssClass="form-control" placeholder="Norte" MaxLength="100"></asp:TextBox>
            </div>
            <div class="f-group">
                <label>Caracteristica *</label>
                <asp:TextBox ID="txtNicCaracteristica" runat="server" CssClass="form-control" placeholder="Estanteria alta para sala" MaxLength="200"></asp:TextBox>
            </div>
            <div style="display:flex; align-items:flex-end;">
                <asp:Button ID="btnCrearNicho" runat="server" Text="Crear y Asignar" CssClass="btn-gold tiempoInhabilitado" OnClick="btnCrearNicho_Click" />
            </div>
        </div>

        <div class="section-label">Nichos Asignados</div>
        <div class="table-card">
            <asp:GridView ID="gvNichos" runat="server" AutoGenerateColumns="false" OnRowCommand="gvNichos_RowCommand" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="NIC_NUMERO"         HeaderText="Numero" />
                    <asp:BoundField DataField="NIC_ZONA"           HeaderText="Zona" />
                    <asp:BoundField DataField="NIC_CARACTERISTICA" HeaderText="Caracteristica" />
                    <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="100px">
                        <ItemTemplate>
                            <asp:LinkButton CommandName="EliminarNicho"
                                CommandArgument='<%# Eval("NIC_NICHO") %>'
                                runat="server" CssClass="btn-del-t tiempoInhabilitado"
                                OnClientClick="return confirm('Desea eliminar este nicho?');">
                                Eliminar
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate><div class="empty-state">Este almacen no tiene nichos asignados.</div></EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Panel>

<%-- TABLA ALMACENES --%>
<div class="section-label">Almacenes Registrados</div>
<div class="table-card">
    <asp:GridView ID="gvAlmacenes" runat="server" AutoGenerateColumns="false" OnRowCommand="gvAlmacenes_RowCommand" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="ID" ItemStyle-Width="80px">
                <ItemTemplate><span class="badge-id"><%# Eval("ALM_ALMACEN") %></span></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ALM_NOMBRE"    HeaderText="Nombre" />
            <asp:BoundField DataField="ALM_PAIS"      HeaderText="Pais"   ItemStyle-Width="120px" />
            <asp:BoundField DataField="ALM_UBICACION" HeaderText="Ubicacion" />
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="200px">
                <ItemTemplate>
                    <div class="actions-cell">
                        <asp:LinkButton CommandName="Editar"   CommandArgument='<%# Eval("ALM_ALMACEN") %>' runat="server" CssClass="btn-edit-t tiempoInhabilitado">Editar</asp:LinkButton>
                        <asp:LinkButton CommandName="Eliminar" CommandArgument='<%# Eval("ALM_ALMACEN") %>' runat="server" CssClass="btn-del-t tiempoInhabilitado" OnClientClick="return confirm('Desea eliminar este almacen?');">Eliminar</asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate><div class="empty-state">No hay almacenes registrados.</div></EmptyDataTemplate>
    </asp:GridView>
</div>

</asp:Content>