<%@ Page Title="Promociones" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Promociones.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Promociones" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .mod-header { background:linear-gradient(135deg,#1a1a1a,#2a1a0a); border-radius:12px; padding:24px 30px; margin-bottom:24px; border-left:5px solid #C9973A; display:flex; align-items:center; justify-content:space-between; box-shadow:0 4px 16px rgba(0,0,0,0.12); }
    .mod-header h2 { color:#C9973A; font-family:Georgia,serif; margin:0 0 5px; font-size:22px; }
    .mod-header p { color:rgba(240,217,160,0.6); margin:0; font-size:13px; font-family:Arial,sans-serif; }
    .mod-header .mod-icon { font-size:48px; opacity:0.12; }
    .form-card { background:white; border-radius:12px; border:1px solid #e8d8c0; padding:24px; margin-bottom:20px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .form-card h4 { color:#5C3A1E; font-family:Georgia,serif; font-size:16px; margin:0 0 18px; padding-bottom:10px; border-bottom:2px solid #f0e8d8; }
    .form-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:16px; }
    .form-grid.three { grid-template-columns:repeat(3,1fr); }
    .form-grid.four { grid-template-columns:repeat(4,1fr); }
    .form-group label { display:block; font-size:12px; font-weight:bold; color:#5C3A1E; margin-bottom:5px; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .form-group input, .form-group select, .form-group textarea { width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; color:#333; outline:none; }
    .form-group input:focus, .form-group select:focus { border-color:#C9973A; }
    .btn-gold { background:#C9973A; color:#1a0e05; border:none; padding:10px 22px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; }
    .btn-gold:hover { background:#a87a2e; color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:1.5px solid #e0d0b8; padding:10px 22px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; margin-left:8px; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .btn-danger { background:#c53030; color:white; border:none; padding:5px 12px; border-radius:6px; font-size:12px; font-family:Arial,sans-serif; cursor:pointer; }
    .btn-danger:hover { background:#a02020; }
    .btn-sm { background:#C9973A; color:white; border:none; padding:5px 12px; border-radius:6px; font-size:12px; font-family:Arial,sans-serif; cursor:pointer; }
    .section-label { font-size:12px; font-weight:bold; color:#5C3A1E; margin:0 0 14px; padding:8px 14px; background:linear-gradient(135deg,#fdf6ec,#f5e8d0); border-radius:8px; border-left:4px solid #C9973A; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); margin-bottom:20px; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; font-size:13px; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#7a4f2a); }
    .table-card thead th { color:#f0d9a0; padding:12px 16px; text-align:left; font-size:11px; text-transform:uppercase; letter-spacing:0.5px; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf6ec; }
    .table-card tbody td { padding:11px 16px; color:#333; vertical-align:middle; }
    .badge-activa { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; background:#f0fff4; color:#2d7a2d; border:1px solid #9ae6b4; }
    .badge-inactiva { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; background:#fff5f5; color:#c53030; border:1px solid #fed7d7; }
    .badge-pendiente { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; background:#fffff0; color:#b7791f; border:1px solid #f6e05e; }
    .alert-ok { background:#f0fff4; border:1px solid #9ae6b4; color:#276749; padding:10px 16px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:16px; }
    .alert-err { background:#fff5f5; border:1px solid #fed7d7; color:#c53030; padding:10px 16px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:16px; }
    .back-link { display:inline-flex; align-items:center; gap:6px; color:#C9973A; font-size:13px; font-family:Arial,sans-serif; text-decoration:none; margin-top:20px; padding:8px 14px; border-radius:6px; border:1px solid #e8d8c0; background:white; }
    .back-link:hover { border-color:#C9973A; background:#fdf6ec; color:#C9973A; }
    .detalle-panel { background:#fdf8f3; border-radius:12px; border:1px solid #e8d8c0; padding:20px; margin-top:20px; }
    .detalle-panel h5 { color:#5C3A1E; font-family:Georgia,serif; margin:0 0 14px; font-size:15px; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>Catalogo &amp; Inventario</a> /
    <strong style="color:#5C3A1E;">Promociones</strong>
</div>

<div class="mod-header">
    <div>
        <h2>Promociones</h2>
        <p>Gestión de campañas y productos en promoción.</p>
    </div>
    <div class="mod-icon"></div>
</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<%-- FORMULARIO CAMPAÑA --%>
<div class="form-card">
    <h4> Nueva Campaña</h4>
    <div class="form-grid">
        <div class="form-group">
            <label>Nombre de la Campaña</label>
            <asp:TextBox ID="txtNombre" runat="server" placeholder="Ej: Black Friday" />
        </div>
        <div class="form-group">
            <label>Descripción</label>
            <asp:TextBox ID="txtDescripcion" runat="server" placeholder="Descripción opcional" />
        </div>
        <div class="form-group">
            <label>Fecha Inicio</label>
            <asp:TextBox ID="txtFechaInicio" runat="server" TextMode="Date" />
        </div>
        <div class="form-group">
            <label>Fecha Final</label>
            <asp:TextBox ID="txtFechaFinal" runat="server" TextMode="Date" />
        </div>
    </div>
    <div style="margin-top:18px;">
        <asp:Button ID="btnCrearCampana" runat="server" Text="Crear Campaña" CssClass="btn-gold tiempoInhabilitado" OnClick="btnCrearCampana_Click" CausesValidation="false" />
        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-outline tiempoInhabilitado" OnClick="btnCancelar_Click" CausesValidation="false" />
    </div>
</div>

<%-- LISTA DE CAMPAÑAS --%>
<div class="section-label"> Campañas</div>
<div class="table-card">
    <asp:GridView ID="gvCampanas" runat="server"
        AutoGenerateColumns="false"
        OnRowCommand="gvCampanas_RowCommand"
        EmptyDataText="No hay campañas registradas."
        style="width:100%;">
        <Columns>
            <asp:BoundField DataField="CAMP_CAMPANA"     HeaderText="ID"          ItemStyle-Width="50px" />
            <asp:BoundField DataField="CAMP_NOMBRE"      HeaderText="Nombre" />
            <asp:BoundField DataField="CAMP_DESCRIPCION" HeaderText="Descripción" />
            <asp:BoundField DataField="CAMP_FECHA_INICIO" HeaderText="Inicio"  DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="CAMP_FECHA_FINAL"  HeaderText="Final"   DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="TOTAL_PRODUCTOS"  HeaderText="Productos"   ItemStyle-Width="80px" />
            <asp:TemplateField HeaderText="Estado" ItemStyle-Width="100px">
                <ItemTemplate>
                    <%# If(Eval("CAMP_ESTADO").ToString() = "ACTIVA",
                                    "<span class='badge-activa'> Activa</span>",
                                    If(Eval("CAMP_ESTADO").ToString() = "INACTIVA",
                                    "<span class='badge-inactiva'> Inactiva</span>",
                                    "<span class='badge-pendiente'> Pendiente</span>")) %>
                </ItemTemplate>
            </asp:TemplateField>
<asp:TemplateField HeaderText="Acciones" ItemStyle-Width="280px">
    <ItemTemplate>
        <div style="display:flex; gap:6px; flex-wrap:wrap;">
            <asp:LinkButton runat="server" CommandName="VerDetalle"
                CommandArgument='<%# Eval("CAMP_CAMPANA") %>'
                CssClass="btn-sm tiempoInhabilitado"
                style="background:#C9973A; color:white; padding:6px 12px; border-radius:6px; font-size:11px; font-family:Arial,sans-serif; border:none; cursor:pointer; text-decoration:none;">
                Productos
            </asp:LinkButton>
            <asp:LinkButton runat="server" CommandName="Activar"
                CommandArgument='<%# Eval("CAMP_CAMPANA") & "|" & Eval("CAMP_NOMBRE") & "|" & Eval("CAMP_DESCRIPCION") & "|" & Eval("CAMP_FECHA_INICIO") & "|" & Eval("CAMP_FECHA_FINAL") %>'
                CssClass="btn-sm tiempoInhabilitado"
                style="background:#276749; color:white; padding:6px 12px; border-radius:6px; font-size:11px; font-family:Arial,sans-serif; border:none; cursor:pointer; text-decoration:none;">
                Activar
            </asp:LinkButton>
            <asp:LinkButton runat="server" CommandName="Desactivar"
                CommandArgument='<%# Eval("CAMP_CAMPANA") & "|" & Eval("CAMP_NOMBRE") & "|" & Eval("CAMP_DESCRIPCION") & "|" & Eval("CAMP_FECHA_INICIO") & "|" & Eval("CAMP_FECHA_FINAL") %>'
                CssClass="btn-sm tiempoInhabilitado"
                style="background:#b7791f; color:white; padding:6px 12px; border-radius:6px; font-size:11px; font-family:Arial,sans-serif; border:none; cursor:pointer; text-decoration:none;">
                Desactivar
            </asp:LinkButton>
            <asp:LinkButton runat="server" CommandName="EliminarCampana"
                CommandArgument='<%# Eval("CAMP_CAMPANA") %>'
                CssClass="btn-danger tiempoInhabilitado"
                style="padding:6px 12px; border-radius:6px; font-size:11px; font-family:Arial,sans-serif;"
                OnClientClick="return confirm('¿Eliminar esta campaña y sus productos?');">
                Eliminar
            </asp:LinkButton>
        </div>
    </ItemTemplate>
</asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>

<%-- DETALLE PRODUCTOS DE CAMPAÑA --%>
<asp:Panel ID="pnlDetalle" runat="server" Visible="false">
    <div class="detalle-panel">
        <h5>Productos de la Campaña: <asp:Label ID="lblCampanaNombre" runat="server" /></h5>

        <%-- Agregar por categoría --%>
        <div class="form-grid three" style="margin-bottom:16px;">
            <div class="form-group">
                <label>Categoría</label>
                <asp:DropDownList ID="ddlCategoria" runat="server"
                    style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
            </div>
            <div class="form-group">
                <label>Porcentaje de Descuento</label>
                <asp:TextBox ID="txtPorcentaje" runat="server" placeholder="Ej: 20.00"
                    style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
            </div>
            <div class="form-group" style="display:flex; align-items:flex-end; gap:8px;">
                <asp:Button ID="btnAgregarCategoria" runat="server" Text=" Por Categoría"
                    CssClass="btn-gold tiempoInhabilitado" OnClick="btnAgregarCategoria_Click" CausesValidation="false" />
                <asp:Button ID="btnAgregarTodos" runat="server" Text=" Todos"
                    CssClass="btn-outline tiempoInhabilitado" OnClick="btnAgregarTodos_Click" CausesValidation="false" />
            </div>
        </div>

                <%-- Agregar producto individual --%>
                <div class="form-grid three" style="margin-bottom:80px; margin-top:80px; padding-top:24px; border-top:2px dashed #e8d8c0;">
            <div class="form-group">
                <label>Producto Individual</label>
                <asp:DropDownList ID="ddlProducto" runat="server"
                    style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
            </div>
            <div class="form-group">
                <label>Porcentaje de Descuento</label>
                <asp:TextBox ID="txtPorcentajeInd" runat="server" placeholder="Ej: 20.00"
                    style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
            </div>
            <div class="form-group" style="display:flex; align-items:flex-end;">
                <asp:Button ID="btnAgregarProducto" runat="server" Text=" Agregar"
                    CssClass="btn-gold tiempoInhabilitado" OnClick="btnAgregarProducto_Click" CausesValidation="false" />
            </div>
        </div>

        <asp:HiddenField ID="hfCampanaActiva" runat="server" />

        <asp:GridView ID="gvDetalle" runat="server"
            AutoGenerateColumns="false"
            OnRowCommand="gvDetalle_RowCommand"
            EmptyDataText="No hay productos en esta campaña."
            style="width:100%;">
            <Columns>
                <asp:BoundField DataField="PROM_PROMOCION" HeaderText="ID"         ItemStyle-Width="50px" />
                <asp:BoundField DataField="PRO_REFERENCIA" HeaderText="Referencia" ItemStyle-Width="100px" />
                <asp:BoundField DataField="PRO_NOMBRE"     HeaderText="Producto" />
                <asp:TemplateField HeaderText="Descuento" ItemStyle-Width="100px">
                    <ItemTemplate>
                        <%# String.Format("{0:N2}", Eval("PROM_PORCENTAJE")) %>%
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="100px">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CommandName="EliminarDetalle"
                            CommandArgument='<%# Eval("PROM_PROMOCION") %>'
                            CssClass="btn-danger tiempoInhabilitado"
                            OnClientClick="return confirm('¿Eliminar este producto de la campaña?');">
                            Eliminar
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Panel>

<a class="back-link" href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>&#8592; Volver a Catalogo &amp; Inventario</a>

</asp:Content>