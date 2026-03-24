<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Tipos.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Tipos" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h2>Gestión de Tipos</h2>
    </div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </asp:Panel>

    <div class="panel panel-default">
        <div class="panel-heading">
            <asp:Label ID="lblTituloForm" runat="server" Text="Nuevo Tipo"></asp:Label>
        </div>
        <div class="panel-body">
            <asp:HiddenField ID="hfId" runat="server" Value="0" />
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <label>Descripción <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" MaxLength="200" placeholder="Ingrese la descripción"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <label>Categoría <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                </div>
            </div>
            <asp:Button ID="btnGuardar"  runat="server" Text="Guardar"  CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-default" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>

    <div class="row" style="margin-bottom:10px;">
        <div class="col-sm-4">
            <label>Filtrar por Categoría:</label>
            <asp:DropDownList ID="ddlFiltroCategoria" runat="server" CssClass="form-control"
                              AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroCategoria_SelectedIndexChanged">
            </asp:DropDownList>
        </div>
    </div>

    <asp:GridView ID="gvTipos" runat="server"
                  AutoGenerateColumns="false"
                  CssClass="table table-bordered table-hover table-striped"
                  OnRowCommand="gvTipos_RowCommand"
                  EmptyDataText="No hay tipos registrados.">
        <Columns>
            <asp:BoundField DataField="TIP_TIPO"        HeaderText="ID"        ItemStyle-Width="60px" />
            <asp:BoundField DataField="TIP_DESCRIPCION" HeaderText="Tipo"      />
            <asp:BoundField DataField="CATEGORIA"       HeaderText="Categoría" />
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="160px" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:LinkButton CommandName="Editar"   CommandArgument='<%# Eval("TIP_TIPO") %>' runat="server" CssClass="btn btn-xs btn-warning">
                        <span class="glyphicon glyphicon-pencil"></span> Editar
                    </asp:LinkButton>&nbsp;
                    <asp:LinkButton CommandName="Eliminar" CommandArgument='<%# Eval("TIP_TIPO") %>' runat="server" CssClass="btn btn-xs btn-danger"
                                    OnClientClick="return confirm('¿Eliminar este tipo?');">
                        <span class="glyphicon glyphicon-trash"></span> Eliminar
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>