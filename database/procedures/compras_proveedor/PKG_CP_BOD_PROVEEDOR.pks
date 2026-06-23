-- ============================================================
-- PKG_CP_BOD_PROVEEDOR.pks
-- Especificacion del package de proveedores.
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_CP_BOD_PROVEEDOR AS

    -- --------------------------------------------------------
    -- CRUD principal
    -- --------------------------------------------------------

    PROCEDURE PROV_LISTAR(p_data OUT SYS_REFCURSOR);

    PROCEDURE PROV_BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR);

    PROCEDURE PROV_CREAR(
        p_nit       IN  VARCHAR2,
        p_nombre    IN  VARCHAR2,
        p_avenida   IN  VARCHAR2,
        p_zona      IN  VARCHAR2,
        p_direccion IN  VARCHAR2,
        p_telefono  IN  VARCHAR2,
        p_id        OUT NUMBER
    );

    PROCEDURE PROV_ACTUALIZAR(
        p_id        IN NUMBER,
        p_nit       IN VARCHAR2,
        p_nombre    IN VARCHAR2,
        p_avenida   IN VARCHAR2,
        p_zona      IN VARCHAR2,
        p_direccion IN VARCHAR2,
        p_telefono  IN VARCHAR2
    );

    PROCEDURE PROV_ELIMINAR(p_id IN NUMBER);

    -- --------------------------------------------------------
    -- Validaciones expuestas — utiles para otros packages
    -- o para pruebas directas desde SQL.
    --
    -- Devuelven TRUE si el valor es valido.
    -- --------------------------------------------------------

    FUNCTION VALIDAR_NIT(p_nit IN VARCHAR2) RETURN BOOLEAN;

    FUNCTION VALIDAR_TELEFONO(p_telefono IN VARCHAR2) RETURN BOOLEAN;

END PKG_CP_BOD_PROVEEDOR;
/
