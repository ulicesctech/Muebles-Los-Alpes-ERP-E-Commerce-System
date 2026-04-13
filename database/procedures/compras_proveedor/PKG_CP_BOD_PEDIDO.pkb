CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_PEDIDO AS

    PROCEDURE PED_CREAR(p_codigo IN VARCHAR2, p_forma_pago IN VARCHAR2, p_total IN NUMBER, p_id OUT NUMBER) IS
    BEGIN
        INSERT INTO BOD_PEDIDO(ped_codigo, ped_forma_pago, ped_fecha, ped_total)
        VALUES(TRIM(p_codigo), NVL(p_forma_pago, 'SIMULADO'), SYSDATE, NVL(p_total, 0))
        RETURNING ped_pedido INTO p_id;
    END;

    PROCEDURE PED_AGREGAR_DETALLE(p_ped_id IN NUMBER, p_hip_id IN NUMBER, p_cant_sol IN NUMBER) IS
    BEGIN
        INSERT INTO BOD_DETALLE_PEDIDO(ped_pedido, hip_historial_precio, detpe_cantidad_solicitada)
        VALUES(p_ped_id, p_hip_id, p_cant_sol);
    END;

    PROCEDURE PED_ELIMINAR(p_id IN NUMBER) IS
    BEGIN
        DELETE FROM BOD_DETALLE_PEDIDO WHERE ped_pedido = p_id;
        DELETE FROM BOD_PEDIDO WHERE ped_pedido = p_id;
    END;

    PROCEDURE PED_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR SELECT * FROM BOD_PEDIDO ORDER BY ped_fecha DESC;
    END;

    PROCEDURE PED_RECIBIR(p_detpe_id IN NUMBER, p_cantidad_recibida IN NUMBER) IS
        v_hip_id   NUMBER;
        v_cant_sol NUMBER;
    BEGIN
        IF p_detpe_id IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'BOD_DETALLE_PEDIDO: id obligatorio.'); END IF;
        IF p_cantidad_recibida IS NULL OR p_cantidad_recibida <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'BOD_DETALLE_PEDIDO: cantidad recibida debe ser > 0.');
        END IF;
        SELECT hip_historial_precio, detpe_cantidad_solicitada
          INTO v_hip_id, v_cant_sol
          FROM BOD_DETALLE_PEDIDO
         WHERE detpe_detalle_pedido = p_detpe_id;
        IF p_cantidad_recibida > v_cant_sol THEN
            RAISE_APPLICATION_ERROR(-20003, 'BOD_DETALLE_PEDIDO: cantidad recibida no puede superar la solicitada.');
        END IF;
        UPDATE BOD_DETALLE_PEDIDO
           SET detpe_cantidad_recibida = p_cantidad_recibida
         WHERE detpe_detalle_pedido = p_detpe_id;
        PKG_BOD_STOCK.ENTRADA(v_hip_id, p_cantidad_recibida);
    END;

    PROCEDURE PED_RECIBIR_TODO(p_ped_id IN NUMBER) IS
        CURSOR c_detalles IS
          SELECT detpe_detalle_pedido, hip_historial_precio, detpe_cantidad_solicitada
            FROM BOD_DETALLE_PEDIDO
           WHERE ped_pedido = p_ped_id;
    BEGIN
        IF p_ped_id IS NULL THEN RAISE_APPLICATION_ERROR(-20004, 'BOD_PEDIDO: id obligatorio.'); END IF;
        FOR r IN c_detalles LOOP
            UPDATE BOD_DETALLE_PEDIDO
               SET detpe_cantidad_recibida = r.detpe_cantidad_solicitada
             WHERE detpe_detalle_pedido = r.detpe_detalle_pedido;
            PKG_BOD_STOCK.ENTRADA(r.hip_historial_precio, r.detpe_cantidad_solicitada);
        END LOOP;
    END;

END PKG_CP_BOD_PEDIDO;
/