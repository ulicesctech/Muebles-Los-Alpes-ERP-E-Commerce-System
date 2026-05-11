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
import { useAuth } from '../../../context/AuthContext';
import { actualizarEmpleado, crearEmpleado, eliminarEmpleado, listarEmpleados } from '../../services/authUsuarios/empleados';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function EmpleadosScreen() {
  const { usuario } = useAuth();
  const [empleados, setEmpleados] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [modalVisible, setModalVisible] = useState(false);
  const [editando, setEditando] = useState<any>(null);
  const [busqueda, setBusqueda] = useState('');

  const [dpi, setDpi] = useState('');
  const [primerNombre, setPrimerNombre] = useState('');
  const [segundoNombre, setSegundoNombre] = useState('');
  const [primerApellido, setPrimerApellido] = useState('');
  const [segundoApellido, setSegundoApellido] = useState('');
  const [direccion, setDireccion] = useState('');
  const [avenida, setAvenida] = useState('');
  const [cp, setCp] = useState('');
  const [tel1, setTel1] = useState('');
  const [tel2, setTel2] = useState('');
  const [rol, setRol] = useState('');
  const [password, setPassword] = useState('');

  useEffect(() => { cargar(); }, []);

  const cargar = async () => {
    setLoading(true);
    try {
      const res = await listarEmpleados();
      if (res.ok) setEmpleados(res.data);
    } catch {
      Alert.alert('Error', 'No se pudo cargar empleados.');
    } finally {
      setLoading(false);
    }
  };

  const abrirModal = (emp?: any) => {
    if (emp) {
      setEditando(emp);
      setDpi(emp.em_DPI);
      setPrimerNombre(emp.em_primer_nombre);
      setSegundoNombre(emp.em_segundo_nombre || '');
      setPrimerApellido(emp.em_primer_apellido);
      setSegundoApellido(emp.em_segundo_apellido || '');
      setDireccion(emp.em_direccion);
      setAvenida(emp.em_avenida);
      setCp(emp.em_codigo_postal);
      setTel1(emp.em_primer_telefono);
      setTel2(emp.em_segundo_telefono || '');
      setRol(String(emp.rolus_rol_usuario));
      setPassword('');
    } else {
      setEditando(null);
      setDpi(''); setPrimerNombre(''); setSegundoNombre('');
      setPrimerApellido(''); setSegundoApellido('');
      setDireccion(''); setAvenida(''); setCp('');
      setTel1(''); setTel2(''); setRol(''); setPassword('');
    }
    setModalVisible(true);
  };

  const guardar = async () => {
    if (!dpi || !primerNombre || !primerApellido || !tel1 || !rol) {
      Alert.alert('Error', 'Completa los campos obligatorios.');
      return;
    }
    try {
      if (editando) {
        await actualizarEmpleado({
          em_empleado: editando.em_empleado,
          dpi, primer_nombre: primerNombre, segundo_nombre: segundoNombre || ' ',
          primer_apellido: primerApellido, segundo_apellido: segundoApellido || ' ',
          direccion, avenida, codigo_postal: cp,
          primer_telefono: tel1, segundo_telefono: tel2 || ' ', rol: parseInt(rol)
        });
        Alert.alert('✅', 'Empleado actualizado.');
      } else {
        if (!password) { Alert.alert('Error', 'La contraseña es obligatoria.'); return; }
        await crearEmpleado({
          dpi, primer_nombre: primerNombre, segundo_nombre: segundoNombre || ' ',
          primer_apellido: primerApellido, segundo_apellido: segundoApellido || ' ',
          direccion, avenida, codigo_postal: cp,
          primer_telefono: tel1, segundo_telefono: tel2 || ' ',
          rol: parseInt(rol), password
        });
        Alert.alert('✅', 'Empleado creado.');
      }
      setModalVisible(false);
      cargar();
    } catch {
      Alert.alert('Error', 'No se pudo guardar.');
    }
  };

  const eliminar = (emp: any) => {
    if (emp.em_empleado === usuario?.id) {
      Alert.alert('Error', 'No puedes eliminarte a ti mismo.');
      return;
    }
    Alert.alert('Eliminar', `¿Eliminar a ${emp.em_primer_nombre}?`, [
      { text: 'Cancelar', style: 'cancel' },
      {
        text: 'Eliminar', style: 'destructive', onPress: async () => {
          await eliminarEmpleado({ em_empleado: emp.em_empleado });
          cargar();
        }
      },
    ]);
  };

  const filtrados = empleados.filter(e =>
    `${e.em_primer_nombre} ${e.em_primer_apellido} ${e.em_DPI}`.toLowerCase().includes(busqueda.toLowerCase())
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>👨‍💼 Empleados</Text>
        <TouchableOpacity onPress={() => abrirModal()}>
          <Text style={styles.addBtn}>+ Nuevo</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.searchBox}>
        <TextInput
          style={styles.searchInput}
          placeholder="Buscar por nombre o DPI..."
          value={busqueda}
          onChangeText={setBusqueda}
        />
      </View>

      {loading ? <ActivityIndicator size="large" color={GOLD} style={{ marginTop: 40 }} /> : (
        <ScrollView contentContainerStyle={styles.list}>
          {filtrados.map((e, i) => (
            <View key={i} style={styles.card}>
              <Text style={styles.cardNombre}>{e.em_primer_nombre} {e.em_primer_apellido}</Text>
              <Text style={styles.cardDpi}>DPI: {e.em_DPI}</Text>
              <Text style={styles.cardRol}>Rol: {e.rol_nombre}</Text>
              <View style={styles.actions}>
                <TouchableOpacity style={styles.btnEdit} onPress={() => abrirModal(e)}>
                  <Text style={styles.btnEditText}>✏️ Editar</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.btnDel} onPress={() => eliminar(e)}>
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
              <Text style={styles.modalTitle}>{editando ? 'Editar Empleado' : 'Nuevo Empleado'}</Text>

              <Text style={styles.label}>DPI *</Text>
              <TextInput style={styles.input} value={dpi} onChangeText={setDpi} placeholder="13 dígitos..." keyboardType="numeric" editable={!editando} />

              <Text style={styles.label}>Primer Nombre *</Text>
              <TextInput style={styles.input} value={primerNombre} onChangeText={setPrimerNombre} placeholder="Nombre..." />

              <Text style={styles.label}>Segundo Nombre</Text>
              <TextInput style={styles.input} value={segundoNombre} onChangeText={setSegundoNombre} placeholder="Opcional..." />

              <Text style={styles.label}>Primer Apellido *</Text>
              <TextInput style={styles.input} value={primerApellido} onChangeText={setPrimerApellido} placeholder="Apellido..." />

              <Text style={styles.label}>Segundo Apellido</Text>
              <TextInput style={styles.input} value={segundoApellido} onChangeText={setSegundoApellido} placeholder="Opcional..." />

              <Text style={styles.label}>Dirección *</Text>
              <TextInput style={styles.input} value={direccion} onChangeText={setDireccion} placeholder="Dirección..." />

              <Text style={styles.label}>Avenida</Text>
              <TextInput style={styles.input} value={avenida} onChangeText={setAvenida} placeholder="Avenida..." />

              <Text style={styles.label}>Código Postal</Text>
              <TextInput style={styles.input} value={cp} onChangeText={setCp} placeholder="01001..." keyboardType="numeric" />

              <Text style={styles.label}>Teléfono Principal *</Text>
              <TextInput style={styles.input} value={tel1} onChangeText={setTel1} placeholder="55551234..." keyboardType="numeric" />

              <Text style={styles.label}>Teléfono Secundario</Text>
              <TextInput style={styles.input} value={tel2} onChangeText={setTel2} placeholder="Opcional..." keyboardType="numeric" />

              <Text style={styles.label}>Rol (ID Grupo) *</Text>
              <TextInput style={styles.input} value={rol} onChangeText={setRol} placeholder="1=SuperUsuario, 2=Admin..." keyboardType="numeric" />

              {!editando && (
                <>
                  <Text style={styles.label}>Contraseña *</Text>
                  <TextInput style={styles.input} value={password} onChangeText={setPassword} placeholder="Mín. 8 caracteres..." secureTextEntry />
                </>
              )}

              <View style={styles.modalActions}>
                <TouchableOpacity style={styles.btnCancel} onPress={() => setModalVisible(false)}>
                  <Text style={styles.btnCancelText}>Cancelar</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.btnSave} onPress={guardar}>
                  <Text style={styles.btnSaveText}>Guardar</Text>
                </TouchableOpacity>
              </View>
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
  searchBox: { padding: 12, backgroundColor: 'white', borderBottomWidth: 1, borderBottomColor: '#e8d8c0' },
  searchInput: { borderWidth: 1.5, borderColor: '#e8d8c0', borderRadius: 10, padding: 10, fontSize: 13, backgroundColor: '#fafafa' },
  list: { padding: 16, gap: 12 },
  card: { backgroundColor: 'white', borderRadius: 12, padding: 16, elevation: 3 },
  cardNombre: { fontSize: 16, fontWeight: 'bold', color: CAFE, marginBottom: 4 },
  cardDpi: { fontSize: 13, color: '#6b7280', marginBottom: 2 },
  cardRol: { fontSize: 13, color: GOLD, fontWeight: 'bold', marginBottom: 12 },
  actions: { flexDirection: 'row', gap: 8 },
  btnEdit: { flex: 1, backgroundColor: '#e0e7ff', padding: 8, borderRadius: 8, alignItems: 'center' },
  btnEditText: { color: '#3730a3', fontWeight: 'bold', fontSize: 13 },
  btnDel: { flex: 1, backgroundColor: '#fee2e2', padding: 8, borderRadius: 8, alignItems: 'center' },
  btnDelText: { color: '#991b1b', fontWeight: 'bold', fontSize: 13 },
  modalOverlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', paddingVertical: 40, paddingHorizontal: 20 },
  modalCard: { backgroundColor: 'white', borderRadius: 16, padding: 24 },
  modalTitle: { fontSize: 18, fontWeight: 'bold', color: CAFE, marginBottom: 16, textAlign: 'center' },
  label: { fontSize: 12, fontWeight: 'bold', color: CAFE, marginBottom: 6 },
  input: { borderWidth: 1.5, borderColor: '#e8d8c0', borderRadius: 10, padding: 12, fontSize: 13, marginBottom: 16, backgroundColor: '#fafafa' },
  modalActions: { flexDirection: 'row', gap: 12, marginTop: 8 },
  btnCancel: { flex: 1, backgroundColor: '#f3f4f6', padding: 12, borderRadius: 8, alignItems: 'center' },
  btnCancelText: { color: '#374151', fontWeight: 'bold' },
  btnSave: { flex: 1, backgroundColor: GOLD, padding: 12, borderRadius: 8, alignItems: 'center' },
  btnSaveText: { color: '#1a1a1a', fontWeight: 'bold' },
});