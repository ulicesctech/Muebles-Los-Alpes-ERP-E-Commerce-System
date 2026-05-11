import React, { useCallback, useEffect, useRef, useState } from "react";
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
  actualizarProveedor,
  buscarProveedores,
  crearProveedor,
  eliminarProveedor,
  getProveedores,
  Proveedor,
  validarNit,
  validarTelefono,
} from "../../../services/comprasProveedor/proveedores";

const DEBOUNCE_MS = 400;

// ─────────────────────────────────────────────────────────────────────────────
// Mensajes de error amigables según código HTTP / texto del error
// ─────────────────────────────────────────────────────────────────────────────
function getMensajeError(e: any, contexto: string): string {
  const status = e?.status ?? e?.statusCode ?? e?.response?.status;
  const raw = (e?.message ?? "").toLowerCase();

  if (status === 400 || raw.includes("400")) {
    return `Datos inválidos al ${contexto}. Revisá los campos e intentá de nuevo.`;
  }
  if (status === 401 || raw.includes("401") || raw.includes("unauthorized")) {
    return "Tu sesión expiró. Cerrá sesión e ingresá nuevamente.";
  }
  if (status === 403 || raw.includes("403") || raw.includes("forbidden")) {
    return "No tenés permiso para realizar esta acción.";
  }
  if (status === 404 || raw.includes("404") || raw.includes("not found")) {
    return `El proveedor no fue encontrado. Es posible que ya haya sido eliminado.`;
  }
  if (
    status === 409 ||
    raw.includes("409") ||
    raw.includes("conflict") ||
    raw.includes("duplicate") ||
    raw.includes("ya existe")
  ) {
    return "Ya existe un proveedor con ese NIT o CUI. Verificá los datos.";
  }
  if (status === 422 || raw.includes("422") || raw.includes("unprocessable")) {
    return `Los datos enviados no son válidos. Revisá el formulario.`;
  }
  if (
    status === 500 ||
    raw.includes("500") ||
    raw.includes("internal server")
  ) {
    return "Ocurrió un error en el servidor. Intentá más tarde o contactá a soporte.";
  }
  if (status === 503 || raw.includes("503") || raw.includes("unavailable")) {
    return "El servicio no está disponible en este momento. Intentá en unos minutos.";
  }
  if (
    raw.includes("network") ||
    raw.includes("fetch") ||
    raw.includes("conexion") ||
    raw.includes("timeout")
  ) {
    return "Sin conexión a Internet. Verificá tu red e intentá nuevamente.";
  }
  // fallback: si viene un mensaje legible del backend, usarlo; sino genérico
  if (e?.message && e.message.length < 120 && !e.message.match(/^\d{3}/)) {
    return e.message;
  }
  return `No se pudo ${contexto}. Intentá de nuevo o contactá a soporte.`;
}

// ─────────────────────────────────────────────────────────────────────────────
export default function ProveedoresScreen() {
  const [proveedores, setProveedores] = useState<Proveedor[]>([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");
  const [modalVisible, setModalVisible] = useState(false);
  const [currentId, setCurrentId] = useState<number | null>(null);
  const [nitEditable, setNitEditable] = useState(true);
  const [form, setForm] = useState({
    nit: "",
    nombre: "",
    avenida: "",
    zona: "",
    direccion: "",
    telefono: "",
  });
  const [errors, setErrors] = useState<Partial<typeof form>>({});

  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    cargar();
  }, []);

  // ── debounce automático al escribir ──────────────────────────────────────
  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => {
      if (search.trim() === "") {
        cargar();
      } else {
        ejecutarBusqueda(search);
      }
    }, DEBOUNCE_MS);
    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
  }, [search]);

  const cargar = async () => {
    setLoading(true);
    try {
      setProveedores(await getProveedores());
    } catch (e: any) {
      Alert.alert(
        "Error al cargar",
        getMensajeError(e, "cargar los proveedores"),
      );
    } finally {
      setLoading(false);
    }
  };

  const ejecutarBusqueda = async (texto: string) => {
    if (!texto.trim()) return;
    setLoading(true);
    try {
      const resultado = await buscarProveedores(texto);
      setProveedores(resultado);
      if (resultado.length === 0) {
        // Feedback suave: no alert, el ListEmptyComponent lo maneja visualmente
      }
    } catch (e: any) {
      Alert.alert("Error al buscar", getMensajeError(e, "buscar proveedores"));
    } finally {
      setLoading(false);
    }
  };

  const validarForm = (): boolean => {
    const errs: Partial<typeof form> = {};

    if (!form.nit.trim()) {
      errs.nit = "El NIT o CUI es obligatorio.";
    } else if (!validarNit(form.nit)) {
      errs.nit =
        "Formato inválido. Acepta NIT sin guion (ej: 123456789 ó 12345678K) " +
        "o CUI de 13 dígitos (ej: 1234567890101).";
    }

    if (!form.nombre.trim())
      errs.nombre = "El nombre o razón social es obligatorio.";
    if (!form.avenida.trim()) errs.avenida = "La avenida es obligatoria.";
    if (!form.zona.trim()) errs.zona = "La zona es obligatoria.";
    if (!form.direccion.trim()) errs.direccion = "La dirección es obligatoria.";

    if (!form.telefono.trim()) {
      errs.telefono = "El teléfono es obligatorio.";
    } else if (!validarTelefono(form.telefono)) {
      errs.telefono =
        "Debe tener exactamente 8 dígitos numéricos (ej: 22223333).";
    }

    setErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleGuardar = async () => {
    if (!validarForm()) return;

    setLoading(true);
    try {
      if (currentId) {
        await actualizarProveedor(
          currentId,
          form.nit,
          form.nombre,
          form.avenida,
          form.zona,
          form.direccion,
          form.telefono,
        );
        Alert.alert(
          "✅ Actualizado",
          `Los datos de "${form.nombre}" fueron guardados correctamente.`,
        );
      } else {
        await crearProveedor(
          form.nit,
          form.nombre,
          form.avenida,
          form.zona,
          form.direccion,
          form.telefono,
        );
        Alert.alert(
          "✅ Proveedor creado",
          `"${form.nombre}" fue registrado exitosamente.`,
        );
      }
      cerrarModal();
      cargar();
    } catch (e: any) {
      const accion = currentId
        ? "actualizar el proveedor"
        : "crear el proveedor";
      Alert.alert("No se pudo guardar", getMensajeError(e, accion));
    } finally {
      setLoading(false);
    }
  };

  const handleEliminar = (id: number, nombre: string) => {
    Alert.alert(
      "Eliminar proveedor",
      `¿Estás seguro de que querés eliminar a "${nombre}"? Esta acción no se puede deshacer.`,
      [
        { text: "Cancelar", style: "cancel" },
        {
          text: "Sí, eliminar",
          style: "destructive",
          onPress: async () => {
            try {
              setLoading(true);
              await eliminarProveedor(id);
              Alert.alert(
                "🗑 Eliminado",
                `"${nombre}" fue eliminado correctamente.`,
              );
              cargar();
            } catch (e: any) {
              Alert.alert(
                "No se pudo eliminar",
                getMensajeError(e, "eliminar el proveedor"),
              );
              setLoading(false);
            }
          },
        },
      ],
    );
  };

  const abrirModal = (p?: Proveedor) => {
    setErrors({});
    if (p) {
      setCurrentId(p.PROV_PROVEEDOR);
      setNitEditable(false);
      setForm({
        nit: p.PROV_NIT,
        nombre: p.PROV_NOMBRE,
        avenida: p.PROV_AVENIDA,
        zona: p.PROV_ZONA,
        direccion: p.PROV_DIRECCION,
        telefono: p.PROV_TELEFONO,
      });
    } else {
      setCurrentId(null);
      setNitEditable(true);
      setForm({
        nit: "",
        nombre: "",
        avenida: "",
        zona: "",
        direccion: "",
        telefono: "",
      });
    }
    setModalVisible(true);
  };

  const cerrarModal = () => {
    setModalVisible(false);
    setCurrentId(null);
    setNitEditable(true);
    setErrors({});
  };

  const campos: {
    label: string;
    key: keyof typeof form;
    placeholder: string;
    editable: boolean;
    keyboardType?: "default" | "numeric" | "phone-pad";
  }[] = [
    {
      label: "NIT / CUI *",
      key: "nit",
      placeholder: "Ej: 123456789 ó 1234567890101",
      editable: nitEditable,
    },
    {
      label: "Nombre / Razón Social *",
      key: "nombre",
      placeholder: "Razón social",
      editable: true,
    },
    {
      label: "Teléfono *",
      key: "telefono",
      placeholder: "Ej: 22223333 (8 dígitos)",
      editable: true,
      keyboardType: "phone-pad",
    },
    {
      label: "Avenida *",
      key: "avenida",
      placeholder: "Ej: 6ta Avenida",
      editable: true,
    },
    {
      label: "Zona *",
      key: "zona",
      placeholder: "Ej: 10",
      editable: true,
      keyboardType: "numeric",
    },
    {
      label: "Dirección *",
      key: "direccion",
      placeholder: "Dirección completa",
      editable: true,
    },
  ];

  const renderItem = ({ item }: { item: Proveedor }) => (
    <View style={styles.card}>
      <View style={styles.cardInfo}>
        <Text style={styles.badgeId}>NIT: {item.PROV_NIT}</Text>
        <Text style={styles.cardTitle}>{item.PROV_NOMBRE}</Text>
        <Text style={styles.cardSub}>📞 {item.PROV_TELEFONO}</Text>
        <Text style={styles.cardSub}>
          📍 {item.PROV_AVENIDA}, Zona {item.PROV_ZONA} — {item.PROV_DIRECCION}
        </Text>
      </View>
      <View style={styles.actions}>
        <TouchableOpacity
          style={styles.btnEdit}
          onPress={() => abrirModal(item)}
        >
          <Text style={styles.btnTextGold}>✏️ Editar</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.btnDelete}
          onPress={() => handleEliminar(item.PROV_PROVEEDOR, item.PROV_NOMBRE)}
        >
          <Text style={styles.btnTextRed}>🗑 Eliminar</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        {/* ── BUSCADOR + BOTÓN BUSCAR — fuera del FlatList para que el teclado no se cierre ── */}
        <View style={styles.searchRow}>
          <TextInput
            style={styles.searchInput}
            placeholder="Buscar por nombre, NIT o teléfono..."
            value={search}
            onChangeText={setSearch}
            returnKeyType="search"
            onSubmitEditing={() => ejecutarBusqueda(search)}
          />
          {search.trim() !== "" && (
            <TouchableOpacity
              style={styles.btnClearInline}
              onPress={() => setSearch("")}
            >
              <Text style={styles.btnTextDark}>✕</Text>
            </TouchableOpacity>
          )}
          <TouchableOpacity
            style={styles.btnBuscar}
            onPress={() => ejecutarBusqueda(search)}
            disabled={loading}
          >
            {loading ? (
              <ActivityIndicator size="small" color="white" />
            ) : (
              <Text style={styles.btnTextWhite}>🔍</Text>
            )}
          </TouchableOpacity>
        </View>

        {/* ── BOTÓN NUEVO ── */}
        <TouchableOpacity style={styles.btnAdd} onPress={() => abrirModal()}>
          <Text style={styles.btnTextWhite}>+ Nuevo Proveedor</Text>
        </TouchableOpacity>

        {/* ── LISTA ── */}
        <FlatList
          data={proveedores}
          keyExtractor={(item) => item.PROV_PROVEEDOR.toString()}
          renderItem={renderItem}
          contentContainerStyle={{ paddingBottom: 20 }}
          keyboardShouldPersistTaps="handled"
          ListEmptyComponent={
            loading ? (
              <ActivityIndicator
                size="large"
                color="#C9973A"
                style={{ marginTop: 20 }}
              />
            ) : search.trim() !== "" ? (
              <View style={styles.emptyContainer}>
                <Text style={styles.emptyIcon}>🔍</Text>
                <Text style={styles.emptyTitle}>Sin resultados</Text>
                <Text style={styles.emptyText}>
                  No se encontró ningún proveedor para "{search}".{"\n"}
                  Probá con otro nombre, NIT o teléfono.
                </Text>
              </View>
            ) : (
              <View style={styles.emptyContainer}>
                <Text style={styles.emptyIcon}>📋</Text>
                <Text style={styles.emptyTitle}>Sin proveedores</Text>
                <Text style={styles.emptyText}>
                  Aún no hay proveedores registrados.{"\n"}
                  Tocá "+ Nuevo Proveedor" para agregar uno.
                </Text>
              </View>
            )
          }
        />

        {/* ── loading overlay cuando la lista ya tiene datos ── */}
        {loading && proveedores.length > 0 && (
          <ActivityIndicator
            size="small"
            color="#C9973A"
            style={styles.inlineLoader}
          />
        )}

        {/* ── Modal crear / editar ── */}
        <Modal visible={modalVisible} animationType="slide" transparent>
          <View style={styles.modalOverlay}>
            <View style={styles.modalContent}>
              <Text style={styles.modalTitle}>
                {currentId ? `Editando: ${form.nombre}` : "Nuevo Proveedor"}
              </Text>
              <ScrollView
                showsVerticalScrollIndicator={false}
                keyboardShouldPersistTaps="handled"
              >
                {campos.map(
                  ({ label, key, placeholder, editable, keyboardType }) => (
                    <View key={key}>
                      <Text style={styles.label}>{label}</Text>
                      <TextInput
                        style={[
                          styles.input,
                          !editable && styles.inputDisabled,
                          !!errors[key] && styles.inputError,
                        ]}
                        value={form[key]}
                        onChangeText={(v) => {
                          setForm({ ...form, [key]: v });
                          if (errors[key])
                            setErrors({ ...errors, [key]: undefined });
                        }}
                        placeholder={placeholder}
                        editable={editable}
                        keyboardType={keyboardType ?? "default"}
                        autoCapitalize={
                          key === "nit" ? "characters" : "sentences"
                        }
                      />
                      {!!errors[key] && (
                        <Text style={styles.errorText}>{errors[key]}</Text>
                      )}
                    </View>
                  ),
                )}

                {!nitEditable && (
                  <Text style={styles.infoNote}>
                    ℹ️ El NIT no puede modificarse una vez creado el proveedor.
                  </Text>
                )}

                <View style={styles.modalActions}>
                  <TouchableOpacity
                    style={styles.btnCancel}
                    onPress={cerrarModal}
                  >
                    <Text style={styles.btnTextDark}>✕ Cancelar</Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={[styles.btnSave, loading && { opacity: 0.7 }]}
                    onPress={handleGuardar}
                    disabled={loading}
                  >
                    {loading ? (
                      <ActivityIndicator size="small" color="white" />
                    ) : (
                      <Text style={styles.btnTextWhite}>
                        💾 {currentId ? "Actualizar" : "Guardar"}
                      </Text>
                    )}
                  </TouchableOpacity>
                </View>
              </ScrollView>
            </View>
          </View>
        </Modal>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: "#fdf8f3" },
  container: { flex: 1, padding: 16 },

  // buscador
  searchRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
    marginBottom: 12,
  },
  searchInput: {
    flex: 1,
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    paddingHorizontal: 12,
    height: 45,
  },
  btnClearInline: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    width: 40,
    height: 45,
    alignItems: "center",
    justifyContent: "center",
  },
  btnBuscar: {
    backgroundColor: "#C9973A",
    borderRadius: 8,
    width: 45,
    height: 45,
    alignItems: "center",
    justifyContent: "center",
  },
  inlineLoader: { position: "absolute", top: 8, right: 24 },

  btnAdd: {
    backgroundColor: "#5C3A1E",
    padding: 12,
    borderRadius: 8,
    alignItems: "center",
    marginBottom: 16,
  },
  btnTextWhite: { color: "white", fontWeight: "bold" },
  btnTextDark: { color: "#5C3A1E", fontWeight: "bold" },

  // tarjeta
  card: {
    backgroundColor: "white",
    padding: 16,
    borderRadius: 12,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  cardInfo: { marginBottom: 10 },
  badgeId: {
    backgroundColor: "#fdf6ec",
    color: "#C9973A",
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 12,
    fontSize: 12,
    alignSelf: "flex-start",
    marginBottom: 6,
  },
  cardTitle: {
    fontSize: 15,
    color: "#333",
    fontWeight: "bold",
    marginBottom: 4,
  },
  cardSub: { fontSize: 12, color: "#888", marginTop: 2 },
  actions: { flexDirection: "row", gap: 8 },
  btnEdit: {
    flex: 1,
    backgroundColor: "#fdf6ec",
    padding: 8,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    alignItems: "center",
  },
  btnTextGold: { color: "#C9973A", fontSize: 12, fontWeight: "bold" },
  btnDelete: {
    flex: 1,
    backgroundColor: "#fff5f5",
    padding: 8,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#fed7d7",
    alignItems: "center",
  },
  btnTextRed: { color: "#e53e3e", fontSize: 12, fontWeight: "bold" },

  // empty state
  emptyContainer: {
    alignItems: "center",
    marginTop: 40,
    paddingHorizontal: 24,
  },
  emptyIcon: { fontSize: 40, marginBottom: 12 },
  emptyTitle: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 6,
  },
  emptyText: { textAlign: "center", color: "#aaa", lineHeight: 20 },

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
    marginBottom: 16,
  },
  label: {
    fontSize: 11,
    color: "#5C3A1E",
    fontWeight: "bold",
    marginBottom: 4,
    textTransform: "uppercase",
  },
  input: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 10,
    marginBottom: 4,
  },
  inputDisabled: { backgroundColor: "#f0f0f0", color: "#888" },
  inputError: { borderColor: "#e53e3e", backgroundColor: "#fff5f5" },
  errorText: { fontSize: 11, color: "#e53e3e", marginBottom: 10, marginTop: 1 },
  infoNote: {
    fontSize: 11,
    color: "#8B5E3C",
    fontStyle: "italic",
    marginBottom: 12,
  },
  modalActions: {
    flexDirection: "row",
    justifyContent: "flex-end",
    gap: 10,
    marginTop: 8,
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
