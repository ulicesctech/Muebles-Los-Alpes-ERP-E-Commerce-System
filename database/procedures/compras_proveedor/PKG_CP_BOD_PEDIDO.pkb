CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_PEDIDO AS
    PROCEDURE PED_CREAR(p_codigo IN VARCHAR2, p_forma_pago IN VARCHAR2, p_id OUT NUMBER) IS
    BEGIN
        INSERT INTO BOD_PEDIDO(ped_codigo, ped_forma_pago, ped_fecha, ped_total)
        VALUES (TRIM(p_codigo), NVL(p_forma_pago, 'SIMULADO'), SYSDATE, 0)
        RETURNING ped_pedido INTO p_id;
    END;

    PROCEDURE PED_AGREGAR_DETALLE(p_ped_id IN NUMBER, p_hip_id IN NUMBER, p_cant_sol IN NUMBER) IS
    BEGIN
        INSERT INTO BOD_DETALLE_PEDIDO(ped_pedido, hip_historial_precio, detpe_cantidad_solicitada)
        VALUES (p_ped_id, p_hip_id, p_cant_sol);
    END;

    PROCEDURE PED_ELIMINAR(p_id IN NUMBER) IS
    BEGIN
        DELETE FROM BOD_DETALLE_PEDIDO WHERE ped_pedido = p_id;
        DELETE FROM BOD_PEDIDO WHERE ped_pedido = p_id;
    END;

    PROCEDURE PED_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN OPEN p_data FOR SELECT * FROM BOD_PEDIDO ORDER BY ped_fecha DESC; END;
END PKG_CP_BOD_PEDIDO;
/