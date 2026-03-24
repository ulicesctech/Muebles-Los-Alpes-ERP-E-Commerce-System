<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Almacenes.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Almacenes" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header"><h2>Gestión de Almacenes</h2></div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </asp:Panel>

    <div class="panel panel-default">
        <div class="panel-heading">
            <asp:Label ID="lblTituloForm" runat="server" Text="Nuevo Almacén"></asp:Label>
        </div>
        <div class="panel-body">
            <asp:HiddenField ID="hfId" runat="server" Value="0" />
            <div class="row">
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Nombre <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtNombre"    runat="server" CssClass="form-control" MaxLength="200" placeholder="Nombre del almacén"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>País <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtPais"      runat="server" CssClass="form-control" MaxLength="100" placeholder="País"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Ubicación <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtUbicacion" runat="server" CssClass="form-control" MaxLength="300" placeholder="Dirección / ubicación"></asp:TextBox>
                    </div>
                </div>
            </div>
            <asp:Button ID="btnGuardar"  runat="server" Text="Guardar"  CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-default" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>

    <asp:GridView ID="gvAlmacenes" runat="server"
                  AutoGenerateColumns="false"
                  CssClass="table table-bordered table-hover table-striped"
                  OnRowCommand="gvAlmacenes_RowCommand"
                  EmptyDataText="No hay almacenes registrados.">
        <Columns>
            <asp:BoundField DataField="ALM_ALMACEN"   HeaderText="ID"        ItemStyle-Width="60px" />
            <asp:BoundField DataField="ALM_NOMBRE"    HeaderText="Nombre"    />
            <asp:BoundField DataField="ALM_PAIS"      HeaderText="País"      ItemStyle-Width="120px" />
            <asp:BoundField DataField="ALM_UBICACION" HeaderText="Ubicación" />
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="160px" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:LinkButton CommandName="Editar"   CommandArgument='<%# Eval("ALM_ALMACEN") %>' runat="server" CssClass="btn btn-xs btn-warning">
                        <span class="glyphicon glyphicon-pencil"></span> Editar
                    </asp:LinkButton>&nbsp;
                    <asp:LinkButton CommandName="Eliminar" CommandArgument='<%# Eval("ALM_ALMACEN") %>' runat="server" CssClass="btn btn-xs btn-danger"
                                    OnClientClick="return confirm('¿Eliminar este almacén?');">
                        <span class="glyphicon glyphicon-trash"></span> Eliminar
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>