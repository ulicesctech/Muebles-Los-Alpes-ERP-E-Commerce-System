import { useState, useEffect } from 'react';
import {
  View, Text, StyleSheet, FlatList, TouchableOpacity,
  Modal, TextInput, ActivityIndicator, Alert, ScrollView,
} from 'react-native';
import { useRouter } from 'expo-router';
import {
  listarCarritos, listarProductos, crearCarrito,
  agregarDetalle, vaciarCarrito, eliminarCarrito,
  Carrito, Producto,
} from '../../../services/carritoService';
import { fetchAPI } from '../../../services/apiClient';

interface Cliente {
  cli_cliente: number;
  cli_primer_nombre: string;
  cli_primer_apellido: string;
}

export default function CarritoScreen() {
  const router = useRouter();
  const [carritos, setCarritos] = useState<Carrito[]>([]);
  const [productos, setProductos] = useState<Producto[]>([]);
  const [clientes, setClientes] = useState<Cliente[]>([]);
  const [correlativosFacturados, setCorrelativosFacturados] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);

  // Modal nuevo carrito
  const [modalVisible, setModalVisible] = useState(false);
  const [clienteId, setClienteId] = useState<number | null>(null);
  const [guardando, setGuardando] = useState(false);
  const [cargandoClientes, setCargandoClientes] = useState(false);

  // Modal agregar producto
  const [modalAgregarVisible, setModalAgregarVisible] = useState(false);
  const [carritoActivo, setCarritoActivo] = useState<Carrito | null>(null);
  const [hvPrecioSeleccionado, setHvPrecioSeleccionado] = useState<number | null>(null);
  const [cantidad, setCantidad] = useState('1');
  const [guardandoDetalle, setGuardandoDetalle] = useState(false);

  const cargarDatos = async () => {
    try {
      setLoading(true);
      const [listaCarritos, listaProductos, listaFacturas] = await Promise.all([
        listarCarritos(),
        listarProductos(),
        fetchAPI('Handlers/VentasFacturacion/FacturaHandler.ashx', 'listar', 'GET'),
      ]);
      setCarritos(listaCarritos);
      setProductos(listaProductos);
      const correlativos = listaFacturas
        .map((f: any) => f.PRE_CORRELATIVO)
        .filter((c: any) => c !== null && c !== undefined);
      console.log('[Carrito] Correlativos facturados:', JSON.stringify(correlativos));
      console.log('[Carrito] PRE_CORRELATIVO de carritos:', JSON.stringify(listaCarritos.map((c) => c.PRE_CORRELATIVO)));
      setCorrelativosFacturados(new Set(correlativos));
    } catch {
      Alert.alert('Error', 'No se pudieron cargar los datos. Verifica tu conexión.');
    } finally {
      setLoading(false);
    }
  };

  const cargarClientes = async () => {
    try {
      setCargandoClientes(true);
      const result = await fetchAPI('Handlers/Auth/AuthHandler.ashx', 'listar-clientes');
      setClientes(result.data);
      if (result.data.length > 0) setClienteId(result.data[0].cli_cliente);
    } catch {
      Alert.alert('Error', 'No se pudieron cargar los clientes.');
    } finally {
      setCargandoClientes(false);
    }
  };

  useEffect(() => {
    cargarDatos();
  }, []);

  const abrirModal = () => {
    setClienteId(null);
    cargarClientes();
    setModalVisible(true);
  };

  const handleCrearCarrito = async () => {
    if (!clienteId) {
      Alert.alert('Error', 'Selecciona un cliente.');
      return;
    }
    try {
      setGuardando(true);
      const nuevoId = await crearCarrito(clienteId);
      console.log('[Carrito] Carrito creado, PRE_CARRITO:', nuevoId);
      setModalVisible(false);
      setClienteId(null);
      await cargarDatos();
    } catch (error: any) {
      Alert.alert('Error', 'No se pudo crear el carrito.');
    } finally {
      setGuardando(false);
    }
  };

  const abrirModalAgregar = (item: Carrito) => {
    setCarritoActivo(item);
    setCantidad('1');
    setHvPrecioSeleccionado(productos.length > 0 ? productos[0].HV_HISTORIAL_PRECIO_VENTA : null);
    setModalAgregarVisible(true);
  };

  const handleAgregarDetalle = async () => {
    const cant = parseInt(cantidad, 10);
    if (!carritoActivo || !hvPrecioSeleccionado) {
      Alert.alert('Error', 'Selecciona un producto.');
      return;
    }
    if (isNaN(cant) || cant <= 0) {
      Alert.alert('Error', 'Ingresa una cantidad válida.');
      return;
    }
    try {
      setGuardandoDetalle(true);
      await agregarDetalle(carritoActivo.PRE_CARRITO, hvPrecioSeleccionado, cant);
      setModalAgregarVisible(false);
      await cargarDatos();
    } catch {
      Alert.alert('Error', 'No se pudo agregar el producto.');
    } finally {
      setGuardandoDetalle(false);
    }
  };

  const handleVaciar = (item: Carrito) => {
    Alert.alert(
      'Vaciar carrito',
      `¿Vaciar el carrito ${item.PRE_CORRELATIVO}?`,
      [
        { text: 'Cancelar', style: 'cancel' },
        {
          text: 'Vaciar',
          style: 'destructive',
          onPress: async () => {
            try {
              await vaciarCarrito(item.PRE_CARRITO);
              await cargarDatos();
            } catch {
              Alert.alert('Error', 'No se pudo vaciar el carrito.');
            }
          },
        },
      ]
    );
  };

  const handleEliminar = (item: Carrito) => {
    Alert.alert(
      'Eliminar carrito',
      `¿Eliminar el carrito ${item.PRE_CORRELATIVO}?`,
      [
        { text: 'Cancelar', style: 'cancel' },
        {
          text: 'Eliminar',
          style: 'destructive',
          onPress: async () => {
            try {
              await eliminarCarrito(item.PRE_CARRITO);
              await cargarDatos();
            } catch {
              Alert.alert('Error', 'No se pudo eliminar el carrito.');
            }
          },
        },
      ]
    );
  };

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#5c3a1e" />
        <Text style={styles.loadingTexto}>Cargando carritos...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.headerAcciones}>
        <TouchableOpacity style={styles.btnNuevo} onPress={abrirModal}>
          <Text style={styles.btnNuevoTexto}>+ Nuevo Carrito</Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={carritos}
        keyExtractor={(item) => item.PRE_CARRITO.toString()}
        renderItem={({ item }) => {
          const estaFacturado = item.PRE_CORRELATIVO != null && correlativosFacturados.has(item.PRE_CORRELATIVO);
          console.log(`[Carrito] carrito ${item.PRE_CORRELATIVO} | Set: ${JSON.stringify([...correlativosFacturados])} | estaFacturado: ${estaFacturado}`);
          return (
            <View style={styles.card}>
              <View style={styles.cardHeader}>
                <Text style={styles.correlativo}>{item.PRE_CORRELATIVO}</Text>
                <Text style={styles.total}>Q {parseFloat(String(item.PRE_TOTAL || '0')).toFixed(2)}</Text>
              </View>
              <Text style={styles.cliente}>👤 {item.NOMBRE_CLIENTE}</Text>
              <Text style={styles.productosTexto}>📦 {item.PRODUCTOS}</Text>
              <Text style={styles.fecha}>📅 {item.PRE_FECHA_INICIO}</Text>
              <View style={styles.acciones}>
                <TouchableOpacity style={styles.btnAgregar} onPress={() => abrirModalAgregar(item)}>
                  <Text style={styles.btnTexto}>Agregar</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={styles.btnResumen}
                  onPress={() => router.push({
                    pathname: '/modules/ventasFacturacion/detalleCarrito',
                    params: { carritoId: item.PRE_CARRITO },
                  })}>
                  <Text style={styles.btnTexto}>Resumen</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.btnVaciar} onPress={() => handleVaciar(item)}>
                  <Text style={styles.btnTexto}>Vaciar</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.btnEliminar} onPress={() => handleEliminar(item)}>
                  <Text style={styles.btnTexto}>Eliminar</Text>
                </TouchableOpacity>
              </View>
              <View style={styles.acciones}>
                {estaFacturado ? (
                  <TouchableOpacity style={[styles.btnFactura, styles.btnFacturado]} disabled>
                    <Text style={styles.btnTexto}>Facturado</Text>
                  </TouchableOpacity>
                ) : (
                  <TouchableOpacity
                    style={styles.btnFactura}
                    onPress={() => router.push({
                      pathname: '/modules/ventasFacturacion/factura',
                      params: { carrito: JSON.stringify(item) },
                    })}>
                    <Text style={styles.btnTexto}>Facturar</Text>
                  </TouchableOpacity>
                )}
              </View>
            </View>
          );
        }}
      />

      {/* Modal nuevo carrito */}
      <Modal visible={modalVisible} transparent animationType="slide">
        <View style={styles.modalOverlay}>
          <View style={styles.modalBox}>
            <Text style={styles.modalTitulo}>🛒 Nuevo Carrito</Text>
            <Text style={styles.modalLabel}>Cliente</Text>
            {cargandoClientes ? (
              <ActivityIndicator size="small" color="#5c3a1e" style={{ marginVertical: 16 }} />
            ) : (
              <ScrollView style={styles.listaWrapper} nestedScrollEnabled>
                {clientes.map((c) => (
                  <TouchableOpacity
                    key={c.cli_cliente}
                    style={[styles.opcionItem, clienteId === c.cli_cliente && styles.opcionItemSelected]}
                    onPress={() => setClienteId(c.cli_cliente)}
                  >
                    <Text style={[styles.opcionText, clienteId === c.cli_cliente && styles.opcionTextSelected]}>
                      {c.cli_primer_nombre} {c.cli_primer_apellido}
                    </Text>
                  </TouchableOpacity>
                ))}
              </ScrollView>
            )}
            <View style={styles.modalAcciones}>
              <TouchableOpacity
                style={styles.btnCancelar}
                onPress={() => { setModalVisible(false); setClienteId(null); }}>
                <Text style={styles.btnTexto}>Cancelar</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[styles.btnCrear, guardando && styles.btnDisabled]}
                onPress={handleCrearCarrito}
                disabled={guardando}>
                <Text style={styles.btnTexto}>{guardando ? 'Creando...' : 'Crear'}</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>

      {/* Modal agregar producto */}
      <Modal visible={modalAgregarVisible} transparent animationType="slide">
        <View style={styles.modalOverlay}>
          <View style={styles.modalBox}>
            <Text style={styles.modalTitulo}>+ Agregar Producto</Text>
            <Text style={styles.modalLabel}>Producto</Text>
            <ScrollView style={styles.listaWrapper} nestedScrollEnabled>
              {productos.map((p) => (
                <TouchableOpacity
                  key={p.HV_HISTORIAL_PRECIO_VENTA}
                  style={[styles.opcionItem, hvPrecioSeleccionado === p.HV_HISTORIAL_PRECIO_VENTA && styles.opcionItemSelected]}
                  onPress={() => setHvPrecioSeleccionado(p.HV_HISTORIAL_PRECIO_VENTA)}
                >
                  <Text style={[styles.opcionText, hvPrecioSeleccionado === p.HV_HISTORIAL_PRECIO_VENTA && styles.opcionTextSelected]}>
                    {p.PRO_NOMBRE}
                  </Text>
                </TouchableOpacity>
              ))}
            </ScrollView>
            <Text style={styles.modalLabel}>Cantidad</Text>
            <TextInput
              style={styles.input}
              placeholder="Ej: 1"
              placeholderTextColor="#aaa"
              keyboardType="numeric"
              value={cantidad}
              onChangeText={setCantidad}
            />
            <View style={styles.modalAcciones}>
              <TouchableOpacity
                style={styles.btnCancelar}
                onPress={() => setModalAgregarVisible(false)}>
                <Text style={styles.btnTexto}>Cancelar</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[styles.btnCrear, guardandoDetalle && styles.btnDisabled]}
                onPress={handleAgregarDetalle}
                disabled={guardandoDetalle}>
                <Text style={styles.btnTexto}>{guardandoDetalle ? 'Guardando...' : 'Guardar'}</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f3eb', padding: 16 },
  loadingContainer: { flex: 1, backgroundColor: '#f8f3eb', justifyContent: 'center', alignItems: 'center' },
  loadingTexto: { marginTop: 12, color: '#5c3a1e', fontSize: 15 },
  headerAcciones: { flexDirection: 'row', gap: 10, marginBottom: 16 },
  btnNuevo: {
    flex: 1, backgroundColor: '#5c3a1e', padding: 14, borderRadius: 10, alignItems: 'center',
  },
  btnHistorial: {
    flex: 1, backgroundColor: '#c9973a', padding: 14, borderRadius: 10, alignItems: 'center',
  },
  btnFacturas: {
    flex: 1, backgroundColor: '#7a6652', padding: 14, borderRadius: 10, alignItems: 'center',
  },
  btnNuevoTexto: { color: '#f7deb0', fontWeight: 'bold', fontSize: 15 },
  card: {
    backgroundColor: '#fff', borderRadius: 12, padding: 16,
    marginBottom: 12, borderWidth: 1, borderColor: '#dcc29a', elevation: 3,
  },
  cardHeader: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 8 },
  correlativo: { fontSize: 16, fontWeight: 'bold', color: '#5c3a1e' },
  total: { fontSize: 16, fontWeight: 'bold', color: '#c9973a' },
  cliente: { fontSize: 14, color: '#3a281b', marginBottom: 4 },
  productosTexto: { fontSize: 13, color: '#6f5a49', marginBottom: 4 },
  fecha: { fontSize: 12, color: '#999', marginBottom: 12 },
  acciones: { flexDirection: 'row', gap: 6, marginBottom: 4 },
  btnAgregar: { flex: 1, backgroundColor: '#4a7c59', padding: 10, borderRadius: 8, alignItems: 'center' },
  btnResumen: { flex: 1, backgroundColor: '#5c3a1e', padding: 10, borderRadius: 8, alignItems: 'center' },
  btnVaciar: { flex: 1, backgroundColor: '#7a6652', padding: 10, borderRadius: 8, alignItems: 'center' },
  btnEliminar: { flex: 1, backgroundColor: '#b94040', padding: 10, borderRadius: 8, alignItems: 'center' },
  btnFactura: { flex: 1, backgroundColor: '#c9973a', padding: 10, borderRadius: 8, alignItems: 'center' },
  btnFacturado: { backgroundColor: '#a0a0a0' },
  btnTexto: { color: '#fff', fontWeight: 'bold', fontSize: 12 },
  modalOverlay: {
    flex: 1, backgroundColor: 'rgba(47,27,15,0.6)',
    justifyContent: 'center', alignItems: 'center',
  },
  modalBox: {
    backgroundColor: '#fcf8f2', borderRadius: 16, padding: 24,
    width: '90%', borderWidth: 1, borderColor: '#dcc29a',
  },
  modalTitulo: { fontSize: 18, fontWeight: 'bold', color: '#5c3a1e', marginBottom: 16 },
  modalLabel: { fontSize: 13, fontWeight: 'bold', color: '#5c3a1e', marginBottom: 8 },
  listaWrapper: { maxHeight: 180, borderWidth: 1, borderColor: '#dcc29a', borderRadius: 8, marginBottom: 12 },
  opcionItem: { padding: 12, borderBottomWidth: 1, borderBottomColor: '#f0e8d8' },
  opcionItemSelected: { backgroundColor: '#5c3a1e' },
  opcionText: { fontSize: 14, color: '#3a281b' },
  opcionTextSelected: { color: '#f7deb0', fontWeight: 'bold' },
  input: {
    borderWidth: 1, borderColor: '#dcc29a', borderRadius: 8,
    padding: 12, backgroundColor: '#fff', color: '#3a281b',
    fontSize: 14, marginBottom: 8,
  },
  modalAcciones: { flexDirection: 'row', gap: 8, marginTop: 16 },
  btnCancelar: { flex: 1, backgroundColor: '#6f5a49', padding: 12, borderRadius: 8, alignItems: 'center' },
  btnCrear: { flex: 1, backgroundColor: '#c9973a', padding: 12, borderRadius: 8, alignItems: 'center' },
  btnDisabled: { opacity: 0.6 },
});
