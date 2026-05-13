import React, { useEffect, useState } from 'react';
import {
    ActivityIndicator,
    Alert,
    Modal,
    ScrollView,
    StyleSheet,
    Text,
    TextInput,
    TouchableOpacity,
    View
} from 'react-native';
import { actualizarPuesto, crearPuesto, eliminarPuesto, listarPuestos } from '../../../services/authUsuarios/puestos';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function PuestosScreen() {
  const [puestos, setPuestos] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [modalVisible, setModalVisible] = useState(false);
  const [editando, setEditando] = useState<any>(null);
  const [busqueda, setBusqueda] = useState('');

  const [nombre, setNombre] = useState('');
  const [salario, setSalario] = useState('');
  const [descripcion, setDescripcion] = useState('');

  useEffect(() => { cargar(); }, []);

  const cargar = async () => {
    setLoading(true);
    try {
      const res = await listarPuestos();
      if (res.ok) setPuestos(res.data);
    } catch {
      Alert.alert('Error', 'No se pudo cargar puestos.');
    } finally {
      setLoading(false);
    }
  };

  const abrirModal = (puesto?: any) => {
    if (puesto) {
      setEditando(puesto);
      setNombre(puesto.pue_nombre);
      setSalario(String(puesto.pue_salario));
      setDescripcion(puesto.pue_descripcion || '');
    } else {
      setEditando(null);
      setNombre(''); setSalario(''); setDescripcion('');
    }
    setModalVisible(true);
  };

  const guardar = async () => {
    if (!nombre || !salario) {
      Alert.alert('Error', 'Nombre y salario son obligatorios.');
      return;
    }
    try {
      if (editando) {
        await actualizarPuesto({
          pue_puestos: editando.pue_puestos,
          nombre, salario: parseFloat(salario), descripcion
        });
        Alert.alert('✅', 'Puesto actualizado.');
      } else {
        await crearPuesto({ nombre, salario: parseFloat(salario), descripcion });
        Alert.alert('✅', 'Puesto creado.');
      }
      setModalVisible(false);
      cargar();
    } catch {
      Alert.alert('Error', 'No se pudo guardar.');
    }
  };

  const eliminar = (p: any) => {
    Alert.alert('Eliminar', `¿Eliminar puesto ${p.pue_nombre}?`, [
      { text: 'Cancelar', style: 'cancel' },
      {
        text: 'Eliminar', style: 'destructive', onPress: async () => {
          await eliminarPuesto({ pue_puestos: p.pue_puestos });
          cargar();
        }
      },
    ]);
  };

  const filtrados = puestos.filter(p =>
    p.pue_nombre.toLowerCase().includes(busqueda.toLowerCase())
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>💼 Puestos</Text>
        <TouchableOpacity onPress={() => abrirModal()}>
          <Text style={styles.addBtn}>+ Nuevo</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.searchBox}>
        <TextInput
          style={styles.searchInput}
          placeholder="Buscar puesto..."
          value={busqueda}
          onChangeText={setBusqueda}
        />
      </View>

      {loading ? <ActivityIndicator size="large" color={GOLD} style={{ marginTop: 40 }} /> : (
        <ScrollView contentContainerStyle={styles.list}>
          {filtrados.map((p, i) => (
            <View key={i} style={styles.card}>
              <Text style={styles.cardNombre}>{p.pue_nombre}</Text>
              <Text style={styles.cardSalario}>Q {parseFloat(p.pue_salario).toFixed(2)}</Text>
              <Text style={styles.cardDesc}>{p.pue_descripcion}</Text>
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
            <Text style={styles.modalTitle}>{editando ? 'Editar Puesto' : 'Nuevo Puesto'}</Text>

            <Text style={styles.label}>Nombre *</Text>
            <TextInput style={styles.input} value={nombre} onChangeText={setNombre} placeholder="Nombre del puesto..." />

            <Text style={styles.label}>Salario (Q) *</Text>
            <TextInput style={styles.input} value={salario} onChangeText={setSalario} placeholder="3500.00" keyboardType="numeric" />

            <Text style={styles.label}>Descripción</Text>
            <TextInput style={[styles.input, styles.inputMulti]} value={descripcion} onChangeText={setDescripcion} placeholder="Descripción del puesto..." multiline numberOfLines={3} />

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
  searchBox: { padding: 12, backgroundColor: 'white', borderBottomWidth: 1, borderBottomColor: '#e8d8c0' },
  searchInput: { borderWidth: 1.5, borderColor: '#e8d8c0', borderRadius: 10, padding: 10, fontSize: 13, backgroundColor: '#fafafa' },
  list: { padding: 16, gap: 12 },
  card: { backgroundColor: 'white', borderRadius: 12, padding: 16, elevation: 3 },
  cardNombre: { fontSize: 16, fontWeight: 'bold', color: CAFE, marginBottom: 4 },
  cardSalario: { fontSize: 14, color: GOLD, fontWeight: 'bold', marginBottom: 4 },
  cardDesc: { fontSize: 13, color: '#6b7280', marginBottom: 12 },
  actions: { flexDirection: 'row', gap: 8 },
  btnEdit: { flex: 1, backgroundColor: '#e0e7ff', padding: 8, borderRadius: 8, alignItems: 'center' },
  btnEditText: { color: '#3730a3', fontWeight: 'bold', fontSize: 13 },
  btnDel: { flex: 1, backgroundColor: '#fee2e2', padding: 8, borderRadius: 8, alignItems: 'center' },
  btnDelText: { color: '#991b1b', fontWeight: 'bold', fontSize: 13 },
  modalOverlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 20 },
  modalCard: { backgroundColor: 'white', borderRadius: 16, padding: 24 },
  modalTitle: { fontSize: 18, fontWeight: 'bold', color: CAFE, marginBottom: 16, textAlign: 'center' },
  label: { fontSize: 12, fontWeight: 'bold', color: CAFE, marginBottom: 6 },
  input: { borderWidth: 1.5, borderColor: '#e8d8c0', borderRadius: 10, padding: 12, fontSize: 13, marginBottom: 16, backgroundColor: '#fafafa' },
  inputMulti: { height: 80, textAlignVertical: 'top' },
  modalActions: { flexDirection: 'row', gap: 12, marginTop: 8 },
  btnCancel: { flex: 1, backgroundColor: '#f3f4f6', padding: 12, borderRadius: 8, alignItems: 'center' },
  btnCancelText: { color: '#374151', fontWeight: 'bold' },
  btnSave: { flex: 1, backgroundColor: GOLD, padding: 12, borderRadius: 8, alignItems: 'center' },
  btnSaveText: { color: '#1a1a1a', fontWeight: 'bold' },
});