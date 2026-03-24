<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Materiales.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Materiales" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h2>Gestión de Materiales</h2>
    </div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </asp:Panel>

    <div class="panel panel-default">
        <div class="panel-heading">
            <asp:Label ID="lblTituloForm" runat="server" Text="Nuevo Material"></asp:Label>
        </div>
        <div class="panel-body">
            <asp:HiddenField ID="hfId" runat="server" Value="0" />
            <div class="form-group">
                <label>Descripción <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control"
                             MaxLength="200" placeholder="Ingrese la descripción"></asp:TextBox>
            </div>
            <asp:Button ID="btnGuardar"  runat="server" Text="Guardar"  CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-default" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>

    <div class="row" style="margin-bottom:10px;">
        <div class="col-sm-6">
            <div class="input-group">
                <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar..."></asp:TextBox>
                <span class="input-group-btn">
                    <asp:Button ID="btnBuscar"  runat="server" Text="Buscar"  CssClass="btn btn-default" OnClick="btnBuscar_Click"  CausesValidation="false" />
                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-default" OnClick="btnLimpiar_Click" CausesValidation="false" />
                </span>
            </div>
        </div>
    </div>

    <asp:GridView ID="gvMateriales" runat="server"
                  AutoGenerateColumns="false"
                  CssClass="table table-bordered table-hover table-striped"
                  OnRowCommand="gvMateriales_RowCommand"
                  EmptyDataText="No hay materiales registrados.">
        <Columns>
            <asp:BoundField DataField="MAT_MATERIAL"    HeaderText="ID"          ItemStyle-Width="60px" />
            <asp:BoundField DataField="MAT_DESCRIPCION" HeaderText="Descripción" />
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="160px" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:LinkButton CommandName="Editar"   CommandArgument='<%# Eval("MAT_MATERIAL") %>' runat="server" CssClass="btn btn-xs btn-warning">
                        <span class="glyphicon glyphicon-pencil"></span> Editar
                    </asp:LinkButton>&nbsp;
                    <asp:LinkButton CommandName="Eliminar" CommandArgument='<%# Eval("MAT_MATERIAL") %>' runat="server" CssClass="btn btn-xs btn-danger"
                                    OnClientClick="return confirm('¿Eliminar este material?');">
                        <span class="glyphicon glyphicon-trash"></span> Eliminar
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>