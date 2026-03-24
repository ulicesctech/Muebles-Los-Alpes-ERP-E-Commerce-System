<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Productos.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Productos" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header"><h2>Gestión de Productos</h2></div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </asp:Panel>

    <div class="panel panel-default">
        <div class="panel-heading">
            <asp:Label ID="lblTituloForm" runat="server" Text="Nuevo Producto"></asp:Label>
        </div>
        <div class="panel-body">
            <asp:HiddenField ID="hfReferencia" runat="server" Value="" />
            <asp:HiddenField ID="hfModo"       runat="server" Value="C" />
            <div class="row">
                <div class="col-sm-3">
                    <div class="form-group">
                        <label>Referencia <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtReferencia" runat="server" CssClass="form-control" MaxLength="50" placeholder="Ej: MUE-001"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-5">
                    <div class="form-group">
                        <label>Nombre <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-2">
                    <div class="form-group">
                        <label>Color</label>
                        <asp:TextBox ID="txtColor" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-2">
                    <div class="form-group">
                        <label>Peso (kg)</label>
                        <asp:TextBox ID="txtPeso" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <div class="form-group">
                        <label>Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <div class="form-group">
                        <label>Categoría <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-control"
                                          AutoPostBack="true" OnSelectedIndexChanged="ddlCategoria_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-group">
                        <label>Tipo <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-group">
                        <label>Material <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlMaterial" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2">
                    <div class="form-group">
                        <label>Alto (cm)</label>
                        <asp:TextBox ID="txtAlto"        runat="server" CssClass="form-control" placeholder="0"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-2">
                    <div class="form-group">
                        <label>Ancho (cm)</label>
                        <asp:TextBox ID="txtAncho"       runat="server" CssClass="form-control" placeholder="0"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-2">
                    <div class="form-group">
                        <label>Profundidad (cm)</label>
                        <asp:TextBox ID="txtProfundidad" runat="server" CssClass="form-control" placeholder="0"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <label>Foto</label>
                        <asp:FileUpload ID="fuFoto" runat="server" CssClass="form-control" />
                        <small class="text-muted">JPG, PNG o GIF. Dejar vacío para conservar foto actual.</small>
                    </div>
                </div>
            </div>
            <asp:Button ID="btnGuardar"  runat="server" Text="Guardar"  CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-default" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>
    </div>

    <div class="row" style="margin-bottom:10px;">
        <div class="col-sm-6">
            <div class="input-group">
                <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por ref, nombre, tipo, material..."></asp:TextBox>
                <span class="input-group-btn">
                    <asp:Button ID="btnBuscar"  runat="server" Text="Buscar"  CssClass="btn btn-default" OnClick="btnBuscar_Click"  CausesValidation="false" />
                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-default" OnClick="btnLimpiar_Click" CausesValidation="false" />
                </span>
            </div>
        </div>
    </div>

    <asp:GridView ID="gvProductos" runat="server"
                  AutoGenerateColumns="false"
                  CssClass="table table-bordered table-hover table-striped"
                  OnRowCommand="gvProductos_RowCommand"
                  EmptyDataText="No hay productos registrados.">
        <Columns>
            <asp:BoundField DataField="PRO_REFERENCIA" HeaderText="Referencia" ItemStyle-Width="100px" />
            <asp:BoundField DataField="PRO_NOMBRE"     HeaderText="Nombre"     />
            <asp:BoundField DataField="TIP_DESCRIPCION" HeaderText="Tipo"     ItemStyle-Width="120px" />
            <asp:BoundField DataField="MAT_DESCRIPCION" HeaderText="Material" ItemStyle-Width="120px" />
            <asp:BoundField DataField="PRO_COLOR"      HeaderText="Color"      ItemStyle-Width="90px" />
            <asp:BoundField DataField="PRO_PESO"       HeaderText="Peso (kg)"  ItemStyle-Width="80px" />
            <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="160px" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:LinkButton CommandName="Editar"   CommandArgument='<%# Eval("PRO_REFERENCIA") %>' runat="server" CssClass="btn btn-xs btn-warning">
                        <span class="glyphicon glyphicon-pencil"></span> Editar
                    </asp:LinkButton>&nbsp;
                    <asp:LinkButton CommandName="Eliminar" CommandArgument='<%# Eval("PRO_REFERENCIA") %>' runat="server" CssClass="btn btn-xs btn-danger"
                                    OnClientClick="return confirm('¿Eliminar este producto?');">
                        <span class="glyphicon glyphicon-trash"></span> Eliminar
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>