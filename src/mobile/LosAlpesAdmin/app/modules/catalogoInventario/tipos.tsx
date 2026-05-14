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
  Categoria,
  getCategorias,
} from "../../../services/catalogoInventario/categorias";
import {
  actualizarTipo,
  crearTipo,
  eliminarTipo,
  getTipos,
  getTiposPorCategoria,
  Tipo,
} from "../../../services/catalogoInventario/tipos";

export default function TiposScreen() {
  const [tipos, setTipos] = useState<Tipo[]>([]);
  const [categorias, setCategorias] = useState<Categoria[]>([]);
  const [loading, setLoading] = useState(false);

  const [filtroCategoria, setFiltroCategoria] = useState<number | null>(null);
  const [modalFiltroVisible, setModalFiltroVisible] = useState(false);

  const [modalVisible, setModalVisible] = useState(false);
  const [currentId, setCurrentId] = useState<number | null>(null);
  const [descripcion, setDescripcion] = useState("");
  const [selectedCategoria, setSelectedCategoria] = useState<number | null>(
    null,
  );
  const [modalSelectorVisible, setModalSelectorVisible] = useState(false);

  useEffect(() => {
    cargarDatosIniciales();
  }, []);

  useEffect(() => {
    cargarTipos();
  }, [filtroCategoria]);

  const cargarDatosIniciales = async () => {
    setLoading(true);
    try {
      const cats = await getCategorias();
      setCategorias(cats);
      await cargarTipos();
    } catch (error) {
      Alert.alert("Error", "No se pudieron cargar los datos iniciales");
      setLoading(false);
    }
  };

  const cargarTipos = async () => {
    setLoading(true);
    try {
      let data;
      if (filtroCategoria) {
        data = await getTiposPorCategoria(filtroCategoria);
      } else {
        data = await getTipos();
      }
      setTipos(data);
    } catch (error) {
      Alert.alert("Error", "No se pudieron cargar los tipos");
    } finally {
      setLoading(false);
    }
  };

  const handleGuardar = async () => {
    if (!descripcion.trim() || !selectedCategoria) {
      Alert.alert("Atención", "La descripción y la categoría son obligatorias");
      return;
    }

    setLoading(true);
    try {
      if (currentId) {
        await actualizarTipo(currentId, descripcion, selectedCategoria);
        Alert.alert("Éxito", "Tipo actualizado correctamente");
      } else {
        await crearTipo(descripcion, selectedCategoria);
        Alert.alert("Éxito", "Tipo creado correctamente");
      }
      cerrarModal();
      cargarTipos();
    } catch (error) {
      Alert.alert("Error", "Ocurrió un error al guardar");
    } finally {
      setLoading(false);
    }
  };

  const handleEliminar = (id: number) => {
    Alert.alert("Eliminar Tipo", "¿Estás seguro de eliminar este tipo?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Eliminar",
        style: "destructive",
        onPress: async () => {
          try {
            setLoading(true);
            await eliminarTipo(id);
            Alert.alert("Éxito", "Tipo eliminado");
            cargarTipos();
          } catch (error) {
            Alert.alert("Error", "No se pudo eliminar el tipo");
            setLoading(false);
          }
        },
      },
    ]);
  };

  const abrirModal = (tipo?: Tipo) => {
    if (tipo) {
      setCurrentId(tipo.TIP_TIPO);
      setDescripcion(tipo.TIP_DESCRIPCION);
      setSelectedCategoria(tipo.CAT_CATEGORIA);
    } else {
      setCurrentId(null);
      setDescripcion("");
      setSelectedCategoria(null);
    }
    setModalVisible(true);
  };

  const cerrarModal = () => {
    setModalVisible(false);
    setCurrentId(null);
    setDescripcion("");
    setSelectedCategoria(null);
  };

  const getNombreCategoriaSeleccionada = (id: number | null) => {
    if (!id) return "Seleccione una categoría...";
    const cat = categorias.find((c) => c.CAT_CATEGORIA === id);
    return cat ? cat.CAT_DESCRIPCION : "Desconocida";
  };

  // --- ENCABEZADO DE LA LISTA ---
  const renderHeader = () => (
    <View>
      <View style={styles.searchContainer}>
        <TouchableOpacity
          style={styles.filterDropdown}
          onPress={() => setModalFiltroVisible(true)}
        >
          <Text style={styles.filterText}>
            🏷️ Filtro:{" "}
            {filtroCategoria
              ? getNombreCategoriaSeleccionada(filtroCategoria)
              : "Todas las Categorías"}
          </Text>
        </TouchableOpacity>
        {filtroCategoria !== null && (
          <TouchableOpacity
            style={styles.btnClearFilter}
            onPress={() => setFiltroCategoria(null)}
          >
            <Text style={styles.btnTextRed}>✕</Text>
          </TouchableOpacity>
        )}
      </View>

      <TouchableOpacity style={styles.btnAdd} onPress={() => abrirModal()}>
        <Text style={styles.btnTextWhite}>📋 + Nuevo Tipo</Text>
      </TouchableOpacity>
    </View>
  );

  const renderItem = ({ item }: { item: Tipo }) => (
    <View style={styles.card}>
      <View style={styles.cardInfo}>
        <View style={styles.badgeRow}>
          <Text style={styles.badgeId}>ID: {item.TIP_TIPO}</Text>
          <Text style={styles.badgeCat}>🏷️ {item.CATEGORIA}</Text>
        </View>
        <Text style={styles.title}>{item.TIP_DESCRIPCION}</Text>
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
          onPress={() => handleEliminar(item.TIP_TIPO)}
        >
          <Text style={styles.btnTextRed}>🗑 Eliminar</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      <FlatList
        data={tipos}
        keyExtractor={(item) => item.TIP_TIPO.toString()}
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
              <Text style={styles.emptyEmoji}>📋</Text>
              <Text style={styles.emptyText}>No hay tipos registrados.</Text>
            </View>
          )
        }
      />

      {/* Modal Formulario */}
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
                  {currentId ? "Editar Tipo" : "Nuevo Tipo"}
                </Text>

                <Text style={styles.label}>Descripción *</Text>
                <TextInput
                  style={styles.input}
                  value={descripcion}
                  onChangeText={setDescripcion}
                  placeholder="Ej: Sofá, Mesa, Silla..."
                  maxLength={200}
                />

                <Text style={styles.label}>Categoría *</Text>
                <TouchableOpacity
                  style={styles.selectorInput}
                  onPress={() => setModalSelectorVisible(true)}
                >
                  <Text
                    style={
                      selectedCategoria
                        ? styles.selectorText
                        : styles.selectorPlaceholder
                    }
                  >
                    {getNombreCategoriaSeleccionada(selectedCategoria)}
                  </Text>
                </TouchableOpacity>

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

      {/* Selector Modal (Reutilizado para Filtro y Formulario) */}
      <Modal
        visible={modalSelectorVisible || modalFiltroVisible}
        animationType="fade"
        transparent={true}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.selectorContent}>
            <Text style={styles.modalTitle}>Selecciona una Categoría</Text>
            <FlatList
              data={categorias}
              keyExtractor={(item) => item.CAT_CATEGORIA.toString()}
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={styles.selectorItem}
                  onPress={() => {
                    if (modalSelectorVisible) {
                      setSelectedCategoria(item.CAT_CATEGORIA);
                      setModalSelectorVisible(false);
                    } else {
                      setFiltroCategoria(item.CAT_CATEGORIA);
                      setModalFiltroVisible(false);
                    }
                  }}
                >
                  <Text style={styles.selectorItemText}>
                    {item.CAT_DESCRIPCION}
                  </Text>
                </TouchableOpacity>
              )}
            />
            <TouchableOpacity
              style={styles.btnCancelSelector}
              onPress={() => {
                setModalSelectorVisible(false);
                setModalFiltroVisible(false);
              }}
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
  searchContainer: { flexDirection: "row", marginBottom: 12, gap: 8 },
  filterDropdown: {
    flex: 1,
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    paddingHorizontal: 14,
    justifyContent: "center",
    height: 45,
  },
  filterText: { color: "#5C3A1E", fontSize: 14 },
  btnClearFilter: {
    backgroundColor: "#fff5f5",
    borderWidth: 1,
    borderColor: "#fed7d7",
    justifyContent: "center",
    paddingHorizontal: 14,
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
  badgeRow: { flexDirection: "row", gap: 8, marginBottom: 6 },
  badgeId: {
    backgroundColor: "#fdf6ec",
    color: "#C9973A",
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 12,
    fontSize: 11,
    fontWeight: "bold",
    overflow: "hidden",
  },
  badgeCat: {
    backgroundColor: "#f0f4f8",
    color: "#4a5568",
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 12,
    fontSize: 11,
    fontWeight: "bold",
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
    marginBottom: 16,
  },
  selectorInput: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 12,
    marginBottom: 20,
  },
  selectorText: { color: "#333", fontSize: 14 },
  selectorPlaceholder: { color: "#999", fontSize: 14 },
  modalActions: { flexDirection: "row", justifyContent: "flex-end", gap: 10 },
  btnCancel: {
    padding: 10,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  btnSave: { backgroundColor: "#C9973A", padding: 10, borderRadius: 8 },
  btnTextDark: { color: "#5C3A1E", fontWeight: "bold" },
  selectorContent: {
    backgroundColor: "white",
    padding: 20,
    borderRadius: 12,
    maxHeight: "70%",
  },
  selectorItem: {
    paddingVertical: 14,
    borderBottomWidth: 1,
    borderBottomColor: "#f5ece0",
  },
  selectorItemText: { fontSize: 16, color: "#444" },
  btnCancelSelector: {
    marginTop: 16,
    alignItems: "center",
    padding: 12,
    backgroundColor: "#fff5f5",
    borderRadius: 8,
  },
});