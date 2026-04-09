<%@ Page Title="Acceso Clientes" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="LoginCliente.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.LoginClientePage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .login-wrap { display:grid; grid-template-columns:1fr 1fr; gap:24px; max-width:900px; margin:0 auto; }
    .login-card { background:white; border-radius:14px; border:1px solid #e8d8c0; box-shadow:0 2px 8px rgba(92,58,30,0.08); overflow:hidden; }
    .login-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:20px 24px; }
    .login-head h2 { color:#f0d9a0; font-family:Georgia,serif; font-size:18px; margin:0 0 4px; }
    .login-head p  { color:#c9a96e; font-size:12px; margin:0; font-family:Arial,sans-serif; }
    .login-body { padding:24px; }
    .form-group { margin-bottom:16px; }
    .form-group label { display:block; font-size:13px; font-weight:bold; color:#5C3A1E; margin-bottom:6px; font-family:Arial,sans-serif; }
    .form-control { width:100%; padding:10px 12px; border:1px solid #e8d8c0; border-radius:8px; font-size:13px; font-family:Arial,sans-serif; color:#333; box-sizing:border-box; }
    .form-control:focus { outline:none; border-color:#C9973A; }
    .btn-gold { background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; border:none; padding:11px 20px; border-radius:8px; font-size:13px; font-weight:bold; cursor:pointer; width:100%; }
    .btn-gold:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; }
    .btn-outline { background:white; color:#5C3A1E; border:2px solid #e8d8c0; padding:10px 20px; border-radius:8px; font-size:13px; cursor:pointer; width:100%; margin-top:8px; font-family:Arial,sans-serif; }
    .btn-outline:hover { border-color:#C9973A; color:#C9973A; }
    .alert-ok  { padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; background:#f0fff4; color:#276749; border-left:4px solid #48bb78; font-family:Arial,sans-serif; display:block; }
    .alert-err { padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; background:#fff5f5; color:#c53030; border-left:4px solid #fc8181; font-family:Arial,sans-serif; display:block; }
    .divider { border:none; border-top:1px solid #e8d8c0; margin:20px 0; }
    .hint { font-size:12px; color:#aaa; font-family:Arial,sans-serif; text-align:center; margin-top:10px; }
    .section-title { font-size:12px; font-weight:bold; color:#8B5E3C; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:14px; font-family:Arial,sans-serif; padding-bottom:6px; border-bottom:1px solid #e8d8c0; }
    .val-error { color:#c53030; font-size:12px; font-family:Arial,sans-serif; display:block; margin-top:3px; }
    .back-link { display:inline-block; margin-bottom:20px; color:#C9973A; font-size:13px; font-family:Arial,sans-serif; text-decoration:none; }
    .back-link:hover { text-decoration:underline; }
    @media(max-width:640px){ .login-wrap{ grid-template-columns:1fr; } }
</style>

<a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Index.aspx") %>' class="back-link">← Volver al inicio</a>

<div class="login-wrap">

    <%-- ═══ COLUMNA IZQUIERDA: LOGIN CLIENTE ═══ --%>
    <div class="login-card">
        <div class="login-head">
            <h2>🛒 Acceso Clientes</h2>
            <p>Ingresa con tu email y número de documento</p>
        </div>
        <div class="login-body">

            <asp:Label ID="lblLoginError"   runat="server" CssClass="alert-err" Visible="false" />
            <asp:Label ID="lblLoginMensaje" runat="server" CssClass="alert-ok"  Visible="false" />

            <div class="section-title">Iniciar Sesión</div>
            <div class="form-group">
                <label>Email *</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                    placeholder="tucorreo@email.com" />
            </div>
            <div class="form-group">
                <label>Contraseña <small style="color:#aaa;">(número de documento)</small></label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                    placeholder="Tu número de documento..." TextMode="Password" />
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="🔑 Ingresar"
                CssClass="btn-gold" OnClick="btnLogin_Click" CausesValidation="false" />

            <hr class="divider" />

            <%-- REGISTRO --%>
            <div class="section-title">Nuevo Cliente — Regístrate</div>

            <asp:Label ID="lblRegError"   runat="server" CssClass="alert-err" Visible="false" />
            <asp:Label ID="lblRegMensaje" runat="server" CssClass="alert-ok"  Visible="false" />

            <div class="form-group">
                <label>Tipo Documento *</label>
                <asp:DropDownList ID="ddlTipoDoc" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">-- Seleccione --</asp:ListItem>
                    <asp:ListItem Value="DPI">DPI</asp:ListItem>
                    <asp:ListItem Value="Pasaporte">Pasaporte</asp:ListItem>
                    <asp:ListItem Value="NIT">NIT</asp:ListItem>
                    <asp:ListItem Value="Otro">Otro</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="form-group">
                <label>Número Documento * <small style="color:#aaa;">(DPI: 13 dígitos)</small></label>
                <asp:TextBox ID="txtNumDoc" runat="server" CssClass="form-control"
                    placeholder="Ej: 1234567890101" MaxLength="13" />
            </div>
            <div class="form-group">
                <label>Primer Nombre *</label>
                <asp:TextBox ID="txtPrimerNombre" runat="server" CssClass="form-control" placeholder="Primer nombre..." />
            </div>
            <div class="form-group">
                <label>Primer Apellido *</label>
                <asp:TextBox ID="txtPrimerApellido" runat="server" CssClass="form-control" placeholder="Primer apellido..." />
            </div>
            <div class="form-group">
                <label>Email *</label>
                <asp:TextBox ID="txtEmailReg" runat="server" CssClass="form-control" placeholder="tucorreo@email.com" />
            </div>
            <div class="form-group">
                <label>Teléfono * <small style="color:#aaa;">(8 dígitos)</small></label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control"
                    placeholder="Ej: 55551234" MaxLength="8" />
            </div>
            <div class="form-group">
                <label>País *</label>
                <asp:TextBox ID="txtPais" runat="server" CssClass="form-control" placeholder="País..." />
            </div>
            <div class="form-group">
                <label>Departamento *</label>
                <asp:TextBox ID="txtDepartamento" runat="server" CssClass="form-control" placeholder="Departamento..." />
            </div>
            <div class="form-group">
                <label>Municipio *</label>
                <asp:TextBox ID="txtMunicipio" runat="server" CssClass="form-control" placeholder="Municipio..." />
            </div>
            <div class="form-group">
                <label>Zona *</label>
                <asp:TextBox ID="txtZona" runat="server" CssClass="form-control" placeholder="Zona..." />
            </div>
            <div class="form-group">
                <label>Dirección *</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" placeholder="Dirección..." />
            </div>
            <div class="form-group">
                <label>Código Postal *</label>
                <asp:TextBox ID="txtCodigoPostal" runat="server" CssClass="form-control" placeholder="Código postal..." />
            </div>
            <div class="form-group">
                <label>Tipo Cliente *</label>
                <asp:DropDownList ID="ddlTipoCliente" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">-- Seleccione --</asp:ListItem>
                    <asp:ListItem Value="NATURAL">Natural</asp:ListItem>
                    <asp:ListItem Value="JURIDICA">Jurídica</asp:ListItem>
                </asp:DropDownList>
            </div>
            <asp:Button ID="btnRegistrar" runat="server" Text="📝 Registrarme"
                CssClass="btn-gold" OnClick="btnRegistrar_Click" CausesValidation="false" />
        </div>
    </div>

    <%-- ═══ COLUMNA DERECHA: INFO + LINK EMPLEADO ═══ --%>
    <div class="login-card">
        <div class="login-head">
            <h2>ℹ️ Información</h2>
            <p>¿Eres empleado? Ingresa por aquí</p>
        </div>
        <div class="login-body">
            <div style="text-align:center; padding:20px 0; font-family:Arial,sans-serif;">
                <div style="font-size:48px; margin-bottom:16px;">👨‍💼</div>
                <p style="color:#5C3A1E; font-size:14px; margin-bottom:20px;">
                    Si eres un empleado de Muebles Los Alpes, accede con tus credenciales de empleado.
                </p>
                <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/LoginEmpleado.aspx") %>'
                   style="display:block; background:linear-gradient(135deg,#5C3A1E,#8B5E3C); color:#f0d9a0; padding:12px 20px; border-radius:8px; text-decoration:none; font-size:14px; font-weight:bold; font-family:Arial,sans-serif;">
                    👨‍💼 Ingresar como Empleado
                </a>
            </div>
            <hr class="divider" />
            <div style="font-family:Arial,sans-serif; font-size:13px; color:#666;">
                <p style="margin-bottom:8px;"><strong style="color:#5C3A1E;">Usuario cliente:</strong> tu email</p>
                <p style="margin-bottom:8px;"><strong style="color:#5C3A1E;">Contraseña:</strong> tu número de documento</p>
                <p style="margin-bottom:0;"><strong style="color:#5C3A1E;">Usuario empleado:</strong> tu nombre en minúsculas</p>
            </div>
        </div>
    </div>

</div>
</asp:Content>