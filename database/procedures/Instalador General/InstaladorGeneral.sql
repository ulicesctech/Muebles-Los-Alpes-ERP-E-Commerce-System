-- ============================================================
-- INSTALADOR COMPLETO — Muebles Los Alpes ERP
-- Ejecutar en SQL Developer como usuario ULISS
-- ============================================================

-- ============================================================
-- 1. AUTH & USUARIOS (Wilmer)
-- ============================================================
@database/procedures/auth_usuarios/PKG_ADMIN_PERMISOS.pks
@database/procedures/auth_usuarios/PKG_ADMIN_PERMISOS.pkb
@database/procedures/auth_usuarios/PKG_RH_PUESTO.pks
@database/procedures/auth_usuarios/PKG_RH_PUESTO.pkb
@database/procedures/auth_usuarios/PKG_RH_EMPLEADO.pks
@database/procedures/auth_usuarios/PKG_RH_EMPLEADO.pkb
@database/procedures/auth_usuarios/PKG_RH_ASCENSO.pks
@database/procedures/auth_usuarios/PKG_RH_ASCENSO.pkb
@database/procedures/auth_usuarios/PKG_ADMIN_GRUPO_USUARIO.pks
@database/procedures/auth_usuarios/PKG_ADMIN_GRUPO_USUARIO.pkb
@database/procedures/auth_usuarios/PKG_ADMIN_LOGIN_EMPLEADO.pks
@database/procedures/auth_usuarios/PKG_ADMIN_LOGIN_EMPLEADO.pkb
@database/procedures/auth_usuarios/PKG_ADMIN_LOGIN_CLIENTE.pks
@database/procedures/auth_usuarios/PKG_ADMIN_LOGIN_CLIENTE.pkb
@database/procedures/auth_usuarios/PKG_CLI_CLIENTE.pks
@database/procedures/auth_usuarios/PKG_CLI_CLIENTE.pkb

-- ============================================================
-- 2. CATALOGO & INVENTARIO (Ulices)
-- ============================================================
@database/procedures/catalogo_inventario/PKG_BOD_CATEGORIA.pks.sql
@database/procedures/catalogo_inventario/PKG_BOD_CATEGORIA.pkb.sql
@database/procedures/catalogo_inventario/PKG_BOD_MATERIAL.pks.sql
@database/procedures/catalogo_inventario/PKG_BOD_MATERIAL.pkb.sql
@database/procedures/catalogo_inventario/PKG_BOD_TIPO.pks.sql
@database/procedures/catalogo_inventario/PKG_BOD_TIPO.pkb.sql
@database/procedures/catalogo_inventario/PKG_BOD_ALMACEN.pks.sql
@database/procedures/catalogo_inventario/PKG_BOD_ALMACEN.pkb.sql
@database/procedures/catalogo_inventario/PKG_BOD_NICHO.pks.sql
@database/procedures/catalogo_inventario/PKG_BOD_NICHO.pkb.sql
@database/procedures/catalogo_inventario/PKG_BOD_NIC_ALM.pks.sql
@database/procedures/catalogo_inventario/PKG_BOD_NIC_ALM.pkb.sql
@database/procedures/catalogo_inventario/PKG_BOD_PRODUCTO.pks.sql
@database/procedures/catalogo_inventario/PKG_BOD_PRODUCTO.pkb.sql
@database/procedures/catalogo_inventario/PKG_BOD_HISTORIAL_PRECIO.pks.sql
@database/procedures/catalogo_inventario/PKG_BOD_HISTORIAL_PRECIO.pkb.sql
@database/procedures/catalogo_inventario/PKG_BOD_STOCK.pks.sql
@database/procedures/catalogo_inventario/PKG_BOD_STOCK.pkb.sql
@database/procedures/catalogo_inventario/PKG_PROMO_PROMOCION.pks.sql
@database/procedures/catalogo_inventario/PKG_PROMO_PROMOCION.pkb.sql

-- ============================================================
-- 3. COMPRAS & PROVEEDOR (Anderson)
-- ============================================================
@database/procedures/compras_proveedor/PKG_CP_BOD_PROVEEDOR.pks
@database/procedures/compras_proveedor/PKG_CP_BOD_PROVEEDOR.pkb
@database/procedures/compras_proveedor/PKG_CP_BOD_PEDIDO.pks
@database/procedures/compras_proveedor/PKG_CP_BOD_PEDIDO.pkb
@database/procedures/compras_proveedor/PKG_CP_BOD_DETALLE_PEDIDO.pks
@database/procedures/compras_proveedor/PKG_CP_BOD_DETALLE_PEDIDO.pkb
@database/procedures/compras_proveedor/PKG_CP_BOD_ORDEN_COMPRA.pks
@database/procedures/compras_proveedor/PKG_CP_BOD_ORDEN_COMPRA.pkb
@database/procedures/compras_proveedor/PKG_CP_BOD_ORDEN_DETALLE_PEDIDO.pks
@database/procedures/compras_proveedor/PKG_CP_BOD_ORDEN_DETALLE_PEDIDO.pkb
@database/procedures/compras_proveedor/PKG_CP_FAC_FACTURA_PROV.pks
@database/procedures/compras_proveedor/PKG_CP_FAC_FACTURA_PROV.pkb
@database/procedures/compras_proveedor/PKG_CP_FAC_RECLAMO_PROV.pks
@database/procedures/compras_proveedor/PKG_CP_FAC_RECLAMO_PROV.pkb

-- ============================================================
-- 4. VENTAS & FACTURACION (José)
-- ============================================================
@database/procedures/ventas_facturacion/PKG_BOD_HISTORIAL_PRECIO_VENTA.pks
@database/procedures/ventas_facturacion/PKG_BOD_HISTORIAL_PRECIO_VENTA.pkb
@database/procedures/ventas_facturacion/PKG_CLI_CARRITO.pks
@database/procedures/ventas_facturacion/PKG_CLI_CARRITO.pkb
@database/procedures/ventas_facturacion/PKG_FAC_FACTURA_CLIENTE.pks
@database/procedures/ventas_facturacion/PKG_FAC_FACTURA_CLIENTE.pkb

-- ============================================================
-- 5. CLIENTE E-COMMERCE (Ulices)
-- ============================================================
@database/Cliente/PKG_CLI_CATALOGO.sql

-- ============================================================
-- VERIFICACION FINAL
-- ============================================================
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
  FROM USER_OBJECTS
 WHERE OBJECT_TYPE IN ('PACKAGE', 'PACKAGE BODY')
 ORDER BY OBJECT_NAME, OBJECT_TYPE;