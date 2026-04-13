CREATE OR REPLACE PACKAGE BODY PKG_RH_ASCENSO AS
    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS 
    BEGIN 
        IF p_id IS NULL 
        THEN RAISE_APPLICATION_ERROR(-20002, p_msg); 
        END IF;
    END;

    PROCEDURE ASCEN_CREAR(p_id_puesto IN NUMBER, p_id_empleado IN NUMBER, p_id OUT NUMBER) IS
    BEGIN
        assert_id(p_id_puesto, 'Ascenso: Puesto obligatorio.');
        assert_id(p_id_empleado, 'Ascenso: Empleado obligatorio.');
    
        -- Cerramos el puesto anterior (si lo tuviera)
        UPDATE RH_ASCENSO SET asc_fecha_final = SYSDATE 
        WHERE em_empleado = p_id_empleado AND asc_fecha_final IS NULL;

        INSERT INTO RH_ASCENSO (pue_puestos, em_empleado, asc_fecha_inicio) 
        VALUES (p_id_puesto, p_id_empleado, SYSDATE) 
        RETURNING asc_ascenso INTO p_id;
    END;

    PROCEDURE ASCEN_CERRAR(p_id_ascenso IN NUMBER) IS
    BEGIN
        UPDATE RH_ASCENSO SET asc_fecha_final = SYSDATE WHERE asc_ascenso = p_id_ascenso;
    END;

    PROCEDURE ASCEN_LISTAR_POR_EMP(p_id_empleado IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR SELECT a.*, p.pue_nombre 
        FROM RH_ASCENSO a JOIN RH_PUESTO p ON a.pue_puestos = p.pue_puestos 
        WHERE a.em_empleado = p_id_empleado ORDER BY a.asc_fecha_inicio DESC;
    END;
END PKG_RH_ASCENSO;
/