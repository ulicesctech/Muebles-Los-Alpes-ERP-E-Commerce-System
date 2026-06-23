import { useState, useEffect, useMemo } from "react";
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
  FlatList,
  ScrollView,
} from "react-native";
import { useLocalSearchParams } from "expo-router";
import { fetchAPI } from "../../../services/apiClient";
import { crearFactura } from "../../../services/facturaService";
import { Carrito, listarCarritos } from "../../../services/carritoService";

interface Factura {
  FACLI_CODIGO_FACTURA: string;
  PRE_CORRELATIVO: string;
  NOMBRE_EMPLEADO: string;
  FACLI_FECHA: string;
}

interface Empleado {
  em_empleado: number;
  em_primer_nombre: string;
  em_primer_apellido: string;
}

export default function FacturaScreen() {
  const { carrito: carritoParam } = useLocalSearchParams();

  const carrito = useMemo<Carrito | null>(() => {
    if (!carritoParam || typeof carritoParam !== "string") return null;
    try {
      return JSON.parse(carritoParam);
    } catch {
      return null;
    }
  }, [carritoParam]);

  const modoFormulario = carrito !== null;

  const [empleados, setEmpleados] = useState<Empleado[]>([]);
  const [empleadoId, setEmpleadoId] = useState<number | null>(null);
  const [generando, setGenerando] = useState(false);
  const [codigoGenerado, setCodigoGenerado] = useState<string | null>(null);

  const [facturas, setFacturas] = useState<Factura[]>([]);
  const [carritosPorCorrelativo, setCarritosPorCorrelativo] = useState<
    Record<string, Carrito>
  >({});

  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const cargar = async () => {
      try {
        if (modoFormulario) {
          const result = await fetchAPI(
            "Handlers/Auth/AuthHandler.ashx",
            "listar-empleados",
          );
          const lista: Empleado[] = result.data;
          setEmpleados(lista);
          if (lista.length > 0) setEmpleadoId(lista[0].em_empleado);
        } else {
          const [listaFacturas, listaCarritos] = await Promise.all([
            fetchAPI(
              "Handlers/VentasFacturacion/FacturaHandler.ashx",
              "listar",
              "GET",
            ),
            listarCarritos(),
          ]);
          setFacturas(listaFacturas);
          const mapa: Record<string, Carrito> = {};
          listaCarritos.forEach((c) => {
            mapa[c.PRE_CORRELATIVO] = c;
          });
          setCarritosPorCorrelativo(mapa);
        }
      } catch {
        Alert.alert(
          "Error",
          modoFormulario
            ? "No se pudieron cargar los empleados."
            : "No se pudieron cargar las facturas.",
        );
      } finally {
        setLoading(false);
      }
    };
    cargar();
  }, [modoFormulario]);

  const handleGenerar = async () => {
    if (!empleadoId || !carrito) {
      Alert.alert("Error", "Selecciona un empleado.");
      return;
    }
    try {
      setGenerando(true);
      const codigo = await crearFactura(carrito.PRE_CARRITO, empleadoId);
      await fetchAPI(
        "Handlers/VentasFacturacion/CarritoHandler.ashx",
        `facturar&carrito=${carrito.PRE_CARRITO}`,
        "POST",
      );
      setCodigoGenerado(codigo);
    } catch (error: any) {
      Alert.alert("Error", error?.message || "No se pudo generar la factura.");
    } finally {
      setGenerando(false);
    }
  };

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#5c3a1e" />
        <Text style={styles.loadingTexto}>
          {modoFormulario ? "Cargando empleados..." : "Cargando facturas..."}
        </Text>
      </View>
    );
  }

  if (modoFormulario) {
    return (
      <View style={styles.container}>
        <View style={styles.carritoCard}>
          <Text style={styles.sectionLabel}>Carrito a facturar</Text>
          <Text style={styles.correlativo}>{carrito!.PRE_CORRELATIVO}</Text>
          <Text style={styles.cliente}>👤 {carrito!.NOMBRE_CLIENTE}</Text>
          <Text style={styles.totalCarrito}>
            Total: Q {parseFloat(String(carrito!.PRE_TOTAL || "0")).toFixed(2)}
          </Text>
        </View>

        <View style={styles.formulario}>
          <Text style={styles.sectionLabel}>Empleado</Text>
          <ScrollView style={styles.listaWrapper} nestedScrollEnabled>
            {empleados.map((e) => (
              <TouchableOpacity
                key={e.em_empleado}
                style={[
                  styles.opcionItem,
                  empleadoId === e.em_empleado && styles.opcionItemSelected,
                ]}
                onPress={() => setEmpleadoId(e.em_empleado)}
              >
                <Text
                  style={[
                    styles.opcionText,
                    empleadoId === e.em_empleado && styles.opcionTextSelected,
                  ]}
                >
                  {e.em_primer_nombre} {e.em_primer_apellido}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>

          <TouchableOpacity
            style={[
              styles.btnGenerar,
              (generando || !!codigoGenerado) && styles.btnDisabled,
            ]}
            onPress={handleGenerar}
            disabled={generando || !!codigoGenerado}
          >
            <Text style={styles.btnGenerarTexto}>
              {generando ? "Generando..." : "🧾 Generar Factura"}
            </Text>
          </TouchableOpacity>
        </View>

        {codigoGenerado && (
          <View style={styles.resultCard}>
            <Text style={styles.resultLabel}>Factura generada</Text>
            <Text style={styles.resultCodigo}>{codigoGenerado}</Text>
          </View>
        )}
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.titulo}>Facturas Emitidas</Text>
      {facturas.length === 0 ? (
        <View style={styles.loadingContainer}>
          <Text style={styles.loadingTexto}>No hay facturas registradas.</Text>
        </View>
      ) : (
        <FlatList
          data={facturas}
          keyExtractor={(item, index) =>
            item.FACLI_CODIGO_FACTURA ?? String(index)
          }
          renderItem={({ item }) => (
            <View style={styles.card}>
              <View style={styles.cardHeader}>
                <Text style={styles.codigo}>{item.FACLI_CODIGO_FACTURA}</Text>
                <Text style={styles.fecha}>📅 {item.FACLI_FECHA}</Text>
              </View>
              <Text style={styles.valor}>
                🛒 Carrito: {item.PRE_CORRELATIVO}
              </Text>
              <Text style={styles.empleado}>👤 {item.NOMBRE_EMPLEADO}</Text>
              <Text style={styles.monto}>
                Q{" "}
                {parseFloat(
                  String(
                    carritosPorCorrelativo[item.PRE_CORRELATIVO]?.PRE_TOTAL ||
                      "0",
                  ),
                ).toFixed(2)}
              </Text>
            </View>
          )}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#f8f3eb", padding: 16 },
  loadingContainer: {
    flex: 1,
    backgroundColor: "#f8f3eb",
    justifyContent: "center",
    alignItems: "center",
  },
  loadingTexto: { marginTop: 12, color: "#5c3a1e", fontSize: 15 },
  titulo: {
    fontSize: 18,
    fontWeight: "bold",
    color: "#3a1f0a",
    marginBottom: 16,
  },
  carritoCard: {
    backgroundColor: "#fff",
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: "#dcc29a",
    elevation: 3,
  },
  formulario: {
    backgroundColor: "#fff",
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: "#dcc29a",
    elevation: 3,
  },
  sectionLabel: {
    fontSize: 12,
    fontWeight: "bold",
    color: "#999",
    textTransform: "uppercase",
    marginBottom: 8,
  },
  correlativo: {
    fontSize: 18,
    fontWeight: "bold",
    color: "#5c3a1e",
    marginBottom: 4,
  },
  cliente: { fontSize: 14, color: "#3a281b", marginBottom: 4 },
  totalCarrito: { fontSize: 15, fontWeight: "bold", color: "#c9973a" },
  listaWrapper: {
    maxHeight: 180,
    borderWidth: 1,
    borderColor: "#dcc29a",
    borderRadius: 8,
    marginBottom: 16,
  },
  opcionItem: {
    padding: 12,
    borderBottomWidth: 1,
    borderBottomColor: "#f0e8d8",
  },
  opcionItemSelected: { backgroundColor: "#5c3a1e" },
  opcionText: { fontSize: 14, color: "#3a281b" },
  opcionTextSelected: { color: "#f7deb0", fontWeight: "bold" },
  btnGenerar: {
    backgroundColor: "#5c3a1e",
    padding: 16,
    borderRadius: 10,
    alignItems: "center",
  },
  btnDisabled: { opacity: 0.6 },
  btnGenerarTexto: { color: "#f7deb0", fontWeight: "bold", fontSize: 15 },
  resultCard: {
    backgroundColor: "#5c3a1e",
    borderRadius: 12,
    padding: 20,
    alignItems: "center",
    borderWidth: 1,
    borderColor: "#c9973a",
    elevation: 3,
  },
  resultLabel: {
    fontSize: 12,
    fontWeight: "bold",
    color: "#c9973a",
    textTransform: "uppercase",
    marginBottom: 8,
  },
  resultCodigo: {
    fontSize: 20,
    fontWeight: "bold",
    color: "#f7deb0",
    textAlign: "center",
  },
  card: {
    backgroundColor: "#fff",
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: "#dcc29a",
    elevation: 3,
  },
  cardHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 8,
  },
  codigo: { fontSize: 15, fontWeight: "bold", color: "#5c3a1e", flex: 1 },
  fecha: { fontSize: 12, color: "#999" },
  valor: { fontSize: 14, color: "#3a281b", marginBottom: 4 },
  empleado: { fontSize: 13, color: "#6f5a49", marginBottom: 4 },
  monto: { fontSize: 15, fontWeight: "bold", color: "#c9973a" },
});
