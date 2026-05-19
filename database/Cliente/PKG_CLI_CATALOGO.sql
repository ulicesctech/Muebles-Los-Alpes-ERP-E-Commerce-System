CREATE OR REPLACE PACKAGE PKG_CLI_CATALOGO AS
    PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR);
    PROCEDURE LISTAR_POR_CATEGORIA(p_categoria IN NUMBER, p_data OUT SYS_REFCURSOR);
    PROCEDURE BUSCAR(p_texto IN VARCHAR2, p_categoria IN NUMBER, p_data OUT SYS_REFCURSOR);
    PROCEDURE LISTAR_CATEGORIAS(p_data OUT SYS_REFCURSOR);
    PROCEDURE LISTAR_PROMOCIONES(p_data OUT SYS_REFCURSOR);
END PKG_CLI_CATALOGO;
/

CREATE OR REPLACE PACKAGE BODY PKG_CLI_CATALOGO AS

    PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT p.pro_referencia,
                   p.pro_nombre,
                   p.pro_descripcion,
                   p.pro_precio,
                   p.pro_color,
                   p.pro_alto_cm,
                   p.pro_ancho_cm,
                   p.pro_profundidad_cm,
                   p.pro_peso,
                   t.tip_descripcion,
                   c.cat_descripcion,
                   m.mat_descripcion,
                   promo.prom_porcentaje,
                   promo.camp_nombre,
                   CASE WHEN promo.prom_porcentaje IS NOT NULL
                        THEN ROUND(p.pro_precio * (1 - promo.prom_porcentaje / 100), 2)
                        ELSE p.pro_precio
                   END AS precio_final,
                   NVL(stock.sto_disponible, 0) AS sto_disponible,
                   h.hv_historial_precio_venta
              FROM BOD_PRODUCTO p
              JOIN BOD_TIPO      t ON t.tip_tipo      = p.tip_tipo
              JOIN BOD_CATEGORIA c ON c.cat_categoria = t.cat_categoria
              JOIN BOD_MATERIAL  m ON m.mat_material  = p.mat_material
              LEFT JOIN (
                  SELECT pr.pro_referencia, MAX(pr.prom_porcentaje) prom_porcentaje,
                         MAX(ca.camp_nombre) camp_nombre
                    FROM PROMO_PROMOCION pr
                    JOIN PROMO_CAMPANA   ca ON ca.camp_campana = pr.camp_campana
                   WHERE ca.camp_estado = 'ACTIVA'
                   GROUP BY pr.pro_referencia
              ) promo ON promo.pro_referencia = p.pro_referencia
              LEFT JOIN (
                  SELECT h2.pro_referencia, SUM(s.sto_disponible) sto_disponible
                    FROM BOD_STOCK s
                    JOIN BOD_HISTORIAL_PRECIO h2 ON h2.hip_historial_precio = s.hip_historial_precio
                   WHERE h2.hip_fecha_final IS NULL
                   GROUP BY h2.pro_referencia
              ) stock ON stock.pro_referencia = p.pro_referencia
              LEFT JOIN (
                  SELECT pro_referencia, MIN(hv_historial_precio_venta) hv_historial_precio_venta
                    FROM BOD_HISTORIAL_PRECIO_VENTA
                   WHERE hv_fecha_final IS NULL
                   GROUP BY pro_referencia
              ) h ON h.pro_referencia = p.pro_referencia
             ORDER BY p.pro_nombre;
    END LISTAR;

    PROCEDURE LISTAR_POR_CATEGORIA(p_categoria IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT p.pro_referencia,
                   p.pro_nombre,
                   p.pro_descripcion,
                   p.pro_precio,
                   p.pro_color,
                   p.pro_alto_cm,
                   p.pro_ancho_cm,
                   p.pro_profundidad_cm,
                   p.pro_peso,
                   t.tip_descripcion,
                   c.cat_descripcion,
                   m.mat_descripcion,
                   promo.prom_porcentaje,
                   promo.camp_nombre,
                   CASE WHEN promo.prom_porcentaje IS NOT NULL
                        THEN ROUND(p.pro_precio * (1 - promo.prom_porcentaje / 100), 2)
                        ELSE p.pro_precio
                   END AS precio_final,
                   NVL(stock.sto_disponible, 0) AS sto_disponible,
                   h.hv_historial_precio_venta
              FROM BOD_PRODUCTO p
              JOIN BOD_TIPO      t ON t.tip_tipo      = p.tip_tipo
              JOIN BOD_CATEGORIA c ON c.cat_categoria = t.cat_categoria
              JOIN BOD_MATERIAL  m ON m.mat_material  = p.mat_material
              LEFT JOIN (
                  SELECT pr.pro_referencia, MAX(pr.prom_porcentaje) prom_porcentaje,
                         MAX(ca.camp_nombre) camp_nombre
                    FROM PROMO_PROMOCION pr
                    JOIN PROMO_CAMPANA   ca ON ca.camp_campana = pr.camp_campana
                   WHERE ca.camp_estado = 'ACTIVA'
                   GROUP BY pr.pro_referencia
              ) promo ON promo.pro_referencia = p.pro_referencia
              LEFT JOIN (
                  SELECT h2.pro_referencia, SUM(s.sto_disponible) sto_disponible
                    FROM BOD_STOCK s
                    JOIN BOD_HISTORIAL_PRECIO h2 ON h2.hip_historial_precio = s.hip_historial_precio
                   WHERE h2.hip_fecha_final IS NULL
                   GROUP BY h2.pro_referencia
              ) stock ON stock.pro_referencia = p.pro_referencia
              LEFT JOIN (
                  SELECT pro_referencia, MIN(hv_historial_precio_venta) hv_historial_precio_venta
                    FROM BOD_HISTORIAL_PRECIO_VENTA
                   WHERE hv_fecha_final IS NULL
                   GROUP BY pro_referencia
              ) h ON h.pro_referencia = p.pro_referencia
             WHERE c.cat_categoria = p_categoria
             ORDER BY p.pro_nombre;
    END LISTAR_POR_CATEGORIA;

    PROCEDURE BUSCAR(p_texto IN VARCHAR2, p_categoria IN NUMBER, p_data OUT SYS_REFCURSOR) IS
        v_txt VARCHAR2(4000);
    BEGIN
        v_txt := '%' || UPPER(TRIM(NVL(p_texto, ''))) || '%';
        OPEN p_data FOR
            SELECT p.pro_referencia,
                   p.pro_nombre,
                   p.pro_descripcion,
                   p.pro_precio,
                   p.pro_color,
                   p.pro_alto_cm,
                   p.pro_ancho_cm,
                   p.pro_profundidad_cm,
                   p.pro_peso,
                   t.tip_descripcion,
                   c.cat_descripcion,
                   m.mat_descripcion,
                   promo.prom_porcentaje,
                   promo.camp_nombre,
                   CASE WHEN promo.prom_porcentaje IS NOT NULL
                        THEN ROUND(p.pro_precio * (1 - promo.prom_porcentaje / 100), 2)
                        ELSE p.pro_precio
                   END AS precio_final,
                   NVL(stock.sto_disponible, 0) AS sto_disponible,
                   h.hv_historial_precio_venta
              FROM BOD_PRODUCTO p
              JOIN BOD_TIPO      t ON t.tip_tipo      = p.tip_tipo
              JOIN BOD_CATEGORIA c ON c.cat_categoria = t.cat_categoria
              JOIN BOD_MATERIAL  m ON m.mat_material  = p.mat_material
              LEFT JOIN (
                  SELECT pr.pro_referencia, MAX(pr.prom_porcentaje) prom_porcentaje,
                         MAX(ca.camp_nombre) camp_nombre
                    FROM PROMO_PROMOCION pr
                    JOIN PROMO_CAMPANA   ca ON ca.camp_campana = pr.camp_campana
                   WHERE ca.camp_estado = 'ACTIVA'
                   GROUP BY pr.pro_referencia
              ) promo ON promo.pro_referencia = p.pro_referencia
              LEFT JOIN (
                  SELECT h2.pro_referencia, SUM(s.sto_disponible) sto_disponible
                    FROM BOD_STOCK s
                    JOIN BOD_HISTORIAL_PRECIO h2 ON h2.hip_historial_precio = s.hip_historial_precio
                   WHERE h2.hip_fecha_final IS NULL
                   GROUP BY h2.pro_referencia
              ) stock ON stock.pro_referencia = p.pro_referencia
              LEFT JOIN (
                  SELECT pro_referencia, MIN(hv_historial_precio_venta) hv_historial_precio_venta
                    FROM BOD_HISTORIAL_PRECIO_VENTA
                   WHERE hv_fecha_final IS NULL
                   GROUP BY pro_referencia
              ) h ON h.pro_referencia = p.pro_referencia
             WHERE (p_categoria = 0 OR c.cat_categoria = p_categoria)
               AND (UPPER(p.pro_nombre)      LIKE v_txt
                OR  UPPER(p.pro_descripcion) LIKE v_txt
                OR  UPPER(t.tip_descripcion) LIKE v_txt
                OR  UPPER(m.mat_descripcion) LIKE v_txt)
             ORDER BY p.pro_nombre;
    END BUSCAR;

    PROCEDURE LISTAR_CATEGORIAS(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT cat_categoria, cat_descripcion
              FROM BOD_CATEGORIA
             ORDER BY cat_descripcion;
    END LISTAR_CATEGORIAS;

    PROCEDURE LISTAR_PROMOCIONES(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT p.pro_referencia,
                   p.pro_nombre,
                   p.pro_descripcion,
                   p.pro_precio,
                   p.pro_color,
                   p.pro_alto_cm,
                   p.pro_ancho_cm,
                   p.pro_profundidad_cm,
                   p.pro_peso,
                   t.tip_descripcion,
                   c.cat_descripcion,
                   m.mat_descripcion,
                   promo.prom_porcentaje,
                   promo.camp_nombre,
                   ROUND(p.pro_precio * (1 - promo.prom_porcentaje / 100), 2) AS precio_final,
                   NVL(stock.sto_disponible, 0) AS sto_disponible,
                   h.hv_historial_precio_venta
              FROM BOD_PRODUCTO p
              JOIN BOD_TIPO      t ON t.tip_tipo      = p.tip_tipo
              JOIN BOD_CATEGORIA c ON c.cat_categoria = t.cat_categoria
              JOIN BOD_MATERIAL  m ON m.mat_material  = p.mat_material
              JOIN (
                  SELECT pr.pro_referencia, MAX(pr.prom_porcentaje) prom_porcentaje,
                         MAX(ca.camp_nombre) camp_nombre
                    FROM PROMO_PROMOCION pr
                    JOIN PROMO_CAMPANA   ca ON ca.camp_campana = pr.camp_campana
                   WHERE ca.camp_estado = 'ACTIVA'
                   GROUP BY pr.pro_referencia
              ) promo ON promo.pro_referencia = p.pro_referencia
              LEFT JOIN (
                  SELECT h2.pro_referencia, SUM(s.sto_disponible) sto_disponible
                    FROM BOD_STOCK s
                    JOIN BOD_HISTORIAL_PRECIO h2 ON h2.hip_historial_precio = s.hip_historial_precio
                   WHERE h2.hip_fecha_final IS NULL
                   GROUP BY h2.pro_referencia
              ) stock ON stock.pro_referencia = p.pro_referencia
              LEFT JOIN (
                  SELECT pro_referencia, MIN(hv_historial_precio_venta) hv_historial_precio_venta
                    FROM BOD_HISTORIAL_PRECIO_VENTA
                   WHERE hv_fecha_final IS NULL
                   GROUP BY pro_referencia
              ) h ON h.pro_referencia = p.pro_referencia
             WHERE p.pro_precio > 0
             ORDER BY promo.prom_porcentaje DESC;
    END LISTAR_PROMOCIONES;

END PKG_CLI_CATALOGO;
/