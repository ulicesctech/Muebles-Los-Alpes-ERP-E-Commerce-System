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
import { actualizarPermiso, crearPermiso, listarPermisos } from '../../../../services/authUsuarios/admin/permisos';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

const MODULOS = [
  { key: 'admin', label: 'Administración', icon: '' },
  { key: 'rh',    label: 'Recursos Humanos', icon: '' },
  { key: 'fac',   label: 'Facturación', icon: '' },
  { key: 'cli',   label: 'Clientes', icon: '' },
  { key: 'bod',   label: 'Bodega', icon: '' },
  { key: 'promo', label: 'Promociones', icon: '' },
];

export default function GrupoUsuarioScreen() {
  const [grupos, setGrupos] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [modalVisible, setModalVisible] = useState(false);
  const [editando, setEditando] = useState<any>(null);
  const [paso, setPaso] = useState<1 | 2>(1);

  // Paso 1 - Permisos (solo en memoria, no se guardan hasta Guardar final)
  const [admin, setAdmin] = useState('0');
  const [rh, setRh] = useState('0');
  const [fac, setFac] = useState('0');
  const [cli, setCli] = useState('0');
  const [bod, setBod] = useState('0');
  const [promo, setPromo] = useState('0');

  // Paso 2 - Grupo
  const [descripcion, setDescripcion] = useState('');

  useEffect(() => { cargar(); }, []);

  const cargar = async () => {
    setLoading(true);
    try {
      const resG = await listarGrupos();
      if (resG.ok) setGrupos(resG.data);
    } catch {
      Alert.alert('Error', 'No se pudo cargar.');
    } finally {
      setLoading(false);
    }
  };

  const abrirModal = async (grupo?: any) => {
    if (grupo) {
      // Editar: cargar permisos actuales del grupo
      setEditando(grupo);
      setDescripcion(grupo.grupus_descripcion);
      // Buscar los permisos del grupo para precargarlos
      try {
        const resP = await listarPermisos();
        if (resP.ok) {
          const perm = resP.data.find((p: any) => p.per_permisos === grupo.per_permisos);
          if (perm) {
            setAdmin(String(perm.per_admin));
            setRh(String(perm.per_rh));
            setFac(String(perm.per_fac));
            setCli(String(perm.per_cli));
            setBod(String(perm.per_bod));
            setPromo(String(perm.per_promo));
          }
        }
      } catch {}
    } else {
      // Nuevo
      setEditando(null);
      setDescripcion('');
      setAdmin('0'); setRh('0'); setFac('0');
      setCli('0'); setBod('0'); setPromo('0');
    }
    setPaso(1);
    setModalVisible(true);
  };

  // Guardar TODO junto: primero permiso, luego grupo
  const guardarTodo = async () => {
    if (!descripcion.trim()) {
      Alert.alert('Error', 'Escribe un nombre para el grupo.');
      return;
    }
    try {
      const datosPerm = {
        admin: parseInt(admin), rh: parseInt(rh),
        fac: parseInt(fac), cli: parseInt(cli),
        bod: parseInt(bod), promo: parseInt(promo),
      };

      if (editando) {
        // Actualizar permiso existente
        await actualizarPermiso({
          ...datosPerm,
          per_permisos: editando.per_permisos,
        });
        // Actualizar grupo
        await actualizarGrupo({
          grupus_grupo_usuario: editando.grupus_grupo_usuario,
          descripcion: descripcion.trim(),
          per_permisos: editando.per_permisos,
        });
        Alert.alert('✅', 'Grupo actualizado correctamente.');
      } else {
        // Crear permiso nuevo
        const resPerm = await crearPermiso(datosPerm);
        if (!resPerm.ok) {
          Alert.alert('Error', 'No se pudo crear el permiso.');
          return;
        }
        // Crear grupo con el permiso recién creado
        await crearGrupo({
          descripcion: descripcion.trim(),
          per_permisos: resPerm.per_permisos,
        });
        Alert.alert('✅', 'Grupo creado correctamente.');
      }

      setModalVisible(false);
      cargar();
    } catch {
      Alert.alert('Error', 'No se pudo guardar.');
    }
  };

  const eliminar = (g: any) => {
    Alert.alert('Eliminar', `¿Eliminar el grupo "${g.grupus_descripcion}"?`, [
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

      {loading ? (
        <ActivityIndicator size="large" color={GOLD} style={{ marginTop: 40 }} />
      ) : (
        <ScrollView contentContainerStyle={styles.list}>
          {grupos.map((g, i) => (
            <View key={i} style={styles.card}>
              <Text style={styles.cardTitle}>{g.grupus_descripcion}</Text>
              <Text style={styles.cardSub}>Permiso #{g.per_permisos}</Text>
              <View style={styles.actions}>
                <TouchableOpacity style={styles.btnEdit} onPress={() => abrirModal(g)}>
                  <Text style={styles.btnEditText}>Editar</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.btnDel} onPress={() => eliminar(g)}>
                  <Text style={styles.btnDelText}>Eliminar</Text>
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

              {/* Indicador de pasos */}
              <View style={styles.stepRow}>
                <View style={[styles.step, paso === 1 && styles.stepActive]}>
                  <Text style={[styles.stepText, paso === 1 && styles.stepTextActive]}>
                    1. Permisos
                  </Text>
                </View>
                <View style={styles.stepLine} />
                <View style={[styles.step, paso === 2 && styles.stepActive]}>
                  <Text style={[styles.stepText, paso === 2 && styles.stepTextActive]}>
                    2. Grupo
                  </Text>
                </View>
              </View>

              {/* PASO 1: Permisos */}
              {paso === 1 && (
                <>
                  <Text style={styles.modalTitle}>
                    {editando ? 'Editar Permisos' : '🔐 Definir Permisos'}
                  </Text>
                  <Text style={styles.modalSub}>
                    Define qué módulos tendrá acceso este grupo.
                  </Text>
                  {MODULOS.map((m) => {
                    const vals: any = { admin, rh, fac, cli, bod, promo };
                    const sets: any = {
                      admin: setAdmin, rh: setRh, fac: setFac,
                      cli: setCli, bod: setBod, promo: setPromo
                    };
                    return (
                      <Toggle
                        key={m.key}
                        label={`${m.icon} ${m.label}`}
                        value={vals[m.key]}
                        onChange={sets[m.key]}
                      />
                    );
                  })}
                  <View style={styles.modalActions}>
                    <TouchableOpacity style={styles.btnCancel} onPress={() => setModalVisible(false)}>
                      <Text style={styles.btnCancelText}>Cancelar</Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.btnSave} onPress={() => setPaso(2)}>
                      <Text style={styles.btnSaveText}>Siguiente →</Text>
                    </TouchableOpacity>
                  </View>
                </>
              )}

              {/* PASO 2: Nombre del grupo */}
              {paso === 2 && (
                <>
                  <Text style={styles.modalTitle}>
                    {editando ? 'Editar Grupo' : 'Crear Grupo'}
                  </Text>
                  <Text style={styles.modalSub}>
                    Asigna un nombre al grupo con los permisos configurados.
                  </Text>

                  {/* Resumen de permisos seleccionados */}
                  <View style={styles.resumenPerm}>
                    <Text style={styles.resumenTitle}>Permisos seleccionados:</Text>
                    <View style={styles.resumenRow}>
                      {MODULOS.map((m) => {
                        const vals: any = { admin, rh, fac, cli, bod, promo };
                        const activo = vals[m.key] === '1';
                        return (
                          <View key={m.key} style={[styles.resumenBadge, activo ? styles.resumenOn : styles.resumenOff]}>
                            <Text style={styles.resumenBadgeText}>
                              {activo ? m.icon : '✕'} {m.label}
                            </Text>
                          </View>
                        );
                      })}
                    </View>
                  </View>

                  <Text style={styles.label}>Nombre del Grupo *</Text>
                  <TextInput
                    style={styles.input}
                    value={descripcion}
                    onChangeText={setDescripcion}
                    placeholder="Ej: SuperUsuario, RRHH..."
                    autoFocus
                  />

                  <View style={styles.modalActions}>
                    <TouchableOpacity style={styles.btnCancel} onPress={() => setPaso(1)}>
                      <Text style={styles.btnCancelText}>← Atrás</Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.btnSave} onPress={guardarTodo}>
                      <Text style={styles.btnSaveText}>💾 Guardar</Text>
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
  stepRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 20 },
  step: { flex: 1, padding: 10, borderRadius: 8, backgroundColor: '#f3f4f6', alignItems: 'center' },
  stepActive: { backgroundColor: GOLD },
  stepText: { fontSize: 13, fontWeight: 'bold', color: '#9ca3af' },
  stepTextActive: { color: '#1a1a1a' },
  stepLine: { width: 16, height: 2, backgroundColor: '#e5e7eb', marginHorizontal: 4 },
  modalTitle: { fontSize: 18, fontWeight: 'bold', color: CAFE, marginBottom: 4, textAlign: 'center' },
  modalSub: { fontSize: 12, color: '#9ca3af', textAlign: 'center', marginBottom: 16 },
  toggleRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 },
  toggleLabel: { fontSize: 14, color: '#374151' },
  toggleBtn: { backgroundColor: '#fee2e2', paddingHorizontal: 16, paddingVertical: 8, borderRadius: 8 },
  toggleOn: { backgroundColor: '#d1fae5' },
  toggleText: { fontSize: 13, fontWeight: 'bold' },
  resumenPerm: { backgroundColor: '#fdf6ec', borderRadius: 10, padding: 12, marginBottom: 16, borderWidth: 1, borderColor: '#e8d8c0' },
  resumenTitle: { fontSize: 11, fontWeight: 'bold', color: CAFE, marginBottom: 8, textTransform: 'uppercase', letterSpacing: 0.5 },
  resumenRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 6 },
  resumenBadge: { paddingHorizontal: 8, paddingVertical: 4, borderRadius: 8 },
  resumenOn: { backgroundColor: '#d1fae5' },
  resumenOff: { backgroundColor: '#fee2e2' },
  resumenBadgeText: { fontSize: 11, fontWeight: 'bold', color: '#374151' },
  label: { fontSize: 12, fontWeight: 'bold', color: CAFE, marginBottom: 6 },
  input: { borderWidth: 1.5, borderColor: '#e8d8c0', borderRadius: 10, padding: 12, fontSize: 13, marginBottom: 16, backgroundColor: '#fafafa' },
  modalActions: { flexDirection: 'row', gap: 12, marginTop: 16 },
  btnCancel: { flex: 1, backgroundColor: '#f3f4f6', padding: 12, borderRadius: 8, alignItems: 'center' },
  btnCancelText: { color: '#374151', fontWeight: 'bold' },
  btnSave: { flex: 1, backgroundColor: GOLD, padding: 12, borderRadius: 8, alignItems: 'center' },
  btnSaveText: { color: '#1a1a1a', fontWeight: 'bold' },
});