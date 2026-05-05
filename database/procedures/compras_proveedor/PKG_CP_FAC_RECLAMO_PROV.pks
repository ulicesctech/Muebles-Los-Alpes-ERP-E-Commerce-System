-- ============================================================
-- PKG_CP_FAC_RECLAMO_PROV.pks
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_CP_FAC_RECLAMO_PROV AS

    -- Crea un reclamo con descripcion. Estado = INICIADO, comentarios = NULL
    PROCEDURE REC_PROV_CREAR(
        p_orc_key     IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_id          OUT NUMBER
    );

    -- Actualiza descripcion del reclamo (solo cuando estado es INICIADO o PENDIENTE)
    PROCEDURE REC_PROV_ACTUALIZAR(p_id IN NUMBER, p_descripcion IN VARCHAR2);

    -- Actualiza solo los comentarios (cuando estado es RESUELTO o RECHAZADO)
    PROCEDURE REC_PROV_ACTUALIZAR_COMENTARIOS(p_id IN NUMBER, p_coment IN VARCHAR2);

    -- Cambia el estado con orden estricto. RESUELTO/RECHAZADO guardan comentarios y fecha_final
    PROCEDURE REC_PROV_CAMBIAR_ESTADO(
        p_id     IN NUMBER,
        p_estado IN VARCHAR2,
        p_coment IN VARCHAR2
    );

    -- Elimina un reclamo
    PROCEDURE REC_PROV_ELIMINAR(p_id IN NUMBER);

    -- Lista todos los reclamos ordenados por fecha desc
    PROCEDURE REC_PROV_LISTAR(p_data OUT SYS_REFCURSOR);

    -- Obtiene un reclamo por ID
    PROCEDURE REC_PROV_LISTAR_ID(p_id IN NUMBER, p_data OUT SYS_REFCURSOR);

    -- Busca por texto libre, estado y rango de fechas
    PROCEDURE REC_PROV_BUSCAR(
        p_texto       IN VARCHAR2,
        p_estado      IN VARCHAR2,
        p_fecha_desde IN DATE,
        p_fecha_hasta IN DATE,
        p_data        OUT SYS_REFCURSOR
    );

    -- Devuelve los estados validos. Incluye fila TODOS al inicio
    PROCEDURE REC_PROV_LISTAR_ESTADOS(p_data OUT SYS_REFCURSOR);

    -- Devuelve 1 si el estado es de cierre (RESUELTO/RECHAZADO), 0 si no
    PROCEDURE REC_PROV_ES_CIERRE(p_estado IN VARCHAR2, p_resultado OUT NUMBER);

END PKG_CP_FAC_RECLAMO_PROV;
/
