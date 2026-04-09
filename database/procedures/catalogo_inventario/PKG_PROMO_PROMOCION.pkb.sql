CREATE OR REPLACE PACKAGE BODY PKG_PROMO_PROMOCION AS
 
  PROCEDURE CREAR(
    p_pro_referencia IN VARCHAR2, p_porcentaje IN NUMBER,
    p_fecha_inicio IN DATE, p_fecha_final IN DATE, p_id_out OUT NUMBER
  ) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'PROMO_PROMOCION: referencia obligatoria.'); END IF;
    IF p_porcentaje IS NULL OR p_porcentaje <= 0 OR p_porcentaje > 100 THEN
      RAISE_APPLICATION_ERROR(-20002, 'PROMO_PROMOCION: porcentaje debe ser >0 y <=100.');
    END IF;
    IF p_fecha_inicio IS NULL OR p_fecha_final IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'PROMO_PROMOCION: fechas obligatorias.');
    END IF;
    IF p_fecha_inicio > p_fecha_final THEN
      RAISE_APPLICATION_ERROR(-20004, 'PROMO_PROMOCION: fecha_inicio no puede ser mayor a fecha_final.');
    END IF;
    INSERT INTO PROMO_PROMOCION(pro_referencia, prom_porcentaje, prom_fecha_inicio, prom_fecha_final)
    VALUES(v_ref, p_porcentaje, p_fecha_inicio, p_fecha_final)
    RETURNING prom_promocion INTO p_id_out;
  END;
 
  PROCEDURE ELIMINAR(p_id IN NUMBER) IS
  BEGIN
    IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-20005, 'PROMO_PROMOCION: id obligatorio.'); END IF;
    DELETE FROM PROMO_PROMOCION WHERE prom_promocion = p_id;
    IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20006, 'PROMO_PROMOCION: no existe.'); END IF;
  END;
 
  PROCEDURE LISTAR_POR_PRODUCTO(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20007, 'PROMO_PROMOCION: referencia obligatoria.'); END IF;
    OPEN p_data FOR
      SELECT prom_promocion, pro_referencia, prom_porcentaje, prom_fecha_inicio, prom_fecha_final
        FROM PROMO_PROMOCION WHERE pro_referencia = v_ref
       ORDER BY prom_fecha_inicio DESC, prom_promocion DESC;
  END;
 
  PROCEDURE VIGENTE(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20008, 'PROMO_PROMOCION: referencia obligatoria.'); END IF;
    OPEN p_data FOR
      SELECT prom_promocion, pro_referencia, prom_porcentaje, prom_fecha_inicio, prom_fecha_final
        FROM PROMO_PROMOCION
       WHERE pro_referencia = v_ref
         AND prom_fecha_inicio <= SYSDATE
         AND prom_fecha_final  >= SYSDATE
       ORDER BY prom_fecha_inicio DESC, prom_promocion DESC
       FETCH FIRST 1 ROWS ONLY;
  END;
 
END PKG_PROMO_PROMOCION;
/