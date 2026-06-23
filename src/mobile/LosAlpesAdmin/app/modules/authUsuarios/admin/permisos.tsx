import React, { useEffect, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  ScrollView,
  StyleSheet,
  Text,
  View
} from 'react-native';
import { listarPermisos } from '../../../../services/authUsuarios/admin/permisos';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

const MODULOS = [
  { key: 'per_admin', label: 'Admin',       icon: '👑' },
  { key: 'per_rh',    label: 'RH',          icon: '👥' },
  { key: 'per_fac',   label: 'Facturación', icon: '🧾' },
  { key: 'per_cli',   label: 'Clientes',    icon: '🛒' },
  { key: 'per_bod',   label: 'Bodega',      icon: '📦' },
  { key: 'per_promo', label: 'Promos',      icon: '🎁' },
];

export default function PermisosScreen() {
  const [permisos, setPermisos] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => { cargar(); }, []);

  const cargar = async () => {
    setLoading(true);
    try {
      const res = await listarPermisos();
      if (res.ok) setPermisos(res.data);
    } catch {
      Alert.alert('Error', 'No se pudo cargar permisos.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>⚙️ Permisos</Text>
      </View>

      {loading ? (
        <ActivityIndicator size="large" color={GOLD} style={{ marginTop: 40 }} />
      ) : (
        <ScrollView contentContainerStyle={styles.list}>
          {permisos.length === 0 ? (
            <View style={styles.empty}>
              <Text style={styles.emptyIco}>⚙️</Text>
              <Text style={styles.emptyText}>No hay permisos registrados.</Text>
            </View>
          ) : (
            permisos.map((p, i) => (
              <View key={i} style={styles.card}>
                <Text style={styles.cardTitle}>Permiso #{p.per_permisos}</Text>
                <View style={styles.grid}>
                  {MODULOS.map((m) => {
                    const activo = p[m.key] === 1;
                    return (
                      <View key={m.key} style={[styles.cell, activo ? styles.cellOn : styles.cellOff]}>
                        <Text style={styles.cellIcon}>{activo ? m.icon : '✕'}</Text>
                        <Text style={[styles.cellLabel, activo ? styles.cellLabelOn : styles.cellLabelOff]}>
                          {m.label}
                        </Text>
                      </View>
                    );
                  })}
                </View>
              </View>
            ))
          )}
        </ScrollView>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0' },
  header: { backgroundColor: CAFE, padding: 16 },
  title: { color: '#f0d9a0', fontSize: 18, fontWeight: 'bold' },
  list: { padding: 16, gap: 12 },
  card: { backgroundColor: 'white', borderRadius: 12, padding: 16, elevation: 3 },
  cardTitle: { fontSize: 15, fontWeight: 'bold', color: CAFE, marginBottom: 14 },
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 10,
    justifyContent: 'flex-start',
  },
  cell: {
    width: '30%',
    aspectRatio: 1,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1.5,
  },
  cellOn: {
    backgroundColor: '#d1fae5',
    borderColor: '#34d399',
  },
  cellOff: {
    backgroundColor: '#fee2e2',
    borderColor: '#f87171',
  },
  cellIcon: {
    fontSize: 22,
    marginBottom: 4,
  },
  cellLabel: {
    fontSize: 11,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  cellLabelOn: { color: '#065f46' },
  cellLabelOff: { color: '#991b1b' },
  empty: { alignItems: 'center', padding: 60 },
  emptyIco: { fontSize: 48, marginBottom: 12 },
  emptyText: { fontSize: 14, color: '#aaa' },
});