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
  actualizarMaterial,
  buscarMateriales,
  crearMaterial,
  eliminarMaterial,
  getMateriales,
  Material,
} from "../../../services/catalogoInventario/materiales";

export default function MaterialesScreen() {
  const [materiales, setMateriales] = useState<Material[]>([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");

  const [modalVisible, setModalVisible] = useState(false);
  const [currentId, setCurrentId] = useState<number | null>(null);
  const [descripcion, setDescripcion] = useState("");

  useEffect(() => {
    cargarMateriales();
  }, []);

  const cargarMateriales = async () => {
    setLoading(true);
    try {
      const data = await getMateriales();
      setMateriales(data);
    } catch (error) {
      Alert.alert("Error", "No se pudieron cargar los materiales");
    } finally {
      setLoading(false);
    }
  };

  const handleBuscar = async () => {
    if (!search.trim()) return cargarMateriales();

    setLoading(true);
    try {
      const data = await buscarMateriales(search);
      setMateriales(data);
    } catch (error) {
      Alert.alert("Error", "No se pudo realizar la búsqueda");
    } finally {
      setLoading(false);
    }
  };

  const handleGuardar = async () => {
    if (!descripcion.trim()) {
      Alert.alert("Atención", "La descripción es obligatoria");
      return;
    }

    setLoading(true);
    try {
      if (currentId) {
        await actualizarMaterial(currentId, descripcion);
        Alert.alert("Éxito", "Material actualizado correctamente");
      } else {
        await crearMaterial(descripcion);
        Alert.alert("Éxito", "Material creado correctamente");
      }
      cerrarModal();
      cargarMateriales();
    } catch (error) {
      Alert.alert("Error", "Ocurrió un error al guardar el material");
    } finally {
      setLoading(false);
    }
  };

  const handleEliminar = (id: number) => {
    Alert.alert(
      "Eliminar Material",
      "¿Estás seguro de eliminar este material?",
      [
        { text: "Cancelar", style: "cancel" },
        {
          text: "Eliminar",
          style: "destructive",
          onPress: async () => {
            try {
              setLoading(true);
              await eliminarMaterial(id);
              Alert.alert("Éxito", "Material eliminado");
              cargarMateriales();
            } catch (error) {
              Alert.alert("Error", "No se pudo eliminar el material");
              setLoading(false);
            }
          },
        },
      ],
    );
  };

  const abrirModal = (material?: Material) => {
    if (material) {
      setCurrentId(material.MAT_MATERIAL);
      setDescripcion(material.MAT_DESCRIPCION);
    } else {
      setCurrentId(null);
      setDescripcion("");
    }
    setModalVisible(true);
  };

  const cerrarModal = () => {
    setModalVisible(false);
    setCurrentId(null);
    setDescripcion("");
  };

  const renderItem = ({ item }: { item: Material }) => (
    <View style={styles.card}>
      <View style={styles.cardInfo}>
        <Text style={styles.badgeId}>ID: {item.MAT_MATERIAL}</Text>
        <Text style={styles.title}>{item.MAT_DESCRIPCION}</Text>
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
          onPress={() => handleEliminar(item.MAT_MATERIAL)}
        >
          <Text style={styles.btnTextRed}>🗑 Eliminar</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.headerContainer}>
        <View style={styles.searchContainer}>
          <TextInput
            style={styles.searchInput}
            placeholder="Buscar material..."
            value={search}
            onChangeText={setSearch}
          />
          <TouchableOpacity style={styles.btnSearch} onPress={handleBuscar}>
            <Text style={styles.btnTextWhite}>Buscar</Text>
          </TouchableOpacity>
        </View>

        <TouchableOpacity style={styles.btnAdd} onPress={() => abrirModal()}>
          <Text style={styles.btnTextWhite}>🧱 + Nuevo Material</Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={materiales}
        keyExtractor={(item) => item.MAT_MATERIAL.toString()}
        renderItem={renderItem}
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
              <Text style={styles.emptyEmoji}>🧱</Text>
              <Text style={styles.emptyText}>
                No hay materiales registrados.
              </Text>
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
                <Text style={styles.modalTitle}>
                  {currentId ? "Editar Material" : "Nuevo Material"}
                </Text>

                <Text style={styles.label}>Descripción *</Text>
                <TextInput
                  style={styles.input}
                  value={descripcion}
                  onChangeText={setDescripcion}
                  placeholder="Ej: Madera, Metal, Tela..."
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
                    onPress={handleGuardar}
                  >
                    <Text style={styles.btnTextWhite}>💾 Guardar</Text>
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
  headerContainer: { marginBottom: 10 },
  searchContainer: { flexDirection: "row", marginBottom: 10, gap: 8 },
  searchInput: {
    flex: 1,
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    paddingHorizontal: 12,
    height: 45,
  },
  btnSearch: {
    backgroundColor: "#C9973A",
    justifyContent: "center",
    paddingHorizontal: 16,
    borderRadius: 8,
  },
  btnAdd: {
    backgroundColor: "#5C3A1E",
    padding: 12,
    borderRadius: 8,
    alignItems: "center",
    marginBottom: 16,
  },
  btnTextWhite: { color: "white", fontWeight: "bold" },
  card: {
    backgroundColor: "white",
    padding: 16,
    borderRadius: 12,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  cardInfo: { flex: 1 },
  badgeId: {
    backgroundColor: "#fdf6ec",
    color: "#C9973A",
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 12,
    fontSize: 12,
    alignSelf: "flex-start",
    marginBottom: 4,
    overflow: "hidden",
  },
  title: { fontSize: 16, color: "#444", fontWeight: "bold" },
  actions: { flexDirection: "row", gap: 8 },
  btnEdit: {
    backgroundColor: "#fdf6ec",
    padding: 8,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  btnTextGold: { color: "#C9973A", fontSize: 12, fontWeight: "bold" },
  btnDelete: {
    backgroundColor: "#fff5f5",
    padding: 8,
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
  },
  input: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 10,
    marginBottom: 20,
  },
  modalActions: { flexDirection: "row", justifyContent: "flex-end", gap: 10 },
  btnCancel: {
    padding: 10,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  btnSave: { backgroundColor: "#C9973A", padding: 10, borderRadius: 8 },
  btnTextDark: { color: "#5C3A1E", fontWeight: "bold" },
});