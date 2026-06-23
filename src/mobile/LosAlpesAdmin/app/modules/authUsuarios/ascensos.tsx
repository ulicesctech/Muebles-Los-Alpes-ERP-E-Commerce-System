import DateTimePicker from "@react-native-community/datetimepicker";
import React, { useEffect, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  Modal,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import {
  cerrarAscenso,
  crearAscenso,
  eliminarAscenso,
  listarAscensos,
} from "../../../services/authUsuarios/ascensos";
import { listarEmpleados } from "../../../services/authUsuarios/empleados";
import { listarPuestos } from "../../../services/authUsuarios/puestos";

const CAFE = "#5C3A1E";
const GOLD = "#C9973A";

export default function AscensosScreen() {
  const [ascensos, setAscensos] = useState<any[]>([]);
  const [empleados, setEmpleados] = useState<any[]>([]);
  const [puestos, setPuestos] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [modalVisible, setModalVisible] = useState(false);
  const [busqueda, setBusqueda] = useState("");

  const [empSeleccionado, setEmpSeleccionado] = useState("");
  const [puestoSeleccionado, setPuestoSeleccionado] = useState("");
  const [fechaInicio, setFechaInicio] = useState("");
  const [fechaDate, setFechaDate] = useState(new Date());
  const [showDatePicker, setShowDatePicker] = useState(false);
  const [observaciones, setObservaciones] = useState("");
  const [paso, setPaso] = useState<"empleado" | "puesto">("empleado");

  useEffect(() => {
    cargar();
  }, []);

  const cargar = async () => {
    setLoading(true);
    try {
      const [resA, resE, resP] = await Promise.all([
        listarAscensos(),
        listarEmpleados(),
        listarPuestos(),
      ]);
      if (resA.ok) setAscensos(resA.data);
      if (resE.ok) setEmpleados(resE.data);
      if (resP.ok) setPuestos(resP.data);
    } catch {
      Alert.alert("Error", "No se pudo cargar.");
    } finally {
      setLoading(false);
    }
  };

  const abrirModal = () => {
    setEmpSeleccionado("");
    setPuestoSeleccionado("");
    setFechaInicio("");
    setFechaDate(new Date());
    setObservaciones("");
    setPaso("empleado");
    setModalVisible(true);
  };

  const onFechaChange = (event: any, selectedDate?: Date) => {
    setShowDatePicker(false);
    if (event.type === "dismissed") return;
    if (selectedDate) {
      setFechaDate(selectedDate);
      const yyyy = selectedDate.getFullYear();
      const mm = String(selectedDate.getMonth() + 1).padStart(2, "0");
      const dd = String(selectedDate.getDate()).padStart(2, "0");
      setFechaInicio(`${yyyy}-${mm}-${dd}`);
    }
  };

  const guardar = async () => {
    if (!empSeleccionado || !puestoSeleccionado || !fechaInicio) {
      Alert.alert("Error", "Completa todos los campos.");
      return;
    }
    try {
      await crearAscenso({
        em_empleado: parseInt(empSeleccionado),
        pue_puestos: parseInt(puestoSeleccionado),
        fecha_inicio: fechaInicio,
        observaciones: observaciones || " ",
      });
      Alert.alert("✅", "Ascenso registrado.");
      setModalVisible(false);
      cargar();
    } catch {
      Alert.alert("Error", "No se pudo guardar.");
    }
  };

  const cerrar = (asc: any) => {
    Alert.alert("Cerrar Ascenso", "¿Cerrar este ascenso?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Cerrar",
        onPress: async () => {
          await cerrarAscenso({ asc_ascenso: asc.asc_ascenso });
          cargar();
        },
      },
    ]);
  };

  const eliminar = (asc: any) => {
    Alert.alert("Eliminar", "¿Eliminar este ascenso?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Eliminar",
        style: "destructive",
        onPress: async () => {
          await eliminarAscenso({ asc_ascenso: asc.asc_ascenso });
          cargar();
        },
      },
    ]);
  };

  const filtrados = ascensos.filter((a) =>
    `${a.empleado_nombre} ${a.puesto_nombre}`
      .toLowerCase()
      .includes(busqueda.toLowerCase()),
  );

  const empNombre = (id: string) => {
    const e = empleados.find((e) => String(e.em_empleado) === id);
    return e
      ? `${e.em_primer_nombre} ${e.em_primer_apellido}`
      : "Seleccionar...";
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>📈 Ascensos</Text>
        <TouchableOpacity onPress={abrirModal}>
          <Text style={styles.addBtn}>+ Nuevo</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.searchBox}>
        <TextInput
          style={styles.searchInput}
          placeholder="Buscar por empleado o puesto..."
          value={busqueda}
          onChangeText={setBusqueda}
        />
      </View>

      {loading ? (
        <ActivityIndicator
          size="large"
          color={GOLD}
          style={{ marginTop: 40 }}
        />
      ) : (
        <ScrollView contentContainerStyle={styles.list}>
          {filtrados.map((a, i) => (
            <View key={i} style={styles.card}>
              <View style={styles.cardHeader}>
                <Text style={styles.cardNombre}>{a.empleado_nombre}</Text>
                <View
                  style={[
                    styles.badge,
                    a.asc_estado === "ACTIVO"
                      ? styles.badgeActivo
                      : styles.badgeCerrado,
                  ]}
                >
                  <Text style={styles.badgeText}>{a.asc_estado}</Text>
                </View>
              </View>
              <Text style={styles.cardPuesto}>📋 {a.puesto_nombre}</Text>
              <Text style={styles.cardFecha}>
                📅 Inicio: {a.asc_fecha_inicio}
              </Text>
              {a.asc_observaciones && (
                <Text style={styles.cardObs}>💬 {a.asc_observaciones}</Text>
              )}
              <View style={styles.actions}>
                {a.asc_estado === "ACTIVO" && (
                  <TouchableOpacity
                    style={styles.btnCerrar}
                    onPress={() => cerrar(a)}
                  >
                    <Text style={styles.btnCerrarText}>✅ Cerrar</Text>
                  </TouchableOpacity>
                )}
                <TouchableOpacity
                  style={styles.btnDel}
                  onPress={() => eliminar(a)}
                >
                  <Text style={styles.btnDelText}>🗑️ Eliminar</Text>
                </TouchableOpacity>
              </View>
            </View>
          ))}
        </ScrollView>
      )}

      <Modal visible={modalVisible} animationType="slide" transparent>
        <View style={styles.modalOverlay}>
          <ScrollView keyboardShouldPersistTaps="handled">
            <View style={styles.modalCard}>
              <Text style={styles.modalTitle}>Nuevo Ascenso</Text>

              <View style={styles.stepRow}>
                <View
                  style={[
                    styles.step,
                    paso === "empleado" && styles.stepActive,
                  ]}
                >
                  <Text
                    style={[
                      styles.stepText,
                      paso === "empleado" && styles.stepTextActive,
                    ]}
                  >
                    1. Empleado
                  </Text>
                </View>
                <View style={styles.stepLine} />
                <View
                  style={[styles.step, paso === "puesto" && styles.stepActive]}
                >
                  <Text
                    style={[
                      styles.stepText,
                      paso === "puesto" && styles.stepTextActive,
                    ]}
                  >
                    2. Puesto
                  </Text>
                </View>
              </View>

              {paso === "empleado" && (
                <>
                  <Text style={styles.label}>Seleccionar Empleado *</Text>
                  <ScrollView style={styles.selectList} nestedScrollEnabled>
                    {empleados.map((e, i) => (
                      <TouchableOpacity
                        key={i}
                        style={[
                          styles.selectItem,
                          empSeleccionado === String(e.em_empleado) &&
                            styles.selectItemActive,
                        ]}
                        onPress={() =>
                          setEmpSeleccionado(String(e.em_empleado))
                        }
                      >
                        <Text
                          style={[
                            styles.selectText,
                            empSeleccionado === String(e.em_empleado) &&
                              styles.selectTextActive,
                          ]}
                        >
                          {e.em_primer_nombre} {e.em_primer_apellido}
                        </Text>
                        <Text
                          style={[
                            styles.selectSub,
                            empSeleccionado === String(e.em_empleado) &&
                              styles.selectSubActive,
                          ]}
                        >
                          DPI: {e.em_DPI}
                        </Text>
                      </TouchableOpacity>
                    ))}
                  </ScrollView>
                  <View style={styles.modalActions}>
                    <TouchableOpacity
                      style={styles.btnCancel}
                      onPress={() => setModalVisible(false)}
                    >
                      <Text style={styles.btnCancelText}>Cancelar</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                      style={styles.btnSave}
                      onPress={() => {
                        if (!empSeleccionado) {
                          Alert.alert("Error", "Selecciona un empleado.");
                          return;
                        }
                        setPaso("puesto");
                      }}
                    >
                      <Text style={styles.btnSaveText}>Siguiente →</Text>
                    </TouchableOpacity>
                  </View>
                </>
              )}

              {paso === "puesto" && (
                <>
                  <View style={styles.empInfo}>
                    <Text style={styles.empInfoText}>
                      👨‍💼 {empNombre(empSeleccionado)}
                    </Text>
                  </View>

                  <Text style={styles.label}>Seleccionar Puesto *</Text>
                  <ScrollView style={styles.selectList} nestedScrollEnabled>
                    {puestos.map((p, i) => (
                      <TouchableOpacity
                        key={i}
                        style={[
                          styles.selectItem,
                          puestoSeleccionado === String(p.pue_puestos) &&
                            styles.selectItemActive,
                        ]}
                        onPress={() =>
                          setPuestoSeleccionado(String(p.pue_puestos))
                        }
                      >
                        <Text
                          style={[
                            styles.selectText,
                            puestoSeleccionado === String(p.pue_puestos) &&
                              styles.selectTextActive,
                          ]}
                        >
                          {p.pue_nombre}
                        </Text>
                        <Text
                          style={[
                            styles.selectSub,
                            puestoSeleccionado === String(p.pue_puestos) &&
                              styles.selectSubActive,
                          ]}
                        >
                          Q {parseFloat(p.pue_salario).toFixed(2)}
                        </Text>
                      </TouchableOpacity>
                    ))}
                  </ScrollView>

                  <Text style={styles.label}>Fecha de Inicio *</Text>
                  <TouchableOpacity
                    style={styles.dateBtn}
                    onPress={() => setShowDatePicker(true)} // ← ya no cierra el modal
                  >
                    <Text style={styles.dateBtnIco}>📅</Text>
                    <Text
                      style={
                        fechaInicio
                          ? styles.dateBtnText
                          : styles.dateBtnPlaceholder
                      }
                    >
                      {fechaInicio || "Seleccionar fecha..."}
                    </Text>
                  </TouchableOpacity>

                  {/* DatePicker inline dentro del modal — aparece como diálogo nativo en Android */}
                  {showDatePicker && (
                    <DateTimePicker
                      value={fechaDate}
                      mode="date"
                      display={Platform.OS === "ios" ? "spinner" : "default"}
                      onChange={onFechaChange}
                      maximumDate={new Date(2100, 11, 31)}
                      minimumDate={new Date(2000, 0, 1)}
                    />
                  )}

                  <Text style={styles.label}>Observaciones</Text>
                  <TextInput
                    style={[styles.input, styles.inputMulti]}
                    value={observaciones}
                    onChangeText={setObservaciones}
                    placeholder="Opcional..."
                    multiline
                    numberOfLines={3}
                  />

                  <View style={styles.modalActions}>
                    <TouchableOpacity
                      style={styles.btnCancel}
                      onPress={() => setPaso("empleado")}
                    >
                      <Text style={styles.btnCancelText}>← Atrás</Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.btnSave} onPress={guardar}>
                      <Text style={styles.btnSaveText}>💾 Guardar</Text>
                    </TouchableOpacity>
                  </View>
                </>
              )}
            </View>
          </ScrollView>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#f5ece0" },
  header: {
    backgroundColor: CAFE,
    padding: 16,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  title: { color: "#f0d9a0", fontSize: 18, fontWeight: "bold" },
  addBtn: { color: GOLD, fontSize: 14, fontWeight: "bold" },
  searchBox: {
    padding: 12,
    backgroundColor: "white",
    borderBottomWidth: 1,
    borderBottomColor: "#e8d8c0",
  },
  searchInput: {
    borderWidth: 1.5,
    borderColor: "#e8d8c0",
    borderRadius: 10,
    padding: 10,
    fontSize: 13,
    backgroundColor: "#fafafa",
  },
  list: { padding: 16, gap: 12 },
  card: {
    backgroundColor: "white",
    borderRadius: 12,
    padding: 16,
    elevation: 3,
  },
  cardHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 6,
  },
  cardNombre: { fontSize: 15, fontWeight: "bold", color: CAFE, flex: 1 },
  badge: { paddingHorizontal: 10, paddingVertical: 4, borderRadius: 20 },
  badgeActivo: { backgroundColor: "#d1fae5" },
  badgeCerrado: { backgroundColor: "#fee2e2" },
  badgeText: { fontSize: 11, fontWeight: "bold", color: "#374151" },
  cardPuesto: { fontSize: 13, color: "#6b7280", marginBottom: 2 },
  cardFecha: { fontSize: 13, color: "#6b7280", marginBottom: 2 },
  cardObs: { fontSize: 12, color: "#9ca3af", marginBottom: 10 },
  actions: { flexDirection: "row", gap: 8, marginTop: 8 },
  btnCerrar: {
    flex: 1,
    backgroundColor: "#d1fae5",
    padding: 8,
    borderRadius: 8,
    alignItems: "center",
  },
  btnCerrarText: { color: "#065f46", fontWeight: "bold", fontSize: 13 },
  btnDel: {
    flex: 1,
    backgroundColor: "#fee2e2",
    padding: 8,
    borderRadius: 8,
    alignItems: "center",
  },
  btnDelText: { color: "#991b1b", fontWeight: "bold", fontSize: 13 },
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    paddingVertical: 40,
    paddingHorizontal: 20,
  },
  modalCard: { backgroundColor: "white", borderRadius: 16, padding: 24 },
  modalTitle: {
    fontSize: 18,
    fontWeight: "bold",
    color: CAFE,
    marginBottom: 16,
    textAlign: "center",
  },
  stepRow: { flexDirection: "row", alignItems: "center", marginBottom: 16 },
  step: {
    flex: 1,
    padding: 10,
    borderRadius: 8,
    backgroundColor: "#f3f4f6",
    alignItems: "center",
  },
  stepActive: { backgroundColor: GOLD },
  stepText: { fontSize: 13, fontWeight: "bold", color: "#9ca3af" },
  stepTextActive: { color: "#1a1a1a" },
  stepLine: {
    width: 16,
    height: 2,
    backgroundColor: "#e5e7eb",
    marginHorizontal: 4,
  },
  empInfo: {
    backgroundColor: "#fef3c7",
    padding: 10,
    borderRadius: 8,
    marginBottom: 12,
  },
  empInfoText: { color: "#92400e", fontWeight: "bold", textAlign: "center" },
  label: { fontSize: 12, fontWeight: "bold", color: CAFE, marginBottom: 6 },
  input: {
    borderWidth: 1.5,
    borderColor: "#e8d8c0",
    borderRadius: 10,
    padding: 12,
    fontSize: 13,
    marginBottom: 16,
    backgroundColor: "#fafafa",
  },
  inputMulti: { height: 80, textAlignVertical: "top" },
  dateBtn: {
    flexDirection: "row",
    alignItems: "center",
    gap: 10,
    borderWidth: 1.5,
    borderColor: "#e8d8c0",
    borderRadius: 10,
    padding: 12,
    marginBottom: 16,
    backgroundColor: "#fafafa",
  },
  dateBtnIco: { fontSize: 18 },
  dateBtnText: { fontSize: 13, color: "#333", fontWeight: "bold" },
  dateBtnPlaceholder: { fontSize: 13, color: "#aaa" },
  selectList: { maxHeight: 180, marginBottom: 16 },
  selectItem: {
    padding: 12,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    marginBottom: 6,
  },
  selectItemActive: { backgroundColor: GOLD, borderColor: GOLD },
  selectText: { fontSize: 13, fontWeight: "bold", color: "#374151" },
  selectTextActive: { color: "#1a1a1a" },
  selectSub: { fontSize: 11, color: "#6b7280" },
  selectSubActive: { color: "#1a1a1a" },
  modalActions: { flexDirection: "row", gap: 12, marginTop: 8 },
  btnCancel: {
    flex: 1,
    backgroundColor: "#f3f4f6",
    padding: 12,
    borderRadius: 8,
    alignItems: "center",
  },
  btnCancelText: { color: "#374151", fontWeight: "bold" },
  btnSave: {
    flex: 1,
    backgroundColor: GOLD,
    padding: 12,
    borderRadius: 8,
    alignItems: "center",
  },
  btnSaveText: { color: "#1a1a1a", fontWeight: "bold" },
});
