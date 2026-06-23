CREATE OR REPLACE PACKAGE PKG_ADMIN_LOGIN_CLIENTE AS
    PROCEDURE logc_crear(
        p_id_cliente IN NUMBER,
        p_usuario    IN VARCHAR2,
        p_password   IN VARCHAR2
    );
    PROCEDURE logc_actualizar_pwd(
        p_id_cliente IN NUMBER,
        p_password   IN VARCHAR2
    );
    PROCEDURE logc_eliminar(p_id_cliente IN NUMBER);
    PROCEDURE logc_autenticar(
        p_usuario    IN  VARCHAR2,
        p_password   IN  VARCHAR2,
        p_id_cliente OUT NUMBER
    );
END PKG_ADMIN_LOGIN_CLIENTE;
/

CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_LOGIN_CLIENTE AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, p_msg);
        END IF;
    END assert_id;

    PROCEDURE logc_crear(
        p_id_cliente IN NUMBER,
        p_usuario    IN VARCHAR2,
        p_password   IN VARCHAR2
    ) IS
    BEGIN
        assert_id(p_id_cliente, 'Login Cli: Cliente obligatorio.');
        INSERT INTO ADMIN_LOGIN_CLIENTE (cli_cliente, logcli_usuario, logcli_password)
        VALUES (p_id_cliente, LOWER(TRIM(p_usuario)), TRIM(p_password));
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20006, 'Usuario ya existe');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END logc_crear;

    PROCEDURE logc_actualizar_pwd(
        p_id_cliente IN NUMBER,
        p_password   IN VARCHAR2
    ) IS
    BEGIN
        UPDATE ADMIN_LOGIN_CLIENTE SET logcli_password = TRIM(p_password)
        WHERE cli_cliente = p_id_cliente;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END logc_actualizar_pwd;

    PROCEDURE logc_eliminar(p_id_cliente IN NUMBER) IS
    BEGIN
        DELETE FROM ADMIN_LOGIN_CLIENTE WHERE cli_cliente = p_id_cliente;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END logc_eliminar;

    PROCEDURE logc_autenticar(
    p_usuario    IN  VARCHAR2,
    p_password   IN  VARCHAR2,
    p_id_cliente OUT NUMBER
) IS
BEGIN
    SELECT al.cli_cliente INTO p_id_cliente
      FROM ADMIN_LOGIN_CLIENTE al
      JOIN CLI_CLIENTE c ON c.cli_cliente = al.cli_cliente
     WHERE (LOWER(al.logcli_usuario) = LOWER(TRIM(p_usuario))
        OR  LOWER(c.cli_email)       = LOWER(TRIM(p_usuario)))
       AND al.logcli_password = TRIM(p_password);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20007, 'Credenciales de cliente incorrectas.');
END logc_autenticar;

END PKG_ADMIN_LOGIN_CLIENTE;
/