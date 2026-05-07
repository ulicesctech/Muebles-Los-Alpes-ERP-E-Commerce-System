CREATE OR REPLACE PACKAGE PKG_CLI_CLIENTE AS
    PROCEDURE cli_crear(
        p_tipodoc IN VARCHAR2, p_numdoc  IN VARCHAR2,
        p_p_nom   IN VARCHAR2, p_s_nom   IN VARCHAR2,
        p_p_ape   IN VARCHAR2, p_s_ape   IN VARCHAR2,
        p_pais    IN VARCHAR2, p_dep     IN VARCHAR2,
        p_mun     IN VARCHAR2, p_zona    IN VARCHAR2,
        p_dir     IN VARCHAR2, p_cp      IN VARCHAR2,
        p_tel1    IN VARCHAR2, p_tel2    IN VARCHAR2,
        p_email   IN VARCHAR2, p_prof    IN VARCHAR2,
        p_tipocli IN VARCHAR2, p_id      OUT NUMBER
    );
    PROCEDURE cli_actualizar(
        p_id      IN NUMBER,
        p_tipodoc IN VARCHAR2, p_numdoc  IN VARCHAR2,
        p_p_nom   IN VARCHAR2, p_s_nom   IN VARCHAR2,
        p_p_ape   IN VARCHAR2, p_s_ape   IN VARCHAR2,
        p_pais    IN VARCHAR2, p_dep     IN VARCHAR2,
        p_mun     IN VARCHAR2, p_zona    IN VARCHAR2,
        p_dir     IN VARCHAR2, p_cp      IN VARCHAR2,
        p_tel1    IN VARCHAR2, p_tel2    IN VARCHAR2,
        p_email   IN VARCHAR2, p_prof    IN VARCHAR2,
        p_tipocli IN VARCHAR2
    );
    PROCEDURE cli_eliminar(p_id IN NUMBER);
    PROCEDURE cli_listar(p_data OUT SYS_REFCURSOR);
    PROCEDURE cli_buscar(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR);
END PKG_CLI_CLIENTE;
/

CREATE OR REPLACE PACKAGE BODY PKG_CLI_CLIENTE AS

    PROCEDURE assert_not_null(p_val IN VARCHAR2, p_msg IN VARCHAR2) IS
    BEGIN
        IF TRIM(p_val) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, p_msg);
        END IF;
    END assert_not_null;

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, p_msg);
        END IF;
    END assert_id;

    PROCEDURE cli_crear(
        p_tipodoc IN VARCHAR2, p_numdoc  IN VARCHAR2,
        p_p_nom   IN VARCHAR2, p_s_nom   IN VARCHAR2,
        p_p_ape   IN VARCHAR2, p_s_ape   IN VARCHAR2,
        p_pais    IN VARCHAR2, p_dep     IN VARCHAR2,
        p_mun     IN VARCHAR2, p_zona    IN VARCHAR2,
        p_dir     IN VARCHAR2, p_cp      IN VARCHAR2,
        p_tel1    IN VARCHAR2, p_tel2    IN VARCHAR2,
        p_email   IN VARCHAR2, p_prof    IN VARCHAR2,
        p_tipocli IN VARCHAR2, p_id      OUT NUMBER
    ) IS
    BEGIN
        assert_not_null(p_numdoc, 'Cliente: Documento obligatorio.');
        assert_not_null(p_email,  'Cliente: Email obligatorio.');
        INSERT INTO CLI_CLIENTE (
            cli_tipodocumento, cli_numdocumento,
            cli_primer_nombre, cli_segundo_nombre,
            cli_primer_apellido, cli_segundo_apellido,
            cli_pais, cli_departamento, cli_municipio,
            cli_zona, cli_direccion, cli_codigo_postal,
            cli_primer_telefono, cli_segundo_telefono,
            cli_email, cli_profesion, cli_tipocliente
        ) VALUES (
            TRIM(p_tipodoc), TRIM(p_numdoc),
            TRIM(p_p_nom), TRIM(p_s_nom),
            TRIM(p_p_ape), TRIM(p_s_ape),
            TRIM(p_pais), TRIM(p_dep), TRIM(p_mun),
            TRIM(p_zona), TRIM(p_dir), TRIM(p_cp),
            TRIM(p_tel1), TRIM(p_tel2),
            TRIM(p_email), TRIM(p_prof), TRIM(p_tipocli)
        ) RETURNING cli_cliente INTO p_id;
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20006, 'Documento o email ya registrado');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END cli_crear;

    PROCEDURE cli_actualizar(
        p_id      IN NUMBER,
        p_tipodoc IN VARCHAR2, p_numdoc  IN VARCHAR2,
        p_p_nom   IN VARCHAR2, p_s_nom   IN VARCHAR2,
        p_p_ape   IN VARCHAR2, p_s_ape   IN VARCHAR2,
        p_pais    IN VARCHAR2, p_dep     IN VARCHAR2,
        p_mun     IN VARCHAR2, p_zona    IN VARCHAR2,
        p_dir     IN VARCHAR2, p_cp      IN VARCHAR2,
        p_tel1    IN VARCHAR2, p_tel2    IN VARCHAR2,
        p_email   IN VARCHAR2, p_prof    IN VARCHAR2,
        p_tipocli IN VARCHAR2
    ) IS
    BEGIN
        assert_id(p_id, 'Cliente: ID obligatorio.');
        UPDATE CLI_CLIENTE SET
            cli_tipodocumento    = TRIM(p_tipodoc),
            cli_numdocumento     = TRIM(p_numdoc),
            cli_primer_nombre    = TRIM(p_p_nom),
            cli_segundo_nombre   = TRIM(p_s_nom),
            cli_primer_apellido  = TRIM(p_p_ape),
            cli_segundo_apellido = TRIM(p_s_ape),
            cli_pais             = TRIM(p_pais),
            cli_departamento     = TRIM(p_dep),
            cli_municipio        = TRIM(p_mun),
            cli_zona             = TRIM(p_zona),
            cli_direccion        = TRIM(p_dir),
            cli_codigo_postal    = TRIM(p_cp),
            cli_primer_telefono  = TRIM(p_tel1),
            cli_segundo_telefono = TRIM(p_tel2),
            cli_email            = TRIM(p_email),
            cli_profesion        = TRIM(p_prof),
            cli_tipocliente      = TRIM(p_tipocli)
        WHERE cli_cliente = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END cli_actualizar;

    PROCEDURE cli_eliminar(p_id IN NUMBER) IS
    BEGIN
        DELETE FROM ADMIN_LOGIN_CLIENTE WHERE cli_cliente = p_id;
        DELETE FROM CLI_CLIENTE WHERE cli_cliente = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END cli_eliminar;

    PROCEDURE cli_listar(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR SELECT * FROM CLI_CLIENTE ORDER BY cli_primer_nombre;
    END cli_listar;

    PROCEDURE cli_buscar(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
        v_txt VARCHAR2(200) := '%' || UPPER(TRIM(NVL(p_texto,''))) || '%';
    BEGIN
        OPEN p_data FOR SELECT * FROM CLI_CLIENTE
        WHERE UPPER(cli_primer_nombre) LIKE v_txt
           OR UPPER(cli_numdocumento)  LIKE v_txt
           OR UPPER(cli_email)         LIKE v_txt;
    END cli_buscar;

END PKG_CLI_CLIENTE;
/