import { useEffect, useState } from 'react';
import {
  View, Text, StyleSheet, ActivityIndicator,
  FlatList, Alert, ScrollView,
} from 'react-native';
import { fetchAPI } from '../../../services/apiClient';
import { listarCarritos, Carrito } from '../../../services/carritoService';

interface Factura {
  FACLI_CODIGO_FACTURA: string;
  PRE_CORRELATIVO: string;
  NOMBRE_EMPLEADO: string;
  FACLI_FECHA: string;
}

const hoy = new Date();
const hoyISO = `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, '0')}-${String(hoy.getDate()).padStart(2, '0')}`;

const fechaHaciaISO = (raw: string): string => {
  if (!raw) return '';
  // "dd/MM/yyyy ..." o "dd/MM/yyyy"
  if (/^\d{2}\/\d{2}\/\d{4}/.test(raw)) {
    const [d, m, y] = raw.split('/');
    return `${y}-${m}-${d.slice(0, 2)}`;
  }
  // "yyyy-MM-ddT..." o "yyyy-MM-dd"
  return raw.slice(0, 10);
};

export default function DashboardVentas() {
  const [loading, setLoading] = useState(true);
  const [facturasHoy, setFacturasHoy] = useState<Factura[]>([]);
  const [totalVentas, setTotalVentas] = useState(0);
  const [ultimas, setUltimas] = useState<Factura[]>([]);

  useEffect(() => {
    const cargar = async () => {
      try {
        const [todasFacturas, todosCarritos]: [Factura[], Carrito[]] = await Promise.all([
          fetchAPI('Handlers/VentasFacturacion/FacturaHandler.ashx', 'listar', 'GET'),
          listarCarritos(),
        ]);

        const mapaCarritos: Record<string, Carrito> = {};
        todosCarritos.forEach((c) => { mapaCarritos[c.PRE_CORRELATIVO] = c; });

        if (todasFacturas.length > 0) {
          console.log('[Dashboard] FACLI_FECHA muestra:', todasFacturas[0].FACLI_FECHA);
        }

        const del_dia = todasFacturas.filter(
          (f) => fechaHaciaISO(f.FACLI_FECHA) === hoyISO
        );

        const total = del_dia.reduce((sum, f) => {
          const carrito = mapaCarritos[f.PRE_CORRELATIVO];
          return sum + parseFloat(String(carrito?.PRE_TOTAL || 0));
        }, 0);

        setFacturasHoy(del_dia);
        setTotalVentas(total);
        setUltimas(todasFacturas.slice(0, 5));
      } catch {
        Alert.alert('Error', 'No se pudo cargar el dashboard de ventas.');
      } finally {
        setLoading(false);
      }
    };
    cargar();
  }, []);

  if (loading) {
    return (
      <View style={styles.centered}>
        <ActivityIndicator size="large" color="#5c3a1e" />
        <Text style={styles.loadingTexto}>Cargando dashboard...</Text>
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.titulo}>Dashboard Ventas</Text>
      <Text style={styles.fecha}>Hoy: {hoyISO}</Text>

      <View style={styles.metricsRow}>
        <View style={styles.metricCard}>
          <Text style={styles.metricValue}>{facturasHoy.length}</Text>
          <Text style={styles.metricLabel}>Facturas hoy</Text>
        </View>
        <View style={styles.metricCard}>
          <Text style={styles.metricValue}>Q {totalVentas.toFixed(2)}</Text>
          <Text style={styles.metricLabel}>Ventas del día</Text>
        </View>
      </View>

      <Text style={styles.seccion}>Últimas 5 facturas</Text>
      {ultimas.length === 0 ? (
        <Text style={styles.vacio}>No hay facturas registradas.</Text>
      ) : (
        <FlatList
          data={ultimas}
          keyExtractor={(item) => item.FACLI_CODIGO_FACTURA}
          scrollEnabled={false}
          renderItem={({ item }) => (
            <View style={styles.card}>
              <View style={styles.cardHeader}>
                <Text style={styles.codigo}>{item.FACLI_CODIGO_FACTURA}</Text>
                <Text style={styles.fecha_item}>{item.FACLI_FECHA?.slice(0, 10)}</Text>
              </View>
              <Text style={styles.detalle}>🛒 {item.PRE_CORRELATIVO}</Text>
              <Text style={styles.detalle}>👤 {item.NOMBRE_EMPLEADO}</Text>
            </View>
          )}
        />
      )}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f3eb', padding: 16 },
  centered: { flex: 1, backgroundColor: '#f8f3eb', justifyContent: 'center', alignItems: 'center' },
  loadingTexto: { marginTop: 12, color: '#5c3a1e', fontSize: 15 },
  titulo: { fontSize: 20, fontWeight: 'bold', color: '#3a1f0a', marginBottom: 2 },
  fecha: { fontSize: 12, color: '#999', marginBottom: 20 },
  metricsRow: { flexDirection: 'row', gap: 12, marginBottom: 24 },
  metricCard: {
    flex: 1, backgroundColor: '#1a0e05', borderRadius: 12,
    padding: 20, alignItems: 'center', elevation: 3,
  },
  metricValue: { fontSize: 22, fontWeight: 'bold', color: '#f0d9a0', marginBottom: 4 },
  metricLabel: { fontSize: 12, color: 'rgba(240,217,160,0.6)', textTransform: 'uppercase' },
  seccion: {
    fontSize: 13, fontWeight: 'bold', color: '#7a4f2a',
    textTransform: 'uppercase', marginBottom: 12,
  },
  vacio: { color: '#999', fontSize: 14, textAlign: 'center', marginTop: 8 },
  card: {
    backgroundColor: '#fff', borderRadius: 12, padding: 14,
    marginBottom: 10, borderWidth: 1, borderColor: '#dcc29a', elevation: 2,
  },
  cardHeader: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 6 },
  codigo: { fontSize: 14, fontWeight: 'bold', color: '#5c3a1e', flex: 1 },
  fecha_item: { fontSize: 12, color: '#999' },
  detalle: { fontSize: 13, color: '#6f5a49', marginTop: 2 },
});
