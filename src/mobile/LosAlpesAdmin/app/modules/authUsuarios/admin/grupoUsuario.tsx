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
import { actualizarGrupo, crearGrupo, eliminarGrupo, listarGrupos } from '../../../../services/authUsuarios/admin/grupoUsuario';
import { crearPermiso, listarPermisos } from '../../../../services/authUsuarios/admin/permisos';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function GrupoUsuarioScreen() {
  const [grupos, setGrupos] = useState<any[]>([]);
  const [permisos, setPermisos] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [modalVisible, setModalVisible] = useState(false);
  const [editando, setEditando] = useState<any>(null);
  const [paso, setPaso] = useState<1 | 2>(1);

  // Paso 1 - Permiso
  const [admin, setAdmin] = useState('0');
  const [rh, setRh] = useState('0');
  const [fac, setFac] = useState('0');
  const [cli, setCli] = useState('0');
  const [bod, setBod] = useState('0');
  const [promo, setPromo] = useState('0');
  const [permisoCreado, setPermisoCreado] = useState<number | null>(null);

  // Paso 2 - Grupo
  const [descripcion, setDescripcion] = useState('');
  const [permisoSeleccionado, setPermisoSeleccionado] = useState('');

  useEffect(() => { cargar(); }, []);

  const cargar = async () => {
    setLoading(true);
    try {
      const [resG, resP] = await Promise.all([listarGrupos(), listarPermisos()]);
      if (resG.ok) setGrupos(resG.data);
      if (resP.ok) setPermisos(resP.data);
    } catch {
      Alert.alert('Error', 'No se pudo cargar.');
    } finally {
      setLoading(false);
    }
  };

  const abrirModal = (grupo?: any) => {
    setEditando(grupo || null);
    setPaso(grupo ? 2 : 1);
    setAdmin('0'); setRh('0'); setFac('0');
    setCli('0'); setBod('0'); setPromo('0');
    setPermisoCreado(null);
    setDescripcion(grupo ? grupo.grupus_descripcion : '');
    setPermisoSeleccionado(grupo ? String(grupo.per_permisos) : '');
    setModalVisible(true);
  };

  const crearPermisoYAvanzar = async () => {
    try {
      const res = await crearPermiso({
        admin: parseInt(admin), rh: parseInt(rh),
        fac: parseInt(fac), cli: parseInt(cli),
        bod: parseInt(bod), promo: parseInt(promo),
      });
      if (res.ok) {
        setPermisoCreado(res.per_permisos);
        setPermisoSeleccionado(String(res.per_permisos));
        await cargar();
        setPaso(2);
      }
    } catch {
      Alert.alert('Error', 'No se pudo crear el permiso.');
    }
  };

  const guardarGrupo = async () => {
    if (!descripcion || !permisoSeleccionado) {
      Alert.alert('Error', 'Completa todos los campos.');
      return;
    }
    try {
      if (editando) {
        await actualizarGrupo({
          grupus_grupo_usuario: editando.grupus_grupo_usuario,
          descripcion, per_permisos: parseInt(permisoSeleccionado)
        });
        Alert.alert('✅', 'Grupo actualizado.');
      } else {
        await crearGrupo({ descripcion, per_permisos: parseInt(permisoSeleccionado) });
        Alert.alert('✅', 'Grupo creado.');
      }
      setModalVisible(false);
      cargar();
    } catch {
      Alert.alert('Error', 'No se pudo guardar.');
    }
  };

  const eliminar = (g: any) => {
    Alert.alert('Eliminar', `¿Eliminar grupo ${g.grupus_descripcion}?`, [
      { text: 'Cancelar', style: 'cancel' },
      {
        text: 'Eliminar', style: 'destructive', onPress: async () => {
          await eliminarGrupo({ grupus_grupo_usuario: g.grupus_grupo_usuario });
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
        <Text style={styles.title}>👥 Grupos</Text>
        <TouchableOpacity onPress={() => abrirModal()}>
          <Text style={styles.addBtn}>+ Nuevo</Text>
        </TouchableOpacity>
      </View>

      {loading ? <ActivityIndicator size="large" color={GOLD} style={{ marginTop: 40 }} /> : (
        <ScrollView contentContainerStyle={styles.list}>
          {grupos.map((g, i) => (
            <View key={i} style={styles.card}>
              <Text style={styles.cardTitle}>{g.grupus_descripcion}</Text>
              <Text style={styles.cardSub}>Permiso #{g.per_permisos}</Text>
              <View style={styles.actions}>
                <TouchableOpacity style={styles.btnEdit} onPress={() => abrirModal(g)}>
                  <Text style={styles.btnEditText}>✏️ Editar</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.btnDel} onPress={() => eliminar(g)}>
                  <Text style={styles.btnDelText}>🗑️ Eliminar</Text>
                </TouchableOpacity>
              </View>
            </View>
          ))}
        </ScrollView>
      )}

      <Modal visible={modalVisible} animationType="slide" transparent>
        <View style={styles.modalOverlay}>
          <ScrollView>
            <View style={styles.modalCard}>
              {!editando && (
                <View style={styles.stepRow}>
                  <View style={[styles.step, paso === 1 && styles.stepActive]}>
                    <Text style={styles.stepText}>1. Permiso</Text>
                  </View>
                  <View style={[styles.step, paso === 2 && styles.stepActive]}>
                    <Text style={styles.stepText}>2. Grupo</Text>
                  </View>
                </View>
              )}

              {paso === 1 && (
                <>
                  <Text style={styles.modalTitle}>Definir Permisos</Text>
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
                    <TouchableOpacity style={styles.btnSave} onPress={crearPermisoYAvanzar}>
                      <Text style={styles.btnSaveText}>Siguiente →</Text>
                    </TouchableOpacity>
                  </View>
                </>
              )}

              {paso === 2 && (
                <>
                  <Text style={styles.modalTitle}>{editando ? 'Editar Grupo' : 'Asignar Grupo'}</Text>
                  {permisoCreado && (
                    <View style={styles.permisoInfo}>
                      <Text style={styles.permisoInfoText}>✅ Permiso #{permisoCreado} creado</Text>
                    </View>
                  )}
                  <Text style={styles.label}>Nombre del Grupo *</Text>
                  <TextInput
                    style={styles.input}
                    value={descripcion}
                    onChangeText={setDescripcion}
                    placeholder="Ej: SuperUsuario, RRHH..."
                  />
                  {!permisoCreado && (
                    <>
                      <Text style={styles.label}>Seleccionar Permiso *</Text>
                      <ScrollView style={styles.permisoList} nestedScrollEnabled>
                        {permisos.map((p, i) => (
                          <TouchableOpacity
                            key={i}
                            style={[styles.permisoItem, permisoSeleccionado === String(p.per_permisos) && styles.permisoSelected]}
                            onPress={() => setPermisoSeleccionado(String(p.per_permisos))}>
                            <Text style={styles.permisoText}>Permiso #{p.per_permisos}</Text>
                          </TouchableOpacity>
                        ))}
                      </ScrollView>
                    </>
                  )}
                  <View style={styles.modalActions}>
                    {!editando ? (
                      <TouchableOpacity style={styles.btnCancel} onPress={() => setPaso(1)}>
                        <Text style={styles.btnCancelText}>← Atrás</Text>
                      </TouchableOpacity>
                    ) : (
                      <TouchableOpacity style={styles.btnCancel} onPress={() => setModalVisible(false)}>
                        <Text style={styles.btnCancelText}>Cancelar</Text>
                      </TouchableOpacity>
                    )}
                    <TouchableOpacity style={styles.btnSave} onPress={guardarGrupo}>
                      <Text style={styles.btnSaveText}>Guardar ✅</Text>
                    </TouchableOpacity>
                  </View>
                </>
              )}
            </View>
          </ScrollView>
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
  cardTitle: { fontSize: 16, fontWeight: 'bold', color: CAFE, marginBottom: 4 },
  cardSub: { fontSize: 13, color: '#6b7280', marginBottom: 12 },
  actions: { flexDirection: 'row', gap: 8 },
  btnEdit: { flex: 1, backgroundColor: '#e0e7ff', padding: 8, borderRadius: 8, alignItems: 'center' },
  btnEditText: { color: '#3730a3', fontWeight: 'bold', fontSize: 13 },
  btnDel: { flex: 1, backgroundColor: '#fee2e2', padding: 8, borderRadius: 8, alignItems: 'center' },
  btnDelText: { color: '#991b1b', fontWeight: 'bold', fontSize: 13 },
  modalOverlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', paddingVertical: 40, paddingHorizontal: 20 },
  modalCard: { backgroundColor: 'white', borderRadius: 16, padding: 24 },
  stepRow: { flexDirection: 'row', gap: 8, marginBottom: 16 },
  step: { flex: 1, padding: 10, borderRadius: 8, backgroundColor: '#f3f4f6', alignItems: 'center' },
  stepActive: { backgroundColor: GOLD },
  stepText: { fontSize: 13, fontWeight: 'bold', color: '#374151' },
  modalTitle: { fontSize: 18, fontWeight: 'bold', color: CAFE, marginBottom: 16, textAlign: 'center' },
  toggleRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 },
  toggleLabel: { fontSize: 14, color: '#374151' },
  toggleBtn: { backgroundColor: '#fee2e2', paddingHorizontal: 16, paddingVertical: 8, borderRadius: 8 },
  toggleOn: { backgroundColor: '#d1fae5' },
  toggleText: { fontSize: 13, fontWeight: 'bold' },
  label: { fontSize: 12, fontWeight: 'bold', color: CAFE, marginBottom: 6 },
  input: { borderWidth: 1.5, borderColor: '#e8d8c0', borderRadius: 10, padding: 12, fontSize: 13, marginBottom: 16, backgroundColor: '#fafafa' },
  permisoList: { maxHeight: 150, marginBottom: 16 },
  permisoItem: { padding: 10, borderRadius: 8, borderWidth: 1, borderColor: '#e8d8c0', marginBottom: 6 },
  permisoSelected: { backgroundColor: GOLD, borderColor: GOLD },
  permisoText: { fontSize: 13, color: '#374151' },
  permisoInfo: { backgroundColor: '#d1fae5', padding: 10, borderRadius: 8, marginBottom: 12 },
  permisoInfoText: { color: '#065f46', fontWeight: 'bold', textAlign: 'center' },
  modalActions: { flexDirection: 'row', gap: 12, marginTop: 16 },
  btnCancel: { flex: 1, backgroundColor: '#f3f4f6', padding: 12, borderRadius: 8, alignItems: 'center' },
  btnCancelText: { color: '#374151', fontWeight: 'bold' },
  btnSave: { flex: 1, backgroundColor: GOLD, padding: 12, borderRadius: 8, alignItems: 'center' },
  btnSaveText: { color: '#1a1a1a', fontWeight: 'bold' },
});