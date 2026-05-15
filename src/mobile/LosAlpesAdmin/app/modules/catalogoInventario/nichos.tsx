import React, { useEffect, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  FlatList,
  KeyboardAvoidingView,
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
  actualizarNicho,
  eliminarNicho,
  getNichos,
  Nicho,
} from "../../../services/catalogoInventario/nichos";

export default function NichosScreen() {
  const [nichos, setNichos] = useState<Nicho[]>([]);
  const [loading, setLoading] = useState(false);

  const [modalVisible, setModalVisible] = useState(false);
  const [currentId, setCurrentId] = useState<number | null>(null);

  const [numero, setNumero] = useState("");
  const [zona, setZona] = useState("");
  const [caracteristica, setCaracteristica] = useState("");

  useEffect(() => {
    cargarNichos();
  }, []);

  const cargarNichos = async () => {
    setLoading(true);
    try {
      const data = await getNichos();
      setNichos(data);
    } catch (error) {
      Alert.alert("Error", "No se pudieron cargar los nichos");
    } finally {
      setLoading(false);
    }
  };

  const handleActualizar = async () => {
    if (!numero.trim() || !zona.trim() || !caracteristica.trim()) {
      Alert.alert("Atención", "Todos los campos son obligatorios");
      return;
    }

    if (!currentId) return;

    setLoading(true);
    try {
      await actualizarNicho(currentId, numero, zona, caracteristica);
      Alert.alert("Éxito", "Nicho actualizado correctamente");
      cerrarModal();
      cargarNichos();
    } catch (error) {
      Alert.alert("Error", "Ocurrió un error al actualizar el nicho");
    } finally {
      setLoading(false);
    }
  };

  const handleEliminar = (id: number) => {
    Alert.alert("Eliminar Nicho", "¿Deseas eliminar este nicho?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Eliminar",
        style: "destructive",
        onPress: async () => {
          try {
            setLoading(true);
            await eliminarNicho(id);
            Alert.alert("Éxito", "Nicho eliminado");
            cargarNichos();
          } catch (error) {
            Alert.alert("Error", "No se pudo eliminar el nicho");
            setLoading(false);
          }
        },
      },
    ]);
  };

  const abrirModalEditar = (nicho: Nicho) => {
    setCurrentId(nicho.NIC_NICHO);
    setNumero(nicho.NIC_NUMERO);
    setZona(nicho.NIC_ZONA);
    setCaracteristica(nicho.NIC_CARACTERISTICA);
    setModalVisible(true);
  };

  const cerrarModal = () => {
    setModalVisible(false);
    setCurrentId(null);
    setNumero("");
    setZona("");
    setCaracteristica("");
  };

  // --- ENCABEZADO DE LA LISTA ---
  const renderHeader = () => (
    <View style={styles.infoBanner}>
      <Text style={styles.infoText}>
        ℹ️ Para crear un nicho nuevo, hazlo desde la sección de{" "}
        <Text style={styles.infoTextBold}>Almacenes</Text>. Cada nicho se crea y
        asigna directamente a su almacén.
      </Text>
    </View>
  );

  const renderItem = ({ item }: { item: Nicho }) => (
    <View style={styles.card}>
      <View style={styles.cardHeader}>
        <Text style={styles.badgeId}>ID: {item.NIC_NICHO}</Text>
        <Text style={styles.almacenText}>
          📦 {item.ALM_NOMBRE || "Sin Almacén"}
        </Text>
      </View>

      <View style={styles.cardInfo}>
        <Text style={styles.title}>Número: {item.NIC_NUMERO}</Text>
        <Text style={styles.subtitle}>Zona: {item.NIC_ZONA}</Text>
        <Text style={styles.detail}>
          Característica: {item.NIC_CARACTERISTICA}
        </Text>
      </View>

      <View style={styles.actions}>
        <TouchableOpacity
          style={styles.btnEdit}
          onPress={() => abrirModalEditar(item)}
        >
          <Text style={styles.btnTextGold}>✏️ Editar</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.btnDelete}
          onPress={() => handleEliminar(item.NIC_NICHO)}
        >
          <Text style={styles.btnTextRed}>🗑 Eliminar</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      <FlatList
        data={nichos}
        keyExtractor={(item) => item.NIC_NICHO.toString()}
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
              <Text style={styles.emptyEmoji}>🗄️</Text>
              <Text style={styles.emptyText}>No hay nichos registrados.</Text>
            </View>
          )
        }
      />

      <Modal visible={modalVisible} animationType="slide" transparent={true}>
        <View style={styles.modalOverlay}>
          <KeyboardAvoidingView
            style={styles.keyboardContainer}
            behavior={Platform.OS === "ios" ? "padding" : "height"}
          >
            <ScrollView
              keyboardShouldPersistTaps="handled"
              keyboardDismissMode="none"
              showsVerticalScrollIndicator={false}
            >
              <View style={styles.modalContent}>
                <Text style={styles.modalTitle}>✏️ Editar Nicho</Text>

                <Text style={styles.label}>Número *</Text>
                <TextInput
                  style={styles.input}
                  value={numero}
                  onChangeText={setNumero}
                  placeholder="Ej: A-001"
                  maxLength={50}
                />

                <Text style={styles.label}>Zona *</Text>
                <TextInput
                  style={styles.input}
                  value={zona}
                  onChangeText={setZona}
                  placeholder="Ej: Zona Norte"
                  maxLength={100}
                />

                <Text style={styles.label}>Característica *</Text>
                <TextInput
                  style={styles.input}
                  value={caracteristica}
                  onChangeText={setCaracteristica}
                  placeholder="Ej: Alta capacidad"
                  maxLength={300}
                />

                <View style={styles.modalActions}>
                  <TouchableOpacity
                    style={styles.btnCancel}
                    onPress={cerrarModal}
                  >
                    <Text style={styles.btnTextDark}>Cancelar</Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={styles.btnSave}
                    onPress={handleActualizar}
                  >
                    <Text style={styles.btnTextWhite}>💾 Actualizar</Text>
                  </TouchableOpacity>
                </View>
              </View>
            </ScrollView>
          </KeyboardAvoidingView>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#fdf8f3", padding: 16 },
  infoBanner: {
    backgroundColor: "#fdf6ec",
    borderWidth: 1,
    borderColor: "#e8d0a0",
    borderRadius: 10,
    padding: 14,
    marginBottom: 16,
  },
  infoText: { fontSize: 13, color: "#7a5818", lineHeight: 20 },
  infoTextBold: { fontWeight: "bold", color: "#C9973A" },
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
    marginBottom: 10,
  },
  badgeId: {
    backgroundColor: "#fdf6ec",
    color: "#C9973A",
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
    fontSize: 12,
    fontWeight: "bold",
    overflow: "hidden",
  },
  almacenText: { fontSize: 13, color: "#5C3A1E", fontWeight: "bold" },
  cardInfo: { marginBottom: 14 },
  title: { fontSize: 16, color: "#333", fontWeight: "bold", marginBottom: 4 },
  subtitle: { fontSize: 14, color: "#555", marginBottom: 2 },
  detail: { fontSize: 13, color: "#777" },
  actions: {
    flexDirection: "row",
    justifyContent: "flex-end",
    gap: 8,
    borderTopWidth: 1,
    borderTopColor: "#f5ece0",
    paddingTop: 10,
  },
  btnEdit: {
    backgroundColor: "#fdf6ec",
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  btnTextGold: { color: "#C9973A", fontSize: 12, fontWeight: "bold" },
  btnDelete: {
    backgroundColor: "#fff5f5",
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#fed7d7",
  },
  btnTextRed: { color: "#e53e3e", fontSize: 12, fontWeight: "bold" },
  emptyState: { alignItems: "center", marginTop: 40 },
  emptyEmoji: { fontSize: 48, marginBottom: 10 },
  emptyText: { color: "#aaa", fontSize: 16 },
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    justifyContent: "center",
    padding: 20,
  },
  keyboardContainer: {
    width: "100%",
  },
  modalContent: { backgroundColor: "white", padding: 20, borderRadius: 12 },
  modalTitle: {
    fontSize: 18,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 16,
  },
  label: {
    fontSize: 12,
    color: "#5C3A1E",
    fontWeight: "bold",
    marginBottom: 4,
    marginTop: 10,
  },
  input: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 10,
    fontSize: 14,
  },
  modalActions: {
    flexDirection: "row",
    justifyContent: "flex-end",
    gap: 10,
    marginTop: 20,
  },
  btnCancel: {
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  btnSave: {
    backgroundColor: "#C9973A",
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: 8,
  },
  btnTextDark: { color: "#5C3A1E", fontWeight: "bold" },
  btnTextWhite: { color: "white", fontWeight: "bold" },
});