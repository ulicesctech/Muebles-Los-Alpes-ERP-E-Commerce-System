<%@ Page Title="Puestos" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    CodeFile="Puestos.aspx.vb" Inherits="MueblesAlpes.Web.Modules.RH.Puestos" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Gestión de Puestos</h2>

    <asp:HiddenField ID="hfId" runat="server" />

    Nombre:
    <asp:TextBox ID="txtNombre" runat="server" /><br />

    Salario:
    <asp:TextBox ID="txtSalario" runat="server" /><br />

    Descripción:
    <asp:TextBox ID="txtDescripcion" runat="server" /><br /><br />

    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" OnClick="btnGuardar_Click" />
    <asp:Button ID="btnNuevo" runat="server" Text="Nuevo" OnClick="btnNuevo_Click" />

    <br /><br />

    <asp:GridView ID="gvPuestos" runat="server" AutoGenerateColumns="False" OnRowCommand="gvPuestos_RowCommand">
        <Columns>
            <asp:BoundField DataField="pue_puestos" HeaderText="ID" />
            <asp:BoundField DataField="pue_nombre" HeaderText="Nombre" />
            <asp:BoundField DataField="pue_salario" HeaderText="Salario" />
            <asp:BoundField DataField="pue_descripcion" HeaderText="Descripción" />

            <asp:ButtonField ButtonType="Button" CommandName="Editar" Text="Editar" />
            <asp:ButtonField ButtonType="Button" CommandName="Eliminar" Text="Eliminar" />
        </Columns>
    </asp:GridView>

    <br />
    <asp:Label ID="lblMensaje" runat="server" ForeColor="Red"></asp:Label>

</asp:Content>