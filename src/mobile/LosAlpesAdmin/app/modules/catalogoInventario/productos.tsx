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

// Servicios Propios
import {
  actualizarProducto,
  buscarProductos,
  crearProducto,
  eliminarProducto,
  getProductos,
  Producto,
} from "../../../services/catalogoInventario/productos";
// Dependencias para los combos
import {
  Categoria,
  getCategorias,
} from "../../../services/catalogoInventario/categorias";
import {
  getMateriales,
  Material,
} from "../../../services/catalogoInventario/materiales";
import {
  getTiposPorCategoria,
  Tipo,
} from "../../../services/catalogoInventario/tipos";

export default function ProductosScreen() {
  const [productos, setProductos] = useState<Producto[]>([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");

  // Estado del Modal Formulario
  const [modalVisible, setModalVisible] = useState(false);
  const [isEditing, setIsEditing] = useState(false);

  // Combos / Selectores Data
  const [categorias, setCategorias] = useState<Categoria[]>([]);
  const [tipos, setTipos] = useState<Tipo[]>([]);
  const [materiales, setMateriales] = useState<Material[]>([]);

  // Campos del Formulario
  const [referencia, setReferencia] = useState("");
  const [nombre, setNombre] = useState("");
  const [color, setColor] = useState("");
  const [peso, setPeso] = useState("");
  const [descripcion, setDescripcion] = useState("");
  const [alto, setAlto] = useState("");
  const [ancho, setAncho] = useState("");
  const [profundidad, setProfundidad] = useState("");

  const [categoriaId, setCategoriaId] = useState<number | null>(null);
  const [tipoId, setTipoId] = useState<number | null>(null);
  const [materialId, setMaterialId] = useState<number | null>(null);

  // Estado del Modal Selector Único
  const [modalSelectorVisible, setModalSelectorVisible] = useState(false);
  const [selectorType, setSelectorType] = useState<
    "categoria" | "tipo" | "material"
  >("categoria");
  const [selectorData, setSelectorData] = useState<
    { id: number; nombre: string }[]
  >([]);

  useEffect(() => {
    cargarDatosIniciales();
  }, []);

  // Si cambia la categoría, cargamos los tipos de esa categoría
  useEffect(() => {
    if (categoriaId) {
      cargarTiposDropdown(categoriaId);
    } else {
      setTipos([]);
      setTipoId(null);
    }
  }, [categoriaId]);

  const cargarDatosIniciales = async () => {
    setLoading(true);
    try {
      const [dataProd, dataCat, dataMat] = await Promise.all([
        getProductos(),
        getCategorias(),
        getMateriales(),
      ]);
      setProductos(dataProd);
      setCategorias(dataCat);
      setMateriales(dataMat);
    } catch (error) {
      Alert.alert("Error", "No se pudieron cargar los datos iniciales");
    } finally {
      setLoading(false);
    }
  };

  const cargarTiposDropdown = async (idCat: number) => {
    try {
      const dataTipos = await getTiposPorCategoria(idCat);
      setTipos(dataTipos);
    } catch (error) {
      console.log("Error al cargar tipos");
    }
  };

  const handleBuscar = async () => {
    if (!search.trim()) return cargarDatosIniciales();
    setLoading(true);
    try {
      const data = await buscarProductos(search);
      setProductos(data);
    } catch (error) {
      Alert.alert("Error", "No se pudo realizar la búsqueda");
    } finally {
      setLoading(false);
    }
  };

  const handleGuardar = async () => {
    if (
      !referencia.trim() ||
      !nombre.trim() ||
      !categoriaId ||
      !tipoId ||
      !materialId
    ) {
      Alert.alert(
        "Atención",
        "Referencia, Nombre, Categoría, Tipo y Material son obligatorios",
      );
      return;
    }

    setLoading(true);
    try {
      const payload = {
        referencia,
        nombre,
        descripcion,
        tipoId,
        materialId,
        color,
        alto,
        ancho,
        profundidad,
        peso,
      };

      if (isEditing) {
        await actualizarProducto(payload);
        Alert.alert("Éxito", "Producto actualizado");
      } else {
        await crearProducto(payload);
        Alert.alert("Éxito", "Producto creado");
      }
      cerrarModal();
      handleBuscar();
    } catch (error) {
      Alert.alert("Error", "Ocurrió un error al guardar");
    } finally {
      setLoading(false);
    }
  };

  const handleEliminar = (ref: string) => {
    Alert.alert(
      "Eliminar Producto",
      "¿Estás seguro de eliminar este producto?",
      [
        { text: "Cancelar", style: "cancel" },
        {
          text: "Eliminar",
          style: "destructive",
          onPress: async () => {
            try {
              setLoading(true);
              await eliminarProducto(ref);
              Alert.alert("Éxito", "Producto eliminado");
              handleBuscar();
            } catch (error) {
              Alert.alert("Error", "No se pudo eliminar");
              setLoading(false);
            }
          },
        },
      ],
    );
  };

  const abrirModal = (prod?: Producto) => {
    if (prod) {
      setIsEditing(true);
      setReferencia(prod.PRO_REFERENCIA);
      setNombre(prod.PRO_NOMBRE);
      setColor(prod.PRO_COLOR || "");
      setPeso(prod.PRO_PESO?.toString() || "");
      setDescripcion(prod.PRO_DESCRIPCION || "");
      setMaterialId(prod.MAT_MATERIAL || null);
      setAlto(prod.PRO_ALTO_CM?.toString() || "");
      setAncho(prod.PRO_ANCHO_CM?.toString() || "");
      setProfundidad(prod.PRO_PROFUNDIDAD_CM?.toString() || "");
      // Nota: Si el backend no te devuelve CAT_CATEGORIA directamente en el producto,
      // el usuario tendrá que re-seleccionar la categoría al editar el tipo.
      setTipoId(prod.TIP_TIPO || null);
    } else {
      setIsEditing(false);
      setReferencia("");
      setNombre("");
      setColor("");
      setPeso("");
      setDescripcion("");
      setCategoriaId(null);
      setTipoId(null);
      setMaterialId(null);
      setAlto("");
      setAncho("");
      setProfundidad("");
    }
    setModalVisible(true);
  };

  const cerrarModal = () => {
    setModalVisible(false);
  };

  // --- LÓGICA DEL SELECTOR GENÉRICO ---
  const abrirSelector = (tipo: "categoria" | "tipo" | "material") => {
    let rawData: { id: number; nombre: string }[] = [];
    if (tipo === "categoria")
      rawData = categorias.map((c) => ({
        id: c.CAT_CATEGORIA,
        nombre: c.CAT_DESCRIPCION,
      }));
    if (tipo === "tipo") {
      if (!categoriaId) {
        Alert.alert("Atención", "Primero selecciona una categoría");
        return;
      }
      rawData = tipos.map((t) => ({
        id: t.TIP_TIPO,
        nombre: t.TIP_DESCRIPCION,
      }));
    }
    if (tipo === "material")
      rawData = materiales.map((m) => ({
        id: m.MAT_MATERIAL,
        nombre: m.MAT_DESCRIPCION,
      }));

    setSelectorData(rawData);
    setSelectorType(tipo);
    setModalSelectorVisible(true);
  };

  const seleccionarOpcion = (id: number) => {
    if (selectorType === "categoria") {
      setCategoriaId(id);
      setTipoId(null);
    }
    if (selectorType === "tipo") setTipoId(id);
    if (selectorType === "material") setMaterialId(id);
    setModalSelectorVisible(false);
  };

  const getNombreSeleccionado = (
    tipo: "categoria" | "tipo" | "material",
    id: number | null,
  ) => {
    if (!id) return `Seleccione ${tipo}...`;
    if (tipo === "categoria")
      return (
        categorias.find((c) => c.CAT_CATEGORIA === id)?.CAT_DESCRIPCION || ""
      );
    if (tipo === "tipo")
      return (
        tipos.find((t) => t.TIP_TIPO === id)?.TIP_DESCRIPCION ||
        "Tipo previo (Seleccione Cat)"
      );
    if (tipo === "material")
      return (
        materiales.find((m) => m.MAT_MATERIAL === id)?.MAT_DESCRIPCION || ""
      );
  };

  // --- ENCABEZADOS Y RENDER DE LISTA ---
  const renderHeader = () => (
    <View>
      <View style={styles.searchContainer}>
        <TextInput
          style={styles.searchInput}
          placeholder="Buscar producto..."
          value={search}
          onChangeText={setSearch}
        />
        <TouchableOpacity style={styles.btnSearch} onPress={handleBuscar}>
          <Text style={styles.btnTextWhite}>Buscar</Text>
        </TouchableOpacity>
      </View>
      <TouchableOpacity style={styles.btnAdd} onPress={() => abrirModal()}>
        <Text style={styles.btnTextWhite}>🛋️ + Nuevo Producto</Text>
      </TouchableOpacity>
    </View>
  );

  const renderItem = ({ item }: { item: Producto }) => (
    <View style={styles.card}>
      <View style={styles.cardInfo}>
        <Text style={styles.badgeId}>Ref: {item.PRO_REFERENCIA}</Text>
        <Text style={styles.title}>{item.PRO_NOMBRE}</Text>
        <View style={styles.detailsRow}>
          <Text style={styles.detailPill}>
            🏷️ {item.TIP_DESCRIPCION || "N/A"}
          </Text>
          <Text style={styles.detailPill}>
            🧱 {item.MAT_DESCRIPCION || "N/A"}
          </Text>
        </View>
        <View style={styles.detailsRow}>
          <Text style={styles.detailSub}>
            🎨 Color: {item.PRO_COLOR || "N/A"}
          </Text>
          <Text style={styles.detailSub}>
            ⚖️ Peso: {item.PRO_PESO ? `${item.PRO_PESO} kg` : "N/A"}
          </Text>
        </View>
        <Text style={styles.price}>
          Q {item.PRO_PRECIO ? Number(item.PRO_PRECIO).toFixed(2) : "0.00"}
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
          onPress={() => handleEliminar(item.PRO_REFERENCIA)}
        >
          <Text style={styles.btnTextRed}>🗑 Eliminar</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  // Formulario Renderizado como ListHeaderComponent para scroll natural sin <ScrollView>
  const renderFormulario = () => (
    <View style={styles.modalContent}>
      <Text style={styles.modalTitle}>
        {isEditing ? "Editar Producto" : "Nuevo Producto"}
      </Text>

      <Text style={styles.label}>Referencia *</Text>
      <TextInput
        style={[styles.input, isEditing && { backgroundColor: "#f0f0f0" }]}
        value={referencia}
        onChangeText={setReferencia}
        placeholder="Ej: MUE-001"
        editable={!isEditing}
      />

      <Text style={styles.label}>Nombre *</Text>
      <TextInput style={styles.input} value={nombre} onChangeText={setNombre} />

      <Text style={styles.label}>Descripción</Text>
      <TextInput
        style={[styles.input, { height: 60, textAlignVertical: "top" }]}
        value={descripcion}
        onChangeText={setDescripcion}
        multiline
      />

      <Text style={styles.label}>Categoría *</Text>
      <TouchableOpacity
        style={styles.selectorInput}
        onPress={() => abrirSelector("categoria")}
      >
        <Text
          style={categoriaId ? styles.selectorText : styles.selectorPlaceholder}
        >
          {getNombreSeleccionado("categoria", categoriaId)}
        </Text>
      </TouchableOpacity>

      <View style={styles.rowInputs}>
        <View style={{ flex: 1, marginRight: 5 }}>
          <Text style={styles.label}>Tipo *</Text>
          <TouchableOpacity
            style={styles.selectorInput}
            onPress={() => abrirSelector("tipo")}
          >
            <Text
              style={tipoId ? styles.selectorText : styles.selectorPlaceholder}
            >
              {getNombreSeleccionado("tipo", tipoId)}
            </Text>
          </TouchableOpacity>
        </View>
        <View style={{ flex: 1, marginLeft: 5 }}>
          <Text style={styles.label}>Material *</Text>
          <TouchableOpacity
            style={styles.selectorInput}
            onPress={() => abrirSelector("material")}
          >
            <Text
              style={
                materialId ? styles.selectorText : styles.selectorPlaceholder
              }
            >
              {getNombreSeleccionado("material", materialId)}
            </Text>
          </TouchableOpacity>
        </View>
      </View>

      <View style={styles.rowInputs}>
        <View style={{ flex: 1, marginRight: 5 }}>
          <Text style={styles.label}>Color</Text>
          <TextInput
            style={styles.input}
            value={color}
            onChangeText={setColor}
          />
        </View>
        <View style={{ flex: 1, marginLeft: 5 }}>
          <Text style={styles.label}>Peso (kg)</Text>
          <TextInput
            style={styles.input}
            value={peso}
            onChangeText={setPeso}
            keyboardType="numeric"
          />
        </View>
      </View>

      <View style={styles.rowInputs}>
        <View style={{ flex: 1, marginRight: 4 }}>
          <Text style={styles.label}>Alto (cm)</Text>
          <TextInput
            style={styles.input}
            value={alto}
            onChangeText={setAlto}
            keyboardType="numeric"
          />
        </View>
        <View style={{ flex: 1, marginHorizontal: 4 }}>
          <Text style={styles.label}>Ancho</Text>
          <TextInput
            style={styles.input}
            value={ancho}
            onChangeText={setAncho}
            keyboardType="numeric"
          />
        </View>
        <View style={{ flex: 1, marginLeft: 4 }}>
          <Text style={styles.label}>Prof.</Text>
          <TextInput
            style={styles.input}
            value={profundidad}
            onChangeText={setProfundidad}
            keyboardType="numeric"
          />
        </View>
      </View>

      <View style={styles.modalActions}>
        <TouchableOpacity style={styles.btnCancel} onPress={cerrarModal}>
          <Text style={styles.btnTextDark}>Cancelar</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.btnSave} onPress={handleGuardar}>
          <Text style={styles.btnTextWhite}>💾 Guardar</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      <FlatList
        data={productos}
        keyExtractor={(item) => item.PRO_REFERENCIA}
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
              <Text style={styles.emptyEmoji}>🛋️</Text>
              <Text style={styles.emptyText}>
                No hay productos registrados.
              </Text>
            </View>
          )
        }
      />

      {/* Modal Principal del Formulario con truco FlatList */}
      <Modal visible={modalVisible} animationType="slide" transparent={true}>
        <View style={styles.modalOverlay}>
          <View style={styles.formContainer}>
            <FlatList
              data={[]}
              renderItem={() => null}
              ListHeaderComponent={renderFormulario}
              showsVerticalScrollIndicator={false}
            />
          </View>
        </View>
      </Modal>

      {/* Modal Genérico para Listas Desplegables */}
      <Modal
        visible={modalSelectorVisible}
        animationType="fade"
        transparent={true}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.selectorContainer}>
            <Text style={styles.modalTitle}>Seleccionar Opción</Text>
            <FlatList
              data={selectorData}
              keyExtractor={(item) => item.id.toString()}
              showsVerticalScrollIndicator={false}
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={styles.selectorItem}
                  onPress={() => seleccionarOpcion(item.id)}
                >
                  <Text style={styles.selectorItemText}>{item.nombre}</Text>
                </TouchableOpacity>
              )}
              ListEmptyComponent={
                <Text style={{ textAlign: "center", padding: 20 }}>
                  No hay datos disponibles.
                </Text>
              }
            />
            <TouchableOpacity
              style={styles.btnCancelSelector}
              onPress={() => setModalSelectorVisible(false)}
            >
              <Text style={styles.btnTextRed}>Cerrar</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#fdf8f3", padding: 16 },
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
  title: { fontSize: 16, color: "#444", fontWeight: "bold", marginBottom: 6 },
  detailsRow: { flexDirection: "row", gap: 10, marginBottom: 4 },
  detailPill: {
    fontSize: 13,
    color: "#5C3A1E",
    backgroundColor: "#f0f4f8",
    paddingHorizontal: 6,
    borderRadius: 6,
    overflow: "hidden",
  },
  detailSub: { fontSize: 12, color: "#777" },
  price: { fontSize: 16, fontWeight: "bold", color: "#276749", marginTop: 6 },

  actions: { flexDirection: "column", gap: 8, justifyContent: "center" },
  btnEdit: {
    backgroundColor: "#fdf6ec",
    padding: 8,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    alignItems: "center",
  },
  btnTextGold: { color: "#C9973A", fontSize: 12, fontWeight: "bold" },
  btnDelete: {
    backgroundColor: "#fff5f5",
    padding: 8,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#fed7d7",
    alignItems: "center",
  },
  btnTextRed: { color: "#e53e3e", fontSize: 12, fontWeight: "bold" },

  emptyState: { alignItems: "center", marginTop: 40 },
  emptyEmoji: { fontSize: 48, marginBottom: 10 },
  emptyText: { color: "#aaa", fontSize: 16 },

  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    justifyContent: "center",
    padding: 16,
  },
  formContainer: {
    backgroundColor: "white",
    borderRadius: 12,
    maxHeight: "90%",
  },
  modalContent: { padding: 20 },
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
    marginBottom: 12,
  },
  rowInputs: { flexDirection: "row", justifyContent: "space-between" },

  selectorInput: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    paddingHorizontal: 12,
    height: 42,
    justifyContent: "center",
    marginBottom: 12,
  },
  selectorText: { color: "#333", fontSize: 14 },
  selectorPlaceholder: { color: "#999", fontSize: 14 },

  selectorContainer: {
    backgroundColor: "white",
    padding: 20,
    borderRadius: 12,
    maxHeight: "60%",
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

  modalActions: {
    flexDirection: "row",
    justifyContent: "flex-end",
    gap: 10,
    marginTop: 10,
  },
  btnCancel: {
    padding: 10,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  btnSave: { backgroundColor: "#C9973A", padding: 10, borderRadius: 8 },
  btnTextDark: { color: "#5C3A1E", fontWeight: "bold" },
});
