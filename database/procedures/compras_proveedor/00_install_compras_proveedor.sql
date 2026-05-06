-- ============================================================
-- SCRIPT MAESTRO INTEGRAL (17 ELEMENTOS) - MÓDULO COMPRAS
-- ============================================================
DEFINE ruta = "C:\Users\AGALVEZ\Documents\Muebleria oficial\Muebles-Los-Alpes-ERP-E-Commerce-System\database\procedures\compras_proveedor"
--DEFINE ruta_catalogo = "C:\Users\AGALVEZ\Documents\Muebleria oficial\Muebles-Los-Alpes-ERP-E-Commerce-System\database\procedures\catalogo_inventario"

PROMPT >>> INICIANDO INSTALACION DESDE: &&ruta

-- 0. DEPENDENCIAS EXTERNAS (requeridas por compras)
-- Stock es necesario para PKG_CP_BOD_PEDIDO.PED_RECIBIR y PED_RECIBIR_TODO
--@@"&&ruta_catalogo\PKG_BOD_STOCK.pks.sql"
--@@"&&ruta_catalogo\PKG_BOD_STOCK.pkb.sql"

-- 1. MÓDULO BODEGA (10 Elementos)
-- Proveedores (2)
@@"&&ruta\PKG_CP_BOD_PROVEEDOR.pks"
@@"&&ruta\PKG_CP_BOD_PROVEEDOR.pkb"
-- Pedidos (4)
@@"&&ruta\PKG_CP_BOD_PEDIDO.pks"
@@"&&ruta\PKG_CP_BOD_PEDIDO.pkb"
@@"&&ruta\PKG_CP_BOD_DETALLE_PEDIDO.pks"
@@"&&ruta\PKG_CP_BOD_DETALLE_PEDIDO.pkb"
-- Ordenes de Compra y Detalles (4)
@@"&&ruta\PKG_CP_BOD_ORDEN_COMPRA.pks"
@@"&&ruta\PKG_CP_BOD_ORDEN_COMPRA.pkb"
@@"&&ruta\PKG_CP_BOD_ORDEN_DETALLE_PEDIDO.pks"
@@"&&ruta\PKG_CP_BOD_ORDEN_DETALLE_PEDIDO.pkb"

-- 2. MÓDULO FACTURACIÓN Y RECLAMOS (6 Elementos)
@@"&&ruta\PKG_CP_FAC_FACTURA_PROV.pks"
@@"&&ruta\PKG_CP_FAC_FACTURA_PROV.pkb"
@@"&&ruta\PKG_CP_FAC_RECLAMO_PROV.pks"
@@"&&ruta\PKG_CP_FAC_RECLAMO_PROV.pkb"

-- 3. VERIFICACIÓN DE ESTADO FINAL
PROMPT >>> VERIFICANDO PAQUETES...
SET PAGESIZE 50
COLUMN object_name FORMAT A40
COLUMN object_type FORMAT A15
COLUMN status      FORMAT A10

SELECT object_name, object_type, status
FROM user_objects
WHERE object_name IN (
    'PKG_BOD_STOCK',
    'PKG_CP_BOD_PROVEEDOR',
    'PKG_CP_BOD_PEDIDO',
    'PKG_BOD_DETALLE_PEDIDO',
    'PKG_CP_BOD_ORDEN_COMPRA',
    'PKG_BOD_ORDEN_DETALLE_PEDIDO',
    'PKG_CP_FAC_FACTURA_PROV',
    'PKG_CP_FAC_RECLAMO_PROV'
)
AND object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;

PROMPT >>> CONTEO TOTAL DE COMPONENTES:
SELECT COUNT(*) FROM user_objects
WHERE object_name IN (
    --'PKG_BOD_STOCK',
    'PKG_CP_BOD_PROVEEDOR',
    'PKG_CP_BOD_PEDIDO',
    'PKG_BOD_DETALLE_PEDIDO',
    'PKG_CP_BOD_ORDEN_COMPRA',
    'PKG_BOD_ORDEN_DETALLE_PEDIDO',
    'PKG_CP_FAC_FACTURA_PROV',
    'PKG_CP_FAC_RECLAMO_PROV'
);