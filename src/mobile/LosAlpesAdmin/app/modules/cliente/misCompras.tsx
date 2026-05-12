import { router } from 'expo-router';
import React, { useEffect, useState } from 'react';
import {
    ActivityIndicator, Alert, ScrollView, StyleSheet,
    Text, TouchableOpacity, View
} from 'react-native';
import { useAuth } from '../../../context/AuthContext';
import { listarMisCompras } from '../../../services/cliente/misComprasService';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function MisComprasScreen() {
  const { usuario } = useAuth();
  const [compras, setCompras] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (usuario) cargar();
  }, []);

  const cargar = async () => {
    setLoading(true);
    try {
      const res = await listarMisCompras(usuario!.id);
      setCompras(res.data || []);
    } catch (e: any) {
      Alert.alert('Error', e.message);
    } finally { setLoading(false); }
  };

  if (!usuario) {
    return (
      <View style={styles.centrado}>
        <Text style={styles.msgText}>Debes iniciar sesión para ver tus compras.</Text>
        <TouchableOpacity style={styles.btn} onPress={() => router.push('/(auth)/login')}>
          <Text style={styles.btnText}>Iniciar sesión</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={styles.back}>← Volver</Text>
        </TouchableOpacity>
        <Text style={styles.titulo}>Mis Compras</Text>
      </View>

      {loading ? <ActivityIndicator color={CAFE} style={{ marginTop: 40 }} /> : (
        <ScrollView style={styles.lista}>
          {compras.length === 0 ? (
            <View style={styles.centrado}>
              <Text style={styles.vacioIcon}>📦</Text>
              <Text style={styles.msgText}>No tienes compras registradas.</Text>
            </View>
          ) : compras.map((c, i) => (
            <View key={i} style={styles.card}>
              <View style={styles.cardHeader}>
                <Text style={styles.codigo}>{c.FACLI_CODIGO_FACTURA}</Text>
                <Text style={[styles.badge,
                  c.FACLI_TIPO_ENTREGA === 'DOMICILIO' ? styles.badgeDom : styles.badgeSuc]}>
                  {c.FACLI_TIPO_ENTREGA === 'DOMICILIO' ? '🏠 Domicilio' : '📍 Sucursal'}
                </Text>
              </View>
              <Text style={styles.fecha}>{new Date(c.FACLI_FECHA).toLocaleDateString('es-GT')}</Text>
              <Text style={styles.productos} numberOfLines={2}>{c.PRODUCTOS}</Text>
              {c.NOMBRE_ALMACEN ? (
                <Text style={styles.almacen}>📍 {c.NOMBRE_ALMACEN}</Text>
              ) : null}
              <View style={styles.cardFooter}>
                <Text style={styles.formaPago}>💳 {c.FACLI_FORMA_PAGO}</Text>
                <Text style={styles.total}>Q {Number(c.TOTAL_REAL || 0).toFixed(2)}</Text>
              </View>
            </View>
          ))}
        </ScrollView>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0' },
  header: { backgroundColor: CAFE, padding: 16, flexDirection: 'row', alignItems: 'center', gap: 16 },
  back: { color: GOLD, fontSize: 14, fontWeight: 'bold' },
  titulo: { color: '#f0d9a0', fontSize: 18, fontWeight: 'bold' },
  lista: { padding: 16 },
  card: { backgroundColor: 'white', borderRadius: 12, padding: 16, marginBottom: 12, elevation: 2 },
  cardHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 },
  codigo: { fontSize: 13, fontWeight: 'bold', color: CAFE, flex: 1 },
  badge: { fontSize: 11, fontWeight: 'bold', paddingHorizontal: 8, paddingVertical: 3, borderRadius: 10 },
  badgeDom: { backgroundColor: '#EBF8FF', color: '#2B6CB0' },
  badgeSuc: { backgroundColor: '#F0FFF4', color: '#276749' },
  fecha: { fontSize: 12, color: '#888', marginBottom: 6 },
  productos: { fontSize: 13, color: '#555', marginBottom: 6 },
  almacen: { fontSize: 12, color: '#888', marginBottom: 6 },
  cardFooter: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 8, paddingTop: 8, borderTopWidth: 1, borderTopColor: '#f5ece0' },
  formaPago: { fontSize: 13, color: '#888' },
  total: { fontSize: 16, fontWeight: 'bold', color: CAFE },
  centrado: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 30, marginTop: 60 },
  vacioIcon: { fontSize: 48, marginBottom: 12 },
  msgText: { fontSize: 15, color: '#888', textAlign: 'center', marginBottom: 20 },
  btn: { backgroundColor: CAFE, padding: 14, borderRadius: 10 },
  btnText: { color: 'white', fontWeight: 'bold', fontSize: 15 },
});