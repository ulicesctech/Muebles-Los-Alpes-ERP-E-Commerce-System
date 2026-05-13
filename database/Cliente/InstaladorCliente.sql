-- ==========================================================
-- INSTALADOR PACKAGES VISTA CLIENTE
-- Muebles Los Alpes ERP & E-Commerce
-- Ejecutar como: @InstaladorCliente.sql
-- ==========================================================

PROMPT ==========================================
PROMPT FASE 1: AUTH CLIENTE
PROMPT ==========================================

PROMPT [1/1] PKG_ADMIN_LOGIN_CLIENTE...
@@PKG_ADMIN_LOGIN_CLIENTE.sql

PROMPT ==========================================
PROMPT FASE 2: CLIENTE
PROMPT ==========================================

PROMPT [2/1] PKG_CLI_CLIENTE...
@@PKG_CLI_CLIENTE.sql

PROMPT ==========================================
PROMPT FASE 3: CATALOGO
PROMPT ==========================================

PROMPT [3/1] PKG_BOD_HISTORIAL_PRECIO_VENTA...
@@PKG_BOD_HISTORIAL_PRECIO_VENTA.sql

PROMPT [3/2] PKG_CLI_CATALOGO...
@@PKG_CLI_CATALOGO.sql

PROMPT ==========================================
PROMPT FASE 4: CARRITO Y FACTURACION
PROMPT ==========================================

PROMPT [4/1] PKG_FAC_FACTURA_CLIENTE...
@@PKG_FAC_FACTURA_CLIENTE.sql

PROMPT [4/2] PKG_CLI_CARRITO...
@@PKG_CLI_CARRITO.sql

PROMPT ==========================================
PROMPT VERIFICACION FINAL
PROMPT ==========================================

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
AND object_name IN (
    'PKG_ADMIN_LOGIN_CLIENTE',
    'PKG_CLI_CLIENTE',
    'PKG_BOD_HISTORIAL_PRECIO_VENTA',
    'PKG_CLI_CATALOGO',
    'PKG_FAC_FACTURA_CLIENTE',
    'PKG_CLI_CARRITO'
)
ORDER BY object_type, object_name;

PROMPT ==========================================
PROMPT INSTALACION CLIENTE COMPLETADA
PROMPT ==========================================