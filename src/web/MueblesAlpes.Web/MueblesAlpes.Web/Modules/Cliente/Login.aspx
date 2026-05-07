<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Login.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.Cliente.Login"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .login-wrap { min-height: 70vh; display: flex; align-items: center;
        justify-content: center; padding: 40px 16px; }
    .login-card { background: white; border-radius: 16px; border: 1px solid #e8d8c0;
        box-shadow: 0 8px 32px rgba(92,58,30,0.12); width: 100%; max-width: 420px;
        overflow: hidden; }
    .login-head { background: linear-gradient(135deg,#5C3A1E,#8B5E3C);
        padding: 32px 30px; text-align: center; }
    .login-head .logo { font-size: 48px; margin-bottom: 8px; }
    .login-head h2 { color: #f0d9a0; font-family: Georgia,serif; font-size: 22px; margin: 0; }
    .login-head p  { color: #d4b896; font-family: Arial,sans-serif; font-size: 13px; margin: 6px 0 0; }
    .login-body { padding: 30px; }
    .f-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 16px; }
    .f-group label { font-size: 11px; font-weight: bold; color: #5C3A1E;
        text-transform: uppercase; letter-spacing: 0.5px; font-family: Arial,sans-serif; }
    .f-group .form-control { padding: 12px 14px; border: 2px solid #e8d8c0;
        border-radius: 8px; font-size: 14px; background: #fdf8f3; outline: none;
        width: 100%; box-sizing: border-box; font-family: Arial,sans-serif; }
    .f-group .form-control:focus { border-color: #C9973A; background: white; }
    .btn-login { width: 100%; background: linear-gradient(135deg,#5C3A1E,#8B5E3C);
        color: white; border: none; padding: 14px; border-radius: 8px; font-size: 15px;
        font-weight: bold; cursor: pointer; font-family: Arial,sans-serif; margin-top: 4px; }
    .btn-login:hover { background: linear-gradient(135deg,#3a2010,#5C3A1E); }
    .login-footer { text-align: center; padding: 16px 30px 24px;
        font-family: Arial,sans-serif; font-size: 13px; color: #888;
        border-top: 1px solid #f5ece0; }
    .login-footer a { color: #C9973A; text-decoration: none; font-weight: bold; }
    .login-footer a:hover { text-decoration: underline; }
    .alert-ok  { padding: 12px 16px; border-radius: 8px; font-size: 13px;
        background: #f0fff4; color: #276749; border-left: 4px solid #48bb78;
        margin-bottom: 16px; font-family: Arial,sans-serif; }
    .alert-err { padding: 12px 16px; border-radius: 8px; font-size: 13px;
        background: #fff5f5; color: #c53030; border-left: 4px solid #fc8181;
        margin-bottom: 16px; font-family: Arial,sans-serif; }
</style>

<div class="login-wrap">
    <div class="login-card">
        <div class="login-head">
            <div class="logo">🛋️</div>
            <h2>Muebles Los Alpes</h2>
            <p>Inicia sesión en tu cuenta</p>
        </div>
        <div class="login-body">
            <asp:Panel ID="pnlMsg" runat="server" Visible="false">
                <asp:Label ID="lblMsg" runat="server" />
            </asp:Panel>
                <div class="f-group">
                    <label>Usuario o Email</label>
                    <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control"
                        placeholder="Tu usuario o email" MaxLength="100" />
                </div>
            <div class="f-group">
                <label>Contraseña</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                    TextMode="Password" placeholder="Tu contraseña" MaxLength="100" />
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión"
                CssClass="btn-login" OnClick="btnLogin_Click" />
        </div>
        <div class="login-footer">
            ¿No tienes cuenta?
            <a href='<%: ResolveUrl("~/Modules/Cliente/Registro.aspx") %>'>Regístrate aquí</a>
        </div>
    </div>
</div>
</asp:Content>