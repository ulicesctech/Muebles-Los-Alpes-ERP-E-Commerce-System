<%@ Page Title="Auth & Usuarios" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Index.aspx.vb" Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.IndexPage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    .au-hero { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); border-radius:14px; padding:32px 28px; margin-bottom:28px; color:#f0d9a0; }
    .au-hero h1 { font-family:Georgia,serif; font-size:26px; margin:0 0 8px; }
    .au-hero p  { font-size:14px; color:#c9a96e; margin:0; font-family:Arial,sans-serif; }
    .au-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:18px; }
    .au-card { background:white; border-radius:12px; border:1px solid #e8d8c0; box-shadow:0 2px 8px rgba(92,58,30,0.06); overflow:hidden; transition:transform 0.2s,box-shadow 0.2s; }
    .au-card:hover { transform:translateY(-3px); box-shadow:0 6px 16px rgba(92,58,30,0.12); }
    .au-card-head { background:linear-gradient(135deg,#5C3A1E,#8B5E3C); padding:16px 18px; }
    .au-card-head h3 { color:#f0d9a0; font-size:15px; font-family:Georgia,serif; margin:0; }
    .au-card-head span { font-size:22px; }
    .au-card-body { padding:16px 18px; font-family:Arial,sans-serif; }
    .au-card-desc { font-size:13px; color:#666; margin-bottom:14px; }
    .au-btn { display:block; background:linear-gradient(135deg,#C9973A,#a87a2e); color:#1a1a1a; text-decoration:none; padding:10px 14px; border-radius:8px; font-size:13px; font-weight:bold; text-align:center; margin-bottom:8px; transition:all 0.2s; }
    .au-btn:hover { background:linear-gradient(135deg,#a87a2e,#7a5818); color:white; text-decoration:none; }
    .au-section-title { font-size:13px; font-weight:bold; color:#8B5E3C; text-transform:uppercase; letter-spacing:0.5px; margin:0 0 16px; font-family:Arial,sans-serif; padding-bottom:8px; border-bottom:2px solid #e8d8c0; }
    .au-section { margin-bottom:28px; }
    .welcome-bar { background:white; border:1px solid #e8d8c0; border-radius:10px; padding:14px 20px; margin-bottom:24px; display:flex; justify-content:space-between; align-items:center; box-shadow:0 2px 8px rgba(92,58,30,0.06); font-family:Arial,sans-serif; }
    .welcome-bar span { font-size:14px; color:#5C3A1E; font-weight:bold; }
    .welcome-bar small { font-size:12px; color:#aaa; }
    .btn-cerrar { background:white; color:#e53e3e; border:2px solid #fed7d7; padding:8px 16px; border-radius:8px; font-size:13px; font-weight:bold; cursor:pointer; font-family:Arial,sans-serif; }
    .btn-cerrar:hover { background:#e53e3e; color:white; }
</style>

<div class="au-hero">
    <h1>🔐 Auth &amp; Usuarios</h1>
    <p>Gestión de permisos, grupos, empleados y clientes del sistema.</p>
</div>

<%-- Bienvenida si hay sesión --%>
<asp:Panel ID="pnlBienvenida" runat="server" Visible="false">
    <div class="welcome-bar">
        <div>
            <span>👋 <asp:Label ID="lblNombre" runat="server" /></span><br/>
            <small><asp:Label ID="lblGrupo" runat="server" /></small>
        </div>
        <asp:Button ID="btnCerrarSesion" runat="server" Text="🚪 Cerrar Sesión"
            CssClass="btn-cerrar" OnClick="btnCerrarSesion_Click" />
    </div>
</asp:Panel>

<%-- ACCESO — si NO hay sesión --%>
<asp:Panel ID="pnlAcceso" runat="server" Visible="false">
    <div class="au-section">
        <div class="au-section-title">🔑 Acceso al Sistema</div>
        <div class="au-grid">
            <div class="au-card">
                <div class="au-card-head">
                    <span>🛒</span>
                    <h3>Soy Cliente</h3>
                </div>
                <div class="au-card-body">
                    <div class="au-card-desc">Ingresa o regístrate para realizar tus compras.</div>
                    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/LoginCliente.aspx") %>' class="au-btn">Ingresar como Cliente</a>
                </div>
            </div>
            <div class="au-card">
                <div class="au-card-head">
                    <span>👨‍💼</span>
                    <h3>Soy Empleado</h3>
                </div>
                <div class="au-card-body">
                    <div class="au-card-desc">Ingresa con tus credenciales de empleado.</div>
                    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/LoginEmpleado.aspx") %>' class="au-btn">Ingresar como Empleado</a>
                </div>
            </div>
        </div>
    </div>
</asp:Panel>

<%-- ADMIN — solo empleados con permiso Admin --%>
<asp:Panel ID="pnlAdmin" runat="server" Visible="false">
    <div class="au-section">
        <div class="au-section-title">⚙️ Administración</div>
        <div class="au-grid">
            <div class="au-card">
                <div class="au-card-head"><span>👥</span><h3>Grupos de Usuario</h3></div>
                <div class="au-card-body">
                    <div class="au-card-desc">Administra los grupos y sus permisos de acceso.</div>
                    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/GrupoUsuario.aspx") %>' class="au-btn">Gestionar Grupos</a>
                </div>
            </div>
            <div class="au-card">
                <div class="au-card-head"><span>⚙️</span><h3>Permisos</h3></div>
                <div class="au-card-body">
                    <div class="au-card-desc">Consulta los permisos asignados a cada grupo.</div>
                    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Permisos.aspx") %>' class="au-btn">Ver Permisos</a>
                </div>
            </div>
        </div>
    </div>
</asp:Panel>

<%-- RH — solo empleados con permiso RH --%>
<asp:Panel ID="pnlRH" runat="server" Visible="false">
    <div class="au-section">
        <div class="au-section-title">👨‍💼 Recursos Humanos</div>
        <div class="au-grid">
            <div class="au-card">
                <div class="au-card-head"><span>💼</span><h3>Puestos</h3></div>
                <div class="au-card-body">
                    <div class="au-card-desc">Gestiona los puestos de trabajo y salarios.</div>
                    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Puestos.aspx") %>' class="au-btn">Gestionar Puestos</a>
                </div>
            </div>
            <div class="au-card">
                <div class="au-card-head"><span>👨‍💼</span><h3>Empleados</h3></div>
                <div class="au-card-body">
                    <div class="au-card-desc">Administra el personal de la empresa.</div>
                    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Empleados.aspx") %>' class="au-btn">Gestionar Empleados</a>
                </div>
            </div>
            <div class="au-card">
                <div class="au-card-head"><span>📈</span><h3>Ascensos</h3></div>
                <div class="au-card-body">
                    <div class="au-card-desc">Registra y gestiona los ascensos del personal.</div>
                    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Ascensos.aspx") %>' class="au-btn">Gestionar Ascensos</a>
                </div>
            </div>
        </div>
    </div>
</asp:Panel>

<%-- CLIENTES — solo empleados con permiso CLI --%>
<asp:Panel ID="pnlClientes" runat="server" Visible="false">
    <div class="au-section">
        <div class="au-section-title">🛒 Clientes</div>
        <div class="au-grid">
            <div class="au-card">
                <div class="au-card-head"><span>🛒</span><h3>Gestión de Clientes</h3></div>
                <div class="au-card-body">
                    <div class="au-card-desc">Administra el registro y datos de los clientes.</div>
                    <a href='<%: ResolveUrl("~/Modules/AuthUsuarios/Clientes.aspx") %>' class="au-btn">Gestionar Clientes</a>
                </div>
            </div>
        </div>
    </div>
</asp:Panel>

</asp:Content>