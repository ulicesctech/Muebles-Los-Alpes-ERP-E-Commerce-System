CREATE OR REPLACE PACKAGE PKG_CP_FAC_RECLAMO_PROV AS

    -- Procedimiento para crear: Recibe 2 parámetros de entrada y devuelve el ID generado.
    -- (El estado se asigna como 'INICIADO' internamente en el Body)
    PROCEDURE REC_PROV_CREAR(
        p_orc_key IN VARCHAR2, 
        p_coment  IN VARCHAR2, 
        p_id      OUT NUMBER
    );
    
    -- Actualiza solo los comentarios del reclamo
    PROCEDURE REC_PROV_ACTUALIZAR(
        p_id     IN NUMBER, 
        p_coment IN VARCHAR2
    );
    
    -- Maneja el flujo de estados (PENDIENTE, FINALIZADO, RECHAZADO, etc.)
    -- Controla automáticamente la fecha de finalización.
    PROCEDURE REC_PROV_CAMBIAR_ESTADO(
        p_id     IN NUMBER, 
        p_estado IN VARCHAR2
    );
    
    -- Elimina físicamente el registro del reclamo
    PROCEDURE REC_PROV_ELIMINAR(
        p_id IN NUMBER
    );
    
    -- Devuelve todos los registros ordenados por fecha de inicio descendente
    PROCEDURE REC_PROV_LISTAR(
        p_data OUT SYS_REFCURSOR
    );
    
    -- Busca un reclamo específico por su ID único
    PROCEDURE REC_PROV_LISTAR_ID(
        p_id   IN NUMBER, 
        p_data OUT SYS_REFCURSOR
    );

END PKG_CP_FAC_RECLAMO_PROV;
/