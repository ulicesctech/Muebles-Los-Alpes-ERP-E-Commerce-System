import { router } from 'expo-router';
import React, { useEffect, useState } from 'react';
import {
  ActivityIndicator, Alert, FlatList, Image,
  StyleSheet, Text, TouchableOpacity, View
} from 'react-native';
import { useCarrito } from '../../../context/CarritoContext';
import { listarPromociones } from '../../../services/cliente/catalogoService';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';
const BASE = 'http://10.0.2.2:61850';

export default function PromocionesClienteScreen() {
  const { agregarItem } = useCarrito();
  const [productos, setProductos] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => { cargar(); }, []);

  const cargar = async () => {
    setLoading(true);
    try {
      const res = await listarPromociones();
      setProductos(res.data || []);
    } catch (e: any) {
      Alert.alert('Error', e.message);
    } finally { setLoading(false); }
  };

  const handleAgregar = (item: any) => {
    if (!item.HV_HISTORIAL_PRECIO_VENTA) {
      Alert.alert('Error', 'Este producto no tiene precio disponible.');
      return;
    }
    if (item.STO_DISPONIBLE <= 0) {
      Alert.alert('Agotado', 'Este producto no tiene stock disponible.');
      return;
    }

    agregarItem({
      hvId: item.HV_HISTORIAL_PRECIO_VENTA,
      proReferencia: item.PRO_REFERENCIA,
      proNombre: item.PRO_NOMBRE,
      precio: item.PRECIO_FINAL,
      precioOriginal: item.PRO_PRECIO,
      promPorcentaje: item.PROM_PORCENTAJE,
      campNombre: item.CAMP_NOMBRE,
      cantidad: 1,
    });

    Alert.alert('✅', `${item.PRO_NOMBRE} agregado al carrito.`);
  };

  return (
    <View style={styles.container}>
      {/* Hero */}
      <View style={styles.hero}>
        <Text style={styles.heroTitle}>🔥 Ofertas y Promociones</Text>
        <Text style={styles.heroSub}>Productos con descuento activos hoy</Text>
      </View>

      {/* Contador */}
      {!loading && (
        <View style={styles.toolbar}>
          <Text style={styles.toolbarText}>
            <Text style={styles.toolbarBold}>{productos.length}</Text> promocion(es) activas
          </Text>
        </View>
      )}

      {loading ? <ActivityIndicator color={CAFE} style={{ marginTop: 40 }} /> : (
        productos.length === 0 ? (
          <View style={styles.empty}>
            <Text style={styles.emptyIcon}>🏷️</Text>
            <Text style={styles.emptyText}>No hay promociones activas en este momento.</Text>
            <TouchableOpacity style={styles.btnCatalogo} onPress={() => router.push('/modules/cliente/catalogo' as any)}>
              <Text style={styles.btnCatalogoText}>Ver Catálogo</Text>
            </TouchableOpacity>
          </View>
        ) : (
          <FlatList
            data={productos}
            keyExtractor={item => item.PRO_REFERENCIA}
            numColumns={2}
            contentContainerStyle={styles.grid}
            renderItem={({ item }) => (
              <View style={styles.prodCard}>
                <View style={styles.cardImgWrap}>
                  <Image
                    source={{ uri: `${BASE}/Handlers/CatalogoInventario/FotoProductoHandler.ashx?ref=${item.PRO_REFERENCIA}` }}
                    style={styles.cardImg}
                    resizeMode="cover"
                  />
                  <View style={styles.badgePromo}>
                    <Text style={styles.badgePromoText}>-{item.PROM_PORCENTAJE}%</Text>
                  </View>
                  <View style={[styles.badgeStock, item.STO_DISPONIBLE > 0 ? styles.badgeDisponible : styles.badgeAgotado]}>
                    <Text style={styles.badgeStockText}>{item.STO_DISPONIBLE > 0 ? '✓ Disponible' : '✗ Agotado'}</Text>
                  </View>
                </View>

                <View style={styles.cardBody}>
                  <Text style={styles.cardCategoria}>{item.CAT_DESCRIPCION}</Text>
                  <Text style={styles.cardNombre} numberOfLines={2}>{item.PRO_NOMBRE}</Text>
                  <Text style={styles.cardTipo} numberOfLines={1}>{item.TIP_DESCRIPCION} · {item.MAT_DESCRIPCION}</Text>
                  <View style={styles.cardPrecioWrap}>
                    <Text style={styles.precioOriginal}>Q {Number(item.PRO_PRECIO).toFixed(2)}</Text>
                    <Text style={styles.precioFinal}>Q {Number(item.PRECIO_FINAL).toFixed(2)}</Text>
                  </View>
                </View>

                <View style={styles.cardFooter}>
                  <TouchableOpacity style={styles.btnDetalle}
                    onPress={() => router.push(`/modules/cliente/detalleProducto?ref=${item.PRO_REFERENCIA}` as any)}>
                    <Text style={styles.btnDetalleText}>👁 Ver</Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={[styles.btnCarrito, item.STO_DISPONIBLE <= 0 && styles.btnCarritoDisabled]}
                    disabled={item.STO_DISPONIBLE <= 0}
                    onPress={() => handleAgregar(item)}>
                    <Text style={styles.btnCarritoText}>+ Agregar</Text>
                  </TouchableOpacity>
                </View>
              </View>
            )}
          />
        )
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0' },
  hero: { backgroundColor: '#C53030', padding: 24, margin: 16, borderRadius: 14 },
  heroTitle: { color: 'white', fontSize: 22, fontWeight: 'bold', marginBottom: 4 },
  heroSub: { color: 'rgba(255,255,255,0.8)', fontSize: 13 },
  toolbar: { paddingHorizontal: 16, paddingVertical: 8 },
  toolbarText: { fontSize: 13, color: '#888' },
  toolbarBold: { color: CAFE, fontWeight: 'bold' },
  grid: { padding: 8 },
  prodCard: { flex: 1, backgroundColor: 'white', borderRadius: 12, borderWidth: 1, borderColor: '#e8d8c0', margin: 6, overflow: 'hidden', elevation: 2 },
  cardImgWrap: { height: 160, position: 'relative', backgroundColor: '#fdf8f3' },
  cardImg: { width: '100%', height: '100%' },
  badgePromo: { position: 'absolute', top: 6, left: 6, backgroundColor: '#e53e3e', borderRadius: 20, paddingHorizontal: 6, paddingVertical: 2 },
  badgePromoText: { color: 'white', fontSize: 9, fontWeight: 'bold' },
  badgeStock: { position: 'absolute', top: 6, right: 6, borderRadius: 20, paddingHorizontal: 6, paddingVertical: 2 },
  badgeDisponible: { backgroundColor: 'rgba(39,103,73,0.85)' },
  badgeAgotado: { backgroundColor: 'rgba(0,0,0,0.55)' },
  badgeStockText: { color: 'white', fontSize: 9, fontWeight: 'bold' },
  cardBody: { padding: 10, flex: 1 },
  cardCategoria: { fontSize: 10, fontWeight: 'bold', textTransform: 'uppercase', letterSpacing: 0.8, color: GOLD, marginBottom: 2 },
  cardNombre: { fontSize: 13, fontWeight: 'bold', color: '#3a2a1a', marginBottom: 2 },
  cardTipo: { fontSize: 11, color: '#888', marginBottom: 6 },
  cardPrecioWrap: { marginTop: 4 },
  precioOriginal: { fontSize: 11, color: '#aaa', textDecorationLine: 'line-through' },
  precioFinal: { fontSize: 16, fontWeight: 'bold', color: '#e53e3e' },
  cardFooter: { flexDirection: 'row', padding: 8, gap: 6, borderTopWidth: 1, borderTopColor: '#f5ece0' },
  btnDetalle: { flex: 1, backgroundColor: '#fdf6ec', borderWidth: 1, borderColor: '#e8d8c0', padding: 7, borderRadius: 6, alignItems: 'center' },
  btnDetalleText: { color: GOLD, fontSize: 11, fontWeight: 'bold' },
  btnCarrito: { flex: 2, backgroundColor: CAFE, padding: 7, borderRadius: 6, alignItems: 'center' },
  btnCarritoDisabled: { backgroundColor: '#ccc' },
  btnCarritoText: { color: 'white', fontSize: 11, fontWeight: 'bold' },
  empty: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 40 },
  emptyIcon: { fontSize: 64, marginBottom: 12 },
  emptyText: { fontSize: 15, color: '#aaa', textAlign: 'center', marginBottom: 20 },
  btnCatalogo: { backgroundColor: GOLD, paddingHorizontal: 28, paddingVertical: 12, borderRadius: 8 },
  btnCatalogoText: { color: 'white', fontWeight: 'bold', fontSize: 14 },
});