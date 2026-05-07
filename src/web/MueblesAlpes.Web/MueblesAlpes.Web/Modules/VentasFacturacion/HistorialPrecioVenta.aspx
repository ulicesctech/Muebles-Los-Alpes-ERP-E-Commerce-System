<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="HistorialPrecioVenta.aspx.vb" Inherits="MueblesAlpes.Web.Modules.VentasFacturacion.HistorialPrecioVenta" MasterPageFile="~/Site.Master" %>

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

        .panel-form {
            background: linear-gradient(180deg, #fcf8f2 0%, #f7efe3 100%);
            border: 1px solid var(--borde);
            border-radius: 14px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--sombra);
        }

        .panel-form h4 { color: var(--cafe-medio); font-weight: 700; margin-bottom: 18px; border-bottom: 1px solid var(--borde); padding-bottom: 10px; }

        .form-label-custom { color: var(--cafe-medio); font-weight: 700; margin-bottom: 6px; display: block; font-size: 13px; }

        .input-ui, .select-ui {
            border: 1.5px solid var(--borde);
            border-radius: 10px;
            padding: 10px 14px;
            width: 100%;
            font-size: 14px;
            color: var(--texto);
            background: #fffdf9;
            outline: none;
            transition: all .2s ease;
        }

        .input-ui:focus, .select-ui:focus {
            border-color: var(--dorado);
            box-shadow: 0 0 0 3px rgba(201, 151, 58, 0.15);
            background: #ffffff;
        }

        .input-ui[readonly] { background: #f3ece0; color: #6b4f35; font-weight: 600; cursor: default; }

        .btn-ui {
            display: inline-block;
            padding: 10px 22px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all .2s ease;
        }
        .btn-ui:hover { transform: translateY(-1px); opacity: .95; }
        .btn-principal { background: var(--cafe-medio); color: #f7deb0 !important; }

        .tabla-wrap { border-radius: 14px; overflow: hidden; box-shadow: var(--sombra); border: 1px solid var(--borde); background: white; }

        .tabla-precios { width: 100%; border-collapse: collapse; }
        .tabla-precios th {
            background: linear-gradient(180deg, var(--cafe-medio) 0%, var(--cafe-oscuro) 100%);
            color: #f4ddb0; font-weight: 700; font-size: 13px;
            text-align: center; padding: 14px 12px;
            border: 1px solid #6d4725;
        }
        .tabla-precios td {
            padding: 13px 12px; border: 1px solid #eadbc2;
            color: var(--texto); vertical-align: middle;
            text-align: center; background: #fffaf3;
        }
        .tabla-precios tr:nth-child(even) td { background: #f8efe2; }
        .tabla-precios tr:hover td { background: #fdf6ec; }

        .badge-precio {
            background: linear-gradient(135deg, var(--cafe-medio), var(--cafe-oscuro));
            color: #f4ddb0;
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 13px;
            display: inline-block;
        }

        .alert { border-radius: 10px; padding: 12px 16px; margin-bottom: 16px; }
    </style>

    <div class="page-header">
        <h2>💰 Historial de Precios de Venta</h2>
    </div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </asp:Panel>

    <asp:HiddenField ID="hfPrecios" runat="server" />

    <%-- FORMULARIO --%>
    <div class="panel-form">
        <h4>Registrar nuevo precio de venta</h4>
        <div class="row">
            <div class="col-sm-4">
                <div class="form-group">
                    <label class="form-label-custom">Producto <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlProducto" runat="server" CssClass="select-ui"
                        onchange="actualizarPrecioCompra(this.value)">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="col-sm-2">
                <div class="form-group">
                    <label class="form-label-custom">Precio de compra vigente</label>
                    <input type="text" id="txtPrecioCompra" class="input-ui" readonly placeholder="—" />
                </div>
            </div>
            <div class="col-sm-2">
                <div class="form-group">
                    <label class="form-label-custom">Porcentaje (%) <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtPorcetaje" runat="server" CssClass="input-ui"
                        placeholder="Ej: 30" oninput="calcularPrecioFinal()">
                    </asp:TextBox>
                </div>
            </div>
            <div class="col-sm-2">
                <div class="form-group">
                    <label class="form-label-custom">Precio de venta final</label>
                    <asp:TextBox ID="txtPrecioFinal" runat="server" CssClass="input-ui" ReadOnly="true" placeholder="—"></asp:TextBox>
                </div>
            </div>
        </div>
        <asp:Button ID="btnRegistrar" runat="server" Text="Registrar precio"
            CssClass="btn-ui btn-principal tiempoInhabilitado" OnClick="btnRegistrar_Click"
            style="margin-top:10px;" />
    </div>

    <%-- TABLA --%>
    <div class="tabla-wrap">
        <asp:GridView ID="gvPrecios" runat="server"
            AutoGenerateColumns="false"
            CssClass="tabla-precios"
            EmptyDataText="No hay precios de venta registrados."
            GridLines="None">
            <Columns>
                <asp:BoundField DataField="PRO_REFERENCIA"  HeaderText="Referencia"       ItemStyle-Width="110px" />
                <asp:BoundField DataField="PRO_NOMBRE"      HeaderText="Producto" />
                <asp:BoundField DataField="PRECIO_COMPRA"   HeaderText="Precio compra"     ItemStyle-Width="120px" DataFormatString="{0:N2}" />
                <asp:BoundField DataField="HV_PORCETAJE"    HeaderText="Porcentaje (%)"    ItemStyle-Width="110px" DataFormatString="{0:N2}" />
                <asp:TemplateField HeaderText="Precio de venta" ItemStyle-Width="130px" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <span class="badge-precio">Q <%# Eval("HV_PRECIO_FINAL", "{0:N2}") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="HV_FECHA_INICIO" HeaderText="Desde"            ItemStyle-Width="110px" DataFormatString="{0:dd/MM/yyyy}" />
            </Columns>
        </asp:GridView>
    </div>

    <script>
        var preciosCompra = {};

        window.onload = function () {
            var hf = document.getElementById('<%= hfPrecios.ClientID %>');
            if (hf && hf.value) {
                try { preciosCompra = JSON.parse(hf.value); } catch (e) { }
            }
            actualizarPrecioCompra(document.getElementById('<%= ddlProducto.ClientID %>').value);
        };

        function actualizarPrecioCompra(ref) {
            var precio = preciosCompra[ref];
            document.getElementById('txtPrecioCompra').value = precio ? parseFloat(precio).toFixed(2) : '';
            calcularPrecioFinal();
        }

        function calcularPrecioFinal() {
            var ref      = document.getElementById('<%= ddlProducto.ClientID %>').value;
            var pct      = parseFloat(document.getElementById('<%= txtPorcetaje.ClientID %>').value);
            var compra   = parseFloat(preciosCompra[ref]);
            var finalTxt = document.getElementById('<%= txtPrecioFinal.ClientID %>');

            if (!isNaN(compra) && !isNaN(pct) && pct >= 0) {
                finalTxt.value = (compra * (1 + pct / 100)).toFixed(2);
            } else {
                finalTxt.value = '';
            }
        }
    </script>

</asp:Content> 
