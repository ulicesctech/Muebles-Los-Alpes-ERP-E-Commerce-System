CREATE OR REPLACE PACKAGE PKG_RH_ASCENSO AS
    PROCEDURE ascen_crear(
        p_id_puesto   IN  NUMBER,
        p_id_empleado IN  NUMBER,
        p_id          OUT NUMBER
    );
    PROCEDURE ascen_cerrar(p_id_ascenso IN NUMBER);
    PROCEDURE ascen_eliminar(p_id_ascenso IN NUMBER);
    PROCEDURE ascen_listar_por_emp(
        p_id_empleado IN  NUMBER,
        p_data        OUT SYS_REFCURSOR
    );
END PKG_RH_ASCENSO;
/
