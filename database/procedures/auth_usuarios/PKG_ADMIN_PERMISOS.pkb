CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_PERMISOS AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL OR p_id <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, p_msg);
        END IF;
    END assert_id;

    PROCEDURE per_crear(
        p_admin   IN NUMBER DEFAULT 0,
        p_rh      IN NUMBER DEFAULT 0,
        p_fac     IN NUMBER DEFAULT 0,
        p_cli     IN NUMBER DEFAULT 0,
        p_bod     IN NUMBER DEFAULT 0,
        p_promo   IN NUMBER DEFAULT 0,
        p_id      OUT NUMBER
    ) IS
    BEGIN
        INSERT INTO ADMIN_PERMISOS (
            per_admin, per_rh, per_fac, per_cli, per_bod, per_promo
        ) VALUES (
            NVL(p_admin,0), NVL(p_rh,0), NVL(p_fac,0),
            NVL(p_cli,0), NVL(p_bod,0), NVL(p_promo,0)
        ) RETURNING per_permisos INTO p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END per_crear;

    PROCEDURE per_actualizar(
        p_id      IN NUMBER,
        p_admin   IN NUMBER DEFAULT NULL,
        p_rh      IN NUMBER DEFAULT NULL,
        p_fac     IN NUMBER DEFAULT NULL,
        p_cli     IN NUMBER DEFAULT NULL,
        p_bod     IN NUMBER DEFAULT NULL,
        p_promo   IN NUMBER DEFAULT NULL
    ) IS
        v_rows NUMBER;
    BEGIN
        assert_id(p_id, 'ID obligatorio');
        UPDATE ADMIN_PERMISOS SET
            per_admin = NVL(p_admin, per_admin),
            per_rh    = NVL(p_rh,    per_rh),
            per_fac   = NVL(p_fac,   per_fac),
            per_cli   = NVL(p_cli,   per_cli),
            per_bod   = NVL(p_bod,   per_bod),
            per_promo = NVL(p_promo, per_promo)
        WHERE per_permisos = p_id;
        v_rows := SQL%ROWCOUNT;
        IF v_rows = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Permiso no encontrado');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END per_actualizar;

    PROCEDURE per_eliminar(p_id IN NUMBER) IS
        v_rows NUMBER;
    BEGIN
        assert_id(p_id, 'ID obligatorio');
        DELETE FROM ADMIN_PERMISOS WHERE per_permisos = p_id;
        v_rows := SQL%ROWCOUNT;
        IF v_rows = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Permiso no encontrado');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END per_eliminar;

    PROCEDURE per_listar(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT per_permisos, per_admin, per_rh, per_fac,
                   per_cli, per_bod, per_promo
            FROM ADMIN_PERMISOS
            ORDER BY per_permisos;
    END per_listar;

END PKG_ADMIN_PERMISOS;
/