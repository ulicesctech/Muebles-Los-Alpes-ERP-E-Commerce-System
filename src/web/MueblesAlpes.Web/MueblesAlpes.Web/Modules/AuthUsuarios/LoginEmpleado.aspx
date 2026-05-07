<%@ Page Title="Acceso Empleados" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="LoginEmpleado.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.LoginEmpleadoPage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .le-wrap { max-width:460px; margin:20px auto; padding:0 16px 40px; }
    .back-link { color:#C9973A; font-size:13px; text-decoration:none; font-family:Arial,sans-serif; display:block; margin-bottom:12px; text-align:left; padding-left:0; }
    .back-link:hover { color:#5C3A1E; }
    .le-card { background:white; border-radius:16px; border:1px solid #e8d8c0; box-shadow:0 6px 28px rgba(92,58,30,0.10); overflow:hidden; }
    .le-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:32px 28px; text-align:center; }
    .le-card-head .le-logo { font-size:52px; margin-bottom:10px; }
    .le-card-head h2 { color:#f0d9a0; font-family:Georgia,serif; font-size:22px; margin:0 0 6px; }
    .le-card-head p  { color:#c9a96e; font-size:13px; margin:0; font-family:Arial,sans-serif; }
    .le-card-body { padding:32px 28px; }
    .form-group { margin-bottom:20px; }
    .form-group label { display:block; font-size:12px; font-weight:bold; color:#5C3A1E; margin-bottom:7px; font-family:Arial,sans-serif; letter-spacing:0.3px; }
    .form-control { width:100%; padding:12px 14px; border:1.5px solid #e8d8c0; border-radius:10px; font-size:13px; font-family:Arial,sans-serif; color:#333; box-sizing:border-box; transition:border-color 0.2s, box-shadow 0.2s; background:#fafafa; }
    .form-control:focus { outline:none; border-color:#C9973A; background:white; box-shadow:0 0 0 3px rgba(201,151,58,0.12); }
    .hint-warn { font-size:11px; font-family:Arial,sans-serif; margin-top:6px; padding:5px 10px; background:#fdf6ec; border-left:3px solid #C9973A; border-radius:4px; color:#8B5E3C; }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:13px 40px; border-radius:10px; font-size:14px; font-weight:bold; cursor:pointer; font-family:Arial,sans-serif; letter-spacing:0.3px; transition:all 0.2s; margin-top:4px; display:block; margin-left:auto; margin-right:auto; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; transform:translateY(-1px); box-shadow:0 4px 14px rgba(168,122,46,0.28); }
    .alert-ok  { padding:12px 16px; border-radius:10px; font-size:13px; margin-bottom:18px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; display:block; font-family:Arial,sans-serif; }
    .alert-err { padding:12px 16px; border-radius:10px; font-size:13px; margin-bottom:18px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; display:block; font-family:Arial,sans-serif; }
    .security-badge { display:flex; align-items:center; gap:8px; background:#f8f4ef; border:1px solid #e8d8c0; border-radius:8px; padding:10px 14px; margin-bottom:24px; font-size:12px; color:#8B5E3C; font-family:Arial,sans-serif; }
    .le-footer { text-align:center; margin-top:20px; font-family:Arial,sans-serif; font-size:12px; color:#aaa; }
    .le-footer a { color:#C9973A; text-decoration:none; font-weight:bold; }
    .le-footer a:hover { color:#5C3A1E; }
    .le-divider { border:none; border-top:1px solid #f0e8d8; margin:24px 0; }
    .le-info { background:#fdf8f3; border:1px solid #e8d8c0; border-radius:10px; padding:16px 18px; font-family:Arial,sans-serif; font-size:12px; color:#8B5E3C; }
    .le-info p { margin:0 0 8px; }
    .le-info p:last-child { margin:0; }
    .le-info strong { color:#5C3A1E; }
</style>

<div class="le-wrap">
    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/LoginCliente.aspx") %>' class="back-link">← Volver a Login Cliente</a>

    <div class="le-card">
        <div class="le-card-head">
            <div class="le-logo">👨‍💼</div>
            <h2>Acceso Empleados</h2>
            <p>Portal interno — Muebles Los Alpes</p>
        </div>
        <div class="le-card-body">

            <asp:Label ID="lblMensaje" runat="server" CssClass="alert-ok"  Visible="false" />
            <asp:Label ID="lblError"   runat="server" CssClass="alert-err" Visible="false" />

            <div class="security-badge">
                🔒 <span>Solo personal autorizado</span>
            </div>

            <div class="form-group">
                <label>👤 Usuario * <small style="color:#aaa;font-weight:normal;"></small></label>
                <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control"
                    placeholder="agrega tu usuario/CUI"
                    autocomplete="off" />
            </div>

            <div class="form-group">
                <label>🔑 Contraseña * <small style="color:#aaa;font-weight:normal;"></small></label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                    TextMode="Password" placeholder="sin espacios..."
                    autocomplete="new-password" />
            </div>

            <asp:Button ID="btnIngresar" runat="server" Text="🔑 Ingresar al sistema"
                CssClass="btn-gold tiempoInhabilitado" OnClick="btnLogin_Click" CausesValidation="false" />

            <hr class="le-divider" />
        </div>
    </div>

    <div class="le-footer">
        ¿Eres cliente?
        <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/LoginCliente.aspx") %>'>Acceso Clientes →</a>
    </div>
</div>
</asp:Content>