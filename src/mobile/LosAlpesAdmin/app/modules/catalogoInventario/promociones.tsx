import React, { useEffect, useState } from 'react';
import {
    ActivityIndicator, Alert, ScrollView, StyleSheet,
    Text, TextInput, TouchableOpacity, View
} from 'react-native';
import { Categoria, getCategorias } from '../../../services/catalogoInventario/categorias';
import { getProductos, Producto } from '../../../services/catalogoInventario/productos';
import {
    actualizarCampana, crearCampana, crearPromo,
    eliminarCampana, eliminarPromo, listarCampanas, listarPorCampana
} from '../../../services/catalogoInventario/promociones';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function PromocionesScreen() {
  const [campanas, setCampanas] = useState<any[]>([]);
  const [detalle, setDetalle] = useState<any[]>([]);
  const [campanaActiva, setCampanaActiva] = useState<any>(null);
  const [loading, setLoading] = useState(false);

  const [nombre, setNombre] = useState('');
  const [descripcion, setDescripcion] = useState('');
  const [fechaInicio, setFechaInicio] = useState(new Date().toISOString().split('T')[0]);
  const [fechaFinal, setFechaFinal] = useState(() => {
    const d = new Date(); d.setMonth(d.getMonth() + 1);
    return d.toISOString().split('T')[0];
  });

  const [productos, setProductos] = useState<Producto[]>([]);
  const [productoSeleccionado, setProductoSeleccionado] = useState<string>('');
  const [porcentaje, setPorcentaje] = useState('');

  const [categorias, setCategorias] = useState<Categoria[]>([]);
  const [categoriaSeleccionada, setCategoriaSeleccionada] = useState<number>(0);
  const [porcentajeCategoria, setPorcentajeCategoria] = useState('');

  useEffect(() => { 
    cargar(); 
    cargarProductos();
    cargarCategorias();
  }, []);

  const cargarProductos = async () => {
    try {
      const res = await getProductos();
      setProductos(res);
    } catch (e: any) {
      Alert.alert('Error', e.message);
    }
  };

  const cargarCategorias = async () => {
    try {
      const res = await getCategorias();
      setCategorias(res);
    } catch (e: any) {}
  };

  const cargar = async () => {
    setLoading(true);
    try {
      const res = await listarCampanas();
      setCampanas(res.data || []);
    } catch (e: any) {
      Alert.alert('Error', e.message);
    } finally { setLoading(false); }
  };

  const verDetalle = async (campana: any) => {
    setCampanaActiva(campana);
    try {
      const res = await listarPorCampana(campana.CAMP_CAMPANA);
      setDetalle(res.data || []);
    } catch (e: any) {
      Alert.alert('Error', e.message);
    }
  };

  const handleCrearCampana = async () => {
    if (!nombre || !fechaInicio || !fechaFinal) {
      Alert.alert('Error', 'Nombre y fechas son obligatorios.');
      return;
    }
    try {
      await crearCampana({ nombre, descripcion, fechaInicio, fechaFinal });
      Alert.alert('Éxito', 'Campaña creada.');
      setNombre(''); setDescripcion('');
      cargar();
    } catch (e: any) { Alert.alert('Error', e.message); }
  };

  const handleEliminarCampana = (id: number) => {
    Alert.alert('Confirmar', '¿Eliminar campaña?', [
      { text: 'Cancelar', style: 'cancel' },
      { text: 'Eliminar', style: 'destructive', onPress: async () => {
        try {
          await eliminarCampana(id);
          setCampanaActiva(null);
          setDetalle([]);
          cargar();
        } catch (e: any) { Alert.alert('Error', e.message); }
      }}
    ]);
  };

  const handleToggleEstado = async (campana: any) => {
    const nuevoEstado = campana.CAMP_ESTADO === 'ACTIVA' ? 'INACTIVA' : 'ACTIVA';
    try {
      await actualizarCampana({
        id: campana.CAMP_CAMPANA,
        nombre: campana.CAMP_NOMBRE,
        descripcion: campana.CAMP_DESCRIPCION,
        estado: nuevoEstado,
        fechaInicio: campana.CAMP_FECHA_INICIO,
        fechaFinal: campana.CAMP_FECHA_FINAL,
      });
      cargar();
    } catch (e: any) { Alert.alert('Error', e.message); }
  };

  const handleAgregarPromo = async () => {
    if (!campanaActiva || !productoSeleccionado || !porcentaje) {
      Alert.alert('Error', 'Completa todos los campos.');
      return;
    }
    try {
      await crearPromo({
        campanaId: campanaActiva.CAMP_CAMPANA,
        proReferencia: productoSeleccionado,
        porcentaje: parseFloat(porcentaje),
      });
      setProductoSeleccionado(''); setPorcentaje('');
      verDetalle(campanaActiva);
    } catch (e: any) { Alert.alert('Error', e.message); }
  };

  const handleAgregarPorCategoria = async () => {
    if (!campanaActiva || !porcentajeCategoria) {
      Alert.alert('Error', 'Selecciona una campaña y el porcentaje.');
      return;
    }

    let productosFiltrados = categoriaSeleccionada === 0
      ? productos
      : productos.filter(p => p.TIP_TIPO === categoriaSeleccionada);
    
    let agregados = 0;

    for (const p of productosFiltrados) {
      try {
        await crearPromo({
          campanaId: campanaActiva.CAMP_CAMPANA,
          proReferencia: p.PRO_REFERENCIA,
          porcentaje: parseFloat(porcentajeCategoria),
        });
        agregados++;
      } catch {}
    }

    Alert.alert('Éxito', `${agregados} producto(s) agregados.`);
    setPorcentajeCategoria('');
    verDetalle(campanaActiva);
  };

  const handleEliminarPromo = (id: number) => {
    Alert.alert('Confirmar', '¿Eliminar promoción?', [
      { text: 'Cancelar', style: 'cancel' },
      { text: 'Eliminar', style: 'destructive', onPress: async () => {
        try {
          await eliminarPromo(id);
          verDetalle(campanaActiva);
        } catch (e: any) { Alert.alert('Error', e.message); }
      }}
    ]);
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.titulo}>Promociones</Text>

      {/* CREAR CAMPAÑA */}
      <View style={styles.card}>
        <Text style={styles.cardTitulo}>Nueva Campaña</Text>
        <TextInput style={styles.input} placeholder="Nombre *" value={nombre} onChangeText={setNombre} />
        <TextInput style={styles.input} placeholder="Descripción" value={descripcion} onChangeText={setDescripcion} />
        <TextInput style={styles.input} placeholder="Fecha inicio (YYYY-MM-DD)" value={fechaInicio} onChangeText={setFechaInicio} />
        <TextInput style={styles.input} placeholder="Fecha final (YYYY-MM-DD)" value={fechaFinal} onChangeText={setFechaFinal} />
        <TouchableOpacity style={styles.btn} onPress={handleCrearCampana}>
          <Text style={styles.btnText}>Crear Campaña</Text>
        </TouchableOpacity>
      </View>

      {/* LISTA CAMPAÑAS */}
      <Text style={styles.seccion}>Campañas</Text>
      {loading ? <ActivityIndicator color={CAFE} /> : campanas.map(c => (
        <View key={c.CAMP_CAMPANA} style={styles.item}>
          <TouchableOpacity onPress={() => verDetalle(c)} style={styles.itemInfo}>
            <Text style={styles.itemNombre}>{c.CAMP_NOMBRE}</Text>
            <Text style={styles.itemSub}>{c.CAMP_FECHA_INICIO} → {c.CAMP_FECHA_FINAL}</Text>
            <Text style={[styles.badge, c.CAMP_ESTADO === 'ACTIVA' ? styles.badgeOk : styles.badgeOff]}>
              {c.CAMP_ESTADO}
            </Text>
          </TouchableOpacity>
          <View style={styles.itemBtns}>
            <TouchableOpacity style={styles.btnToggle} onPress={() => handleToggleEstado(c)}>
              <Text style={styles.btnToggleText}>{c.CAMP_ESTADO === 'ACTIVA' ? '⏸' : '▶'}</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.btnDel} onPress={() => handleEliminarCampana(c.CAMP_CAMPANA)}>
              <Text style={styles.btnDelText}>🗑</Text>
            </TouchableOpacity>
          </View>
        </View>
      ))}

      {/* DETALLE CAMPAÑA */}
      {campanaActiva && (
        <View style={styles.card}>
          <Text style={styles.cardTitulo}> {campanaActiva.CAMP_NOMBRE}</Text>

          {/* POR CATEGORÍA */}
          <Text style={styles.label}>CATEGORÍA</Text>
          <ScrollView style={styles.selectorBox} nestedScrollEnabled>
            <TouchableOpacity
              style={[styles.selectorItem, categoriaSeleccionada === 0 && styles.selectorItemActive]}
              onPress={() => setCategoriaSeleccionada(0)}>
              <Text style={[styles.selectorText, categoriaSeleccionada === 0 && styles.selectorTextActive]}>
                Todas las categorías
              </Text>
            </TouchableOpacity>
            {categorias.map(c => (
              <TouchableOpacity
                key={c.CAT_CATEGORIA}
                style={[styles.selectorItem, categoriaSeleccionada === c.CAT_CATEGORIA && styles.selectorItemActive]}
                onPress={() => setCategoriaSeleccionada(c.CAT_CATEGORIA)}>
                <Text style={[styles.selectorText, categoriaSeleccionada === c.CAT_CATEGORIA && styles.selectorTextActive]}>
                  {c.CAT_DESCRIPCION}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>

          <TextInput
            style={styles.input}
            placeholder="Porcentaje categoría (%)"
            value={porcentajeCategoria}
            onChangeText={setPorcentajeCategoria}
            keyboardType="numeric"
          />

          <TouchableOpacity
            style={[styles.btn, { backgroundColor: GOLD, marginBottom: 16 }]}
            onPress={handleAgregarPorCategoria}>
            <Text style={styles.btnText}>Agregar por Categoría</Text>
          </TouchableOpacity>

          <Text style={styles.label}>PRODUCTO</Text>
          <ScrollView style={styles.selectorBox} nestedScrollEnabled>
            {productos.map(p => (
              <TouchableOpacity
                key={p.PRO_REFERENCIA}
                style={[styles.selectorItem, productoSeleccionado === p.PRO_REFERENCIA && styles.selectorItemActive]}
                onPress={() => setProductoSeleccionado(p.PRO_REFERENCIA)}>
                <Text style={[styles.selectorText, productoSeleccionado === p.PRO_REFERENCIA && styles.selectorTextActive]}>
                  {p.PRO_NOMBRE}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>

          <TextInput
            style={styles.input}
            placeholder="Porcentaje (%)"
            value={porcentaje}
            onChangeText={setPorcentaje}
            keyboardType="numeric"
          />

          <TouchableOpacity style={styles.btn} onPress={handleAgregarPromo}>
            <Text style={styles.btnText}>Agregar Producto</Text>
          </TouchableOpacity>

          {detalle.map(d => (
            <View key={d.PROM_PROMOCION} style={styles.detalleItem}>
              <Text style={styles.detalleNombre}>{d.PRO_NOMBRE}</Text>
              <Text style={styles.detalleSub}>{d.PROM_PORCENTAJE}% descuento</Text>
              <TouchableOpacity onPress={() => handleEliminarPromo(d.PROM_PROMOCION)}>
                <Text style={styles.btnDelText}></Text>
              </TouchableOpacity>
            </View>
          ))}
        </View>
      )}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0', padding: 16 },
  titulo: { fontSize: 22, fontWeight: 'bold', color: CAFE, marginBottom: 16 },
  card: { backgroundColor: 'white', borderRadius: 12, padding: 16, marginBottom: 16, elevation: 2 },
  cardTitulo: { fontSize: 15, fontWeight: 'bold', color: CAFE, marginBottom: 12 },
  input: { borderWidth: 1.5, borderColor: '#e8d8c0', borderRadius: 8, padding: 10, marginBottom: 10, fontSize: 13 },
  btn: { backgroundColor: CAFE, padding: 12, borderRadius: 8, alignItems: 'center' },
  btnText: { color: 'white', fontWeight: 'bold' },
  seccion: { fontSize: 16, fontWeight: 'bold', color: CAFE, marginBottom: 8 },
  item: { backgroundColor: 'white', borderRadius: 10, padding: 12, marginBottom: 8, flexDirection: 'row', alignItems: 'center', elevation: 1 },
  itemInfo: { flex: 1 },
  itemNombre: { fontSize: 14, fontWeight: 'bold', color: '#333' },
  itemSub: { fontSize: 11, color: '#888', marginTop: 2 },
  badge: { fontSize: 10, fontWeight: 'bold', marginTop: 4, paddingHorizontal: 8, paddingVertical: 2, borderRadius: 10, alignSelf: 'flex-start' },
  badgeOk: { backgroundColor: '#c6f6d5', color: '#276749' },
  badgeOff: { backgroundColor: '#fed7d7', color: '#9b2c2c' },
  itemBtns: { flexDirection: 'row', gap: 8 },
  btnToggle: { backgroundColor: '#EBF8FF', padding: 8, borderRadius: 6 },
  btnToggleText: { fontSize: 16 },
  btnDel: { backgroundColor: '#FFF5F5', padding: 8, borderRadius: 6 },
  btnDelText: { fontSize: 16 },
  detalleItem: { flexDirection: 'row', alignItems: 'center', paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: '#f5ece0' },
  detalleNombre: { flex: 1, fontSize: 13, color: '#333' },
  detalleSub: { fontSize: 12, color: GOLD, marginRight: 8 },
  selectorBox: { maxHeight: 150, borderWidth: 1.5, borderColor: '#e8d8c0', borderRadius: 8, marginBottom: 10 },
  selectorItem: { padding: 10, borderBottomWidth: 1, borderBottomColor: '#f5ece0' },
  selectorItemActive: { backgroundColor: GOLD },
  selectorText: { fontSize: 13, color: '#333' },
  selectorTextActive: { color: 'white', fontWeight: 'bold' },
  label: { fontSize: 11, fontWeight: 'bold', color: CAFE, letterSpacing: 0.5, marginBottom: 6, textTransform: 'uppercase' },
});