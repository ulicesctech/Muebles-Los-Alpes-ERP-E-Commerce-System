CREATE OR REPLACE PACKAGE PKG_CP_BOD_ORDEN_COMPRA AS

    -- Crea una nueva orden de compra
    PROCEDURE ORC_CREAR(
        p_orc_key  IN VARCHAR2,
        p_codigo   IN VARCHAR2,
        p_prov_id  IN NUMBER,
        p_total    IN NUMBER
    );

    -- Actualiza los datos generales de una orden de compra
    PROCEDURE ORC_ACTUALIZAR(
        p_orc_key IN VARCHAR2,
        p_codigo  IN VARCHAR2,
        p_prov_id IN NUMBER,
        p_total   IN NUMBER
    );

    -- Actualiza únicamente el total de la orden
    PROCEDURE ORC_ACTUALIZAR_TOTAL(
        p_orc_key IN VARCHAR2,
        p_total   IN NUMBER
    );

    -- Elimina la orden de compra y sus detalles asociados
    PROCEDURE ORC_ELIMINAR(p_orc_key IN VARCHAR2);

    -- Lista todas las órdenes de compra con el nombre del proveedor
    PROCEDURE ORC_LISTAR(p_data OUT SYS_REFCURSOR);

    -- Obtiene la cabecera y el detalle de una orden de compra específica por su KEY
    PROCEDURE ORC_LISTAR_ID(
        p_orc_key IN VARCHAR2,
        p_data    OUT SYS_REFCURSOR
    );

    -- Busca órdenes de compra por código, nombre de proveedor o KEY
    PROCEDURE ORC_BUSCAR(
        p_codigo IN VARCHAR2,
        p_data   OUT SYS_REFCURSOR
    );

    -- Busca pedidos (cabeceras) para ser utilizados en órdenes de compra
    PROCEDURE ORC_BUSCAR_PEDIDOS(
        p_texto IN VARCHAR2,
        p_data  OUT SYS_REFCURSOR
    );

    -- Devuelve los items de un pedido basándose en la referencia directa del producto
    PROCEDURE ORC_DETALLES_PEDIDO(
        p_ped_id IN NUMBER,
        p_data   OUT SYS_REFCURSOR
    );

END PKG_CP_BOD_ORDEN_COMPRA;
/