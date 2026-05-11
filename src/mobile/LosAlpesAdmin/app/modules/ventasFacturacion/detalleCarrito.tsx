import { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, Alert, FlatList } from 'react-native';
import { useLocalSearchParams } from 'expo-router';
import { fetchAPI } from '../../services/apiClient';
import { listarCarritos, Carrito } from '../../services/carritoService';

export default function DetalleCarritoScreen() {
  const { carritoId } = useLocalSearchParams();
  console.log('[DetalleCarrito] carritoId recibido:', carritoId, '| tipo:', typeof carritoId);

  const [carrito, setCarrito] = useState<Carrito | null>(null);
  const [carritos, setCarritos] = useState<Carrito[]>([]);
  const [loading, setLoading] = useState(true);

  const modoLista = !carritoId;

  useEffect(() => {
    const cargar = async () => {
      try {
        if (modoLista) {
          const lista = await fetchAPI('Handlers/VentasFacturacion/CarritoHandler.ashx', 'listar', 'GET');
          setCarritos(lista);
        } else {
          const lista = await listarCarritos();
          const id = parseInt(carritoId as string, 10);
          console.log('[DetalleCarrito] id parseado:', id, '| carritos disponibles:', lista.map(c => c.PRE_CARRITO));
          const encontrado = lista.find((c) => c.PRE_CARRITO === id);
          setCarrito(encontrado ?? null);
        }
      } catch {
        Alert.alert('Error', 'No se pudo cargar la información del carrito.');
      } finally {
        setLoading(false);
      }
    };
    cargar();
  }, [carritoId]);

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#5c3a1e" />
        <Text style={styles.loadingTexto}>Cargando...</Text>
      </View>
    );
  }

  // Modo lista: muestra todos los carritos
  if (modoLista) {
    return (
      <View style={styles.container}>
        <Text style={styles.titulo}>Todos los Carritos</Text>
        {carritos.length === 0 ? (
          <View style={styles.loadingContainer}>
            <Text style={styles.loadingTexto}>No hay carritos registrados.</Text>
          </View>
        ) : (
          <FlatList
            data={carritos}
            keyExtractor={(item) => item.PRE_CARRITO.toString()}
            renderItem={({ item }) => (
              <View style={styles.card}>
                <View style={styles.cardHeader}>
                  <Text style={styles.correlativo}>{item.PRE_CORRELATIVO}</Text>
                  <Text style={styles.total}>Q {parseFloat(String(item.PRE_TOTAL || '0')).toFixed(2)}</Text>
                </View>
                <Text style={styles.valor}>👤 {item.NOMBRE_CLIENTE}</Text>
                <Text style={styles.productos}>📦 {item.PRODUCTOS}</Text>
                <Text style={styles.fecha}>📅 {item.PRE_FECHA_INICIO}</Text>
              </View>
            )}
          />
        )}
      </View>
    );
  }

  // Modo detalle: muestra un carrito específico
  if (!carrito) {
    return (
      <View style={styles.loadingContainer}>
        <Text style={styles.loadingTexto}>Carrito no encontrado.</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.card}>
        <Text style={styles.label}>Correlativo</Text>
        <Text style={styles.valor}>{carrito.PRE_CORRELATIVO}</Text>

        <Text style={styles.label}>Cliente</Text>
        <Text style={styles.valor}>👤 {carrito.NOMBRE_CLIENTE}</Text>

        <Text style={styles.label}>Productos</Text>
        <Text style={styles.valor}>📦 {carrito.PRODUCTOS}</Text>

        <Text style={styles.label}>Total</Text>
        <Text style={styles.totalDetalle}>Q {parseFloat(String(carrito.PRE_TOTAL || '0')).toFixed(2)}</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f3eb', padding: 16 },
  loadingContainer: { flex: 1, backgroundColor: '#f8f3eb', justifyContent: 'center', alignItems: 'center' },
  loadingTexto: { marginTop: 12, color: '#5c3a1e', fontSize: 15 },
  titulo: { fontSize: 18, fontWeight: 'bold', color: '#3a1f0a', marginBottom: 16 },
  card: {
    backgroundColor: '#fff', borderRadius: 12, padding: 20,
    marginBottom: 12, borderWidth: 1, borderColor: '#dcc29a', elevation: 3,
  },
  cardHeader: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 8 },
  correlativo: { fontSize: 16, fontWeight: 'bold', color: '#5c3a1e' },
  total: { fontSize: 16, fontWeight: 'bold', color: '#c9973a' },
  label: { fontSize: 12, fontWeight: 'bold', color: '#999', marginTop: 12, textTransform: 'uppercase' },
  valor: { fontSize: 15, color: '#3a281b', marginTop: 4 },
  productos: { fontSize: 13, color: '#6f5a49', marginTop: 4 },
  fecha: { fontSize: 12, color: '#999', marginTop: 4 },
  totalDetalle: { fontSize: 20, fontWeight: 'bold', color: '#c9973a', marginTop: 4 },
});
