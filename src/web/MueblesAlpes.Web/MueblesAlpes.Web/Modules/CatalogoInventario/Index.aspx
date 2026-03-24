<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Index.aspx.vb" Inherits="MueblesAlpes.Web.Modules.CatalogoInventario.Index" MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h2>Catálogo &amp; Inventario</h2>
        <p class="text-muted">Gestión de productos, materiales, tipos y ubicaciones de bodega.</p>
    </div>

    <h4 style="color:#555; margin-bottom:15px;">🏷️ Catálogo</h4>
    <div class="row" style="margin-bottom:30px;">

        <div class="col-sm-6 col-md-3">
            <div class="panel panel-default" style="border-top: 4px solid #d4a843;">
                <div class="panel-body text-center">
                    <div style="font-size:40px; margin-bottom:10px;">🏷️</div>
                    <h4>Categorías</h4>
                    <p class="text-muted" style="font-size:13px;">Clasifica los productos por categoría principal.</p>
                    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Categorias.aspx") %>' class="btn btn-warning btn-block">Gestionar</a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-md-3">
            <div class="panel panel-default" style="border-top: 4px solid #5bc0de;">
                <div class="panel-body text-center">
                    <div style="font-size:40px; margin-bottom:10px;">🧱</div>
                    <h4>Materiales</h4>
                    <p class="text-muted" style="font-size:13px;">Define los materiales usados en los productos.</p>
                    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Materiales.aspx") %>' class="btn btn-info btn-block">Gestionar</a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-md-3">
            <div class="panel panel-default" style="border-top: 4px solid #5cb85c;">
                <div class="panel-body text-center">
                    <div style="font-size:40px; margin-bottom:10px;">📋</div>
                    <h4>Tipos</h4>
                    <p class="text-muted" style="font-size:13px;">Subcategorías asociadas a cada categoría.</p>
                    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Tipos.aspx") %>' class="btn btn-success btn-block">Gestionar</a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-md-3">
            <div class="panel panel-default" style="border-top: 4px solid #d9534f;">
                <div class="panel-body text-center">
                    <div style="font-size:40px; margin-bottom:10px;">🛋️</div>
                    <h4>Productos</h4>
                    <p class="text-muted" style="font-size:13px;">Registro completo del catálogo de muebles.</p>
                    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Productos.aspx") %>' class="btn btn-danger btn-block">Gestionar</a>
                </div>
            </div>
        </div>

    </div>

    <h4 style="color:#555; margin-bottom:15px;">🏭 Bodega</h4>
    <div class="row">

        <div class="col-sm-6 col-md-3">
            <div class="panel panel-default" style="border-top: 4px solid #337ab7;">
                <div class="panel-body text-center">
                    <div style="font-size:40px; margin-bottom:10px;">🏭</div>
                    <h4>Almacenes</h4>
                    <p class="text-muted" style="font-size:13px;">Gestiona las bodegas y su ubicación geográfica.</p>
                    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Almacenes.aspx") %>' class="btn btn-primary btn-block">Gestionar</a>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-md-3">
            <div class="panel panel-default" style="border-top: 4px solid #9b59b6;">
                <div class="panel-body text-center">
                    <div style="font-size:40px; margin-bottom:10px;">📍</div>
                    <h4>Nichos</h4>
                    <p class="text-muted" style="font-size:13px;">Espacios físicos dentro de cada almacén.</p>
                    <a href='<%: ResolveUrl("~/Modules/CatalogoInventario/Nichos.aspx") %>' class="btn btn-block" style="background-color:#9b59b6; color:#fff; border-color:#9b59b6;">Gestionar</a>
                </div>
            </div>
        </div>

    </div>

</asp:Content>