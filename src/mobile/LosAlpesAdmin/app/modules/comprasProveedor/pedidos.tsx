import React, { useEffect, useRef, useState } from "react";
import { useRouter, useLocalSearchParams } from "expo-router";
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
  PedidoService,
  DetallePedidoService,
} from "../../../services/comprasProveedor/pedidos";
import { buscarDetallesPorPedido } from "../../../services/comprasProveedor/ordenesCompra";

// ─── Tipos ───────────────────────────────────────────────────────────────────
type Pedido = {
  PED_PEDIDO: number;
  PED_CODIGO: string;
  PED_FECHA: string;
  PED_FORMA_PAGO: string;
  PED_TOTAL: number;
};
type FormaPago = { FORMA_PAGO: string; DESCRIPCION: string };
type DetallePedido = {
  DETPE_DETALLE_PEDIDO: number;
  PRO_REFERENCIA: string;
  PRO_NOMBRE: string;
  MATERIAL: string;
  DETPE_CANTIDAD_SOLICITADA: number;
  DETPE_CANTIDAD_RECIBIDA: number;
  HIP_HISTORIAL_PRECIO: number;
  HIP_PRECIO: number;
};
type Producto = { PRO_REFERENCIA: string; PRO_NOMBRE: string };
type Vista = "lista" | "nuevaCabecera" | "detalle";

// Convierte cualquier fecha del backend a DD/MM/YYYY
function formatFecha(fecha?: string | null): string {
  if (!fecha) return "—";
  const clean = fecha.split("T")[0];
  if (clean.includes("-")) {
    const [y, m, d] = clean.split("-");
    return `${d.padStart(2, "0")}/${m.padStart(2, "0")}/${y}`;
  }
  return clean; // ya viene DD/MM/YYYY
}

export default function PedidosScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<{ pedido?: string }>();
  const [pedidos, setPedidos] = useState<Pedido[]>([]);
  const [formasPago, setFormasPago] = useState<FormaPago[]>([]);
  const [productos, setProductos] = useState<Producto[]>([]);
  const [detalles, setDetalles] = useState<DetallePedido[]>([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");
  const [vista, setVista] = useState<Vista>("lista");

  const [pedidoActivo, setPedidoActivo] = useState<number>(0);
  const [cabeceraInfo, setCabeceraInfo] = useState<Pedido | null>(null);
  const [tieneOC, setTieneOC] = useState(false);

  const [formaPagoSel, setFormaPagoSel] = useState("");
  const [showFormaPago, setShowFormaPago] = useState(false);

  const [productoSel, setProductoSel] = useState("");
  const [productoNombre, setProductoNombre] = useState("");
  const [cantSolicitada, setCantSolicitada] = useState("");
  const [showProductos, setShowProductos] = useState(false);

  const [modalCab, setModalCab] = useState(false);
  const [fpCabSel, setFpCabSel] = useState("");
  const [showFpCab, setShowFpCab] = useState(false);

  const [modalItem, setModalItem] = useState(false);
  const [itemEditando, setItemEditando] = useState<DetallePedido | null>(null);
  const [cantEditando, setCantEditando] = useState("");

  const [itemRecibiendoId, setItemRecibiendoId] = useState<number | null>(null);
  const [cantRecibiendo, setCantRecibiendo] = useState("");

  useEffect(() => {
    cargarLista();
    cargarFormasPago();
  }, []);

  const cargarLista = async () => {
    setLoading(true);
    try {
      setPedidos(await PedidoService.listar());
    } catch {
      Alert.alert(
        "😕 Sin conexión",
        "No pudimos cargar los pedidos. Verifica tu conexión e intenta de nuevo.",
      );
    } finally {
      setLoading(false);
    }
  };

  const cargarFormasPago = async () => {
    try {
      setFormasPago(await PedidoService.listarFormasPago());
    } catch {}
  };

  const cargarProductos = async () => {
    try {
      setProductos(await DetallePedidoService.listarTodosProductos());
    } catch {}
  };

  const verificarOC = async (pedId: number): Promise<boolean> => {
    try {
      const dt = await buscarDetallesPorPedido(pedId);
      return Array.isArray(dt) && dt.length > 0;
    } catch {
      return false;
    }
  };

  const normalizarDetalle = (d: any): DetallePedido => ({
    DETPE_DETALLE_PEDIDO: d.DETPE_DETALLE_PEDIDO ?? d.detpe_detalle_pedido,
    PRO_REFERENCIA: d.PRO_REFERENCIA ?? d.pro_referencia ?? "",
    PRO_NOMBRE: d.PRO_NOMBRE ?? d.pro_nombre ?? "—",
    MATERIAL: d.MATERIAL ?? d.material ?? "",
    DETPE_CANTIDAD_SOLICITADA:
      d.DETPE_CANTIDAD_SOLICITADA ?? d.detpe_cantidad_solicitada ?? 0,
    DETPE_CANTIDAD_RECIBIDA:
      d.DETPE_CANTIDAD_RECIBIDA ?? d.detpe_cantidad_recibida ?? 0,
    HIP_HISTORIAL_PRECIO: d.HIP_HISTORIAL_PRECIO ?? d.hip_historial_precio ?? 0,
    HIP_PRECIO: d.HIP_PRECIO ?? d.hip_precio ?? 0,
  });

  const abrirDetalle = async (pedId: number) => {
    setLoading(true);
    try {
      const [dets, cab, tieneOrden] = await Promise.all([
        DetallePedidoService.listarPorPedido(pedId),
        PedidoService.obtener(pedId),
        verificarOC(pedId),
      ]);
      await cargarProductos();
      setPedidoActivo(pedId);
      setDetalles((Array.isArray(dets) ? dets : []).map(normalizarDetalle));
      setCabeceraInfo(Array.isArray(cab) && cab.length > 0 ? cab[0] : null);
      setTieneOC(tieneOrden);
      setVista("detalle");
      if (tieneOrden) {
        Alert.alert(
          "Info",
          "Este pedido tiene una Orden de Compra asociada. No se pueden modificar los productos.",
        );
      }
    } catch {
      Alert.alert(
        "😕 Error al abrir",
        "No pudimos cargar el detalle del pedido. Intenta de nuevo.",
      );
    } finally {
      setLoading(false);
    }
  };

  const handleCrearCabecera = async () => {
    if (!formaPagoSel) {
      Alert.alert("Atención", "Selecciona una forma de pago.");
      return;
    }
    setLoading(true);
    try {
      const res = await PedidoService.crear(formaPagoSel);
      const nuevoId: number = res?.id ?? res?.PED_PEDIDO ?? 0;
      if (!nuevoId) throw new Error("No se obtuvo el ID del pedido.");
      setFormaPagoSel("");
      await abrirDetalle(nuevoId);
      await cargarLista();
      Alert.alert(
        "Éxito",
        "Pedido creado. Agrega al menos un producto antes de finalizar.",
      );
    } catch {
      Alert.alert(
        "😕 Error al crear",
        "No se pudo crear el pedido. Verifica los datos e intenta de nuevo.",
      );
    } finally {
      setLoading(false);
    }
  };

  const handleAgregarProducto = async () => {
    if (!productoSel) {
      Alert.alert("Atención", "Selecciona un producto.");
      return;
    }
    const cant = parseInt(cantSolicitada);
    if (isNaN(cant) || cant <= 0) {
      Alert.alert("Atención", "Ingresa una cantidad válida.");
      return;
    }
    setLoading(true);
    try {
      await DetallePedidoService.insertar(pedidoActivo, productoSel, cant);
      setCantSolicitada("");
      setProductoSel("");
      setProductoNombre("");
      const nuevos = await DetallePedidoService.listarPorPedido(pedidoActivo);
      setDetalles((Array.isArray(nuevos) ? nuevos : []).map(normalizarDetalle));
      await cargarLista();
      Alert.alert("Éxito", "Producto agregado correctamente.");
    } catch {
      Alert.alert(
        "😕 Error al agregar",
        "No se pudo agregar el producto al pedido. Intenta de nuevo.",
      );
    } finally {
      setLoading(false);
    }
  };

  const abrirEditarItem = (det: DetallePedido) => {
    setItemEditando(det);
    setCantEditando(det.DETPE_CANTIDAD_SOLICITADA.toString());
    setModalItem(true);
  };

  const handleGuardarItem = async () => {
    if (!itemEditando) return;
    const cant = parseInt(cantEditando);
    if (isNaN(cant) || cant <= 0) {
      Alert.alert("Atención", "Ingresa una cantidad válida mayor a 0.");
      return;
    }
    setLoading(true);
    try {
      await DetallePedidoService.actualizar(
        itemEditando.DETPE_DETALLE_PEDIDO,
        cant,
        itemEditando.DETPE_CANTIDAD_RECIBIDA ?? 0,
      );
      setModalItem(false);
      setItemEditando(null);
      const nuevos = await DetallePedidoService.listarPorPedido(pedidoActivo);
      setDetalles((Array.isArray(nuevos) ? nuevos : []).map(normalizarDetalle));
      await cargarLista();
      Alert.alert("Éxito", "Cantidad actualizada correctamente.");
    } catch {
      Alert.alert(
        "😕 Error al guardar",
        "No se pudo guardar el cambio. Intenta de nuevo.",
      );
    } finally {
      setLoading(false);
    }
  };

  const abrirRecibirItem = (det: DetallePedido) => {
    if (itemRecibiendoId === det.DETPE_DETALLE_PEDIDO) {
      setItemRecibiendoId(null);
      setCantRecibiendo("");
      return;
    }
    setItemRecibiendoId(det.DETPE_DETALLE_PEDIDO);
    setCantRecibiendo("");
  };

  const handleConfirmarRecepcion = async (det: DetallePedido) => {
    const cant = parseInt(cantRecibiendo);
    const yaRecibida = det.DETPE_CANTIDAD_RECIBIDA ?? 0;
    const solicitada = det.DETPE_CANTIDAD_SOLICITADA;
    const pendiente = solicitada - yaRecibida;
    if (isNaN(cant) || cant <= 0) {
      Alert.alert("Atención", "Ingresa una cantidad mayor a 0.");
      return;
    }
    if (cant > pendiente) {
      Alert.alert(
        "Cantidad excedida",
        `Solo puedes recibir hasta ${pendiente} unidades más.\nSolicitada: ${solicitada} | Ya recibida: ${yaRecibida} | Pendiente: ${pendiente}`,
      );
      return;
    }
    setLoading(true);
    try {
      let precioODP =
        det.HIP_PRECIO != null && Number(det.HIP_PRECIO) > 0
          ? Number(det.HIP_PRECIO)
          : 0;
      if (precioODP === 0) {
        try {
          const ordenes = await buscarDetallesPorPedido(pedidoActivo);
          if (Array.isArray(ordenes) && ordenes.length > 0) {
            const filaODP = ordenes.find((o: any) => {
              const mat = (o.ODP_MATERIAL ?? o.odp_material ?? "").trim();
              const prod = (o.ODP_PRODUCTO ?? o.odp_producto ?? "").trim();
              return (
                mat === (det.MATERIAL ?? "").trim() ||
                prod === (det.PRO_NOMBRE ?? "").trim()
              );
            });
            if (filaODP)
              precioODP = Number(filaODP.ODP_PRECIO ?? filaODP.odp_precio ?? 0);
            if (precioODP === 0 && ordenes.length > 0)
              precioODP = Number(
                (ordenes[0] as any).ODP_PRECIO ??
                  (ordenes[0] as any).odp_precio ??
                  0,
              );
          }
        } catch {}
      }
      setItemRecibiendoId(null);
      setCantRecibiendo("");
      router.push({
        pathname: "/modules/catalogoInventario/stock" as any,
        params: {
          fromped: "1",
          ref: det.PRO_REFERENCIA,
          nombre: det.PRO_NOMBRE,
          material: det.MATERIAL ?? "",
          pedido: String(pedidoActivo),
          detpe: String(det.DETPE_DETALLE_PEDIDO),
          hip: String(det.HIP_HISTORIAL_PRECIO),
          precio: precioODP.toFixed(2),
          cantrecibida: String(cant),
          canttotalrecib: String(yaRecibida + cant),
        },
      });
    } catch {
      Alert.alert(
        "😕 Error en recepción",
        "No se pudo registrar la recepción. Verifica que el precio de la Orden de Compra sea mayor a 0.",
      );
    } finally {
      setLoading(false);
    }
  };

  const handleEliminarItem = (detalleId: number) => {
    Alert.alert("Eliminar", "¿Eliminar este producto del pedido?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Eliminar",
        style: "destructive",
        onPress: async () => {
          try {
            setLoading(true);
            await DetallePedidoService.eliminar(detalleId);
            const nuevos =
              await DetallePedidoService.listarPorPedido(pedidoActivo);
            setDetalles(
              (Array.isArray(nuevos) ? nuevos : []).map(normalizarDetalle),
            );
            await cargarLista();
          } catch {
            Alert.alert(
              "😕 Error al eliminar",
              "No se pudo eliminar. Es posible que ya tenga datos asociados.",
            );
          } finally {
            setLoading(false);
          }
        },
      },
    ]);
  };

  const handleGuardarCabecera = async () => {
    if (!fpCabSel) {
      Alert.alert("Atención", "Selecciona la forma de pago.");
      return;
    }
    setLoading(true);
    try {
      await PedidoService.actualizar(
        pedidoActivo,
        cabeceraInfo?.PED_CODIGO ?? "",
        fpCabSel,
        cabeceraInfo?.PED_TOTAL ?? 0,
      );
      const cab = await PedidoService.obtener(pedidoActivo);
      setCabeceraInfo(Array.isArray(cab) && cab.length > 0 ? cab[0] : null);
      setModalCab(false);
      await cargarLista();
      Alert.alert("Éxito", "Forma de pago actualizada correctamente.");
    } catch {
      Alert.alert(
        "😕 Error al guardar",
        "No se pudo guardar el cambio. Intenta de nuevo.",
      );
    } finally {
      setLoading(false);
    }
  };

  const handleFinalizar = async () => {
    // ── Validación: no se puede finalizar sin al menos un producto ──
    if (detalles.length === 0) {
      Alert.alert(
        "Sin productos",
        "No puedes guardar un pedido sin al menos un producto. Agrega uno o elimina el pedido.",
        [
          { text: "Seguir editando", style: "cancel" },
          {
            text: "Eliminar pedido",
            style: "destructive",
            onPress: async () => {
              try {
                await PedidoService.eliminar(pedidoActivo);
                await cargarLista();
                setVista("lista");
              } catch (e: any) {
                Alert.alert(
                  "😕 Algo salió mal",
                  e.message ?? "Ocurrió un error inesperado.",
                );
              }
            },
          },
        ],
      );
      return;
    }
    setVista("lista");
  };

  const handleEliminarPedido = (id: number) => {
    Alert.alert("Eliminar", "¿Eliminar este pedido y sus productos?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Eliminar",
        style: "destructive",
        onPress: async () => {
          try {
            setLoading(true);
            await PedidoService.eliminar(id);
            if (pedidoActivo === id) setVista("lista");
            await cargarLista();
            Alert.alert("Éxito", "Pedido eliminado correctamente.");
          } catch {
            Alert.alert(
              "😕 Error al eliminar",
              "No se pudo eliminar. Es posible que ya tenga datos asociados.",
            );
          } finally {
            setLoading(false);
          }
        },
      },
    ]);
  };

  const handleBuscar = async () => {
    if (!search.trim()) return cargarLista();
    setLoading(true);
    try {
      setPedidos(await PedidoService.buscar(search));
    } catch {
      Alert.alert(
        "😕 Sin resultados",
        "No se pudo realizar la búsqueda. Verifica tu conexión.",
      );
    } finally {
      setLoading(false);
    }
  };

  // ── RENDER LISTA ──────────────────────────────────────────────────────────
  if (vista === "lista") {
    return (
      <SafeAreaView style={styles.safeArea}>
        {/* Buscador FUERA del FlatList */}
        <View style={styles.searchContainer}>
          <View style={styles.searchRow}>
            <TextInput
              style={styles.searchInput}
              placeholder="Buscar por código..."
              value={search}
              onChangeText={setSearch}
              returnKeyType="search"
              onSubmitEditing={handleBuscar}
            />
            <TouchableOpacity style={styles.btnSearch} onPress={handleBuscar}>
              <Text style={styles.btnTextWhite}>Buscar</Text>
            </TouchableOpacity>
            {search.trim() !== "" && (
              <TouchableOpacity
                style={styles.btnSearchOutline}
                onPress={() => {
                  setSearch("");
                  cargarLista();
                }}
              >
                <Text style={styles.btnTextDark}>✕</Text>
              </TouchableOpacity>
            )}
          </View>
          <TouchableOpacity
            style={styles.btnAdd}
            onPress={() => {
              setFormaPagoSel("");
              setVista("nuevaCabecera");
            }}
          >
            <Text style={styles.btnTextWhite}>+ Nuevo Pedido</Text>
          </TouchableOpacity>
        </View>

        <FlatList
          style={styles.container}
          data={pedidos}
          keyExtractor={(item) => item.PED_PEDIDO.toString()}
          contentContainerStyle={{ paddingBottom: 20, paddingHorizontal: 16 }}
          keyboardShouldPersistTaps="handled"
          ListEmptyComponent={
            loading ? (
              <ActivityIndicator
                size="large"
                color="#C9973A"
                style={{ marginTop: 20 }}
              />
            ) : (
              <Text style={styles.emptyText}>No hay pedidos registrados.</Text>
            )
          }
          renderItem={({ item }) => (
            <View style={styles.card}>
              <View style={styles.cardInfo}>
                <View style={styles.cardRow}>
                  <Text style={styles.badgeId}>{item.PED_CODIGO}</Text>
                  <Text style={styles.badgePago}>{item.PED_FORMA_PAGO}</Text>
                </View>
                <Text style={styles.cardSub}>
                  📅 {formatFecha(item.PED_FECHA)}
                </Text>
              </View>
              <View style={styles.actions}>
                <TouchableOpacity
                  style={styles.btnEdit}
                  onPress={() => abrirDetalle(item.PED_PEDIDO)}
                >
                  <Text style={styles.btnTextGold}>👁 Ver</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={styles.btnDelete}
                  onPress={() => handleEliminarPedido(item.PED_PEDIDO)}
                >
                  <Text style={styles.btnTextRed}>🗑</Text>
                </TouchableOpacity>
              </View>
            </View>
          )}
        />
      </SafeAreaView>
    );
  }

  // ── RENDER NUEVA CABECERA ─────────────────────────────────────────────────
  if (vista === "nuevaCabecera") {
    return (
      <SafeAreaView style={styles.safeArea}>
        <ScrollView
          style={styles.container}
          contentContainerStyle={{ paddingBottom: 30 }}
        >
          <View style={styles.formCard}>
            <View style={styles.formCardHead}>
              <Text style={styles.formCardTitle}>✏️ Nuevo Pedido</Text>
            </View>
            <View style={styles.formCardBody}>
              <Text style={styles.infoNote}>
                El código se generará automáticamente por Oracle.
              </Text>
              <Text style={styles.label}>Forma de Pago *</Text>
              <TouchableOpacity
                style={styles.selector}
                onPress={() => setShowFormaPago(!showFormaPago)}
              >
                <Text style={{ color: formaPagoSel ? "#333" : "#aaa" }}>
                  {formaPagoSel
                    ? (formasPago.find((f) => f.FORMA_PAGO === formaPagoSel)
                        ?.DESCRIPCION ?? formaPagoSel)
                    : "Seleccionar..."}
                </Text>
                <Text>▼</Text>
              </TouchableOpacity>
              {showFormaPago && (
                <View style={styles.dropdownList}>
                  {formasPago.map((f) => (
                    <TouchableOpacity
                      key={f.FORMA_PAGO}
                      style={styles.dropdownItem}
                      onPress={() => {
                        setFormaPagoSel(f.FORMA_PAGO);
                        setShowFormaPago(false);
                      }}
                    >
                      <Text style={{ color: "#333" }}>{f.DESCRIPCION}</Text>
                    </TouchableOpacity>
                  ))}
                </View>
              )}

              {/* Botones — fila con gap y sin flex para que no se corten */}
              <View style={styles.modalActions}>
                <TouchableOpacity
                  style={styles.btnCancel}
                  onPress={() => setVista("lista")}
                >
                  <Text style={styles.btnTextDark}>✕ Cancelar</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={styles.btnSave}
                  onPress={handleCrearCabecera}
                  disabled={loading}
                >
                  <Text style={styles.btnTextWhite}>
                    💾 Guardar y Agregar Productos
                  </Text>
                </TouchableOpacity>
              </View>
            </View>
          </View>
        </ScrollView>
      </SafeAreaView>
    );
  }

  // ── RENDER DETALLE PEDIDO ─────────────────────────────────────────────────
  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView
        style={styles.container}
        contentContainerStyle={{ paddingBottom: 30 }}
      >
        {/* Cabecera */}
        <View style={styles.formCard}>
          <View
            style={[
              styles.formCardHead,
              { flexDirection: "row", justifyContent: "space-between" },
            ]}
          >
            <Text style={styles.formCardTitle}>📦 PEDIDO #{pedidoActivo}</Text>
            <TouchableOpacity onPress={() => setVista("lista")}>
              <Text style={{ color: "#f0d9a0", fontWeight: "bold" }}>
                ✕ Cerrar
              </Text>
            </TouchableOpacity>
          </View>
          <View style={styles.formCardBody}>
            <View style={styles.cabeceraInfo}>
              <View style={styles.cabeceraField}>
                <Text style={styles.cabeceraLabel}>Código</Text>
                <Text style={styles.cabeceraVal}>
                  {cabeceraInfo?.PED_CODIGO ?? "—"}
                </Text>
              </View>
              <View style={styles.cabeceraField}>
                <Text style={styles.cabeceraLabel}>Fecha</Text>
                <Text style={styles.cabeceraVal}>
                  {formatFecha(cabeceraInfo?.PED_FECHA) ?? "—"}
                </Text>
              </View>
              <View style={styles.cabeceraField}>
                <Text style={styles.cabeceraLabel}>Forma de Pago</Text>
                <Text style={styles.cabeceraVal}>
                  {cabeceraInfo?.PED_FORMA_PAGO ?? "—"}
                </Text>
              </View>
            </View>
            {!tieneOC && (
              <TouchableOpacity
                style={[
                  styles.btnSaveSmall,
                  { alignSelf: "flex-start", marginTop: 8 },
                ]}
                onPress={() => {
                  setFpCabSel(cabeceraInfo?.PED_FORMA_PAGO ?? "");
                  setModalCab(true);
                }}
              >
                <Text style={styles.btnTextSmallGreen}>
                  ✏️ Editar Forma de Pago
                </Text>
              </TouchableOpacity>
            )}
            {tieneOC && (
              <View style={styles.alertInfo}>
                <Text style={styles.alertInfoText}>
                  🔒 Este pedido tiene una Orden de Compra asociada. No se
                  pueden modificar los productos ni la forma de pago.
                </Text>
              </View>
            )}
          </View>
        </View>

        {/* Agregar producto */}
        {!tieneOC && (
          <View style={styles.formCard}>
            <View style={styles.formCardHead}>
              <Text style={styles.formCardTitle}>+ Agregar Producto</Text>
            </View>
            <View style={styles.formCardBody}>
              <Text style={styles.label}>Producto *</Text>
              <TouchableOpacity
                style={styles.selector}
                onPress={() => setShowProductos(!showProductos)}
              >
                <Text style={{ color: productoSel ? "#333" : "#aaa" }}>
                  {productoNombre || "Seleccionar producto..."}
                </Text>
                <Text>▼</Text>
              </TouchableOpacity>
              {showProductos && (
                <ScrollView
                  style={[styles.dropdownList, { maxHeight: 160 }]}
                  nestedScrollEnabled
                >
                  {productos.map((p) => (
                    <TouchableOpacity
                      key={p.PRO_REFERENCIA}
                      style={styles.dropdownItem}
                      onPress={() => {
                        setProductoSel(p.PRO_REFERENCIA);
                        setProductoNombre(p.PRO_NOMBRE);
                        setShowProductos(false);
                      }}
                    >
                      <Text style={{ color: "#333" }}>{p.PRO_NOMBRE}</Text>
                    </TouchableOpacity>
                  ))}
                </ScrollView>
              )}
              <Text style={styles.infoNote}>
                El precio se asignará al recibir la mercancía desde la Orden de
                Compra.
              </Text>
              <Text style={styles.label}>Cantidad *</Text>
              <TextInput
                style={styles.input}
                value={cantSolicitada}
                onChangeText={setCantSolicitada}
                placeholder="0"
                keyboardType="numeric"
              />
              <TouchableOpacity
                style={styles.btnAdd}
                onPress={handleAgregarProducto}
              >
                <Text style={styles.btnTextWhite}>+ Agregar</Text>
              </TouchableOpacity>
            </View>
          </View>
        )}

        {/* Lista de items */}
        <View style={styles.formCard}>
          <View style={styles.formCardHead}>
            <Text style={styles.formCardTitle}>
              Items del Pedido ({detalles.length})
            </Text>
          </View>
          <View style={styles.formCardBody}>
            {detalles.length === 0 ? (
              <View style={styles.emptyItemsBox}>
                <Text style={styles.emptyItemsIcon}>📋</Text>
                <Text style={styles.emptyItemsText}>No hay productos aún.</Text>
                <Text style={styles.emptyItemsNote}>
                  Debes agregar al menos un producto antes de finalizar.
                </Text>
              </View>
            ) : (
              detalles.map((det) => (
                <View key={det.DETPE_DETALLE_PEDIDO} style={styles.detalleRow}>
                  <View style={{ flex: 1 }}>
                    <Text style={styles.detalleProd}>{det.PRO_NOMBRE}</Text>
                    {det.MATERIAL ? (
                      <Text style={styles.cardSub}>
                        Material: {det.MATERIAL}
                      </Text>
                    ) : null}
                    <Text style={styles.cardSub}>
                      Sol: {det.DETPE_CANTIDAD_SOLICITADA} | Rec:{" "}
                      {det.DETPE_CANTIDAD_RECIBIDA ?? 0}
                    </Text>
                    {det.HIP_PRECIO > 0 && (
                      <Text style={styles.cardSub}>
                        Precio ref: Q{" "}
                        {parseFloat(det.HIP_PRECIO?.toString() ?? "0").toFixed(
                          2,
                        )}
                      </Text>
                    )}
                  </View>
                  <View style={{ flexDirection: "column", gap: 5 }}>
                    {!tieneOC && (
                      <>
                        <TouchableOpacity
                          style={styles.btnEditSmall}
                          onPress={() => abrirEditarItem(det)}
                        >
                          <Text style={styles.btnTextGold}>✏️</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                          style={styles.btnDeleteSmall}
                          onPress={() =>
                            handleEliminarItem(det.DETPE_DETALLE_PEDIDO)
                          }
                        >
                          <Text style={styles.btnTextRed}>🗑</Text>
                        </TouchableOpacity>
                      </>
                    )}
                    {tieneOC &&
                      (det.DETPE_CANTIDAD_RECIBIDA ?? 0) <
                        det.DETPE_CANTIDAD_SOLICITADA && (
                        <TouchableOpacity
                          style={[
                            styles.btnReceiveSmall,
                            itemRecibiendoId === det.DETPE_DETALLE_PEDIDO &&
                              styles.btnReceiveActive,
                          ]}
                          onPress={() => abrirRecibirItem(det)}
                        >
                          <Text style={styles.btnTextReceive}>
                            {itemRecibiendoId === det.DETPE_DETALLE_PEDIDO
                              ? "✕ Cerrar"
                              : "✔ Recibir"}
                          </Text>
                        </TouchableOpacity>
                      )}
                    {tieneOC &&
                      (det.DETPE_CANTIDAD_RECIBIDA ?? 0) >=
                        det.DETPE_CANTIDAD_SOLICITADA && (
                        <View
                          style={[
                            styles.btnReceiveSmall,
                            {
                              backgroundColor: "#f0fff4",
                              borderColor: "#9ae6b4",
                            },
                          ]}
                        >
                          <Text
                            style={{
                              color: "#276749",
                              fontSize: 11,
                              fontWeight: "bold",
                            }}
                          >
                            ✅ Completo
                          </Text>
                        </View>
                      )}
                  </View>
                </View>
              ))
            )}
          </View>
        </View>

        {/* Panel inline de recepción */}
        {itemRecibiendoId !== null &&
          tieneOC &&
          (() => {
            const det = detalles.find(
              (d) => d.DETPE_DETALLE_PEDIDO === itemRecibiendoId,
            );
            if (!det) return null;
            const yaRecibida = det.DETPE_CANTIDAD_RECIBIDA ?? 0;
            const cantNueva = parseInt(cantRecibiendo) || 0;
            const totalSiConfirma = yaRecibida + cantNueva;
            return (
              <View style={styles.recepcionPanel}>
                <Text style={styles.recepcionPanelTitle}>
                  📦 {det.PRO_NOMBRE}
                </Text>
                <View style={styles.recepcionInfoRow}>
                  <View style={styles.recepcionInfoBox}>
                    <Text style={styles.recepcionInfoVal}>
                      {det.DETPE_CANTIDAD_SOLICITADA}
                    </Text>
                    <Text style={styles.recepcionInfoLbl}>Solicitada</Text>
                  </View>
                  <View style={styles.recepcionInfoBox}>
                    <Text style={styles.recepcionInfoVal}>{yaRecibida}</Text>
                    <Text style={styles.recepcionInfoLbl}>Recibida</Text>
                  </View>
                  <View
                    style={[
                      styles.recepcionInfoBox,
                      { borderColor: "#C9973A" },
                    ]}
                  >
                    <Text
                      style={[styles.recepcionInfoVal, { color: "#C9973A" }]}
                    >
                      {det.DETPE_CANTIDAD_SOLICITADA - yaRecibida}
                    </Text>
                    <Text style={styles.recepcionInfoLbl}>Pendiente</Text>
                  </View>
                </View>
                <View style={styles.recepcionFormulaRow}>
                  <View style={styles.recepcionBox}>
                    <Text style={styles.recepcionBoxLabel}>YA RECIBIDO</Text>
                    <Text style={styles.recepcionBoxVal}>{yaRecibida}</Text>
                  </View>
                  <Text style={styles.recepcionSep}>+</Text>
                  <View style={{ flex: 1 }}>
                    <Text style={styles.recepcionBoxLabel}>
                      CANTIDAD A AGREGAR *
                    </Text>
                    <TextInput
                      style={styles.recepcionInput}
                      value={cantRecibiendo}
                      onChangeText={setCantRecibiendo}
                      keyboardType="numeric"
                      placeholder="0"
                      autoFocus
                    />
                  </View>
                </View>
                <View style={styles.recepcionTotalRow}>
                  <Text style={styles.recepcionSep}>=</Text>
                  <View style={styles.recepcionTotalBox}>
                    <Text style={styles.recepcionBoxLabel}>TOTAL RECIBIDO</Text>
                    <Text style={styles.recepcionTotalVal}>
                      {cantNueva > 0 ? totalSiConfirma : "—"}
                    </Text>
                  </View>
                </View>
                <Text style={styles.recepcionNota}>
                  Solo ingresa la cantidad que llega ahora. Luego asignarás
                  almacén y nicho en Stock.
                </Text>
                <View style={styles.recepcionBtns}>
                  <TouchableOpacity
                    style={styles.btnConfirmarRecep}
                    onPress={() => handleConfirmarRecepcion(det)}
                    disabled={loading}
                  >
                    <Text style={styles.btnTextWhite}>
                      {loading ? "..." : "✓ Confirmar e ir a Stock"}
                    </Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={styles.btnCancelarRecep}
                    onPress={() => {
                      setItemRecibiendoId(null);
                      setCantRecibiendo("");
                    }}
                  >
                    <Text style={styles.btnTextDark}>✕ Cancelar</Text>
                  </TouchableOpacity>
                </View>
              </View>
            );
          })()}

        <TouchableOpacity style={styles.btnGreen} onPress={handleFinalizar}>
          <Text style={styles.btnTextWhite}>✓ Finalizar</Text>
        </TouchableOpacity>
      </ScrollView>

      {/* Modal editar forma de pago */}
      <Modal visible={modalCab} animationType="slide" transparent>
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Editar Forma de Pago</Text>
            <Text style={styles.label}>Forma de Pago *</Text>
            <TouchableOpacity
              style={styles.selector}
              onPress={() => setShowFpCab(!showFpCab)}
            >
              <Text style={{ color: fpCabSel ? "#333" : "#aaa" }}>
                {fpCabSel
                  ? (formasPago.find((f) => f.FORMA_PAGO === fpCabSel)
                      ?.DESCRIPCION ?? fpCabSel)
                  : "Seleccionar..."}
              </Text>
              <Text>▼</Text>
            </TouchableOpacity>
            {showFpCab && (
              <View style={styles.dropdownList}>
                {formasPago.map((f) => (
                  <TouchableOpacity
                    key={f.FORMA_PAGO}
                    style={styles.dropdownItem}
                    onPress={() => {
                      setFpCabSel(f.FORMA_PAGO);
                      setShowFpCab(false);
                    }}
                  >
                    <Text style={{ color: "#333" }}>{f.DESCRIPCION}</Text>
                  </TouchableOpacity>
                ))}
              </View>
            )}
            <View style={styles.modalActions}>
              <TouchableOpacity
                style={styles.btnCancel}
                onPress={() => setModalCab(false)}
              >
                <Text style={styles.btnTextDark}>Cancelar</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={styles.btnSave}
                onPress={handleGuardarCabecera}
              >
                <Text style={styles.btnTextWhite}>✓ Guardar</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>

      {/* Modal editar cantidad de ítem */}
      <Modal visible={modalItem} animationType="slide" transparent>
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>
              Editar Cantidad — {itemEditando?.PRO_NOMBRE}
            </Text>
            {itemEditando?.MATERIAL ? (
              <Text style={{ color: "#888", fontSize: 12, marginBottom: 12 }}>
                Material: {itemEditando.MATERIAL}
              </Text>
            ) : null}
            <Text style={styles.label}>Cantidad Solicitada *</Text>
            <TextInput
              style={styles.input}
              value={cantEditando}
              onChangeText={setCantEditando}
              keyboardType="numeric"
              placeholder="0"
            />
            <Text
              style={{
                fontSize: 11,
                color: "#8B5E3C",
                fontStyle: "italic",
                marginBottom: 14,
              }}
            >
              Recibida actual: {itemEditando?.DETPE_CANTIDAD_RECIBIDA ?? 0} —
              Oracle validará que la nueva cantidad sea válida.
            </Text>
            <View style={styles.modalActions}>
              <TouchableOpacity
                style={styles.btnCancel}
                onPress={() => {
                  setModalItem(false);
                  setItemEditando(null);
                }}
              >
                <Text style={styles.btnTextDark}>Cancelar</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={styles.btnSave}
                onPress={handleGuardarItem}
                disabled={loading}
              >
                <Text style={styles.btnTextWhite}>✓ Guardar</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: "#fdf8f3" },
  container: { flex: 1 },

  // buscador fuera del FlatList
  searchContainer: { paddingHorizontal: 16, paddingTop: 16 },
  searchRow: {
    flexDirection: "row",
    gap: 8,
    marginBottom: 8,
    flexWrap: "wrap",
  },
  searchInput: {
    flex: 1,
    minWidth: 160,
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
    paddingHorizontal: 14,
    borderRadius: 8,
    height: 45,
  },
  btnSearchOutline: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    justifyContent: "center",
    paddingHorizontal: 14,
    borderRadius: 8,
    height: 45,
  },

  btnAdd: {
    backgroundColor: "#5C3A1E",
    padding: 12,
    borderRadius: 8,
    alignItems: "center",
    marginBottom: 16,
  },
  btnGreen: {
    backgroundColor: "#276749",
    padding: 14,
    borderRadius: 8,
    alignItems: "center",
    marginTop: 8,
    marginHorizontal: 16,
  },
  btnTextWhite: { color: "white", fontWeight: "bold" },
  btnTextDark: { color: "#5C3A1E", fontWeight: "bold" },

  card: {
    backgroundColor: "white",
    padding: 16,
    borderRadius: 12,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
  },
  cardRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 6,
    marginBottom: 4,
  },
  cardInfo: { flex: 1 },
  badgeId: {
    backgroundColor: "#fdf6ec",
    color: "#C9973A",
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 12,
    fontSize: 12,
  },
  badgePago: {
    backgroundColor: "#eef6ff",
    color: "#2b6cb0",
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 12,
    fontSize: 11,
  },
  cardSub: { fontSize: 12, color: "#888", marginTop: 2 },
  actions: { flexDirection: "row", gap: 6, alignItems: "center" },
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
  },
  btnTextRed: { color: "#e53e3e", fontSize: 12 },
  emptyText: {
    textAlign: "center",
    color: "#aaa",
    marginTop: 10,
    marginBottom: 10,
  },

  formCard: {
    backgroundColor: "white",
    borderRadius: 12,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    marginBottom: 16,
    overflow: "hidden",
    marginHorizontal: 16,
  },
  formCardHead: { backgroundColor: "#5C3A1E", padding: 14 },
  formCardTitle: { color: "#f0d9a0", fontSize: 13, fontWeight: "bold" },
  formCardBody: { padding: 16 },

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
    marginBottom: 12,
  },
  infoNote: {
    fontSize: 11,
    color: "#8B5E3C",
    fontStyle: "italic",
    marginBottom: 12,
  },

  selector: {
    backgroundColor: "#fdf8f3",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 12,
    marginBottom: 8,
    flexDirection: "row",
    justifyContent: "space-between",
  },
  dropdownList: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    marginBottom: 12,
  },
  dropdownItem: {
    padding: 12,
    borderBottomWidth: 1,
    borderBottomColor: "#f0e8dc",
  },

  cabeceraInfo: {
    flexDirection: "row",
    flexWrap: "wrap",
    gap: 16,
    marginBottom: 8,
  },
  cabeceraField: {},
  cabeceraLabel: {
    fontSize: 10,
    color: "#8B5E3C",
    fontWeight: "bold",
    textTransform: "uppercase",
  },
  cabeceraVal: { fontSize: 13, color: "#333" },

  btnSaveSmall: {
    backgroundColor: "#f0fff4",
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#9ae6b4",
  },
  btnTextSmallGreen: { color: "#276749", fontSize: 12, fontWeight: "bold" },
  alertInfo: {
    backgroundColor: "#eff6ff",
    borderRadius: 8,
    padding: 10,
    marginTop: 8,
  },
  alertInfoText: { color: "#1d4ed8", fontSize: 12 },

  // empty items box
  emptyItemsBox: {
    alignItems: "center",
    paddingVertical: 20,
    backgroundColor: "#fdf8f3",
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  emptyItemsIcon: { fontSize: 32, marginBottom: 8 },
  emptyItemsText: {
    fontSize: 14,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 4,
  },
  emptyItemsNote: {
    fontSize: 12,
    color: "#C9973A",
    fontStyle: "italic",
    textAlign: "center",
    paddingHorizontal: 16,
  },

  detalleRow: {
    flexDirection: "row",
    alignItems: "center",
    paddingVertical: 10,
    borderBottomWidth: 1,
    borderBottomColor: "#f5ece0",
  },
  detalleProd: { fontSize: 13, color: "#333", fontWeight: "bold" },
  btnEditSmall: {
    backgroundColor: "#fdf6ec",
    padding: 8,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  btnDeleteSmall: {
    backgroundColor: "#fff5f5",
    padding: 8,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#fed7d7",
  },
  btnReceiveSmall: {
    backgroundColor: "#f0fff4",
    padding: 8,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#9ae6b4",
  },
  btnReceiveActive: { backgroundColor: "#c6f6d5", borderColor: "#276749" },
  btnTextReceive: { color: "#276749", fontSize: 13 },

  // ── Acciones del modal — sin flex para que Cancelar no se corte ──
  modalActions: {
    flexDirection: "row",
    justifyContent: "flex-end",
    gap: 10,
    marginTop: 16,
    flexWrap: "wrap", // si el espacio es muy angosto, baja a la siguiente línea
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
    fontSize: 17,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 16,
  },
  // Cancelar y Guardar con paddingHorizontal fijo — no tienen flex, no se cortan
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

  // recepción
  recepcionPanel: {
    backgroundColor: "#f0fff4",
    borderWidth: 1,
    borderColor: "#9ae6b4",
    borderRadius: 10,
    padding: 14,
    marginHorizontal: 16,
    marginBottom: 12,
  },
  recepcionPanelTitle: {
    color: "#276749",
    fontWeight: "bold",
    fontSize: 13,
    marginBottom: 12,
  },
  recepcionFormulaRow: {
    flexDirection: "row",
    alignItems: "flex-end",
    gap: 8,
    marginBottom: 8,
  },
  recepcionBox: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#9ae6b4",
    borderRadius: 8,
    padding: 10,
    alignItems: "center",
    minWidth: 70,
  },
  recepcionBoxLabel: {
    fontSize: 9,
    color: "#276749",
    fontWeight: "bold",
    textTransform: "uppercase",
    marginBottom: 4,
  },
  recepcionBoxVal: { fontSize: 18, color: "#276749", fontWeight: "bold" },
  recepcionSep: {
    fontSize: 20,
    color: "#276749",
    fontWeight: "bold",
    paddingBottom: 4,
  },
  recepcionInput: {
    backgroundColor: "white",
    borderWidth: 1.5,
    borderColor: "#9ae6b4",
    borderRadius: 8,
    padding: 10,
    fontSize: 18,
    fontWeight: "bold",
    color: "#333",
  },
  recepcionTotalRow: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
    marginBottom: 8,
  },
  recepcionTotalBox: {
    backgroundColor: "white",
    borderWidth: 1.5,
    borderColor: "#276749",
    borderRadius: 8,
    padding: 10,
    alignItems: "center",
    minWidth: 70,
  },
  recepcionTotalVal: { fontSize: 20, color: "#276749", fontWeight: "bold" },
  recepcionNota: {
    fontSize: 11,
    color: "#276749",
    fontStyle: "italic",
    marginBottom: 12,
  },
  recepcionBtns: { flexDirection: "row", gap: 8 },
  recepcionInfoRow: { flexDirection: "row", gap: 8, marginBottom: 14 },
  recepcionInfoBox: {
    flex: 1,
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#9ae6b4",
    borderRadius: 8,
    padding: 10,
    alignItems: "center",
  },
  recepcionInfoVal: { fontSize: 18, fontWeight: "bold", color: "#276749" },
  recepcionInfoLbl: {
    fontSize: 9,
    color: "#276749",
    textTransform: "uppercase",
    marginTop: 2,
  },
  btnConfirmarRecep: {
    flex: 1,
    backgroundColor: "#276749",
    padding: 10,
    borderRadius: 8,
    alignItems: "center",
  },
  btnCancelarRecep: {
    flex: 1,
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    padding: 10,
    borderRadius: 8,
    alignItems: "center",
  },
});
