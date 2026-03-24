CREATE OR REPLACE PACKAGE PKG_CLI_CLIENTE AS
  PROCEDURE CLI_CREAR(
    p_tipodoc   IN VARCHAR2, 
    p_numdoc    IN VARCHAR2, 
    p_p_nom     IN VARCHAR2, 
    p_s_nom     IN VARCHAR2, 
    p_p_ape     IN VARCHAR2, 
    p_s_ape     IN VARCHAR2, 
    p_pais      IN VARCHAR2, 
    p_dep       IN VARCHAR2, 
    p_mun       IN VARCHAR2, 
    p_zona      IN VARCHAR2, 
    p_dir       IN VARCHAR2, 
    p_cp        IN VARCHAR2, 
    p_tel1      IN VARCHAR2, 
    p_tel2      IN VARCHAR2, 
    p_email     IN VARCHAR2, 
    p_prof      IN VARCHAR2, 
    p_tipocli   IN VARCHAR2, 
    p_id        OUT NUMBER
    );

  PROCEDURE CLI_ACTUALIZAR(
    p_id IN NUMBER, 
    p_tipodoc   IN VARCHAR2, 
    p_numdoc    IN VARCHAR2, 
    p_p_nom     IN VARCHAR2, 
    p_s_nom     IN VARCHAR2, 
    p_p_ape     IN VARCHAR2, 
    p_s_ape     IN VARCHAR2, 
    p_pais      IN VARCHAR2, 
    p_dep       IN VARCHAR2, 
    p_mun       IN VARCHAR2, 
    p_zona      IN VARCHAR2, 
    p_dir       IN VARCHAR2, 
    p_cp        IN VARCHAR2, 
    p_tel1      IN VARCHAR2, 
    p_tel2      IN VARCHAR2, 
    p_email     IN VARCHAR2, 
    p_prof      IN VARCHAR2, 
    p_tipocli   IN VARCHAR2
    );

  PROCEDURE CLI_ELIMINAR(
    p_id IN NUMBER
    );

  PROCEDURE CLI_LISTAR(
    p_data OUT SYS_REFCURSOR
    );

  PROCEDURE CLI_BUSCAR(
    p_texto IN VARCHAR2, 
    p_data OUT SYS_REFCURSOR
    );
END PKG_CLI_CLIENTE;
/