CREATE OR REPLACE PACKAGE PKG_CP_BOD_PEDIDO AS

    -- Se agrega p_total para guardar el monto desde el inicio
    PROCEDURE PED_CREAR(
        p_codigo     IN VARCHAR2, 
        p_forma_pago IN VARCHAR2, 
        p_total      IN NUMBER, 
        p_id         OUT NUMBER
    );

    PROCEDURE PED_ACTUALIZAR(
        p_id         IN NUMBER, 
        p_codigo     IN VARCHAR2, 
        p_forma_pago IN VARCHAR2, 
        p_total      IN NUMBER
    );

    PROCEDURE PED_ELIMINAR(p_id IN NUMBER);

    PROCEDURE PED_LISTAR(p_data OUT SYS_REFCURSOR);

    -- Búsqueda optimizada
    PROCEDURE PED_BUSCAR(
        p_codigo     IN VARCHAR2, 
        p_data       OUT SYS_REFCURSOR
    );

END PKG_CP_BOD_PEDIDO;
/