-- ==========================================================
-- 00_install_catalogo_inventario.sql
-- Ejecutar con F5 (Run Script)
-- ==========================================================

-- 1) CATALOGO (MAESTROS)
@PKG_CI_CATALOGOS.pks
@PKG_CI_CATALOGOS.pkb

@PKG_CI_PRODUCTO.pks
@PKG_CI_PRODUCTO.pkb

-- 2) UBICACION (ALMACEN / NICHO / NIC_ALM)
@PKG_CI_UBICACION.pks
@PKG_CI_UBICACION.pkb

-- 3) PRECIO Y STOCK (HISTORIAL_PRECIO / STOCK)
@PKG_CI_PRECIO_STOCK.pks
@PKG_CI_PRECIO_STOCK.pkb

-- 4) PROMOCIONES
@PKG_CI_PROMO.pks
@PKG_CI_PROMO.pkb