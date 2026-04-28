-- ============================================================
-- PKG_CP_BOD_PROVEEDOR.pkb
-- Body del package de proveedores.
-- PROV_BUSCAR: busca por NIT, nombre o telefono
-- ============================================================
CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_PROVEEDOR AS

    -- --------------------------------------------------------
    -- PROV_LISTAR
    -- Devuelve todos los proveedores ordenados por nombre.
    -- --------------------------------------------------------
    PROCEDURE PROV_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT prov_proveedor,
                   prov_nit,
                   prov_nombre,
                   prov_avenida,
                   prov_zona,
                   prov_direccion,
                   prov_telefono
              FROM BOD_PROVEEDOR
             ORDER BY prov_nombre;
    END PROV_LISTAR;

    -- --------------------------------------------------------
    -- PROV_BUSCAR
    -- Busca por NIT, nombre o telefono usando LIKE.
    -- La busqueda es case-insensitive gracias a UPPER.
    -- --------------------------------------------------------
    PROCEDURE PROV_BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
        v_txt VARCHAR2(255);
    BEGIN
        v_txt := '%' || UPPER(TRIM(NVL(p_texto, ''))) || '%';
        OPEN p_data FOR
            SELECT prov_proveedor,
                   prov_nit,
                   prov_nombre,
                   prov_avenida,
                   prov_zona,
                   prov_direccion,
                   prov_telefono
              FROM BOD_PROVEEDOR
             WHERE UPPER(prov_nit)      LIKE v_txt
                OR UPPER(prov_nombre)   LIKE v_txt
                OR UPPER(prov_telefono) LIKE v_txt
             ORDER BY prov_nombre;
    END PROV_BUSCAR;

    -- --------------------------------------------------------
    -- PROV_CREAR
    -- Inserta un nuevo proveedor y devuelve el ID generado.
    -- --------------------------------------------------------
    PROCEDURE PROV_CREAR(
        p_nit       IN  VARCHAR2,
        p_nombre    IN  VARCHAR2,
        p_avenida   IN  VARCHAR2,
        p_zona      IN  VARCHAR2,
        p_direccion IN  VARCHAR2,
        p_telefono  IN  VARCHAR2,
        p_id        OUT NUMBER
    ) IS
        v_nuevo NUMBER;
    BEGIN
        IF TRIM(p_nit) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'PKG_CP_BOD_PROVEEDOR: NIT obligatorio.');
        END IF;
        IF TRIM(p_nombre) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'PKG_CP_BOD_PROVEEDOR: nombre obligatorio.');
        END IF;
        IF TRIM(p_telefono) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'PKG_CP_BOD_PROVEEDOR: telefono obligatorio.');
        END IF;

        INSERT INTO BOD_PROVEEDOR(
            prov_nit, prov_nombre, prov_avenida,
            prov_zona, prov_direccion, prov_telefono)
        VALUES(
            TRIM(p_nit), TRIM(p_nombre), TRIM(p_avenida),
            TRIM(p_zona), TRIM(p_direccion), TRIM(p_telefono))
        RETURNING prov_proveedor INTO v_nuevo;

        COMMIT;
        p_id := v_nuevo;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20004, 'PKG_CP_BOD_PROVEEDOR: ya existe un proveedor con ese NIT.');
        WHEN OTHERS THEN
            ROLLBACK; RAISE;
    END PROV_CREAR;

    -- --------------------------------------------------------
    -- PROV_ACTUALIZAR
    -- Actualiza los datos de un proveedor existente.
    -- --------------------------------------------------------
    PROCEDURE PROV_ACTUALIZAR(
        p_id        IN NUMBER,
        p_nit       IN VARCHAR2,
        p_nombre    IN VARCHAR2,
        p_avenida   IN VARCHAR2,
        p_zona      IN VARCHAR2,
        p_direccion IN VARCHAR2,
        p_telefono  IN VARCHAR2
    ) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'PKG_CP_BOD_PROVEEDOR: ID obligatorio.');
        END IF;

        UPDATE BOD_PROVEEDOR
           SET prov_nit       = TRIM(p_nit),
               prov_nombre    = TRIM(p_nombre),
               prov_avenida   = TRIM(p_avenida),
               prov_zona      = TRIM(p_zona),
               prov_direccion = TRIM(p_direccion),
               prov_telefono  = TRIM(p_telefono)
         WHERE prov_proveedor = p_id;

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20006, 'PKG_CP_BOD_PROVEEDOR: ya existe un proveedor con ese NIT.');
        WHEN OTHERS THEN
            ROLLBACK; RAISE;
    END PROV_ACTUALIZAR;

    -- --------------------------------------------------------
    -- PROV_ELIMINAR
    -- Elimina un proveedor por ID.
    -- Si tiene registros relacionados Oracle lanzara ORA-02292
    -- que el code-behind maneja con mensaje amigable.
    -- --------------------------------------------------------
    PROCEDURE PROV_ELIMINAR(p_id IN NUMBER) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20007, 'PKG_CP_BOD_PROVEEDOR: ID obligatorio.');
        END IF;

        DELETE FROM BOD_PROVEEDOR
         WHERE prov_proveedor = p_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK; RAISE;
    END PROV_ELIMINAR;

END PKG_CP_BOD_PROVEEDOR;
/
