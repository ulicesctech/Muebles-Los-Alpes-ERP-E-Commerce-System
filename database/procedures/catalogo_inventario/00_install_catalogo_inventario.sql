-- ==========================================================
-- 00_install_catalogo_inventario.sql
-- Modulo: Catologo & Inventario Bodega - Ulices
-- Ejecutar con F5 en Oracle SQL Developer
-- Recomendacion: abrir este archivo desde la carpeta donde estan los .pks/.pkb
-- ==========================================================

SET DEFINE OFF;

PROMPT ============================================
PROMPT 1) CATALOGO (MAESTROS)
PROMPT ============================================

-- BOD_CATEGORIA
@PKG_BOD_CATEGORIA.pks
@PKG_BOD_CATEGORIA.pkb

-- BOD_MATERIAL
@PKG_BOD_MATERIAL.pks
@PKG_BOD_MATERIAL.pkb

-- BOD_TIPO (depende de BOD_CATEGORIA)
@PKG_BOD_TIPO.pks
@PKG_BOD_TIPO.pkb

-- BOD_PRODUCTO (depende de BOD_TIPO y BOD_MATERIAL)
@PKG_BOD_PRODUCTO.pks
@PKG_BOD_PRODUCTO.pkb


PROMPT ============================================
PROMPT 2) UBICACION FISICA
PROMPT ============================================

-- BOD_ALMACEN
@PKG_BOD_ALMACEN.pks
@PKG_BOD_ALMACEN.pkb

-- BOD_NICHO
@PKG_BOD_NICHO.pks
@PKG_BOD_NICHO.pkb

-- BOD_NIC_ALM (depende de BOD_NICHO y BOD_ALMACEN)
@PKG_BOD_NIC_ALM.pks
@PKG_BOD_NIC_ALM.pkb


PROMPT ============================================
PROMPT 3) PRECIO E INVENTARIO
PROMPT ============================================

-- BOD_HISTORIAL_PRECIO (depende de BOD_PRODUCTO y BOD_NICHO)
@PKG_BOD_HISTORIAL_PRECIO.pks
@PKG_BOD_HISTORIAL_PRECIO.pkb

-- BOD_STOCK (depende de BOD_HISTORIAL_PRECIO)
@PKG_BOD_STOCK.pks
@PKG_BOD_STOCK.pkb


PROMPT ============================================
PROMPT 4) PROMOCIONES
PROMPT ============================================

-- PROMO_PROMOCION (depende de BOD_PRODUCTO)
@PKG_PROMO_PROMOCION.pks
@PKG_PROMO_PROMOCION.pkb


PROMPT ============================================
PROMPT VALIDACION DE OBJETOS (PACKAGE/PACKAGE BODY)
PROMPT ============================================

COLUMN object_name FORMAT A35
COLUMN object_type FORMAT A15
COLUMN status      FORMAT A10

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE','PACKAGE BODY')
  AND object_name IN (
    'PKG_BOD_CATEGORIA',
    'PKG_BOD_MATERIAL',
    'PKG_BOD_TIPO',
    'PKG_BOD_PRODUCTO',
    'PKG_BOD_ALMACEN',
    'PKG_BOD_NICHO',
    'PKG_BOD_NIC_ALM',
    'PKG_BOD_HISTORIAL_PRECIO',
    'PKG_BOD_STOCK',
    'PKG_PROMO_PROMOCION'
  )
ORDER BY object_name, object_type;

PROMPT ============================================
PROMPT FIN DE INSTALACION - CATALOGO_INVENTARIO
PROMPT ============================================