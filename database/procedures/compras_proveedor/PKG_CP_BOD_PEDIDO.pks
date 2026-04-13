CREATE OR REPLACE PACKAGE PKG_CP_BOD_PEDIDO AS

    -- Crea un pedido y retorna el ID generado
    PROCEDURE PED_CREAR(
        p_codigo     IN VARCHAR2, 
        p_forma_pago IN VARCHAR2, 
        p_total      IN NUMBER, 
        p_id         OUT NUMBER
    );

    -- Actualiza los datos de la cabecera
    PROCEDURE PED_ACTUALIZAR(
        p_id         IN NUMBER, 
        p_codigo     IN VARCHAR2, 
        p_forma_pago IN VARCHAR2, 
        p_total      IN NUMBER
    );

    -- Elimina el pedido y sus detalles (integridad referencial)
    PROCEDURE PED_ELIMINAR(p_id IN NUMBER);

    -- Lista todos los pedidos
    PROCEDURE PED_LISTAR(p_data OUT SYS_REFCURSOR);

    -- Búsqueda por código
    PROCEDURE PED_BUSCAR(
        p_codigo     IN VARCHAR2, 
        p_data       OUT SYS_REFCURSOR
    );

    -- NUEVO: Obtener un solo pedido por su ID (Necesario para Editar/Detalle)
    PROCEDURE PED_OBTENER_ID(
        p_id         IN NUMBER, 
        p_data       OUT SYS_REFCURSOR
    );

END PKG_CP_BOD_PEDIDO;
/