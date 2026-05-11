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
import { actualizarCliente, crearCliente, eliminarCliente, listarClientes } from '../../services/authUsuarios/clientes';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function ClientesScreen() {
  const [clientes, setClientes] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [modalVisible, setModalVisible] = useState(false);
  const [editando, setEditando] = useState<any>(null);
  const [busqueda, setBusqueda] = useState('');

  const [tipoDoc, setTipoDoc] = useState('DPI');
  const [numDoc, setNumDoc] = useState('');
  const [nit, setNit] = useState('');
  const [primerNombre, setPrimerNombre] = useState('');
  const [segundoNombre, setSegundoNombre] = useState('');
  const [primerApellido, setPrimerApellido] = useState('');
  const [segundoApellido, setSegundoApellido] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [tel1, setTel1] = useState('');
  const [tel2, setTel2] = useState('');
  const [pais, setPais] = useState('Guatemala');
  const [dep, setDep] = useState('');
  const [mun, setMun] = useState('');
  const [zona, setZona] = useState('');
  const [dir, setDir] = useState('');
  const [cp, setCp] = useState('');
  const [tipoCliente, setTipoCliente] = useState('NATURAL');
  const [profesion, setProfesion] = useState('');

  useEffect(() => { cargar(); }, []);

  const cargar = async () => {
    setLoading(true);
    try {
      const res = await listarClientes();
      if (res.ok) setClientes(res.data);
    } catch {
      Alert.alert('Error', 'No se pudo cargar clientes.');
    } finally {
      setLoading(false);
    }
  };

  const abrirModal = (cli?: any) => {
    if (cli) {
      setEditando(cli);
      setTipoDoc(cli.cli_tipodocumento);
      setNumDoc(cli.cli_numdocumento);
      setNit(cli.cli_nit || '');
      setPrimerNombre(cli.cli_primer_nombre);
      setSegundoNombre(cli.cli_segundo_nombre || '');
      setPrimerApellido(cli.cli_primer_apellido);
      setSegundoApellido(cli.cli_segundo_apellido || '');
      setEmail(cli.cli_email);
      setTel1(cli.cli_primer_telefono);
      setTel2(cli.cli_segundo_telefono || '');
      setPais(cli.cli_pais);
      setDep(cli.cli_departamento);
      setMun(cli.cli_municipio);
      setZona(cli.cli_zona);
      setDir(cli.cli_direccion);
      setCp(cli.cli_codigo_postal);
      setTipoCliente(cli.cli_tipocliente);
      setProfesion(cli.cli_profesion || '');
      setPassword('');
    } else {
      setEditando(null);
      setTipoDoc('DPI'); setNumDoc(''); setNit('');
      setPrimerNombre(''); setSegundoNombre('');
      setPrimerApellido(''); setSegundoApellido('');
      setEmail(''); setPassword(''); setTel1(''); setTel2('');
      setPais('Guatemala'); setDep(''); setMun('');
      setZona(''); setDir(''); setCp('');
      setTipoCliente('NATURAL'); setProfesion('');
    }
    setModalVisible(true);
  };

  const guardar = async () => {
    if (!primerNombre || !primerApellido || !email || !numDoc || !tel1 || !dep || !mun || !zona || !dir || !cp) {
      Alert.alert('Error', 'Completa todos los campos obligatorios.');
      return;
    }
    try {
      const datos = {
        tipodocumento: tipoDoc, numdocumento: numDoc, nit: nit || ' ',
        primer_nombre: primerNombre, segundo_nombre: segundoNombre || ' ',
        primer_apellido: primerApellido, segundo_apellido: segundoApellido || ' ',
        email, primer_telefono: tel1, segundo_telefono: tel2 || ' ',
        pais, departamento: dep, municipio: mun, zona, direccion: dir,
        codigo_postal: cp, tipocliente: tipoCliente, profesion: profesion || ' ',
      };
      if (editando) {
        await actualizarCliente({ ...datos, cli_cliente: editando.cli_cliente });
        Alert.alert('✅', 'Cliente actualizado.');
      } else {
        if (!password) { Alert.alert('Error', 'La contraseña es obligatoria.'); return; }
        await crearCliente({ ...datos, password });
        Alert.alert('✅', 'Cliente creado.');
      }
      setModalVisible(false);
      cargar();
    } catch {
      Alert.alert('Error', 'No se pudo guardar.');
    }
  };

  const eliminar = (cli: any) => {
    Alert.alert('Eliminar', `¿Eliminar a ${cli.cli_primer_nombre}?`, [
      { text: 'Cancelar', style: 'cancel' },
      {
        text: 'Eliminar', style: 'destructive', onPress: async () => {
          await eliminarCliente({ cli_cliente: cli.cli_cliente });
          cargar();
        }
      },
    ]);
  };

  const filtrados = clientes.filter(c =>
    `${c.cli_primer_nombre} ${c.cli_primer_apellido} ${c.cli_email}`.toLowerCase().includes(busqueda.toLowerCase())
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>🛒 Clientes</Text>
        <TouchableOpacity onPress={() => abrirModal()}>
          <Text style={styles.addBtn}>+ Nuevo</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.searchBox}>
        <TextInput
          style={styles.searchInput}
          placeholder="Buscar por nombre o email..."
          value={busqueda}
          onChangeText={setBusqueda}
        />
      </View>

      {loading ? <ActivityIndicator size="large" color={GOLD} style={{ marginTop: 40 }} /> : (
        <ScrollView contentContainerStyle={styles.list}>
          {filtrados.map((c, i) => (
            <View key={i} style={styles.card}>
              <Text style={styles.cardNombre}>{c.cli_primer_nombre} {c.cli_primer_apellido}</Text>
              <Text style={styles.cardEmail}>{c.cli_email}</Text>
              <Text style={styles.cardTipo}>{c.cli_tipocliente} — {c.cli_pais}</Text>
              <View style={styles.actions}>
                <TouchableOpacity style={styles.btnEdit} onPress={() => abrirModal(c)}>
                  <Text style={styles.btnEditText}>✏️ Editar</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.btnDel} onPress={() => eliminar(c)}>
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
              <Text style={styles.modalTitle}>{editando ? 'Editar Cliente' : 'Nuevo Cliente'}</Text>

              <Text style={styles.label}>Tipo Cliente</Text>
              <View style={styles.tipoRow}>
                {['NATURAL', 'JURIDICA'].map(t => (
                  <TouchableOpacity key={t}
                    style={[styles.tipoBtn, tipoCliente === t && styles.tipoBtnActive]}
                    onPress={() => setTipoCliente(t)}>
                    <Text style={[styles.tipoBtnText, tipoCliente === t && styles.tipoBtnTextActive]}>{t}</Text>
                  </TouchableOpacity>
                ))}
              </View>

              <Text style={styles.label}>Tipo Documento</Text>
              <View style={styles.tipoRow}>
                {['DPI', 'Pasaporte', 'NIT'].map(t => (
                  <TouchableOpacity key={t}
                    style={[styles.tipoBtn, tipoDoc === t && styles.tipoBtnActive]}
                    onPress={() => setTipoDoc(t)}>
                    <Text style={[styles.tipoBtnText, tipoDoc === t && styles.tipoBtnTextActive]}>{t}</Text>
                  </TouchableOpacity>
                ))}
              </View>

              <Text style={styles.label}>Número Documento *</Text>
              <TextInput style={styles.input} value={numDoc} onChangeText={setNumDoc} placeholder="1234567890101" keyboardType="numeric" />

              {tipoCliente === 'JURIDICA' && (
                <>
                  <Text style={styles.label}>NIT</Text>
                  <TextInput style={styles.input} value={nit} onChangeText={setNit} placeholder="12345678-9" />
                </>
              )}

              <Text style={styles.label}>Primer Nombre *</Text>
              <TextInput style={styles.input} value={primerNombre} onChangeText={setPrimerNombre} placeholder="Nombre..." />

              <Text style={styles.label}>Segundo Nombre</Text>
              <TextInput style={styles.input} value={segundoNombre} onChangeText={setSegundoNombre} placeholder="Opcional..." />

              <Text style={styles.label}>Primer Apellido *</Text>
              <TextInput style={styles.input} value={primerApellido} onChangeText={setPrimerApellido} placeholder="Apellido..." />

              <Text style={styles.label}>Segundo Apellido</Text>
              <TextInput style={styles.input} value={segundoApellido} onChangeText={setSegundoApellido} placeholder="Opcional..." />

              <Text style={styles.label}>Email * (será su usuario)</Text>
              <TextInput style={styles.input} value={email} onChangeText={setEmail} placeholder="correo@email.com" keyboardType="email-address" autoCapitalize="none" />

              {!editando && (
                <>
                  <Text style={styles.label}>Contraseña *</Text>
                  <TextInput style={styles.input} value={password} onChangeText={setPassword} placeholder="Mín. 8 caracteres..." secureTextEntry />
                </>
              )}

              <Text style={styles.label}>Teléfono Principal *</Text>
              <TextInput style={styles.input} value={tel1} onChangeText={setTel1} placeholder="55551234" keyboardType="numeric" />

              <Text style={styles.label}>Teléfono Secundario</Text>
              <TextInput style={styles.input} value={tel2} onChangeText={setTel2} placeholder="Opcional..." keyboardType="numeric" />

              <Text style={styles.label}>Departamento *</Text>
              <TextInput style={styles.input} value={dep} onChangeText={setDep} placeholder="Guatemala..." />

              <Text style={styles.label}>Municipio *</Text>
              <TextInput style={styles.input} value={mun} onChangeText={setMun} placeholder="Guatemala..." />

              <Text style={styles.label}>Zona *</Text>
              <TextInput style={styles.input} value={zona} onChangeText={setZona} placeholder="Zona 1..." />

              <Text style={styles.label}>Dirección *</Text>
              <TextInput style={styles.input} value={dir} onChangeText={setDir} placeholder="1 Calle 1-23..." />

              <Text style={styles.label}>Código Postal *</Text>
              <TextInput style={styles.input} value={cp} onChangeText={setCp} placeholder="01001..." keyboardType="numeric" />

              <Text style={styles.label}>Profesión</Text>
              <TextInput style={styles.input} value={profesion} onChangeText={setProfesion} placeholder="Opcional..." />

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
  cardEmail: { fontSize: 13, color: '#6b7280', marginBottom: 2 },
  cardTipo: { fontSize: 13, color: GOLD, fontWeight: 'bold', marginBottom: 12 },
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
  tipoRow: { flexDirection: 'row', gap: 8, marginBottom: 16 },
  tipoBtn: { flex: 1, padding: 10, borderRadius: 8, borderWidth: 1.5, borderColor: '#e8d8c0', alignItems: 'center' },
  tipoBtnActive: { backgroundColor: GOLD, borderColor: GOLD },
  tipoBtnText: { fontSize: 12, fontWeight: 'bold', color: '#888' },
  tipoBtnTextActive: { color: '#1a1a1a' },
  modalActions: { flexDirection: 'row', gap: 12, marginTop: 8 },
  btnCancel: { flex: 1, backgroundColor: '#f3f4f6', padding: 12, borderRadius: 8, alignItems: 'center' },
  btnCancelText: { color: '#374151', fontWeight: 'bold' },
  btnSave: { flex: 1, backgroundColor: GOLD, padding: 12, borderRadius: 8, alignItems: 'center' },
  btnSaveText: { color: '#1a1a1a', fontWeight: 'bold' },
});