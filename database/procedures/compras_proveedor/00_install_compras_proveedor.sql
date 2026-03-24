-- 1. Cambia a la carpeta donde tienes tus archivos .pks y .pkb
-- Ejemplo: cd "C:\Usuarios\Ashley\Proyectos\Clinica\Database\Scripts"
cd "TU RUTA AQUI"

-- 2. MÓDULO DE BODEGA (BOD)
-- Proveedores
@PKG_CP_BOD_PROVEEDOR.pks
@PKG_CP_BOD_PROVEEDOR.pkb

-- Pedidos
@PKG_CP_BOD_PEDIDO.pks
@PKG_CP_BOD_PEDIDO.pkb

-- Órdenes de Compra
@PKG_CP_BOD_ORDEN_COMPRA.pks
@PKG_CP_BOD_ORDEN_COMPRA.pkb


-- 3. MÓDULO DE FACTURACIÓN (FAC)
-- Facturas de Proveedores
@PKG_CP_FAC_FACTURA_PROV.pks
@PKG_CP_FAC_FACTURA_PROV.pkb

-- Reclamos de Proveedores
@PKG_CP_FAC_RECLAMO_PROV.pks
@PKG_CP_FAC_RECLAMO_PROV.pkb


-- 4. VERIFICACIÓN DE ESTADO
-- Este comando te dirá si algún paquete quedó con errores (INVALID)
COLUMN object_name FORMAT A30
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name LIKE 'PKG_CP_%'
  AND object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;