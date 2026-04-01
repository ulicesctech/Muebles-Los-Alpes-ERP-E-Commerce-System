<%@ Page Title="Auth & Usuarios" Language="VB" MasterPageFile="~/Site.Master"      AutoEventWireup="true" CodeFile="Default.aspx.vb"      Inherits="MueblesAlpes.Web.Modules.AuthUsuarios.DefaultPage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .breadcrumb-mod { background:white; border:1px solid #e8d8c0; border-radius:8px; padding:10px 16px; margin-bottom:20px; font-size:13px; font-family:Arial,sans-serif; color:#888; }
    .breadcrumb-mod a { color:#C9973A; text-decoration:none; }

    .page-title { font-size:22px; color:#5C3A1E; font-family:Georgia,serif; margin:0 0 20px; }

    .module-card {
        background:white;
        border-radius:12px;
        border:1px solid #e8d8c0;
        overflow:hidden;
        box-shadow:0 2px 8px rgba(92,58,30,0.06);
        transition:all 0.2s ease;
        height:100%;
    }

    .module-card:hover {
        transform:translateY(-4px);
        box-shadow:0 6px 16px rgba(92,58,30,0.12);
    }

    .module-head {
        background:linear-gradient(135deg,#5C3A1E,#8B5E3C);
        padding:14px;
        text-align:center;
    }

    .module-head i {
        font-size:26px;
        color:#f0d9a0;
    }

    .module-body {
        padding:18px;
        text-align:center;
        font-family:Arial,sans-serif;
    }

    .module-title {
        font-size:16px;
        font-weight:bold;
        color:#5C3A1E;
        margin-bottom:6px;
    }

    .module-desc {
        font-size:13px;
        color:#777;
        margin-bottom:15px;
    }

    .btn-gold {
        background:linear-gradient(135deg,#C9973A,#a87a2e);
        color:#1a1a1a;
        border:none;
        padding:10px;
        border-radius:8px;
        font-size:13px;
        font-weight:bold;
        font-family:Arial,sans-serif;
        cursor:pointer;
        display:block;
        width:100%;
    }

    .btn-gold:hover {
        background:linear-gradient(135deg,#a87a2e,#7a5818);
        color:white;
    }

    .test-section {
        margin-top:30px;
        text-align:center;
    }

    .btn-outline {
        background:white;
        color:#5C3A1E;
        border:2px solid #e8d8c0;
        padding:12px 20px;
        border-radius:10px;
        font-size:14px;
        font-family:Arial,sans-serif;
        cursor:pointer;
    }

    .btn-outline:hover {
        border-color:#C9973A;
        color:#C9973A;
    }
</style>

<div class="breadcrumb-mod">
    <a href='<%: ResolveUrl("~/") %>'>🏠 Inicio</a> /
    <strong style="color:#5C3A1E;">Auth & Usuarios</strong>
</div>

<div class="page-title">🔐 Gestión de Autenticación y Usuarios</div>

<div class="row g-4">

  <!-- ADMIN -->
<div class="col-md-4">
    <div class="module-card">
        <div class="module-head">
            <i class="fas fa-user-shield"></i>
        </div>
        <div class="module-body">
            <div class="module-title">Administración</div>
            <div class="module-desc">Permisos, grupos y logins</div>
            <a href="Admin/Permisos.aspx"         class="btn-gold" style="display:block; margin-bottom:8px;">⚙️ Permisos</a>
            <a href="Admin/GrupoUsuario.aspx"      class="btn-gold" style="display:block; margin-bottom:8px;">👥 Grupos de Usuario</a>
            <a href="LoginEmpleado.aspx"           class="btn-gold" style="display:block; margin-bottom:8px;">👨‍💼 Login Empleado</a>
            <a href="LoginCliente.aspx"            class="btn-gold" style="display:block;">🛒 Login Cliente</a>
        </div>
    </div>
</div>

    <!-- RH -->
    <div class="col-md-4">
        <div class="module-card">
            <div class="module-head">
                <i class="fas fa-users"></i>
            </div>
            <div class="module-body">
                <div class="module-title">Recursos Humanos</div>
                <div class="module-desc">Empleados, puestos y ascensos</div>
                <a href="RH/Empleados.aspx" class="btn-gold">Gestionar</a>
                <a href="RH/Empleados.aspx" class="btn-gold" style="margin-bottom:8px;">👨‍💼 Empleados</a>

                <a href="RH/Puestos.aspx" class="btn-gold" style="margin-bottom:8px;">📋 Puestos</a>

                <a href="RH/Ascensos.aspx" class="btn-gold">📈 Ascensos</a>
            </div>
        </div>
    </div>

    <!-- CLIENTES -->
    <div class="col-md-4">
        <div class="module-card">
            <div class="module-head">
                <i class="fas fa-id-badge"></i>
            </div>
            <div class="module-body">
                <div class="module-title">Clientes</div>
                <div class="module-desc">Gestión de clientes y acceso</div>
                <a href="Clientes/Index.aspx" class="btn-gold">Gestionar</a>
            </div>
        </div>
    </div>

</div>

<div class="test-section">
    <asp:Button 
        ID="btnTest" 
        runat="server" 
        Text="🧪 Ejecutar Test PL/SQL" 
        CssClass="btn-outline"
        OnClick="btnTest_Click" />
</div>

</asp:Content>