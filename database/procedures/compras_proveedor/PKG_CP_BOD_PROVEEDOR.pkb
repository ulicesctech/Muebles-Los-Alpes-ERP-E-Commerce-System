-- ============================================================
-- PKG_CP_BOD_PROVEEDOR.pkb
-- Body del package de proveedores.
-- ============================================================
CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_PROVEEDOR AS

    -- ==========================================================
    -- VALIDACIONES CENTRALIZADAS
    -- Modificar SOLO estas dos funciones para cambiar las reglas.
    -- ==========================================================

    -- ----------------------------------------------------------
    -- VALIDAR_NIT
    -- Formatos validos (Guatemala):
    --   NIT 9 digitos  : exactamente 9 digitos numericos
    --                    Ej: 123456789
    --   NIT 8dig + K   : exactamente 8 digitos + K mayuscula
    --                    Ej: 12345678K
    --   CUI            : exactamente 13 digitos
    --                    Ej: 1234567890101
    -- NOTA: \d NO funciona en Oracle REGEXP_LIKE (POSIX).
    --       Se usa [0-9] en su lugar.
    -- ----------------------------------------------------------
    FUNCTION VALIDAR_NIT(p_nit IN VARCHAR2) RETURN BOOLEAN IS
        v_nit VARCHAR2(20);
    BEGIN
        v_nit := UPPER(TRIM(p_nit));

        -- CUI: exactamente 13 digitos
        IF REGEXP_LIKE(v_nit, '^[0-9]{13}$') THEN
            RETURN TRUE;
        END IF;

        -- NIT: exactamente 9 digitos numericos
        IF REGEXP_LIKE(v_nit, '^[0-9]{9}$') THEN
            RETURN TRUE;
        END IF;

        -- NIT: exactamente 8 digitos + K como digito verificador
        IF REGEXP_LIKE(v_nit, '^[0-9]{8}K$') THEN
            RETURN TRUE;
        END IF;

        RETURN FALSE;
    END VALIDAR_NIT;

    -- ----------------------------------------------------------
    -- VALIDAR_TELEFONO
    -- Regla actual: exactamente 8 digitos numericos.
    -- Ej: 22223333
    -- Para cambiar a otro formato (ej: +502XXXXXXXX) solo
    -- hay que editar la expresion regular de abajo.
    -- ----------------------------------------------------------
    FUNCTION VALIDAR_TELEFONO(p_telefono IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN REGEXP_LIKE(TRIM(p_telefono), '^[0-9]{8}$');
    END VALIDAR_TELEFONO;

    -- ==========================================================
    -- HELPER PRIVADO: valida todos los campos y lanza error
    -- si algo falla. Reutilizado por PROV_CREAR y PROV_ACTUALIZAR.
    -- ==========================================================
    PROCEDURE VALIDAR_CAMPOS(
        p_nit      IN VARCHAR2,
        p_nombre   IN VARCHAR2,
        p_avenida  IN VARCHAR2,
        p_zona     IN VARCHAR2,
        p_direccion IN VARCHAR2,
        p_telefono IN VARCHAR2
    ) IS
    BEGIN
        IF TRIM(p_nit) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'PKG_CP_BOD_PROVEEDOR: NIT obligatorio.');
        END IF;

        IF NOT VALIDAR_NIT(p_nit) THEN
            RAISE_APPLICATION_ERROR(-20008,
                'PKG_CP_BOD_PROVEEDOR: NIT o CUI con formato invalido. ' ||
                'Formatos aceptados: 9 digitos (ej: 123456789), ' ||
                '8 digitos + K (ej: 12345678K), ' ||
                'o CUI de 13 digitos (ej: 1234567890101).');
        END IF;

        IF TRIM(p_nombre) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'PKG_CP_BOD_PROVEEDOR: nombre obligatorio.');
        END IF;

        IF TRIM(p_avenida) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20009, 'PKG_CP_BOD_PROVEEDOR: avenida obligatoria.');
        END IF;

        IF TRIM(p_zona) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20010, 'PKG_CP_BOD_PROVEEDOR: zona obligatoria.');
        END IF;

        IF TRIM(p_direccion) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20011, 'PKG_CP_BOD_PROVEEDOR: direccion obligatoria.');
        END IF;

        IF TRIM(p_telefono) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'PKG_CP_BOD_PROVEEDOR: telefono obligatorio.');
        END IF;

        IF NOT VALIDAR_TELEFONO(p_telefono) THEN
            RAISE_APPLICATION_ERROR(-20012,
                'PKG_CP_BOD_PROVEEDOR: telefono invalido. ' ||
                'Debe tener exactamente 8 digitos numericos (ej: 22223333).');
        END IF;
    END VALIDAR_CAMPOS;

    -- ==========================================================
    -- PROV_LISTAR
    -- ==========================================================
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

    -- ==========================================================
    -- PROV_BUSCAR
    -- ==========================================================
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

    -- ==========================================================
    -- PROV_CREAR
    -- ==========================================================
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
        -- Toda la logica de validacion en un solo lugar
        VALIDAR_CAMPOS(p_nit, p_nombre, p_avenida, p_zona, p_direccion, p_telefono);

        INSERT INTO BOD_PROVEEDOR(
            prov_nit, prov_nombre, prov_avenida,
            prov_zona, prov_direccion, prov_telefono)
        VALUES(
            UPPER(TRIM(p_nit)), TRIM(p_nombre), TRIM(p_avenida),
            TRIM(p_zona),       TRIM(p_direccion), TRIM(p_telefono))
        RETURNING prov_proveedor INTO v_nuevo;

        COMMIT;
        p_id := v_nuevo;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20004,
                'PKG_CP_BOD_PROVEEDOR: ya existe un proveedor con ese NIT.');
        WHEN OTHERS THEN
            ROLLBACK; RAISE;
    END PROV_CREAR;

    -- ==========================================================
    -- PROV_ACTUALIZAR
    -- ==========================================================
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

        VALIDAR_CAMPOS(p_nit, p_nombre, p_avenida, p_zona, p_direccion, p_telefono);

        UPDATE BOD_PROVEEDOR
           SET prov_nit       = UPPER(TRIM(p_nit)),
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
            RAISE_APPLICATION_ERROR(-20006,
                'PKG_CP_BOD_PROVEEDOR: ya existe un proveedor con ese NIT.');
        WHEN OTHERS THEN
            ROLLBACK; RAISE;
    END PROV_ACTUALIZAR;

    -- ==========================================================
    -- PROV_ELIMINAR
    -- ==========================================================
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
