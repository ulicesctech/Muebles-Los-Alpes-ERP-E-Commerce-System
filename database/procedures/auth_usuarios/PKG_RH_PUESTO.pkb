CREATE OR REPLACE PACKAGE BODY PKG_RH_PUESTO AS
    PROCEDURE assert_not_null(p_val IN VARCHAR2, p_msg IN VARCHAR2) IS 
    BEGIN IF TRIM(p_val) IS NULL 
        THEN RAISE_APPLICATION_ERROR(-20001, p_msg); 
        END IF; 
    END;

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS 
    BEGIN 
        IF p_id IS NULL 
        THEN RAISE_APPLICATION_ERROR(-20002, p_msg); 
        END IF; 
    END;

    PROCEDURE PUE_CREAR(p_nombre IN VARCHAR2, p_salario IN NUMBER, p_descripcion IN VARCHAR2, p_id OUT NUMBER) IS
    BEGIN
        assert_not_null(p_nombre, 'Puesto: nombre obligatorio.');
        assert_not_null(p_descripcion, 'Puesto: descripcion obligatoria.');
        IF p_salario IS NULL 
            THEN RAISE_APPLICATION_ERROR(-20001, 'Puesto: salario obligatorio.'); 
    END IF;

    INSERT INTO RH_PUESTO(pue_nombre, pue_salario, pue_descripcion) 
    VALUES (
        TRIM(p_nombre), p_salario, 
        TRIM(p_descripcion)
        ) RETURNING pue_puestos INTO p_id;
    END;

    PROCEDURE PUE_ACTUALIZAR(
        p_id IN NUMBER, 
        p_nombre IN VARCHAR2, 
        p_salario IN NUMBER, 
        p_descripcion IN VARCHAR2) IS
    BEGIN
        assert_id(p_id, 'Puesto: ID obligatorio.');
        UPDATE RH_PUESTO SET pue_nombre = TRIM(p_nombre), pue_salario = p_salario, pue_descripcion = TRIM(p_descripcion) 
        WHERE pue_puestos = p_id;
    END;

    PROCEDURE PUE_ELIMINAR(p_id IN NUMBER) IS
    BEGIN
        assert_id(p_id, 'Puesto: ID obligatorio.');
        DELETE FROM RH_PUESTO WHERE pue_puestos = p_id;
    END;

    PROCEDURE PUE_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR SELECT * FROM RH_PUESTO ORDER BY pue_nombre;
    END;
    
END PKG_RH_PUESTO;
/