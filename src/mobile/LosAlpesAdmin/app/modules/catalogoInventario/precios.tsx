import React, { useEffect, useMemo, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Modal,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import {
  getHistorialAnios,
  getHistorialPorMes,
  getHistorialTodos,
  HistorialPrecio,
} from "../../../services/catalogoInventario/precios";

// ─── mensajes de error amigables ─────────────────────────────────────────────
function getMensajeError(e: any, contexto: string): string {
  const raw = (e?.message ?? "").toLowerCase();
  const status = e?.status ?? e?.statusCode;
  if (raw.includes("ora-20008") || raw.includes("mes debe ser"))
    return "El mes seleccionado no es válido (debe ser 1–12).";
  if (raw.includes("ora-20009") || raw.includes("anio invalido"))
    return "El año seleccionado no es válido.";
  if (status === 500 || raw.includes("500"))
    return "Error en el servidor. Intentá más tarde.";
  if (
    raw.includes("network") ||
    raw.includes("fetch") ||
    raw.includes("timeout")
  )
    return "Sin conexión. Verificá tu red e intentá de nuevo.";
  if (e?.message && e.message.length < 150) return e.message;
  return `No se pudo ${contexto}. Intentá de nuevo.`;
}

const MESES = [
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

export default function PreciosScreen() {
  // ── datos ──
  const [historialOriginal, setHistorialOriginal] = useState<HistorialPrecio[]>(
    [],
  );
  const [aniosDisponibles, setAniosDisponibles] = useState<number[]>([]);
  const [loading, setLoading] = useState(false);

  // ── inputs de filtro (pendientes de aplicar) ──
  const [searchInput, setSearchInput] = useState("");
  const [soloVigentesIn, setSoloVigentesIn] = useState(false);
  const [mesInput, setMesInput] = useState<number | null>(null);
  const [anioInput, setAnioInput] = useState<number | null>(null);

  // ── filtros aplicados (solo cambian al presionar Filtrar) ──
  const [searchActivo, setSearchActivo] = useState("");
  const [soloVigentesAct, setSoloVigentesAct] = useState(false);

  // ── modales selectores ──
  const [modalMesVisible, setModalMesVisible] = useState(false);
  const [modalAnioVisible, setModalAnioVisible] = useState(false);

  // ── panel de filtros colapsable ──
  const [filtrosExpandido, setFiltrosExpandido] = useState(false);

  // ─── carga inicial ────────────────────────────────────────────────────────
  useEffect(() => {
    cargarAnios();
    cargarDatos(null, null);
  }, []);

  const cargarAnios = async () => {
    try {
      const anios = await getHistorialAnios(); // llama OBTENER_ANIOS del paquete
      setAniosDisponibles(anios);
      // pre-seleccionar el año más reciente
      if (anios.length > 0) setAnioInput(anios[0]);
    } catch {}
  };

  // cargarDatos recibe mes/año explícitamente para no depender del estado asíncrono
  const cargarDatos = async (mes: number | null, anio: number | null) => {
    setLoading(true);
    try {
      let data: HistorialPrecio[];
      if (mes !== null && anio !== null) {
        data = await getHistorialPorMes(mes, anio);
      } else {
        data = await getHistorialTodos();
      }
      setHistorialOriginal(data);
    } catch (e: any) {
      Alert.alert(
        "Error al cargar",
        getMensajeError(e, "cargar el historial de precios"),
      );
    } finally {
      setLoading(false);
    }
  };

  // ─── aplicar / limpiar filtros ────────────────────────────────────────────
  const handleFiltrar = () => {
    // 1. Actualizar filtros locales aplicados
    setSearchActivo(searchInput.trim());
    setSoloVigentesAct(soloVigentesIn);
    // 2. Si hay mes+año, pedir datos al backend; si no, traer todos
    cargarDatos(mesInput, anioInput);
  };

  const handleLimpiar = () => {
    setSearchInput("");
    setSoloVigentesIn(false);
    setMesInput(null);
    // mantener el año más reciente como la web hace con ddlAnio
    setAnioInput(aniosDisponibles.length > 0 ? aniosDisponibles[0] : null);
    setSearchActivo("");
    setSoloVigentesAct(false);
    cargarDatos(null, null);
  };

  // ─── filtrado local (producto + vigentes) — mismo que la web ─────────────
  const historialFiltrado = useMemo(() => {
    let lista = historialOriginal;
    if (searchActivo) {
      lista = lista.filter((i) =>
        i.PRO_NOMBRE?.toLowerCase().includes(searchActivo.toLowerCase()),
      );
    }
    if (soloVigentesAct) {
      lista = lista.filter((i) => !i.HIP_FECHA_FINAL);
    }
    return lista;
  }, [historialOriginal, searchActivo, soloVigentesAct]);

  const hayFiltrosActivos =
    searchActivo !== "" || soloVigentesAct || mesInput !== null;

  // ─── helpers ──────────────────────────────────────────────────────────────
  const formatFecha = (fecha?: string | null): string => {
    if (!fecha) return "Vigente";
    const clean = fecha.split("T")[0];
    if (clean.includes("-")) {
      const [y, m, d] = clean.split("-");
      return `${d.padStart(2, "0")}/${m.padStart(2, "0")}/${y}`;
    }
    return clean; // ya viene DD/MM/YYYY
  };

  // ─── render item ──────────────────────────────────────────────────────────
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
        <Text style={styles.dateLabel}>
          Desde: {formatFecha(item.HIP_FECHA_INICIO)}
        </Text>
        <Text
          style={[
            styles.dateLabel,
            !item.HIP_FECHA_FINAL && styles.dateVigente,
          ]}
        >
          Hasta: {formatFecha(item.HIP_FECHA_FINAL)}
        </Text>
      </View>
    </View>
  );

  // ─────────────────────────────────────────────────────────────────────────
  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        {/* ══ HEADER ══ */}
        <View style={styles.modHeader}>
          <View style={{ flex: 1 }}>
            <Text style={styles.modTitle}>Historial de Precios</Text>
            <Text style={styles.modSubtitle}>
              Precios de venta por producto, almacén y nicho.
            </Text>
          </View>
          <Text style={styles.modIcon}>💰</Text>
        </View>

        {/* ══ BARRA COMPACTA: buscador + toggle filtros + botón filtrar ══ */}
        <View style={styles.topBar}>
          <View style={styles.searchRow}>
            <TextInput
              style={styles.searchInput}
              placeholder="Buscar por producto..."
              value={searchInput}
              onChangeText={setSearchInput}
              returnKeyType="search"
              onSubmitEditing={handleFiltrar}
              autoCorrect={false}
            />
            {searchInput.trim() !== "" && (
              <TouchableOpacity
                style={styles.btnClear}
                onPress={() => setSearchInput("")}
              >
                <Text style={styles.btnTextGold}>✕</Text>
              </TouchableOpacity>
            )}
            <TouchableOpacity
              style={[
                styles.btnToggle,
                filtrosExpandido && styles.btnToggleActive,
              ]}
              onPress={() => setFiltrosExpandido((v) => !v)}
            >
              <Text style={{ fontSize: 15 }}>⚙️</Text>
              {hayFiltrosActivos && <View style={styles.toggleDot} />}
            </TouchableOpacity>
          </View>

          <View style={styles.topActions}>
            <TouchableOpacity
              style={styles.btnFiltrar}
              onPress={handleFiltrar}
              disabled={loading}
            >
              {loading ? (
                <ActivityIndicator size="small" color="#1a0e05" />
              ) : (
                <Text style={styles.btnTextDark}>🔍 Filtrar</Text>
              )}
            </TouchableOpacity>
            {hayFiltrosActivos && (
              <TouchableOpacity
                style={styles.btnLimpiar}
                onPress={handleLimpiar}
              >
                <Text style={styles.btnTextGold}>✕ Limpiar</Text>
              </TouchableOpacity>
            )}
          </View>
        </View>

        {/* ══ PANEL DE FILTROS COLAPSABLE ══ */}
        {filtrosExpandido && (
          <View style={styles.filterBar}>
            <View style={styles.rowInputs}>
              <View style={{ flex: 1, marginRight: 6 }}>
                <Text style={styles.label}>MES</Text>
                <TouchableOpacity
                  style={styles.selectorInput}
                  onPress={() => setModalMesVisible(true)}
                >
                  <Text
                    style={
                      mesInput
                        ? styles.selectorText
                        : styles.selectorPlaceholder
                    }
                  >
                    {mesInput
                      ? MESES.find((m) => m.id === mesInput)?.nombre
                      : "Todos"}
                  </Text>
                  <Text style={styles.selectorArrow}>▾</Text>
                </TouchableOpacity>
              </View>
              <View style={{ flex: 1, marginLeft: 6 }}>
                <Text style={styles.label}>AÑO</Text>
                <TouchableOpacity
                  style={styles.selectorInput}
                  onPress={() => setModalAnioVisible(true)}
                >
                  <Text
                    style={
                      anioInput
                        ? styles.selectorText
                        : styles.selectorPlaceholder
                    }
                  >
                    {anioInput?.toString() ?? "Todos"}
                  </Text>
                  <Text style={styles.selectorArrow}>▾</Text>
                </TouchableOpacity>
              </View>
            </View>

            <TouchableOpacity
              style={[styles.chkWrap, soloVigentesIn && styles.chkWrapActive]}
              onPress={() => setSoloVigentesIn((v) => !v)}
            >
              <Text
                style={[styles.chkText, soloVigentesIn && styles.chkTextActive]}
              >
                {soloVigentesIn ? "🟢 Solo vigentes" : "⚪ Mostrar todos"}
              </Text>
            </TouchableOpacity>
          </View>
        )}

        {/* Contador */}
        <Text style={styles.contadorText}>
          Mostrando{" "}
          <Text style={styles.contadorBold}>{historialFiltrado.length}</Text>{" "}
          registro(s)
          {hayFiltrosActivos && (
            <Text style={styles.filtroNote}> · filtros activos</Text>
          )}
        </Text>

        {/* ══ LISTA — flex:1 para ocupar todo el espacio restante ══ */}
        <FlatList
          data={historialFiltrado}
          keyExtractor={(item) => item.HIP_HISTORIAL_PRECIO.toString()}
          renderItem={renderItem}
          keyboardShouldPersistTaps="handled"
          style={styles.lista}
          contentContainerStyle={{ paddingBottom: 24 }}
          ListEmptyComponent={
            loading ? (
              <ActivityIndicator
                size="large"
                color="#C9973A"
                style={{ marginTop: 30 }}
              />
            ) : (
              <View style={styles.emptyState}>
                <Text style={styles.emptyEmoji}>📉</Text>
                <Text style={styles.emptyTitle}>Sin registros</Text>
                <Text style={styles.emptyText}>
                  {hayFiltrosActivos
                    ? "No hay registros que coincidan con los filtros aplicados."
                    : "No hay historial de precios registrado."}
                </Text>
                {hayFiltrosActivos && (
                  <TouchableOpacity
                    style={styles.btnLimpiarEmpty}
                    onPress={handleLimpiar}
                  >
                    <Text style={styles.btnTextGold}>Limpiar filtros</Text>
                  </TouchableOpacity>
                )}
              </View>
            )
          }
        />

        {/* ══ MODAL SELECTOR MES ══ */}
        <Modal visible={modalMesVisible} animationType="fade" transparent>
          <View style={styles.modalOverlay}>
            <View style={styles.selectorContent}>
              <Text style={styles.modalTitle}>Seleccionar mes</Text>
              <FlatList
                data={MESES}
                keyExtractor={(item) => item.id.toString()}
                showsVerticalScrollIndicator={false}
                ListHeaderComponent={
                  <TouchableOpacity
                    style={[
                      styles.selectorItem,
                      mesInput === null && styles.selectorItemSel,
                    ]}
                    onPress={() => {
                      setMesInput(null);
                      setModalMesVisible(false);
                    }}
                  >
                    <Text style={styles.selectorItemText}>
                      — Todos los meses —
                    </Text>
                  </TouchableOpacity>
                }
                renderItem={({ item }) => (
                  <TouchableOpacity
                    style={[
                      styles.selectorItem,
                      mesInput === item.id && styles.selectorItemSel,
                    ]}
                    onPress={() => {
                      setMesInput(item.id);
                      setModalMesVisible(false);
                    }}
                  >
                    <Text
                      style={[
                        styles.selectorItemText,
                        mesInput === item.id && styles.selectorItemTextSel,
                      ]}
                    >
                      {item.nombre}
                    </Text>
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

        {/* ══ MODAL SELECTOR AÑO — años vienen del backend (OBTENER_ANIOS) ══ */}
        <Modal visible={modalAnioVisible} animationType="fade" transparent>
          <View style={styles.modalOverlay}>
            <View style={styles.selectorContent}>
              <Text style={styles.modalTitle}>Seleccionar año</Text>
              {aniosDisponibles.length === 0 ? (
                <ActivityIndicator
                  size="small"
                  color="#C9973A"
                  style={{ marginVertical: 20 }}
                />
              ) : (
                <FlatList
                  data={aniosDisponibles}
                  keyExtractor={(item) => item.toString()}
                  showsVerticalScrollIndicator={false}
                  ListHeaderComponent={
                    <TouchableOpacity
                      style={[
                        styles.selectorItem,
                        anioInput === null && styles.selectorItemSel,
                      ]}
                      onPress={() => {
                        setAnioInput(null);
                        setModalAnioVisible(false);
                      }}
                    >
                      <Text style={styles.selectorItemText}>
                        — Todos los años —
                      </Text>
                    </TouchableOpacity>
                  }
                  renderItem={({ item }) => (
                    <TouchableOpacity
                      style={[
                        styles.selectorItem,
                        anioInput === item && styles.selectorItemSel,
                      ]}
                      onPress={() => {
                        setAnioInput(item);
                        setModalAnioVisible(false);
                      }}
                    >
                      <Text
                        style={[
                          styles.selectorItemText,
                          anioInput === item && styles.selectorItemTextSel,
                        ]}
                      >
                        {item}
                      </Text>
                    </TouchableOpacity>
                  )}
                />
              )}
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
    </SafeAreaView>
  );
}

// ─────────────────────────────────────────────────────────────────────────────
const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: "#fdf8f3" },
  container: { flex: 1, padding: 16 },

  // header oscuro
  modHeader: {
    backgroundColor: "#1a1a1a",
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    borderLeftWidth: 5,
    borderLeftColor: "#C9973A",
    flexDirection: "row",
    alignItems: "center",
  },
  modTitle: {
    color: "#C9973A",
    fontSize: 17,
    fontWeight: "bold",
    marginBottom: 2,
  },
  modSubtitle: { color: "rgba(240,217,160,0.7)", fontSize: 11 },
  modIcon: { fontSize: 32, opacity: 0.4, marginLeft: 8 },

  // barra compacta
  topBar: { marginBottom: 8 },
  searchRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
    marginBottom: 8,
  },
  searchInput: {
    flex: 1,
    backgroundColor: "white",
    borderWidth: 1.5,
    borderColor: "#e0d0b8",
    borderRadius: 8,
    paddingHorizontal: 12,
    height: 44,
    fontSize: 14,
  },
  btnClear: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    width: 40,
    height: 44,
    alignItems: "center",
    justifyContent: "center",
  },
  btnToggle: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    width: 44,
    height: 44,
    alignItems: "center",
    justifyContent: "center",
  },
  btnToggleActive: { backgroundColor: "#fdf6ec", borderColor: "#C9973A" },
  toggleDot: {
    position: "absolute",
    top: 6,
    right: 6,
    width: 7,
    height: 7,
    borderRadius: 4,
    backgroundColor: "#C9973A",
  },
  topActions: { flexDirection: "row", gap: 8 },
  btnFiltrar: {
    flex: 1,
    backgroundColor: "#C9973A",
    paddingVertical: 10,
    borderRadius: 8,
    alignItems: "center",
  },
  btnLimpiar: {
    flex: 1,
    backgroundColor: "white",
    borderWidth: 1.5,
    borderColor: "#e0d0b8",
    paddingVertical: 10,
    borderRadius: 8,
    alignItems: "center",
  },
  btnTextDark: { color: "#1a0e05", fontWeight: "bold" },
  btnTextGold: { color: "#C9973A", fontWeight: "bold" },

  // panel colapsable
  filterBar: {
    backgroundColor: "white",
    borderRadius: 12,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    padding: 14,
    marginBottom: 10,
  },
  label: {
    fontSize: 10,
    fontWeight: "bold",
    color: "#5C3A1E",
    textTransform: "uppercase",
    marginBottom: 4,
    letterSpacing: 0.5,
  },
  rowInputs: { flexDirection: "row", marginBottom: 12 },
  selectorInput: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1.5,
    borderColor: "#e0d0b8",
    borderRadius: 8,
    paddingHorizontal: 12,
    height: 44,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  selectorText: { color: "#333", fontSize: 14 },
  selectorPlaceholder: { color: "#aaa", fontSize: 14 },
  selectorArrow: { color: "#888", fontSize: 12 },
  chkWrap: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1.5,
    borderColor: "#e0d0b8",
    borderRadius: 8,
    padding: 11,
    alignItems: "center",
  },
  chkWrapActive: { borderColor: "#276749", backgroundColor: "#f0fff4" },
  chkText: { fontSize: 14, fontWeight: "bold", color: "#888" },
  chkTextActive: { color: "#276749" },

  // contador
  contadorText: { fontSize: 12, color: "#888", marginBottom: 8, marginLeft: 2 },
  contadorBold: { color: "#5C3A1E", fontWeight: "bold" },
  filtroNote: { color: "#C9973A", fontStyle: "italic" },

  // *** clave para el scroll: flex:1 hace que la lista ocupe todo el espacio restante ***
  lista: { flex: 1 },

  // tarjeta
  card: {
    backgroundColor: "white",
    padding: 14,
    borderRadius: 12,
    marginBottom: 10,
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
    paddingVertical: 3,
    borderRadius: 12,
    fontSize: 11,
    fontWeight: "bold",
  },
  priceText: { fontSize: 17, fontWeight: "bold", color: "#276749" },
  productName: {
    fontSize: 15,
    color: "#333",
    fontWeight: "bold",
    marginBottom: 8,
  },
  detailsBox: {
    backgroundColor: "#fdf8f3",
    padding: 10,
    borderRadius: 8,
    marginBottom: 10,
  },
  detailText: { fontSize: 12, color: "#555", marginBottom: 3 },
  datesRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    borderTopWidth: 1,
    borderTopColor: "#f5ece0",
    paddingTop: 8,
  },
  dateLabel: { fontSize: 12, color: "#777" },
  dateVigente: { color: "#276749", fontWeight: "bold" },

  // empty
  emptyState: { alignItems: "center", marginTop: 40, paddingHorizontal: 24 },
  emptyEmoji: { fontSize: 44, marginBottom: 10 },
  emptyTitle: {
    fontSize: 15,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 6,
  },
  emptyText: {
    color: "#aaa",
    fontSize: 13,
    textAlign: "center",
    marginBottom: 16,
  },
  btnLimpiarEmpty: {
    borderWidth: 1,
    borderColor: "#e8d8c0",
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 8,
  },

  // modales
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    justifyContent: "center",
    padding: 24,
  },
  selectorContent: {
    backgroundColor: "white",
    padding: 20,
    borderRadius: 14,
    maxHeight: "60%",
  },
  modalTitle: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 14,
    textAlign: "center",
  },
  selectorItem: {
    paddingVertical: 13,
    borderBottomWidth: 1,
    borderBottomColor: "#f5ece0",
    alignItems: "center",
  },
  selectorItemSel: { backgroundColor: "#fdf6ec" },
  selectorItemText: { fontSize: 15, color: "#444" },
  selectorItemTextSel: { color: "#C9973A", fontWeight: "bold" },
  btnCancelSelector: {
    marginTop: 14,
    alignItems: "center",
    padding: 11,
    backgroundColor: "#fff5f5",
    borderRadius: 8,
  },
  btnTextRed: { color: "#e53e3e", fontWeight: "bold" },
});
