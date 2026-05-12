CREATE OR REPLACE PACKAGE BODY PKG_BOD_PRODUCTO AS

    PROCEDURE CREAR(p_referencia IN VARCHAR2, p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2, p_tip_tipo IN NUMBER, p_mat_material IN NUMBER, p_alto_cm IN NUMBER, p_ancho_cm IN NUMBER, p_profundidad_cm IN NUMBER, p_color IN VARCHAR2, p_peso IN NUMBER, p_foto IN BLOB) IS
        v_ref VARCHAR2(40);
    BEGIN
        v_ref := TRIM(p_referencia);
        IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'BOD_PRODUCTO: referencia obligatoria.'); END IF;
        IF TRIM(p_nombre) IS NULL THEN RAISE_APPLICATION_ERROR(-20002, 'BOD_PRODUCTO: nombre obligatorio.'); END IF;
        IF p_tip_tipo IS NULL THEN RAISE_APPLICATION_ERROR(-20003, 'BOD_PRODUCTO: tip_tipo obligatorio.'); END IF;
        IF p_mat_material IS NULL THEN RAISE_APPLICATION_ERROR(-20004, 'BOD_PRODUCTO: mat_material obligatorio.'); END IF;
        IF p_alto_cm <= 0 OR p_ancho_cm <= 0 OR p_profundidad_cm <= 0 THEN RAISE_APPLICATION_ERROR(-20005, 'BOD_PRODUCTO: dimensiones deben ser > 0.'); END IF;
        IF p_peso IS NULL OR p_peso <= 0 THEN RAISE_APPLICATION_ERROR(-20006, 'BOD_PRODUCTO: peso debe ser > 0.'); END IF;
        INSERT INTO BOD_PRODUCTO(pro_referencia, pro_nombre, pro_descripcion, tip_tipo, mat_material, pro_alto_cm, pro_ancho_cm, pro_profundidad_cm, pro_color, pro_peso, pro_foto)
        VALUES(v_ref, TRIM(p_nombre), p_descripcion, p_tip_tipo, p_mat_material, p_alto_cm, p_ancho_cm, p_profundidad_cm, p_color, p_peso, p_foto);
    END;

    PROCEDURE ACTUALIZAR(p_referencia IN VARCHAR2, p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2, p_tip_tipo IN NUMBER, p_mat_material IN NUMBER, p_alto_cm IN NUMBER, p_ancho_cm IN NUMBER, p_profundidad_cm IN NUMBER, p_color IN VARCHAR2, p_peso IN NUMBER) IS
        v_ref VARCHAR2(40);
    BEGIN
        v_ref := TRIM(p_referencia);
        IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20007, 'BOD_PRODUCTO: referencia obligatoria.'); END IF;
        IF TRIM(p_nombre) IS NULL THEN RAISE_APPLICATION_ERROR(-20008, 'BOD_PRODUCTO: nombre obligatorio.'); END IF;
        IF p_tip_tipo IS NULL THEN RAISE_APPLICATION_ERROR(-20009, 'BOD_PRODUCTO: tip_tipo obligatorio.'); END IF;
        IF p_mat_material IS NULL THEN RAISE_APPLICATION_ERROR(-20010, 'BOD_PRODUCTO: mat_material obligatorio.'); END IF;
        IF p_alto_cm <= 0 OR p_ancho_cm <= 0 OR p_profundidad_cm <= 0 THEN RAISE_APPLICATION_ERROR(-20011, 'BOD_PRODUCTO: dimensiones deben ser > 0.'); END IF;
        IF p_peso IS NULL OR p_peso <= 0 THEN RAISE_APPLICATION_ERROR(-20012, 'BOD_PRODUCTO: peso debe ser > 0.'); END IF;
        UPDATE BOD_PRODUCTO SET pro_nombre = TRIM(p_nombre), pro_descripcion = p_descripcion, tip_tipo = p_tip_tipo, mat_material = p_mat_material, pro_alto_cm = p_alto_cm, pro_ancho_cm = p_ancho_cm, pro_profundidad_cm = p_profundidad_cm, pro_color = p_color, pro_peso = p_peso WHERE pro_referencia = v_ref;
        IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20013, 'BOD_PRODUCTO: no existe.'); END IF;
    END;

    PROCEDURE ACTUALIZAR_FOTO(p_referencia IN VARCHAR2, p_foto IN BLOB) IS
        v_ref VARCHAR2(40);
    BEGIN
        v_ref := TRIM(p_referencia);
        IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20014, 'BOD_PRODUCTO: referencia obligatoria.'); END IF;
        UPDATE BOD_PRODUCTO SET pro_foto = p_foto WHERE pro_referencia = v_ref;
        IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20015, 'BOD_PRODUCTO: no existe para actualizar foto.'); END IF;
    END;

    PROCEDURE ACTUALIZAR_PRECIO(p_referencia IN VARCHAR2, p_precio IN NUMBER) IS
        v_ref VARCHAR2(40);
    BEGIN
        v_ref := TRIM(p_referencia);
        IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20023, 'BOD_PRODUCTO: referencia obligatoria.'); END IF;
        IF p_precio < 0 THEN RAISE_APPLICATION_ERROR(-20024, 'BOD_PRODUCTO: precio no puede ser negativo.'); END IF;
        UPDATE BOD_PRODUCTO SET pro_precio = p_precio WHERE pro_referencia = v_ref;
        IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20025, 'BOD_PRODUCTO: no existe para actualizar precio.'); END IF;
    END;

    PROCEDURE ELIMINAR(p_referencia IN VARCHAR2) IS
        v_ref  VARCHAR2(40);
        v_used NUMBER;
    BEGIN
        v_ref := TRIM(p_referencia);
        IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20016, 'BOD_PRODUCTO: referencia obligatoria.'); END IF;
        SELECT COUNT(1) INTO v_used FROM BOD_HISTORIAL_PRECIO WHERE pro_referencia = v_ref;
        IF v_used > 0 THEN RAISE_APPLICATION_ERROR(-20017, 'BOD_PRODUCTO: no se puede eliminar, tiene historial de precio.'); END IF;
        SELECT COUNT(1) INTO v_used FROM PROMO_PROMOCION WHERE pro_referencia = v_ref;
        IF v_used > 0 THEN RAISE_APPLICATION_ERROR(-20018, 'BOD_PRODUCTO: no se puede eliminar, tiene promociones.'); END IF;
        DELETE FROM BOD_PRODUCTO WHERE pro_referencia = v_ref;
        IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20019, 'BOD_PRODUCTO: no existe.'); END IF;
    END;

    PROCEDURE OBTENER(p_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
        v_ref VARCHAR2(40);
    BEGIN
        v_ref := TRIM(p_referencia);
        IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20020, 'BOD_PRODUCTO: referencia obligatoria.'); END IF;
        OPEN p_data FOR
            SELECT p.pro_referencia, p.pro_nombre, p.pro_descripcion,
                   p.tip_tipo, t.tip_descripcion, p.mat_material, m.mat_descripcion,
                   p.pro_alto_cm, p.pro_ancho_cm, p.pro_profundidad_cm,
                   p.pro_color, p.pro_peso, p.pro_precio
              FROM BOD_PRODUCTO p
              JOIN BOD_TIPO     t ON t.tip_tipo     = p.tip_tipo
              JOIN BOD_MATERIAL m ON m.mat_material = p.mat_material
             WHERE p.pro_referencia = v_ref;
    END;

    PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT p.pro_referencia, p.pro_nombre, p.tip_tipo, t.tip_descripcion,
                   p.mat_material, m.mat_descripcion, p.pro_color, p.pro_peso, p.pro_precio
              FROM BOD_PRODUCTO p
              JOIN BOD_TIPO     t ON t.tip_tipo     = p.tip_tipo
              JOIN BOD_MATERIAL m ON m.mat_material = p.mat_material
             ORDER BY p.pro_nombre;
    END;

    PROCEDURE LISTAR_POR_CATEGORIA(p_categoria IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT p.pro_referencia, p.pro_nombre, p.tip_tipo, t.tip_descripcion,
                   p.mat_material, m.mat_descripcion, p.pro_color, p.pro_peso, p.pro_precio,
                   t.cat_categoria
              FROM BOD_PRODUCTO p
              JOIN BOD_TIPO      t ON t.tip_tipo      = p.tip_tipo
              JOIN BOD_CATEGORIA c ON c.cat_categoria = t.cat_categoria
              JOIN BOD_MATERIAL  m ON m.mat_material  = p.mat_material
             WHERE t.cat_categoria = p_categoria
             ORDER BY p.pro_nombre;
    END;

    PROCEDURE BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
        v_txt VARCHAR2(4000);
    BEGIN
        v_txt := '%' || UPPER(TRIM(NVL(p_texto, ''))) || '%';
        OPEN p_data FOR
            SELECT p.pro_referencia, p.pro_nombre, p.pro_descripcion,
                   p.tip_tipo, t.tip_descripcion, p.mat_material, m.mat_descripcion,
                   p.pro_color, p.pro_peso, p.pro_precio
              FROM BOD_PRODUCTO p
              JOIN BOD_TIPO     t ON t.tip_tipo     = p.tip_tipo
              JOIN BOD_MATERIAL m ON m.mat_material = p.mat_material
             WHERE UPPER(p.pro_referencia)  LIKE v_txt
                OR UPPER(p.pro_nombre)      LIKE v_txt
                OR UPPER(t.tip_descripcion) LIKE v_txt
                OR UPPER(m.mat_descripcion) LIKE v_txt
             ORDER BY p.pro_nombre;
    END;

    PROCEDURE OBTENER_FOTO(p_referencia IN VARCHAR2, p_foto OUT BLOB) IS
        v_ref VARCHAR2(40);
    BEGIN
        v_ref := TRIM(p_referencia);
        IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20021, 'BOD_PRODUCTO: referencia obligatoria.'); END IF;
        SELECT pro_foto INTO p_foto FROM BOD_PRODUCTO WHERE pro_referencia = v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20022, 'BOD_PRODUCTO: no existe para obtener foto.');
    END;

END PKG_BOD_PRODUCTO;
/