<%@ Page Title="Reporte de Inventario" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false" CodeBehind="ReporteInventario.aspx.vb" Inherits="MueblesAlpes.Web.Modules.Reporteria.Gerencial.ReporteInventario" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <h2 style="color: #2f1b0f; font-weight: bold;">Reporte de Inventario</h2>
    </div>

    <div class="panel-reporte" style="min-height: 800px; width: 100%; background: #fff; border: 1px solid #dcc29a; border-radius: 14px;">
        <iframe id="iframeInventario"
<<<<<<< HEAD
                src="http://192.168.56.1/Reports/powerbi/INVENTARIO?rs:Embed=true&rs:navContentPaneEnabled=false"
=======
                src="http://192.168.0.101/Reports/powerbi/INVENTARIO?rs:Embed=true&rs:navContentPaneEnabled=false"
>>>>>>> 5bc675990cf417f92d859f72b9beb18bce1ca2b3
                style="width: 100%; height: 800px; border: none;" 
                allowFullScreen="true">
        </iframe>
    </div>
</asp:Content>