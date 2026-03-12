CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_LOGIN_CLIENTE AS
    PROCEDURE assert_not_null(p_val IN VARCHAR2, p_msg IN VARCHAR2) IS 
    BEGIN 
        IF TRIM(p_val) IS NULL 
            THEN RAISE_APPLICATION_ERROR(-20001, p_msg); 
        END IF; 
    END;

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS 
    BEGIN 
        IF p_id IS NULL 
            THEN RAISE_APPLICATION_ERROR(-20002, p_msg); 
        END IF; 
    END;

    PROCEDURE LOGC_CREAR(p_id_cliente IN NUMBER, p_usuario IN VARCHAR2, p_password IN VARCHAR2) IS
    BEGIN
        assert_id(p_id_cliente, 'Login Cli: Cliente obligatorio.');
        INSERT INTO ADMIN_LOGIN_CLIENTE (cli_cliente, logcli_usuario, logcli_password) 
        VALUES (p_id_cliente, TRIM(p_usuario), 
        TRIM(p_password));
    END;

    PROCEDURE LOGC_ACTUALIZAR_PWD(p_id_cliente IN NUMBER, p_password IN VARCHAR2) IS
    BEGIN
        UPDATE ADMIN_LOGIN_CLIENTE SET logcli_password = TRIM(p_password) WHERE cli_cliente = p_id_cliente;
    END;

    PROCEDURE LOGC_ELIMINAR(p_id_cliente IN NUMBER) IS
    BEGIN
        DELETE FROM ADMIN_LOGIN_CLIENTE WHERE cli_cliente = p_id_cliente;
    END;

    PROCEDURE LOGC_AUTENTICAR(p_usuario IN VARCHAR2, p_password IN VARCHAR2, p_id_cliente OUT NUMBER) IS
    BEGIN
        BEGIN
            SELECT cli_cliente INTO p_id_cliente FROM ADMIN_LOGIN_CLIENTE 
            WHERE logcli_usuario = TRIM(p_usuario) AND logcli_password = TRIM(p_password);
            EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20007, 'Credenciales de cliente incorrectas.');
        END;
    END;
END PKG_ADMIN_LOGIN_CLIENTE;
/