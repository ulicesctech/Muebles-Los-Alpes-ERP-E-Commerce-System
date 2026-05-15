<%@ Page Title="Reporte de Ventas" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false" CodeBehind="ReporteVentas.aspx.vb" Inherits="MueblesAlpes.Web.Modules.Reporteria.Gerencial.ReporteVentas" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <h2 style="color: #2f1b0f; font-weight: bold;">Reporte de Ventas</h2>
    </div>

    <div class="panel-reporte" style="min-height: 800px; width: 100%; background: #fff; border: 1px solid #dcc29a; border-radius: 14px;">
        <iframe id="iframeVentas"
                src="http://192.168.0.101/Reports/powerbi/VENTAS?rs:Embed=true"
                style="width: 100%; height: 800px; border: none;" 
                allowFullScreen="true">
        </iframe>
    </div>
</asp:Content>