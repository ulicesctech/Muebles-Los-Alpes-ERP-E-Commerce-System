CREATE OR REPLACE PACKAGE PKG_BOD_ORDEN_DETALLE_PEDIDO AS

    PROCEDURE ODP_INSERTAR(
        p_orc_key  IN VARCHAR2,
        p_ped_id   IN NUMBER,
        p_material IN VARCHAR2,
        p_producto IN VARCHAR2,
        p_precio   IN NUMBER,
        p_cantidad IN NUMBER
    );

    PROCEDURE ODP_ACTUALIZAR(
        p_odp_id   IN NUMBER,
        p_material IN VARCHAR2,
        p_producto IN VARCHAR2,
        p_precio   IN NUMBER,
        p_cantidad IN NUMBER
    );

    PROCEDURE ODP_ELIMINAR(p_odp_id IN NUMBER);

    PROCEDURE ODP_LISTAR_POR_ORDEN(
        p_orc_key IN VARCHAR2,
        p_data    OUT SYS_REFCURSOR
    );

    PROCEDURE ODP_LISTAR_POR_PEDIDO(
        p_ped_id IN NUMBER,
        p_data   OUT SYS_REFCURSOR
    );

END PKG_BOD_ORDEN_DETALLE_PEDIDO;
/
