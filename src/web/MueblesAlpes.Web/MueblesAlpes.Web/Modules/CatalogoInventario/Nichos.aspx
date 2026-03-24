<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Nichos.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Nichos" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header"><h2>Gestión de Nichos</h2></div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </asp:Panel>

    <div class="panel panel-default">
        <div class="panel-heading">
            <asp:Label ID="lblTituloForm" runat="server" Text="Nuevo Nicho"></asp:Label>
        </div>
        <div class="panel-body">
            <asp:HiddenField ID="hfId" runat="server" Value="0" />
            <div class="row">
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Número <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtNumero" runat="server" CssClass="form-control" MaxLength="50" placeholder="Ej: A-001"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Zona <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtZona" runat="server" CssClass="form-control" MaxLength="100" placeholder="Ej: Zona Norte"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label>Característica <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtCaracteristica" runat="server" CssClass="form-control" MaxLength="300" placeholder="Ej: Temperatura controlada"></asp:TextBox>
                    </div>
                </div>
            </div>
            <asp:Button ID="btnGuardar"  runat="server" Text="Guardar"  CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-default" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>

    <asp:GridView ID="gvNichos" runat="server"
                  AutoGenerateColumns="false"
                  CssClass="table table-bordered table-hover table-striped"
                  OnRowCommand="gvNichos_RowCommand"
                  EmptyDataText="No hay nichos registrados.">
        <Columns>
            <asp:BoundField DataField="NIC_NICHO"          HeaderText="ID"             ItemStyle-Width="60px" />
            <asp:BoundField DataField="NIC_NUMERO"         HeaderText="Número"         ItemStyle-Width="100px" />
            <asp:BoundField DataField="NIC_ZONA"           HeaderText="Zona"           ItemStyle-Width="150px" />
            <asp:BoundField DataField="NIC_CARACTERISTICA" HeaderText="Característica" />
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="160px" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:LinkButton CommandName="Editar"   CommandArgument='<%# Eval("NIC_NICHO") %>' runat="server" CssClass="btn btn-xs btn-warning">
                        <span class="glyphicon glyphicon-pencil"></span> Editar
                    </asp:LinkButton>&nbsp;
                    <asp:LinkButton CommandName="Eliminar" CommandArgument='<%# Eval("NIC_NICHO") %>' runat="server" CssClass="btn btn-xs btn-danger"
                                    OnClientClick="return confirm('¿Eliminar este nicho?');">
                        <span class="glyphicon glyphicon-trash"></span> Eliminar
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>