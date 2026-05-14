import { useLocalSearchParams, useRouter } from "expo-router";
import React, { useCallback, useEffect, useState } from "react";
import {
  ActivityIndicator,
  Alert,
  FlatList,
  KeyboardAvoidingView,
  Modal,
  Platform,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import { fetchAPI } from "../../../services/apiClient";
import { StockService } from "../../../services/catalogoInventario/stock";

// ─── Tipos ────────────────────────────────────────────────────────────────────
type StockItem = {
  HIP_HISTORIAL_PRECIO: number;
  PRO_REFERENCIA: string;
  PRO_NOMBRE: string;
  NIC_NICHO: number;
  NIC_NUMERO: string;
  NIC_CARACTERISTICA: string;
  ALM_NOMBRE: string;
  HIP_PRECIO: number;
  STO_MINIMO: number;
  STO_MAXIMO: number;
  STO_DISPONIBLE: number;
  ESTADO_STOCK: "BAJO" | "NORMAL" | "ALTO";
};

type Almacen = { ALM_ALMACEN: number; ALM_NOMBRE: string };
type Nicho = {
  NIC_NICHO: number;
  NIC_NUMERO: string;
  NIC_CARACTERISTICA: string;
};

const ALMACEN_HANDLER = "Handlers/CatalogoInventario/AlmacenesHandler.ashx";
const NICHO_HANDLER = "Handlers/CatalogoInventario/NichoHandler.ashx";

export default function StockScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<{
    fromped?: string;
    ref?: string;
    pedido?: string;
    detpe?: string;
    hip?: string;
    precio?: string;
    cantrecibida?: string;
    canttotalrecib?: string;
    nombre?: string;
    material?: string;
  }>();

  const fromPed = params.fromped === "1";
  const proRefParam = params.ref ?? "";
  const proNombre = params.nombre ?? proRefParam;
  const proMaterial = params.material ?? "";
  const pedidoId = Number(params.pedido ?? 0);
  const detpeId = Number(params.detpe ?? 0);
  const hipSemilla = Number(params.hip ?? 0);
  const precioODP = Number(params.precio ?? 0);
  const cantRecibida = Number(params.cantrecibida ?? 0);
  const cantTotal = Number(params.canttotalrecib ?? cantRecibida);

  // ── Estado tabla general ─────────────────────────────────────────────────
  const [stockGeneral, setStockGeneral] = useState<StockItem[]>([]);
  const [filtered, setFiltered] = useState<StockItem[]>([]);
  const [loadingTabla, setLoadingTabla] = useState(false);

  // inputs de filtro (pendientes)
  const [filtroProdInput, setFiltroProdInput] = useState("");
  const [filtroAlmInput, setFiltroAlmInput] = useState<number | null>(null);
  const [filtroNicInput, setFiltroNicInput] = useState<number | null>(null);

  // listas para dropdowns de filtro
  const [almacenesFilter, setAlmacenesFilter] = useState<Almacen[]>([]);
  const [nichosFilter, setNichosFilter] = useState<Nicho[]>([]);
  const [loadingAlmFilter, setLoadingAlmFilter] = useState(false);
  const [loadingNicFilter, setLoadingNicFilter] = useState(false);
  const [showAlmFilter, setShowAlmFilter] = useState(false);
  const [showNicFilter, setShowNicFilter] = useState(false);

  // ── Estado wizard fromped ────────────────────────────────────────────────
  const [almacenes, setAlmacenes] = useState<Almacen[]>([]);
  const [almSelId, setAlmSelId] = useState<number | null>(null);
  const [loadingAlm, setLoadingAlm] = useState(false);
  const [nichos, setNichos] = useState<Nicho[]>([]);
  const [nicSelId, setNicSelId] = useState<number | null>(null);
  const [loadingNichos, setLoadingNichos] = useState(false);
  const [stockNicho, setStockNicho] = useState<StockItem | null>(null);
  const [tieneStock, setTieneStock] = useState<boolean | null>(null);
  const [loadingPaso4, setLoadingPaso4] = useState(false);
  const [txtMin, setTxtMin] = useState("");
  const [txtMax, setTxtMax] = useState("");
  const [editLimites, setEditLimites] = useState(false);
  const [txtMinNuevo, setTxtMinNuevo] = useState("");
  const [txtMaxNuevo, setTxtMaxNuevo] = useState("");
  const [saving, setSaving] = useState(false);
  const [showAlmDropdown, setShowAlmDropdown] = useState(false);
  const [showNicDropdown, setShowNicDropdown] = useState(false);

  // ── Modal límites modo normal ────────────────────────────────────────────
  const [modalLimites, setModalLimites] = useState(false);
  const [itemActivo, setItemActivo] = useState<StockItem | null>(null);
  const [modalMin, setModalMin] = useState("");
  const [modalMax, setModalMax] = useState("");
  const [savingModal, setSavingModal] = useState(false);

  // ── Toggle filtros modo normal ───────────────────────────────────────────
  const [filtrosExpandido, setFiltrosExpandido] = useState(false);

  // ── Carga ────────────────────────────────────────────────────────────────
  const cargarTabla = useCallback(async () => {
    setLoadingTabla(true);
    try {
      const data = await StockService.listar();
      const list: StockItem[] = Array.isArray(data) ? data : [];
      setStockGeneral(list);
      setFiltered(list);
    } catch (err: any) {
      Alert.alert(
        "😕 Algo salió mal",
        err.message?.includes("500")
          ? "Error en el servidor. Contacta al administrador."
          : (err.message ?? "Ocurrió un error inesperado."),
      );
    } finally {
      setLoadingTabla(false);
    }
  }, []);

  const cargarAlmacenesFilter = async () => {
    setLoadingAlmFilter(true);
    try {
      const res = await fetchAPI(ALMACEN_HANDLER, "listar", "GET");
      const data = res?.data ?? res;
      setAlmacenesFilter(Array.isArray(data) ? data : []);
    } catch {
    } finally {
      setLoadingAlmFilter(false);
    }
  };

  const cargarNichosFilter = async (almId: number) => {
    setLoadingNicFilter(true);
    setNichosFilter([]);
    setFiltroNicInput(null);
    try {
      const data = await fetchAPI(
        NICHO_HANDLER,
        `listar_por_almacen&almacenId=${almId}`,
        "GET",
      );
      setNichosFilter(Array.isArray(data) ? data : []);
    } catch {
    } finally {
      setLoadingNicFilter(false);
    }
  };

  useEffect(() => {
    if (fromPed) {
      cargarAlmacenes();
    } else {
      cargarTabla();
      cargarAlmacenesFilter();
    }
  }, []);

  // ── PASO 2: Almacenes wizard ─────────────────────────────────────────────
  const cargarAlmacenes = async () => {
    setLoadingAlm(true);
    try {
      const res = await fetchAPI(ALMACEN_HANDLER, "listar", "GET");
      const data = res?.data ?? res;
      setAlmacenes(Array.isArray(data) ? data : []);
    } catch {
      Alert.alert("😕 Sin almacenes", "No se pudieron cargar los almacenes.");
    } finally {
      setLoadingAlm(false);
    }
  };

  // ── PASO 3: Nichos por almacén ───────────────────────────────────────────
  const seleccionarAlmacen = async (almId: number) => {
    setAlmSelId(almId);
    setNicSelId(null);
    setNichos([]);
    setStockNicho(null);
    setTieneStock(null);
    setLoadingNichos(true);
    try {
      const data = await fetchAPI(
        NICHO_HANDLER,
        `listar_por_almacen&almacenId=${almId}`,
        "GET",
      );
      setNichos(Array.isArray(data) ? data : []);
    } catch {
      Alert.alert("😕 Sin nichos", "No se pudieron cargar los nichos.");
    } finally {
      setLoadingNichos(false);
    }
  };

  // ── PASO 4: Stock del nicho ──────────────────────────────────────────────
  const seleccionarNicho = async (nicId: number) => {
    setNicSelId(nicId);
    setStockNicho(null);
    setTieneStock(null);
    setEditLimites(false);
    setLoadingPaso4(true);
    try {
      const data = await StockService.obtenerPorNicho(proRefParam, nicId);
      const list: StockItem[] = Array.isArray(data) ? data : [];
      if (list.length > 0) {
        const item = list[0];
        setStockNicho(item);
        setTieneStock(true);
        setTxtMin(item.STO_MINIMO.toString());
        setTxtMax(item.STO_MAXIMO.toString());
        setEditLimites(false);
      } else {
        setTieneStock(false);
        setTxtMinNuevo("");
        setTxtMaxNuevo("");
      }
    } catch {
      setTieneStock(false);
      setTxtMinNuevo("");
      setTxtMaxNuevo("");
    } finally {
      setLoadingPaso4(false);
    }
  };

  // ── Confirmar entrada existente ──────────────────────────────────────────
  const confirmarEntradaExistente = async () => {
    if (!stockNicho || nicSelId === null || saving) return;
    setSaving(true);
    try {
      await StockService.recibirDesdePedido({
        proReferencia: proRefParam,
        hipSemilla,
        nichoId: nicSelId,
        precio: precioODP,
        cantRecibida,
        cantTotal,
        detpeId,
        pedidoId,
      });
      Alert.alert(
        "✅ Recepción Confirmada",
        `La mercancía fue recibida en el nicho ${stockNicho.NIC_NUMERO}. El stock y el historial de precios han sido actualizados.`,
        [
          {
            text: "OK",
            onPress: () =>
              router.push({
                pathname: "/modules/comprasProveedor/pedidos" as any,
                params: { pedido: String(pedidoId) },
              }),
          },
        ],
      );
    } catch (err: any) {
      Alert.alert(
        "😕 Algo salió mal",
        err.message?.includes("500")
          ? "Error en el servidor."
          : (err.message ?? "Error inesperado."),
      );
    } finally {
      setSaving(false);
    }
  };

  // ── Confirmar crear stock ────────────────────────────────────────────────
  const confirmarCrearStock = async () => {
    if (nicSelId === null || saving) return;
    const min = parseInt(txtMinNuevo, 10);
    const max = parseInt(txtMaxNuevo, 10);
    if (isNaN(min) || isNaN(max)) {
      Alert.alert("Atención", "Mínimo y máximo son obligatorios.");
      return;
    }
    if (min > max) {
      Alert.alert("Atención", "El mínimo no puede ser mayor al máximo.");
      return;
    }
    setSaving(true);
    try {
      await StockService.recibirDesdePedido({
        proReferencia: proRefParam,
        hipSemilla,
        nichoId: nicSelId,
        precio: precioODP,
        cantRecibida,
        cantTotal,
        detpeId,
        pedidoId,
        minimo: min,
        maximo: max,
      });
      Alert.alert(
        "✅ Stock Creado",
        "El stock fue inicializado y la recepción quedó registrada.",
        [
          {
            text: "OK",
            onPress: () =>
              router.push({
                pathname: "/modules/comprasProveedor/pedidos" as any,
                params: { pedido: String(pedidoId) },
              }),
          },
        ],
      );
    } catch (err: any) {
      Alert.alert(
        "😕 Algo salió mal",
        err.message?.includes("500")
          ? "Error en el servidor."
          : (err.message ?? "Error inesperado."),
      );
    } finally {
      setSaving(false);
    }
  };

  // ── Guardar límites modal normal ─────────────────────────────────────────
  const guardarLimitesModal = async () => {
    if (!itemActivo) return;
    const min = parseInt(modalMin, 10);
    const max = parseInt(modalMax, 10);
    if (isNaN(min) || isNaN(max) || min > max) {
      Alert.alert(
        "⚠️ Límites inválidos",
        "El mínimo no puede ser mayor al máximo.",
      );
      return;
    }
    setSavingModal(true);
    try {
      await StockService.guardar(
        itemActivo.HIP_HISTORIAL_PRECIO,
        min,
        max,
        itemActivo.STO_DISPONIBLE,
      );
      Alert.alert("✅ Listo", "Los límites fueron actualizados correctamente.");
      setModalLimites(false);
      cargarTabla();
    } catch (err: any) {
      Alert.alert(
        "😕 Algo salió mal",
        err.message?.includes("500")
          ? "Error en el servidor."
          : (err.message ?? "Error inesperado."),
      );
    } finally {
      setSavingModal(false);
    }
  };

  // ── Filtros modo normal ──────────────────────────────────────────────────
  const aplicarFiltros = () => {
    let data = [...stockGeneral];
    if (filtroProdInput.trim())
      data = data.filter((i) =>
        i.PRO_NOMBRE.toUpperCase().includes(
          filtroProdInput.trim().toUpperCase(),
        ),
      );
    if (filtroAlmInput !== null)
      data = data.filter(
        (i) =>
          i.ALM_NOMBRE ===
          almacenesFilter.find((a) => a.ALM_ALMACEN === filtroAlmInput)
            ?.ALM_NOMBRE,
      );
    if (filtroNicInput !== null)
      data = data.filter((i) => i.NIC_NICHO === filtroNicInput);
    setFiltered(data);
  };

  const limpiarFiltros = () => {
    setFiltroProdInput("");
    setFiltroAlmInput(null);
    setFiltroNicInput(null);
    setNichosFilter([]);
    setFiltered(stockGeneral);
  };

  // ─── RENDER FROMPED ───────────────────────────────────────────────────────
  if (fromPed) {
    const almSel = almacenes.find((a) => a.ALM_ALMACEN === almSelId);
    const nicSel = nichos.find((n) => n.NIC_NICHO === nicSelId);
    const nuevoDisponible = stockNicho
      ? stockNicho.STO_DISPONIBLE + cantRecibida
      : cantRecibida;

    return (
      <View style={styles.wrapper}>
        <KeyboardAvoidingView
          style={styles.keyboardContainer}
          behavior={Platform.OS === "ios" ? "padding" : undefined}
        >
          <ScrollView
            contentContainerStyle={styles.container}
            keyboardShouldPersistTaps="handled"
            keyboardDismissMode="none"
          >
            <View style={styles.avisoPedido}>
              <Text style={styles.avisoTitle}>
                ⚠ Recepción de Pedido #{pedidoId}
              </Text>
              <Text style={styles.avisoText}>
                {"Selecciona el almacén y nicho donde ingresa la mercancía.\n"}
                {
                  "Al confirmar se registrará la cantidad recibida y el historial de precios se actualizará si el precio cambió.\n"
                }
                <Text style={{ fontStyle: "italic" }}>
                  Si salís sin confirmar, la cantidad recibida NO quedará
                  registrada.
                </Text>
              </Text>
            </View>

            {/* PASO 1 */}
            <View style={styles.stepCard}>
              <View style={styles.stepHeader}>
                <View style={styles.stepNum}>
                  <Text style={styles.stepNumText}>1</Text>
                </View>
                <Text style={styles.stepTitle}>Producto seleccionado</Text>
              </View>
              <View style={styles.infoBadge}>
                <Text style={styles.infoBadgeText}>{proNombre}</Text>
                {!!proMaterial && (
                  <Text style={styles.infoBadgeCant}>{proMaterial}</Text>
                )}
                <Text style={styles.infoBadgeCant}>
                  Cantidad a ingresar:{" "}
                  <Text style={{ fontWeight: "bold" }}>{cantRecibida}</Text>
                </Text>
                {precioODP > 0 && (
                  <Text style={styles.infoBadgeCant}>
                    Precio OC:{" "}
                    <Text style={{ fontWeight: "bold" }}>
                      Q {precioODP.toFixed(2)}
                    </Text>
                  </Text>
                )}
              </View>
            </View>

            {/* PASO 2 */}
            <View style={styles.stepCard}>
              <View style={styles.stepHeader}>
                <View style={styles.stepNum}>
                  <Text style={styles.stepNumText}>2</Text>
                </View>
                <Text style={styles.stepTitle}>Selecciona el Almacén</Text>
              </View>
              {loadingAlm ? (
                <ActivityIndicator color="#C9973A" />
              ) : (
                <>
                  <TouchableOpacity
                    style={styles.dropdownBtn}
                    onPress={() => setShowAlmDropdown((v) => !v)}
                  >
                    <Text
                      style={
                        almSelId
                          ? styles.dropdownBtnTextSel
                          : styles.dropdownBtnPlaceholder
                      }
                    >
                      {almSelId
                        ? (almacenes.find((a) => a.ALM_ALMACEN === almSelId)
                            ?.ALM_NOMBRE ?? "Seleccionar...")
                        : "Seleccionar almacén..."}
                    </Text>
                    <Text style={styles.dropdownArrow}>
                      {showAlmDropdown ? "▲" : "▼"}
                    </Text>
                  </TouchableOpacity>
                  {showAlmDropdown && (
                    <ScrollView
                      style={styles.dropdownList}
                      nestedScrollEnabled
                      keyboardShouldPersistTaps="handled"
                      keyboardDismissMode="none"
                    >
                      {almacenes.map((alm) => (
                        <TouchableOpacity
                          key={alm.ALM_ALMACEN}
                          style={[
                            styles.dropdownItem,
                            almSelId === alm.ALM_ALMACEN &&
                              styles.dropdownItemSel,
                          ]}
                          onPress={() => {
                            seleccionarAlmacen(alm.ALM_ALMACEN);
                            setShowAlmDropdown(false);
                          }}
                        >
                          <Text
                            style={[
                              styles.dropdownItemText,
                              almSelId === alm.ALM_ALMACEN &&
                                styles.dropdownItemTextSel,
                            ]}
                          >
                            {alm.ALM_NOMBRE}
                          </Text>
                          {almSelId === alm.ALM_ALMACEN && (
                            <Text style={{ color: "#C9973A" }}>✔</Text>
                          )}
                        </TouchableOpacity>
                      ))}
                    </ScrollView>
                  )}
                </>
              )}
            </View>

            {/* PASO 3 */}
            {almSelId !== null && (
              <View style={styles.stepCard}>
                <View style={styles.stepHeader}>
                  <View style={styles.stepNum}>
                    <Text style={styles.stepNumText}>3</Text>
                  </View>
                  <Text style={styles.stepTitle}>Selecciona el Nicho</Text>
                  <Text style={styles.stepSub}>{almSel?.ALM_NOMBRE}</Text>
                </View>
                {loadingNichos ? (
                  <ActivityIndicator color="#C9973A" />
                ) : nichos.length === 0 ? (
                  <Text style={styles.emptyState}>
                    No hay nichos en este almacén.
                  </Text>
                ) : (
                  <>
                    <TouchableOpacity
                      style={styles.dropdownBtn}
                      onPress={() => setShowNicDropdown((v) => !v)}
                    >
                      <Text
                        style={
                          nicSelId
                            ? styles.dropdownBtnTextSel
                            : styles.dropdownBtnPlaceholder
                        }
                      >
                        {nicSelId
                          ? (nichos.find((n) => n.NIC_NICHO === nicSelId)
                              ?.NIC_NUMERO ?? "Seleccionar...") +
                            (nichos.find((n) => n.NIC_NICHO === nicSelId)
                              ?.NIC_CARACTERISTICA
                              ? ` — ${nichos.find((n) => n.NIC_NICHO === nicSelId)?.NIC_CARACTERISTICA}`
                              : "")
                          : "Seleccionar nicho..."}
                      </Text>
                      <Text style={styles.dropdownArrow}>
                        {showNicDropdown ? "▲" : "▼"}
                      </Text>
                    </TouchableOpacity>
                    {showNicDropdown && (
                      <ScrollView
                        style={styles.dropdownList}
                        nestedScrollEnabled
                        keyboardShouldPersistTaps="handled"
                        keyboardDismissMode="none"
                      >
                        {nichos.map((nic) => (
                          <TouchableOpacity
                            key={nic.NIC_NICHO}
                            style={[
                              styles.dropdownItem,
                              nicSelId === nic.NIC_NICHO &&
                                styles.dropdownItemSel,
                            ]}
                            onPress={() => {
                              seleccionarNicho(nic.NIC_NICHO);
                              setShowNicDropdown(false);
                            }}
                          >
                            <Text
                              style={[
                                styles.dropdownItemText,
                                nicSelId === nic.NIC_NICHO &&
                                  styles.dropdownItemTextSel,
                              ]}
                            >
                              {nic.NIC_NUMERO}
                              {nic.NIC_CARACTERISTICA
                                ? ` — ${nic.NIC_CARACTERISTICA}`
                                : ""}
                            </Text>
                            {nicSelId === nic.NIC_NICHO && (
                              <Text style={{ color: "#C9973A" }}>✔</Text>
                            )}
                          </TouchableOpacity>
                        ))}
                      </ScrollView>
                    )}
                  </>
                )}
              </View>
            )}

            {/* PASO 4 */}
            {nicSelId !== null && (
              <View style={styles.stepCard}>
                <View style={styles.stepHeader}>
                  <View style={styles.stepNum}>
                    <Text style={styles.stepNumText}>4</Text>
                  </View>
                  <Text style={styles.stepTitle}>Gestionar Stock</Text>
                  <Text style={styles.stepSub}>
                    {nicSel
                      ? `${nicSel.NIC_NUMERO}${nicSel.NIC_CARACTERISTICA ? ` — ${nicSel.NIC_CARACTERISTICA}` : ""}`
                      : ""}
                  </Text>
                </View>

                {loadingPaso4 && (
                  <ActivityIndicator
                    color="#C9973A"
                    style={{ marginVertical: 12 }}
                  />
                )}

                {/* Con stock existente */}
                {!loadingPaso4 && tieneStock === true && stockNicho && (
                  <View>
                    <View style={styles.stockActual}>
                      <Text style={styles.stockActualTitle}>Stock Actual</Text>
                      <View style={styles.stockGrid}>
                        <View
                          style={[
                            styles.stockItem,
                            stockNicho.STO_DISPONIBLE <=
                              stockNicho.STO_MINIMO && styles.stockItemBajo,
                            stockNicho.STO_DISPONIBLE >=
                              stockNicho.STO_MAXIMO && styles.stockItemAlto,
                          ]}
                        >
                          <Text style={styles.stockVal}>
                            {stockNicho.STO_DISPONIBLE}
                          </Text>
                          <Text style={styles.stockLbl}>Disponible</Text>
                        </View>
                        <View style={styles.stockItem}>
                          <Text style={styles.stockVal}>
                            {stockNicho.STO_MINIMO}
                          </Text>
                          <Text style={styles.stockLbl}>Mínimo</Text>
                        </View>
                        <View style={styles.stockItem}>
                          <Text style={styles.stockVal}>
                            {stockNicho.STO_MAXIMO}
                          </Text>
                          <Text style={styles.stockLbl}>Máximo</Text>
                        </View>
                      </View>
                    </View>

                    <View style={styles.sumaInfo}>
                      <Text style={styles.sumaInfoText}>
                        {"➕ Al confirmar el disponible quedará en: "}
                        <Text style={styles.sumaInfoVal}>
                          {stockNicho.STO_DISPONIBLE} + {cantRecibida} ={" "}
                          <Text style={{ fontWeight: "900" }}>
                            {nuevoDisponible}
                          </Text>
                        </Text>
                      </Text>
                    </View>

                    <View style={styles.entradaCard}>
                      <Text style={styles.entradaTitle}>
                        Registrar Entrada de Mercancía
                      </Text>
                      <View style={styles.entradaRow}>
                        <View style={styles.entradaReadonly}>
                          <Text style={styles.entradaReadonlyVal}>
                            {cantRecibida}
                          </Text>
                          <Text style={styles.entradaReadonlyLbl}>
                            Cantidad a ingresar
                          </Text>
                        </View>
                        <TouchableOpacity
                          style={[styles.btnGreen, saving && { opacity: 0.6 }]}
                          onPress={confirmarEntradaExistente}
                          disabled={saving}
                        >
                          <Text style={styles.btnGreenText}>
                            {saving
                              ? "Confirmando..."
                              : "✔ Confirmar Recepción y Volver a Pedidos"}
                          </Text>
                        </TouchableOpacity>
                      </View>
                    </View>

                    {/* ── Ajustar límites: todos en la misma fila alineada ── */}
                    <View style={{ marginTop: 16 }}>
                      <Text style={styles.subLabel}>Ajustar Límites</Text>
                      {/* Fila con 3 celdas iguales: Disponible | Mínimo | Máximo */}
                      <View style={styles.limitesRow}>
                        <View style={styles.limiteCampo}>
                          <Text style={styles.label}>Disponible</Text>
                          <View style={styles.inputReadonly}>
                            <Text style={styles.inputReadonlyText}>
                              {stockNicho.STO_DISPONIBLE}
                            </Text>
                          </View>
                        </View>
                        <View style={styles.limiteCampo}>
                          <Text style={styles.label}>Mínimo *</Text>
                          <TextInput
                            style={[
                              styles.input,
                              styles.inputLimite,
                              !editLimites && styles.inputReadonlyField,
                            ]}
                            value={txtMin}
                            onChangeText={setTxtMin}
                            keyboardType="numeric"
                            editable={editLimites}
                          />
                        </View>
                        <View style={styles.limiteCampo}>
                          <Text style={styles.label}>Máximo *</Text>
                          <TextInput
                            style={[
                              styles.input,
                              styles.inputLimite,
                              !editLimites && styles.inputReadonlyField,
                            ]}
                            value={txtMax}
                            onChangeText={setTxtMax}
                            keyboardType="numeric"
                            editable={editLimites}
                          />
                        </View>
                      </View>

                      {!editLimites ? (
                        <TouchableOpacity
                          style={styles.btnOutline}
                          onPress={() => setEditLimites(true)}
                        >
                          <Text style={styles.btnOutlineText}>
                            ✎ Editar Límites
                          </Text>
                        </TouchableOpacity>
                      ) : (
                        <View style={{ flexDirection: "row", gap: 10 }}>
                          <TouchableOpacity
                            style={styles.btnOutline}
                            onPress={() => {
                              setEditLimites(false);
                              setTxtMin(stockNicho.STO_MINIMO.toString());
                              setTxtMax(stockNicho.STO_MAXIMO.toString());
                            }}
                          >
                            <Text style={styles.btnOutlineText}>Cancelar</Text>
                          </TouchableOpacity>
                          <TouchableOpacity
                            style={[styles.btnGold, saving && { opacity: 0.6 }]}
                            disabled={saving}
                            onPress={async () => {
                              const min = parseInt(txtMin, 10);
                              const max = parseInt(txtMax, 10);
                              if (isNaN(min) || isNaN(max) || min > max) {
                                Alert.alert(
                                  "Atención",
                                  "Mínimo no puede ser mayor al máximo.",
                                );
                                return;
                              }
                              setSaving(true);
                              try {
                                await StockService.guardar(
                                  stockNicho.HIP_HISTORIAL_PRECIO,
                                  min,
                                  max,
                                  stockNicho.STO_DISPONIBLE,
                                );
                                Alert.alert(
                                  "✅ Listo",
                                  "Los límites fueron actualizados.",
                                );
                                setEditLimites(false);
                                await seleccionarNicho(nicSelId!);
                              } catch (err: any) {
                                Alert.alert(
                                  "😕 Algo salió mal",
                                  err.message?.includes("500")
                                    ? "Error en el servidor."
                                    : (err.message ?? "Error inesperado."),
                                );
                              } finally {
                                setSaving(false);
                              }
                            }}
                          >
                            <Text style={styles.btnGoldText}>
                              Guardar Límites
                            </Text>
                          </TouchableOpacity>
                        </View>
                      )}
                    </View>
                  </View>
                )}

                {/* Sin stock */}
                {!loadingPaso4 && tieneStock === false && (
                  <View>
                    <View style={styles.avisoPrecio}>
                      <Text style={styles.avisoPrecioText}>
                        Este producto no tiene stock registrado en este nicho aún.
                      </Text>
                    </View>
                    {/* Misma fila alineada: Disponible inicial | Mínimo | Máximo */}
                    <View style={styles.limitesRow}>
                      <View style={styles.limiteCampo}>
                        <Text style={styles.label}>Disponible inicial</Text>
                        <View style={styles.inputReadonly}>
                          <Text style={styles.inputReadonlyText}>
                            {cantRecibida}
                          </Text>
                        </View>
                      </View>
                      <View style={styles.limiteCampo}>
                        <Text style={styles.label}>Mínimo *</Text>
                        <TextInput
                          style={[styles.input, styles.inputLimite]}
                          value={txtMinNuevo}
                          onChangeText={setTxtMinNuevo}
                          keyboardType="numeric"
                          placeholder="0"
                        />
                      </View>
                      <View style={styles.limiteCampo}>
                        <Text style={styles.label}>Máximo *</Text>
                        <TextInput
                          style={[styles.input, styles.inputLimite]}
                          value={txtMaxNuevo}
                          onChangeText={setTxtMaxNuevo}
                          keyboardType="numeric"
                          placeholder="0"
                        />
                      </View>
                    </View>
                    <TouchableOpacity
                      style={[styles.btnGold, saving && { opacity: 0.6 }]}
                      onPress={confirmarCrearStock}
                      disabled={saving}
                    >
                      <Text style={styles.btnGoldText}>
                        {saving
                          ? "Creando..."
                          : "✔ Confirmar Recepción y Volver a Pedidos"}
                      </Text>
                    </TouchableOpacity>
                  </View>
                )}
              </View>
            )}

            <TouchableOpacity
              style={[styles.btnOutline, { marginTop: 16 }]}
              onPress={() => router.back()}
            >
              <Text style={styles.btnOutlineText}>← Cancelar y volver</Text>
            </TouchableOpacity>
            <View style={{ height: 40 }} />
          </ScrollView>
        </KeyboardAvoidingView>
      </View>
    );
  }

  // ─── RENDER MODO NORMAL ───────────────────────────────────────────────────
  const renderItem = ({ item }: { item: StockItem }) => (
    <View style={styles.card}>
      <View style={styles.cardTop}>
        <View style={{ flex: 1 }}>
          <Text style={styles.cardProducto} numberOfLines={2}>
            {item.PRO_NOMBRE}
          </Text>
          <Text style={styles.cardSub}>
            {item.ALM_NOMBRE} · Nicho {item.NIC_NUMERO}
          </Text>
        </View>
      </View>
      <View style={styles.metricRow}>
        <View
          style={[
            styles.metricBox,
            item.STO_DISPONIBLE <= item.STO_MINIMO && styles.metricBajo,
            item.STO_DISPONIBLE >= item.STO_MAXIMO && styles.metricAlto,
          ]}
        >
          <Text style={styles.metricVal}>{item.STO_DISPONIBLE}</Text>
          <Text style={styles.metricLbl}>Disponible</Text>
        </View>
        <View style={styles.metricBox}>
          <Text style={styles.metricVal}>{item.STO_MINIMO}</Text>
          <Text style={styles.metricLbl}>Mínimo</Text>
        </View>
        <View style={styles.metricBox}>
          <Text style={styles.metricVal}>{item.STO_MAXIMO}</Text>
          <Text style={styles.metricLbl}>Máximo</Text>
        </View>
        <View style={styles.metricBox}>
          <Text style={styles.metricVal}>
            Q {Number(item.HIP_PRECIO).toFixed(2)}
          </Text>
          <Text style={styles.metricLbl}>Precio</Text>
        </View>
      </View>
      <View style={styles.cardActions}>
        <TouchableOpacity
          style={[styles.btnEditar, { flex: 1 }]}
          onPress={() => {
            setItemActivo(item);
            setModalMin(item.STO_MINIMO.toString());
            setModalMax(item.STO_MAXIMO.toString());
            setModalLimites(true);
          }}
        >
          <Text style={styles.btnEditarText}>✎ Editar Límites</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  return (
    <SafeAreaView style={styles.wrapper}>
      <KeyboardAvoidingView
        style={styles.keyboardContainer}
        behavior={Platform.OS === "ios" ? "padding" : undefined}
      >
        <View style={{ flex: 1 }}>
          {/* ══ FILTROS FUERA DEL FLATLIST ══ */}
          <View style={styles.filtrosCard}>
            {/* Título + toggle */}
            <TouchableOpacity
              style={styles.filtrosTitleRow}
              onPress={() => setFiltrosExpandido((v) => !v)}
            >
              <Text style={styles.filtrosTitle}>📦 Control de Stock</Text>
              <View
                style={{ flexDirection: "row", alignItems: "center", gap: 6 }}
              >
                {(filtroProdInput.trim() !== "" || filtroAlmInput !== null) && (
                  <View style={styles.filtrosDot} />
                )}
                <Text style={styles.filtrosToggleText}>
                  {filtrosExpandido ? "▲ Ocultar" : "▼ Filtros"}
                </Text>
              </View>
            </TouchableOpacity>

            {filtrosExpandido && (
              <>
                <TextInput
                  style={[styles.input, { marginTop: 12 }]}
                  placeholder="Buscar por producto..."
                  value={filtroProdInput}
                  onChangeText={setFiltroProdInput}
                  returnKeyType="search"
                  onSubmitEditing={aplicarFiltros}
                  autoCorrect={false}
                />

                <Text style={styles.label}>ALMACÉN</Text>
                <TouchableOpacity
                  style={styles.dropdownBtn}
                  onPress={() => {
                    setShowAlmFilter((v) => !v);
                    setShowNicFilter(false);
                  }}
                >
                  <Text
                    style={
                      filtroAlmInput
                        ? styles.dropdownBtnTextSel
                        : styles.dropdownBtnPlaceholder
                    }
                  >
                    {filtroAlmInput
                      ? (almacenesFilter.find(
                          (a) => a.ALM_ALMACEN === filtroAlmInput,
                        )?.ALM_NOMBRE ?? "Todos")
                      : "Todos los almacenes"}
                  </Text>
                  <Text style={styles.dropdownArrow}>
                    {showAlmFilter ? "▲" : "▼"}
                  </Text>
                </TouchableOpacity>
                {showAlmFilter && (
                  <ScrollView
                    style={styles.dropdownList}
                    nestedScrollEnabled
                    keyboardShouldPersistTaps="handled"
                    keyboardDismissMode="none"
                  >
                    <TouchableOpacity
                      style={styles.dropdownItem}
                      onPress={() => {
                        setFiltroAlmInput(null);
                        setFiltroNicInput(null);
                        setNichosFilter([]);
                        setShowAlmFilter(false);
                      }}
                    >
                      <Text style={styles.dropdownItemText}>
                        — Todos los almacenes —
                      </Text>
                    </TouchableOpacity>
                    {loadingAlmFilter ? (
                      <ActivityIndicator
                        color="#C9973A"
                        style={{ padding: 12 }}
                      />
                    ) : (
                      almacenesFilter.map((alm) => (
                        <TouchableOpacity
                          key={alm.ALM_ALMACEN}
                          style={[
                            styles.dropdownItem,
                            filtroAlmInput === alm.ALM_ALMACEN &&
                              styles.dropdownItemSel,
                          ]}
                          onPress={() => {
                            setFiltroAlmInput(alm.ALM_ALMACEN);
                            setShowAlmFilter(false);
                            cargarNichosFilter(alm.ALM_ALMACEN);
                          }}
                        >
                          <Text
                            style={[
                              styles.dropdownItemText,
                              filtroAlmInput === alm.ALM_ALMACEN &&
                                styles.dropdownItemTextSel,
                            ]}
                          >
                            {alm.ALM_NOMBRE}
                          </Text>
                          {filtroAlmInput === alm.ALM_ALMACEN && (
                            <Text style={{ color: "#C9973A" }}>✔</Text>
                          )}
                        </TouchableOpacity>
                      ))
                    )}
                  </ScrollView>
                )}

                {filtroAlmInput !== null && (
                  <>
                    <Text style={[styles.label, { marginTop: 8 }]}>NICHO</Text>
                    <TouchableOpacity
                      style={styles.dropdownBtn}
                      onPress={() => {
                        setShowNicFilter((v) => !v);
                        setShowAlmFilter(false);
                      }}
                    >
                      <Text
                        style={
                          filtroNicInput
                            ? styles.dropdownBtnTextSel
                            : styles.dropdownBtnPlaceholder
                        }
                      >
                        {filtroNicInput
                          ? (nichosFilter.find(
                              (n) => n.NIC_NICHO === filtroNicInput,
                            )?.NIC_NUMERO ?? "Todos") +
                            (nichosFilter.find(
                              (n) => n.NIC_NICHO === filtroNicInput,
                            )?.NIC_CARACTERISTICA
                              ? ` — ${nichosFilter.find((n) => n.NIC_NICHO === filtroNicInput)?.NIC_CARACTERISTICA}`
                              : "")
                          : "Todos los nichos"}
                      </Text>
                      <Text style={styles.dropdownArrow}>
                        {showNicFilter ? "▲" : "▼"}
                      </Text>
                    </TouchableOpacity>
                    {showNicFilter && (
                      <ScrollView
                        style={styles.dropdownList}
                        nestedScrollEnabled
                        keyboardShouldPersistTaps="handled"
                        keyboardDismissMode="none"
                      >
                        <TouchableOpacity
                          style={styles.dropdownItem}
                          onPress={() => {
                            setFiltroNicInput(null);
                            setShowNicFilter(false);
                          }}
                        >
                          <Text style={styles.dropdownItemText}>
                            — Todos los nichos —
                          </Text>
                        </TouchableOpacity>
                        {loadingNicFilter ? (
                          <ActivityIndicator
                            color="#C9973A"
                            style={{ padding: 12 }}
                          />
                        ) : (
                          nichosFilter.map((nic) => (
                            <TouchableOpacity
                              key={nic.NIC_NICHO}
                              style={[
                                styles.dropdownItem,
                                filtroNicInput === nic.NIC_NICHO &&
                                  styles.dropdownItemSel,
                              ]}
                              onPress={() => {
                                setFiltroNicInput(nic.NIC_NICHO);
                                setShowNicFilter(false);
                              }}
                            >
                              <Text
                                style={[
                                  styles.dropdownItemText,
                                  filtroNicInput === nic.NIC_NICHO &&
                                    styles.dropdownItemTextSel,
                                ]}
                              >
                                {nic.NIC_NUMERO}
                                {nic.NIC_CARACTERISTICA
                                  ? ` — ${nic.NIC_CARACTERISTICA}`
                                  : ""}
                              </Text>
                              {filtroNicInput === nic.NIC_NICHO && (
                                <Text style={{ color: "#C9973A" }}>✔</Text>
                              )}
                            </TouchableOpacity>
                          ))
                        )}
                      </ScrollView>
                    )}
                  </>
                )}

                <View style={{ flexDirection: "row", gap: 10, marginTop: 10 }}>
                  <TouchableOpacity
                    style={styles.btnOutline}
                    onPress={limpiarFiltros}
                  >
                    <Text style={styles.btnOutlineText}>Limpiar</Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={styles.btnGold}
                    onPress={aplicarFiltros}
                  >
                    <Text style={styles.btnGoldText}>🔍 Filtrar</Text>
                  </TouchableOpacity>
                </View>
              </>
            )}
          </View>

          <Text style={styles.contador}>
            Mostrando{" "}
            <Text style={{ fontWeight: "bold", color: "#5C3A1E" }}>
              {filtered.length}
            </Text>{" "}
            registro(s)
          </Text>

          {/* ══ LISTA ══ */}
          <FlatList
            data={filtered}
            keyExtractor={(item) => item.HIP_HISTORIAL_PRECIO.toString()}
            renderItem={renderItem}
            style={{ flex: 1 }}
            contentContainerStyle={{ padding: 15, paddingTop: 0 }}
            keyboardShouldPersistTaps="handled"
            keyboardDismissMode="none"
            ListEmptyComponent={
              loadingTabla ? (
                <ActivityIndicator
                  size="large"
                  color="#C9973A"
                  style={{ marginTop: 30 }}
                />
              ) : (
                <Text style={styles.emptyState}>No hay registros de stock.</Text>
              )
            }
            ListFooterComponent={<View style={{ height: 40 }} />}
          />
        </View>
      </KeyboardAvoidingView>

      {/* Modal límites */}
      <Modal visible={modalLimites} transparent animationType="slide">
        <View style={styles.modalOverlay}>
          <KeyboardAvoidingView
            style={styles.modalKeyboardContainer}
            behavior={Platform.OS === "ios" ? "padding" : undefined}
          >
            <View style={styles.modalBox}>
              <View style={styles.modalHeader}>
                <Text style={styles.modalTitle}>Ajustar Límites</Text>
              </View>
              {itemActivo && (
                <ScrollView
                  keyboardShouldPersistTaps="handled"
                  keyboardDismissMode="none"
                  showsVerticalScrollIndicator={false}
                >
                  <View style={styles.modalBody}>
                    <Text style={styles.modalProd}>{itemActivo.PRO_NOMBRE}</Text>
                    <Text style={styles.modalSub}>
                      {itemActivo.ALM_NOMBRE} · Nicho {itemActivo.NIC_NUMERO}
                    </Text>
                    <View style={styles.modalInfoBox}>
                      <Text style={styles.modalInfoVal}>
                        {itemActivo.STO_DISPONIBLE}
                      </Text>
                      <Text style={styles.modalInfoLbl}>Disponible actual</Text>
                    </View>
                    <Text style={styles.label}>Mínimo *</Text>
                    <TextInput
                      style={styles.input}
                      value={modalMin}
                      onChangeText={setModalMin}
                      keyboardType="numeric"
                    />
                    <Text style={styles.label}>Máximo *</Text>
                    <TextInput
                      style={styles.input}
                      value={modalMax}
                      onChangeText={setModalMax}
                      keyboardType="numeric"
                    />
                    <View style={{ flexDirection: "row", gap: 10 }}>
                      <TouchableOpacity
                        style={styles.btnOutline}
                        onPress={() => setModalLimites(false)}
                      >
                        <Text style={styles.btnOutlineText}>Cancelar</Text>
                      </TouchableOpacity>
                      <TouchableOpacity
                        style={styles.btnGold}
                        onPress={guardarLimitesModal}
                        disabled={savingModal}
                      >
                        <Text style={styles.btnGoldText}>
                          {savingModal ? "Guardando..." : "Guardar"}
                        </Text>
                      </TouchableOpacity>
                    </View>
                  </View>
                </ScrollView>
              )}
            </View>
          </KeyboardAvoidingView>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  wrapper: { flex: 1, backgroundColor: "#f0ebe0" },
  keyboardContainer: { flex: 1 },
  modalKeyboardContainer: { width: "100%" },
  container: { padding: 15 },

  // aviso pedido
  avisoPedido: {
    backgroundColor: "#fff8e1",
    borderRadius: 10,
    padding: 14,
    borderWidth: 1,
    borderColor: "#ffe082",
    marginBottom: 16,
  },
  avisoTitle: {
    fontSize: 14,
    fontWeight: "bold",
    color: "#7a5818",
    marginBottom: 6,
  },
  avisoText: { fontSize: 12, color: "#5a4010", lineHeight: 18 },

  // steps
  stepCard: {
    backgroundColor: "white",
    borderRadius: 12,
    padding: 16,
    marginBottom: 14,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    elevation: 2,
    zIndex: 1,
  },
  stepHeader: {
    flexDirection: "row",
    alignItems: "center",
    marginBottom: 14,
    gap: 10,
  },
  stepNum: {
    backgroundColor: "#C9973A",
    width: 26,
    height: 26,
    borderRadius: 13,
    alignItems: "center",
    justifyContent: "center",
  },
  stepNumText: { color: "#1a0e05", fontWeight: "bold", fontSize: 13 },
  stepTitle: { fontSize: 15, fontWeight: "bold", color: "#5C3A1E", flex: 1 },
  stepSub: { fontSize: 11, color: "#888" },
  infoBadge: {
    backgroundColor: "#fdf6ec",
    borderRadius: 8,
    padding: 10,
    borderWidth: 1,
    borderColor: "#e8d0a0",
  },
  infoBadgeText: {
    fontSize: 14,
    fontWeight: "bold",
    color: "#5C3A1E",
    marginBottom: 4,
  },
  infoBadgeCant: { fontSize: 13, color: "#5C3A1E" },

  // stock actual
  stockActual: {
    backgroundColor: "#f0f7ff",
    borderRadius: 10,
    padding: 14,
    borderWidth: 1,
    borderColor: "#b0c8f0",
    marginBottom: 12,
  },
  stockActualTitle: {
    fontSize: 12,
    fontWeight: "bold",
    color: "#3060c0",
    textTransform: "uppercase",
    marginBottom: 10,
  },
  stockGrid: { flexDirection: "row", gap: 8 },
  stockItem: {
    flex: 1,
    backgroundColor: "white",
    borderRadius: 8,
    padding: 10,
    alignItems: "center",
    borderWidth: 1,
    borderColor: "#e0d0b8",
  },
  stockItemBajo: { borderColor: "#fed7d7", backgroundColor: "#fff5f5" },
  stockItemAlto: { borderColor: "#e8d0a0", backgroundColor: "#fdf6ec" },
  stockVal: { fontSize: 22, fontWeight: "900", color: "#1a0e05" },
  stockLbl: {
    fontSize: 9,
    color: "#aaa",
    textTransform: "uppercase",
    marginTop: 3,
  },

  sumaInfo: {
    backgroundColor: "#e8f5e9",
    borderRadius: 8,
    padding: 10,
    borderWidth: 1,
    borderColor: "#a5d6a7",
    marginBottom: 12,
  },
  sumaInfoText: { fontSize: 13, color: "#1b5e20" },
  sumaInfoVal: { color: "#276749" },

  entradaCard: {
    backgroundColor: "#f0fff4",
    borderRadius: 10,
    padding: 14,
    borderWidth: 1,
    borderColor: "#9ae6b4",
    marginBottom: 12,
  },
  entradaTitle: {
    fontSize: 12,
    fontWeight: "bold",
    color: "#276749",
    textTransform: "uppercase",
    marginBottom: 12,
  },
  entradaRow: {
    flexDirection: "row",
    gap: 12,
    alignItems: "center",
    flexWrap: "wrap",
  },
  entradaReadonly: {
    alignItems: "center",
    backgroundColor: "#e6ffed",
    borderRadius: 8,
    padding: 10,
    borderWidth: 2,
    borderColor: "#c6f6d5",
    minWidth: 90,
  },
  entradaReadonlyVal: { fontSize: 24, fontWeight: "900", color: "#276749" },
  entradaReadonlyLbl: {
    fontSize: 9,
    color: "#276749",
    textTransform: "uppercase",
    marginTop: 2,
    textAlign: "center",
  },

  subLabel: {
    fontSize: 12,
    fontWeight: "bold",
    color: "#5C3A1E",
    textTransform: "uppercase",
    marginBottom: 10,
  },

  // ── Límites: fila alineada ──
  // flex: 1 + altura fija garantizan que Disponible, Mínimo y Máximo queden en la misma línea
  limitesRow: {
    flexDirection: "row",
    gap: 8,
    marginBottom: 12,
    alignItems: "flex-end",
  },
  limiteCampo: { flex: 1 },
  inputReadonly: {
    backgroundColor: "#f5f0eb",
    borderWidth: 1.5,
    borderColor: "#e0d0b8",
    borderRadius: 8,
    height: 46, // misma altura que los TextInput de límites
    alignItems: "center",
    justifyContent: "center",
  },
  inputReadonlyText: { color: "#888", fontSize: 14 },
  inputReadonlyField: { backgroundColor: "#f5f0eb", color: "#888" },
  // TextInput de límites con altura fija para coincidir con inputReadonly
  inputLimite: { height: 46, marginBottom: 0, paddingVertical: 0 },

  avisoPrecio: {
    backgroundColor: "#fff8e1",
    borderRadius: 8,
    padding: 12,
    borderWidth: 1,
    borderColor: "#ffe082",
    marginBottom: 12,
  },
  avisoPrecioText: { fontSize: 13, color: "#7a5818" },

  // botones
  btnGold: {
    backgroundColor: "#C9973A",
    paddingVertical: 12,
    paddingHorizontal: 18,
    borderRadius: 8,
    alignItems: "center",
    flex: 1,
  },
  btnGoldText: { color: "#1a1a1a", fontWeight: "bold", fontSize: 14 },
  btnGreen: {
    backgroundColor: "#276749",
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    alignItems: "center",
    flex: 1,
  },
  btnGreenText: { color: "white", fontWeight: "bold", fontSize: 13 },
  btnOutline: {
    backgroundColor: "white",
    borderWidth: 2,
    borderColor: "#e8d8c0",
    paddingVertical: 12,
    paddingHorizontal: 18,
    borderRadius: 8,
    alignItems: "center",
    flex: 1,
  },
  btnOutlineText: { color: "#5C3A1E", fontWeight: "bold", fontSize: 14 },
  btnEditar: {
    backgroundColor: "#fdf6ec",
    borderWidth: 1,
    borderColor: "#e8d0a0",
    paddingVertical: 9,
    borderRadius: 7,
    alignItems: "center",
  },
  btnEditarText: { color: "#C9973A", fontWeight: "bold", fontSize: 13 },

  // filtros modo normal
  filtrosCard: {
    backgroundColor: "white",
    borderRadius: 12,
    padding: 16,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    margin: 15,
    marginBottom: 8,
    elevation: 2,
  },
  filtrosTitleRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  filtrosTitle: { fontSize: 16, fontWeight: "bold", color: "#5C3A1E" },
  filtrosToggleText: { fontSize: 12, color: "#C9973A", fontWeight: "bold" },
  filtrosDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: "#C9973A",
  },
  contador: {
    fontSize: 12,
    color: "#888",
    marginBottom: 8,
    marginHorizontal: 15,
  },

  input: {
    backgroundColor: "#fdf8f3",
    borderWidth: 2,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 11,
    fontSize: 14,
    marginBottom: 12,
    color: "#333",
  },
  label: {
    fontSize: 11,
    fontWeight: "bold",
    color: "#5C3A1E",
    textTransform: "uppercase",
    marginBottom: 5,
  },

  // tarjeta
  card: {
    backgroundColor: "white",
    borderRadius: 12,
    padding: 15,
    marginBottom: 14,
    borderWidth: 1,
    borderColor: "#e8d8c0",
    elevation: 2,
  },
  cardTop: { flexDirection: "row", alignItems: "flex-start", marginBottom: 12 },
  cardProducto: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#3a1f0a",
    marginBottom: 3,
  },
  cardSub: { fontSize: 12, color: "#888" },
  cardCaract: {
    fontSize: 11,
    color: "#aaa",
    marginTop: 2,
    fontStyle: "italic",
  },
  metricRow: {
    flexDirection: "row",
    gap: 8,
    marginBottom: 14,
    borderTopWidth: 1,
    borderTopColor: "#f5ece0",
    paddingTop: 12,
  },
  metricBox: {
    flex: 1,
    alignItems: "center",
    backgroundColor: "#fdf8f3",
    borderRadius: 8,
    padding: 8,
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  metricBajo: { borderColor: "#fed7d7", backgroundColor: "#fff5f5" },
  metricAlto: { borderColor: "#e8d0a0", backgroundColor: "#fdf6ec" },
  metricVal: { fontSize: 16, fontWeight: "900", color: "#1a0e05" },
  metricLbl: {
    fontSize: 9,
    color: "#aaa",
    textTransform: "uppercase",
    marginTop: 2,
  },
  cardActions: {
    flexDirection: "row",
    gap: 10,
    borderTopWidth: 1,
    borderTopColor: "#f5ece0",
    paddingTop: 12,
  },

  // modal
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.45)",
    justifyContent: "flex-end",
  },
  modalBox: {
    backgroundColor: "white",
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    overflow: "hidden",
  },
  modalHeader: { backgroundColor: "#5C3A1E", padding: 18 },
  modalTitle: { color: "#f0d9a0", fontSize: 16, fontWeight: "bold" },
  modalBody: { padding: 20 },
  modalProd: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#3a1f0a",
    marginBottom: 3,
  },
  modalSub: { fontSize: 12, color: "#888", marginBottom: 14 },
  modalInfoBox: {
    backgroundColor: "#f0f7ff",
    borderRadius: 10,
    padding: 12,
    borderWidth: 1,
    borderColor: "#b0c8f0",
    alignItems: "center",
    marginBottom: 16,
  },
  modalInfoVal: { fontSize: 28, fontWeight: "900", color: "#3060c0" },
  modalInfoLbl: {
    fontSize: 10,
    color: "#888",
    textTransform: "uppercase",
    marginTop: 3,
  },

  emptyState: {
    textAlign: "center",
    color: "#aaa",
    marginTop: 30,
    fontStyle: "italic",
    fontSize: 14,
  },

  // dropdowns
  dropdownBtn: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    backgroundColor: "#fdf8f3",
    borderWidth: 2,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    padding: 12,
    marginBottom: 4,
  },
  dropdownBtnTextSel: {
    fontSize: 14,
    color: "#333",
    flex: 1,
    fontWeight: "bold",
  },
  dropdownBtnPlaceholder: { fontSize: 14, color: "#aaa", flex: 1 },
  dropdownArrow: { fontSize: 12, color: "#5C3A1E", marginLeft: 8 },
  dropdownList: {
    backgroundColor: "white",
    borderWidth: 1,
    borderColor: "#e8d8c0",
    borderRadius: 8,
    marginBottom: 12,
    maxHeight: 160,
    elevation: 10,
    zIndex: 999,
    overflow: "hidden",
  },
  dropdownItem: {
    padding: 12,
    borderBottomWidth: 1,
    borderBottomColor: "#f5ece0",
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  dropdownItemSel: { backgroundColor: "#fdf6ec" },
  dropdownItemText: { fontSize: 14, color: "#333", flex: 1 },
  dropdownItemTextSel: { color: "#C9973A", fontWeight: "bold" },
});