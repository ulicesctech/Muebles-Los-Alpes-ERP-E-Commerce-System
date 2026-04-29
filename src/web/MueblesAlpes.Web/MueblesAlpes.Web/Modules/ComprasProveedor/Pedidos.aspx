<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Pedidos.aspx.vb"
        Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.Pedidos"
        MasterPageFile="~/Site.Master"
        ContentType="text/html" ResponseEncoding="utf-8" %>
<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<meta charset="utf-8" />
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .page-title { font-size:22px; color:#5C3A1E; font-family:Georgia,serif; margin:0 0 20px; }
    .alert-ok  { display:block; margin-bottom:16px; padding:12px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; }
    .alert-err { display:block; margin-bottom:16px; padding:12px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; }
    .form-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; margin-bottom:24px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .form-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:14px 20px; display:flex; justify-content:space-between; align-items:center; }
    .form-card-head span { color:#f0d9a0; font-size:14px; font-weight:bold; font-family:Arial,sans-serif; }
    .form-card-body { padding:20px; }
    .f-row { display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; }
    .f-group { display:flex; flex-direction:column; gap:6px; flex:1; min-width:160px; }
    .f-group label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:0.5px; }
    .form-control { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3; width:100%; outline:none; box-sizing:border-box; }
    .form-control:focus { border-color:#C9973A; background:white; }
    .form-control-readonly { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; font-family:Arial,sans-serif; background:#f0f0f0; color:#888; width:100%; box-sizing:border-box; cursor:not-allowed; }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:white; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); }
    .btn-green { background:linear-gradient(135deg,#276749,#1a4d35); color:white; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-green:hover { background:linear-gradient(135deg,#1a4d35,#0f3020); }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; cursor:pointer; white-space:nowrap; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; box-shadow:0 2px 8px rgba(92,58,30,0.06); margin-top:10px; }
    .table-card table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; }
    .table-card thead tr { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); }
    .table-card thead th { padding:12px 16px; color:#f0d9a0; font-size:11px; font-weight:bold; text-transform:uppercase; letter-spacing:0.5px; text-align:left; }
    .table-card tbody tr { border-bottom:1px solid #f5ece0; }
    .table-card tbody tr:last-child { border-bottom:none; }
    .table-card tbody td { padding:12px 16px; font-size:13px; color:#444; vertical-align:top; }
    .badge-id   { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; display:inline-block; }
    .badge-pago { background:#eef6ff; color:#2b6cb0; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; border:1px solid #bee3f8; display:inline-block; }
    .actions-cell { display:flex; gap:6px; align-items:center; }
    .btn-edit-t   { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-edit-t:hover { background:#C9973A; color:white; border-color:#C9973A; }
    .btn-del-t    { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-del-t:hover { background:#e53e3e; color:white; border-color:#e53e3e; }
    .btn-save-t   { background:#f0fff4; color:#276749; border:1px solid #9ae6b4; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; white-space:nowrap; }
    .btn-save-t:hover { background:#276749; color:white; }
    .btn-cancel-t { background:#f7fafc; color:#4a5568; border:1px solid #cbd5e0; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; white-space:nowrap; }
    .btn-cancel-t:hover { background:#4a5568; color:white; }
    .btn-precio-t { background:#fdf6ec; color:#8B5E3C; border:1px solid #e8d8c0; padding:5px 12px; border-radius:6px; font-size:12px; font-weight:bold; cursor:pointer; text-decoration:none; display:inline-block; white-space:nowrap; }
    .btn-precio-t:hover { background:#8B5E3C; color:white; }
    .add-item-box { background:#fdf8f3; padding:15px; border-radius:10px; border:1px solid #e8d8c0; margin-bottom:15px; }
    .cabecera-info { background:#fdf8f3; border:1px solid #e8d8c0; border-radius:8px; padding:12px 16px; margin-bottom:14px; display:flex; gap:24px; flex-wrap:wrap; align-items:flex-end; font-family:Arial,sans-serif; font-size:13px; color:#5C3A1E; }
    .cabecera-info strong { font-size:11px; text-transform:uppercase; letter-spacing:.4px; color:#8B5E3C; display:block; margin-bottom:4px; }
    .section-label { font-size:12px; font-weight:bold; color:#5C3A1E; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:10px; }
    .empty-state { text-align:center; padding:40px 20px; color:#aaa; font-family:Arial,sans-serif; }
    .recibir-box { margin-top:8px; padding:12px 14px; background:#f0fff4; border:1px solid #9ae6b4; border-radius:8px; font-family:Arial,sans-serif; }
    .recibir-fila { display:flex; gap:10px; align-items:flex-end; flex-wrap:wrap; margin-bottom:10px; }
    .recibir-campo { display:flex; flex-direction:column; gap:4px; }
    .recibir-campo label { font-size:10px; font-weight:bold; color:#276749; text-transform:uppercase; letter-spacing:0.4px; }
    .recibir-readonly { padding:7px 10px; border:2px solid #c6f6d5; border-radius:6px; font-size:13px; font-family:Arial,sans-serif; background:#e6ffed; color:#276749; font-weight:bold; width:80px; box-sizing:border-box; text-align:center; }
    .recibir-suma  { padding:7px 8px; font-size:18px; color:#276749; font-weight:bold; align-self:flex-end; margin-bottom:2px; }
    .recibir-input { padding:7px 10px; border:2px solid #9ae6b4; border-radius:6px; font-size:13px; font-family:Arial,sans-serif; background:white; width:80px; box-sizing:border-box; outline:none; }
    .recibir-input:focus { border-color:#276749; }
    .recibir-igual { padding:7px 8px; font-size:18px; color:#276749; font-weight:bold; align-self:flex-end; margin-bottom:2px; }
    .recibir-total { padding:7px 10px; border:2px solid #276749; border-radius:6px; font-size:13px; font-family:Arial,sans-serif; background:#f0fff4; color:#276749; font-weight:bold; width:80px; box-sizing:border-box; text-align:center; }
    .recibir-nota  { font-size:11px; color:#276749; font-style:italic; margin-bottom:10px; }
    .info-nota     { font-size:11px; color:#8B5E3C; font-style:italic; margin-top:4px; font-family:Arial,sans-serif; }
    .edit-input    { padding:7px 10px; border:2px solid #C9973A; border-radius:6px; font-size:13px; font-family:Arial,sans-serif; background:white; width:100%; box-sizing:border-box; outline:none; }
    .sub-ped-table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; font-size:12px; margin-top:6px; }
    .sub-ped-table thead tr { background:#f5ece0; }
    .sub-ped-table thead th { padding:5px 10px; color:#5C3A1E; font-size:10px; font-weight:bold; text-transform:uppercase; letter-spacing:0.4px; text-align:left; border-bottom:1px solid #e8d8c0; }
    .sub-ped-table tbody tr { border-bottom:1px solid #fdf6ec; }
    .sub-ped-table tbody tr:last-child { border-bottom:none; }
    .sub-ped-table tbody td { padding:5px 10px; color:#555; }
    .badge-pendiente { color:#aaa; font-size:11px; font-style:italic; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>&#127968; Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Index.aspx") %>'>&#128722; Compras</a> /
    <strong style="color:#5C3A1E;">Pedidos</strong>
</div>
<div class="page-title">&#128203; Gestion de Pedidos</div>

<asp:Panel ID="pnlMsg" runat="server" Visible="false">
    <asp:Label ID="lblMsg" runat="server" />
</asp:Panel>

<!-- LISTADO -->
<div class="form-card">
    <div class="form-card-head">
        <span>&#128230; LISTADO DE PEDIDOS</span>
        <asp:Button ID="btnNuevoPedido" runat="server" Text="+ Nuevo Pedido"
            CssClass="btn-gold" OnClick="btnNuevoPedido_Click" />
    </div>
    <div class="form-card-body">
        <div class="f-row" style="margin-bottom:15px;">
            <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control"
                placeholder="Buscar por codigo..." style="flex:3;" />
            <asp:Button ID="btnBuscar"  runat="server" Text="Buscar"  CssClass="btn-gold"    OnClick="btnBuscar_Click" />
            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-outline" OnClick="btnLimpiar_Click" />
        </div>
        <div class="table-card">
            <asp:GridView ID="gvPedidos" runat="server"
                AutoGenerateColumns="false"
                DataKeyNames="PED_PEDIDO"
                CssClass="table"
                GridLines="None"
                OnRowCommand="gvPedidos_RowCommand"
                OnRowDataBound="gvPedidos_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="ID" ItemStyle-Width="75px">
                        <ItemTemplate><span class="badge-id"><%# Eval("PED_PEDIDO") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="PED_CODIGO" HeaderText="Codigo" />
                    <asp:TemplateField HeaderText="Fecha" ItemStyle-Width="110px">
                        <ItemTemplate><%# String.Format("{0:dd/MM/yyyy}", Eval("PED_FECHA")) %></ItemTemplate>
                    </asp:TemplateField>
                    <%-- Forma de pago: valor directo de Oracle, sin comparar ni condicionar --%>
                    <asp:TemplateField HeaderText="Forma Pago" ItemStyle-Width="110px">
                        <ItemTemplate>
                            <span class="badge-pago"><%# Eval("PED_FORMA_PAGO") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Productos / Items">
                        <ItemTemplate>
                            <asp:GridView ID="gvSubProductos" runat="server"
                                AutoGenerateColumns="false"
                                CssClass="sub-ped-table"
                                GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="PRO_NOMBRE" HeaderText="Producto" />
                                    <asp:TemplateField HeaderText="Material">
                                        <ItemTemplate>
                                            <%# If(IsDBNull(Eval("MATERIAL")) OrElse String.IsNullOrEmpty(Eval("MATERIAL").ToString()),
                                                "<span class='badge-pendiente'>—</span>",
                                                Eval("MATERIAL").ToString()) %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Sol." ItemStyle-Width="55px">
                                        <ItemTemplate><%# Eval("DETPE_CANTIDAD_SOLICITADA") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Rec." ItemStyle-Width="55px">
                                        <ItemTemplate><%# Eval("DETPE_CANTIDAD_RECIBIDA") %></ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <span style="color:#aaa;font-size:11px;font-style:italic;">Sin productos</span>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="170px" ItemStyle-VerticalAlign="Top">
                        <ItemTemplate>
                            <div class="actions-cell">
                                <asp:LinkButton CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("PED_PEDIDO") %>'
                                    runat="server" CssClass="btn-edit-t">&#9999; Editar</asp:LinkButton>
                                <asp:LinkButton CommandName="Eliminar"
                                    CommandArgument='<%# Eval("PED_PEDIDO") %>'
                                    runat="server" CssClass="btn-del-t"
                                    OnClientClick="return confirm('Eliminar este pedido?');">&#128465;</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state"><p>No hay pedidos registrados.</p></div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</div>

<!-- FORM NUEVO PEDIDO -->
<asp:Panel ID="pnlFormCabecera" runat="server" Visible="false">
<div class="form-card">
    <div class="form-card-head"><span>&#9999; Nuevo Pedido</span></div>
    <div class="form-card-body">
        <div class="f-row">
            <div class="f-group">
                <label>Codigo</label>
                <div class="form-control-readonly">Se generara automaticamente (ej: PED-12)</div>
            </div>
            <div class="f-group">
                <label>Forma de Pago *</label>
                <asp:DropDownList ID="ddlFormaPago" runat="server"  style="padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px;
           font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3;
           width:100%; outline:none; box-sizing:border-box;" />
            </div>
        </div>
        <div class="f-row" style="margin-top:12px;">
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar y Agregar Productos"
                CssClass="btn-gold" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelarForm" runat="server" Text="Cancelar"
                CssClass="btn-outline" OnClick="btnCancelarForm_Click" CausesValidation="false" />
        </div>
    </div>
</div>
</asp:Panel>

<!-- DETALLE PEDIDO -->
<asp:Panel ID="pnlDetalleContenedor" runat="server" Visible="false">
<div class="form-card">
    <div class="form-card-head">
        <span>&#128230; PRODUCTOS DEL PEDIDO: <asp:Label ID="lblIdSeleccionado" runat="server" /></span>
        <asp:Button ID="btnCerrarDetalle" runat="server" Text="X Cerrar"
            CssClass="btn-outline" OnClick="btnCerrarDetalle_Click" CausesValidation="false"
            style="background:transparent;color:#f0d9a0;border-color:#f0d9a0;" />
    </div>
    <div class="form-card-body">
        <asp:HiddenField ID="hfPedidoActivo"   runat="server" Value="0" />
        <asp:HiddenField ID="hfDetalleRecibir" runat="server" Value="0" />

        <div class="cabecera-info">
            <div><strong>Codigo</strong><asp:Label ID="lblCabeceraCode"  runat="server" /></div>
            <div><strong>Fecha</strong><asp:Label  ID="lblCabeceraFecha" runat="server" /></div>
            <div>
                <strong>Forma de Pago</strong>
                <%-- ddlCabeceraFormaPago se deshabilita en CargarDetallesPedido si el pedido tiene OC --%>
                <asp:DropDownList ID="ddlCabeceraFormaPago" runat="server" CssClass="form-control"
                    style="width:160px; padding:5px 10px; font-size:13px;" />
            </div>
            <div style="display:flex;align-items:flex-end;">
                <%-- btnGuardarCabecera se deshabilita en CargarDetallesPedido si el pedido tiene OC --%>
                <asp:Button ID="btnGuardarCabecera" runat="server" Text="&#10003; Guardar"
                    CssClass="btn-save-t" OnClick="btnGuardarCabecera_Click" CausesValidation="false" />
            </div>
        </div>

        <div class="section-label">&#43; Agregar Producto</div>
        <div class="add-item-box">
            <div class="f-row">
                <div class="f-group" style="flex:3;">
                    <label>Producto *</label>
                    <%-- ddlProducto se deshabilita en CargarDetallesPedido si el pedido tiene OC --%>
                    <asp:DropDownList ID="ddlProducto" runat="server" style="padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px;
           font-size:14px; font-family:Arial,sans-serif; background:#fdf8f3;
           width:100%; outline:none; box-sizing:border-box;" 
                        AutoPostBack="true" OnSelectedIndexChanged="ddlProducto_SelectedIndexChanged" />
                    <div class="info-nota">El precio se asignara al recibir la mercancia desde la Orden de Compra.</div>
                </div>
                <div class="f-group" style="max-width:140px;">
                    <label>Cantidad *</label>
                    <%-- txtCantSolicitada se deshabilita en CargarDetallesPedido si el pedido tiene OC --%>
                    <asp:TextBox ID="txtCantSolicitada" runat="server" CssClass="form-control" placeholder="0" />
                </div>
                <div style="display:flex;align-items:flex-end;">
                    <%-- btnAgregarItem se deshabilita en CargarDetallesPedido si el pedido tiene OC --%>
                    <asp:Button ID="btnAgregarItem" runat="server" Text="+ Agregar"
                        CssClass="btn-gold" OnClick="btnAgregarItem_Click" />
                </div>
            </div>
        </div>

        <div class="table-card">
            <asp:GridView ID="gvDetalles" runat="server"
                AutoGenerateColumns="false"
                DataKeyNames="DETPE_DETALLE_PEDIDO"
                CssClass="table"
                GridLines="None"
                OnRowCommand="gvDetalles_RowCommand"
                OnRowEditing="gvDetalles_RowEditing"
                OnRowCancelingEdit="gvDetalles_RowCancelingEdit"
                OnRowUpdating="gvDetalles_RowUpdating"
                OnRowDataBound="gvDetalles_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="Producto">
                        <ItemTemplate><%# Eval("PRO_NOMBRE") %></ItemTemplate>
                        <EditItemTemplate><%# Eval("PRO_NOMBRE") %></EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Material">
                        <ItemTemplate>
                            <%# If(IsDBNull(Eval("MATERIAL")) OrElse String.IsNullOrEmpty(Eval("MATERIAL").ToString()),
                                "<span class='badge-pendiente'>—</span>", Eval("MATERIAL").ToString()) %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <%# If(IsDBNull(Eval("MATERIAL")) OrElse String.IsNullOrEmpty(Eval("MATERIAL").ToString()),
                                "—", Eval("MATERIAL").ToString()) %>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Solicitado" ItemStyle-Width="100px">
                        <ItemTemplate><%# Eval("DETPE_CANTIDAD_SOLICITADA") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtESolicitada" runat="server" Text="" placeholder="0"
                                CssClass="edit-input" style="width:70px;" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Recibido" ItemStyle-Width="320px">
                        <ItemTemplate>
                            <%# Eval("DETPE_CANTIDAD_RECIBIDA") %>
                            <asp:Panel ID="pnlRecibir" runat="server" Visible="false">
                                <div class="recibir-box">
                                    <div class="recibir-fila">
                                        <div class="recibir-campo">
                                            <label>Ya recibido</label>
                                            <asp:TextBox ID="txtYaRecibido" runat="server"
                                                CssClass="recibir-readonly" ReadOnly="true"
                                                Text='<%# Eval("DETPE_CANTIDAD_RECIBIDA") %>' />
                                        </div>
                                        <div class="recibir-suma">+</div>
                                        <div class="recibir-campo">
                                            <label>Cantidad a agregar *</label>
                                            <asp:TextBox ID="txtCantComplemento" runat="server"
                                                CssClass="recibir-input" placeholder="0" Text="" />
                                        </div>
                                        <div class="recibir-igual">=</div>
                                        <div class="recibir-campo">
                                            <label>Total recibido</label>
                                            <div class="recibir-total">—</div>
                                        </div>
                                    </div>
                                    <div class="recibir-nota">
                                        Solo ingresa la cantidad que llega ahora. El total se acumula automaticamente.
                                    </div>
                                    <div class="actions-cell">
                                        <asp:LinkButton CommandName="ConfirmarRecibido"
                                            CommandArgument='<%# Eval("DETPE_DETALLE_PEDIDO") & "|" & Eval("PRO_REFERENCIA") & "|" & Eval("DETPE_CANTIDAD_SOLICITADA") & "|" & Eval("DETPE_CANTIDAD_RECIBIDA") %>'
                                            runat="server" CssClass="btn-save-t" CausesValidation="false">&#10003; Confirmar</asp:LinkButton>
                                        <asp:LinkButton CommandName="CancelarRecibido"
                                            CommandArgument='<%# Eval("DETPE_DETALLE_PEDIDO") %>'
                                            runat="server" CssClass="btn-cancel-t" CausesValidation="false">&#10005; Cancelar</asp:LinkButton>
                                    </div>
                                </div>
                            </asp:Panel>
                        </ItemTemplate>
                        <EditItemTemplate><%# Eval("DETPE_CANTIDAD_RECIBIDA") %></EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="220px">
                        <ItemTemplate>
                            <div class="actions-cell">
                                <%-- ID requerido para que gvDetalles_RowDataBound pueda ocultarlo cuando hay OC --%>
                                <asp:LinkButton ID="btnEditarItem" CommandName="Edit"
                                    runat="server" CssClass="btn-edit-t" CausesValidation="false">&#9999; Editar</asp:LinkButton>
                                <asp:LinkButton CommandName="MarcarRecibido"
                                    CommandArgument='<%# Eval("DETPE_DETALLE_PEDIDO") %>'
                                    runat="server" CssClass="btn-precio-t" CausesValidation="false">&#10003; Recibido</asp:LinkButton>
                                <%-- ID requerido para que gvDetalles_RowDataBound pueda ocultarlo cuando hay OC --%>
                                <asp:LinkButton ID="btnBorrarItem" CommandName="BorrarItem"
                                    CommandArgument='<%# Eval("DETPE_DETALLE_PEDIDO") %>'
                                    runat="server" CssClass="btn-del-t"
                                    OnClientClick="return confirm('Eliminar este producto?');">&#128465;</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <div class="actions-cell">
                                <asp:LinkButton CommandName="Update" runat="server" CssClass="btn-save-t" CausesValidation="false">&#10003; Guardar</asp:LinkButton>
                                <asp:LinkButton CommandName="Cancel" runat="server" CssClass="btn-cancel-t" CausesValidation="false">&#10005; Cancelar</asp:LinkButton>
                            </div>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state"><p>No hay productos en este pedido.</p></div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

        <div class="f-row" style="margin-top:16px;">
            <asp:Button ID="btnFinalizarPedido" runat="server" Text="&#10003; Finalizar Pedido"
                CssClass="btn-green" OnClick="btnFinalizarPedido_Click" />
        </div>
    </div>
</div>
</asp:Panel>

<script type="text/javascript">
    document.addEventListener('input', function (e) {
        if (!e.target.classList.contains('recibir-input')) return;
        var box = e.target.closest('.recibir-box');
        if (!box) return;
        var yaInput = box.querySelector('.recibir-readonly');
        var totalDiv = box.querySelector('.recibir-total');
        if (!yaInput || !totalDiv) return;
        var ya = parseInt(yaInput.value, 10) || 0;
        var complemento = parseInt(e.target.value, 10) || 0;
        totalDiv.textContent = complemento > 0 ? ya + complemento : '—';
    });
</script>

</asp:Content>
