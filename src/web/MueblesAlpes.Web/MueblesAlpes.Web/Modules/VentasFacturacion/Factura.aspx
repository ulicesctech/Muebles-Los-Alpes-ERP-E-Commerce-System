<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Factura.aspx.vb" Inherits="MueblesAlpes.Web.Modules.VentasFacturacion.Factura" MasterPageFile="~/Site.Master" %>

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

        .page-header {
            margin-bottom: 22px;
            border-bottom: 2px solid var(--dorado);
            padding-bottom: 10px;
        }

        .page-header h2 {
            margin: 0;
            color: var(--cafe-medio);
            font-weight: 600;
            letter-spacing: .3px;
        }

        .panel-factura {
            background: linear-gradient(180deg, #fcf8f2 0%, #f7efe3 100%);
            border: 1px solid var(--borde);
            border-radius: 14px;
            margin-bottom: 24px;
            box-shadow: var(--sombra);
            overflow: hidden;
        }

        .panel-factura-header {
            background: linear-gradient(180deg, #7a4a22 0%, #5c3a1e 100%);
            color: #f4ddb0;
            font-weight: 600;
            padding: 12px 18px;
            font-size: 18px;
        }

        .panel-factura-body {
            padding: 22px;
        }

        .form-label-custom {
            color: var(--cafe-medio);
            font-weight: 700;
            margin-bottom: 8px;
            display: block;
        }

        .input-ui,
        .select-ui {
            border: 1.5px solid var(--borde);
            border-radius: 10px;
            padding: 11px 14px;
            width: 100%;
            font-size: 14px;
            color: var(--texto);
            background: #fffdf9;
            outline: none;
            transition: all .2s ease;
            box-sizing: border-box;
        }

        .input-ui:focus,
        .select-ui:focus {
            border-color: var(--dorado);
            box-shadow: 0 0 0 3px rgba(201, 151, 58, 0.15);
            background: #ffffff;
        }

        .input-ui[readonly] {
            background: #f4eee5;
            color: #7a6857;
            cursor: not-allowed;
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
            margin-right: 8px;
        }

        .btn-ui:hover {
            transform: translateY(-1px);
            opacity: .95;
        }

        .btn-principal {
            background: var(--cafe-medio);
            color: #f7deb0 !important;
        }

        .btn-dorado {
            background: #b8892f;
            color: #fff !important;
        }

        .btn-secundario {
            background: var(--gris-btn);
            color: #fff3db !important;
        }

        .tabla-wrap {
            margin-top: 10px;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: var(--sombra);
            border: 1px solid var(--borde);
            background: white;
        }

        .tabla-factura {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
        }

        .tabla-factura th {
            background: linear-gradient(180deg, var(--cafe-medio) 0%, var(--cafe-oscuro) 100%);
            color: #f4ddb0;
            font-weight: 700;
            font-size: 13px;
            text-align: left;
            padding: 14px 12px;
            border: 1px solid #6d4725;
        }

        .tabla-factura td {
            padding: 14px 12px;
            border: 1px solid #eadbc2;
            color: var(--texto);
            vertical-align: middle;
            background: #fffaf3;
        }

        .tabla-factura tr:nth-child(even) td {
            background: #f8efe2;
        }

        .tabla-factura tr:hover td {
            background: #f1e6d6;
            transition: 0.2s;
        }

        .alert {
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 16px;
        }

        .acciones-form {
            margin-top: 8px;
        }

        @media (max-width: 768px) {
            .tabla-factura th,
            .tabla-factura td {
                font-size: 12px;
                padding: 10px 8px;
            }

            .btn-ui {
                margin-bottom: 8px;
            }
        }
    </style>

    <div class="page-header">
        <h2>Facturación</h2>
    </div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </asp:Panel>

    <div class="panel-factura">
        <div class="panel-factura-header">
            <asp:Label ID="lblTituloForm" runat="server" Text="Nueva Factura"></asp:Label>
        </div>

        <div class="panel-factura-body">
            <div class="row">
                <div class="col-sm-4">
                    <div class="form-group">
                        <label class="form-label-custom">Carrito <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlCarrito" runat="server" CssClass="select-ui"></asp:DropDownList>
                    </div>
                </div>

                <div class="col-sm-4">
                    <div class="form-group">
                        <label class="form-label-custom">Empleado <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="select-ui"></asp:DropDownList>
                    </div>
                </div>

                <div class="col-sm-4">
                    <div class="form-group">
                        <label class="form-label-custom">Código Factura</label>
                        <asp:TextBox ID="txtCodigoFactura" runat="server" CssClass="input-ui" ReadOnly="true" placeholder="Generado automáticamente"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="acciones-form">
                <asp:Button ID="btnGuardar" runat="server"
                    Text="🧾 Generar Factura"
                    CssClass="btn-ui btn-dorado tiempoInhabilitado"
                    OnClick="btnGuardar_Click" />

                <asp:Button ID="btnCancelar" runat="server"
                    Text="✖ Cancelar"
                    CssClass="btn-ui btn-secundario tiempoInhabilitado"
                    OnClick="btnCancelar_Click"
                    CausesValidation="false" />
            </div>
        </div>
    </div>

    <div class="tabla-wrap">
        <asp:GridView ID="gvFacturas" runat="server"
            AutoGenerateColumns="false"
            CssClass="tabla-factura"
            EmptyDataText="No hay facturas registradas."
            GridLines="None">
            <HeaderStyle />
            <RowStyle />
            <AlternatingRowStyle />
            <Columns>
    <asp:BoundField DataField="FACLI_CODIGO_FACTURA" HeaderText="Código Factura" ItemStyle-Width="220px" />
    <asp:BoundField DataField="PRE_CORRELATIVO"      HeaderText="Carrito"        ItemStyle-Width="120px" />
    <asp:BoundField DataField="NOMBRE_EMPLEADO"      HeaderText="Empleado"       ItemStyle-Width="200px" />
    <asp:BoundField DataField="FACLI_FECHA"          HeaderText="Fecha"          ItemStyle-Width="220px" />
</Columns>
        </asp:GridView>
    </div>
    <div id="modalStock" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
     background:rgba(0,0,0,0.5); z-index:99999; align-items:center; justify-content:center;">
    <div style="background:white; border-radius:16px; padding:36px; max-width:420px; width:90%;
                text-align:center; box-shadow:0 20px 60px rgba(0,0,0,0.3);">
        <div style="font-size:64px; margin-bottom:12px;"></div>
        <div style="font-size:20px; font-weight:bold; color:#3a2a1a; font-family:Georgia,serif;
                    margin-bottom:10px;">Stock insuficiente</div>
        <div id="modalStockMsg" style="font-size:14px; color:#666; font-family:Arial,sans-serif;
             margin-bottom:24px; line-height:1.6;"></div>
        <button onclick="document.getElementById('modalStock').style.display='none';"
                style="padding:12px 28px; background:linear-gradient(135deg,#5C3A1E,#8B5E3C);
                       color:white; border:none; border-radius:8px; font-family:Arial,sans-serif;
                       font-size:14px; cursor:pointer;">
            Cerrar
        </button>
    </div>
</div>
</asp:Content>