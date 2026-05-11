import React, { useEffect, useRef, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  FlatList,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import {
  buscarOrdenesCompra,
  crearOrdenCompra,
  eliminarOrdenCompra,
  getOrdenesCompra,
  getOrdenCompraPorId,
  OrdenCompra,
  buscarPedidosParaOrden,
  getDetallesPedidoParaOrden,
  actualizarTotalOrden,
} from "../../services/comprasProveedor/ordenesCompra";
import {
  buscarProveedores,
  Proveedor,
} from "../../services/comprasProveedor/proveedores";
import {
  buscarPorPedido,
  insertarOrdenDetalle,
  listarPorOrden,
  OrdenDetalle,
} from "../../services/comprasProveedor/ordenDetallePedido";

type Vista = "lista" | "nuevaOrden" | "detalle";

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

interface ItemPedido {
  PRO_NOMBRE: string;
  MATERIAL: string;
  DETPE_CANTIDAD_SOLICITADA: number;
  precio: string;
}

interface PedidoItem {
  PED_PEDIDO: number;
  PED_CODIGO: string;
  PED_FORMA_PAGO: string;
  items: ItemPedido[];
  YA_ASIGNADO: boolean;
}

export default function OrdenesCompraScreen() {
  const [ordenes, setOrdenes] = useState<OrdenCompra[]>([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");
  const [vista, setVista] = useState<Vista>("lista");

  const [proveedores, setProveedores] = useState<Proveedor[]>([]);
  const [proveedorSel, setProveedorSel] = useState<Proveedor | null>(null);
  const [searchProv, setSearchProv] = useState("");
  const [showProvList, setShowProvList] = useState(false);
  const [searchPedido, setSearchPedido] = useState("");
  const [resultadosPedidos, setResultadosPedidos] = useState<PedidoItem[]>([]);
  const [pedidoVinculado, setPedidoVinculado] = useState<PedidoItem | null>(
    null,
  );

  const [orcActiva, setOrcActiva] = useState("");
  const [codigoActivo, setCodigoActivo] = useState("");
  const [pedidoCodActivo, setPedidoCodActivo] = useState("");
  const [itemsOrden, setItemsOrden] = useState<OrdenDetalle[]>([]);
  const [totalOrden, setTotalOrden] = useState("0.00");

  useEffect(() => {
    cargarLista();
  }, []);

  const pedidoYaAsignado = async (pedId: number): Promise<boolean> => {
    try {
      const dt = await buscarPorPedido(pedId);
      return Array.isArray(dt) && dt.length > 0;
    } catch {
      return false;
    }
  };

  const ordenTieneRecepcion = async (orcKey: string): Promise<boolean> => {
    try {
      const items = await listarPorOrden(orcKey);
      if (!Array.isArray(items) || items.length === 0) return false;
      const pedId =
        (items[0] as any).PED_PEDIDO ?? (items[0] as any).ped_pedido;
      if (!pedId) return false;
      const { getDetallePedido } =
        await import("../../services/comprasProveedor/detallePedido");
      const dets = await getDetallePedido(pedId);
      if (!Array.isArray(dets)) return false;
      return dets.some(
        (d: any) =>
          Number(d.DETPE_CANTIDAD_RECIBIDA ?? d.detpe_cantidad_recibida ?? 0) >
          0,
      );
    } catch {
      return false;
    }
  };

  const cargarLista = async () => {
    setLoading(true);
    try {
      setOrdenes(await getOrdenesCompra());
    } catch (e: any) {
      Alert.alert(
        "😕 Sin conexión",
        e.message ?? "No se pudieron cargar las órdenes.",
      );
    } finally {
      setLoading(false);
    }
  };

  const cargarDetalle = async (orcKey: string) => {
    try {
      const dt = await listarPorOrden(orcKey);
      const items = Array.isArray(dt) ? dt : [];
      setItemsOrden(items);
      const total = items.reduce(
        (acc, r) => acc + (r.ODP_PRECIO ?? 0) * (r.ODP_CANTIDAD ?? 0),
        0,
      );
      setTotalOrden(total.toFixed(2));
      if (items.length > 0) {
        const raw = items[0] as any;
        const cod = raw.ped_codigo ?? raw.PED_CODIGO ?? "";
        const num = raw.ped_pedido ?? raw.PED_PEDIDO ?? "";
        setPedidoCodActivo(cod || (num ? String(num) : ""));
      }
    } catch {}
  };

  const handleBuscar = async () => {
    if (!search.trim()) return cargarLista();
    setLoading(true);
    try {
      setOrdenes(await buscarOrdenesCompra(search));
    } catch (e: any) {
      Alert.alert(
        "😕 Sin resultados",
        e.message ?? "No se pudo realizar la búsqueda.",
      );
    } finally {
      setLoading(false);
    }
  };

  const handleBuscarPedidos = async () => {
    if (!searchPedido.trim()) {
      Alert.alert("Atención", "Ingresa texto para buscar pedidos.");
      return;
    }
    setLoading(true);
    try {
      const raw = await buscarPedidosParaOrden(searchPedido);
      const lista = Array.isArray(raw) ? raw : [];
      const conItems: PedidoItem[] = await Promise.all(
        lista.map(async (p: any) => {
          try {
            const pedId = p.PED_PEDIDO ?? p.ped_pedido;
            const [dets, yaAsignado] = await Promise.all([
              getDetallesPedidoParaOrden(pedId),
              pedidoYaAsignado(pedId),
            ]);
            return {
              PED_PEDIDO: pedId,
              PED_CODIGO: p.PED_CODIGO ?? p.ped_codigo,
              PED_FORMA_PAGO: p.PED_FORMA_PAGO ?? p.ped_forma_pago,
              items: (Array.isArray(dets) ? dets : []).map((d: any) => ({
                PRO_NOMBRE:
                  d.PRODUCTO_NOMBRE ?? d.producto_nombre ?? d.PRO_NOMBRE ?? "—",
                MATERIAL: d.MATERIAL ?? d.material ?? "",
                DETPE_CANTIDAD_SOLICITADA:
                  d.CANTIDAD ?? d.cantidad ?? d.DETPE_CANTIDAD_SOLICITADA ?? 0,
                precio: "",
              })),
              YA_ASIGNADO: yaAsignado,
            };
          } catch {
            return {
              PED_PEDIDO: p.PED_PEDIDO ?? p.ped_pedido,
              PED_CODIGO: p.PED_CODIGO ?? p.ped_codigo,
              PED_FORMA_PAGO: p.PED_FORMA_PAGO ?? p.ped_forma_pago,
              items: [],
              YA_ASIGNADO: false,
            };
          }
        }),
      );
      setResultadosPedidos(conItems);
    } catch (e: any) {
      Alert.alert("😕 Error", e.message ?? "No se pudo buscar pedidos.");
    } finally {
      setLoading(false);
    }
  };

  const seleccionarPedido = (p: PedidoItem) => {
    if (p.YA_ASIGNADO) {
      Alert.alert(
        "🔒 No disponible",
        "Este pedido ya fue asignado a una Orden de Compra y no puede seleccionarse.",
      );
      return;
    }
    setPedidoVinculado({ ...p });
    setResultadosPedidos([]);
    setSearchPedido("");
  };

  const actualizarPrecioItem = (idx: number, precio: string) => {
    if (!pedidoVinculado) return;
    const nuevos = [...pedidoVinculado.items];
    nuevos[idx] = { ...nuevos[idx], precio };
    setPedidoVinculado({ ...pedidoVinculado, items: nuevos });
  };

  const handleCrearOrden = async () => {
    if (!proveedorSel) {
      Alert.alert("Atención", "Selecciona un proveedor.");
      return;
    }
    if (!pedidoVinculado) {
      Alert.alert(
        "Atención",
        "Debes seleccionar un pedido antes de confirmar la orden.",
      );
      return;
    }

    // ── Validación: todos los items deben tener precio > 0 ──
    const itemsSinPrecio = pedidoVinculado.items.filter((it) => {
      const p = parseFloat(it.precio.replace(",", "."));
      return isNaN(p) || p <= 0;
    });
    if (itemsSinPrecio.length > 0) {
      const nombres = itemsSinPrecio
        .map(
          (it) => `• ${it.PRO_NOMBRE}${it.MATERIAL ? ` (${it.MATERIAL})` : ""}`,
        )
        .join("\n");
      Alert.alert(
        "Precio requerido",
        `Los siguientes productos no tienen precio ingresado. Debes asignar un precio mayor a 0 a cada uno antes de confirmar la orden:\n\n${nombres}`,
      );
      return;
    }

    setLoading(true);
    try {
      const res = await crearOrdenCompra(proveedorSel.PROV_PROVEEDOR, 0);
      const orcKey: string = res?.orc_key ?? "";
      if (!orcKey) throw new Error("No se obtuvo la clave de la orden.");
      for (const it of pedidoVinculado.items) {
        const precio = parseFloat(it.precio.replace(",", ".")) || 0;
        await insertarOrdenDetalle(
          orcKey,
          pedidoVinculado.PED_PEDIDO,
          it.MATERIAL,
          it.PRO_NOMBRE,
          precio,
          it.DETPE_CANTIDAD_SOLICITADA,
        );
      }
      await actualizarTotalOrden(orcKey);
      await cargarLista();
      await cargarDetalle(orcKey);
      // Obtener el CODIGO real que Oracle asignó a la nueva OC
      try {
        const orcData = await getOrdenCompraPorId(orcKey);
        const codigoNuevo =
          Array.isArray(orcData) && orcData.length > 0
            ? orcData[0].CODIGO
            : orcKey;
        setCodigoActivo(codigoNuevo);
      } catch {
        setCodigoActivo(orcKey); // fallback: mostrar la key si falla
      }
      setOrcActiva(orcKey);
      setPedidoCodActivo(pedidoVinculado?.PED_CODIGO ?? "");
      setVista("detalle");
      limpiarNueva();
      Alert.alert(
        "✅ Orden Creada",
        `La orden ${orcKey} fue creada correctamente.`,
      );
    } catch (e: any) {
      Alert.alert(
        "😕 Error al crear",
        e.message ?? "No se pudo crear la orden de compra.",
      );
    } finally {
      setLoading(false);
    }
  };

  const limpiarNueva = () => {
    setProveedorSel(null);
    setSearchProv("");
    setShowProvList(false);
    setPedidoVinculado(null);
    setSearchPedido("");
    setResultadosPedidos([]);
  };

  const handleEliminar = (orcKey: string) => {
    Alert.alert("Eliminar", "¿Eliminar esta orden de compra?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Eliminar",
        style: "destructive",
        onPress: async () => {
          try {
            setLoading(true);
            const tieneRecepcion = await ordenTieneRecepcion(orcKey);
            if (tieneRecepcion) {
              Alert.alert(
                "🔒 No se puede eliminar",
                "Esta Orden de Compra ya tiene recepción de mercancía registrada y no puede eliminarse.",
              );
              return;
            }
            await eliminarOrdenCompra(orcKey);
            if (orcActiva === orcKey) setVista("lista");
            await cargarLista();
            Alert.alert(
              "✅ Eliminada",
              "La orden fue eliminada correctamente.",
            );
          } catch (e: any) {
            Alert.alert(
              "😕 Error al eliminar",
              e.message ?? "No se pudo eliminar la orden.",
            );
          } finally {
            setLoading(false);
          }
        },
      },
    ]);
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
              onSubmitEditing={handleBuscar}
              returnKeyType="search"
              autoCorrect={false}
              autoCapitalize="none"
            />
            <TouchableOpacity style={styles.btnSearch} onPress={handleBuscar}>
              <Text style={styles.btnTextWhite}>Buscar</Text>
            </TouchableOpacity>
            {search.trim() !== "" && (
              <TouchableOpacity
                style={[styles.btnSearch, { backgroundColor: "#e8d8c0" }]}
                onPress={() => {
                  setSearch("");
                  cargarLista();
                }}
              >
                <Text style={[styles.btnTextWhite, { color: "#5C3A1E" }]}>
                  ✕
                </Text>
              </TouchableOpacity>
            )}
          </View>
          <TouchableOpacity
            style={styles.btnAdd}
            onPress={() => {
              limpiarNueva();
              setVista("nuevaOrden");
            }}
          >
            <Text style={styles.btnTextWhite}>+ Nueva Orden de Compra</Text>
          </TouchableOpacity>
        </View>

        <FlatList
          style={styles.container}
          data={ordenes}
          keyExtractor={(item, index) => (item.ORC_KEY ?? index).toString()}
          contentContainerStyle={{ paddingBottom: 20, paddingHorizontal: 16 }}
          keyboardShouldPersistTaps="handled"
          keyboardDismissMode="none"
          ListEmptyComponent={
            loading ? (
              <ActivityIndicator
                size="large"
                color="#C9973A"
                style={{ marginTop: 20 }}
              />
            ) : (
              <Text style={styles.emptyText}>No hay órdenes registradas.</Text>
            )
          }
          renderItem={({ item }) => (
            <View style={styles.card}>
              <View style={styles.cardInfo}>
                <View
                  style={{
                    flexDirection: "row",
                    gap: 6,
                    marginBottom: 6,
                    flexWrap: "wrap",
                  }}
                >
                  <Text style={styles.badgeORC}>{item.ORC_KEY}</Text>
                  <Text style={styles.badgeId}>{item.CODIGO}</Text>
                </View>
                <Text style={styles.cardTitle}>🏭 {item.PROVEEDOR}</Text>
                <Text style={styles.cardSub}>
                  Total: Q{" "}
                  {parseFloat(item.TOTAL?.toString() ?? "0").toFixed(2)}
                </Text>
                <Text style={styles.cardSub}>📅 {formatFecha(item.FECHA)}</Text>
              </View>
              <View style={styles.actionsCol}>
                <TouchableOpacity
                  style={styles.btnEdit}
                  onPress={async () => {
                    setCodigoActivo(item.CODIGO);
                    await cargarDetalle(item.ORC_KEY);
                    setOrcActiva(item.ORC_KEY);
                    setVista("detalle");
                  }}
                >
                  <Text style={styles.btnTextGold}>👁 Ver</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={styles.btnDelete}
                  onPress={() => handleEliminar(item.ORC_KEY)}
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

  // ── RENDER NUEVA ORDEN ────────────────────────────────────────────────────
  if (vista === "nuevaOrden") {
    return (
      <SafeAreaView style={styles.safeArea}>
        <ScrollView
          style={styles.container}
          contentContainerStyle={{ paddingBottom: 30 }}
          keyboardShouldPersistTaps="handled"
        >
          <View style={styles.formCard}>
            <View
              style={[
                styles.formCardHead,
                { flexDirection: "row", justifyContent: "space-between" },
              ]}
            >
              <Text style={styles.formCardTitle}>🛒 Nueva Orden de Compra</Text>
              <TouchableOpacity
                onPress={() => {
                  limpiarNueva();
                  setVista("lista");
                }}
              >
                <Text style={{ color: "#f0d9a0", fontWeight: "bold" }}>✕</Text>
              </TouchableOpacity>
            </View>
            <View style={styles.formCardBody}>
              <Text style={styles.label}>Proveedor *</Text>
              <View style={styles.searchRow}>
                <TextInput
                  style={[styles.searchInput, { flex: 1 }]}
                  placeholder="Buscar proveedor..."
                  value={searchProv}
                  onChangeText={setSearchProv}
                  autoCorrect={false}
                />
                <TouchableOpacity
                  style={styles.btnSearch}
                  onPress={async () => {
                    try {
                      setProveedores(await buscarProveedores(searchProv));
                      setShowProvList(true);
                    } catch (e: any) {
                      Alert.alert(
                        "😕 Error",
                        e.message ?? "No se pudo buscar.",
                      );
                    }
                  }}
                >
                  <Text style={styles.btnTextWhite}>🔍</Text>
                </TouchableOpacity>
              </View>
              {showProvList && (
                <View style={styles.dropdownList}>
                  {proveedores.map((p) => (
                    <TouchableOpacity
                      key={p.PROV_PROVEEDOR}
                      style={styles.dropdownItem}
                      onPress={() => {
                        setProveedorSel(p);
                        setSearchProv(p.PROV_NOMBRE);
                        setShowProvList(false);
                      }}
                    >
                      <Text style={{ color: "#333", fontWeight: "bold" }}>
                        {p.PROV_NOMBRE}
                      </Text>
                      <Text style={{ color: "#888", fontSize: 11 }}>
                        NIT: {p.PROV_NIT}
                      </Text>
                    </TouchableOpacity>
                  ))}
                </View>
              )}
              {proveedorSel && (
                <View style={styles.selectedBadge}>
                  <Text style={styles.selectedText}>
                    ✅ {proveedorSel.PROV_NOMBRE}
                  </Text>
                </View>
              )}

              <Text style={[styles.label, { marginTop: 12 }]}>
                Buscar Pedido *
              </Text>
              <View style={styles.searchRow}>
                <TextInput
                  style={[styles.searchInput, { flex: 1 }]}
                  placeholder="Código o número de pedido..."
                  value={searchPedido}
                  onChangeText={setSearchPedido}
                  autoCorrect={false}
                />
                <TouchableOpacity
                  style={styles.btnSearch}
                  onPress={handleBuscarPedidos}
                >
                  <Text style={styles.btnTextWhite}>🔍</Text>
                </TouchableOpacity>
              </View>

              {resultadosPedidos.map((p, idx) => (
                <View
                  key={`ped-${p.PED_PEDIDO}-${idx}`}
                  style={[styles.card, { marginBottom: 8 }]}
                >
                  <View style={{ flex: 1 }}>
                    <Text style={styles.badgeId}>{p.PED_CODIGO}</Text>
                    <Text style={styles.cardSub}>
                      Forma pago: {p.PED_FORMA_PAGO}
                    </Text>
                    {p.items.map((it, i) => (
                      <Text key={i} style={styles.cardSub}>
                        • {it.PRO_NOMBRE} ({it.DETPE_CANTIDAD_SOLICITADA} uds)
                      </Text>
                    ))}
                  </View>
                  <TouchableOpacity
                    style={p.YA_ASIGNADO ? styles.btnDisabled : styles.btnEdit}
                    onPress={() => seleccionarPedido(p)}
                  >
                    <Text
                      style={
                        p.YA_ASIGNADO
                          ? styles.btnTextDisabled
                          : styles.btnTextGold
                      }
                    >
                      {p.YA_ASIGNADO ? "🔒 Asignado" : "Seleccionar"}
                    </Text>
                  </TouchableOpacity>
                </View>
              ))}

              {pedidoVinculado && (
                <View style={[styles.formCard, { marginTop: 8 }]}>
                  <View style={styles.formCardHead}>
                    <Text style={styles.formCardTitle}>
                      📋 Pedido: {pedidoVinculado.PED_CODIGO} —{" "}
                      {pedidoVinculado.PED_FORMA_PAGO}
                    </Text>
                  </View>
                  <View style={styles.formCardBody}>
                    <Text style={styles.infoNote}>
                      Ingresa el precio de cada producto. Oracle validará y
                      calculará el total.
                    </Text>

                    {pedidoVinculado.items.map((it, idx) => {
                      const precioNum = parseFloat(it.precio.replace(",", "."));
                      const sinPrecio =
                        it.precio.trim() !== "" &&
                        (isNaN(precioNum) || precioNum <= 0);
                      return (
                        <View
                          key={idx}
                          style={[
                            styles.itemPrecioCard,
                            sinPrecio && styles.itemPrecioCardError,
                          ]}
                        >
                          <Text style={styles.detalleProd}>
                            {it.PRO_NOMBRE}
                          </Text>
                          {it.MATERIAL ? (
                            <Text style={styles.cardSub}>
                              Material: {it.MATERIAL}
                            </Text>
                          ) : null}
                          <Text style={styles.cardSub}>
                            Cantidad: {it.DETPE_CANTIDAD_SOLICITADA}
                          </Text>
                          <Text style={[styles.label, { marginTop: 6 }]}>
                            Precio unitario *
                          </Text>
                          <TextInput
                            style={[
                              styles.input,
                              sinPrecio && styles.inputError,
                            ]}
                            placeholder="0.00"
                            keyboardType="decimal-pad"
                            value={it.precio}
                            onChangeText={(v) => actualizarPrecioItem(idx, v)}
                          />
                          {sinPrecio && (
                            <Text style={styles.errorText}>
                              El precio debe ser mayor a 0.
                            </Text>
                          )}
                        </View>
                      );
                    })}

                    <TouchableOpacity
                      style={styles.btnOutline}
                      onPress={() => setPedidoVinculado(null)}
                    >
                      <Text style={styles.btnTextDark}>✕ Quitar pedido</Text>
                    </TouchableOpacity>
                  </View>
                </View>
              )}

              <View style={styles.modalActions}>
                <TouchableOpacity
                  style={styles.btnCancel}
                  onPress={() => {
                    limpiarNueva();
                    setVista("lista");
                  }}
                >
                  <Text style={styles.btnTextDark}>Cancelar</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={styles.btnSave}
                  onPress={handleCrearOrden}
                  disabled={loading}
                >
                  <Text style={styles.btnTextWhite}>💾 Confirmar Orden</Text>
                </TouchableOpacity>
              </View>
            </View>
          </View>
        </ScrollView>
      </SafeAreaView>
    );
  }

  // ── RENDER DETALLE ORDEN ──────────────────────────────────────────────────
  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView
        style={styles.container}
        contentContainerStyle={{ paddingBottom: 30 }}
      >
        <View style={styles.formCard}>
          <View
            style={[
              styles.formCardHead,
              {
                flexDirection: "row",
                justifyContent: "space-between",
                alignItems: "center",
              },
            ]}
          >
            <View style={{ flex: 1 }}>
              <View
                style={{
                  flexDirection: "row",
                  gap: 8,
                  alignItems: "center",
                  marginBottom: 4,
                }}
              >
                <Text style={[styles.badgeORC, { fontSize: 13 }]}>
                  🛒 {orcActiva}
                </Text>
                <Text style={[styles.badgeId, { fontSize: 13 }]}>
                  {codigoActivo}
                </Text>
              </View>
              {!!pedidoCodActivo && (
                <Text
                  style={{
                    color: "rgba(240,217,160,0.7)",
                    fontSize: 11,
                    marginTop: 2,
                  }}
                >
                  📋 {pedidoCodActivo}
                </Text>
              )}
            </View>
            <TouchableOpacity onPress={() => setVista("lista")}>
              <Text style={{ color: "#f0d9a0", fontWeight: "bold" }}>
                ✕ Cerrar
              </Text>
            </TouchableOpacity>
          </View>
          <View style={styles.formCardBody}>
            <View
              style={{
                flexDirection: "row",
                gap: 8,
                marginBottom: 10,
                flexWrap: "wrap",
              }}
            >
              <View
                style={[styles.selectedBadge, { flex: 1, marginBottom: 0 }]}
              >
                <Text style={styles.selectedText}>
                  💰 Total: Q {totalOrden}
                </Text>
              </View>
              {!!pedidoCodActivo && (
                <View
                  style={[
                    styles.selectedBadge,
                    {
                      flex: 1,
                      marginBottom: 0,
                      backgroundColor: "#eff6ff",
                      borderColor: "#bfdbfe",
                    },
                  ]}
                >
                  <Text style={[styles.selectedText, { color: "#1d4ed8" }]}>
                    📋 {pedidoCodActivo}
                  </Text>
                </View>
              )}
            </View>
            {itemsOrden.length === 0 ? (
              <Text style={styles.emptyText}>No hay items en esta orden.</Text>
            ) : (
              itemsOrden.map((it, idx) => (
                <View
                  key={(it as any).odp_orden_detalle_pedido ?? it.ODP_ID ?? idx}
                  style={styles.detalleRow}
                >
                  <View style={{ flex: 1 }}>
                    <Text style={styles.detalleProd}>
                      {(it as any).pro_nombre ?? it.ODP_PRODUCTO}
                    </Text>
                    {it.ODP_MATERIAL ? (
                      <Text style={styles.cardSub}>
                        Material: {it.ODP_MATERIAL}
                      </Text>
                    ) : null}
                    <Text style={styles.cardSub}>
                      Precio: Q{" "}
                      {parseFloat(it.ODP_PRECIO?.toString() ?? "0").toFixed(2)}{" "}
                      | Cant: {it.ODP_CANTIDAD}
                    </Text>
                  </View>
                </View>
              ))
            )}
            <TouchableOpacity
              style={[styles.btnGreen, { marginTop: 16 }]}
              onPress={() => setVista("lista")}
            >
              <Text style={styles.btnTextWhite}>✓ Finalizar</Text>
            </TouchableOpacity>
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: "#fdf8f3" },
  container: { flex: 1 },

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
  btnAdd: {
    backgroundColor: "#5C3A1E",
    padding: 12,
    borderRadius: 8,
    alignItems: "center",
    marginBottom: 12,
  },
  btnGreen: {
    backgroundColor: "#276749",
    padding: 12,
    borderRadius: 8,
    alignItems: "center",
  },
  btnOutline: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    padding: 10,
    borderRadius: 8,
    alignItems: "center",
    marginTop: 4,
  },
  btnTextWhite: { color: "white", fontWeight: "bold" },
  btnTextDark: { color: "#5C3A1E", fontWeight: "bold" },

  card: {
    backgroundColor: "white",
    padding: 14,
    borderRadius: 12,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    flexDirection: "row",
    gap: 8,
  },
  cardInfo: { flex: 1 },
  badgeORC: {
    backgroundColor: "#5C3A1E",
    color: "#f0d9a0",
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 12,
    fontSize: 12,
    fontWeight: "bold",
    alignSelf: "flex-start",
    overflow: "hidden",
  },
  badgeId: {
    backgroundColor: "#fdf6ec",
    color: "#C9973A",
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 12,
    fontSize: 12,
    fontWeight: "bold",
    alignSelf: "flex-start",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    overflow: "hidden",
  },
  cardTitle: {
    fontSize: 14,
    color: "#333",
    fontWeight: "bold",
    marginBottom: 2,
  },
  cardSub: { fontSize: 12, color: "#888", marginTop: 1 },
  actionsCol: { flexDirection: "column", gap: 6, justifyContent: "center" },
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
  btnTextRed: { color: "#e53e3e", fontSize: 12 },
  btnDisabled: {
    backgroundColor: "#f5f5f5",
    padding: 8,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: "#ddd",
  },
  btnTextDisabled: { color: "#aaa", fontSize: 11, fontWeight: "bold" },
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
    marginBottom: 4,
  },
  infoNote: {
    fontSize: 11,
    color: "#8B5E3C",
    fontStyle: "italic",
    marginBottom: 10,
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

  selectedBadge: {
    backgroundColor: "#f0fdf4",
    borderWidth: 1,
    borderColor: "#bbf7d0",
    borderRadius: 8,
    padding: 8,
    marginBottom: 10,
  },
  selectedText: { color: "#166534", fontWeight: "bold", fontSize: 13 },

  // card por item con precio — resalta en rojo si hay error
  itemPrecioCard: {
    backgroundColor: "#fdf8f3",
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    padding: 12,
    marginBottom: 12,
  },
  itemPrecioCardError: { borderColor: "#e53e3e", backgroundColor: "#fff5f5" },
  inputError: { borderColor: "#e53e3e", backgroundColor: "#fff5f5" },
  errorText: { fontSize: 11, color: "#e53e3e", marginBottom: 4 },

  detalleRow: {
    flexDirection: "row",
    paddingVertical: 10,
    borderBottomWidth: 1,
    borderBottomColor: "#f5ece0",
  },
  detalleProd: { fontSize: 13, color: "#333", fontWeight: "bold" },

  // ── Acciones — paddingHorizontal fijo, sin flex, no se cortan ──
  modalActions: {
    flexDirection: "row",
    justifyContent: "flex-end",
    gap: 10,
    marginTop: 16,
    flexWrap: "wrap",
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
});
