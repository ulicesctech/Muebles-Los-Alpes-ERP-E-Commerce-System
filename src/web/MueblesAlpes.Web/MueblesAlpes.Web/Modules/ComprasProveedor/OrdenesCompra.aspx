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
    .alert-ok  { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; font-family:Arial,sans-serif; }
    .alert-err { padding:12px 18px; border-radius:8px; font-size:13px; margin-bottom:20px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; font-family:Arial,sans-serif; }
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
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); margin-top:10px; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:12px 16px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; letter-spacing:0.5px; text-align:left; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; transition:background 0.15s; }
    .table-card tbody tr:hover { background:#fdf8f3; }
    .table-card tbody tr:last-child { border-bottom:none; }
    .table-card tbody td { padding:12px 16px; font-size:13px; color:#444; vertical-align:top; }
    .badge-id   { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; display:inline-block; }
    .badge-pago { background:#eef6ff; color:#2b6cb0; padding:2px 8px; border-radius:10px; font-size:11px; font-weight:bold; border:1px solid #bee3f8; display:inline-block; }
    .actions-cell { display:flex; gap:6px; align-items:center; }
    .btn-del-t  { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-del-t:hover { background:#e53e3e; color:white; border-color:#e53e3e; }
    .btn-edit-t { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-edit-t:hover { background:#C9973A; color:white; border-color:#C9973A; }
    .sub-items-wrap { margin-top:6px; }
    .sub-items-table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; font-size:12px; }
    .sub-items-table thead tr { background:#f5ece0; }
    .sub-items-table thead th { padding:5px 10px; color:#5C3A1E; font-size:10px; font-weight:bold; text-transform:uppercase; letter-spacing:0.4px; text-align:left; border-bottom:1px solid #e8d8c0; }
    .sub-items-table tbody tr { border-bottom:1px solid #fdf6ec; }
    .sub-items-table tbody tr:last-child { border-bottom:none; }
    .sub-items-table tbody td { padding:5px 10px; color:#555; }
    .add-item-box { background:#fdf8f3; padding:15px; border-radius:10px; border:1px solid #e8d8c0; margin-bottom:15px; }
    .total-box { padding:14px 16px; background:#fdf6ec; border-radius:8px; border:1px solid #e8d8c0; font-size:16px; font-weight:bold; color:#5C3A1E; font-family:Georgia,serif; margin-top:12px; display:flex; justify-content:space-between; align-items:center; }
    .empty-state { text-align:center; padding:40px 20px; color:#aaa; font-family:Arial,sans-serif; }
    .section-label { font-size:12px; font-weight:bold; color:#5C3A1E; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:10px; }
    .pedido-sel-box { background:#f0fff4; border:1px solid #9ae6b4; border-radius:8px; padding:14px 16px; margin-top:10px; }
    .items-precio-table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; font-size:13px; }
    .items-precio-table thead tr { background:#e8f5e9; }
    .items-precio-table thead th { padding:9px 12px; color:#276749; font-size:11px; font-weight:bold; text-transform:uppercase; text-align:left; border-bottom:2px solid #9ae6b4; }
    .items-precio-table tbody tr { border-bottom:1px solid #f0fff4; }
    .items-precio-table tbody td { padding:9px 12px; color:#333; vertical-align:middle; }
    .precio-input { padding:7px 10px; border:2px solid #9ae6b4; border-radius:6px; font-size:13px; font-family:Arial,sans-serif; background:white; width:110px; box-sizing:border-box; outline:none; }
    .precio-input:focus { border-color:#276749; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>&#127968; Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Index.aspx") %>'>&#128722; Compras</a> /
    <strong style="color:#5C3A1E;">Ordenes de Compra</strong>
</div>
<div class="page-title">&#128722; Gestion de Ordenes de Compra</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<!-- ====== LISTADO ORDENES ====== -->
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
                GridLines="None"
                OnRowCommand="gvOrdenes_RowCommand"
                OnRowDeleting="gvOrdenes_RowDeleting"
                OnRowEditing="gvOrdenes_RowEditing"
                OnRowCancelingEdit="gvOrdenes_RowCancelingEdit"
                OnRowUpdating="gvOrdenes_RowUpdating"
                OnRowDataBound="gvOrdenes_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="ID" ItemStyle-Width="110px">
                        <ItemTemplate><span class="badge-id"><%# Eval("ORC_KEY") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CODIGO"    HeaderText="Codigo" />
                    <asp:BoundField DataField="PROVEEDOR" HeaderText="Proveedor" />
                    <asp:BoundField DataField="FECHA"     HeaderText="Fecha" ItemStyle-Width="130px" />
                    <asp:TemplateField HeaderText="Items / Total">
                        <ItemTemplate>
                            <div class="sub-items-wrap">
                                <asp:GridView ID="gvSubItems" runat="server"
                                    AutoGenerateColumns="false"
                                    CssClass="sub-items-table"
                                    GridLines="None"
                                    Visible="false">
                                    <Columns>
                                        <asp:BoundField DataField="PED_CODIGO"   HeaderText="Pedido"     ItemStyle-Width="65px" />
                                        <asp:BoundField DataField="PRO_NOMBRE"   HeaderText="Producto" />
                                        <asp:TemplateField HeaderText="Forma Pago" ItemStyle-Width="90px">
                                            <ItemTemplate><span class="badge-pago"><%# Eval("PED_FORMA_PAGO") %></span></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ODP_MATERIAL" HeaderText="Material" />
                                        <asp:TemplateField HeaderText="Precio" ItemStyle-Width="80px">
                                            <ItemTemplate>Q <%# String.Format("{0:N2}", Eval("ODP_PRECIO")) %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ODP_CANTIDAD" HeaderText="Cant." ItemStyle-Width="55px" />
                                        <asp:TemplateField HeaderText="Subtotal" ItemStyle-Width="90px">
                                            <ItemTemplate>Q <%# String.Format("{0:N2}", Convert.ToDecimal(Eval("ODP_PRECIO")) * Convert.ToDecimal(Eval("ODP_CANTIDAD"))) %></ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <div style="margin-top:6px; padding:4px 10px; background:#fdf6ec; border-radius:6px; border:1px solid #e8d8c0; font-size:12px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; display:inline-block;">
                                    Total: Q <%# String.Format("{0:N2}", Eval("TOTAL")) %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="180px" ItemStyle-VerticalAlign="Top">
                        <ItemTemplate>
                            <div class="actions-cell">
                                <asp:LinkButton CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("ORC_KEY") %>'
                                    runat="server" CssClass="btn-edit-t">&#128230; Ver</asp:LinkButton>
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

<!-- ====== FORM NUEVA ORDEN ====== -->
<asp:Panel ID="pnlFormCabecera" runat="server" Visible="false">
<div class="form-card">
    <div class="form-card-head"><span>&#9999; Nueva Orden de Compra</span></div>
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

        <hr style="border:1px solid #e8d8c0; margin:18px 0;" />

        <div class="section-label">&#128203; Vincular Pedido</div>
        <div class="add-item-box">
            <div class="f-row" style="margin-bottom:12px;">
                <asp:TextBox ID="txtBuscarPedido" runat="server" CssClass="form-control"
                    placeholder="Buscar pedido por codigo o ID..." style="flex:3;" />
                <asp:Button ID="btnBuscarPedido" runat="server" Text="&#128269; Buscar"
                    CssClass="btn-gold" OnClick="btnBuscarPedido_Click" CausesValidation="false" />
            </div>

            <asp:Panel ID="pnlResultadosPedidos" runat="server" Visible="false">
                <div class="table-card" style="margin-bottom:12px;">
                    <asp:GridView ID="gvBuscarPedidos" runat="server"
                        AutoGenerateColumns="false"
                        DataKeyNames="PED_PEDIDO"
                        CssClass="table"
                        GridLines="None"
                        OnRowDataBound="gvBuscarPedidos_RowDataBound"
                        OnRowCommand="gvBuscarPedidos_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="ID" ItemStyle-Width="70px">
                                <ItemTemplate><span class="badge-id"><%# Eval("PED_PEDIDO") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="PED_CODIGO" HeaderText="Codigo" />
                            <asp:TemplateField HeaderText="Fecha" ItemStyle-Width="110px">
                                <ItemTemplate><%# String.Format("{0:dd/MM/yyyy}", Eval("PED_FECHA")) %></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Forma Pago" ItemStyle-Width="110px">
                                <ItemTemplate><span class="badge-pago"><%# Eval("PED_FORMA_PAGO") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Productos / Items">
                                <ItemTemplate>
                                    <asp:GridView ID="gvSubItemsBuscar" runat="server"
                                        AutoGenerateColumns="false"
                                        CssClass="sub-items-table"
                                        GridLines="None">
                                        <Columns>
                                            <asp:BoundField DataField="PRODUCTO_NOMBRE" HeaderText="Producto" />
                                            <asp:BoundField DataField="MATERIAL"        HeaderText="Material" />
                                            <asp:TemplateField HeaderText="Cant." ItemStyle-Width="55px">
                                                <ItemTemplate><%# Eval("CANTIDAD") %></ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate><span style="color:#aaa;font-size:11px;">Sin items</span></EmptyDataTemplate>
                                    </asp:GridView>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="" ItemStyle-Width="130px" ItemStyle-VerticalAlign="Top">
                                <ItemTemplate>
                                    <asp:LinkButton CommandName="VerItemsPedido"
                                        CommandArgument='<%# Eval("PED_PEDIDO") & "|" & Eval("PED_CODIGO") %>'
                                        runat="server" CssClass="btn-edit-t"
                                        CausesValidation="false">&#10003; Seleccionar</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state"><p>No se encontraron pedidos.</p></div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlItemsPedido" runat="server" Visible="false">
                <asp:HiddenField ID="hfPedidoVinculado" runat="server" Value="0" />
                <div class="pedido-sel-box">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
                        <div style="font-size:13px; font-weight:bold; color:#276749; font-family:Arial,sans-serif;">
                            &#128203; Pedido #<asp:Label ID="lblPedidoId" runat="server" /> &mdash;
                            <asp:Label ID="lblPedidoCodigo" runat="server" />
                            <span style="font-size:11px; color:#555; font-weight:normal; margin-left:8px;">
                                Ingresa el precio de compra para cada item
                            </span>
                        </div>
                        <asp:LinkButton ID="lnkQuitarPedido" runat="server"
                            CssClass="btn-del-t" CausesValidation="false"
                            OnClick="lnkQuitarPedido_Click">&#10005; Quitar</asp:LinkButton>
                    </div>
                    <asp:GridView ID="gvItemsPedido" runat="server"
                        AutoGenerateColumns="false"
                        DataKeyNames="DETPE_DETALLE_PEDIDO"
                        CssClass="items-precio-table"
                        GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="PRODUCTO_NOMBRE" HeaderText="Producto" />
                            <asp:BoundField DataField="MATERIAL"        HeaderText="Material" />
                            <asp:TemplateField HeaderText="Forma Pago" ItemStyle-Width="100px">
                                <ItemTemplate><span class="badge-pago"><%# Eval("PED_FORMA_PAGO") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Cantidad" ItemStyle-Width="80px">
                                <ItemTemplate><%# Eval("CANTIDAD") %></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Precio ODP (Q) *" ItemStyle-Width="160px">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtPrecioItem" runat="server"
                                        CssClass="precio-input" placeholder="0.00" Text="" />
                                    <asp:HiddenField ID="hfDetpeId"  runat="server" Value='<%# Eval("DETPE_DETALLE_PEDIDO") %>' />
                                    <asp:HiddenField ID="hfMaterial" runat="server" Value='<%# Eval("MATERIAL") %>' />
                                    <asp:HiddenField ID="hfCantidad" runat="server" Value='<%# Eval("CANTIDAD") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state"><p>Este pedido no tiene items.</p></div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </asp:Panel>
        </div>

        <div class="f-row" style="margin-top:12px;">
            <asp:Button ID="btnGuardar" runat="server" Text="&#10003; Confirmar Orden"
                CssClass="btn-gold" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="&#10005; Cancelar"
                CssClass="btn-outline" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>
</div>
</asp:Panel>

<!-- ====== DETALLE DE ITEMS (solo lectura + eliminar) ====== -->
<asp:Panel ID="pnlDetalleOrden" runat="server" Visible="false">
<div class="form-card">
    <div class="form-card-head">
        <span>&#128230; ITEMS DE LA ORDEN: <asp:Label ID="lblOrdenSeleccionada" runat="server" /></span>
        <asp:Button ID="btnCerrarDetalle" runat="server" Text="X Cerrar"
            CssClass="btn-outline" OnClick="btnCerrarDetalle_Click" CausesValidation="false"
            style="background:transparent;color:#f0d9a0;border-color:#f0d9a0;" />
    </div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfOrdenActiva" runat="server" />
        <div class="table-card">
            <asp:GridView ID="gvItemsOrden" runat="server"
                AutoGenerateColumns="false"
                DataKeyNames="ODP_ORDEN_DETALLE_PEDIDO"
                CssClass="table"
                GridLines="None"
                OnRowCommand="gvItemsOrden_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="Pedido" ItemStyle-Width="80px">
                        <ItemTemplate><span class="badge-id"><%# Eval("PED_PEDIDO") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Producto">
                        <ItemTemplate><%# Eval("PRO_NOMBRE") %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Forma Pago" ItemStyle-Width="110px">
                        <ItemTemplate><span class="badge-pago"><%# Eval("PED_FORMA_PAGO") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Material">
                        <ItemTemplate><%# Eval("ODP_MATERIAL") %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Precio" ItemStyle-Width="110px">
                        <ItemTemplate>Q <%# String.Format("{0:N2}", Eval("ODP_PRECIO")) %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Cantidad" ItemStyle-Width="80px">
                        <ItemTemplate><%# Eval("ODP_CANTIDAD") %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Subtotal" ItemStyle-Width="110px">
                        <ItemTemplate>Q <%# String.Format("{0:N2}", Convert.ToDecimal(Eval("ODP_PRECIO")) * Convert.ToDecimal(Eval("ODP_CANTIDAD"))) %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="120px">
                        <ItemTemplate>
                            <div class="actions-cell">
                                <asp:LinkButton CommandName="BorrarItem"
                                    CommandArgument='<%# Eval("ODP_ORDEN_DETALLE_PEDIDO") %>'
                                    runat="server" CssClass="btn-del-t"
                                    OnClientClick="return confirm('Eliminar este item?');">&#128465; Eliminar</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state"><p>No hay items en esta orden.</p></div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
        <div class="total-box">
            <span>Total: Q <asp:Label ID="lblTotalOrden" runat="server" Text="0.00" /></span>
            <asp:Button ID="btnFinalizarOrden" runat="server"
                Text="&#10005; Cerrar"
                CssClass="btn-outline"
                OnClick="btnFinalizarOrden_Click"
                CausesValidation="false" />
        </div>
    </div>
</div>
</asp:Panel>

</asp:Content>
