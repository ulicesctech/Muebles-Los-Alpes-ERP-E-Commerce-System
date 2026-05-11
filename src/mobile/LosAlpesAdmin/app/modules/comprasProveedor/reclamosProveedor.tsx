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
import DateTimePicker from "@react-native-community/datetimepicker";
import {
  actualizarComentariosReclamo,
  actualizarReclamo,
  cambiarEstadoReclamo,
  crearReclamo,
  eliminarReclamo,
  EstadoReclamo,
  getEstadosReclamo,
  getReclamosProveedor,
  ReclamoProveedor,
} from "../../../services/comprasProveedor/reclamosProveedor";
import {
  getOrdenesCompra,
  OrdenCompra,
} from "../../../services/comprasProveedor/ordenesCompra";

// ─────────────────────────────────────────────────────────────────────────────
// LÓGICA DE ESTADOS — espejo del paquete Oracle (sin hardcode de strings)
// El nivel lo calculamos con los datos que vienen del backend.
// ─────────────────────────────────────────────────────────────────────────────

/** Nivel numérico según el paquete Oracle:
 *  INICIADO=1, PENDIENTE=2, RESUELTO/RECHAZADO=3, desconocido=0 */
function nivelEstado(estado: string): number {
  switch (estado?.toUpperCase().trim()) {
    case "INICIADO":
      return 1;
    case "PENDIENTE":
      return 2;
    case "RESUELTO":
    case "RECHAZADO":
      return 3;
    default:
      return 0;
  }
}

/** Retorna true si el estado es de cierre (nivel 3) */
const esCierre = (estado: string) => nivelEstado(estado) === 3;

/** Estados válidos a los que se puede avanzar desde el estado actual.
 *  Filtra los que vengan del backend dejando solo los de nivel > actual.
 *  Excluye "TODOS" que es solo para filtro. */
function estadosDisponibles(
  estadoActual: string,
  todos: EstadoReclamo[],
): EstadoReclamo[] {
  const nivelActual = nivelEstado(estadoActual);
  return todos.filter(
    (e) => e.ESTADO !== "TODOS" && nivelEstado(e.ESTADO) > nivelActual,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// MENSAJES DE ERROR AMIGABLES
// ─────────────────────────────────────────────────────────────────────────────
function getMensajeError(e: any, contexto: string): string {
  const status = e?.status ?? e?.statusCode ?? e?.response?.status;
  const raw = (e?.message ?? "").toLowerCase();

  // Oracle ORA-20070: no se puede retroceder de estado
  if (
    raw.includes("ora-20070") ||
    raw.includes("no puede retroceder") ||
    raw.includes("no se puede cambiar al estado")
  ) {
    // Extraemos el mensaje limpio de Oracle si viene
    const match = e.message?.match(/no se puede cambiar.*$/i);
    if (match) return match[0].replace(/\.$/, "") + ".";
    return "Este reclamo ya tiene un estado más avanzado y no puede retroceder.";
  }
  if (raw.includes("ora-20")) {
    // Otros errores de aplicación Oracle — suelen traer mensaje legible
    const match = e.message?.match(/ORA-20\d+:\s*(.+)/i);
    if (match) return match[1].replace(/\.$/, "") + ".";
  }
  if (status === 400 || raw.includes("400"))
    return `Datos inválidos al ${contexto}. Revisá los campos.`;
  if (status === 401 || raw.includes("unauthorized"))
    return "Tu sesión expiró. Cerrá sesión e ingresá de nuevo.";
  if (status === 403 || raw.includes("forbidden"))
    return "No tenés permiso para realizar esta acción.";
  if (status === 404 || raw.includes("not found"))
    return "El reclamo no fue encontrado. Es posible que ya haya sido eliminado.";
  if (status === 500 || raw.includes("500"))
    return "Error en el servidor. Intentá más tarde o contactá a soporte.";
  if (
    raw.includes("network") ||
    raw.includes("fetch") ||
    raw.includes("timeout")
  )
    return "Sin conexión. Verificá tu red e intentá nuevamente.";
  if (e?.message && e.message.length < 150) return e.message;
  return `No se pudo ${contexto}. Intentá de nuevo.`;
}

// ─────────────────────────────────────────────────────────────────────────────
type PanelMode = "principal" | "cambiarEstado" | "editarComentarios";

export default function ReclamosProveedorScreen() {
  // ── data ──
  const [reclamos, setReclamos] = useState<ReclamoProveedor[]>([]);
  const [estados, setEstados] = useState<EstadoReclamo[]>([]);
  const [ordenes, setOrdenes] = useState<OrdenCompra[]>([]);
  const [loading, setLoading] = useState(false);

  // ── filtros (pendientes de aplicar) ──
  const [searchInput, setSearchInput] = useState("");
  const [filtroEstadoInput, setFiltroEstadoInput] = useState("TODOS");
  const [fechaDesdeInput, setFechaDesdeInput] = useState<Date | null>(null);
  const [fechaHastaInput, setFechaHastaInput] = useState<Date | null>(null);

  // ── filtros aplicados (solo cambian al presionar Buscar) ──
  const [searchActivo, setSearchActivo] = useState("");
  const [filtroEstadoActivo, setFiltroEstadoActivo] = useState("TODOS");
  const [fechaDesdeActivo, setFechaDesdeActivo] = useState<Date | null>(null);
  const [fechaHastaActivo, setFechaHastaActivo] = useState<Date | null>(null);

  const [showDesde, setShowDesde] = useState(false);
  const [showHasta, setShowHasta] = useState(false);

  // ── modal ──
  const [modalVisible, setModalVisible] = useState(false);
  const [panelMode, setPanelMode] = useState<PanelMode>("principal");
  const [modo, setModo] = useState<"nuevo" | "editar">("nuevo");
  const [currentId, setCurrentId] = useState<number>(0);
  const [estadoActualReclamo, setEstadoActualReclamo] = useState("");

  // ── form ──
  const [ordenSel, setOrdenSel] = useState("");
  const [descripcion, setDescripcion] = useState("");
  const [showOrdenes, setShowOrdenes] = useState(false);
  const [ordenEnabled, setOrdenEnabled] = useState(true);
  const [estadoSel, setEstadoSel] = useState("");
  const [comentariosCierre, setComentariosCierre] = useState("");
  const [comentariosEditar, setComentariosEditar] = useState("");
  const [filtrosExpandido, setFiltrosExpandido] = useState(false);

  // ─── carga inicial ─────────────────────────────────────────────────────────
  useEffect(() => {
    cargar();
    cargarEstados();
    cargarOrdenes();
  }, []);

  const cargar = async () => {
    setLoading(true);
    try {
      setReclamos(await getReclamosProveedor());
    } catch (e: any) {
      Alert.alert("Error al cargar", getMensajeError(e, "cargar los reclamos"));
    } finally {
      setLoading(false);
    }
  };

  const cargarEstados = async () => {
    try {
      setEstados(await getEstadosReclamo());
    } catch {}
  };

  const cargarOrdenes = async () => {
    try {
      setOrdenes(await getOrdenesCompra());
    } catch {}
  };

  // ─── fechas ────────────────────────────────────────────────────────────────
  const formatDate = (date: Date | null) => {
    if (!date) return "";
    const d = String(date.getDate()).padStart(2, "0");
    const m = String(date.getMonth() + 1).padStart(2, "0");
    return `${d}/${m}/${date.getFullYear()}`;
  };

  const parseFecha = (fecha: string): Date | null => {
    try {
      if (!fecha) return null;
      const direct = new Date(fecha);
      if (!isNaN(direct.getTime())) return direct;
      const clean = fecha.split(" ")[0];
      if (clean.includes("-")) {
        const [y, m, d] = clean.split("-");
        return new Date(Number(y), Number(m) - 1, Number(d));
      }
      if (clean.includes("/")) {
        const [d, m, y] = clean.split("/");
        return new Date(Number(y), Number(m) - 1, Number(d));
      }
      return null;
    } catch {
      return null;
    }
  };

  // ─── aplicar / limpiar filtros ─────────────────────────────────────────────
  const aplicarFiltros = () => {
    setSearchActivo(searchInput.trim());
    setFiltroEstadoActivo(filtroEstadoInput);
    setFechaDesdeActivo(fechaDesdeInput);
    setFechaHastaActivo(fechaHastaInput);
  };

  const limpiarFiltros = () => {
    setSearchInput("");
    setFiltroEstadoInput("TODOS");
    setFechaDesdeInput(null);
    setFechaHastaInput(null);
    setSearchActivo("");
    setFiltroEstadoActivo("TODOS");
    setFechaDesdeActivo(null);
    setFechaHastaActivo(null);
  };

  const hayFiltrosActivos =
    searchActivo !== "" ||
    filtroEstadoActivo !== "TODOS" ||
    fechaDesdeActivo !== null ||
    fechaHastaActivo !== null;

  // ─── filtrado local (sobre los datos ya cargados) ──────────────────────────
  const reclamosFiltrados = useMemo(() => {
    return reclamos.filter((item) => {
      const texto = searchActivo.toLowerCase();
      const coincideTexto =
        texto === "" ||
        item.REP_DESCRIPCION?.toLowerCase().includes(texto) ||
        item.REP_COMENTARIOS?.toLowerCase().includes(texto) ||
        item.REP_ESTADO?.toLowerCase().includes(texto) ||
        item.ORC_ORDEN_COMPRA?.toLowerCase().includes(texto);

      const coincideEstado =
        filtroEstadoActivo === "" ||
        filtroEstadoActivo === "TODOS" ||
        item.REP_ESTADO === filtroEstadoActivo;

      let coincideFecha = true;
      const fechaReclamo = parseFecha(item.REP_FECHA_INICIO);
      if (fechaReclamo) {
        if (fechaDesdeActivo && fechaReclamo < fechaDesdeActivo)
          coincideFecha = false;
        if (fechaHastaActivo) {
          const hasta = new Date(fechaHastaActivo);
          hasta.setHours(23, 59, 59, 999);
          if (fechaReclamo > hasta) coincideFecha = false;
        }
      }
      return coincideTexto && coincideEstado && coincideFecha;
    });
  }, [
    reclamos,
    searchActivo,
    filtroEstadoActivo,
    fechaDesdeActivo,
    fechaHastaActivo,
  ]);

  // ─── helpers de estado ─────────────────────────────────────────────────────
  /** Qué puede hacer el usuario sobre un reclamo según su estado */
  const permisosReclamo = (item: ReclamoProveedor) => {
    const nivel = nivelEstado(item.REP_ESTADO);
    return {
      puedeEditarDescripcion: nivel < 3, // INICIADO o PENDIENTE
      puedeEditarComentarios: nivel === 3, // RESUELTO o RECHAZADO
      puedeCambiarEstado: nivel < 3, // aún tiene estados disponibles
      puedeEliminar: true, // siempre
    };
  };

  // ─── acciones del formulario ───────────────────────────────────────────────
  const limpiarFormulario = () => {
    setCurrentId(0);
    setModo("nuevo");
    setOrdenSel("");
    setDescripcion("");
    setOrdenEnabled(true);
    setEstadoSel("");
    setComentariosCierre("");
    setComentariosEditar("");
    setEstadoActualReclamo("");
    setPanelMode("principal");
    setShowOrdenes(false);
    setModalVisible(false);
  };

  const handleGuardar = async () => {
    if (modo === "nuevo" && !ordenSel) {
      Alert.alert("Campo requerido", "Debe seleccionar una orden de compra.");
      return;
    }
    if (!descripcion.trim()) {
      Alert.alert(
        "Campo requerido",
        "Debe ingresar la descripción del reclamo.",
      );
      return;
    }
    try {
      setLoading(true);
      if (modo === "nuevo") {
        await crearReclamo(ordenSel, descripcion.trim());
        Alert.alert(
          "✅ Reclamo creado",
          "El reclamo fue registrado exitosamente.",
        );
      } else {
        await actualizarReclamo(currentId, descripcion.trim());
        Alert.alert(
          "✅ Reclamo actualizado",
          "La descripción fue guardada correctamente.",
        );
      }
      limpiarFormulario();
      cargar();
    } catch (e: any) {
      const accion =
        modo === "nuevo" ? "crear el reclamo" : "actualizar el reclamo";
      Alert.alert("No se pudo guardar", getMensajeError(e, accion));
    } finally {
      setLoading(false);
    }
  };

  const handleGuardarComentarios = async () => {
    if (!comentariosEditar.trim()) {
      Alert.alert("Campo requerido", "Debe ingresar los comentarios.");
      return;
    }
    try {
      setLoading(true);
      await actualizarComentariosReclamo(currentId, comentariosEditar.trim());
      Alert.alert(
        "✅ Comentarios guardados",
        "Los comentarios fueron actualizados correctamente.",
      );
      limpiarFormulario();
      cargar();
    } catch (e: any) {
      Alert.alert(
        "No se pudo guardar",
        getMensajeError(e, "actualizar los comentarios"),
      );
    } finally {
      setLoading(false);
    }
  };

  const handleCambiarEstado = async () => {
    if (!estadoSel) {
      Alert.alert("Campo requerido", "Debe seleccionar un estado.");
      return;
    }
    // Validación client-side espejo de Oracle: no retroceder
    if (nivelEstado(estadoSel) <= nivelEstado(estadoActualReclamo)) {
      Alert.alert(
        "Estado no permitido",
        `El reclamo ya está en "${estadoActualReclamo}" y no puede cambiar a "${estadoSel}". Los estados solo avanzan.`,
      );
      return;
    }
    // Si es cierre, comentarios obligatorios (Oracle los guarda en fecha_final también)
    if (esCierre(estadoSel) && !comentariosCierre.trim()) {
      Alert.alert(
        "Campo requerido",
        "Para cerrar el reclamo debe ingresar comentarios.",
      );
      return;
    }
    try {
      setLoading(true);
      await cambiarEstadoReclamo(
        currentId,
        estadoSel,
        comentariosCierre.trim(),
      );
      Alert.alert(
        "✅ Estado actualizado",
        `El reclamo pasó a estado "${estadoSel}".`,
      );
      limpiarFormulario();
      cargar();
    } catch (e: any) {
      Alert.alert(
        "No se pudo cambiar el estado",
        getMensajeError(e, "cambiar el estado"),
      );
    } finally {
      setLoading(false);
    }
  };

  const handleEliminar = (id: number) => {
    Alert.alert(
      "Eliminar reclamo",
      "¿Estás seguro de que querés eliminar este reclamo? Esta acción no se puede deshacer.",
      [
        { text: "Cancelar", style: "cancel" },
        {
          text: "Sí, eliminar",
          style: "destructive",
          onPress: async () => {
            try {
              setLoading(true);
              await eliminarReclamo(id);
              Alert.alert(
                "🗑 Eliminado",
                "El reclamo fue eliminado correctamente.",
              );
              cargar();
            } catch (e: any) {
              Alert.alert(
                "No se pudo eliminar",
                getMensajeError(e, "eliminar el reclamo"),
              );
            } finally {
              setLoading(false);
            }
          },
        },
      ],
    );
  };

  // ─── abrir modales ─────────────────────────────────────────────────────────
  const abrirNuevo = () => {
    limpiarFormulario();
    setModo("nuevo");
    setModalVisible(true);
  };

  const abrirEditar = (item: ReclamoProveedor) => {
    limpiarFormulario();
    setModo("editar");
    setCurrentId(item.REP_RECLAMO_PROVEEDOR);
    setDescripcion(item.REP_DESCRIPCION ?? "");
    setOrdenSel(item.ORC_ORDEN_COMPRA);
    setOrdenEnabled(false);
    setEstadoActualReclamo(item.REP_ESTADO ?? "");
    setPanelMode("principal");
    setModalVisible(true);
  };

  const abrirComentarios = (item: ReclamoProveedor) => {
    limpiarFormulario();
    setCurrentId(item.REP_RECLAMO_PROVEEDOR);
    setComentariosEditar(item.REP_COMENTARIOS ?? "");
    setEstadoActualReclamo(item.REP_ESTADO ?? "");
    setPanelMode("editarComentarios");
    setModalVisible(true);
  };

  const abrirEstado = (item: ReclamoProveedor) => {
    limpiarFormulario();
    setCurrentId(item.REP_RECLAMO_PROVEEDOR);
    setEstadoActualReclamo(item.REP_ESTADO ?? "");
    // Pre-seleccionar el estado actual para que el usuario vea dónde está
    setEstadoSel("");
    setPanelMode("cambiarEstado");
    setModalVisible(true);
  };

  // ─── badge de color por estado ─────────────────────────────────────────────
  const colorEstado = (estado: string) => {
    switch (estado?.toUpperCase()) {
      case "INICIADO":
        return { bg: "#eff6ff", text: "#2563eb" };
      case "PENDIENTE":
        return { bg: "#fefce8", text: "#ca8a04" };
      case "RESUELTO":
        return { bg: "#f0fdf4", text: "#16a34a" };
      case "RECHAZADO":
        return { bg: "#fff5f5", text: "#dc2626" };
      default:
        return { bg: "#f0f0f0", text: "#555" };
    }
  };

  // ─── render item ───────────────────────────────────────────────────────────
  const renderItem = ({ item }: { item: ReclamoProveedor }) => {
    const perms = permisosReclamo(item);
    const colores = colorEstado(item.REP_ESTADO);

    return (
      <View style={styles.card}>
        <View style={styles.cardInfo}>
          <View style={styles.cardRow}>
            <Text style={styles.badgeOrden}>
              Orden: {item.ORC_ORDEN_COMPRA}
            </Text>
            <View style={[styles.estadoBadge, { backgroundColor: colores.bg }]}>
              <Text style={[styles.estadoText, { color: colores.text }]}>
                {item.REP_ESTADO}
              </Text>
            </View>
          </View>

          <Text style={styles.cardTitle}>📋 {item.REP_DESCRIPCION}</Text>
          <Text style={styles.cardSub}>
            📅 Inicio: {formatDate(parseFecha(item.REP_FECHA_INICIO))}
          </Text>
          {item.REP_FECHA_FINAL ? (
            <Text style={styles.cardSub}>
              🏁 Fin: {formatDate(parseFecha(item.REP_FECHA_FINAL))}
            </Text>
          ) : null}
          {item.REP_COMENTARIOS ? (
            <Text style={styles.cardSub}>💬 {item.REP_COMENTARIOS}</Text>
          ) : null}
        </View>

        <View style={styles.actionsCol}>
          {/* Editar descripción: solo INICIADO / PENDIENTE */}
          {perms.puedeEditarDescripcion && (
            <TouchableOpacity
              style={styles.btnEdit}
              onPress={() => abrirEditar(item)}
            >
              <Text style={styles.btnTextGold}>✏️</Text>
            </TouchableOpacity>
          )}

          {/* Cambiar estado: solo si quedan estados disponibles */}
          {perms.puedeCambiarEstado && (
            <TouchableOpacity
              style={styles.btnStatus}
              onPress={() => abrirEstado(item)}
            >
              <Text style={{ fontSize: 14 }}>🔄</Text>
            </TouchableOpacity>
          )}

          {/* Editar comentarios: solo RESUELTO / RECHAZADO */}
          {perms.puedeEditarComentarios && (
            <TouchableOpacity
              style={styles.btnComent}
              onPress={() => abrirComentarios(item)}
            >
              <Text style={{ fontSize: 14 }}>💬</Text>
            </TouchableOpacity>
          )}

          {/* Eliminar: siempre */}
          <TouchableOpacity
            style={styles.btnDelete}
            onPress={() => handleEliminar(item.REP_RECLAMO_PROVEEDOR)}
          >
            <Text style={styles.btnTextRed}>🗑</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  };

  // ─────────────────────────────────────────────────────────────────────────────
  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        {/* ══ BUSCADOR + CONTROLES — FUERA del FlatList para que el teclado no se cierre ══ */}
        <View style={styles.topBar}>
          {/* Fila 1: buscador + toggle filtros */}
          <View style={styles.searchRow}>
            <TextInput
              style={styles.searchInput}
              placeholder="Buscar descripción, orden..."
              value={searchInput}
              onChangeText={setSearchInput}
              returnKeyType="search"
              onSubmitEditing={aplicarFiltros}
              autoCorrect={false}
            />
            {searchInput.trim() !== "" && (
              <TouchableOpacity
                style={styles.btnClear}
                onPress={() => setSearchInput("")}
              >
                <Text style={styles.btnTextDark}>✕</Text>
              </TouchableOpacity>
            )}
            <TouchableOpacity
              style={[
                styles.btnToggleFiltros,
                filtrosExpandido && styles.btnToggleFiltrosActive,
              ]}
              onPress={() => setFiltrosExpandido((v) => !v)}
            >
              <Text style={{ fontSize: 16 }}>⚙️</Text>
              {hayFiltrosActivos && <View style={styles.filtrosDot} />}
            </TouchableOpacity>
          </View>

          {/* Fila 2: Buscar + Nuevo */}
          <View style={styles.topActions}>
            <TouchableOpacity
              style={styles.btnBuscar}
              onPress={aplicarFiltros}
              disabled={loading}
            >
              {loading ? (
                <ActivityIndicator size="small" color="white" />
              ) : (
                <Text style={styles.btnTextWhite}>🔍 Buscar</Text>
              )}
            </TouchableOpacity>
            <TouchableOpacity style={styles.btnAdd} onPress={abrirNuevo}>
              <Text style={styles.btnTextWhite}>＋ Nuevo</Text>
            </TouchableOpacity>
          </View>

          {/* Panel de filtros colapsable */}
          {filtrosExpandido && (
            <View style={styles.filterCard}>
              <Text style={styles.labelFilter}>ESTADO</Text>
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                style={{ marginBottom: 12 }}
                keyboardShouldPersistTaps="handled"
              >
                {estados.map((e) => (
                  <TouchableOpacity
                    key={e.ESTADO}
                    style={[
                      styles.chipEstado,
                      filtroEstadoInput === e.ESTADO && styles.chipEstadoSel,
                    ]}
                    onPress={() => setFiltroEstadoInput(e.ESTADO)}
                  >
                    <Text
                      style={{
                        color:
                          filtroEstadoInput === e.ESTADO ? "white" : "#5C3A1E",
                        fontWeight: "bold",
                        fontSize: 12,
                      }}
                    >
                      {e.DESCRIPCION ?? e.ESTADO}
                    </Text>
                  </TouchableOpacity>
                ))}
              </ScrollView>

              <View style={styles.fechasRow}>
                <View style={{ flex: 1 }}>
                  <Text style={styles.labelFilter}>DESDE</Text>
                  <TouchableOpacity
                    style={styles.dateBtn}
                    onPress={() => setShowDesde(true)}
                  >
                    <Text
                      style={[
                        styles.dateText,
                        !fechaDesdeInput && { color: "#aaa" },
                      ]}
                    >
                      {fechaDesdeInput
                        ? formatDate(fechaDesdeInput)
                        : "dd/mm/aaaa"}
                    </Text>
                  </TouchableOpacity>
                </View>
                <View style={{ flex: 1 }}>
                  <Text style={styles.labelFilter}>HASTA</Text>
                  <TouchableOpacity
                    style={styles.dateBtn}
                    onPress={() => setShowHasta(true)}
                  >
                    <Text
                      style={[
                        styles.dateText,
                        !fechaHastaInput && { color: "#aaa" },
                      ]}
                    >
                      {fechaHastaInput
                        ? formatDate(fechaHastaInput)
                        : "dd/mm/aaaa"}
                    </Text>
                  </TouchableOpacity>
                </View>
              </View>

              {hayFiltrosActivos && (
                <TouchableOpacity
                  style={styles.btnLimpiar}
                  onPress={limpiarFiltros}
                >
                  <Text style={styles.btnTextDark}>✕ Limpiar filtros</Text>
                </TouchableOpacity>
              )}
            </View>
          )}

          {/* Indicador de filtros activos */}
          {hayFiltrosActivos && (
            <Text style={styles.filtroActivoNote}>
              ● {reclamosFiltrados.length} resultado
              {reclamosFiltrados.length !== 1 ? "s" : ""} con filtros activos
            </Text>
          )}
        </View>

        {/* ══ LISTA — ocupa todo el espacio restante ══ */}
        <FlatList
          data={reclamosFiltrados}
          keyExtractor={(item, index) =>
            (item.REP_RECLAMO_PROVEEDOR ?? index).toString()
          }
          renderItem={renderItem}
          keyboardShouldPersistTaps="handled"
          contentContainerStyle={{ paddingBottom: 24 }}
          ListEmptyComponent={
            loading ? (
              <ActivityIndicator
                size="large"
                color="#C9973A"
                style={{ marginTop: 30 }}
              />
            ) : hayFiltrosActivos ? (
              <View style={styles.emptyContainer}>
                <Text style={styles.emptyIcon}>🔍</Text>
                <Text style={styles.emptyTitle}>Sin resultados</Text>
                <Text style={styles.emptyText}>
                  No se encontraron reclamos con los filtros aplicados.{"\n"}
                  Probá cambiando la búsqueda o el estado.
                </Text>
                <TouchableOpacity
                  style={styles.btnLimpiarEmpty}
                  onPress={limpiarFiltros}
                >
                  <Text style={styles.btnTextDark}>Limpiar filtros</Text>
                </TouchableOpacity>
              </View>
            ) : (
              <View style={styles.emptyContainer}>
                <Text style={styles.emptyIcon}>📋</Text>
                <Text style={styles.emptyTitle}>Sin reclamos</Text>
                <Text style={styles.emptyText}>
                  No hay reclamos registrados.{"\n"}
                  Tocá "+ Nuevo" para agregar uno.
                </Text>
              </View>
            )
          }
        />

        {/* ══ DATE PICKERS ══ */}
        {showDesde && (
          <DateTimePicker
            value={fechaDesdeInput || new Date()}
            mode="date"
            display="default"
            onChange={(_, date) => {
              setShowDesde(false);
              if (date) setFechaDesdeInput(date);
            }}
          />
        )}
        {showHasta && (
          <DateTimePicker
            value={fechaHastaInput || new Date()}
            mode="date"
            display="default"
            onChange={(_, date) => {
              setShowHasta(false);
              if (date) setFechaHastaInput(date);
            }}
          />
        )}

        {/* ══ MODAL ══ */}
        <Modal visible={modalVisible} animationType="slide" transparent>
          <View style={styles.modalOverlay}>
            <View style={styles.modalContent}>
              {/* ── Panel principal: crear / editar descripción ── */}
              {panelMode === "principal" && (
                <ScrollView keyboardShouldPersistTaps="handled">
                  <Text style={styles.modalTitle}>
                    {modo === "nuevo"
                      ? "Nuevo Reclamo"
                      : `Editar Reclamo #${currentId}`}
                  </Text>
                  {modo === "editar" && estadoActualReclamo !== "" && (
                    <View
                      style={[
                        styles.estadoInfoBanner,
                        {
                          backgroundColor: colorEstado(estadoActualReclamo).bg,
                        },
                      ]}
                    >
                      <Text
                        style={[
                          styles.estadoInfoText,
                          { color: colorEstado(estadoActualReclamo).text },
                        ]}
                      >
                        Estado actual: {estadoActualReclamo}
                      </Text>
                    </View>
                  )}
                  <Text style={styles.label}>Orden de Compra *</Text>
                  {ordenEnabled ? (
                    <>
                      <TouchableOpacity
                        style={styles.selector}
                        onPress={() => setShowOrdenes(!showOrdenes)}
                      >
                        <Text style={{ color: ordenSel ? "#333" : "#aaa" }}>
                          {ordenSel
                            ? (ordenes.find((o) => o.ORC_KEY === ordenSel)
                                ?.CODIGO ?? ordenSel)
                            : "— Seleccione una orden —"}
                        </Text>
                        <Text>▼</Text>
                      </TouchableOpacity>
                      {showOrdenes && (
                        <ScrollView
                          style={[styles.dropdownList, { maxHeight: 150 }]}
                          nestedScrollEnabled
                        >
                          {ordenes.map((o) => (
                            <TouchableOpacity
                              key={o.ORC_KEY}
                              style={styles.dropdownItem}
                              onPress={() => {
                                setOrdenSel(o.ORC_KEY);
                                setShowOrdenes(false);
                              }}
                            >
                              <Text style={{ fontWeight: "bold" }}>
                                {o.CODIGO}
                              </Text>
                              <Text style={{ color: "#888", fontSize: 11 }}>
                                {o.PROVEEDOR}
                              </Text>
                            </TouchableOpacity>
                          ))}
                        </ScrollView>
                      )}
                    </>
                  ) : (
                    <View style={styles.readonlyField}>
                      <Text style={styles.readonlyVal}>{ordenSel}</Text>
                    </View>
                  )}
                  <Text style={styles.label}>Descripción *</Text>
                  <TextInput
                    style={[
                      styles.input,
                      { height: 100, textAlignVertical: "top" },
                    ]}
                    multiline
                    value={descripcion}
                    onChangeText={setDescripcion}
                    placeholder="Describa el problema o reclamo..."
                  />
                  <View style={styles.modalActions}>
                    <TouchableOpacity
                      style={styles.btnCancel}
                      onPress={limpiarFormulario}
                    >
                      <Text style={styles.btnTextDark}>Cancelar</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                      style={[styles.btnSave, loading && { opacity: 0.7 }]}
                      onPress={handleGuardar}
                      disabled={loading}
                    >
                      {loading ? (
                        <ActivityIndicator size="small" color="white" />
                      ) : (
                        <Text style={styles.btnTextWhite}>💾 Guardar</Text>
                      )}
                    </TouchableOpacity>
                  </View>
                </ScrollView>
              )}

              {/* ── Panel comentarios (solo RESUELTO / RECHAZADO) ── */}
              {panelMode === "editarComentarios" && (
                <ScrollView keyboardShouldPersistTaps="handled">
                  <Text style={styles.modalTitle}>Comentarios del Reclamo</Text>
                  <View
                    style={[
                      styles.estadoInfoBanner,
                      { backgroundColor: colorEstado(estadoActualReclamo).bg },
                    ]}
                  >
                    <Text
                      style={[
                        styles.estadoInfoText,
                        { color: colorEstado(estadoActualReclamo).text },
                      ]}
                    >
                      Estado: {estadoActualReclamo} — solo los comentarios son
                      editables.
                    </Text>
                  </View>
                  <Text style={styles.label}>Comentarios</Text>
                  <TextInput
                    style={[
                      styles.input,
                      { height: 120, textAlignVertical: "top" },
                    ]}
                    multiline
                    value={comentariosEditar}
                    onChangeText={setComentariosEditar}
                    placeholder="Escribí los comentarios del cierre..."
                  />
                  <View style={styles.modalActions}>
                    <TouchableOpacity
                      style={styles.btnCancel}
                      onPress={limpiarFormulario}
                    >
                      <Text style={styles.btnTextDark}>Cancelar</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                      style={[styles.btnSave, loading && { opacity: 0.7 }]}
                      onPress={handleGuardarComentarios}
                      disabled={loading}
                    >
                      {loading ? (
                        <ActivityIndicator size="small" color="white" />
                      ) : (
                        <Text style={styles.btnTextWhite}>💾 Guardar</Text>
                      )}
                    </TouchableOpacity>
                  </View>
                </ScrollView>
              )}

              {/* ── Panel cambiar estado ── */}
              {panelMode === "cambiarEstado" && (
                <ScrollView keyboardShouldPersistTaps="handled">
                  <Text style={styles.modalTitle}>Cambiar Estado</Text>
                  <View
                    style={[
                      styles.estadoInfoBanner,
                      { backgroundColor: colorEstado(estadoActualReclamo).bg },
                    ]}
                  >
                    <Text
                      style={[
                        styles.estadoInfoText,
                        { color: colorEstado(estadoActualReclamo).text },
                      ]}
                    >
                      Estado actual: {estadoActualReclamo}
                    </Text>
                  </View>
                  <Text style={styles.label}>AVANZAR A</Text>
                  {estadosDisponibles(estadoActualReclamo, estados).length ===
                  0 ? (
                    <View style={styles.noEstadosBanner}>
                      <Text style={styles.noEstadosText}>
                        ℹ️ Este reclamo ya está en su estado final y no puede
                        avanzar más.
                      </Text>
                    </View>
                  ) : (
                    <ScrollView
                      horizontal
                      showsHorizontalScrollIndicator={false}
                      style={{ marginBottom: 12 }}
                    >
                      {estadosDisponibles(estadoActualReclamo, estados).map(
                        (e) => (
                          <TouchableOpacity
                            key={e.ESTADO}
                            style={[
                              styles.chipEstado,
                              estadoSel === e.ESTADO && styles.chipEstadoSel,
                            ]}
                            onPress={() => setEstadoSel(e.ESTADO)}
                          >
                            <Text
                              style={{
                                color:
                                  estadoSel === e.ESTADO ? "white" : "#5C3A1E",
                                fontWeight: "bold",
                              }}
                            >
                              {e.DESCRIPCION ?? e.ESTADO}
                            </Text>
                          </TouchableOpacity>
                        ),
                      )}
                    </ScrollView>
                  )}
                  {estadoSel !== "" && esCierre(estadoSel) && (
                    <>
                      <Text style={styles.label}>
                        Comentarios de cierre *{" "}
                        <Text
                          style={{
                            color: "#888",
                            fontWeight: "normal",
                            textTransform: "none",
                          }}
                        >
                          (obligatorio para {estadoSel})
                        </Text>
                      </Text>
                      <TextInput
                        style={[
                          styles.input,
                          { height: 100, textAlignVertical: "top" },
                        ]}
                        multiline
                        value={comentariosCierre}
                        onChangeText={setComentariosCierre}
                        placeholder={`Explique por qué el reclamo queda como ${estadoSel}...`}
                      />
                    </>
                  )}
                  <View style={styles.modalActions}>
                    <TouchableOpacity
                      style={styles.btnCancel}
                      onPress={limpiarFormulario}
                    >
                      <Text style={styles.btnTextDark}>Cancelar</Text>
                    </TouchableOpacity>
                    {estadosDisponibles(estadoActualReclamo, estados).length >
                      0 && (
                      <TouchableOpacity
                        style={[
                          styles.btnSave,
                          (!estadoSel || loading) && { opacity: 0.5 },
                        ]}
                        onPress={handleCambiarEstado}
                        disabled={!estadoSel || loading}
                      >
                        {loading ? (
                          <ActivityIndicator size="small" color="white" />
                        ) : (
                          <Text style={styles.btnTextWhite}>🔄 Actualizar</Text>
                        )}
                      </TouchableOpacity>
                    )}
                  </View>
                </ScrollView>
              )}
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

  // barra superior compacta
  topBar: { marginBottom: 10 },
  searchRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
    marginBottom: 8,
  },
  searchInput: {
    flex: 1,
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    paddingHorizontal: 12,
    height: 44,
    fontSize: 15,
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
  btnToggleFiltros: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    width: 44,
    height: 44,
    alignItems: "center",
    justifyContent: "center",
  },
  btnToggleFiltrosActive: {
    backgroundColor: "#fdf6ec",
    borderColor: "#C9973A",
  },
  filtrosDot: {
    position: "absolute",
    top: 6,
    right: 6,
    width: 7,
    height: 7,
    borderRadius: 4,
    backgroundColor: "#C9973A",
  },
  topActions: { flexDirection: "row", gap: 8, marginBottom: 4 },
  btnBuscar: {
    flex: 1,
    backgroundColor: "#C9973A",
    paddingVertical: 10,
    borderRadius: 8,
    alignItems: "center",
  },
  btnAdd: {
    flex: 1,
    backgroundColor: "#5C3A1E",
    paddingVertical: 10,
    borderRadius: 8,
    alignItems: "center",
  },

  // panel de filtros colapsable
  filterCard: {
    backgroundColor: "white",
    borderRadius: 12,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    padding: 14,
    marginBottom: 10,
  },
  labelFilter: {
    fontSize: 10,
    color: "#5C3A1E",
    fontWeight: "bold",
    marginBottom: 6,
    letterSpacing: 0.5,
  },
  chipEstado: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    backgroundColor: "#fdf8f3",
    marginRight: 6,
  },
  chipEstadoSel: { backgroundColor: "#5C3A1E", borderColor: "#5C3A1E" },
  fechasRow: { flexDirection: "row", gap: 8, marginBottom: 12 },
  dateBtn: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    paddingHorizontal: 12,
    height: 44,
    justifyContent: "center",
  },
  dateText: { color: "#333", fontSize: 14 },
  btnLimpiar: {
    borderWidth: 1,
    borderColor: "#e8d8c0",
    paddingVertical: 9,
    borderRadius: 8,
    alignItems: "center",
  },
  filtroActivoNote: {
    fontSize: 11,
    color: "#C9973A",
    fontStyle: "italic",
    marginBottom: 8,
  },

  btnTextWhite: { color: "white", fontWeight: "bold" },
  btnTextDark: { color: "#5C3A1E", fontWeight: "bold" },

  // tarjeta
  card: {
    backgroundColor: "white",
    padding: 14,
    borderRadius: 12,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    flexDirection: "row",
  },
  cardInfo: { flex: 1 },
  cardRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 6,
  },
  badgeOrden: {
    backgroundColor: "#fdf6ec",
    color: "#C9973A",
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 12,
    fontSize: 11,
    fontWeight: "bold",
  },
  estadoBadge: { paddingHorizontal: 8, paddingVertical: 3, borderRadius: 12 },
  estadoText: { fontSize: 11, fontWeight: "bold" },
  cardTitle: {
    fontSize: 14,
    color: "#333",
    fontWeight: "bold",
    marginBottom: 4,
  },
  cardSub: { fontSize: 12, color: "#888", marginTop: 2 },
  actionsCol: { justifyContent: "center", gap: 8 },
  btnEdit: { backgroundColor: "#fdf6ec", padding: 10, borderRadius: 8 },
  btnStatus: { backgroundColor: "#eff6ff", padding: 10, borderRadius: 8 },
  btnComent: { backgroundColor: "#f5f3ff", padding: 10, borderRadius: 8 },
  btnDelete: { backgroundColor: "#fff5f5", padding: 10, borderRadius: 8 },
  btnTextGold: { color: "#C9973A", fontSize: 15 },
  btnTextRed: { color: "#e53e3e", fontSize: 15 },

  // empty state
  emptyContainer: {
    alignItems: "center",
    marginTop: 40,
    paddingHorizontal: 24,
  },
  emptyIcon: { fontSize: 40, marginBottom: 12 },
  emptyTitle: {
    fontSize: 15,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 6,
  },
  emptyText: {
    textAlign: "center",
    color: "#aaa",
    lineHeight: 20,
    marginBottom: 16,
  },
  btnLimpiarEmpty: {
    borderWidth: 1,
    borderColor: "#e8d8c0",
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 8,
  },

  // modal
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    justifyContent: "flex-end",
  },
  modalContent: {
    backgroundColor: "white",
    padding: 20,
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    maxHeight: "90%",
  },
  modalTitle: {
    fontSize: 17,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 14,
  },
  label: {
    fontSize: 11,
    color: "#5C3A1E",
    fontWeight: "bold",
    marginBottom: 4,
    textTransform: "uppercase",
  },
  estadoInfoBanner: { padding: 10, borderRadius: 8, marginBottom: 14 },
  estadoInfoText: { fontSize: 13, fontWeight: "bold" },
  noEstadosBanner: {
    backgroundColor: "#fdf6ec",
    borderRadius: 8,
    padding: 12,
    marginBottom: 14,
  },
  noEstadosText: { color: "#8B5E3C", fontSize: 13 },
  selector: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 12,
    marginBottom: 10,
    flexDirection: "row",
    justifyContent: "space-between",
  },
  dropdownList: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    marginBottom: 10,
  },
  dropdownItem: {
    padding: 12,
    borderBottomWidth: 1,
    borderBottomColor: "#f0e8dc",
  },
  input: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 12,
    marginBottom: 14,
  },
  readonlyField: { marginBottom: 12 },
  readonlyVal: {
    backgroundColor: "#f0f0f0",
    color: "#888",
    padding: 12,
    borderRadius: 8,
  },
  modalActions: {
    flexDirection: "row",
    justifyContent: "flex-end",
    gap: 10,
    marginTop: 4,
    paddingBottom: 8,
  },
  btnCancel: {
    padding: 10,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  btnSave: {
    backgroundColor: "#C9973A",
    padding: 10,
    borderRadius: 8,
    minWidth: 110,
    alignItems: "center",
  },
});
