import { router, useLocalSearchParams } from 'expo-router';
import React, { useEffect, useState } from 'react';
import {
  ActivityIndicator, Alert, Image, ScrollView,
  StyleSheet, Text, TouchableOpacity, View
} from 'react-native';
import { useCarrito } from '../../../context/CarritoContext';
import { detalleProducto } from '../../../services/cliente/catalogoService';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';
const BASE = 'http://10.0.2.2:61850';

export default function DetalleProductoScreen() {
  const { ref } = useLocalSearchParams<{ ref: string }>();
  const { agregarItem } = useCarrito();
  const [producto, setProducto] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [cantidad, setCantidad] = useState(1);

  useEffect(() => { cargar(); }, []);

  const cargar = async () => {
    try {
      const res = await detalleProducto(ref);
      setProducto(res.data);
    } catch (e: any) {
      Alert.alert('Error', e.message);
    } finally { setLoading(false); }
  };

  const handleAgregar = () => {
    if (!producto.HV_HISTORIAL_PRECIO_VENTA) {
      Alert.alert('Error', 'Este producto no tiene precio disponible.');
      return;
    }
    agregarItem({
      hvId: producto.HV_HISTORIAL_PRECIO_VENTA,
      proReferencia: producto.PRO_REFERENCIA,
      proNombre: producto.PRO_NOMBRE,
      precio: producto.PRECIO_FINAL,
      cantidad,
    });
    Alert.alert('✅', `${producto.PRO_NOMBRE} agregado al carrito.`);
  };

  if (loading) return <ActivityIndicator color={CAFE} style={{ marginTop: 40 }} />;

  if (!producto) return (
    <View style={styles.noEncontrado}>
      <Text style={styles.noEncontradoIcon}>🔍</Text>
      <Text style={styles.noEncontradoText}>Producto no encontrado.</Text>
      <TouchableOpacity style={styles.btnVolver} onPress={() => router.back()}>
        <Text style={styles.btnVolverText}>Ver Catálogo</Text>
      </TouchableOpacity>
    </View>
  );

  const tienePromo = producto.PROM_PORCENTAJE !== null && producto.PROM_PORCENTAJE !== undefined;

  return (
    <ScrollView style={styles.container}>
      {/* Breadcrumb */}
      <View style={styles.breadcrumb}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={styles.breadcrumbLink}>🏠 Catálogo</Text>
        </TouchableOpacity>
        <Text style={styles.breadcrumbSep}> / </Text>
        <Text style={styles.breadcrumbActual}>{producto.PRO_NOMBRE}</Text>
      </View>

      {/* Imagen */}
      <View style={styles.imgCard}>
        <Image
          source={{ uri: `${BASE}/Handlers/CatalogoInventario/FotoProductoHandler.ashx?ref=${producto.PRO_REFERENCIA}&t=${Date.now()}` }}
          style={styles.img}
          resizeMode="cover"
        />
      </View>

      {/* Info */}
      <View style={styles.infoCard}>
        <Text style={styles.categoria}>{producto.CAT_DESCRIPCION}</Text>
        <Text style={styles.nombre}>{producto.PRO_NOMBRE}</Text>
        <Text style={styles.tipo}>{producto.TIP_DESCRIPCION} · {producto.MAT_DESCRIPCION}</Text>

        {/* Precio */}
        <View style={styles.precioWrap}>
          {tienePromo && (
            <Text style={styles.precioOriginal}>Q {Number(producto.PRO_PRECIO).toFixed(2)}</Text>
          )}
          <View style={styles.precioRow}>
            <Text style={[styles.precioFinal, tienePromo && styles.precioPromo]}>
              Q {Number(producto.PRECIO_FINAL).toFixed(2)}
            </Text>
            {tienePromo && (
              <View style={styles.badgePromo}>
                <Text style={styles.badgePromoText}>-{producto.PROM_PORCENTAJE}%</Text>
              </View>
            )}
          </View>
        </View>

        {/* Stock */}
        <View style={[styles.stockBadge, producto.STO_DISPONIBLE > 0 ? styles.stockDisponible : styles.stockAgotado]}>
          <Text style={[styles.stockText, producto.STO_DISPONIBLE > 0 ? styles.stockTextoDisp : styles.stockTextoAgot]}>
            {producto.STO_DISPONIBLE > 0 ? '✓ En stock' : '✗ Agotado'}
          </Text>
        </View>

        {/* Especificaciones */}
        <View style={styles.specs}>
          <Text style={styles.specsTitle}>ESPECIFICACIONES</Text>
          {[
            ['Material', producto.MAT_DESCRIPCION],
            ['Color', producto.PRO_COLOR || 'N/A'],
            ['Alto', `${producto.PRO_ALTO_CM} cm`],
            ['Ancho', `${producto.PRO_ANCHO_CM} cm`],
            ['Profundidad', `${producto.PRO_PROFUNDIDAD_CM} cm`],
            ['Peso', `${producto.PRO_PESO} g`],
          ].map(([label, val]) => (
            <View key={label} style={styles.specRow}>
              <Text style={styles.specLabel}>{label}</Text>
              <Text style={styles.specVal}>{val}</Text>
            </View>
          ))}
        </View>

        {/* Cantidad */}
        <View style={styles.qtyWrap}>
          <Text style={styles.qtyLabel}>Cantidad:</Text>
          <TouchableOpacity style={styles.qtyBtn} onPress={() => setCantidad(Math.max(1, cantidad - 1))}>
            <Text style={styles.qtyBtnText}>−</Text>
          </TouchableOpacity>
          <Text style={styles.qtyVal}>{cantidad}</Text>
          <TouchableOpacity style={styles.qtyBtn} onPress={() => setCantidad(Math.min(99, cantidad + 1))}>
            <Text style={styles.qtyBtnText}>+</Text>
          </TouchableOpacity>
        </View>

        {/* Botón agregar */}
        <TouchableOpacity
          style={[styles.btnAgregar, producto.STO_DISPONIBLE <= 0 && styles.btnAgregarDisabled]}
          disabled={producto.STO_DISPONIBLE <= 0}
          onPress={handleAgregar}>
          <Text style={styles.btnAgregarText}>🛒 Agregar al Carrito</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0' },
  breadcrumb: { flexDirection: 'row', alignItems: 'center', backgroundColor: 'white', padding: 12, borderBottomWidth: 1, borderBottomColor: '#e8d8c0', flexWrap: 'wrap' },
  breadcrumbLink: { color: GOLD, fontSize: 13 },
  breadcrumbSep: { color: '#888', fontSize: 13 },
  breadcrumbActual: { color: CAFE, fontSize: 13, fontWeight: 'bold', flex: 1 },
  imgCard: { backgroundColor: 'white', margin: 16, borderRadius: 14, overflow: 'hidden', borderWidth: 1, borderColor: '#e8d8c0', elevation: 2 },
  img: { width: '100%', height: 300 },
  infoCard: { backgroundColor: 'white', margin: 16, marginTop: 0, borderRadius: 14, padding: 24, borderWidth: 1, borderColor: '#e8d8c0', elevation: 2 },
  categoria: { fontSize: 11, fontWeight: 'bold', textTransform: 'uppercase', letterSpacing: 1, color: GOLD, marginBottom: 8 },
  nombre: { fontSize: 24, fontWeight: 'bold', color: '#3a2a1a', marginBottom: 6 },
  tipo: { fontSize: 14, color: '#888', marginBottom: 20 },
  precioWrap: { marginBottom: 16 },
  precioRow: { flexDirection: 'row', alignItems: 'center', gap: 10 },
  precioOriginal: { fontSize: 16, color: '#aaa', textDecorationLine: 'line-through', marginBottom: 4 },
  precioFinal: { fontSize: 34, fontWeight: 'bold', color: CAFE },
  precioPromo: { color: '#e53e3e' },
  badgePromo: { backgroundColor: '#e53e3e', paddingHorizontal: 10, paddingVertical: 4, borderRadius: 20 },
  badgePromoText: { color: 'white', fontSize: 12, fontWeight: 'bold' },
  stockBadge: { alignSelf: 'flex-start', paddingHorizontal: 14, paddingVertical: 6, borderRadius: 20, borderWidth: 1, marginBottom: 20 },
  stockDisponible: { backgroundColor: '#e6f4ea', borderColor: '#b7dfc2' },
  stockAgotado: { backgroundColor: '#f5f5f5', borderColor: '#ddd' },
  stockText: { fontSize: 13, fontWeight: 'bold' },
  stockTextoDisp: { color: '#276749' },
  stockTextoAgot: { color: '#888' },
  specs: { backgroundColor: '#fdf8f3', borderRadius: 10, padding: 16, marginBottom: 20 },
  specsTitle: { fontSize: 11, fontWeight: 'bold', textTransform: 'uppercase', letterSpacing: 1, color: GOLD, marginBottom: 12 },
  specRow: { flexDirection: 'row', justifyContent: 'space-between', paddingVertical: 6, borderBottomWidth: 1, borderBottomColor: '#f0e8d8' },
  specLabel: { fontSize: 13, color: '#888' },
  specVal: { fontSize: 13, fontWeight: 'bold', color: '#3a2a1a' },
  qtyWrap: { flexDirection: 'row', alignItems: 'center', gap: 12, marginBottom: 20 },
  qtyLabel: { fontSize: 13, fontWeight: 'bold', color: CAFE, textTransform: 'uppercase', letterSpacing: 0.5 },
  qtyBtn: { width: 36, height: 36, borderWidth: 2, borderColor: '#e8d8c0', borderRadius: 8, alignItems: 'center', justifyContent: 'center' },
  qtyBtnText: { fontSize: 20, fontWeight: 'bold', color: CAFE },
  qtyVal: { fontSize: 18, fontWeight: 'bold', color: '#3a2a1a', minWidth: 32, textAlign: 'center' },
  btnAgregar: { backgroundColor: CAFE, padding: 16, borderRadius: 10, alignItems: 'center' },
  btnAgregarDisabled: { backgroundColor: '#ccc' },
  btnAgregarText: { color: 'white', fontSize: 16, fontWeight: 'bold' },
  noEncontrado: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 40 },
  noEncontradoIcon: { fontSize: 64, marginBottom: 12 },
  noEncontradoText: { fontSize: 15, color: '#aaa', marginBottom: 20 },
  btnVolver: { backgroundColor: GOLD, paddingHorizontal: 28, paddingVertical: 12, borderRadius: 8 },
  btnVolverText: { color: 'white', fontWeight: 'bold', fontSize: 14 },
});