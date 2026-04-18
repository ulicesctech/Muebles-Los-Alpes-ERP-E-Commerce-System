<%@ Page Title="Acceso Clientes" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="LoginCliente.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.LoginClientePage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .lc-wrap { max-width:500px; margin:20px auto; padding:0 16px 40px; }
    .back-link { color:#C9973A; font-size:13px; text-decoration:none; font-family:Arial,sans-serif; display:block; margin-bottom:12px; text-align:left; }
    .back-link:hover { color:#5C3A1E; }
    .lc-card { background:white; border-radius:16px; border:1px solid #e8d8c0; box-shadow:0 6px 28px rgba(92,58,30,0.10); overflow:hidden; }
    .lc-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:32px 28px; text-align:center; }
    .lc-card-head .lc-logo { font-size:52px; margin-bottom:10px; }
    .lc-card-head h2 { color:#f0d9a0; font-family:Georgia,serif; font-size:22px; margin:0 0 6px; }
    .lc-card-head p  { color:#c9a96e; font-size:13px; margin:0; font-family:Arial,sans-serif; }
    .lc-tabs { display:flex; border-bottom:2px solid #f0e8d8; }
    .lc-tab { flex:1; text-align:center; padding:14px 10px; font-size:13px; font-weight:bold; font-family:Arial,sans-serif; cursor:pointer; color:#bbb; border-bottom:3px solid transparent; margin-bottom:-2px; transition:all 0.2s; user-select:none; }
    .lc-tab.active { color:#5C3A1E; border-bottom-color:#C9973A; }
    .lc-tab:hover:not(.active) { color:#8B5E3C; background:#fdf8f3; }
    .lc-panel { display:none; padding:28px; }
    .lc-panel.active { display:block; }
    .form-group { margin-bottom:18px; }
    .form-group label { display:block; font-size:12px; font-weight:bold; color:#5C3A1E; margin-bottom:7px; font-family:Arial,sans-serif; letter-spacing:0.3px; }
    .form-control { width:100%; padding:11px 14px; border:1.5px solid #e8d8c0; border-radius:10px; font-size:13px; font-family:Arial,sans-serif; color:#333; box-sizing:border-box; transition:border-color 0.2s, box-shadow 0.2s; background:#fafafa; }
    .form-control:focus { outline:none; border-color:#C9973A; background:white; box-shadow:0 0 0 3px rgba(201,151,58,0.12); }
    .form-row { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
    .hint { font-size:11px; color:#aaa; font-family:Arial,sans-serif; margin-top:5px; padding-left:2px; }
    .hint-warn { font-size:11px; font-family:Arial,sans-serif; margin-top:5px; padding:5px 10px; background:#fdf6ec; border-left:3px solid #C9973A; border-radius:4px; color:#8B5E3C; }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:13px 40px; border-radius:10px; font-size:14px; font-weight:bold; cursor:pointer; font-family:Arial,sans-serif; letter-spacing:0.3px; transition:all 0.2s; margin-top:4px; display:block; margin-left:auto; margin-right:auto; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; transform:translateY(-1px); box-shadow:0 4px 14px rgba(168,122,46,0.28); }
    .alert-ok  { padding:12px 16px; border-radius:10px; font-size:13px; margin-bottom:18px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; display:block; font-family:Arial,sans-serif; }
    .alert-err { padding:12px 16px; border-radius:10px; font-size:13px; margin-bottom:18px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; display:block; font-family:Arial,sans-serif; }
    .security-badge { display:flex; align-items:center; gap:8px; background:#f8f4ef; border:1px solid #e8d8c0; border-radius:8px; padding:10px 14px; margin-bottom:22px; font-size:12px; color:#8B5E3C; font-family:Arial,sans-serif; }
    .lc-footer { text-align:center; margin-top:20px; font-family:Arial,sans-serif; font-size:12px; color:#aaa; }
    .lc-footer a { color:#C9973A; text-decoration:none; font-weight:bold; }
    .lc-footer a:hover { color:#5C3A1E; }
    .section-sep { border:none; border-top:1px solid #f0e8d8; margin:22px 0; }
</style>

<div class="lc-wrap">
    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Index.aspx") %>' class="back-link">← Volver al inicio</a>

    <div class="lc-card">

        <%-- HEADER --%>
        <div class="lc-card-head">
            <div class="lc-logo">🛒</div>
            <h2>Muebles Los Alpes</h2>
            <h2>Portal exclusivo para clientes</h2>
        </div>

        <%-- TABS --%>
        <div class="lc-tabs">
            <div class="lc-tab active" onclick="switchTab('Login', this)">🔑 Iniciar Sesión</div>
            <div class="lc-tab"        onclick="switchTab('Registro', this)">✨ Crear Cuenta</div>
        </div>

        <%-- MENSAJES --%>
        <div style="padding:0 28px;">
            <asp:Label ID="lblMensaje" runat="server" CssClass="alert-ok"  Visible="false" />
            <asp:Label ID="lblError"   runat="server" CssClass="alert-err" Visible="false" />
        </div>

        <%-- PANEL: LOGIN --%>
        <div id="panelLogin" class="lc-panel active">
            <div class="security-badge">
            </div>
            <div class="form-group">
                <label>📧 Email *</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                    placeholder="tucorreo@email.com" />
            </div>
            <div class="form-group">
                <label>🔑 Contraseña * <small style="color:#aaa;font-weight:normal;">(tu número de documento)</small></label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                    TextMode="Password" placeholder="Ej: Sin espacios ni guiones" />
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="🔑 Ingresar a mi cuenta"
                CssClass="btn-gold" OnClick="btnLogin_Click" />
        </div>

        <%-- PANEL: REGISTRO --%>
        <div id="panelRegistro" class="lc-panel">
            <div class="security-badge">
                ✅ <span>Completa con tus datos para activar tu cuenta</span>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>📄 Tipo Documento *</label>
                    <asp:DropDownList ID="ddlTipoDoc" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">-- Tipo --</asp:ListItem>
                        <asp:ListItem Value="DPI">DPI</asp:ListItem>
                        <%-- <asp:ListItem Value="Pasaporte">Pasaporte</asp:ListItem> ---%>
                        <asp:ListItem Value="NIT">NIT</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>🔢 Número Documento *</label>
                    <asp:TextBox ID="txtNumDoc" runat="server" CssClass="form-control"
                        placeholder="1234567890101" MaxLength="13" />
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>👤 Primer Nombre *</label>
                    <asp:TextBox ID="txtPrimerNombre" runat="server" CssClass="form-control" placeholder="Tu nombre..." />
                </div>
                <div class="form-group">
                    <label>👤 Segundo Nombre</label>
                    <asp:TextBox ID="txtSegundoNombre" runat="server" CssClass="form-control" placeholder="Opcional..." />
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>👤 Primer Apellido *</label>
                    <asp:TextBox ID="txtPrimerApellido" runat="server" CssClass="form-control" placeholder="Tu apellido..." />
                </div>
                <div class="form-group">
                    <label>👤 Segundo Apellido</label>
                    <asp:TextBox ID="txtSegundoApellido" runat="server" CssClass="form-control" placeholder="Opcional..." />
                </div>
            </div>

            <div class="form-group">
                <label>📧 Email * <small style="color:#aaa;font-weight:normal;">(será tu usuario)</small></label>
                <asp:TextBox ID="txtRegEmail" runat="server" CssClass="form-control"
                    placeholder="tucorreo@email.com" />
            </div>

            <div class="form-group">
                <label>📱 Teléfono * <small style="color:#aaa;font-weight:normal;">(8 dígitos)</small></label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control"
                    placeholder="55551234 sin guiones" MaxLength="8" />
            </div>

            <hr class="section-sep" />

            <div class="form-row">
                <div class="form-group">
                    <label>🌍 País *</label>
                    <asp:TextBox ID="txtPais" runat="server" CssClass="form-control" placeholder="Guatemala" />
                </div>
                <div class="form-group">
                    <label>🗺️ Departamento *</label>
                    <asp:TextBox ID="txtDepartamento" runat="server" CssClass="form-control" placeholder="Guatemala" />
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>🏙️ Municipio *</label>
                    <asp:TextBox ID="txtMunicipio" runat="server" CssClass="form-control" placeholder="Guatemala" />
                </div>
                <div class="form-group">
                    <label>🏘️ Zona *</label>
                    <asp:TextBox ID="txtZona" runat="server" CssClass="form-control" placeholder="Zona 1" />
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>📍 Dirección *</label>
                    <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" placeholder="1 Calle 1-23" />
                </div>
                <div class="form-group">
                    <label>📮 Código Postal *</label>
                    <asp:TextBox ID="txtCodigoPostal" runat="server" CssClass="form-control" placeholder="01001" />
                </div>
            </div>

            <asp:Button ID="btnRegistrar" runat="server" Text="✅ Crear mi cuenta"
                CssClass="btn-gold" OnClick="btnRegistrar_Click" />
        </div>

    </div>

    <div class="lc-footer">
        ¿Eres empleado de Muebles Los Alpes?
        <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/LoginEmpleado.aspx") %>'>Acceso Empleados →</a>
    </div>
</div>

<script>
    function switchTab(name, el) {
        document.querySelectorAll('.lc-tab').forEach(function (t) { t.classList.remove('active'); });
        document.querySelectorAll('.lc-panel').forEach(function (p) { p.classList.remove('active'); });
        el.classList.add('active');
        document.getElementById('panel' + name).classList.add('active');
    }
</script>
</asp:Content>