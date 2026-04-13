<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="OrdenesCompra.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.OrdenesCompra"
    MasterPageFile="~/Site.Master"
    ContentType="text/html"
    ResponseEncoding="utf-8" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<meta charset="utf-8" />
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .page-title { font-size:22px; color:#5C3A1E; font-family:Georgia,serif; margin:0 0 20px; }
    .alert-ok  { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; }
    .alert-err { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; }
    .form-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; margin-bottom:24px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .form-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:14px 20px; display:flex; justify-content:space-between; align-items:center; }
    .form-card-head span { color:#f0d9a0; font-size:14px; font-weight:bold; font-family:Arial,sans-serif; }
    .form-card-body { padding:20px; }
    .f-row { display:flex; gap:12px; flex-wrap:wrap; align-items:flex-end; }
    .f-group { display:flex; flex-direction:column; gap:6px; flex:1; min-width:160px; }
    .f-group label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .form-control { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; width:100%; outline:none; box-sizing:border-box; }
    .form-control:focus { border-color:#C9973A; background:white; }
    .btn-gold    { background:linear-gradient(135deg,#C9973A,#a87a2e); color:white; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); }
    .btn-green   { background:linear-gradient(135deg,#276749,#1a4d35); color:white; border:none; padding:10px 22px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-green:hover { background:linear-gradient(135deg,#1a4d35,#0f3020); }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    /* Grid principal */
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); margin-top:10px; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:12px 16px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; letter-spacing:0.5px; text-align:left; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf8f3; }
    .table-card tbody tr:last-child { border-bottom:none; }
    .table-card tbody td { padding:12px 16px; font-size:13px; color:#444; vertical-align:top; }
    .badge-id { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; display:inline-block; }
    .actions-cell { display:flex; gap:6px; align-items:center; }
    .btn-edit-t   { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-edit-t:hover { background:#C9973A; color:white; border-color:#C9973A; }
    .btn-del-t    { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-del-t:hover { background:#e53e3e; color:white; border-color:#e53e3e; }
    .btn-save-t   { background:#f0fff4; color:#276749; border:1px solid #9ae6b4; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; white-space:nowrap; }
    .btn-save-t:hover { background:#276749; color:white; }
    .btn-cancel-t { background:#f7fafc; color:#4a5568; border:1px solid #cbd5e0; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; white-space:nowrap; }
    .btn-cancel-t:hover { background:#4a5568; color:white; }
    /* Sub-grid de ítems dentro del listado */
    .sub-items-wrap { margin-top:8px; }
    .sub-items-table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; font-size:12px; }
    .sub-items-table thead tr { background:#f5ece0; }
    .sub-items-table thead th { padding:6px 10px; color:#5C3A1E; font-size:10px; font-weight:bold; text-transform:uppercase; letter-spacing:0.4px; text-align:left; border-bottom:1px solid #e8d8c0; }
    .sub-items-table tbody tr { border-bottom:1px solid #fdf6ec; }
    .sub-items-table tbody tr:last-child { border-bottom:none; }
    .sub-items-table tbody td { padding:5px 10px; color:#555; }
    .sub-items-label { font-size:10px; font-weight:bold; color:#8B5E3C; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:4px; }
    /* Panel agregar ítem */
    .add-item-box { background:#fdf8f3; padding:15px; border-radius:10px; border:1px solid #e8d8c0; margin-bottom:15px; }
    .total-box { padding:14px 16px; background:#fdf6ec; border-radius:8px; border:1px solid #e8d8c0; font-size:16px; font-weight:bold; color:#5C3A1E; font-family:Georgia,serif; margin-top:12px; display:flex; justify-content:space-between; align-items:center; }
    .edit-input { padding:7px 10px; border:2px solid #C9973A; border-radius:6px; font-size:13px; font-family:Arial,sans-serif; background:white; width:100%; box-sizing:border-box; outline:none; }
    .empty-state { text-align:center; padding:40px 20px; color:#aaa; font-family:Arial,sans-serif; }
    .finalizar-bar { background:#f0fff4; border:1px solid #9ae6b4; border-radius:10px; padding:14px 18px; margin-top:14px; display:flex; align-items:center; justify-content:space-between; gap:12px; }
    .finalizar-bar span { font-size:13px; color:#276749; font-family:Arial,sans-serif; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>&#127968; Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Index.aspx") %>'>&#128722; Compras</a> /
    <strong style="color:#5C3A1E;">Ordenes de Compra</strong>
</div>

<div class="page-title">&#128722; Gestion de Ordenes de Compra</div>

<asp:UpdatePanel ID="upOrdenes" runat="server">
<ContentTemplate>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<!-- ===== LISTADO ===== -->
<div class="form-card">
    <div class="form-card-head">
        <span>&#128203; LISTADO DE ORDENES</span>
        <asp:Button ID="btnNuevaOrden" runat="server" Text="+ Nueva Orden"
            CssClass="btn-gold" OnClick="btnNuevaOrden_Click" />
    </div>
    <div class="form-card-body">
        <div class="f-row" style="margin-bottom:15px;">
            <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control"
                placeholder="Buscar por ID, codigo o proveedor..." style="flex:3;" />
            <asp:Button ID="btnBuscar"  runat="server" Text="Buscar"  CssClass="btn-gold"    OnClick="btnBuscar_Click" />
            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-outline" OnClick="btnLimpiar_Click" />
        </div>
        <div class="table-card">
            <asp:GridView ID="gvOrdenes" runat="server"
                AutoGenerateColumns="false"
                DataKeyNames="ORC_KEY"
                CssClass="table"
                OnRowCommand="gvOrdenes_RowCommand"
                OnRowDeleting="gvOrdenes_RowDeleting"
                OnRowEditing="gvOrdenes_RowEditing"
                OnRowCancelingEdit="gvOrdenes_RowCancelingEdit"
                OnRowUpdating="gvOrdenes_RowUpdating"
                OnRowDataBound="gvOrdenes_RowDataBound"
                GridLines="None">
                <Columns>

                    <asp:TemplateField HeaderText="ID" ItemStyle-Width="110px">
                        <ItemTemplate>
                            <span class="badge-id"><%# Eval("ORC_KEY") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="CODIGO"    HeaderText="Codigo"   />
                    <asp:BoundField DataField="PROVEEDOR" HeaderText="Proveedor"/>
                    <asp:BoundField DataField="FECHA"     HeaderText="Fecha"    ItemStyle-Width="150px"/>

                    <%-- Columna combinada: Total + sub-grid de ítems --%>
                    <asp:TemplateField HeaderText="Total / Items">
                        <ItemTemplate>
                            <div class="sub-items-wrap">
                                <asp:GridView ID="gvSubItems" runat="server"
                                    AutoGenerateColumns="false"
                                    CssClass="sub-items-table"
                                    GridLines="None"
                                    Visible="false">
                                    <Columns>
                                        <asp:BoundField DataField="ODP_MATERIAL" HeaderText="Material" />
                                        <asp:TemplateField HeaderText="Precio" ItemStyle-Width="80px">
                                            <ItemTemplate>Q <%# String.Format("{0:N2}", Eval("ODP_PRECIO")) %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ODP_CANTIDAD" HeaderText="Cant." ItemStyle-Width="55px"/>
                                        <asp:TemplateField HeaderText="Subtotal" ItemStyle-Width="90px">
                                            <ItemTemplate>Q <%# String.Format("{0:N2}", Convert.ToDecimal(Eval("ODP_PRECIO")) * Convert.ToDecimal(Eval("ODP_CANTIDAD"))) %></ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <%-- Fila de total visible siempre --%>
                                <div style="margin-top:6px; padding:5px 10px; background:#fdf6ec; border-radius:6px; border:1px solid #e8d8c0; font-size:12px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; display:inline-block;">
                                    Total: Q <%# String.Format("{0:N2}", Eval("TOTAL")) %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="190px" ItemStyle-VerticalAlign="Top">
                        <ItemTemplate>
                            <div class="actions-cell">
                                <asp:LinkButton CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("ORC_KEY") %>'
                                    runat="server" CssClass="btn-edit-t">&#128230; Editar Items</asp:LinkButton>
                                <asp:LinkButton CommandName="Delete"
                                    CommandArgument='<%# Eval("ORC_KEY") %>'
                                    runat="server" CssClass="btn-del-t"
                                    OnClientClick="return confirm('Eliminar esta orden y todos sus items?');">&#128465;</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state"><p>No hay ordenes registradas.</p></div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</div>

<!-- ===== FORM NUEVA ORDEN ===== -->
<asp:Panel ID="pnlFormCabecera" runat="server" Visible="false">
<div class="form-card">
    <div class="form-card-head">
        <span>&#9999; Nueva Orden de Compra</span>
    </div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfKey" runat="server" />
        <div class="f-row">
            <div class="f-group">
                <label>ID / Clave *</label>
                <asp:TextBox ID="txtIDOrden" runat="server" CssClass="form-control" placeholder="Ej: OC-2026-001" />
            </div>
            <div class="f-group">
                <label>Codigo *</label>
                <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control" placeholder="COD-001" />
            </div>
            <div class="f-group">
                <label>Proveedor *</label>
                <asp:DropDownList ID="ddlProveedor" runat="server" CssClass="form-control" />
            </div>
        </div>
        <div class="f-row" style="margin-top:12px;">
            <asp:Button ID="btnGuardar"  runat="server" Text="Guardar y Agregar Items"
                CssClass="btn-gold" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar"
                CssClass="btn-outline" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>
</div>
</asp:Panel>

<!-- ===== DETALLE / EDICION DE ITEMS ===== -->
<asp:Panel ID="pnlDetalleOrden" runat="server" Visible="false">
<div class="form-card">
    <div class="form-card-head">
        <span>&#128230; ITEMS DE LA ORDEN:
            <asp:Label ID="lblOrdenSeleccionada" runat="server" />
        </span>
        <asp:Button ID="btnCerrarDetalle" runat="server" Text="X Cerrar"
            CssClass="btn-outline" OnClick="btnCerrarDetalle_Click" CausesValidation="false"
            style="background:transparent;color:#f0d9a0;border-color:#f0d9a0;" />
    </div>
    <div class="form-card-body">

        <asp:HiddenField ID="hfOrdenActiva" runat="server" />

        <!-- Agregar ítem -->
        <div class="add-item-box">
            <div class="f-row">
                <div class="f-group">
                    <label>Material</label>
                    <asp:TextBox ID="txtMat" runat="server" CssClass="form-control" placeholder="Ej: Madera de pino" />
                </div>
                <div class="f-group">
                    <label>Precio</label>
                    <asp:TextBox ID="txtPre" runat="server" CssClass="form-control" placeholder="0.00" />
                </div>
                <div class="f-group">
                    <label>Cantidad</label>
                    <asp:TextBox ID="txtCan" runat="server" CssClass="form-control" placeholder="0" />
                </div>
                <div style="display:flex;align-items:flex-end;">
                    <asp:Button ID="btnAddMat" runat="server" Text="+ Agregar"
                        CssClass="btn-gold" OnClick="btnAddMat_Click" />
                </div>
            </div>
        </div>

        <!-- Grid ítems con edición inline -->
        <div class="table-card">
            <asp:GridView ID="gvItemsOrden" runat="server"
                AutoGenerateColumns="false"
                DataKeyNames="ODP_ORDEN_DETALLE_PEDIDO"
                CssClass="table"
                OnRowCommand="gvItemsOrden_RowCommand"
                OnRowEditing="gvItemsOrden_RowEditing"
                OnRowCancelingEdit="gvItemsOrden_RowCancelingEdit"
                OnRowUpdating="gvItemsOrden_RowUpdating"
                GridLines="None">
                <Columns>

                    <asp:TemplateField HeaderText="Material">
                        <ItemTemplate><%# Eval("ODP_MATERIAL") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEMat" runat="server" Text='<%# Eval("ODP_MATERIAL") %>' CssClass="edit-input" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Precio" ItemStyle-Width="120px">
                        <ItemTemplate>Q <%# String.Format("{0:N2}", Eval("ODP_PRECIO")) %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEPre" runat="server" Text='<%# Eval("ODP_PRECIO") %>' CssClass="edit-input" style="width:90px;" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Cantidad" ItemStyle-Width="100px">
                        <ItemTemplate><%# Eval("ODP_CANTIDAD") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtECan" runat="server" Text='<%# Eval("ODP_CANTIDAD") %>' CssClass="edit-input" style="width:70px;" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Subtotal" ItemStyle-Width="110px">
                        <ItemTemplate>Q <%# String.Format("{0:N2}", Convert.ToDecimal(Eval("ODP_PRECIO")) * Convert.ToDecimal(Eval("ODP_CANTIDAD"))) %></ItemTemplate>
                        <EditItemTemplate></EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="200px">
                        <ItemTemplate>
                            <div class="actions-cell">
                                <asp:LinkButton CommandName="Edit" runat="server" CssClass="btn-edit-t">&#9999; Editar</asp:LinkButton>
                                <asp:LinkButton CommandName="BorrarItem"
                                    CommandArgument='<%# Eval("ODP_ORDEN_DETALLE_PEDIDO") %>'
                                    runat="server" CssClass="btn-del-t"
                                    OnClientClick="return confirm('Eliminar este item?');">&#128465; Eliminar</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <div class="actions-cell">
                                <asp:LinkButton CommandName="Update" runat="server" CssClass="btn-save-t">&#10003; Guardar</asp:LinkButton>
                                <asp:LinkButton CommandName="Cancel" runat="server" CssClass="btn-cancel-t">&#10005; Cancelar</asp:LinkButton>
                            </div>
                        </EditItemTemplate>
                    </asp:TemplateField>

                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state"><p>No hay items en esta orden. Agrega el primero arriba.</p></div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

        <!-- Total + botón Finalizar -->
        <div class="total-box">
            <span>Total: Q <asp:Label ID="lblTotalOrden" runat="server" Text="0.00" /></span>
            <asp:Button ID="btnFinalizarOrden" runat="server"
                Text="&#10003; Finalizar Orden"
                CssClass="btn-green"
                OnClick="btnFinalizarOrden_Click"
                CausesValidation="false"
                OnClientClick="return confirm('Finalizar y cerrar la carga de items para esta orden?');" />
        </div>

    </div>
</div>
</asp:Panel>

</ContentTemplate>
</asp:UpdatePanel>

</asp:Content>
