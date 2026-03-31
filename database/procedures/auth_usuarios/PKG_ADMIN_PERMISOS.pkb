CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_PERMISOS AS
    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS 
    BEGIN 
        IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-20002, p_msg); 
        END IF; 
    END;

    PROCEDURE PER_CREAR(p_admin IN NUMBER, p_rh IN NUMBER, p_fac IN NUMBER, p_cli IN NUMBER, p_bod IN NUMBER, p_promo IN NUMBER, p_id OUT NUMBER) IS
    BEGIN
        INSERT INTO ADMIN_PERMISOS (
            per_Admin, per_RH, 
            per_Fac, per_cli, 
            per_Bod, per_promo
            )
        VALUES (NVL(p_admin,0), NVL(p_rh,0), NVL(p_fac,0), NVL(p_cli,0), NVL(p_bod,0), NVL(p_promo,0))
        RETURNING per_permisos INTO p_id;
    END;

    PROCEDURE PER_ACTUALIZAR(p_id IN NUMBER, p_admin IN NUMBER, p_rh IN NUMBER, p_fac IN NUMBER, p_cli IN NUMBER, p_bod IN NUMBER, p_promo IN NUMBER) IS
    BEGIN
        assert_id(p_id, 'Permisos: ID obligatorio.');
        UPDATE ADMIN_PERMISOS 
            SET per_Admin = NVL(p_admin,0), 
                per_RH = NVL(p_rh,0), 
                per_Fac = NVL(p_fac,0), 
                per_cli = NVL(p_cli,0), 
                per_Bod = NVL(p_bod,0), 
                per_promo = NVL(p_promo,0)
        WHERE per_permisos = p_id;
    END;

    PROCEDURE PER_ELIMINAR(p_id IN NUMBER) IS
    BEGIN
        assert_id(p_id, 'Permisos: ID obligatorio.');
        DELETE FROM ADMIN_PERMISOS WHERE per_permisos = p_id;
    END;

    PROCEDURE PER_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR SELECT * FROM ADMIN_PERMISOS ORDER BY per_permisos;
    END;
END PKG_ADMIN_PERMISOS;
/