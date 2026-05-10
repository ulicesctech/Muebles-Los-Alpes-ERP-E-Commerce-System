-- ==========================================================
-- INSTALADOR GENERAL DE PACKAGES
-- Muebles Los Alpes ERP & E-Commerce
-- Ejecutar como: @InstaladorPaquetes.sql
-- Orden: specs primero, luego bodies (dependencias respetadas)
-- ==========================================================

PROMPT ==========================================
PROMPT FASE 1: AUTH USUARIOS
PROMPT ==========================================

PROMPT [1/1] PKG_ADMIN_PERMISOS...
@@../auth_usuarios/PKG_ADMIN_PERMISOS.pks
@@../auth_usuarios/PKG_ADMIN_PERMISOS.pkb

PROMPT [1/2] PKG_ADMIN_GRUPO_USUARIO...
@@../auth_usuarios/PKG_ADMIN_GRUPO_USUARIO.pks
@@../auth_usuarios/PKG_ADMIN_GRUPO_USUARIO.pkb

PROMPT [1/3] PKG_ADMIN_LOGIN_EMPLEADO...
@@../auth_usuarios/PKG_ADMIN_LOGIN_EMPLEADO.pks
@@../auth_usuarios/PKG_ADMIN_LOGIN_EMPLEADO.pkb

PROMPT [1/4] PKG_ADMIN_LOGIN_CLIENTE...
@@../auth_usuarios/PKG_ADMIN_LOGIN_CLIENTE.pks
@@../auth_usuarios/PKG_ADMIN_LOGIN_CLIENTE.pkb

PROMPT [1/5] PKG_RH_PUESTO...
@@../auth_usuarios/PKG_RH_PUESTO.pks
@@../auth_usuarios/PKG_RH_PUESTO.pkb

PROMPT [1/6] PKG_RH_EMPLEADO...
@@../auth_usuarios/PKG_RH_EMPLEADO.pks
@@../auth_usuarios/PKG_RH_EMPLEADO.pkb

PROMPT [1/7] PKG_RH_ASCENSO...
@@../auth_usuarios/PKG_RH_ASCENSO.pks
@@../auth_usuarios/PKG_RH_ASCENSO.pkb

PROMPT [1/8] PKG_CLI_CLIENTE...
@@../auth_usuarios/PKG_CLI_CLIENTE.pks
@@../auth_usuarios/PKG_CLI_CLIENTE.pkb

PROMPT ==========================================
PROMPT FASE 2: CATALOGO E INVENTARIO
PROMPT ==========================================

PROMPT [2/1] PKG_BOD_CATEGORIA...
@@../catalogo_inventario/PKG_BOD_CATEGORIA.pks.sql
@@../catalogo_inventario/PKG_BOD_CATEGORIA.pkb.sql

PROMPT [2/2] PKG_BOD_MATERIAL...
@@../catalogo_inventario/PKG_BOD_MATERIAL.pks.sql
@@../catalogo_inventario/PKG_BOD_MATERIAL.pkb.sql

PROMPT [2/3] PKG_BOD_TIPO...
@@../catalogo_inventario/PKG_BOD_TIPO.pks.sql
@@../catalogo_inventario/PKG_BOD_TIPO.pkb.sql

PROMPT [2/4] PKG_BOD_PRODUCTO...
@@../catalogo_inventario/PKG_BOD_PRODUCTO.pks.sql
@@../catalogo_inventario/PKG_BOD_PRODUCTO.pkb.sql

PROMPT [2/5] PKG_BOD_NICHO...
@@../catalogo_inventario/PKG_BOD_NICHO.pks.sql
@@../catalogo_inventario/PKG_BOD_NICHO.pkb.sql

PROMPT [2/6] PKG_BOD_ALMACEN...
@@../catalogo_inventario/PKG_BOD_ALMACEN.pks.sql
@@../catalogo_inventario/PKG_BOD_ALMACEN.pkb.sql

PROMPT [2/7] PKG_BOD_NIC_ALM...
@@../catalogo_inventario/PKG_BOD_NIC_ALM.pks.sql
@@../catalogo_inventario/PKG_BOD_NIC_ALM.pkb.sql

PROMPT [2/8] PKG_BOD_HISTORIAL_PRECIO...
@@../catalogo_inventario/PKG_BOD_HISTORIAL_PRECIO.pks.sql
@@../catalogo_inventario/PKG_BOD_HISTORIAL_PRECIO.pkb.sql

PROMPT [2/9] PKG_BOD_STOCK...
@@../catalogo_inventario/PKG_BOD_STOCK.pks.sql
@@../catalogo_inventario/PKG_BOD_STOCK.pkb.sql

PROMPT [2/10] PKG_PROMO_PROMOCION...
@@../catalogo_inventario/PKG_PROMO_PROMOCION.pks.sql
@@../catalogo_inventario/PKG_PROMO_PROMOCION.pkb.sql

PROMPT ==========================================
PROMPT FASE 3: COMPRAS Y PROVEEDOR
PROMPT ==========================================

PROMPT [3/1] PKG_CP_BOD_PROVEEDOR...
@@../compras_proveedor/PKG_CP_BOD_PROVEEDOR.pks
@@../compras_proveedor/PKG_CP_BOD_PROVEEDOR.pkb

PROMPT [3/2] PKG_CP_BOD_PEDIDO...
@@../compras_proveedor/PKG_CP_BOD_PEDIDO.pks
@@../compras_proveedor/PKG_CP_BOD_PEDIDO.pkb

PROMPT [3/3] PKG_CP_BOD_DETALLE_PEDIDO...
@@../compras_proveedor/PKG_CP_BOD_DETALLE_PEDIDO.pks
@@../compras_proveedor/PKG_CP_BOD_DETALLE_PEDIDO.pkb

PROMPT [3/4] PKG_CP_BOD_ORDEN_COMPRA...
@@../compras_proveedor/PKG_CP_BOD_ORDEN_COMPRA.pks
@@../compras_proveedor/PKG_CP_BOD_ORDEN_COMPRA.pkb

PROMPT [3/5] PKG_CP_BOD_ORDEN_DETALLE_PEDIDO...
@@../compras_proveedor/PKG_CP_BOD_ORDEN_DETALLE_PEDIDO.pks
@@../compras_proveedor/PKG_CP_BOD_ORDEN_DETALLE_PEDIDO.pkb

PROMPT [3/6] PKG_CP_FAC_FACTURA_PROV...
@@../compras_proveedor/PKG_CP_FAC_FACTURA_PROV.pks
@@../compras_proveedor/PKG_CP_FAC_FACTURA_PROV.pkb

PROMPT [3/7] PKG_CP_FAC_RECLAMO_PROV...
@@../compras_proveedor/PKG_CP_FAC_RECLAMO_PROV.pks
@@../compras_proveedor/PKG_CP_FAC_RECLAMO_PROV.pkb

PROMPT ==========================================
PROMPT FASE 4: VENTAS Y FACTURACION
PROMPT ==========================================

PROMPT [4/1] PKG_BOD_HISTORIAL_PRECIO_VENTA...
@@../ventas_facturacion/PKG_BOD_HISTORIAL_PRECIO_VENTA.pks
@@../ventas_facturacion/PKG_BOD_HISTORIAL_PRECIO_VENTA.pkb

PROMPT [4/2] PKG_FAC_FACTURA_CLIENTE...
@@../ventas_facturacion/PKG_FAC_FACTURA_CLIENTE.pks
@@../ventas_facturacion/PKG_FAC_FACTURA_CLIENTE.pkb

PROMPT [4/3] PKG_CLI_CARRITO...
@@../ventas_facturacion/PKG_CLI_CARRITO.pks
@@../ventas_facturacion/PKG_CLI_CARRITO.pkb

PROMPT [4/4] Triggers ventas facturacion...
@@../ventas_facturacion/triggers_ventas_facturacion.sql

PROMPT ==========================================
PROMPT VERIFICACION FINAL
PROMPT ==========================================

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_type, object_name;

PROMPT ==========================================
PROMPT INSTALACION COMPLETADA
PROMPT ==========================================