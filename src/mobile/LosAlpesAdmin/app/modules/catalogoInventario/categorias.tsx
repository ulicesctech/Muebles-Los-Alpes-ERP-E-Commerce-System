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
  actualizarCategoria,
  buscarCategorias,
  Categoria,
  crearCategoria,
  eliminarCategoria,
  getCategorias,
} from "../../../services/catalogoInventario/categorias";

export default function CategoriasScreen() {
  const [categorias, setCategorias] = useState<Categoria[]>([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");

  const [modalVisible, setModalVisible] = useState(false);
  const [currentId, setCurrentId] = useState<number | null>(null);
  const [descripcion, setDescripcion] = useState("");

  useEffect(() => {
    cargarCategorias();
  }, []);

  const cargarCategorias = async () => {
    setLoading(true);
    try {
      const data = await getCategorias();
      setCategorias(data);
    } catch (error) {
      Alert.alert("Error", "No se pudieron cargar las categorías");
    } finally {
      setLoading(false);
    }
  };

  const handleBuscar = async () => {
    if (!search.trim()) return cargarCategorias();
    setLoading(true);
    try {
      const data = await buscarCategorias(search);
      setCategorias(data);
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
        await actualizarCategoria(currentId, descripcion);
        Alert.alert("Éxito", "Categoría actualizada");
      } else {
        await crearCategoria(descripcion);
        Alert.alert("Éxito", "Categoría creada");
      }
      cerrarModal();
      cargarCategorias();
    } catch (error) {
      Alert.alert("Error", "Ocurrió un error al guardar");
    } finally {
      setLoading(false);
    }
  };

  const handleEliminar = (id: number) => {
    Alert.alert("Eliminar", "¿Estás seguro de eliminar esta categoría?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Eliminar",
        style: "destructive",
        onPress: async () => {
          try {
            setLoading(true);
            await eliminarCategoria(id);
            Alert.alert("Éxito", "Categoría eliminada");
            cargarCategorias();
          } catch (error) {
            Alert.alert("Error", "No se pudo eliminar");
            setLoading(false);
          }
        },
      },
    ]);
  };

  const abrirModal = (categoria?: Categoria) => {
    if (categoria) {
      setCurrentId(categoria.CAT_CATEGORIA);
      setDescripcion(categoria.CAT_DESCRIPCION);
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

  const renderItem = ({ item }: { item: Categoria }) => (
    <View style={styles.card}>
      <View style={styles.cardInfo}>
        <Text style={styles.badgeId}>ID: {item.CAT_CATEGORIA}</Text>
        <Text style={styles.title}>{item.CAT_DESCRIPCION}</Text>
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
          onPress={() => handleEliminar(item.CAT_CATEGORIA)}
        >
          <Text style={styles.btnTextRed}>🗑 Eliminar</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      {/* EL ENCABEZADO AHORA ESTÁ FUERA DEL FLATLIST */}
      <View style={styles.headerContainer}>
        <View style={styles.searchContainer}>
          <TextInput
            style={styles.searchInput}
            placeholder="Buscar categoría..."
            value={search}
            onChangeText={setSearch}
          />
          <TouchableOpacity style={styles.btnSearch} onPress={handleBuscar}>
            <Text style={styles.btnTextWhite}>Buscar</Text>
          </TouchableOpacity>
        </View>

        <TouchableOpacity style={styles.btnAdd} onPress={() => abrirModal()}>
          <Text style={styles.btnTextWhite}>+ Nueva Categoría</Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={categorias}
        keyExtractor={(item) => item.CAT_CATEGORIA.toString()}
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
            <Text style={styles.emptyText}>No hay categorías registradas.</Text>
          )
        }
      />

      <Modal visible={modalVisible} animationType="slide" transparent={true}>
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>
              {currentId ? "Editar Categoría" : "Nueva Categoría"}
            </Text>

            <Text style={styles.label}>Descripción *</Text>
            <TextInput
              style={styles.input}
              value={descripcion}
              onChangeText={setDescripcion}
              placeholder="Ej: Sala, Dormitorio..."
            />

            <View style={styles.modalActions}>
              <TouchableOpacity style={styles.btnCancel} onPress={cerrarModal}>
                <Text style={styles.btnTextDark}>Cancelar</Text>
              </TouchableOpacity>
              <TouchableOpacity style={styles.btnSave} onPress={handleGuardar}>
                <Text style={styles.btnTextWhite}>💾 Guardar</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#fdf8f3", padding: 16 },
  headerContainer: { marginBottom: 10 }, // Nuevo estilo para agrupar el buscador fijo
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
    marginBottom: 6,
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
    overflow: "hidden", // Añadido por seguridad visual
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
  emptyText: { textAlign: "center", color: "#aaa", marginTop: 20 },
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    justifyContent: "center",
    padding: 20,
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
