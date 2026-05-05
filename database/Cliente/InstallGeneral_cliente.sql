-- ============================================================
-- INSTALADOR — Módulo Cliente E-Commerce
-- Ejecutar en SQL Developer como tu usuario
-- ============================================================

-- 1. Cliente y autenticación
@database/Cliente/PKG_CLI_CLIENTE.sql
@database/Cliente/PKG_ADMIN_LOGIN_CLIENTE.sql

-- 2. Catálogo vista cliente
@database/Cliente/PKG_CLI_CATALOGO.sql

-- 3. Precios de venta
@database/Cliente/PKG_BOD_HISTORIAL_PRECIO_VENTA.sql

-- 4. Carrito y facturación
@database/Cliente/PKG_CLI_CARRITO.sql
@database/Cliente/PKG_FAC_FACTURA_CLIENTE.sql

-- Verificación
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
  FROM USER_OBJECTS
 WHERE OBJECT_NAME IN (
    'PKG_CLI_CLIENTE',
    'PKG_ADMIN_LOGIN_CLIENTE',
    'PKG_CLI_CATALOGO',
    'PKG_BOD_HISTORIAL_PRECIO_VENTA',
    'PKG_CLI_CARRITO',
    'PKG_FAC_FACTURA_CLIENTE'
 )
 ORDER BY OBJECT_NAME, OBJECT_TYPE;