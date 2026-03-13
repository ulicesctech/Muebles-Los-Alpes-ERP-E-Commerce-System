CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_PROVEEDOR AS
    PROCEDURE assert_not_null(p_val IN VARCHAR2, p_msg IN VARCHAR2) IS
    BEGIN IF TRIM(p_val) IS NULL THEN RAISE_APPLICATION_ERROR(-20101, p_msg); END IF; END;

    PROCEDURE PROV_CREAR(p_nit IN VARCHAR2, p_nombre IN VARCHAR2, p_avenida IN VARCHAR2, p_zona IN VARCHAR2, p_direccion IN VARCHAR2, p_telefono IN VARCHAR2, p_id OUT NUMBER) IS
    BEGIN
        assert_not_null(p_nit, 'NIT obligatorio.');
        assert_not_null(p_nombre, 'Nombre obligatorio.');
        INSERT INTO BOD_PROVEEDOR(prov_nit, prov_nombre, prov_avenida, prov_zona, prov_direccion, prov_telefono)
        VALUES (TRIM(p_nit), TRIM(p_nombre), TRIM(p_avenida), TRIM(p_zona), TRIM(p_direccion), TRIM(p_telefono))
        RETURNING prov_proveedor INTO p_id;
    END;

    PROCEDURE PROV_ACTUALIZAR(p_id IN NUMBER, p_nit IN VARCHAR2, p_nombre IN VARCHAR2, p_avenida IN VARCHAR2, p_zona IN VARCHAR2, p_direccion IN VARCHAR2, p_telefono IN VARCHAR2) IS
    BEGIN
        UPDATE BOD_PROVEEDOR SET prov_nit = TRIM(p_nit), prov_nombre = TRIM(p_nombre), prov_avenida = TRIM(p_avenida),
            prov_zona = TRIM(p_zona), prov_direccion = TRIM(p_direccion), prov_telefono = TRIM(p_telefono)
        WHERE prov_proveedor = p_id;
    END;

    PROCEDURE PROV_ELIMINAR(p_id IN NUMBER) IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(1) INTO v_cnt FROM BOD_ORDEN_COMPRA WHERE prov_proveedor = p_id;
        IF v_cnt > 0 THEN RAISE_APPLICATION_ERROR(-20102, 'No se puede eliminar: El proveedor tiene órdenes asociadas.'); END IF;
        DELETE FROM BOD_PROVEEDOR WHERE prov_proveedor = p_id;
    END;

    PROCEDURE PROV_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN OPEN p_data FOR SELECT * FROM BOD_PROVEEDOR ORDER BY prov_nombre; END;
END PKG_CP_BOD_PROVEEDOR;
/