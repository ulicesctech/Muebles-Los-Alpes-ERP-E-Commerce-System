import { router } from 'expo-router';
import React from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useAuth } from '../context/AuthContext';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function HomeScreen() {
  const { usuario } = useAuth();

  if (usuario?.tipo !== 'EMPLEADO') {
    return <View style={styles.container} />;
  }

  return (
    <ScrollView style={styles.container}>
      <View style={styles.banner}>
        <View>
          <Text style={styles.bannerTitle}>Panel Administrativo</Text>
          <Text style={styles.bannerSub}>Muebles Los Alpes — Santos & Familia, Desde 1978</Text>
          <Text style={styles.bannerTag}>👨‍💼 {usuario?.nombre}</Text>
        </View>
        <Text style={styles.bannerBig}>ERP</Text>
      </View>

      <View style={styles.statsRow}>
        <View style={styles.statBox}>
          <Text style={styles.statIcon}>📦</Text>
          <View>
            <Text style={styles.statNum}>4</Text>
            <Text style={styles.statLabel}>Módulos activos</Text>
          </View>
        </View>

        <View style={styles.statBox}>
          <Text style={styles.statIcon}>🏭</Text>
          <View>
            <Text style={styles.statNum}>—</Text>
            <Text style={styles.statLabel}>Productos</Text>
          </View>
        </View>

        <View style={styles.statBox}>
          <Text style={styles.statIcon}>👥</Text>
          <View>
            <Text style={styles.statNum}>4</Text>
            <Text style={styles.statLabel}>Devs</Text>
          </View>
        </View>
      </View>

      <Text style={styles.sectionLabel}>Módulos del Sistema</Text>

      <View style={styles.modGrid}>
        <TouchableOpacity
          style={styles.modCard}
          onPress={() => router.push('/modules/catalogoInventario' as any)}
        >
          <View style={[styles.modHead, { backgroundColor: GOLD }]} />
          <View style={styles.modBody}>
            <Text style={styles.modIco}>📦</Text>
            <Text style={styles.modTitle}>Catálogo & Inventario</Text>
            <Text style={styles.modDesc}>Productos, categorías, materiales, almacenes y nichos.</Text>
          </View>
          <View style={styles.modFoot}>
            <Text style={[styles.modLink, { color: GOLD }]}>Gestionar →</Text>
          </View>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.modCard}
          onPress={() => router.push('/modules/authUsuarios' as any)}
        >
          <View style={[styles.modHead, { backgroundColor: CAFE }]} />
          <View style={styles.modBody}>
            <Text style={styles.modIco}>👤</Text>
            <Text style={styles.modTitle}>Auth & Usuarios</Text>
            <Text style={styles.modDesc}>Usuarios, roles y permisos del sistema.</Text>
          </View>
          <View style={styles.modFoot}>
            <Text style={[styles.modLink, { color: CAFE }]}>Gestionar →</Text>
          </View>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.modCard}
          onPress={() => router.push('/modules/comprasProveedor' as any)}
        >
          <View style={[styles.modHead, { backgroundColor: '#2d7a2d' }]} />
          <View style={styles.modBody}>
            <Text style={styles.modIco}>🛒</Text>
            <Text style={styles.modTitle}>Compras & Proveedor</Text>
            <Text style={styles.modDesc}>Órdenes de compra y gestión de proveedores.</Text>
          </View>
          <View style={styles.modFoot}>
            <Text style={[styles.modLink, { color: '#2d7a2d' }]}>Gestionar →</Text>
          </View>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.modCard}
          onPress={() => router.push('/modules/ventasFacturacion' as any)}
        >
          <View style={[styles.modHead, { backgroundColor: '#c53030' }]} />
          <View style={styles.modBody}>
            <Text style={styles.modIco}>📋</Text>
            <Text style={styles.modTitle}>Ventas & Facturación</Text>
            <Text style={styles.modDesc}>Ventas, facturas y reportes gerenciales.</Text>
          </View>
          <View style={styles.modFoot}>
            <Text style={[styles.modLink, { color: '#c53030' }]}>Gestionar →</Text>
          </View>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0' },
  banner: {
    backgroundColor: '#1a0e05',
    borderRadius: 12,
    margin: 16,
    padding: 24,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    borderLeftWidth: 5,
    borderLeftColor: GOLD,
  },
  bannerTitle: { color: GOLD, fontSize: 20, fontWeight: 'bold' },
  bannerSub: { color: 'rgba(240,217,160,0.65)', fontSize: 11, marginTop: 4 },
  bannerTag: {
    color: GOLD,
    fontSize: 12,
    marginTop: 8,
    backgroundColor: 'rgba(201,151,58,0.12)',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 20,
    overflow: 'hidden',
  },
  bannerBig: { color: 'rgba(201,151,58,0.15)', fontSize: 52, fontWeight: 'bold' },
  statsRow: { flexDirection: 'row', paddingHorizontal: 16, gap: 10, marginBottom: 16 },
  statBox: {
    flex: 1,
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 12,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    borderLeftWidth: 3,
    borderLeftColor: GOLD,
    elevation: 2,
  },
  statIcon: { fontSize: 22 },
  statNum: { fontSize: 20, fontWeight: 'bold', color: '#1a0e05' },
  statLabel: { fontSize: 10, color: '#aaa' },
  sectionLabel: {
    marginHorizontal: 16,
    marginBottom: 12,
    fontSize: 11,
    fontWeight: 'bold',
    color: CAFE,
    backgroundColor: '#fdf6ec',
    padding: 8,
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: GOLD,
    textTransform: 'uppercase',
    letterSpacing: 1,
  },
  modGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
    gap: 12,
    marginBottom: 20,
  },
  modCard: {
    width: '47%',
    backgroundColor: 'white',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#e0d0b8',
    elevation: 2,
    overflow: 'hidden',
  },
  modHead: { height: 6 },
  modBody: { padding: 16 },
  modIco: { fontSize: 28, marginBottom: 8 },
  modTitle: { fontSize: 13, fontWeight: 'bold', color: '#1a0e05' },
  modDesc: { fontSize: 11, color: '#aaa', marginTop: 4, lineHeight: 16 },
  modFoot: { padding: 12, borderTopWidth: 1, borderTopColor: '#f5ece0' },
  modLink: { fontSize: 13, fontWeight: 'bold' },
});