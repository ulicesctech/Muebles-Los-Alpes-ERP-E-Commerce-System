-- ============================================================
-- SCRIPT MAESTRO INTEGRAL (17 ELEMENTOS) - MÓDULO COMPRAS
-- ============================================================

-- DEFINIR RUTA (Cambia esta ruta por la de tu carpeta actual si es distinta)
DEFINE ruta = "C:\Users\AGALVEZ\Documents\prueba\Muebles-Los-Alpes-ERP-E-Commerce-System\database\procedures\compras_proveedor"

PROMPT >>> INICIANDO INSTALACION DESDE: &&ruta

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
-- NOTA: Se usa @@ y comillas por si los nombres son largos o tienen espacios
@@"&&ruta\PKG_CP_BOD_ORDEN_COMPRA.pks"
@@"&&ruta\PKG_CP_BOD_ORDEN_COMPRA.pkb"
@@"&&ruta\PKG_CP_BOD_ORDEN_DETALLE_PEDIDO.pks"
@@"&&ruta\PKG_CP_BOD_ORDEN_DETALLE_PEDIDO.pkb"


-- 2. MÓDULO FACTURACIÓN Y RECLAMOS (6 Elementos)

-- Facturas (2)
@@"&&ruta\PKG_CP_FAC_FACTURA_PROV.pks"
@@"&&ruta\PKG_CP_FAC_FACTURA_PROV.pkb"

-- Reclamos (2)
@@"&&ruta\PKG_CP_FAC_RECLAMO_PROV.pks"
@@"&&ruta\PKG_CP_FAC_RECLAMO_PROV.pkb"



-- 4. VERIFICACIÓN DE ESTADO FINAL
PROMPT >>> VERIFICANDO PAQUETES...

SET PAGESIZE 50
COLUMN object_name FORMAT A40
COLUMN object_type FORMAT A15
COLUMN status FORMAT A10

SELECT object_name, object_type, status
FROM user_objects
WHERE object_name LIKE 'PKG_CP_%'
  AND object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;

PROMPT >>> CONTEO TOTAL DE COMPONENTES:
SELECT COUNT(*) FROM user_objects WHERE object_name LIKE 'PKG_CP_%';