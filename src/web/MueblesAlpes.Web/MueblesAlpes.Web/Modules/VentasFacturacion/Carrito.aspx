<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Carrito.aspx.vb" Inherits="MueblesAlpes.Web.Modules.VentasFacturacion.Carrito" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        :root {
            --cafe-oscuro: #2f1b0f;
            --cafe-medio: #5c3a1e;
            --dorado: #c9973a;
            --dorado-suave: #e6c27a;
            --marfil: #f8f3eb;
            --marfil-2: #f3eadc;
            --borde: #dcc29a;
            --texto: #3a281b;
            --rojo: #8f2d2d;
            --gris-btn: #6f5a49;
            --sombra: 0 8px 24px rgba(47, 27, 15, 0.08);
        }

        .page-header { margin-bottom: 22px; border-bottom: 2px solid var(--dorado); padding-bottom: 10px; }
        .page-header h2 { margin: 0; color: var(--cafe-medio); font-weight: 600; letter-spacing: .3px; }

        .panel-carrito {
            background: linear-gradient(180deg, #fcf8f2 0%, #f7efe3 100%);
            border: 1px solid var(--borde);
            border-radius: 14px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--sombra);
        }

        .form-label-custom { color: var(--cafe-medio); font-weight: 700; margin-bottom: 8px; display: block; }

        .select-cliente, .input-carrito {
            border: 1.5px solid var(--borde);
            border-radius: 10px;
            padding: 11px 14px;
            width: 100%;
            font-size: 14px;
            color: var(--texto);
            background: #fffdf9;
            outline: none;
            transition: all .2s ease;
        }

        .select-cliente:focus, .input-carrito:focus {
            border-color: var(--dorado);
            box-shadow: 0 0 0 3px rgba(201, 151, 58, 0.15);
            background: #ffffff;
        }

        .btn-ui {
            display: inline-block;
            padding: 10px 18px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            border: none;
            transition: all .2s ease;
            cursor: pointer;
        }

        .btn-ui:hover { transform: translateY(-1px); opacity: .95; }
        .btn-principal { background: var(--cafe-medio); color: #f7deb0 !important; }
        .btn-dorado { background: var(--dorado); color: #fff !important; }
        .btn-secundario { background: var(--gris-btn); color: #fff3db !important; }
        .btn-peligro { background: var(--rojo); color: #fff !important; }

        .tabla-wrap { margin-top: 12px; border-radius: 14px; overflow: hidden; box-shadow: var(--sombra); border: 1px solid var(--borde); background: white; }

        .tabla-carrito { width: 100%; border-collapse: collapse; overflow: hidden; }
        .tabla-carrito th { background: linear-gradient(180deg, var(--cafe-medio) 0%, var(--cafe-oscuro) 100%); color: #f4ddb0; font-weight: 700; font-size: 13px; text-align: center; padding: 14px 12px; border: 1px solid #6d4725; }
        .tabla-carrito td { padding: 14px 12px; border: 1px solid #eadbc2; color: var(--texto); vertical-align: middle; text-align: center; background: #fffaf3; }
        .tabla-carrito tr:nth-child(even) td { background: #f8efe2; }

        .acciones-carrito { display: flex; flex-wrap: wrap; gap: 6px; justify-content: center; }

        .alert { border-radius: 10px; padding: 12px 16px; margin-bottom: 16px; }

        /* MODAL */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(47, 27, 15, 0.6);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }

        .modal-overlay.activo { display: flex; }

        .modal-box {
            background: linear-gradient(180deg, #fcf8f2 0%, #f7efe3 100%);
            border: 1px solid var(--borde);
            border-radius: 16px;
            padding: 28px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 20px 60px rgba(47, 27, 15, 0.3);
            position: relative;
        }

        .modal-titulo {
            color: var(--cafe-medio);
            font-weight: 600;
            margin-bottom: 20px;
            font-size: 18px;
            border-bottom: 1px solid var(--borde);
            padding-bottom: 12px;
        }

        .modal-titulo .carrito-id { color: var(--dorado); font-weight: 700; }

        @media (max-width: 768px) {
            .tabla-carrito th, .tabla-carrito td { font-size: 12px; padding: 10px 8px; }
            .acciones-carrito { flex-direction: column; }
        }
    </style>

    <div class="page-header">
        <h2>🛒 Carrito de Compras</h2>
    </div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </asp:Panel>

    <div class="panel-carrito">
        <asp:HiddenField ID="hfCarrito" runat="server" Value="" />
        <asp:HiddenField ID="hfModo" runat="server" Value="C" />
        <div class="row">
            <div class="col-sm-6">
                <div class="form-group">
                    <label class="form-label-custom">Cliente <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlCliente" runat="server" CssClass="select-cliente"></asp:DropDownList>
                </div>
            </div>
        </div>
        <asp:Button ID="btnGuardar" runat="server" Text="🛒 Crear Carrito"
            CssClass="btn-ui btn-principal tiempoInhabilitado" OnClick="btnGuardar_Click" style="margin-top:15px;" />
    </div>

    <div class="tabla-wrap">
        <asp:GridView ID="gvCarritos" runat="server"
            AutoGenerateColumns="false"
            CssClass="tabla-carrito"
            OnRowCommand="gvCarritos_RowCommand"
            EmptyDataText="No hay carritos registrados."
            GridLines="None">
            <Columns>
                <asp:BoundField DataField="PRE_CARRITO"      HeaderText="ID"          ItemStyle-Width="50px" />
                <asp:BoundField DataField="PRE_CORRELATIVO"  HeaderText="Correlativo"  ItemStyle-Width="110px" />
                <asp:BoundField DataField="NOMBRE_CLIENTE"   HeaderText="Cliente" />
                <asp:BoundField DataField="PRE_FECHA_INICIO" HeaderText="Fecha"        ItemStyle-Width="130px" />
                <asp:BoundField DataField="PRE_TOTAL"        HeaderText="Total"        ItemStyle-Width="80px" />
                <asp:BoundField DataField="PRODUCTOS"        HeaderText="Productos" />
                <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="260px" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <div class="acciones-carrito">
                            <asp:LinkButton CommandName="VerDetalle"
                                CommandArgument='<%#: Eval("PRE_CARRITO") %>'
                                runat="server" CssClass="btn-ui btn-dorado tiempoInhabilitado">
                                ➕ Agregar
                            </asp:LinkButton>
                            <asp:LinkButton CommandName="VerResumen"
                                CommandArgument='<%#: Eval("PRE_CARRITO") %>'
                                runat="server" CssClass="btn-ui btn-principal tiempoInhabilitado">
                                📋 Resumen
                            </asp:LinkButton>
                            <asp:LinkButton CommandName="Vaciar"
                                CommandArgument='<%#: Eval("PRE_CARRITO") %>'
                                runat="server" CssClass="btn-ui btn-secundario tiempoInhabilitado"
                                OnClientClick="return confirm('¿Vaciar este carrito?');">
                                🗑️ Vaciar
                            </asp:LinkButton>
                            <asp:LinkButton CommandName="Eliminar"
                                CommandArgument='<%#: Eval("PRE_CARRITO") %>'
                                runat="server" CssClass="btn-ui btn-peligro tiempoInhabilitado"
                                OnClientClick="return confirm('¿Eliminar este carrito?');">
                                ❌ Eliminar
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <%-- MODAL --%>
    <div id="modalDetalle" class="modal-overlay">
        <div class="modal-box">
            <asp:Panel ID="pnlDetalle" runat="server">
                <div class="modal-titulo">
                    ➕ Agregar Producto — Carrito:
                    <span class="carrito-id">
                        <asp:Label ID="lblCarritoSeleccionado" runat="server"></asp:Label>
                    </span>
                </div>

                <asp:HiddenField ID="hfCarritoDetalle" runat="server" Value="" />

                <div class="row">
                    <div class="col-sm-7">
                        <div class="form-group">
                            <label class="form-label-custom">Producto <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlProducto" runat="server" CssClass="select-cliente"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-sm-3">
                        <div class="form-group">
                            <label class="form-label-custom">Cantidad <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtCantidad" runat="server" CssClass="input-carrito" Text="1"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div style="margin-top:15px;">
                    <asp:Button ID="btnAgregarProducto" runat="server"
                        Text="➕ Agregar"
                        OnClick="btnAgregarProducto_Click"
                        CssClass="btn-ui btn-dorado tiempoInhabilitado"
                        style="margin-right:10px;" />
                    <asp:Button ID="btnCerrarDetalle" runat="server"
                        Text="✖ Cerrar"
                        OnClick="btnCerrarDetalle_Click"
                        CausesValidation="false"
                        CssClass="btn-ui btn-principal tiempoInhabilitado" />
                </div>

                <div class="tabla-wrap" style="margin-top:20px;">
                    <asp:GridView ID="gvProductosCarrito" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="tabla-carrito"
                        OnRowCommand="gvProductosCarrito_RowCommand"
                        EmptyDataText="No hay productos en este carrito."
                        GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="DETCAR_DETALLE_CARRITO" HeaderText="ID"       ItemStyle-Width="50px" />
                            <asp:BoundField DataField="PRO_REFERENCIA"         HeaderText="Producto" />
                            <asp:BoundField DataField="DETPRE_CANTIDAD"        HeaderText="Cantidad" ItemStyle-Width="80px" />
                            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="120px" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:LinkButton CommandName="EliminarDetalle"
                                        CommandArgument='<%#: Eval("DETCAR_DETALLE_CARRITO") %>'
                                        runat="server" CssClass="btn-ui btn-peligro tiempoInhabilitado"
                                        OnClientClick="return confirm('¿Eliminar este producto?');">
                                        ❌ Eliminar
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>
        </div>
    </div>

    <script>
        function abrirModal() {
            document.getElementById('modalDetalle').classList.add('activo');
        }
        function cerrarModal() {
            document.getElementById('modalDetalle').classList.remove('activo');
        }
    </script>

</asp:Content>