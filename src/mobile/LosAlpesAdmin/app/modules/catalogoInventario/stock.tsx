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
    eliminarStock,
    entradaStock,
    getStockList,
    getStockPorProducto,
    guardarStock,
    Stock,
} from "../../services/catalogoInventario/stock";

export default function StockScreen() {
  const [stockOriginal, setStockOriginal] = useState<Stock[]>([]);
  const [stockFiltrado, setStockFiltrado] = useState<Stock[]>([]);
  const [loading, setLoading] = useState(false);

  // Filtro
  const [searchProducto, setSearchProducto] = useState("");

  // Estado del Modal Formulario
  const [modalVisible, setModalVisible] = useState(false);
  const [isEditing, setIsEditing] = useState(false);

  // Campos del formulario
  const [hipHistorialPrecio, setHipHistorialPrecio] = useState("");
  const [minimo, setMinimo] = useState("");
  const [maximo, setMaximo] = useState("");
  const [disponible, setDisponible] = useState("");

  // Campo exclusivo para la entrada de mercancía (Paso 4 de tu ASPX)
  const [cantidadEntrada, setCantidadEntrada] = useState("");

  useEffect(() => {
    cargarStock();
  }, []);

  // Efecto para filtrar localmente en tiempo real (más rápido para el usuario)
  useEffect(() => {
    if (searchProducto.trim() === "") {
      setStockFiltrado(stockOriginal);
    } else {
      const filtrados = stockOriginal.filter(
        (item) =>
          (item.PRO_NOMBRE || "")
            .toLowerCase()
            .includes(searchProducto.toLowerCase()) ||
          (item.PRO_REFERENCIA || "")
            .toLowerCase()
            .includes(searchProducto.toLowerCase()),
      );
      setStockFiltrado(filtrados);
    }
  }, [searchProducto, stockOriginal]);

  const cargarStock = async () => {
    setLoading(true);
    try {
      const data = await getStockList();
      setStockOriginal(data);
      setStockFiltrado(data);
    } catch (error) {
      Alert.alert("Error", "No se pudo cargar el control de stock");
    } finally {
      setLoading(false);
    }
  };

  const handleBuscarBackend = async () => {
    if (!searchProducto.trim()) return cargarStock();
    setLoading(true);
    try {
      const data = await getStockPorProducto(searchProducto);
      setStockOriginal(data);
      setStockFiltrado(data);
    } catch (error) {
      Alert.alert("Error", "No se pudo realizar la búsqueda");
    } finally {
      setLoading(false);
    }
  };

  const handleGuardarLimites = async () => {
    if (!hipHistorialPrecio || !minimo || !maximo || !disponible) {
      Alert.alert("Atención", "Todos los límites son obligatorios");
      return;
    }
    setLoading(true);
    try {
      await guardarStock(
        Number(hipHistorialPrecio),
        Number(minimo),
        Number(maximo),
        Number(disponible),
      );
      Alert.alert("Éxito", "Límites de stock guardados correctamente");
      cerrarModal();
      cargarStock();
    } catch (error) {
      Alert.alert("Error", "Ocurrió un error al guardar los límites");
    } finally {
      setLoading(false);
    }
  };

  const handleEntradaMercancia = async () => {
    if (!cantidadEntrada || Number(cantidadEntrada) <= 0) {
      Alert.alert("Atención", "Ingresa una cantidad válida mayor a 0");
      return;
    }
    setLoading(true);
    try {
      await entradaStock(Number(hipHistorialPrecio), Number(cantidadEntrada));
      Alert.alert("Éxito", `Se agregaron ${cantidadEntrada} unidades al stock`);
      setCantidadEntrada(""); // Limpiamos el campo
      cerrarModal();
      cargarStock();
    } catch (error) {
      Alert.alert("Error", "No se pudo registrar la entrada");
    } finally {
      setLoading(false);
    }
  };

  const handleEliminar = (id: number) => {
    Alert.alert("Eliminar Stock", "¿Estás seguro de eliminar este registro?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Eliminar",
        style: "destructive",
        onPress: async () => {
          try {
            setLoading(true);
            await eliminarStock(id);
            Alert.alert("Éxito", "Registro eliminado");
            cargarStock();
          } catch (error) {
            Alert.alert("Error", "No se pudo eliminar el registro");
            setLoading(false);
          }
        },
      },
    ]);
  };

  const abrirModal = (item?: Stock) => {
    if (item) {
      setIsEditing(true);
      setHipHistorialPrecio(item.HIP_HISTORIAL_PRECIO.toString());
      setMinimo(item.STO_MINIMO?.toString() || "0");
      setMaximo(item.STO_MAXIMO?.toString() || "0");
      setDisponible(item.STO_DISPONIBLE?.toString() || "0");
      setCantidadEntrada("");
    } else {
      setIsEditing(false);
      setHipHistorialPrecio("");
      setMinimo("0");
      setMaximo("0");
      setDisponible("0");
      setCantidadEntrada("");
    }
    setModalVisible(true);
  };

  const cerrarModal = () => {
    setModalVisible(false);
  };

  // Lógica de colores según el estado del stock (Como en tu ASPX)
  const getEstadoStock = (disp: number, min: number, max: number) => {
    if (disp <= min)
      return {
        texto: "BAJO",
        color: "#c53030",
        bg: "#fff5f5",
        border: "#fed7d7",
      };
    if (disp >= max)
      return {
        texto: "ALTO",
        color: "#C9973A",
        bg: "#fdf6ec",
        border: "#e8d0a0",
      };
    return {
      texto: "NORMAL",
      color: "#276749",
      bg: "#f0fff4",
      border: "#9ae6b4",
    };
  };

  // --- ENCABEZADOS Y RENDER DE LISTA ---
  const renderHeader = () => (
    <View>
      <View style={styles.modHeader}>
        <View style={{ flex: 1 }}>
          <Text style={styles.modTitle}>Control de Stock</Text>
          <Text style={styles.modSubtitle}>
            Gestiona límites y registra entradas de mercancía.
          </Text>
        </View>
        <Text style={styles.modIcon}>📦</Text>
      </View>

      <View style={styles.searchContainer}>
        <TextInput
          style={styles.searchInput}
          placeholder="Buscar por producto o referencia..."
          value={searchProducto}
          onChangeText={setSearchProducto}
        />
        <TouchableOpacity
          style={styles.btnSearch}
          onPress={handleBuscarBackend}
        >
          <Text style={styles.btnTextWhite}>Buscar</Text>
        </TouchableOpacity>
      </View>

      <Text style={styles.contadorText}>
        Mostrando{" "}
        <Text style={styles.contadorBold}>{stockFiltrado.length}</Text>{" "}
        registro(s)
      </Text>

      <TouchableOpacity style={styles.btnAdd} onPress={() => abrirModal()}>
        <Text style={styles.btnTextWhite}>📦 + Inicializar Stock Nuevo</Text>
      </TouchableOpacity>
    </View>
  );

  const renderItem = ({ item }: { item: Stock }) => {
    const estado = getEstadoStock(
      item.STO_DISPONIBLE,
      item.STO_MINIMO,
      item.STO_MAXIMO,
    );

    return (
      <View style={styles.card}>
        <View style={styles.cardHeader}>
          <Text style={styles.title}>
            {item.PRO_NOMBRE || item.PRO_REFERENCIA}
          </Text>
          <View
            style={[
              styles.badgeEstado,
              { backgroundColor: estado.bg, borderColor: estado.border },
            ]}
          >
            <Text
              style={{ color: estado.color, fontSize: 11, fontWeight: "bold" }}
            >
              {estado.texto}
            </Text>
          </View>
        </View>

        <Text style={styles.subtitle}>
          📍 Almacén: {item.ALM_NOMBRE} | Nicho: {item.NIC_NUMERO}
        </Text>

        <View style={styles.stockGrid}>
          <View style={styles.stockBox}>
            <Text style={[styles.stockValue, { color: estado.color }]}>
              {item.STO_DISPONIBLE}
            </Text>
            <Text style={styles.stockLabel}>Disponible</Text>
          </View>
          <View style={styles.stockBox}>
            <Text style={styles.stockValue}>{item.STO_MINIMO}</Text>
            <Text style={styles.stockLabel}>Mínimo</Text>
          </View>
          <View style={styles.stockBox}>
            <Text style={styles.stockValue}>{item.STO_MAXIMO}</Text>
            <Text style={styles.stockLabel}>Máximo</Text>
          </View>
        </View>

        <View style={styles.actions}>
          <TouchableOpacity
            style={styles.btnEdit}
            onPress={() => abrirModal(item)}
          >
            <Text style={styles.btnTextGold}>✏️ Gestionar / Entrada</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.btnDelete}
            onPress={() => handleEliminar(item.HIP_HISTORIAL_PRECIO)}
          >
            <Text style={styles.btnTextRed}>🗑 Eliminar</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  };

  // Formulario Renderizado como ListHeaderComponent para el Modal
  const renderFormulario = () => (
    <View style={styles.modalContent}>
      <Text style={styles.modalTitle}>
        {isEditing ? "Gestionar Stock" : "Nuevo Registro de Stock"}
      </Text>

      <Text style={styles.label}>ID Historial (HIP) *</Text>
      <TextInput
        style={[styles.input, isEditing && { backgroundColor: "#f0f0f0" }]}
        value={hipHistorialPrecio}
        onChangeText={setHipHistorialPrecio}
        placeholder="ID de Precio"
        keyboardType="numeric"
        editable={!isEditing}
      />

      {/* SECCIÓN: ENTRADA DE MERCANCÍA (Solo si estamos editando un stock existente) */}
      {isEditing && (
        <View style={styles.entradaCard}>
          <Text style={styles.entradaTitle}>
            📥 Registrar Entrada de Mercancía
          </Text>
          <View style={styles.rowInputs}>
            <View style={{ flex: 1, marginRight: 8 }}>
              <Text style={styles.label}>Cantidad que ingresa *</Text>
              <TextInput
                style={styles.input}
                value={cantidadEntrada}
                onChangeText={setCantidadEntrada}
                placeholder="0"
                keyboardType="numeric"
              />
            </View>
            <TouchableOpacity
              style={styles.btnGreen}
              onPress={handleEntradaMercancia}
            >
              <Text style={styles.btnTextWhite}>Agregar</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}

      {/* SECCIÓN: LÍMITES */}
      <View style={styles.limitesSection}>
        <Text style={styles.limitesTitle}>⚙️ Ajustar Límites Iniciales</Text>

        <Text style={styles.label}>Disponible Actual</Text>
        <TextInput
          style={[styles.input, { backgroundColor: "#f0f0f0" }]}
          value={disponible}
          onChangeText={setDisponible}
          keyboardType="numeric"
          editable={!isEditing}
        />

        <View style={styles.rowInputs}>
          <View style={{ flex: 1, marginRight: 5 }}>
            <Text style={styles.label}>Mínimo *</Text>
            <TextInput
              style={styles.input}
              value={minimo}
              onChangeText={setMinimo}
              keyboardType="numeric"
            />
          </View>
          <View style={{ flex: 1, marginLeft: 5 }}>
            <Text style={styles.label}>Máximo *</Text>
            <TextInput
              style={styles.input}
              value={maximo}
              onChangeText={setMaximo}
              keyboardType="numeric"
            />
          </View>
        </View>

        <TouchableOpacity style={styles.btnSave} onPress={handleGuardarLimites}>
          <Text style={styles.btnTextWhite}>💾 Guardar Límites</Text>
        </TouchableOpacity>
      </View>

      <TouchableOpacity style={styles.btnCancel} onPress={cerrarModal}>
        <Text style={styles.btnTextDark}>Cerrar</Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <View style={styles.container}>
      <FlatList
        data={stockFiltrado}
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
              <Text style={styles.emptyEmoji}>📦</Text>
              <Text style={styles.emptyText}>No hay stock registrado.</Text>
            </View>
          )
        }
      />

      {/* Modal Principal con truco FlatList */}
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
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#fdf8f3", padding: 16 },

  // Header Style (ASPX replica)
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

  searchContainer: { flexDirection: "row", marginBottom: 10, gap: 8 },
  searchInput: {
    flex: 1,
    backgroundColor: "white",
    borderWidth: 1.5,
    borderColor: "#e0d0b8",
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
  contadorText: {
    fontSize: 12,
    color: "#888",
    marginBottom: 12,
    marginLeft: 4,
  },
  contadorBold: { color: "#5C3A1E", fontWeight: "bold" },

  // Cards de Stock
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
    alignItems: "flex-start",
    marginBottom: 4,
  },
  title: {
    fontSize: 16,
    color: "#444",
    fontWeight: "bold",
    flex: 1,
    paddingRight: 10,
  },
  subtitle: { fontSize: 13, color: "#777", marginBottom: 12 },
  badgeEstado: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
    borderWidth: 1,
    overflow: "hidden",
  },

  stockGrid: {
    flexDirection: "row",
    justifyContent: "space-between",
    backgroundColor: "#f9f9f9",
    padding: 10,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#eee",
    marginBottom: 14,
  },
  stockBox: { alignItems: "center", flex: 1 },
  stockValue: { fontSize: 20, fontWeight: "bold", color: "#333" },
  stockLabel: {
    fontSize: 11,
    color: "#888",
    textTransform: "uppercase",
    marginTop: 2,
  },

  actions: { flexDirection: "row", gap: 8, justifyContent: "flex-end" },
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

  // Modal Style
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
    fontSize: 11,
    color: "#5C3A1E",
    fontWeight: "bold",
    textTransform: "uppercase",
    marginBottom: 4,
  },
  input: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1.5,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 10,
    marginBottom: 12,
  },
  rowInputs: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },

  // Entrada Mercancia Card (Verde)
  entradaCard: {
    backgroundColor: "#f0fff4",
    borderWidth: 1,
    borderColor: "#9ae6b4",
    borderRadius: 8,
    padding: 14,
    marginBottom: 16,
  },
  entradaTitle: {
    color: "#276749",
    fontWeight: "bold",
    fontSize: 13,
    marginBottom: 10,
    textTransform: "uppercase",
  },
  btnGreen: {
    backgroundColor: "#2d7a2d",
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderRadius: 8,
    height: 45,
    justifyContent: "center",
    marginBottom: 12,
  },

  // Límites Section
  limitesSection: {
    backgroundColor: "#fff",
    borderWidth: 1,
    borderColor: "#eee",
    borderRadius: 8,
    padding: 14,
    marginBottom: 16,
  },
  limitesTitle: {
    color: "#555",
    fontWeight: "bold",
    fontSize: 13,
    marginBottom: 10,
    textTransform: "uppercase",
  },

  btnCancel: {
    padding: 12,
    borderRadius: 8,
    borderWidth: 1.5,
    borderColor: "#e8d8c0",
    alignItems: "center",
    marginTop: 10,
  },
  btnSave: {
    backgroundColor: "#C9973A",
    padding: 12,
    borderRadius: 8,
    alignItems: "center",
    marginTop: 8,
  },
  btnTextDark: { color: "#5C3A1E", fontWeight: "bold" },
});
