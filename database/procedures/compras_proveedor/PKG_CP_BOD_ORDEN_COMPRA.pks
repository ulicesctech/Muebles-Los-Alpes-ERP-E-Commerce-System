CREATE OR REPLACE PACKAGE PKG_CP_BOD_ORDEN_COMPRA AS

    PROCEDURE ORC_CREAR(
        p_orc_key  IN VARCHAR2, 
        p_codigo   IN VARCHAR2, 
        p_prov_id  IN NUMBER, 
        p_total    IN NUMBER
    );

    PROCEDURE ORC_ACTUALIZAR(
        p_orc_key IN VARCHAR2, 
        p_codigo  IN VARCHAR2, 
        p_prov_id IN NUMBER,   
        p_total   IN NUMBER
    );

    PROCEDURE ORC_ACTUALIZAR_TOTAL(
        p_orc_key IN VARCHAR2,
        p_total   IN NUMBER
    );

    PROCEDURE ORC_ELIMINAR(p_orc_key IN VARCHAR2);

    PROCEDURE ORC_LISTAR(p_data OUT SYS_REFCURSOR);

    PROCEDURE ORC_LISTAR_ID(
        p_orc_key IN VARCHAR2, 
        p_data    OUT SYS_REFCURSOR
    );

    PROCEDURE ORC_BUSCAR(
        p_codigo IN VARCHAR2, 
        p_data   OUT SYS_REFCURSOR
    );

END PKG_CP_BOD_ORDEN_COMPRA;
/