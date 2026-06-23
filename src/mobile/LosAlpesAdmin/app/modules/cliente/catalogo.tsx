import { router } from "expo-router";
import React, { useEffect, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Image,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import { useCarrito } from "../../../context/CarritoContext";
import {
  buscarProductos,
  listarCategorias,
  listarProductos,
} from "../../../services/cliente/catalogoService";

const CAFE = "#5C3A1E";
const GOLD = "#C9973A";

export default function CatalogoScreen() {
  const { agregarItem, items } = useCarrito();
  const [productos, setProductos] = useState<any[]>([]);
  const [categorias, setCategorias] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [busqueda, setBusqueda] = useState("");
  const [categoriaActiva, setCategoriaActiva] = useState(0);
  const totalItems = items.reduce((a, i) => a + i.cantidad, 0);

  useEffect(() => {
    cargarCategorias();
    cargar();
  }, []);

  const cargarCategorias = async () => {
    try {
      const res = await listarCategorias();
      setCategorias(res.data || []);
    } catch {}
  };

  const cargar = async () => {
    setLoading(true);
    try {
      const res = await listarProductos();
      setProductos(res.data || []);
    } catch (e: any) {
      Alert.alert("Error", e.message);
    } finally {
      setLoading(false);
    }
  };

  const buscar = async (texto: string, cat: number) => {
    setLoading(true);
    try {
      const res = await buscarProductos(texto, cat);
      setProductos(res.data || []);
    } catch (e: any) {
      Alert.alert("Error", e.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCategoria = (id: number) => {
    setCategoriaActiva(id);
    buscar(busqueda, id);
  };

  const handleBuscar = () => buscar(busqueda, categoriaActiva);

  const handleLimpiar = () => {
    setBusqueda("");
    setCategoriaActiva(0);
    cargar();
  };

  const handleAgregar = (producto: any) => {
    if (!producto.HV_HISTORIAL_PRECIO_VENTA) {
      Alert.alert("Error", "Este producto no tiene precio disponible.");
      return;
    }
    if (producto.STO_DISPONIBLE <= 0) {
      Alert.alert("Agotado", "Este producto no tiene stock disponible.");
      return;
    }

    agregarItem({
      hvId: producto.HV_HISTORIAL_PRECIO_VENTA,
      proReferencia: producto.PRO_REFERENCIA,
      proNombre: producto.PRO_NOMBRE,
      precio: producto.PRECIO_FINAL,
      precioOriginal: producto.PRO_PRECIO,
      promPorcentaje: producto.PROM_PORCENTAJE,
      campNombre: producto.CAMP_NOMBRE,
      cantidad: 1,
    });

    Alert.alert("✅", `${producto.PRO_NOMBRE} agregado al carrito.`);
  };

  return (
    <View style={styles.container}>
      {/* Buscador */}
      <View style={styles.searchBar}>
        <View style={styles.searchWrap}>
          <Text style={styles.searchIco}>🔍</Text>
          <TextInput
            style={styles.searchInput}
            placeholder="Buscar por nombre, tipo, material..."
            value={busqueda}
            onChangeText={setBusqueda}
            onSubmitEditing={handleBuscar}
          />
        </View>
        <TouchableOpacity style={styles.btnGold} onPress={handleBuscar}>
          <Text style={styles.btnGoldText}>Buscar</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.btnOutline} onPress={handleLimpiar}>
          <Text style={styles.btnOutlineText}>Limpiar</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.carritoBtn}
          onPress={() => router.push("/modules/cliente/carrito" as any)}
        >
          <Text style={styles.carritoIcon}>🛒</Text>
          {totalItems > 0 && (
            <View style={styles.carritoBadge}>
              <Text style={styles.carritoBadgeText}>{totalItems}</Text>
            </View>
          )}
        </TouchableOpacity>
      </View>

      {/* Categorías */}
      <View style={styles.sidebarCard}>
        <View style={styles.sidebarHead}>
          <Text style={styles.sidebarHeadText}>🗂 Categorías</Text>
        </View>
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          style={styles.catScroll}
        >
          <TouchableOpacity
            style={[
              styles.catItem,
              categoriaActiva === 0 && styles.catItemActive,
            ]}
            onPress={() => handleCategoria(0)}
          >
            <Text
              style={[
                styles.catText,
                categoriaActiva === 0 && styles.catTextActive,
              ]}
            >
              Todas
            </Text>
          </TouchableOpacity>
          {categorias.map((c) => (
            <TouchableOpacity
              key={c.CAT_CATEGORIA}
              style={[
                styles.catItem,
                categoriaActiva === c.CAT_CATEGORIA && styles.catItemActive,
              ]}
              onPress={() => handleCategoria(c.CAT_CATEGORIA)}
            >
              <Text
                style={[
                  styles.catText,
                  categoriaActiva === c.CAT_CATEGORIA && styles.catTextActive,
                ]}
              >
                {c.CAT_DESCRIPCION}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      {/* Contador */}
      <View style={styles.toolbar}>
        <Text style={styles.toolbarText}>
          Artículos 1-<Text style={styles.toolbarBold}>{productos.length}</Text>
        </Text>
      </View>

      {/* Productos */}
      {loading ? (
        <ActivityIndicator color={CAFE} style={{ marginTop: 40 }} />
      ) : productos.length === 0 ? (
        <View style={styles.empty}>
          <Text style={styles.emptyIcon}>🛋️</Text>
          <Text style={styles.emptyText}>No se encontraron productos.</Text>
        </View>
      ) : (
        <FlatList
          data={productos}
          keyExtractor={(item) => item.PRO_REFERENCIA}
          numColumns={2}
          contentContainerStyle={styles.grid}
          renderItem={({ item }) => (
            <View style={styles.prodCard}>
              {/* Imagen — usa FOTO_URL que viene del servidor */}
              <View style={styles.cardImgWrap}>
                {item.FOTO_URL ? (
                  <Image
                    source={{ uri: item.FOTO_URL }}
                    style={styles.cardImg}
                    resizeMode="cover"
                    onError={() =>
                      console.log("Sin foto:", item.PRO_REFERENCIA)
                    }
                  />
                ) : (
                  <View style={styles.sinFoto}>
                    <Text style={styles.sinFotoIcon}>🛋️</Text>
                  </View>
                )}
                {item.PROM_PORCENTAJE && (
                  <View style={styles.badgePromo}>
                    <Text style={styles.badgePromoText}>
                      {item.CAMP_NOMBRE} -{item.PROM_PORCENTAJE}%
                    </Text>
                  </View>
                )}
                <View
                  style={[
                    styles.badgeStock,
                    item.STO_DISPONIBLE > 0
                      ? styles.badgeDisponible
                      : styles.badgeAgotado,
                  ]}
                >
                  <Text style={styles.badgeStockText}>
                    {item.STO_DISPONIBLE > 0 ? "✓ Disponible" : "Agotado"}
                  </Text>
                </View>
              </View>

              {/* Info */}
              <View style={styles.cardBody}>
                <Text style={styles.cardCategoria}>{item.CAT_DESCRIPCION}</Text>
                <Text style={styles.cardNombre} numberOfLines={2}>
                  {item.PRO_NOMBRE}
                </Text>
                <Text style={styles.cardTipo} numberOfLines={1}>
                  {item.TIP_DESCRIPCION} · {item.MAT_DESCRIPCION}
                </Text>
                <View style={styles.cardPrecioWrap}>
                  {item.PROM_PORCENTAJE && (
                    <Text style={styles.precioOriginal}>
                      Q {Number(item.PRO_PRECIO).toFixed(2)}
                    </Text>
                  )}
                  <Text
                    style={[
                      styles.precioFinal,
                      item.PROM_PORCENTAJE && styles.precioPromo,
                    ]}
                  >
                    Q {Number(item.PRECIO_FINAL).toFixed(2)}
                  </Text>
                </View>
              </View>

              {/* Botones */}
              <View style={styles.cardFooter}>
                <TouchableOpacity
                  style={styles.btnDetalle}
                  onPress={() =>
                    router.push(
                      `/modules/cliente/detalleProducto?ref=${item.PRO_REFERENCIA}` as any,
                    )
                  }
                >
                  <Text style={styles.btnDetalleText}>👁 Ver</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={[
                    styles.btnCarrito,
                    item.STO_DISPONIBLE <= 0 && styles.btnCarritoDisabled,
                  ]}
                  disabled={item.STO_DISPONIBLE <= 0}
                  onPress={() => handleAgregar(item)}
                >
                  <Text style={styles.btnCarritoText}>+ Agregar</Text>
                </TouchableOpacity>
              </View>
            </View>
          )}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#f5ece0" },
  searchBar: {
    backgroundColor: "white",
    padding: 12,
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
    borderBottomWidth: 1,
    borderBottomColor: "#e8d8c0",
    flexWrap: "wrap",
  },
  searchWrap: {
    flex: 1,
    minWidth: 120,
    position: "relative",
    flexDirection: "row",
    alignItems: "center",
    borderWidth: 2,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    backgroundColor: "#fdf8f3",
  },
  searchIco: { paddingLeft: 10, fontSize: 14 },
  searchInput: { flex: 1, padding: 9, fontSize: 13, color: "#333" },
  btnGold: {
    backgroundColor: GOLD,
    paddingHorizontal: 14,
    paddingVertical: 10,
    borderRadius: 8,
  },
  btnGoldText: { color: "white", fontWeight: "bold", fontSize: 13 },
  btnOutline: {
    borderWidth: 2,
    borderColor: "#e8d8c0",
    paddingHorizontal: 14,
    paddingVertical: 10,
    borderRadius: 8,
  },
  btnOutlineText: { color: CAFE, fontSize: 13 },
  carritoBtn: { position: "relative", padding: 6 },
  carritoIcon: { fontSize: 24 },
  carritoBadge: {
    position: "absolute",
    top: 0,
    right: 0,
    backgroundColor: "#e53e3e",
    borderRadius: 10,
    width: 18,
    height: 18,
    alignItems: "center",
    justifyContent: "center",
  },
  carritoBadgeText: { color: "white", fontSize: 9, fontWeight: "bold" },
  sidebarCard: {
    backgroundColor: "white",
    borderBottomWidth: 1,
    borderBottomColor: "#e8d8c0",
  },
  sidebarHead: {
    backgroundColor: CAFE,
    paddingHorizontal: 16,
    paddingVertical: 10,
  },
  sidebarHeadText: {
    color: "#f0d9a0",
    fontSize: 12,
    fontWeight: "bold",
    textTransform: "uppercase",
    letterSpacing: 1,
  },
  catScroll: { paddingVertical: 8 },
  catItem: {
    paddingHorizontal: 14,
    paddingVertical: 8,
    marginHorizontal: 4,
    borderLeftWidth: 3,
    borderLeftColor: "transparent",
  },
  catItemActive: { backgroundColor: "#fdf6ec", borderLeftColor: GOLD },
  catText: { fontSize: 13, color: "#3a2a1a" },
  catTextActive: { color: GOLD, fontWeight: "bold" },
  toolbar: { paddingHorizontal: 16, paddingVertical: 8 },
  toolbarText: { fontSize: 13, color: "#888" },
  toolbarBold: { color: CAFE, fontWeight: "bold" },
  grid: { padding: 8 },
  prodCard: {
    flex: 1,
    backgroundColor: "white",
    borderRadius: 12,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    margin: 6,
    overflow: "hidden",
    elevation: 2,
  },
  cardImgWrap: {
    height: 160,
    position: "relative",
    backgroundColor: "#fdf8f3",
  },
  cardImg: { width: "100%", height: "100%" },
  sinFoto: {
    width: "100%",
    height: "100%",
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: "#f0ebe0",
  },
  sinFotoIcon: { fontSize: 48, color: "#e8d8c0" },
  badgePromo: {
    position: "absolute",
    top: 6,
    left: 6,
    backgroundColor: "#e53e3e",
    borderRadius: 20,
    paddingHorizontal: 6,
    paddingVertical: 2,
  },
  badgePromoText: { color: "white", fontSize: 9, fontWeight: "bold" },
  badgeStock: {
    position: "absolute",
    top: 6,
    right: 6,
    borderRadius: 20,
    paddingHorizontal: 6,
    paddingVertical: 2,
  },
  badgeDisponible: { backgroundColor: "rgba(39,103,73,0.85)" },
  badgeAgotado: { backgroundColor: "rgba(0,0,0,0.55)" },
  badgeStockText: { color: "white", fontSize: 9, fontWeight: "bold" },
  cardBody: { padding: 10, flex: 1 },
  cardCategoria: {
    fontSize: 10,
    fontWeight: "bold",
    textTransform: "uppercase",
    letterSpacing: 0.8,
    color: GOLD,
    marginBottom: 2,
  },
  cardNombre: {
    fontSize: 13,
    fontWeight: "bold",
    color: "#3a2a1a",
    marginBottom: 2,
  },
  cardTipo: { fontSize: 11, color: "#888", marginBottom: 6 },
  cardPrecioWrap: { marginTop: "auto" as any },
  precioOriginal: {
    fontSize: 11,
    color: "#aaa",
    textDecorationLine: "line-through",
  },
  precioFinal: { fontSize: 16, fontWeight: "bold", color: CAFE },
  precioPromo: { color: "#e53e3e" },
  cardFooter: {
    flexDirection: "row",
    padding: 8,
    gap: 6,
    borderTopWidth: 1,
    borderTopColor: "#f5ece0",
  },
  btnDetalle: {
    flex: 1,
    backgroundColor: "#fdf6ec",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    padding: 7,
    borderRadius: 6,
    alignItems: "center",
  },
  btnDetalleText: { color: GOLD, fontSize: 11, fontWeight: "bold" },
  btnCarrito: {
    flex: 2,
    backgroundColor: CAFE,
    padding: 7,
    borderRadius: 6,
    alignItems: "center",
  },
  btnCarritoDisabled: { backgroundColor: "#ccc" },
  btnCarritoText: { color: "white", fontSize: 11, fontWeight: "bold" },
  empty: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    padding: 40,
  },
  emptyIcon: { fontSize: 64, marginBottom: 12 },
  emptyText: { fontSize: 15, color: "#aaa" },
});
