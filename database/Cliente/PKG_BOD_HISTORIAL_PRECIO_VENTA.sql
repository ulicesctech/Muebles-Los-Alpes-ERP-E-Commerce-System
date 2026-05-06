CREATE OR REPLACE PACKAGE PKG_BOD_HISTORIAL_PRECIO_VENTA AS
    PROCEDURE REGISTRAR(p_pro_referencia IN VARCHAR2, p_porcetaje IN NUMBER, p_id OUT NUMBER);
    PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR);
    PROCEDURE LISTAR_TODOS(p_data OUT SYS_REFCURSOR);
END PKG_BOD_HISTORIAL_PRECIO_VENTA;
/

CREATE OR REPLACE PACKAGE BODY PKG_BOD_HISTORIAL_PRECIO_VENTA AS

    PROCEDURE REGISTRAR(p_pro_referencia IN VARCHAR2, p_porcetaje IN NUMBER, p_id OUT NUMBER) IS
        v_precio_compra BOD_HISTORIAL_PRECIO.hip_precio%TYPE;
        v_precio_final  BOD_HISTORIAL_PRECIO_VENTA.hv_precio_final%TYPE;
    BEGIN
        SELECT hip_precio INTO v_precio_compra
          FROM BOD_HISTORIAL_PRECIO
         WHERE pro_referencia = p_pro_referencia
           AND hip_fecha_final IS NULL
           AND ROWNUM = 1;
        v_precio_final := v_precio_compra * (1 + p_porcetaje / 100);
        UPDATE BOD_HISTORIAL_PRECIO_VENTA
           SET hv_fecha_final = SYSDATE
         WHERE pro_referencia = p_pro_referencia
           AND hv_fecha_final IS NULL;
        INSERT INTO BOD_HISTORIAL_PRECIO_VENTA(pro_referencia, hv_porcetaje, hv_precio_final, hv_fecha_inicio, hv_fecha_final)
        VALUES(p_pro_referencia, p_porcetaje, v_precio_final, SYSDATE, NULL)
        RETURNING hv_historial_precio_venta INTO p_id;
    END;

    PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT hv.hv_historial_precio_venta,
                   hv.pro_referencia,
                   p.pro_nombre,
                   hp.hip_precio AS precio_compra,
                   hv.hv_porcetaje,
                   hv.hv_precio_final,
                   hv.hv_fecha_inicio
              FROM BOD_HISTORIAL_PRECIO_VENTA hv
              JOIN BOD_PRODUCTO              p  ON p.pro_referencia  = hv.pro_referencia
              JOIN BOD_HISTORIAL_PRECIO      hp ON hp.pro_referencia = hv.pro_referencia
                                               AND hp.hip_fecha_final IS NULL
             WHERE hv.hv_fecha_final IS NULL
             ORDER BY p.pro_nombre;
    END;

    PROCEDURE LISTAR_TODOS(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT hv.hv_historial_precio_venta,
                   hv.pro_referencia,
                   p.pro_nombre,
                   hv.hv_porcetaje,
                   hv.hv_precio_final,
                   hv.hv_fecha_inicio,
                   hv.hv_fecha_final
              FROM BOD_HISTORIAL_PRECIO_VENTA hv
              JOIN BOD_PRODUCTO              p ON p.pro_referencia = hv.pro_referencia
             ORDER BY p.pro_nombre, hv.hv_fecha_inicio DESC;
    END;

END PKG_BOD_HISTORIAL_PRECIO_VENTA;
/