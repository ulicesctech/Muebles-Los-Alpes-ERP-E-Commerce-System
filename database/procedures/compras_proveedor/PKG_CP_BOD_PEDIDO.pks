CREATE OR REPLACE PACKAGE PKG_CP_BOD_PEDIDO AS

    -- Crea un pedido y retorna el ID generado
    PROCEDURE PED_CREAR(
        p_codigo     IN  VARCHAR2,
        p_forma_pago IN  VARCHAR2,
        p_total      IN  NUMBER,
        p_id         OUT NUMBER
    );

    -- Actualiza los datos de la cabecera
    PROCEDURE PED_ACTUALIZAR(
        p_id         IN NUMBER,
        p_codigo     IN VARCHAR2,
        p_forma_pago IN VARCHAR2,
        p_total      IN NUMBER
    );

    -- Agrega un detalle al pedido
    PROCEDURE PED_AGREGAR_DETALLE(
        p_ped_id   IN NUMBER,
        p_hip_id   IN NUMBER,
        p_cant_sol IN NUMBER
    );

    -- Elimina el pedido y sus detalles
    PROCEDURE PED_ELIMINAR(p_id IN NUMBER);

    -- Lista todos los pedidos
    PROCEDURE PED_LISTAR(p_data OUT SYS_REFCURSOR);

    -- Busqueda por codigo, producto o material
    PROCEDURE PED_BUSCAR(
        p_codigo IN  VARCHAR2,
        p_data   OUT SYS_REFCURSOR
    );

    -- Obtener un pedido por ID
    PROCEDURE PED_OBTENER_ID(
        p_id   IN  NUMBER,
        p_data OUT SYS_REFCURSOR
    );

    -- Marca un detalle como recibido y actualiza stock
    PROCEDURE PED_RECIBIR(
        p_detpe_id          IN NUMBER,
        p_cantidad_recibida IN NUMBER
    );

    -- Recibe todos los detalles del pedido y actualiza stock
    PROCEDURE PED_RECIBIR_TODO(p_ped_id IN NUMBER);

    -- Devuelve las formas de pago validas segun el CHECK constraint de BOD_PEDIDO
    -- Columnas: FORMA_PAGO (valor a guardar), DESCRIPCION (texto para mostrar)
    PROCEDURE PED_LISTAR_FORMAS_PAGO(p_data OUT SYS_REFCURSOR);

END PKG_CP_BOD_PEDIDO;
/
