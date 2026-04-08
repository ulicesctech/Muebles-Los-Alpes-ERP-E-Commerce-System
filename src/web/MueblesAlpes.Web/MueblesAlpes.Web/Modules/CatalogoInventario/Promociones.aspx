<%@ Page Title="Promociones" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Promociones.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Promociones" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; box-shadow:0 1px 4px rgba(92,58,30,0.06); }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }

    .mod-header { background:linear-gradient(135deg,#1a1a1a,#2a1a0a); border-radius:12px; padding:24px 30px; margin-bottom:24px; border-left:5px solid #C9973A; display:flex; align-items:center; justify-content:space-between; box-shadow:0 4px 16px rgba(0,0,0,0.12); }
    .mod-header h2 { color:#C9973A; font-family:Georgia,serif; margin:0 0 5px; font-size:22px; }
    .mod-header p { color:rgba(240,217,160,0.6); margin:0; font-size:13px; font-family:Arial,sans-serif; }
    .mod-header .mod-icon { font-size:48px; opacity:0.12; }

    .form-card { background:white; border-radius:12px; border:1px solid #e8d8c0; padding:24px; margin-bottom:20px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .form-card h4 { color:#5C3A1E; font-family:Georgia,serif; font-size:16px; margin:0 0 18px; padding-bottom:10px; border-bottom:2px solid #f0e8d8; }
    .form-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:16px; }
    .form-grid.four { grid-template-columns:repeat(4,1fr); }
    .form-group label { display:block; font-size:12px; font-weight:bold; color:#5C3A1E; margin-bottom:5px; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .form-group input, .form-group select { width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; color:#333; outline:none; transition:border 0.2s; }
    .form-group input:focus, .form-group select:focus { border-color:#C9973A; }

    .btn-gold { background:#C9973A; color:#1a0e05; border:none; padding:10px 22px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; transition:all 0.2s; }
    .btn-gold:hover { background:#a87a2e; color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:1.5px solid #e0d0b8; padding:10px 22px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; transition:all 0.2s; margin-left:8px; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }

    .vigente-card { background:linear-gradient(135deg,#fdf6ec,#f5e8d0); border-radius:12px; border:1px solid #e8d0a0; padding:18px 24px; margin-bottom:20px; display:flex; align-items:center; justify-content:space-between; }
    .vigente-card .v-label { font-size:12px; font-weight:bold; color:#C9973A; text-transform:uppercase; letter-spacing:1px; font-family:Arial,sans-serif; margin-bottom:4px; }
    .vigente-card .v-val { font-size:22px; font-weight:900; color:#1a0e05; font-family:Arial,sans-serif; }
    .vigente-card .v-sub { font-size:12px; color:#888; font-family:Arial,sans-serif; }

    .section-label { font-size:12px; font-weight:bold; color:#5C3A1E; margin:0 0 14px; padding:8px 14px; background:linear-gradient(135deg,#fdf6ec,#f5e8d0); border-radius:8px; border-left:4px solid #C9973A; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }

    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); margin-bottom:20px; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; font-size:13px; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#7a4f2a); }
    .table-card thead th { color:#f0d9a0; padding:12px 16px; text-align:left; font-size:11px; text-transform:uppercase; letter-spacing:0.5px; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf6ec; }
    .table-card tbody td { padding:11px 16px; color:#333; vertical-align:middle; }

    .badge-vigente { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; background:#f0fff4; color:#2d7a2d; border:1px solid #9ae6b4; }
    .badge-vencida { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; background:#fff5f5; color:#c53030; border:1px solid #fed7d7; }

    .btn-eliminar { background:#c53030; color:white; border:none; padding:5px 12px; border-radius:6px; font-size:12px; font-family:Arial,sans-serif; cursor:pointer; }
    .btn-eliminar:hover { background:#a02020; }

    .alert-ok { background:#f0fff4; border:1px solid #9ae6b4; color:#276749; padding:10px 16px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:16px; }
    .alert-err { background:#fff5f5; border:1px solid #fed7d7; color:#c53030; padding:10px 16px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; margin-bottom:16px; }

    .back-link { display:inline-flex; align-items:center; gap:6px; color:#C9973A; font-size:13px; font-family:Arial,sans-serif; text-decoration:none; margin-top:20px; padding:8px 14px; border-radius:6px; border:1px solid #e8d8c0; background:white; transition:all 0.2s; }
    .back-link:hover { border-color:#C9973A; background:#fdf6ec; text-decoration:none; color:#C9973A; }
</style>

<%-- BREADCRUMB --%>
<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>Catalogo &amp; Inventario</a> /
    <strong style="color:#5C3A1E;">Promociones</strong>
</div>

<%-- HEADER --%>
<div class="mod-header">
    <div>
        <h2>Promociones</h2>
        <p>Registro y gestion de promociones por producto.</p>
    </div>
    <div class="mod-icon">&#127991;</div>
</div>

<%-- MENSAJE --%>
<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<%-- FORMULARIO --%>
<div class="form-card">
    <h4>&#128221; Nueva Promocion</h4>
    <div class="form-grid four">
        <div class="form-group">
            <label>Producto</label>
            <asp:DropDownList ID="ddlProducto" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlProducto_SelectedIndexChanged"
                style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
        </div>
        <div class="form-group">
            <label>Porcentaje de Descuento</label>
            <asp:TextBox ID="txtPorcentaje" runat="server" placeholder="10.00"
                style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
        </div>
        <div class="form-group">
            <label>Fecha Inicio</label>
            <asp:TextBox ID="txtFechaInicio" runat="server" TextMode="Date"
                style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
        </div>
        <div class="form-group">
            <label>Fecha Final</label>
            <asp:TextBox ID="txtFechaFinal" runat="server" TextMode="Date"
                style="width:100%; padding:10px 14px; border:1.5px solid #e0d0b8; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; outline:none;" />
        </div>
    </div>
    <div style="margin-top:18px;">
        <asp:Button ID="btnCrear" runat="server" Text="Crear Promocion" CssClass="btn-gold" OnClick="btnCrear_Click" />
        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-outline" OnClick="btnCancelar_Click" />
    </div>
</div>

<%-- VIGENTE --%>
<asp:Panel ID="pnlVigente" runat="server" Visible="false">
    <div class="section-label">Promocion Vigente</div>
    <div class="vigente-card">
        <div>
            <div class="v-label">Descuento activo</div>
            <div class="v-val"><asp:Label ID="lblPorcentaje" runat="server" />%</div>
            <div class="v-sub">
                Desde <asp:Label ID="lblFechaInicio" runat="server" /> hasta <asp:Label ID="lblFechaFinal" runat="server" />
            </div>
        </div>
        <span class="badge-vigente">Vigente</span>
    </div>
</asp:Panel>

<%-- HISTORIAL --%>
<div class="section-label">Historial de Promociones</div>
<div class="table-card">
    <asp:GridView ID="gvPromociones" runat="server"
        AutoGenerateColumns="false"
        OnRowCommand="gvPromociones_RowCommand"
        EmptyDataText="Seleccione un producto para ver sus promociones."
        style="width:100%;">
        <Columns>
            <asp:BoundField DataField="PROM_PROMOCION" HeaderText="ID" />
            <asp:BoundField DataField="PRO_REFERENCIA" HeaderText="Producto" />
            <asp:BoundField DataField="PROM_PORCENTAJE" HeaderText="Descuento %" DataFormatString="{0:N2}%" />
            <asp:BoundField DataField="PROM_FECHA_INICIO" HeaderText="Inicio" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="PROM_FECHA_FINAL" HeaderText="Final" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:TemplateField HeaderText="Estado">
                <ItemTemplate>
                    <%# If(Convert.ToDateTime(Eval("PROM_FECHA_FINAL")) >= DateTime.Now,
                        "<span class='badge-vigente'>Vigente</span>",
                        "<span class='badge-vencida'>Vencida</span>") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="Eliminar"
                        CommandArgument='<%# Eval("PROM_PROMOCION") %>'
                        CssClass="btn-eliminar"
                        OnClientClick="return confirm('Desea eliminar esta promocion?');">
                        Eliminar
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>

<a class="back-link" href='<%: ResolveUrl("~/Modules/CatalogoInventario/Index.aspx") %>'>&#8592; Volver a Catalogo &amp; Inventario</a>

</asp:Content>