<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Registro.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.Cliente.Registro"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .reg-wrap { max-width: 680px; margin: 40px auto; padding: 0 16px; }
    .reg-card { background: white; border-radius: 16px; border: 1px solid #e8d8c0;
        box-shadow: 0 4px 20px rgba(92,58,30,0.08); overflow: hidden; }
    .reg-head { background: linear-gradient(135deg,#5C3A1E,#8B5E3C); padding: 24px 30px; }
    .reg-head h2 { color: #f0d9a0; font-family: Georgia,serif; font-size: 20px; margin: 0; }
    .reg-head p  { color: #d4b896; font-family: Arial,sans-serif; font-size: 13px; margin: 4px 0 0; }
    .reg-body { padding: 28px 30px; }
    .sec-title { font-size: 11px; font-weight: bold; text-transform: uppercase;
        letter-spacing: 0.8px; color: #C9973A; font-family: Arial,sans-serif;
        margin: 20px 0 12px; border-bottom: 1px solid #f5ece0; padding-bottom: 6px; }
    .sec-title:first-child { margin-top: 0; }
    .f-row { display: flex; gap: 12px; flex-wrap: wrap; }
    .f-group { display: flex; flex-direction: column; gap: 5px; flex: 1; min-width: 180px; margin-bottom: 12px; }
    .f-group label { font-size: 11px; font-weight: bold; color: #5C3A1E;
        text-transform: uppercase; letter-spacing: 0.4px; font-family: Arial,sans-serif; }
    .f-group .form-control { padding: 10px 14px; border: 2px solid #e8d8c0;
        border-radius: 8px; font-size: 14px; background: #fdf8f3; outline: none;
        width: 100%; box-sizing: border-box; font-family: Arial,sans-serif; }
    .f-group .form-control:focus { border-color: #C9973A; background: white; }
    .btn-registrar { width: 100%; background: linear-gradient(135deg,#C9973A,#a87a2e);
        color: white; border: none; padding: 14px; border-radius: 8px; font-size: 15px;
        font-weight: bold; cursor: pointer; font-family: Arial,sans-serif; margin-top: 8px; }
    .btn-registrar:hover { background: linear-gradient(135deg,#a87a2e,#7a5818); }
    .reg-footer { text-align: center; padding: 16px 30px 24px;
        font-family: Arial,sans-serif; font-size: 13px; color: #888;
        border-top: 1px solid #f5ece0; }
    .reg-footer a { color: #C9973A; text-decoration: none; font-weight: bold; }
    .alert-ok  { padding: 12px 16px; border-radius: 8px; font-size: 13px;
        background: #f0fff4; color: #276749; border-left: 4px solid #48bb78;
        margin-bottom: 16px; font-family: Arial,sans-serif; }
    .alert-err { padding: 12px 16px; border-radius: 8px; font-size: 13px;
        background: #fff5f5; color: #c53030; border-left: 4px solid #fc8181;
        margin-bottom: 16px; font-family: Arial,sans-serif; }
</style>

<div class="reg-wrap">
    <div class="reg-card">
        <div class="reg-head">
            <h2>🛋️ Crear Cuenta</h2>
            <p>Únete a Muebles Los Alpes</p>
        </div>
        <div class="reg-body">
            <asp:Panel ID="pnlMsg" runat="server" Visible="false">
                <asp:Label ID="lblMsg" runat="server" />
            </asp:Panel>

            <%-- Datos personales --%>
            <div class="sec-title">Datos Personales</div>
            <div class="f-row">
                <div class="f-group">
                    <label>Primer Nombre *</label>
                    <asp:TextBox ID="txtPNombre" runat="server" CssClass="form-control" MaxLength="100" />
                </div>
                <div class="f-group">
                    <label>Segundo Nombre</label>
                    <asp:TextBox ID="txtSNombre" runat="server" CssClass="form-control" MaxLength="100" />
                </div>
            </div>
            <div class="f-row">
                <div class="f-group">
                    <label>Primer Apellido *</label>
                    <asp:TextBox ID="txtPApellido" runat="server" CssClass="form-control" MaxLength="100" />
                </div>
                <div class="f-group">
                    <label>Segundo Apellido</label>
                    <asp:TextBox ID="txtSApellido" runat="server" CssClass="form-control" MaxLength="100" />
                </div>
            </div>
            <div class="f-row">
                <div class="f-group">
                    <label>Tipo Documento *</label>
                    <asp:DropDownList ID="ddlTipoDoc" runat="server" CssClass="form-control">
                        <asp:ListItem Text="DPI" Value="DPI" />
                        <asp:ListItem Text="Pasaporte" Value="PASAPORTE" />
                        <asp:ListItem Text="NIT" Value="NIT" />
                    </asp:DropDownList>
                </div>
                <div class="f-group">
                    <label>Número Documento *</label>
                    <asp:TextBox ID="txtNumDoc" runat="server" CssClass="form-control" MaxLength="50" />
                </div>
            </div>
            <div class="f-row">
                <div class="f-group">
                    <label>Teléfono Principal *</label>
                    <asp:TextBox ID="txtTel1" runat="server" CssClass="form-control" MaxLength="20" />
                </div>
                <div class="f-group">
                    <label>Teléfono Secundario</label>
                    <asp:TextBox ID="txtTel2" runat="server" CssClass="form-control" MaxLength="20" />
                </div>
            </div>
            <div class="f-row">
                <div class="f-group">
                    <label>Profesión</label>
                    <asp:TextBox ID="txtProfesion" runat="server" CssClass="form-control" MaxLength="100" />
                </div>
                <div class="f-group">
                    <label>Tipo Cliente *</label>
                    <asp:DropDownList ID="ddlTipoCliente" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Natural" Value="NATURAL" />
                        <asp:ListItem Text="Jurídica" Value="JURIDICA" />
                    </asp:DropDownList>
                </div>
            </div>

            <%-- Dirección --%>
            <div class="sec-title">Dirección</div>
            <div class="f-row">
                <div class="f-group">
                    <label>País *</label>
                    <asp:TextBox ID="txtPais" runat="server" CssClass="form-control" Text="Guatemala" MaxLength="100" />
                </div>
                <div class="f-group">
                    <label>Departamento *</label>
                    <asp:TextBox ID="txtDepartamento" runat="server" CssClass="form-control" MaxLength="100" />
                </div>
            </div>
            <div class="f-row">
                <div class="f-group">
                    <label>Municipio *</label>
                    <asp:TextBox ID="txtMunicipio" runat="server" CssClass="form-control" MaxLength="100" />
                </div>
                <div class="f-group" style="max-width:120px;">
                    <label>Zona *</label>
                    <asp:TextBox ID="txtZona" runat="server" CssClass="form-control" MaxLength="50" />
                </div>
                <div class="f-group" style="max-width:120px;">
                    <label>Código Postal *</label>
                    <asp:TextBox ID="txtCP" runat="server" CssClass="form-control" MaxLength="20" />
                </div>
            </div>
            <div class="f-group">
                <label>Dirección *</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" MaxLength="255" />
            </div>

            <%-- Cuenta --%>
            <div class="sec-title">Datos de Acceso</div>
            <div class="f-group">
                <label>Email *</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                    TextMode="Email" MaxLength="100" />
            </div>
            <div class="f-row">
                <div class="f-group">
                    <label>Contraseña *</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                        TextMode="Password" MaxLength="100" />
                </div>
            </div>

            <asp:Button ID="btnRegistrar" runat="server" Text="✓ Crear Cuenta"
                CssClass="btn-registrar tiempoInhabilitado" OnClick="btnRegistrar_Click" />
        </div>
        <div class="reg-footer">
            ¿Ya tienes cuenta?
            <a href='<%: ResolveUrl("~/Modules/Cliente/Login.aspx") %>'>Inicia sesión</a>
        </div>
    </div>
</div>
</asp:Content>