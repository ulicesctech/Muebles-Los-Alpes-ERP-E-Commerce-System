CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_PEDIDO AS

    PROCEDURE PED_CREAR(
        p_codigo     IN VARCHAR2, 
        p_forma_pago IN VARCHAR2, 
        p_total      IN NUMBER, 
        p_id         OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO BOD_PEDIDO (PED_CODIGO, PED_FORMA_PAGO, PED_TOTAL, PED_FECHA)
        VALUES (p_codigo, p_forma_pago, p_total, SYSDATE)
        RETURNING PED_PEDIDO INTO p_id;
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN 
            ROLLBACK; 
            RAISE;
    END;

    PROCEDURE PED_ACTUALIZAR(
        p_id         IN NUMBER, 
        p_codigo     IN VARCHAR2, 
        p_forma_pago IN VARCHAR2, 
        p_total      IN NUMBER
    ) AS
    BEGIN
        UPDATE BOD_PEDIDO 
        SET PED_CODIGO = p_codigo, 
            PED_FORMA_PAGO = p_forma_pago, 
            PED_TOTAL = p_total
        WHERE PED_PEDIDO = p_id;
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN 
            ROLLBACK; 
            RAISE;
    END;

    PROCEDURE PED_ELIMINAR(p_id IN NUMBER) AS
    BEGIN
        -- Primero borramos detalles para evitar error de llave foránea
        DELETE FROM BOD_DETALLE_PEDIDO WHERE PED_PEDIDO = p_id;
        DELETE FROM BOD_PEDIDO WHERE PED_PEDIDO = p_id;
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN 
            ROLLBACK; 
            RAISE;
    END;

    PROCEDURE PED_LISTAR(p_data OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN p_data FOR 
        SELECT PED_PEDIDO, PED_CODIGO, PED_FECHA, PED_FORMA_PAGO, PED_TOTAL 
        FROM BOD_PEDIDO 
        ORDER BY PED_PEDIDO DESC;
    END;

    PROCEDURE PED_BUSCAR(p_codigo IN VARCHAR2, p_data OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN p_data FOR 
        SELECT PED_PEDIDO, PED_CODIGO, PED_FECHA, PED_FORMA_PAGO, PED_TOTAL 
        FROM BOD_PEDIDO 
        WHERE UPPER(PED_CODIGO) LIKE '%' || UPPER(p_codigo) || '%'
        ORDER BY PED_PEDIDO DESC;
    END;

    -- IMPLEMENTACIÓN DE OBTENER_ID
    PROCEDURE PED_OBTENER_ID(p_id IN NUMBER, p_data OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN p_data FOR 
        SELECT PED_PEDIDO, PED_CODIGO, PED_FECHA, PED_FORMA_PAGO, PED_TOTAL 
        FROM BOD_PEDIDO 
        WHERE PED_PEDIDO = p_id;
    END;

END PKG_CP_BOD_PEDIDO;
/