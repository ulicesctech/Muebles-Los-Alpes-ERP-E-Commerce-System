import { useEffect, useState } from 'react';
import {
  ActivityIndicator, Alert,
  FlatList,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import { fetchAPI } from '../../../services/apiClient';

interface HistorialPrecio {
  HV_HISTORIAL_PRECIO_VENTA: number;
  PRO_NOMBRE: string;
  PRECIO_COMPRA: number | string;
  HV_PORCETAJE: number | string;
  HV_PRECIO_FINAL: number | string;
}

interface Producto {
  PRO_REFERENCIA: string;
  PRO_CODIGO?: number;
  PRO_NOMBRE: string;
}

export default function HistorialPrecioVentaScreen() {
  const [historial, setHistorial] = useState<HistorialPrecio[]>([]);
  const [productos, setProductos] = useState<Producto[]>([]);
  const [loading, setLoading] = useState(true);
  const [proReferencia, setProReferencia] = useState<string | null>(null);
  const [porcentaje, setPorcentaje] = useState('');
  const [registrando, setRegistrando] = useState(false);

  const cargarDatos = async () => {
    try {
      setLoading(true);

      const [resHistorial, resProductos] = await Promise.all([
        fetchAPI('Handlers/VentasFacturacion/HistorialPrecioVentaHandler.ashx', 'listar', 'GET'),
        fetchAPI('Handlers/VentasFacturacion/CarritoHandler.ashx', 'productos', 'GET'),
      ]);

      const vistos = new Set<string>();
      const unicos: Producto[] = (resProductos || []).filter((p: Producto) => {
        if (vistos.has(p.PRO_REFERENCIA)) return false;
        vistos.add(p.PRO_REFERENCIA);
        return true;
      });

      setHistorial(resHistorial || []);
      setProductos(unicos);

      if (unicos.length > 0) {
        setProReferencia(unicos[0].PRO_REFERENCIA);
        console.log('Productos:', JSON.stringify(unicos[0]));
      }
    } catch {
      Alert.alert('Error', 'No se pudieron cargar los datos.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    cargarDatos();
  }, []);

  const handleRegistrar = async () => {
    const pct = parseFloat(porcentaje);

    if (!proReferencia) {
      Alert.alert('Error', 'Selecciona un producto.');
      return;
    }

    if (isNaN(pct) || pct <= 0) {
      Alert.alert('Error', 'Ingresa un porcentaje válido.');
      return;
    }

    try {
      setRegistrando(true);

      const action = `registrar&proReferencia=${encodeURIComponent(proReferencia)}&porcetaje=${pct}`;
      console.log('[HistorialPrecioVenta] POST action:', action);

      await fetchAPI(
        'Handlers/VentasFacturacion/HistorialPrecioVentaHandler.ashx',
        action,
        'POST'
      );

      setPorcentaje('');
      await cargarDatos();
    } catch {
      Alert.alert('Error', 'No se pudo registrar el precio.');
    } finally {
      setRegistrando(false);
    }
  };

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#5c3a1e" />
        <Text style={styles.loadingTexto}>Cargando precios...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.formulario}>
        <Text style={styles.formTitulo}>Registrar Precio</Text>

        <Text style={styles.label}>Producto</Text>

        <ScrollView style={styles.pickerWrapper} nestedScrollEnabled>
          {productos.map((p, i) => (
            <TouchableOpacity
              key={`${p.PRO_REFERENCIA}-${i}`}
              style={[
                styles.opcionItem,
                proReferencia === p.PRO_REFERENCIA && styles.opcionItemSelected,
              ]}
              onPress={() => {
                console.log('Producto seleccionado:', JSON.stringify(p));
                setProReferencia(p.PRO_REFERENCIA);
              }}
            >
              <Text
                style={[
                  styles.opcionText,
                  proReferencia === p.PRO_REFERENCIA && styles.opcionTextSelected,
                ]}
              >
                {p.PRO_NOMBRE}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>

        <Text style={styles.label}>Porcentaje (%)</Text>

        <TextInput
          style={styles.input}
          placeholder="Ej: 30"
          placeholderTextColor="#aaa"
          keyboardType="numeric"
          value={porcentaje}
          onChangeText={setPorcentaje}
        />

        <TouchableOpacity
          style={[styles.btnRegistrar, registrando && styles.btnDisabled]}
          onPress={handleRegistrar}
          disabled={registrando}
        >
          <Text style={styles.btnTexto}>
            {registrando ? 'Registrando...' : 'Registrar'}
          </Text>
        </TouchableOpacity>
      </View>

      <Text style={styles.listaTitulo}>Precios registrados</Text>

      <FlatList
        style={styles.flatList}
        data={historial}
        keyExtractor={(item, index) => `${item.HV_HISTORIAL_PRECIO_VENTA}-${index}`}
        renderItem={({ item }) => (
          <View style={styles.card}>
            <Text style={styles.cardNombre}>{item.PRO_NOMBRE}</Text>

            <View style={styles.cardFila}>
              <Text style={styles.cardLabel}>Precio compra</Text>
              <Text style={styles.cardValor}>
                Q {parseFloat(String(item.PRECIO_COMPRA || '0')).toFixed(2)}
              </Text>
            </View>

            <View style={styles.cardFila}>
              <Text style={styles.cardLabel}>Porcentaje</Text>
              <Text style={styles.cardValor}>{item.HV_PORCETAJE}%</Text>
            </View>

            <View style={styles.cardFila}>
              <Text style={styles.cardLabel}>Precio venta</Text>
              <Text style={[styles.cardValor, styles.cardPrecioVenta]}>
                Q {parseFloat(String(item.HV_PRECIO_FINAL || '0')).toFixed(2)}
              </Text>
            </View>
          </View>
        )}
        ListEmptyComponent={
          <Text style={styles.vacio}>No hay precios registrados.</Text>
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f3eb', padding: 16 },

  loadingContainer: {
    flex: 1,
    backgroundColor: '#f8f3eb',
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingTexto: {
    marginTop: 12,
    color: '#5c3a1e',
    fontSize: 15,
  },

  formulario: {
    backgroundColor: '#fff',
    borderRadius: 12,
    padding: 12,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#dcc29a',
    elevation: 3,
  },
  formTitulo: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#5c3a1e',
    marginBottom: 8,
  },
  label: {
    fontSize: 12,
    fontWeight: 'bold',
    color: '#5c3a1e',
    marginBottom: 4,
  },
  pickerWrapper: {
    maxHeight: 120,
    borderWidth: 1,
    borderColor: '#dcc29a',
    borderRadius: 8,
    backgroundColor: '#f8f3eb',
    marginBottom: 6,
  },
  opcionItem: {
    padding: 8,
    borderBottomWidth: 1,
    borderBottomColor: '#f0e8d8',
  },
  opcionItemSelected: {
    backgroundColor: '#c9973a',
  },
  opcionText: {
    fontSize: 12,
    color: '#3a281b',
  },
  opcionTextSelected: {
    color: '#fff',
    fontWeight: 'bold',
  },

  input: {
    borderWidth: 1,
    borderColor: '#dcc29a',
    borderRadius: 8,
    padding: 8,
    backgroundColor: '#f8f3eb',
    color: '#3a281b',
    fontSize: 13,
    marginBottom: 6,
  },
  btnRegistrar: {
    backgroundColor: '#5c3a1e',
    paddingVertical: 10,
    paddingHorizontal: 14,
    borderRadius: 10,
    alignItems: 'center',
  },
  btnDisabled: {
    opacity: 0.6,
  },
  btnTexto: {
    color: '#f7deb0',
    fontWeight: 'bold',
    fontSize: 13,
  },

  flatList: {
    flex: 1,
  },
  listaTitulo: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#5c3a1e',
    marginBottom: 10,
    textTransform: 'uppercase',
  },
  card: {
    backgroundColor: '#fff',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#dcc29a',
    elevation: 3,
  },
  cardNombre: {
    fontSize: 15,
    fontWeight: 'bold',
    color: '#3a1f0a',
    marginBottom: 10,
  },
  cardFila: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 4,
  },
  cardLabel: {
    fontSize: 13,
    color: '#7a6652',
  },
  cardValor: {
    fontSize: 13,
    fontWeight: 'bold',
    color: '#3a281b',
  },
  cardPrecioVenta: {
    color: '#c9973a',
  },
  vacio: {
    textAlign: 'center',
    color: '#999',
    marginTop: 24,
    fontSize: 14,
  },
});