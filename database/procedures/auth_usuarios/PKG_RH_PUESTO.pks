-- ============================================================
-- PKG_RH_PUESTO.pks - Puestos RH
-- Tabla: RH_PUESTO (pue_puestos, pue_nombre, pue_salario, pue_descripcion)
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_RH_PUESTO AS

    TYPE t_puesto_rec IS RECORD (
        pue_puestos NUMBER,
        pue_nombre VARCHAR2(255),
        pue_salario NUMBER(10,2),
        pue_descripcion VARCHAR2(255)
    );
    TYPE t_cursor_puesto IS REF CURSOR RETURN t_puesto_rec;

    -- CRUD
    PROCEDURE PUE_CREAR(
        p_pue_nombre VARCHAR2,
        p_pue_salario NUMBER,
        p_pue_descripcion VARCHAR2,
        p_nuevo_id OUT NUMBER
    );
    
    PROCEDURE PUE_ACTUALIZAR(
        p_pue_puestos NUMBER,
        p_pue_nombre VARCHAR2,
        p_pue_salario NUMBER,
        p_pue_descripcion VARCHAR2
    );
    
    PROCEDURE PUE_ELIMINAR(p_pue_puestos NUMBER);
    
    FUNCTION PUE_LISTAR(p_pue_puestos NUMBER DEFAULT NULL) RETURN t_cursor_puesto;
    
    FUNCTION PUE_OBTENER(p_pue_puestos NUMBER) RETURN t_puesto_rec;

END PKG_RH_PUESTO;
/