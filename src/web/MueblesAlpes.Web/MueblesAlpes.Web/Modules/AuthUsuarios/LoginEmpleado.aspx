<%@ Page Title="Acceso Empleados" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="LoginEmpleado.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.LoginEmpleadoPage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .login-wrap { max-width:460px; margin:0 auto; }
    .login-card { background:white; border-radius:14px; border:1px solid #e8d8c0; box-shadow:0 2px 8px rgba(92,58,30,0.08); overflow:hidden; }
    .login-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:24px 28px; }
    .login-head h2 { color:#f0d9a0; font-family:Georgia,serif; font-size:20px; margin:0 0 4px; }
    .login-head p  { color:#c9a96e; font-size:13px; margin:0; font-family:Arial,sans-serif; }
    .login-body { padding:28px; }
    .form-group { margin-bottom:18px; }
    .form-group label { display:block; font-size:13px; font-weight:bold; color:#5C3A1E; margin-bottom:6px; font-family:Arial,sans-serif; }
    .form-control { width:100%; padding:11px 14px; border:1px solid #e8d8c0; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; color:#333; box-sizing:border-box; }
    .form-control:focus { outline:none; border-color:#C9973A; }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:12px 20px; border-radius:8px; font-size:14px; font-weight:bold; cursor:pointer; width:100%; font-family:Arial,sans-serif; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .alert-ok  { padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; font-family:Arial,sans-serif; display:block; }
    .alert-err { padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; font-family:Arial,sans-serif; display:block; }
    .hint-box { background:#fdf6ec; border:1px solid #e8d8c0; border-radius:8px; padding:14px 16px; margin-top:20px; font-family:Arial,sans-serif; font-size:13px; color:#5C3A1E; }
    .hint-box p { margin:0 0 6px; }
    .hint-box p:last-child { margin:0; }
    .back-link { display:inline-block; margin-bottom:20px; color:#C9973A; font-size:13px; font-family:Arial,sans-serif; text-decoration:none; }
    .back-link:hover { text-decoration:underline; }
</style>

<a href='<%: ResolveUrl("~/Modules/AuthUsuarios/LoginCliente.aspx") %>' class="back-link">← Volver a Login Cliente</a>

<div class="login-wrap">
    <div class="login-card">
        <div class="login-head">
            <h2>👨‍💼 Acceso Empleados</h2>
            <p>Ingresa con tu usuario y DPI</p>
        </div>
        <div class="login-body">

            <asp:Label ID="lblError"   runat="server" CssClass="alert-err" Visible="false" />
            <asp:Label ID="lblMensaje" runat="server" CssClass="alert-ok"  Visible="false" />

            <div class="form-group">
                <label>Usuario * <small style="color:#aaa;">(tu primer nombre en minúsculas)</small></label>
                <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control"
                    placeholder="Ej: carlos, maria, juan..." />
            </div>
            <div class="form-group">
                <label>Contraseña * <small style="color:#aaa;">(tu DPI de 13 dígitos)</small></label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                    placeholder="Tu DPI..." TextMode="Password" />
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="🔑 Ingresar"
                CssClass="btn-gold" OnClick="btnLogin_Click" CausesValidation="false" />

            <div class="hint-box">
                <p><strong>Usuario:</strong> tu primer nombre en minúsculas</p>
                <p><strong>Contraseña:</strong> tu DPI (13 dígitos)</p>
                <p><strong>Ejemplo:</strong> Usuario: <em>carlos</em> / Pass: <em>1234567890101</em></p>
            </div>

        </div>
    </div>
</div>
</asp:Content>