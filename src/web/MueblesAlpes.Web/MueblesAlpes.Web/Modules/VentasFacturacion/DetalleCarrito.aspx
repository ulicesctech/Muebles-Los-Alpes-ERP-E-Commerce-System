<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="DetalleCarrito.aspx.vb" Inherits="MueblesAlpes.Web.Modules.VentasFacturacion.DetalleCarrito" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        :root {
            --cafe-oscuro: #2f1b0f;
            --cafe-medio: #5c3a1e;
            --dorado: #c9973a;
            --borde: #dcc29a;
            --texto: #3a281b;
            --rojo: #8f2d2d;
            --sombra: 0 8px 24px rgba(47, 27, 15, 0.08);
        }

        .page-header { margin-bottom: 22px; border-bottom: 2px solid var(--dorado); padding-bottom: 10px; }
        .page-header h2 { margin: 0; color: var(--cafe-medio); font-weight: 600; }

        .tabla-wrap { border-radius: 14px; overflow: hidden; box-shadow: var(--sombra); border: 1px solid var(--borde); background: white; }

        /* Tabla listado — igual a Carrito.aspx */
        .tabla-carrito { width: 100%; border-collapse: collapse; overflow: hidden; }
        .tabla-carrito th {
            background: linear-gradient(180deg, var(--cafe-medio) 0%, var(--cafe-oscuro) 100%);
            color: #f4ddb0; font-weight: 700; font-size: 13px;
            text-align: center; padding: 14px 12px;
            border: 1px solid #6d4725;
        }
        .tabla-carrito td {
            padding: 14px 12px; border: 1px solid #eadbc2;
            color: var(--texto); vertical-align: middle;
            text-align: center; background: #fffaf3;
        }
        .tabla-carrito tr:nth-child(even) td { background: #f8efe2; }
        .tabla-carrito tr:hover td { background: #fdf6ec; }

        /* Tabla detalle carrito */
        .tabla-detalle { width: 100%; border-collapse: collapse; }
        .tabla-detalle th {
            background: linear-gradient(180deg, var(--cafe-medio) 0%, var(--cafe-oscuro) 100%);
            color: #f4ddb0; font-weight: 700; font-size: 13px;
            text-align: center; padding: 14px 12px;
            border: 1px solid #6d4725;
        }
        .tabla-detalle td {
            padding: 14px 12px; border: 1px solid #eadbc2;
            color: var(--texto); vertical-align: middle;
            text-align: center; background: #fffaf3;
        }
        .tabla-detalle tr:nth-child(even) td { background: #f8efe2; }
        .tabla-detalle tr:hover td { background: #fdf6ec; }

        .badge-total {
            background: linear-gradient(135deg, var(--cafe-medio), var(--cafe-oscuro));
            color: #f4ddb0;
            padding: 5px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 13px;
            display: inline-block;
        }

        .alert { border-radius: 10px; padding: 12px 16px; margin-bottom: 16px; }
    </style>

    <asp:HiddenField ID="hfCarrito" runat="server" />

    <div class="page-header">
        <h2>Detalle de Carritos</h2>
    </div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </asp:Panel>

    <%-- Vista: listado de todos los carritos (sin parámetro URL) --%>
    <asp:Panel ID="pnlListado" runat="server" Visible="false">
        <div class="tabla-wrap">
            <asp:GridView ID="gvListado" runat="server"
                AutoGenerateColumns="false"
                CssClass="tabla-carrito"
                EmptyDataText="No hay carritos registrados."
                GridLines="None">
                <Columns>
                    <asp:BoundField DataField="PRE_CORRELATIVO"  HeaderText="Correlativo"   ItemStyle-Width="150px" />
                    <asp:BoundField DataField="NOMBRE_CLIENTE"   HeaderText="Cliente"       ItemStyle-Width="160px" />
                    <asp:BoundField DataField="PRE_FECHA_INICIO" HeaderText="Fecha"         ItemStyle-Width="110px" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="PRODUCTOS"        HeaderText="Productos"     ItemStyle-HorizontalAlign="Left" />

                    <asp:TemplateField HeaderText="Total" ItemStyle-Width="120px" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <span class="badge-total">Q <%# Eval("PRE_TOTAL", "{0:N2}") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>

    <%-- Vista: detalle de un carrito específico (con ?carrito=ID) --%>
    <asp:Panel ID="pnlDetalle" runat="server" Visible="false">
        <div class="tabla-wrap">
            <asp:GridView ID="gvDetalles" runat="server"
                AutoGenerateColumns="false"
                CssClass="tabla-detalle"
                EmptyDataText="No hay productos en este carrito."
                GridLines="None">
                <Columns>
                    <asp:BoundField DataField="PRE_CORRELATIVO"  HeaderText="Carrito"       ItemStyle-Width="110px" />
                    <asp:BoundField DataField="NOMBRE_CLIENTE"   HeaderText="Cliente" />
                    <asp:BoundField DataField="PRO_REFERENCIA"   HeaderText="Referencia"    ItemStyle-Width="100px" />
                    <asp:BoundField DataField="PRO_NOMBRE"       HeaderText="Producto" />
                    <asp:BoundField DataField="HV_PRECIO_FINAL"  HeaderText="Precio unit."  ItemStyle-Width="110px" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="DETPRE_CANTIDAD"  HeaderText="Cantidad"      ItemStyle-Width="80px" />
                    <asp:BoundField DataField="SUBTOTAL"         HeaderText="Subtotal"      ItemStyle-Width="110px" DataFormatString="{0:N2}" />
                </Columns>
            </asp:GridView>
        </div>
        <div style="text-align:right; margin-top:16px; padding-right:4px;">
            <asp:Label ID="lblTotal" runat="server" Visible="false"
                style="font-size:16px; font-weight:700; color:#5c3a1e;">
            </asp:Label>
        </div>
    </asp:Panel>

</asp:Content>
