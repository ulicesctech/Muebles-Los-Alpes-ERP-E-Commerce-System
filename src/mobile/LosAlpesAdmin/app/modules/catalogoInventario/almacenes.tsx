import React, { useEffect, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  FlatList,
  KeyboardAvoidingView,
  Platform,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";

// Importamos el servicio centralizado (Asegúrate de que la ruta sea correcta según tu árbol de carpetas)
import { AlmacenService } from "../../../services/catalogoInventario/almacenService";

export default function AlmacenesScreen() {
  const [almacenes, setAlmacenes] = useState([]);
  const [loading, setLoading] = useState(false);

  // Estados del Formulario
  const [id, setId] = useState(0);
  const [nombre, setNombre] = useState("");
  const [pais, setPais] = useState("");
  const [ubicacion, setUbicacion] = useState("");

  // Estados para el panel de Nichos (solo visible al editar)
  const [nicNumero, setNicNumero] = useState("");
  const [nicZona, setNicZona] = useState("");
  const [nicCaracteristica, setNicCaracteristica] = useState("");

  // Cargar datos al iniciar la pantalla
  useEffect(() => {
    cargarAlmacenes();
  }, []);

  const cargarAlmacenes = async () => {
    setLoading(true);
    try {
      const result = await AlmacenService.listar();
      if (result.status === "success") {
        setAlmacenes(result.data);
      } else {
        Alert.alert("Error", result.message);
      }
    } catch (error: any) {
      Alert.alert(
        "Error de conexión",
        error.message || "No se pudo cargar la lista de almacenes.",
      );
    } finally {
      setLoading(false);
    }
  };

  const limpiarFormulario = () => {
    setId(0);
    setNombre("");
    setPais("");
    setUbicacion("");
  };

  const handleGuardar = async () => {
    if (!nombre || !pais || !ubicacion) {
      Alert.alert("Atención", "Por favor, llena todos los campos del almacén.");
      return;
    }

    setLoading(true);
    try {
      let result;

      // Llamamos al servicio correspondiente según si estamos creando o editando
      if (id === 0) {
        result = await AlmacenService.crear(nombre, pais, ubicacion);
      } else {
        result = await AlmacenService.actualizar(id, nombre, pais, ubicacion);
      }

      if (result.status === "success") {
        Alert.alert("Éxito", result.message);
        limpiarFormulario();
        cargarAlmacenes();
      } else {
        Alert.alert("Error", result.message);
      }
    } catch (error: any) {
      Alert.alert(
        "Error",
        "No se pudo guardar el almacén. Verifica tu conexión.",
      );
    } finally {
      setLoading(false);
    }
  };

  const handleEditar = (almacen: any) => {
    setId(almacen.ALM_ALMACEN);
    setNombre(almacen.ALM_NOMBRE);
    setPais(almacen.ALM_PAIS);
    setUbicacion(almacen.ALM_UBICACION);
  };

  const handleEliminar = (idAlmacen: number) => {
    Alert.alert("Confirmar", "¿Deseas eliminar este almacén?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Eliminar",
        style: "destructive",
        onPress: async () => {
          setLoading(true);
          try {
            const result = await AlmacenService.eliminar(idAlmacen);
            if (result.status === "success") {
              Alert.alert("Eliminado", result.message);
              if (id === idAlmacen) limpiarFormulario(); // Limpiar si estábamos editando el eliminado
              cargarAlmacenes();
            } else {
              Alert.alert("Error", result.message);
            }
          } catch (error: any) {
            Alert.alert("Error", "No se pudo eliminar el almacén.");
          } finally {
            setLoading(false);
          }
        },
      },
    ]);
  };

  // --------------------------------------------------------
  // UI DEL ENCABEZADO (Formulario y Títulos)
  // --------------------------------------------------------
  const renderHeader = () => (
    <View>
      <Text style={styles.pageTitle}>Gestión de Almacenes</Text>

      {/* FORMULARIO */}
      <View style={styles.card}>
        <View style={styles.cardHeader}>
          <Text style={styles.cardHeaderText}>
            {id === 0 ? "Nuevo Almacén" : `Editando Almacén #${id}`}
          </Text>
        </View>
        <View style={styles.cardBody}>
          <Text style={styles.label}>Nombre *</Text>
          <TextInput
            style={styles.input}
            value={nombre}
            onChangeText={setNombre}
            placeholder="Nombre del almacén"
          />

          <Text style={styles.label}>País *</Text>
          <TextInput
            style={styles.input}
            value={pais}
            onChangeText={setPais}
            placeholder="Ej. Guatemala"
          />

          <Text style={styles.label}>Ubicación *</Text>
          <TextInput
            style={styles.input}
            value={ubicacion}
            onChangeText={setUbicacion}
            placeholder="Dirección exacta"
            multiline
          />

          <View style={styles.rowButtons}>
            <TouchableOpacity
              style={styles.btnOutline}
              onPress={limpiarFormulario}
            >
              <Text style={styles.btnOutlineText}>Cancelar</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={styles.btnGold}
              onPress={handleGuardar}
              disabled={loading}
            >
              <Text style={styles.btnGoldText}>
                {loading ? "Guardando..." : "Guardar"}
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>

      {/* PANEL DE NICHOS (Solo si se está editando un almacén) */}
      {id > 0 && (
        <View style={styles.nichosPanel}>
          <Text style={styles.nichosTitle}>Nichos del Almacén</Text>

          <View style={styles.nichoRow}>
            <TextInput
              style={[styles.input, { flex: 1, marginRight: 5 }]}
              placeholder="Número (A-01)"
              value={nicNumero}
              onChangeText={setNicNumero}
            />
            <TextInput
              style={[styles.input, { flex: 1, marginLeft: 5 }]}
              placeholder="Zona"
              value={nicZona}
              onChangeText={setNicZona}
            />
          </View>
          <TextInput
            style={styles.input}
            placeholder="Característica (Ej. Estantería alta)"
            value={nicCaracteristica}
            onChangeText={setNicCaracteristica}
          />

          <TouchableOpacity style={styles.btnGold}>
            <Text style={styles.btnGoldText}>Crear y Asignar Nicho</Text>
          </TouchableOpacity>

          <Text style={styles.emptyState}>
            No hay nichos asignados a este almacén aún.
          </Text>
        </View>
      )}

      {/* TÍTULO DEL LISTADO */}
      <Text style={styles.sectionLabel}>Almacenes Registrados</Text>
    </View>
  );

  // --------------------------------------------------------
  // UI DE CADA ELEMENTO DE LA LISTA
  // --------------------------------------------------------
  const renderItem = ({ item }: { item: any }) => (
    <View style={styles.listItem}>
      <View style={styles.listContent}>
        <View style={styles.badge}>
          <Text style={styles.badgeText}>ID: {item.ALM_ALMACEN}</Text>
        </View>
        <Text style={styles.itemTitle}>{item.ALM_NOMBRE}</Text>
        <Text style={styles.itemText}>📍 {item.ALM_UBICACION}</Text>
        <Text style={styles.itemText}>🌎 {item.ALM_PAIS}</Text>
      </View>
      <View style={styles.listActions}>
        <TouchableOpacity
          style={styles.btnEdit}
          onPress={() => handleEditar(item)}
        >
          <Text style={styles.btnEditText}>Editar</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.btnDelete}
          onPress={() => handleEliminar(item.ALM_ALMACEN)}
        >
          <Text style={styles.btnDeleteText}>Eliminar</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  // --------------------------------------------------------
  // RENDER PRINCIPAL DE LA PANTALLA
  // --------------------------------------------------------
  return (
    <View style={styles.mainWrapper}>
      <KeyboardAvoidingView
        style={styles.keyboardContainer}
        behavior={Platform.OS === "ios" ? "padding" : undefined}
      >
        <FlatList
          data={almacenes}
          keyExtractor={(item) => item.ALM_ALMACEN.toString()}
          renderItem={renderItem}
          ListHeaderComponent={renderHeader()}
          keyboardShouldPersistTaps="handled"
          keyboardDismissMode="none"
          contentContainerStyle={styles.container}
          ListEmptyComponent={
            loading ? (
              <ActivityIndicator
                size="large"
                color="#C9973A"
                style={{ marginTop: 20 }}
              />
            ) : (
              <Text style={styles.emptyState}>
                No hay almacenes registrados en la base de datos.
              </Text>
            )
          }
          ListFooterComponent={<View style={{ height: 40 }} />}
        />
      </KeyboardAvoidingView>
    </View>
  );
}

const styles = StyleSheet.create({
  mainWrapper: { flex: 1, backgroundColor: "#f0ebe0" },
  keyboardContainer: { flex: 1 },
  container: { padding: 15 },
  pageTitle: {
    fontSize: 22,
    color: "#5C3A1E",
    fontWeight: "bold",
    marginBottom: 15,
  },
  card: {
    backgroundColor: "white",
    borderRadius: 12,
    borderColor: "#e8d8c0",
    borderWidth: 1,
    overflow: "hidden",
    marginBottom: 20,
    elevation: 2,
  },
  cardHeader: { backgroundColor: "#5C3A1E", padding: 15 },
  cardHeaderText: { color: "#f0d9a0", fontSize: 16, fontWeight: "bold" },
  cardBody: { padding: 15 },
  label: {
    fontSize: 12,
    fontWeight: "bold",
    color: "#5C3A1E",
    textTransform: "uppercase",
    marginBottom: 5,
  },
  input: {
    backgroundColor: "#fdf8f3",
    borderWidth: 2,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 12,
    fontSize: 14,
    marginBottom: 15,
    color: "#333",
  },
  rowButtons: {
    flexDirection: "row",
    justifyContent: "flex-end",
    gap: 10,
    marginTop: 5,
  },
  btnGold: {
    backgroundColor: "#C9973A",
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 8,
    alignItems: "center",
    flex: 1,
  },
  btnGoldText: { color: "#1a1a1a", fontWeight: "bold", fontSize: 14 },
  btnOutline: {
    backgroundColor: "white",
    borderWidth: 2,
    borderColor: "#e8d8c0",
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 8,
    alignItems: "center",
    flex: 1,
  },
  btnOutlineText: { color: "#5C3A1E", fontWeight: "bold", fontSize: 14 },
  sectionLabel: {
    fontSize: 14,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 10,
    textTransform: "uppercase",
  },
  listItem: {
    backgroundColor: "white",
    borderRadius: 12,
    padding: 15,
    marginBottom: 12,
    borderColor: "#e8d8c0",
    borderWidth: 1,
    elevation: 1,
  },
  listContent: { marginBottom: 10 },
  badge: {
    backgroundColor: "#fdf6ec",
    alignSelf: "flex-start",
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 20,
    borderColor: "#C9973A",
    borderWidth: 1,
    marginBottom: 8,
  },
  badgeText: { color: "#C9973A", fontSize: 10, fontWeight: "bold" },
  itemTitle: {
    fontSize: 18,
    fontWeight: "bold",
    color: "#3a1f0a",
    marginBottom: 5,
  },
  itemText: { fontSize: 13, color: "#666", marginBottom: 3 },
  listActions: {
    flexDirection: "row",
    justifyContent: "flex-end",
    gap: 10,
    borderTopWidth: 1,
    borderTopColor: "#f5ece0",
    paddingTop: 10,
  },
  btnEdit: {
    backgroundColor: "#fdf6ec",
    paddingVertical: 8,
    paddingHorizontal: 15,
    borderRadius: 6,
    borderColor: "#e8d8c0",
    borderWidth: 1,
  },
  btnEditText: { color: "#C9973A", fontWeight: "bold", fontSize: 12 },
  btnDelete: {
    backgroundColor: "#fff5f5",
    paddingVertical: 8,
    paddingHorizontal: 15,
    borderRadius: 6,
    borderColor: "#fed7d7",
    borderWidth: 1,
  },
  btnDeleteText: { color: "#e53e3e", fontWeight: "bold", fontSize: 12 },
  nichosPanel: {
    backgroundColor: "#fdf6ec",
    borderRadius: 12,
    padding: 15,
    borderColor: "#e8d0a0",
    borderWidth: 1,
    marginBottom: 20,
  },
  nichosTitle: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 15,
    borderBottomWidth: 1,
    borderBottomColor: "#e8d0a0",
    paddingBottom: 5,
  },
  nichoRow: { flexDirection: "row", justifyContent: "space-between" },
  emptyState: {
    textAlign: "center",
    color: "#aaa",
    marginTop: 15,
    marginBottom: 15,
    fontStyle: "italic",
  },
});