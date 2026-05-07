import React, { useEffect, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Modal,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import {
  getHistorialPorMes,
  getHistorialTodos,
  HistorialPrecio,
} from "../../services/catalogoInventario/precios";

export default function PreciosScreen() {
  const [historialOriginal, setHistorialOriginal] = useState<HistorialPrecio[]>(
    [],
  );
  const [historialFiltrado, setHistorialFiltrado] = useState<HistorialPrecio[]>(
    [],
  );
  const [loading, setLoading] = useState(false);

  // Filtros
  const [searchProducto, setSearchProducto] = useState("");
  const [soloVigentes, setSoloVigentes] = useState(false);
  const [mesSeleccionado, setMesSeleccionado] = useState<number | null>(null);
  const [anioSeleccionado, setAnioSeleccionado] = useState<number | null>(null);

  // Modales para selectores
  const [modalMesVisible, setModalMesVisible] = useState(false);
  const [modalAnioVisible, setModalAnioVisible] = useState(false);

  // Listas de meses y años
  const meses = [
    { id: 1, nombre: "Enero" },
    { id: 2, nombre: "Febrero" },
    { id: 3, nombre: "Marzo" },
    { id: 4, nombre: "Abril" },
    { id: 5, nombre: "Mayo" },
    { id: 6, nombre: "Junio" },
    { id: 7, nombre: "Julio" },
    { id: 8, nombre: "Agosto" },
    { id: 9, nombre: "Septiembre" },
    { id: 10, nombre: "Octubre" },
    { id: 11, nombre: "Noviembre" },
    { id: 12, nombre: "Diciembre" },
  ];

  const anioActual = new Date().getFullYear();
  const anios = Array.from({ length: 10 }, (_, i) => anioActual - i);

  useEffect(() => {
    cargarDatos();
  }, []);

  // Escucha cambios en los filtros locales (nombre y estado vigente)
  useEffect(() => {
    aplicarFiltrosLocales();
  }, [searchProducto, soloVigentes, historialOriginal]);

  const cargarDatos = async () => {
    setLoading(true);
    try {
      let data: HistorialPrecio[];

      // Si el usuario seleccionó un mes Y un año, consultamos al backend por fecha
      if (mesSeleccionado && anioSeleccionado) {
        data = await getHistorialPorMes(mesSeleccionado, anioSeleccionado);
      } else {
        // Por defecto, o si los filtros de fecha están incompletos, traemos todos
        data = await getHistorialTodos();
      }

      setHistorialOriginal(data);
    } catch (error) {
      Alert.alert("Error", "No se pudo cargar el historial de precios.");
    } finally {
      setLoading(false);
    }
  };

  const aplicarFiltrosLocales = () => {
    let filtrados = historialOriginal;

    if (searchProducto.trim()) {
      filtrados = filtrados.filter((item) =>
        item.PRO_NOMBRE.toLowerCase().includes(searchProducto.toLowerCase()),
      );
    }

    if (soloVigentes) {
      filtrados = filtrados.filter((item) => !item.HIP_FECHA_FINAL);
    }

    setHistorialFiltrado(filtrados);
  };

  const handleLimpiarFiltros = () => {
    setSearchProducto("");
    setSoloVigentes(false);
    setMesSeleccionado(null);
    setAnioSeleccionado(null);
    cargarDatos(); // Recarga sin filtros de fecha
  };

  const formatFecha = (fechaString?: string | null) => {
    if (!fechaString) return "Vigente";
    // Extraemos solo la porción de la fecha asumiendo formato ISO (YYYY-MM-DD)
    return fechaString.split("T")[0];
  };

  const renderHeader = () => (
    <View>
      <View style={styles.modHeader}>
        <View style={{ flex: 1 }}>
          <Text style={styles.modTitle}>Historial de Precios</Text>
          <Text style={styles.modSubtitle}>
            Registro de precios de venta por producto, almacén y nicho.
          </Text>
        </View>
        <Text style={styles.modIcon}>💰</Text>
      </View>

      <View style={styles.filterBar}>
        <View style={styles.rowInputs}>
          {/* Selector de Mes */}
          <View style={{ flex: 1, marginRight: 5 }}>
            <Text style={styles.label}>Mes</Text>
            <TouchableOpacity
              style={styles.selectorInput}
              onPress={() => setModalMesVisible(true)}
            >
              <Text
                style={
                  mesSeleccionado
                    ? styles.selectorText
                    : styles.selectorPlaceholder
                }
              >
                {mesSeleccionado
                  ? meses.find((m) => m.id === mesSeleccionado)?.nombre
                  : "Todos"}
              </Text>
            </TouchableOpacity>
          </View>

          {/* Selector de Año */}
          <View style={{ flex: 1, marginLeft: 5 }}>
            <Text style={styles.label}>Año</Text>
            <TouchableOpacity
              style={styles.selectorInput}
              onPress={() => setModalAnioVisible(true)}
            >
              <Text
                style={
                  anioSeleccionado
                    ? styles.selectorText
                    : styles.selectorPlaceholder
                }
              >
                {anioSeleccionado ? anioSeleccionado.toString() : "Todos"}
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        <Text style={styles.label}>Producto</Text>
        <TextInput
          style={styles.searchInput}
          placeholder="Buscar por nombre..."
          value={searchProducto}
          onChangeText={setSearchProducto}
        />

        <TouchableOpacity
          style={[styles.chkWrap, soloVigentes && styles.chkWrapActive]}
          onPress={() => setSoloVigentes(!soloVigentes)}
        >
          <Text style={styles.chkText}>
            {soloVigentes ? "🟢 Solo vigentes" : "⚪ Mostrar todos"}
          </Text>
        </TouchableOpacity>

        <View style={styles.rowActions}>
          <TouchableOpacity style={styles.btnGold} onPress={cargarDatos}>
            <Text style={styles.btnTextDark}>🔍 Filtrar Backend</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.btnOutline}
            onPress={handleLimpiarFiltros}
          >
            <Text style={styles.btnTextGold}>Limpiar</Text>
          </TouchableOpacity>
        </View>
      </View>

      <Text style={styles.contadorText}>
        Mostrando{" "}
        <Text style={styles.contadorBold}>{historialFiltrado.length}</Text>{" "}
        registro(s)
      </Text>
    </View>
  );

  const renderItem = ({ item }: { item: HistorialPrecio }) => (
    <View style={styles.card}>
      <View style={styles.cardHeader}>
        <Text style={styles.badgeId}>ID: {item.HIP_HISTORIAL_PRECIO}</Text>
        <Text style={styles.priceText}>
          Q {Number(item.HIP_PRECIO).toFixed(2)}
        </Text>
      </View>

      <Text style={styles.productName}>{item.PRO_NOMBRE}</Text>

      <View style={styles.detailsBox}>
        <Text style={styles.detailText}>
          📦 <Text style={{ fontWeight: "bold" }}>Almacén:</Text>{" "}
          {item.ALM_NOMBRE}
        </Text>
        <Text style={styles.detailText}>
          🗄️ <Text style={{ fontWeight: "bold" }}>Nicho:</Text>{" "}
          {item.NIC_NUMERO} ({item.NIC_CARACTERISTICA})
        </Text>
      </View>

      <View style={styles.datesRow}>
        <Text style={styles.dateText}>
          Desde: {formatFecha(item.HIP_FECHA_INICIO)}
        </Text>
        <Text
          style={[styles.dateText, !item.HIP_FECHA_FINAL && styles.dateActive]}
        >
          Hasta: {formatFecha(item.HIP_FECHA_FINAL)}
        </Text>
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      {/* Lista Principal */}
      <FlatList
        data={historialFiltrado}
        keyExtractor={(item) => item.HIP_HISTORIAL_PRECIO.toString()}
        renderItem={renderItem}
        ListHeaderComponent={renderHeader}
        contentContainerStyle={{ paddingBottom: 20 }}
        ListEmptyComponent={
          loading ? (
            <ActivityIndicator
              size="large"
              color="#C9973A"
              style={{ marginTop: 20 }}
            />
          ) : (
            <View style={styles.emptyState}>
              <Text style={styles.emptyEmoji}>📉</Text>
              <Text style={styles.emptyText}>
                No hay registros que coincidan.
              </Text>
            </View>
          )
        }
      />

      {/* Modal Selector de Mes usando FlatList */}
      <Modal visible={modalMesVisible} animationType="fade" transparent={true}>
        <View style={styles.modalOverlay}>
          <View style={styles.selectorContent}>
            <Text style={styles.modalTitle}>Selecciona un Mes</Text>
            <FlatList
              data={meses}
              keyExtractor={(item) => item.id.toString()}
              showsVerticalScrollIndicator={false}
              ListHeaderComponent={
                <TouchableOpacity
                  style={styles.selectorItem}
                  onPress={() => {
                    setMesSeleccionado(null);
                    setModalMesVisible(false);
                  }}
                >
                  <Text style={styles.selectorItemText}>Todos los meses</Text>
                </TouchableOpacity>
              }
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={styles.selectorItem}
                  onPress={() => {
                    setMesSeleccionado(item.id);
                    setModalMesVisible(false);
                  }}
                >
                  <Text style={styles.selectorItemText}>{item.nombre}</Text>
                </TouchableOpacity>
              )}
            />
            <TouchableOpacity
              style={styles.btnCancelSelector}
              onPress={() => setModalMesVisible(false)}
            >
              <Text style={styles.btnTextRed}>Cancelar</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>

      {/* Modal Selector de Año usando FlatList */}
      <Modal visible={modalAnioVisible} animationType="fade" transparent={true}>
        <View style={styles.modalOverlay}>
          <View style={styles.selectorContent}>
            <Text style={styles.modalTitle}>Selecciona un Año</Text>
            <FlatList
              data={anios}
              keyExtractor={(item) => item.toString()}
              showsVerticalScrollIndicator={false}
              ListHeaderComponent={
                <TouchableOpacity
                  style={styles.selectorItem}
                  onPress={() => {
                    setAnioSeleccionado(null);
                    setModalAnioVisible(false);
                  }}
                >
                  <Text style={styles.selectorItemText}>Todos los años</Text>
                </TouchableOpacity>
              }
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={styles.selectorItem}
                  onPress={() => {
                    setAnioSeleccionado(item);
                    setModalAnioVisible(false);
                  }}
                >
                  <Text style={styles.selectorItemText}>{item}</Text>
                </TouchableOpacity>
              )}
            />
            <TouchableOpacity
              style={styles.btnCancelSelector}
              onPress={() => setModalAnioVisible(false)}
            >
              <Text style={styles.btnTextRed}>Cancelar</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#fdf8f3", padding: 16 },

  // Header Banner
  modHeader: {
    backgroundColor: "#1a1a1a",
    borderRadius: 12,
    padding: 20,
    marginBottom: 16,
    borderLeftWidth: 5,
    borderLeftColor: "#C9973A",
    flexDirection: "row",
    alignItems: "center",
  },
  modTitle: {
    color: "#C9973A",
    fontSize: 20,
    fontWeight: "bold",
    marginBottom: 4,
  },
  modSubtitle: { color: "rgba(240,217,160,0.7)", fontSize: 13 },
  modIcon: { fontSize: 40, opacity: 0.5 },

  // Filtros
  filterBar: {
    backgroundColor: "white",
    borderRadius: 12,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    padding: 16,
    marginBottom: 12,
    elevation: 1,
  },
  label: {
    fontSize: 11,
    fontWeight: "bold",
    color: "#5C3A1E",
    textTransform: "uppercase",
    marginBottom: 4,
  },
  rowInputs: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 10,
  },
  searchInput: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1.5,
    borderColor: "#e0d0b8",
    borderRadius: 8,
    paddingHorizontal: 12,
    height: 45,
    marginBottom: 12,
  },

  // Selectores (Combos)
  selectorInput: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1.5,
    borderColor: "#e0d0b8",
    borderRadius: 8,
    paddingHorizontal: 12,
    height: 45,
    justifyContent: "center",
  },
  selectorText: { color: "#333", fontSize: 14 },
  selectorPlaceholder: { color: "#888", fontSize: 14 },

  // Checkbox estilo botón
  chkWrap: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1.5,
    borderColor: "#e0d0b8",
    borderRadius: 8,
    padding: 12,
    alignItems: "center",
    marginBottom: 16,
  },
  chkWrapActive: { borderColor: "#276749", backgroundColor: "#f0fff4" },
  chkText: { fontSize: 14, fontWeight: "bold", color: "#333" },

  rowActions: { flexDirection: "row", gap: 10 },
  btnGold: {
    flex: 1,
    backgroundColor: "#C9973A",
    padding: 12,
    borderRadius: 8,
    alignItems: "center",
  },
  btnOutline: {
    flex: 1,
    backgroundColor: "white",
    borderWidth: 1.5,
    borderColor: "#e0d0b8",
    padding: 12,
    borderRadius: 8,
    alignItems: "center",
  },
  btnTextDark: { color: "#1a0e05", fontWeight: "bold" },
  btnTextGold: { color: "#C9973A", fontWeight: "bold" },

  contadorText: {
    fontSize: 12,
    color: "#888",
    marginBottom: 12,
    marginLeft: 4,
  },
  contadorBold: { color: "#5C3A1E", fontWeight: "bold" },

  // Cards de resultados
  card: {
    backgroundColor: "white",
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  cardHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 8,
  },
  badgeId: {
    backgroundColor: "#fdf6ec",
    color: "#C9973A",
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
    fontSize: 11,
    fontWeight: "bold",
    overflow: "hidden",
  },
  priceText: { fontSize: 18, fontWeight: "bold", color: "#276749" },
  productName: {
    fontSize: 16,
    color: "#333",
    fontWeight: "bold",
    marginBottom: 10,
  },

  detailsBox: {
    backgroundColor: "#fdf8f3",
    padding: 10,
    borderRadius: 8,
    marginBottom: 10,
  },
  detailText: { fontSize: 13, color: "#555", marginBottom: 4 },

  datesRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    borderTopWidth: 1,
    borderTopColor: "#f5ece0",
    paddingTop: 10,
  },
  dateText: { fontSize: 12, color: "#777" },
  dateActive: { color: "#276749", fontWeight: "bold" },

  // Empty State
  emptyState: { alignItems: "center", marginTop: 20 },
  emptyEmoji: { fontSize: 48, marginBottom: 10 },
  emptyText: { color: "#aaa", fontSize: 14 },

  // Modales
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    justifyContent: "center",
    padding: 20,
  },
  selectorContent: {
    backgroundColor: "white",
    padding: 20,
    borderRadius: 12,
    maxHeight: "60%",
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 16,
    textAlign: "center",
  },
  selectorItem: {
    paddingVertical: 14,
    borderBottomWidth: 1,
    borderBottomColor: "#f5ece0",
    alignItems: "center",
  },
  selectorItemText: { fontSize: 16, color: "#444" },
  btnCancelSelector: {
    marginTop: 16,
    alignItems: "center",
    padding: 12,
    backgroundColor: "#fff5f5",
    borderRadius: 8,
  },
  btnTextRed: { color: "#e53e3e", fontWeight: "bold" },
});
