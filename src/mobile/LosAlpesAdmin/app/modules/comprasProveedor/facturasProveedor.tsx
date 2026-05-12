import React, { useEffect, useState, useMemo } from "react";
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
  actualizarFactura,
  eliminarFactura,
  FacturaProveedor,
  getFacturasProveedor,
  registrarFactura,
} from "../../../services/comprasProveedor/facturasProveedor";

import {
  getOrdenesCompra,
  OrdenCompra,
} from "../../../services/comprasProveedor/ordenesCompra";

type Modo = "nuevo" | "editar";

export default function FacturasProveedorScreen() {
  const [facturas, setFacturas] = useState<FacturaProveedor[]>([]);
  const [ordenes, setOrdenes] = useState<OrdenCompra[]>([]);
  const [loading, setLoading] = useState(false);

  // =========================
  // FILTROS
  // =========================
  const [search, setSearch] = useState("");
  const [filtroTexto, setFiltroTexto] = useState("");

  const [fechaDesde, setFechaDesde] = useState<Date | null>(null);
  const [fechaHasta, setFechaHasta] = useState<Date | null>(null);

  const [showDesde, setShowDesde] = useState(false);
  const [showHasta, setShowHasta] = useState(false);

  // =========================
  // MODAL
  // =========================
  const [modalVisible, setModalVisible] = useState(false);
  const [modo, setModo] = useState<Modo>("nuevo");

  const [orcKeySel, setOrcKeySel] = useState("");
  const [codigoFac, setCodigoFac] = useState("");

  const [ordenSel, setOrdenSel] = useState("");
  const [showOrdenes, setShowOrdenes] = useState(false);

  // =========================
  // CARGA
  // =========================
  useEffect(() => {
    cargar();
    cargarOrdenes();
  }, []);

  const cargar = async () => {
    setLoading(true);

    try {
      const data = await getFacturasProveedor();
      setFacturas(data);
    } catch (e: any) {
      Alert.alert("Error", e.message ?? "No se pudieron cargar las facturas.");
    } finally {
      setLoading(false);
    }
  };

  const cargarOrdenes = async () => {
    try {
      const data = await getOrdenesCompra();
      setOrdenes(data);
    } catch {}
  };

  // =========================
  // FECHAS
  // =========================
  const formatDate = (date: Date | null) => {
    if (!date) return "";

    const day = String(date.getDate()).padStart(2, "0");
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const year = date.getFullYear();

    return `${day}/${month}/${year}`;
  };

  const parseFecha = (fecha: string) => {
    try {
      if (!fecha) return null;

      // Intento directo
      const fechaDirecta = new Date(fecha);

      if (!isNaN(fechaDirecta.getTime())) {
        return fechaDirecta;
      }

      // Limpia hora
      const clean = fecha.split(" ")[0];

      // YYYY-MM-DD
      if (clean.includes("-")) {
        const partes = clean.split("-");

        if (partes.length === 3) {
          const [y, m, d] = partes;

          return new Date(Number(y), Number(m) - 1, Number(d));
        }
      }

      // DD/MM/YYYY
      if (clean.includes("/")) {
        const partes = clean.split("/");

        if (partes.length === 3) {
          const [d, m, y] = partes;

          return new Date(Number(y), Number(m) - 1, Number(d));
        }
      }

      return null;
    } catch {
      return null;
    }
  };

  // =========================
  // FILTRAR
  // =========================
  const handleFiltrar = () => {
    setFiltroTexto(search.trim().toLowerCase());
  };

  const handleLimpiar = () => {
    setSearch("");
    setFiltroTexto("");

    setFechaDesde(null);
    setFechaHasta(null);
  };

  const facturasFiltradas = useMemo(() => {
    return facturas.filter((item) => {
      const texto = filtroTexto.toLowerCase();

      const coincideTexto =
        texto === "" ||
        item.FACPRO_CODIGO_FACTURA?.toLowerCase().includes(texto) ||
        item.ORC_ORDEN_COMPRA?.toLowerCase().includes(texto) ||
        item.ORC_CODIGO?.toLowerCase().includes(texto);

      let coincideFecha = true;

      const fechaFactura = parseFecha(item.FACPRO_FECHA);

      if (fechaFactura) {
        if (fechaDesde && fechaFactura < fechaDesde) {
          coincideFecha = false;
        }

        if (fechaHasta) {
          const hasta = new Date(fechaHasta);
          hasta.setHours(23, 59, 59, 999);

          if (fechaFactura > hasta) {
            coincideFecha = false;
          }
        }
      }

      return coincideTexto && coincideFecha;
    });
  }, [facturas, filtroTexto, fechaDesde, fechaHasta]);

  // =========================
  // CRUD
  // =========================
  const handleGuardar = async () => {
    if (modo === "nuevo" && !ordenSel) {
      Alert.alert("Atención", "Selecciona la orden de compra.");
      return;
    }

    if (!codigoFac.trim()) {
      Alert.alert("Atención", "Ingresa el código de factura.");
      return;
    }

    setLoading(true);

    try {
      if (modo === "nuevo") {
        await registrarFactura(ordenSel, codigoFac.trim());

        Alert.alert("Éxito", "Factura registrada correctamente.");
      } else {
        await actualizarFactura(orcKeySel, orcKeySel, codigoFac.trim());

        Alert.alert("Éxito", "Factura actualizada correctamente.");
      }

      cerrarModal();
      cargar();
    } catch (e: any) {
      Alert.alert("Error", e.message ?? "Error al guardar.");
    } finally {
      setLoading(false);
    }
  };

  const handleEditar = (item: FacturaProveedor) => {
    setModo("editar");

    setOrcKeySel(item.ORC_ORDEN_COMPRA);
    setCodigoFac(item.FACPRO_CODIGO_FACTURA);

    setOrdenSel("");

    setModalVisible(true);
  };

  const handleEliminar = (orcKey: string, codigo: string) => {
    Alert.alert("Eliminar", `¿Eliminar la factura "${codigo}"?`, [
      {
        text: "Cancelar",
        style: "cancel",
      },
      {
        text: "Eliminar",
        style: "destructive",
        onPress: async () => {
          try {
            setLoading(true);

            await eliminarFactura(orcKey);

            Alert.alert("Éxito", "Factura eliminada correctamente.");

            cargar();
          } catch (e: any) {
            Alert.alert("Error", e.message ?? "No se pudo eliminar.");
          } finally {
            setLoading(false);
          }
        },
      },
    ]);
  };

  const cerrarModal = () => {
    setModalVisible(false);

    setModo("nuevo");

    setOrcKeySel("");
    setCodigoFac("");

    setOrdenSel("");
    setShowOrdenes(false);
  };

  // =========================
  // HEADER
  // =========================
  const renderHeader = () => {
    return (
      <View>
        <View style={styles.filterCard}>
          <TextInput
            style={styles.searchInput}
            placeholder="Buscar factura, orden o código..."
            value={search}
            onChangeText={setSearch}
            autoCorrect={false}
            autoCapitalize="none"
            blurOnSubmit={false}
            returnKeyType="search"
          />

          <View style={styles.searchRow}>
            <View style={{ flex: 1 }}>
              <Text style={styles.label}>DESDE</Text>

              <TouchableOpacity
                style={styles.dateBtn}
                onPress={() => setShowDesde(true)}
              >
                <Text style={styles.dateText}>
                  {fechaDesde ? formatDate(fechaDesde) : "Seleccionar fecha"}
                </Text>
              </TouchableOpacity>
            </View>

            <View style={{ flex: 1 }}>
              <Text style={styles.label}>HASTA</Text>

              <TouchableOpacity
                style={styles.dateBtn}
                onPress={() => setShowHasta(true)}
              >
                <Text style={styles.dateText}>
                  {fechaHasta ? formatDate(fechaHasta) : "Seleccionar fecha"}
                </Text>
              </TouchableOpacity>
            </View>
          </View>

          <View style={styles.searchRow}>
            <TouchableOpacity
              style={[styles.btnSearch, { flex: 1 }]}
              onPress={handleFiltrar}
            >
              <Text style={styles.btnTextWhite}>Filtrar</Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={[styles.btnOutline, { flex: 1 }]}
              onPress={handleLimpiar}
            >
              <Text style={styles.btnTextDark}>Limpiar</Text>
            </TouchableOpacity>
          </View>
        </View>

        <TouchableOpacity
          style={styles.btnAdd}
          onPress={() => {
            setModo("nuevo");
            setModalVisible(true);
          }}
        >
          <Text style={styles.btnTextWhite}>+ Registrar Factura</Text>
        </TouchableOpacity>
      </View>
    );
  };

  // =========================
  // ITEM
  // =========================
  const renderItem = ({ item }: { item: FacturaProveedor }) => {
    return (
      <View style={styles.card}>
        <View style={styles.cardInfo}>
          <Text style={styles.badgeId}>
            Factura: {item.FACPRO_CODIGO_FACTURA}
          </Text>

          <Text style={styles.cardTitle}>
            🛒 Orden: {item.ORC_ORDEN_COMPRA}
          </Text>

          <Text style={styles.cardSub}>Código: {item.ORC_CODIGO}</Text>

          <Text style={styles.cardSub}>
            📅 {formatDate(parseFecha(item.FACPRO_FECHA))}
          </Text>
        </View>

        <View style={styles.actions}>
          <TouchableOpacity
            style={styles.btnEdit}
            onPress={() => handleEditar(item)}
          >
            <Text style={styles.btnTextGold}>✏️</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.btnDelete}
            onPress={() =>
              handleEliminar(item.ORC_ORDEN_COMPRA, item.FACPRO_CODIGO_FACTURA)
            }
          >
            <Text style={styles.btnTextRed}>🗑</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  };

  // =========================
  // RETURN
  // =========================
  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <FlatList
          data={facturasFiltradas}
          keyExtractor={(item, index) => `${item.ORC_ORDEN_COMPRA}-${index}`}
          renderItem={renderItem}
          ListHeaderComponent={renderHeader()}
          keyboardShouldPersistTaps="always"
          removeClippedSubviews={false}
          contentContainerStyle={{
            paddingBottom: 20,
          }}
          ListEmptyComponent={
            loading ? (
              <ActivityIndicator
                size="large"
                color="#C9973A"
                style={{ marginTop: 20 }}
              />
            ) : (
              <Text style={styles.emptyText}>No hay facturas registradas.</Text>
            )
          }
        />

        {showDesde && (
          <DateTimePicker
            value={fechaDesde || new Date()}
            mode="date"
            display="default"
            onChange={(event, date) => {
              setShowDesde(false);

              if (date) {
                setFechaDesde(date);
              }
            }}
          />
        )}

        {showHasta && (
          <DateTimePicker
            value={fechaHasta || new Date()}
            mode="date"
            display="default"
            onChange={(event, date) => {
              setShowHasta(false);

              if (date) {
                setFechaHasta(date);
              }
            }}
          />
        )}

        <Modal visible={modalVisible} animationType="slide" transparent>
          <View style={styles.modalOverlay}>
            <View style={styles.modalContent}>
              <Text style={styles.modalTitle}>
                {modo === "nuevo"
                  ? "Registrar Factura"
                  : `Editar Factura — Orden: ${orcKeySel}`}
              </Text>

              {modo === "nuevo" ? (
                <>
                  <Text style={styles.label}>Orden de Compra *</Text>

                  <TouchableOpacity
                    style={styles.selector}
                    onPress={() => setShowOrdenes(!showOrdenes)}
                  >
                    <Text
                      style={{
                        color: ordenSel ? "#333" : "#aaa",
                      }}
                    >
                      {ordenSel
                        ? (ordenes.find((o) => o.ORC_KEY === ordenSel)
                            ?.CODIGO ?? ordenSel)
                        : "-- Seleccione una orden --"}
                    </Text>

                    <Text>▼</Text>
                  </TouchableOpacity>

                  {showOrdenes && (
                    <ScrollView
                      style={[styles.dropdownList, { maxHeight: 160 }]}
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
                          <Text
                            style={{
                              color: "#333",
                              fontWeight: "bold",
                            }}
                          >
                            {o.CODIGO}
                          </Text>

                          <Text
                            style={{
                              color: "#888",
                              fontSize: 11,
                            }}
                          >
                            {o.PROVEEDOR}
                          </Text>
                        </TouchableOpacity>
                      ))}
                    </ScrollView>
                  )}
                </>
              ) : (
                <View style={styles.readonlyField}>
                  <Text style={styles.label}>Orden de Compra</Text>

                  <Text style={styles.readonlyVal}>{orcKeySel}</Text>
                </View>
              )}

              <Text style={styles.label}>Código / Número de Factura *</Text>

              <TextInput
                style={styles.input}
                value={codigoFac}
                onChangeText={setCodigoFac}
                placeholder="Ej: FAC-2026-001"
                autoCapitalize="characters"
              />

              <View style={styles.modalActions}>
                <TouchableOpacity
                  style={styles.btnCancel}
                  onPress={cerrarModal}
                >
                  <Text style={styles.btnTextDark}>✕ Cancelar</Text>
                </TouchableOpacity>

                <TouchableOpacity
                  style={styles.btnSave}
                  onPress={handleGuardar}
                  disabled={loading}
                >
                  <Text style={styles.btnTextWhite}>
                    💾 {modo === "nuevo" ? "Guardar" : "Actualizar"}
                  </Text>
                </TouchableOpacity>
              </View>
            </View>
          </View>
        </Modal>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: "#fdf8f3",
  },

  container: {
    flex: 1,
    padding: 16,
  },

  filterCard: {
    backgroundColor: "white",
    borderRadius: 12,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    padding: 14,
    marginBottom: 12,
  },

  searchInput: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    paddingHorizontal: 12,
    height: 52,
    marginBottom: 10,
    fontSize: 16,
  },

  searchRow: {
    flexDirection: "row",
    gap: 8,
    marginTop: 8,
  },

  label: {
    fontSize: 11,
    color: "#5C3A1E",
    fontWeight: "bold",
    marginBottom: 4,
  },

  dateBtn: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    paddingHorizontal: 12,
    justifyContent: "center",
    height: 50,
  },

  dateText: {
    color: "#333",
    fontSize: 15,
  },

  btnSearch: {
    backgroundColor: "#C9973A",
    justifyContent: "center",
    alignItems: "center",
    borderRadius: 8,
    height: 50,
  },

  btnOutline: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    justifyContent: "center",
    alignItems: "center",
    borderRadius: 8,
    height: 50,
  },

  btnTextWhite: {
    color: "white",
    fontWeight: "bold",
    fontSize: 16,
  },

  btnTextDark: {
    color: "#5C3A1E",
    fontWeight: "bold",
    fontSize: 16,
  },

  btnAdd: {
    backgroundColor: "#5C3A1E",
    padding: 14,
    borderRadius: 10,
    alignItems: "center",
    marginBottom: 16,
  },

  card: {
    backgroundColor: "white",
    padding: 16,
    borderRadius: 12,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    flexDirection: "row",
  },

  cardInfo: {
    flex: 1,
  },

  badgeId: {
    backgroundColor: "#fdf6ec",
    color: "#C9973A",
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
    fontSize: 12,
    alignSelf: "flex-start",
    marginBottom: 6,
  },

  cardTitle: {
    fontSize: 15,
    color: "#333",
    fontWeight: "bold",
    marginBottom: 2,
  },

  cardSub: {
    fontSize: 13,
    color: "#888",
    marginTop: 2,
  },

  actions: {
    justifyContent: "center",
    gap: 8,
  },

  btnEdit: {
    backgroundColor: "#fdf6ec",
    padding: 10,
    borderRadius: 8,
  },

  btnDelete: {
    backgroundColor: "#fff5f5",
    padding: 10,
    borderRadius: 8,
  },

  btnTextGold: {
    color: "#C9973A",
    fontSize: 16,
  },

  btnTextRed: {
    color: "#e53e3e",
    fontSize: 16,
  },

  emptyText: {
    textAlign: "center",
    color: "#aaa",
    marginTop: 20,
  },

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
  },

  modalTitle: {
    fontSize: 18,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 16,
  },

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

  readonlyField: {
    marginBottom: 12,
  },

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
  },
});
