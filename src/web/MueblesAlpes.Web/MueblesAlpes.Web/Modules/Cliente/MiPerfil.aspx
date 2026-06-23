<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="MiPerfil.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.Cliente.MiPerfil"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    * { box-sizing: border-box; }
    .hero { background: linear-gradient(135deg,#5C3A1E,#8B5E3C);
        padding: 28px 30px; border-radius: 14px; margin-bottom: 24px; }
    .hero-title { color: #f0d9a0; font-size: 24px; font-family: Georgia,serif; margin: 0; }
    .hero-sub { color: #d4b896; font-size: 13px; font-family: Arial,sans-serif; margin: 4px 0 0; }
    .perfil-card { background: white; border-radius: 12px; border: 1px solid #e8d8c0;
        box-shadow: 0 2px 8px rgba(92,58,30,0.06); overflow: hidden; margin-bottom: 20px; }
    .perfil-card-head { background: linear-gradient(135deg,#5C3A1E,#8B5E3C); padding: 14px 20px; }
    .perfil-card-head span { color: #f0d9a0; font-size: 14px; font-weight: bold; font-family: Arial,sans-serif; }
    .perfil-card-body { padding: 24px; }
    .f-row { display: flex; gap: 16px; flex-wrap: wrap; margin-bottom: 16px; }
    .f-group { display: flex; flex-direction: column; gap: 5px; flex: 1; min-width: 200px; }
    .f-group label { font-size: 11px; font-weight: bold; color: #5C3A1E;
        text-transform: uppercase; letter-spacing: 0.4px; font-family: Arial,sans-serif; }
    .f-group .form-control { padding: 10px 14px; border: 2px solid #e8d8c0;
        border-radius: 8px; font-size: 14px; background: #fdf8f3; outline: none;
        width: 100%; font-family: Arial,sans-serif; color: #333; }
    .f-group .form-control:focus { border-color: #C9973A; background: white; }
    .btn-guardar { background: linear-gradient(135deg,#276749,#1a4d35);
        color: white; border: none; padding: 12px 28px; border-radius: 8px;
        font-size: 14px; font-weight: bold; cursor: pointer; font-family: Arial,sans-serif; }
    .btn-guardar:hover { background: linear-gradient(135deg,#1a4d35,#0f3020); }
    .alert-ok { padding: 12px 18px; border-radius: 8px; font-size: 13px; margin-bottom: 20px;
        background: #f0fff4; color: #276749; border-left: 4px solid #48bb78; font-family: Arial,sans-serif; }
    .alert-err { padding: 12px 18px; border-radius: 8px; font-size: 13px; margin-bottom: 20px;
        background: #fff5f5; color: #c53030; border-left: 4px solid #fc8181; font-family: Arial,sans-serif; }
    .no-login { text-align: center; padding: 60px 20px; font-family: Arial,sans-serif; color: #555; }
    .no-login .icon { font-size: 64px; margin-bottom: 12px; }
    .btn-login { display: inline-block; margin-top: 16px; padding: 12px 28px;
        background: linear-gradient(135deg,#5C3A1E,#8B5E3C); color: white;
        border-radius: 8px; text-decoration: none; font-weight: bold;
        font-family: Arial,sans-serif; font-size: 14px; }
</style>

<div class="hero">
    <div class="hero-title"> Mi Perfil</div>
    <div class="hero-sub">Gestiona tus datos personales</div>
</div>

<asp:Panel ID="pnlNoLogin" runat="server" Visible="false">
    <div class="no-login">
        <div class="icon">🔒</div>
        <p>Debes iniciar sesión para ver tu perfil.</p>
        <a href="/Modules/Cliente/Login.aspx?returnUrl=/Modules/Cliente/MiPerfil.aspx"
           class="btn-login">Iniciar sesión</a>
    </div>
</asp:Panel>

<asp:Panel ID="pnlPerfil" runat="server" Visible="false">

    <asp:Panel ID="pnlMsg" runat="server" Visible="false">
        <asp:Label ID="lblMsg" runat="server" />
    </asp:Panel>

    <div class="perfil-card">
        <div class="perfil-card-head"><span>🪪 Identificación</span></div>
        <div class="perfil-card-body">
            <div class="f-row">
                <div class="f-group">
                    <label>Tipo de documento</label>
                    <asp:DropDownList ID="ddlTipoDoc" runat="server" CssClass="form-control">
                        <asp:ListItem Text="DPI" Value="DPI" />
                        <asp:ListItem Text="Cédula de vecindad" Value="CEDULA" />
                        <asp:ListItem Text="Pasaporte" Value="PASAPORTE" />
                        <asp:ListItem Text="NIT" Value="NIT" />
                    </asp:DropDownList>
                </div>
                <div class="f-group">
                    <label>Número de documento</label>
                    <asp:TextBox ID="txtNumDoc" runat="server" CssClass="form-control" />
                </div>
                <div class="f-group">
                    <label>NIT</label>
                    <asp:TextBox ID="txtNit" runat="server" CssClass="form-control" placeholder="CF" />
                </div>
            </div>
        </div>
    </div>

    <div class="perfil-card">
        <div class="perfil-card-head"><span> Datos personales</span></div>
        <div class="perfil-card-body">
            <div class="f-row">
                <div class="f-group">
                    <label>Primer nombre</label>
                    <asp:TextBox ID="txtPrimerNombre" runat="server" CssClass="form-control" />
                </div>
                <div class="f-group">
                    <label>Segundo nombre</label>
                    <asp:TextBox ID="txtSegundoNombre" runat="server" CssClass="form-control" />
                </div>
            </div>
            <div class="f-row">
                <div class="f-group">
                    <label>Primer apellido</label>
                    <asp:TextBox ID="txtPrimerApellido" runat="server" CssClass="form-control" />
                </div>
                <div class="f-group">
                    <label>Segundo apellido</label>
                    <asp:TextBox ID="txtSegundoApellido" runat="server" CssClass="form-control" />
                </div>
            </div>
            <div class="f-row">
                <div class="f-group">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                </div>
                <div class="f-group">
                    <label>Profesión</label>
                    <asp:TextBox ID="txtProfesion" runat="server" CssClass="form-control" />
                </div>
            </div>
        </div>
    </div>

    <div class="perfil-card">
        <div class="perfil-card-head"><span> Contacto</span></div>
        <div class="perfil-card-body">
            <div class="f-row">
                <div class="f-group">
                    <label>Teléfono principal</label>
                    <asp:TextBox ID="txtTel1" runat="server" CssClass="form-control" />
                </div>
                <div class="f-group">
                    <label>Teléfono secundario</label>
                    <asp:TextBox ID="txtTel2" runat="server" CssClass="form-control" />
                </div>
            </div>
        </div>
    </div>

    <div class="perfil-card">
        <div class="perfil-card-head"><span> Dirección</span></div>
        <div class="perfil-card-body">
            <div class="f-row">
                <div class="f-group">
                    <label>País</label>
                    <asp:TextBox ID="txtPais" runat="server" CssClass="form-control" />
                </div>
                <div class="f-group">
                    <label>Departamento</label>
                    <asp:TextBox ID="txtDepartamento" runat="server" CssClass="form-control" />
                </div>
                <div class="f-group">
                    <label>Municipio</label>
                    <asp:TextBox ID="txtMunicipio" runat="server" CssClass="form-control" />
                </div>
            </div>
            <div class="f-row">
                <div class="f-group">
                    <label>Zona</label>
                    <asp:TextBox ID="txtZona" runat="server" CssClass="form-control" />
                </div>
                <div class="f-group">
                    <label>Código postal</label>
                    <asp:TextBox ID="txtCodigoPostal" runat="server" CssClass="form-control" />
                </div>
                <div class="f-group" style="flex:2;">
                    <label>Dirección</label>
                    <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" />
                </div>
            </div>
        </div>
    </div>

    <div style="text-align:right; margin-top:8px;">
        <asp:Button ID="btnGuardar" runat="server" Text=" Guardar cambios"
            CssClass="btn-guardar tiempoInhabilitado" OnClick="btnGuardar_Click" />
    </div>

</asp:Panel>

</asp:Content>