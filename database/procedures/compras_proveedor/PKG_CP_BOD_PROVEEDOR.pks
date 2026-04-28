-- ============================================================
-- PKG_CP_BOD_PROVEEDOR.pks
-- Especificacion del package de proveedores.
-- Procedimientos alineados con ProveedorService.vb
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_CP_BOD_PROVEEDOR AS

    -- Lista todos los proveedores ordenados por nombre
    PROCEDURE PROV_LISTAR(p_data OUT SYS_REFCURSOR);

    -- Busca por NIT, nombre o telefono (LIKE, case-insensitive)
    PROCEDURE PROV_BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR);

    -- Crea un proveedor nuevo y devuelve el ID generado
    PROCEDURE PROV_CREAR(
        p_nit       IN  VARCHAR2,
        p_nombre    IN  VARCHAR2,
        p_avenida   IN  VARCHAR2,
        p_zona      IN  VARCHAR2,
        p_direccion IN  VARCHAR2,
        p_telefono  IN  VARCHAR2,
        p_id        OUT NUMBER
    );

    -- Actualiza los datos de un proveedor existente
    PROCEDURE PROV_ACTUALIZAR(
        p_id        IN NUMBER,
        p_nit       IN VARCHAR2,
        p_nombre    IN VARCHAR2,
        p_avenida   IN VARCHAR2,
        p_zona      IN VARCHAR2,
        p_direccion IN VARCHAR2,
        p_telefono  IN VARCHAR2
    );

    -- Elimina un proveedor por ID
    PROCEDURE PROV_ELIMINAR(p_id IN NUMBER);

END PKG_CP_BOD_PROVEEDOR;
/
