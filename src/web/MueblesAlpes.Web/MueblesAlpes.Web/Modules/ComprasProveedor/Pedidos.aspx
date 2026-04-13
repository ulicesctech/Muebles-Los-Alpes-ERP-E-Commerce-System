<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Pedidos.aspx.vb" Inherits="MueblesAlpes.Web.Modules.ComprasProveedor.Pedidos" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }
    .page-title { font-size:22px; color:#5C3A1E; font-family:Georgia,serif; margin:0 0 20px; }
    .form-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; margin-bottom:24px; box-shadow:0 2px 8px rgba(92,58,30,0.06); }
    .form-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:14px 20px; display:flex; justify-content:space-between; align-items:center; }
    .form-card-head span { color:#f0d9a0; font-size:14px; font-weight:bold; font-family:Arial,sans-serif; }
    .form-card-body { padding:20px; }
    .f-row { display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; }
    .f-group { display:flex; flex-direction:column; gap:6px; flex:1; min-width:180px; }
    .f-group label { font-size:11px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; text-transform:uppercase; }
    .f-group .form-control { padding:10px 14px; border:2px solid #e8d8c0; border-radius:8px; font-size:14px; background:#fdf8f3; width:100%; outline:none; box-sizing:border-box; }
    .f-group .form-control:focus { border-color:#C9973A; }
    .btn-gold  { background:linear-gradient(135deg,#C9973A,#a87a2e); color:white; border:none; padding:10px 20px; border-radius:8px; font-size:13px; font-weight:bold; cursor:pointer; white-space:nowrap; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); }
    .btn-green { background:linear-gradient(135deg,#276749,#1a4d35); color:white; border:none; padding:10px 22px; border-radius:8px; font-size:13px; font-weight:bold; cursor:pointer; white-space:nowrap; }
    .btn-green:hover { background:linear-gradient(135deg,#1a4d35,#0f3020); }
    .btn-recibir { background:linear-gradient(135deg,#2b6cb0,#1a4d80); color:white; border:none; padding:5px 10px; border-radius:6px; font-size:11px; font-weight:bold; cursor:pointer; white-space:nowrap; }
    .btn-recibir:hover { background:linear-gradient(135deg,#1a4d80,#0f3060); }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 18px; border-radius:8px; font-size:13px; cursor:pointer; white-space:nowrap; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .table-card { background:white; border-radius:12px; border:1px solid #e8d8c0; overflow:hidden; margin-bottom:20px; }
    .table-card table { width:100%; border-collapse:collapse; }
    .table-card table th { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); color:#f0d9a0; padding:12px 14px; text-align:left; font-size:11px; font-family:Arial,sans-serif; text-transform:uppercase; letter-spacing:.5px; }
    .table-card table td { padding:10px 14px; font-size:13px; font-family:Arial,sans-serif; color:#3a2a1a; border-bottom:1px solid #f5ede0; vertical-align:top; }
    .table-card table tr:last-child td { border-bottom:none; }
    .table-card table tr:hover td { background:#fdf6ec; }
    .badge-id { background:#fdf6ec; color:#C9973A; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:bold; border:1px solid #e8d8c0; }
    .badge-pago { background:#e6f4ea; color:#276749; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:bold; border:1px solid #b7dfc2; display:inline-block; }
    .badge-pago.credito { background:#fff3e0; color:#7d4a00; border-color:#f6d198; }
    .actions-cell { display:flex; gap:6px; flex-wrap:wrap; }
    .btn-edit-t   { background:#fdf6ec; color:#C9973A; border:1px solid #e8d8c0; padding:5px 10px; border-radius:6px; font-size:11px; font-weight:bold; cursor:pointer; text-decoration:none; white-space:nowrap; }
    .btn-edit-t:hover { background:#C9973A; color:white; }
    .btn-del-t    { background:#fff5f5; color:#e53e3e; border:1px solid #fed7d7; padding:5px 10px; border-radius:6px; font-size:11px; font-weight:bold; cursor:pointer; text-decoration:none; white-space:nowrap; }
    .btn-del-t:hover { background:#e53e3e; color:white; }
    .btn-save-t   { background:#e6f4ea; color:#276749; border:1px solid #b7dfc2; padding:5px 10px; border-radius:6px; font-size:11px; font-weight:bold; cursor:pointer; white-space:nowrap; }
    .btn-cancel-t { background:#f5f5f5; color:#555; border:1px solid #ddd; padding:5px 10px; border-radius:6px; font-size:11px; font-weight:bold; cursor:pointer; white-space:nowrap; }
    .sub-wrap { margin-top:8px; }
    .sub-table { width:100%; border-collapse:collapse; font-family:Arial,sans-serif; font-size:12px; }
    .sub-table thead tr { background:#f5ece0; }
    .sub-table thead th { padding:5px 10px; color:#5C3A1E; font-size:10px; font-weight:bold; text-transform:uppercase; letter-spacing:.4px; text-align:left; border-bottom:1px solid #e8d8c0; }
    .sub-table tbody tr { border-bottom:1px solid #fdf6ec; }
    .sub-table tbody tr:last-child { border-bottom:none; }
    .sub-table tbody td { padding:5px 10px; color:#555; }
    .total-pill { margin-top:7px; padding:5px 12px; background:#fdf6ec; border-radius:6px; border:1px solid #e8d8c0; font-size:12px; font-weight:bold; color:#5C3A1E; font-family:Arial,sans-serif; display:inline-block; }
    .add-item-box { background:#fdfaf6; padding:16px; border-radius:8px; border:1px dashed #C9973A; margin-bottom:16px; }
    .sub-head { font-size:11px; font-weight:bold; color:#8B5E3C; text-transform:uppercase; letter-spacing:.5px; margin:0 0 10px; font-family:Arial,sans-serif; }
    .alert-ok  { display:block; margin-bottom:20px; padding:12px 18px; border-radius:8px; font-size:13px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; }
    .alert-err { display:block; margin-bottom:20px; padding:12px 18px; border-radius:8px; font-size:13px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; }
    .total-bar { display:flex; justify-content:space-between; align-items:center; padding:14px 16px; background:#fdf6ec; border-radius:8px; border:1px solid #e8d8c0; margin-top:12px; }
    .total-bar-label { font-size:13px; font-weight:bold; color:#8B5E3C; font-family:Arial,sans-serif; }
    .total-bar-valor { font-size:22px; font-weight:bold; color:#5C3A1E; font-family:Georgia,serif; }
    .edit-input { padding:6px 10px; border:2px solid #C9973A; border-radius:6px; font-size:13px; font-family:Arial,sans-serif; background:white; width:100%; box-sizing:border-box; outline:none; }
    .cabecera-info { background:#fdf8f3; border:1px solid #e8d8c0; border-radius:8px; padding:12px 16px; margin-bottom:14px; display:flex; gap:24px; flex-wrap:wrap; font-family:Arial,sans-serif; font-size:13px; color:#5C3A1E; }
    .cabecera-info strong { font-size:11px; text-transform:uppercase; letter-spacing:.4px; color:#8B5E3C; display:block; margin-bottom:2px; }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>&#127968; Inicio</a> /
    <a href='<%: ResolveUrl("~/Modules/ComprasProveedor/Index.aspx") %>'>&#128722; Compras</a> /
    <strong style="color:#5C3A1E;">Pedidos</strong>
</div>
<div class="page-title">&#128203; Gestion de Pedidos</div>

<asp:UpdatePanel ID="upMain" runat="server">
<ContentTemplate>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false">
        <asp:Label ID="lblMsg" runat="server" />
    </asp:Panel>

    <%-- BLOQUE 1: LISTADO MAESTRO --%>
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
                    CssClass="table"
                    GridLines="None"
                    DataKeyNames="PED_PEDIDO"
                    OnRowCommand="gvPedidos_RowCommand"
                    OnRowDataBound="gvPedidos_RowDataBound">
                    <Columns>
                        <asp:TemplateField HeaderText="ID" ItemStyle-Width="70px" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <span class="badge-id"><%# Eval("PED_PEDIDO") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Codigo" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate><%# Eval("PED_CODIGO") %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Fecha" ItemStyle-Width="110px" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate><%# String.Format("{0:dd/MM/yyyy}", Eval("PED_FECHA")) %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Forma Pago" ItemStyle-Width="110px" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <span class='badge-pago <%# If(Eval("PED_FORMA_PAGO").ToString() = "CREDITO", "credito", "") %>'>
                                    <%# Eval("PED_FORMA_PAGO") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Productos / Total">
                            <ItemTemplate>
                                <div class="sub-wrap">
                                    <asp:GridView ID="gvSubDetalles" runat="server"
                                        AutoGenerateColumns="false"
                                        CssClass="sub-table"
                                        GridLines="None"
                                        Visible="false">
                                        <Columns>
                                            <asp:BoundField DataField="PRO_NOMBRE" HeaderText="Producto" />
                                            <asp:TemplateField HeaderText="Precio" ItemStyle-Width="90px">
                                                <ItemTemplate>Q <%# String.Format("{0:N2}", Eval("HIP_PRECIO")) %></ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="DETPE_CANTIDAD_SOLICITADA" HeaderText="Solicitado" ItemStyle-Width="80px" />
                                            <asp:BoundField DataField="DETPE_CANTIDAD_RECIBIDA"   HeaderText="Recibido"   ItemStyle-Width="75px" />
                                            <asp:TemplateField HeaderText="Subtotal" ItemStyle-Width="90px">
                                                <ItemTemplate>Q <%# String.Format("{0:N2}", Convert.ToDecimal(Eval("HIP_PRECIO")) * Convert.ToDecimal(Eval("DETPE_CANTIDAD_SOLICITADA"))) %></ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                    <div class="total-pill">
                                        Total: Q <%# String.Format("{0:N2}", Eval("PED_TOTAL")) %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="180px" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <div class="actions-cell">
                                    <asp:LinkButton CommandName="VerDetalle"
                                        CommandArgument='<%# Eval("PED_PEDIDO") %>'
                                        runat="server" CssClass="btn-edit-t">&#128230; Editar</asp:LinkButton>
                                    <asp:LinkButton CommandName="Recibir"
                                        CommandArgument='<%# Eval("PED_PEDIDO") %>'
                                        runat="server" CssClass="btn-recibir"
                                        OnClientClick="return confirm('Marcar como recibido y actualizar stock?');">&#10003; Recibir</asp:LinkButton>
                                    <asp:LinkButton CommandName="Eliminar"
                                        CommandArgument='<%# Eval("PED_PEDIDO") %>'
                                        runat="server" CssClass="btn-del-t"
                                        OnClientClick="return confirm('Eliminar este pedido y sus productos?');">&#128465;</asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="text-align:center; padding:40px; color:#aaa; font-family:Arial,sans-serif;">
                            No hay pedidos registrados.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>

    <%-- BLOQUE 2: FORMULARIO NUEVA CABECERA --%>
    <asp:Panel ID="pnlFormCabecera" runat="server" Visible="false">
        <div class="form-card" style="border-top:4px solid #C9973A;">
            <div class="form-card-head">
                <span>&#9999; Nuevo Pedido</span>
                <asp:Button ID="btnCancelar" runat="server" Text="X Cancelar"
                    CssClass="btn-outline" OnClick="btnCerrarDetalle_Click"
                    style="background:transparent;color:#f0d9a0;border-color:#f0d9a0;" />
            </div>
            <div class="form-card-body">
                <div class="f-row">
                    <div class="f-group">
                        <label>Codigo del Pedido *</label>
                        <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control" placeholder="Ej. PED-001" />
                    </div>
                    <div class="f-group">
                        <label>Forma de Pago *</label>
                        <asp:DropDownList ID="ddlFormaPago" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Contado" Value="CONTADO" />
                            <asp:ListItem Text="Credito" Value="CREDITO" />
                        </asp:DropDownList>
                    </div>
                    <div style="display:flex; align-items:flex-end;">
                        <asp:Button ID="btnGuardar" runat="server" Text="Guardar y Agregar Productos"
                            CssClass="btn-gold" OnClick="btnGuardar_Click" />
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <%-- BLOQUE 3: DETALLE / EDICION DE PRODUCTOS --%>
    <asp:Panel ID="pnlDetalleContenedor" runat="server" Visible="false">
        <div class="form-card" style="border-top:4px solid #8B5E3C;">
            <div class="form-card-head">
                <span>&#128230; PRODUCTOS — PEDIDO:
                    <asp:Label ID="lblIdSeleccionado" runat="server" />
                </span>
                <asp:Button ID="btnCerrarDetalle" runat="server" Text="X Cerrar"
                    CssClass="btn-outline" OnClick="btnCerrarDetalle_Click" CausesValidation="false"
                    style="background:transparent;color:#f0d9a0;border-color:#f0d9a0;" />
            </div>
            <div class="form-card-body">
                <asp:HiddenField ID="hfPedidoActivo" runat="server" Value="0" />
                <div class="cabecera-info">
                    <div><strong>Codigo</strong><asp:Label ID="lblCabeceraCode" runat="server" /></div>
                    <div><strong>Fecha</strong><asp:Label ID="lblCabeceraFecha" runat="server" /></div>
                    <div><strong>Forma de Pago</strong><asp:Label ID="lblCabeceraFormaPago" runat="server" /></div>
                </div>
                <div class="add-item-box">
                    <p class="sub-head">Agregar Producto</p>
                    <div class="f-row">
                        <div class="f-group" style="flex:3;">
                            <label>Producto</label>
                            <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-control" />
                        </div>
                        <div class="f-group" style="max-width:130px;">
                            <label>Cantidad Solicitada</label>
                            <asp:TextBox ID="txtCantSolicitada" runat="server" CssClass="form-control"
                                TextMode="Number" placeholder="0" />
                        </div>
                        <div style="display:flex; align-items:flex-end;">
                            <asp:Button ID="btnAgregarItem" runat="server" Text="+ Anadir"
                                CssClass="btn-gold" OnClick="btnAgregarItem_Click" />
                        </div>
                    </div>
                </div>
                <div class="table-card">
                    <asp:GridView ID="gvDetalles" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="table"
                        GridLines="None"
                        DataKeyNames="DETPE_DETALLE_PEDIDO"
                        OnRowCommand="gvDetalles_RowCommand"
                        OnRowEditing="gvDetalles_RowEditing"
                        OnRowCancelingEdit="gvDetalles_RowCancelingEdit"
                        OnRowUpdating="gvDetalles_RowUpdating">
                        <Columns>
                            <asp:TemplateField HeaderText="Producto">
                                <ItemTemplate><%# Eval("PRO_NOMBRE") %></ItemTemplate>
                                <EditItemTemplate><%# Eval("PRO_NOMBRE") %></EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Precio Unit." ItemStyle-Width="110px">
                                <ItemTemplate>Q <%# String.Format("{0:N2}", Eval("HIP_PRECIO")) %></ItemTemplate>
                                <EditItemTemplate>Q <%# String.Format("{0:N2}", Eval("HIP_PRECIO")) %></EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Solicitado" ItemStyle-Width="110px">
                                <ItemTemplate><%# Eval("DETPE_CANTIDAD_SOLICITADA") %></ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtECantSol" runat="server"
                                        Text='<%# Eval("DETPE_CANTIDAD_SOLICITADA") %>'
                                        CssClass="edit-input" style="width:75px;" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Recibido" ItemStyle-Width="100px">
                                <ItemTemplate><%# Eval("DETPE_CANTIDAD_RECIBIDA") %></ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtECantRec" runat="server"
                                        Text='<%# Eval("DETPE_CANTIDAD_RECIBIDA") %>'
                                        CssClass="edit-input" style="width:75px;" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Subtotal" ItemStyle-Width="110px">
                                <ItemTemplate>
                                    Q <%# String.Format("{0:N2}", Convert.ToDecimal(Eval("DETPE_CANTIDAD_SOLICITADA")) * Convert.ToDecimal(Eval("HIP_PRECIO"))) %>
                                </ItemTemplate>
                                <EditItemTemplate></EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="160px">
                                <ItemTemplate>
                                    <div class="actions-cell">
                                        <asp:LinkButton CommandName="Edit"
                                            runat="server" CssClass="btn-edit-t">&#9999; Editar</asp:LinkButton>
                                        <asp:LinkButton CommandName="BorrarItem"
                                            CommandArgument='<%# Eval("DETPE_DETALLE_PEDIDO") %>'
                                            runat="server" CssClass="btn-del-t"
                                            OnClientClick="return confirm('Quitar este producto?');">&#128465;</asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="actions-cell">
                                        <asp:LinkButton CommandName="Update"
                                            runat="server" CssClass="btn-save-t">&#10003; Guardar</asp:LinkButton>
                                        <asp:LinkButton CommandName="Cancel"
                                            runat="server" CssClass="btn-cancel-t">&#10005; Cancelar</asp:LinkButton>
                                    </div>
                                </EditItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div style="text-align:center; padding:30px; color:#aaa; font-family:Arial,sans-serif;">
                                Sin productos. Agrega el primero arriba.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
                <div class="total-bar">
                    <span class="total-bar-label">TOTAL ACUMULADO:</span>
                    <span class="total-bar-valor">Q <asp:Label ID="lblTotalDetalle" runat="server" Text="0.00" /></span>
                    <asp:Button ID="btnFinalizarPedido" runat="server"
                        Text="&#10003; Finalizar Pedido"
                        CssClass="btn-green"
                        OnClick="btnCerrarDetalle_Click"
                        CausesValidation="false"
                        OnClientClick="return confirm('Finalizar y cerrar este pedido?');" />
                </div>
            </div>
        </div>
    </asp:Panel>

</ContentTemplate>
</asp:UpdatePanel>
</asp:Content>
