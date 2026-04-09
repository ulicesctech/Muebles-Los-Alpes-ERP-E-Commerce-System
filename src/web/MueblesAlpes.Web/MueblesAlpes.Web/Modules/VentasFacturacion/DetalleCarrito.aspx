<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="DetalleCarrito.aspx.vb" Inherits="MueblesAlpes.Web.Modules.VentasFacturacion.DetalleCarrito" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header"><h2>Detalle del Carrito</h2></div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </asp:Panel>

    <div class="panel panel-default">
        <div class="panel-heading">
            <asp:Label ID="lblTituloForm" runat="server" Text="Agregar Producto al Carrito"></asp:Label>
        </div>
        <div class="panel-body">
            <asp:HiddenField ID="hfDetalle" runat="server" Value="" />
            <div class="row">
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Carrito <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlCarrito" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Producto <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Cantidad <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" placeholder="1"></asp:TextBox>
                    </div>
                </div>
            </div>
            <asp:Button ID="btnGuardar"  runat="server" Text="Agregar"  CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-default" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>

    <asp:GridView ID="gvDetalles" runat="server"
                  AutoGenerateColumns="false"
                  CssClass="table table-bordered table-hover table-striped"
                  EmptyDataText="No hay productos en el carrito.">
        <Columns>
            <asp:BoundField DataField="PRE_CORRELATIVO"  HeaderText="Carrito"        ItemStyle-Width="100px" />
            <asp:BoundField DataField="PRODUCTOS"        HeaderText="Productos" />
            <asp:BoundField DataField="TOTAL_CANTIDAD"   HeaderText="Cantidad Total"  ItemStyle-Width="100px" />
        </Columns>
    </asp:GridView>

</asp:Content>