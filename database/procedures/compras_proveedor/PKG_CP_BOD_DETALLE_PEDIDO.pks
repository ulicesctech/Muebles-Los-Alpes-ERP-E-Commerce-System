CREATE OR REPLACE PACKAGE PKG_BOD_DETALLE_PEDIDO AS
    PROCEDURE DET_PED_INSERTAR(
        p_ped_pedido      IN NUMBER,
        p_hip_historial   IN NUMBER,
        p_pro_referencia  IN VARCHAR2,
        p_cant_solicitada IN NUMBER,
        p_cant_recibida   IN NUMBER DEFAULT 0
    );
    PROCEDURE DET_PED_ACTUALIZAR(
        p_detpe_id        IN NUMBER,
        p_cant_solicitada IN NUMBER,
        p_cant_recibida   IN NUMBER
    );
    PROCEDURE DET_PED_ELIMINAR(p_detpe_id IN NUMBER);
    PROCEDURE DET_PED_LISTAR_POR_PEDIDO(
        p_ped_pedido IN NUMBER,
        p_data       OUT SYS_REFCURSOR
    );
    PROCEDURE DET_PED_LISTAR_PRODUCTOS(p_data OUT SYS_REFCURSOR);
    PROCEDURE DET_PED_LISTAR_PRODUCTOS_BASE(p_data OUT SYS_REFCURSOR);
    PROCEDURE DET_PED_LISTAR_TODOS_PRODUCTOS(p_data OUT SYS_REFCURSOR);
    PROCEDURE DET_PED_ACTUALIZAR_HISTORIAL(
        p_detpe_id IN NUMBER,
        p_hip_id   IN NUMBER
    );
END PKG_BOD_DETALLE_PEDIDO;
/