import React, { useEffect, useState } from 'react';
import {
    ActivityIndicator,
    Alert,
    Modal,
    ScrollView,
    StyleSheet,
    Text,
    TouchableOpacity,
    View
} from 'react-native';
import { actualizarPermiso, crearPermiso, eliminarPermiso, listarPermisos } from '../../../../services/authUsuarios/admin/permisos';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function PermisosScreen() {
  const [permisos, setPermisos] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [modalVisible, setModalVisible] = useState(false);
  const [editando, setEditando] = useState<any>(null);

  const [admin, setAdmin] = useState('0');
  const [rh, setRh] = useState('0');
  const [fac, setFac] = useState('0');
  const [cli, setCli] = useState('0');
  const [bod, setBod] = useState('0');
  const [promo, setPromo] = useState('0');

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

  const abrirModal = (p?: any) => {
    if (p) {
      setEditando(p);
      setAdmin(String(p.per_admin));
      setRh(String(p.per_rh));
      setFac(String(p.per_fac));
      setCli(String(p.per_cli));
      setBod(String(p.per_bod));
      setPromo(String(p.per_promo));
    } else {
      setEditando(null);
      setAdmin('0'); setRh('0'); setFac('0');
      setCli('0'); setBod('0'); setPromo('0');
    }
    setModalVisible(true);
  };

  const guardar = async () => {
    try {
      const datos = {
        admin: parseInt(admin), rh: parseInt(rh),
        fac: parseInt(fac), cli: parseInt(cli),
        bod: parseInt(bod), promo: parseInt(promo),
      };
      if (editando) {
        await actualizarPermiso({ ...datos, per_permisos: editando.per_permisos });
        Alert.alert('✅', 'Permiso actualizado.');
      } else {
        await crearPermiso(datos);
        Alert.alert('✅', 'Permiso creado.');
      }
      setModalVisible(false);
      cargar();
    } catch {
      Alert.alert('Error', 'No se pudo guardar.');
    }
  };

  const eliminar = (p: any) => {
    Alert.alert('Eliminar', '¿Eliminar este permiso?', [
      { text: 'Cancelar', style: 'cancel' },
      {
        text: 'Eliminar', style: 'destructive', onPress: async () => {
          await eliminarPermiso({ per_permisos: p.per_permisos });
          cargar();
        }
      },
    ]);
  };

  const Toggle = ({ label, value, onChange }: any) => (
    <View style={styles.toggleRow}>
      <Text style={styles.toggleLabel}>{label}</Text>
      <TouchableOpacity
        style={[styles.toggleBtn, value === '1' && styles.toggleOn]}
        onPress={() => onChange(value === '1' ? '0' : '1')}>
        <Text style={styles.toggleText}>{value === '1' ? '✅ Sí' : '❌ No'}</Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>⚙️ Permisos</Text>
        <TouchableOpacity onPress={() => abrirModal()}>
          <Text style={styles.addBtn}>+ Nuevo</Text>
        </TouchableOpacity>
      </View>

      {loading ? <ActivityIndicator size="large" color={GOLD} style={{ marginTop: 40 }} /> : (
        <ScrollView contentContainerStyle={styles.list}>
          {permisos.map((p, i) => (
            <View key={i} style={styles.card}>
              <Text style={styles.cardTitle}>Permiso #{p.per_permisos}</Text>
              <View style={styles.badgeRow}>
                {p.per_admin === 1 && <Text style={styles.badge}>Admin</Text>}
                {p.per_rh === 1 && <Text style={styles.badge}>RH</Text>}
                {p.per_fac === 1 && <Text style={styles.badge}>Facturación</Text>}
                {p.per_cli === 1 && <Text style={styles.badge}>Clientes</Text>}
                {p.per_bod === 1 && <Text style={styles.badge}>Bodega</Text>}
                {p.per_promo === 1 && <Text style={styles.badge}>Promos</Text>}
              </View>
              <View style={styles.actions}>
                <TouchableOpacity style={styles.btnEdit} onPress={() => abrirModal(p)}>
                  <Text style={styles.btnEditText}>✏️ Editar</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.btnDel} onPress={() => eliminar(p)}>
                  <Text style={styles.btnDelText}>🗑️ Eliminar</Text>
                </TouchableOpacity>
              </View>
            </View>
          ))}
        </ScrollView>
      )}

      <Modal visible={modalVisible} animationType="slide" transparent>
        <View style={styles.modalOverlay}>
          <View style={styles.modalCard}>
            <Text style={styles.modalTitle}>{editando ? 'Editar Permiso' : 'Nuevo Permiso'}</Text>
            <Toggle label="Administración" value={admin} onChange={setAdmin} />
            <Toggle label="Recursos Humanos" value={rh} onChange={setRh} />
            <Toggle label="Facturación" value={fac} onChange={setFac} />
            <Toggle label="Clientes" value={cli} onChange={setCli} />
            <Toggle label="Bodega" value={bod} onChange={setBod} />
            <Toggle label="Promociones" value={promo} onChange={setPromo} />
            <View style={styles.modalActions}>
              <TouchableOpacity style={styles.btnCancel} onPress={() => setModalVisible(false)}>
                <Text style={styles.btnCancelText}>Cancelar</Text>
              </TouchableOpacity>
              <TouchableOpacity style={styles.btnSave} onPress={guardar}>
                <Text style={styles.btnSaveText}>Guardar</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0' },
  header: { backgroundColor: CAFE, padding: 16, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  title: { color: '#f0d9a0', fontSize: 18, fontWeight: 'bold' },
  addBtn: { color: GOLD, fontSize: 14, fontWeight: 'bold' },
  list: { padding: 16, gap: 12 },
  card: { backgroundColor: 'white', borderRadius: 12, padding: 16, elevation: 3 },
  cardTitle: { fontSize: 16, fontWeight: 'bold', color: CAFE, marginBottom: 8 },
  badgeRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 6, marginBottom: 12 },
  badge: { backgroundColor: '#fef3c7', color: '#92400e', paddingHorizontal: 8, paddingVertical: 3, borderRadius: 10, fontSize: 12, fontWeight: 'bold' },
  actions: { flexDirection: 'row', gap: 8 },
  btnEdit: { flex: 1, backgroundColor: '#e0e7ff', padding: 8, borderRadius: 8, alignItems: 'center' },
  btnEditText: { color: '#3730a3', fontWeight: 'bold', fontSize: 13 },
  btnDel: { flex: 1, backgroundColor: '#fee2e2', padding: 8, borderRadius: 8, alignItems: 'center' },
  btnDelText: { color: '#991b1b', fontWeight: 'bold', fontSize: 13 },
  modalOverlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 20 },
  modalCard: { backgroundColor: 'white', borderRadius: 16, padding: 24 },
  modalTitle: { fontSize: 18, fontWeight: 'bold', color: CAFE, marginBottom: 16, textAlign: 'center' },
  toggleRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 },
  toggleLabel: { fontSize: 14, color: '#374151' },
  toggleBtn: { backgroundColor: '#fee2e2', paddingHorizontal: 16, paddingVertical: 8, borderRadius: 8 },
  toggleOn: { backgroundColor: '#d1fae5' },
  toggleText: { fontSize: 13, fontWeight: 'bold' },
  modalActions: { flexDirection: 'row', gap: 12, marginTop: 16 },
  btnCancel: { flex: 1, backgroundColor: '#f3f4f6', padding: 12, borderRadius: 8, alignItems: 'center' },
  btnCancelText: { color: '#374151', fontWeight: 'bold' },
  btnSave: { flex: 1, backgroundColor: GOLD, padding: 12, borderRadius: 8, alignItems: 'center' },
  btnSaveText: { color: '#1a1a1a', fontWeight: 'bold' },
});