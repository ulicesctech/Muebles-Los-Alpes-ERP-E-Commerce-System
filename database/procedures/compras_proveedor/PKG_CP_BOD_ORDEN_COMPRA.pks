-- ============================================================
-- PKG_CP_BOD_ORDEN_COMPRA.pks
-- Especificacion del package de Ordenes de Compra.
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_CP_BOD_ORDEN_COMPRA AS

    -- Crea una orden de compra.
    -- El key (orc_orden_compra) y el codigo (orc_codigo) se generan
    -- internamente usando C_PREFIJO_ORC y C_PREFIJO_COD del package body.
    -- p_orc_key_out devuelve el key generado para que el VB lo use.
    PROCEDURE ORC_CREAR(
        p_prov_id     IN  NUMBER,
        p_total       IN  NUMBER,
        p_orc_key_out OUT VARCHAR2
    );

    -- Actualiza cabecera de una orden de compra
    PROCEDURE ORC_ACTUALIZAR(
        p_orc_key IN VARCHAR2,
        p_codigo  IN VARCHAR2,
        p_prov_id IN NUMBER,
        p_total   IN NUMBER
    );

    -- Actualiza solo el total de una orden de compra
    PROCEDURE ORC_ACTUALIZAR_TOTAL(
        p_orc_key IN VARCHAR2,
        p_total   IN NUMBER
    );

    -- Elimina una orden de compra y sus detalles
    PROCEDURE ORC_ELIMINAR(p_orc_key IN VARCHAR2);

    -- Lista todas las ordenes de compra
    PROCEDURE ORC_LISTAR(p_data OUT SYS_REFCURSOR);

    -- Obtiene una orden de compra por su clave primaria
    PROCEDURE ORC_LISTAR_ID(
        p_orc_key IN  VARCHAR2,
        p_data    OUT SYS_REFCURSOR
    );

    -- Busca ordenes por codigo, proveedor o clave
    PROCEDURE ORC_BUSCAR(
        p_codigo IN  VARCHAR2,
        p_data   OUT SYS_REFCURSOR
    );

    -- Busca pedidos disponibles para vincular a una orden
    PROCEDURE ORC_BUSCAR_PEDIDOS(
        p_texto IN  VARCHAR2,
        p_data  OUT SYS_REFCURSOR
    );

    -- Lista los detalles de un pedido para vincularlo a la orden
    PROCEDURE ORC_DETALLES_PEDIDO(
        p_ped_id IN  NUMBER,
        p_data   OUT SYS_REFCURSOR
    );

END PKG_CP_BOD_ORDEN_COMPRA;
/
