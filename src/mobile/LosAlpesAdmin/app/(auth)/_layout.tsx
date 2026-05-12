import { router } from 'expo-router';
import React, { useState } from 'react';
import {
    ActivityIndicator, Alert, KeyboardAvoidingView,
    Platform, ScrollView, StyleSheet, Text, TextInput,
    TouchableOpacity, View
} from 'react-native';
import { useAuth } from '../../context/AuthContext';
import { loginCliente } from '../../services/authUsuarios/loginCliente';
import { loginEmpleado } from '../../services/authUsuarios/loginEmpleado';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function LoginScreen() {
  const { login } = useAuth();
  const [tipoUsuario, setTipoUsuario] = useState<'empleado' | 'cliente'>('empleado');
  const [tabCliente, setTabCliente] = useState<'login' | 'registro'>('login');
  const [loading, setLoading] = useState(false);

  // Login empleado
  const [dpi, setDpi] = useState('');
  const [passEmp, setPassEmp] = useState('');

  // Login cliente
  const [email, setEmail] = useState('');
  const [passCli, setPassCli] = useState('');

  // Registro cliente
  const [regNombre, setRegNombre] = useState('');
  const [regApellido, setRegApellido] = useState('');
  const [regEmail, setRegEmail] = useState('');
  const [regPassword, setRegPassword] = useState('');
  const [regConfirm, setRegConfirm] = useState('');
  const [regTipoDoc, setRegTipoDoc] = useState('DPI');
  const [regNumDoc, setRegNumDoc] = useState('');
  const [regTel, setRegTel] = useState('');
  const [regPais, setRegPais] = useState('Guatemala');
  const [regDep, setRegDep] = useState('');
  const [regMun, setRegMun] = useState('');
  const [regZona, setRegZona] = useState('');
  const [regDir, setRegDir] = useState('');
  const [regCP, setRegCP] = useState('');

  const handleLoginEmpleado = async () => {
    if (!dpi || !passEmp) {
      Alert.alert('Error', 'DPI y contraseña son obligatorios.');
      return;
    }
    setLoading(true);
    try {
      const res = await loginEmpleado(dpi, passEmp);
      if (res.ok) {
        await login({
          id: res.em_empleado,
          nombre: res.nombre,
          grupo: res.grupo,
          tipo: 'EMPLEADO',
          permisos: res.permisos,
        });
        router.replace('/');
      } else {
        Alert.alert('Error', res.mensaje || 'Credenciales incorrectas.');
      }
    } catch {
      Alert.alert('Error', 'No se pudo conectar al servidor.');
    } finally {
      setLoading(false);
    }
  };

  const handleLoginCliente = async () => {
    if (!email || !passCli) {
      Alert.alert('Error', 'Email y contraseña son obligatorios.');
      return;
    }
    setLoading(true);
    try {
      const res = await loginCliente(email, passCli);
      if (res.ok) {
        await login({
          id: res.cli_cliente,
          nombre: res.nombre,
          grupo: 0,
          tipo: 'CLIENTE',
        });
        router.replace('/');
      } else {
        Alert.alert('Error', res.mensaje || 'Credenciales incorrectas.');
      }
    } catch {
      Alert.alert('Error', 'No se pudo conectar al servidor.');
    } finally {
      setLoading(false);
    }
  };

  const handleRegistro = async () => {
    if (!regNombre || !regApellido || !regEmail || !regPassword || !regNumDoc || !regTel || !regDep || !regMun || !regZona || !regDir || !regCP) {
      Alert.alert('Error', 'Completa todos los campos obligatorios.');
      return;
    }
    if (regPassword !== regConfirm) {
      Alert.alert('Error', 'Las contraseñas no coinciden.');
      return;
    }
    if (regPassword.length < 8) {
      Alert.alert('Error', 'La contraseña debe tener mínimo 8 caracteres.');
      return;
    }
    setLoading(true);
    try {
      const { registroCliente } = await import('../../services/authUsuarios/loginCliente');
      const res = await registroCliente({
        tipodocumento: regTipoDoc,
        numdocumento: regNumDoc,
        primer_nombre: regNombre,
        primer_apellido: regApellido,
        email: regEmail,
        primer_telefono: regTel,
        pais: regPais,
        departamento: regDep,
        municipio: regMun,
        zona: regZona,
        direccion: regDir,
        codigo_postal: regCP,
        tipocliente: 'NATURAL',
        password: regPassword,
      });
      if (res.ok) {
        Alert.alert('✅ Cuenta creada', 'Ya puedes iniciar sesión.', [
          { text: 'OK', onPress: () => setTabCliente('login') }
        ]);
      } else {
        Alert.alert('Error', res.mensaje);
      }
    } catch {
      Alert.alert('Error', 'No se pudo conectar al servidor.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <ScrollView showsVerticalScrollIndicator={false}>
        <View style={styles.card}>
          <Text style={styles.logo}>🪑</Text>
          <Text style={styles.title}>Muebles Los Alpes</Text>
          <Text style={styles.subtitle}>Inicia sesión para continuar</Text>

          {/* Tabs empleado/cliente */}
          <View style={styles.tipoTabs}>
            <TouchableOpacity
              style={[styles.tipoTab, tipoUsuario === 'empleado' && styles.tipoTabActive]}
              onPress={() => setTipoUsuario('empleado')}>
              <Text style={[styles.tipoTabText, tipoUsuario === 'empleado' && styles.tipoTabTextActive]}>
                👨‍💼 Empleado
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.tipoTab, tipoUsuario === 'cliente' && styles.tipoTabActive]}
              onPress={() => setTipoUsuario('cliente')}>
              <Text style={[styles.tipoTabText, tipoUsuario === 'cliente' && styles.tipoTabTextActive]}>
                🛒 Cliente
              </Text>
            </TouchableOpacity>
          </View>

          {/* LOGIN EMPLEADO */}
          {tipoUsuario === 'empleado' && (
            <View>
              <Text style={styles.label}>👤 Usuario (DPI)</Text>
              <TextInput
                style={styles.input}
                placeholder="Tu DPI de 13 dígitos..."
                value={dpi}
                onChangeText={setDpi}
                keyboardType="numeric"
                autoCorrect={false}
              />
              <Text style={styles.label}>🔑 Contraseña</Text>
              <TextInput
                style={styles.input}
                placeholder="Tu contraseña..."
                value={passEmp}
                onChangeText={setPassEmp}
                secureTextEntry
              />
              <TouchableOpacity style={styles.btnLogin} onPress={handleLoginEmpleado} disabled={loading}>
                {loading ? <ActivityIndicator color="#1a1a1a" /> : <Text style={styles.btnLoginText}>🔑 Ingresar</Text>}
              </TouchableOpacity>
            </View>
          )}

          {/* LOGIN / REGISTRO CLIENTE */}
          {tipoUsuario === 'cliente' && (
            <View>
              <View style={styles.tabs}>
                <TouchableOpacity
                  style={[styles.tab, tabCliente === 'login' && styles.tabActive]}
                  onPress={() => setTabCliente('login')}>
                  <Text style={[styles.tabText, tabCliente === 'login' && styles.tabTextActive]}>🔑 Iniciar Sesión</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={[styles.tab, tabCliente === 'registro' && styles.tabActive]}
                  onPress={() => setTabCliente('registro')}>
                  <Text style={[styles.tabText, tabCliente === 'registro' && styles.tabTextActive]}>✨ Crear Cuenta</Text>
                </TouchableOpacity>
              </View>

              {tabCliente === 'login' && (
                <View>
                  <Text style={styles.label}>📧 Email</Text>
                  <TextInput style={styles.input} placeholder="tucorreo@email.com" value={email} onChangeText={setEmail} keyboardType="email-address" autoCorrect={false} autoCapitalize="none" />
                  <Text style={styles.label}>🔑 Contraseña</Text>
                  <TextInput style={styles.input} placeholder="Tu contraseña..." value={passCli} onChangeText={setPassCli} secureTextEntry />
                  <TouchableOpacity style={styles.btnLogin} onPress={handleLoginCliente} disabled={loading}>
                    {loading ? <ActivityIndicator color="#1a1a1a" /> : <Text style={styles.btnLoginText}>🔑 Ingresar</Text>}
                  </TouchableOpacity>
                </View>
              )}

              {tabCliente === 'registro' && (
                <View>
                  <Text style={styles.label}>📄 Tipo Documento *</Text>
                  <View style={styles.tipoDocRow}>
                    {['DPI', 'Pasaporte', 'NIT'].map(t => (
                      <TouchableOpacity
                        key={t}
                        style={[styles.tipoDocBtn, regTipoDoc === t && styles.tipoDocBtnActive]}
                        onPress={() => setRegTipoDoc(t)}>
                        <Text style={[styles.tipoDocText, regTipoDoc === t && styles.tipoDocTextActive]}>{t}</Text>
                      </TouchableOpacity>
                    ))}
                  </View>
                  <Text style={styles.label}>🔢 Número Documento *</Text>
                  <TextInput style={styles.input} placeholder="1234567890101" value={regNumDoc} onChangeText={setRegNumDoc} keyboardType="numeric" />
                  <Text style={styles.label}>👤 Primer Nombre *</Text>
                  <TextInput style={styles.input} placeholder="Tu nombre..." value={regNombre} onChangeText={setRegNombre} />
                  <Text style={styles.label}>👤 Primer Apellido *</Text>
                  <TextInput style={styles.input} placeholder="Tu apellido..." value={regApellido} onChangeText={setRegApellido} />
                  <Text style={styles.label}>📧 Email * (será tu usuario)</Text>
                  <TextInput style={styles.input} placeholder="tucorreo@email.com" value={regEmail} onChangeText={setRegEmail} keyboardType="email-address" autoCorrect={false} autoCapitalize="none" />
                  <Text style={styles.label}>🔑 Contraseña * (mín. 8 caracteres)</Text>
                  <TextInput style={styles.input} placeholder="Crea tu contraseña..." value={regPassword} onChangeText={setRegPassword} secureTextEntry />
                  <Text style={styles.label}>🔑 Confirmar Contraseña *</Text>
                  <TextInput style={styles.input} placeholder="Repite tu contraseña..." value={regConfirm} onChangeText={setRegConfirm} secureTextEntry />
                  <Text style={styles.label}>📱 Teléfono *</Text>
                  <TextInput style={styles.input} placeholder="55551234" value={regTel} onChangeText={setRegTel} keyboardType="numeric" maxLength={8} />
                  <Text style={styles.label}>🗺️ Departamento *</Text>
                  <TextInput style={styles.input} placeholder="Guatemala..." value={regDep} onChangeText={setRegDep} />
                  <Text style={styles.label}>🏙️ Municipio *</Text>
                  <TextInput style={styles.input} placeholder="Guatemala..." value={regMun} onChangeText={setRegMun} />
                  <Text style={styles.label}>🏘️ Zona *</Text>
                  <TextInput style={styles.input} placeholder="Zona 1..." value={regZona} onChangeText={setRegZona} />
                  <Text style={styles.label}>📍 Dirección *</Text>
                  <TextInput style={styles.input} placeholder="1 Calle 1-23..." value={regDir} onChangeText={setRegDir} />
                  <Text style={styles.label}>📮 Código Postal *</Text>
                  <TextInput style={styles.input} placeholder="01001..." value={regCP} onChangeText={setRegCP} keyboardType="numeric" />
                  <TouchableOpacity style={styles.btnLogin} onPress={handleRegistro} disabled={loading}>
                    {loading ? <ActivityIndicator color="#1a1a1a" /> : <Text style={styles.btnLoginText}>✅ Crear mi cuenta</Text>}
                  </TouchableOpacity>
                </View>
              )}
            </View>
          )}
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0', padding: 20 },
  card: { backgroundColor: 'white', borderRadius: 16, padding: 28, elevation: 4, marginVertical: 20 },
  logo: { fontSize: 52, textAlign: 'center', marginBottom: 10 },
  title: { fontSize: 22, fontWeight: 'bold', color: CAFE, textAlign: 'center' },
  subtitle: { fontSize: 13, color: '#8B5E3C', textAlign: 'center', marginBottom: 20 },
  tipoTabs: { flexDirection: 'row', marginBottom: 20, borderRadius: 10, overflow: 'hidden', borderWidth: 1.5, borderColor: '#e8d8c0' },
  tipoTab: { flex: 1, padding: 12, alignItems: 'center', backgroundColor: '#fafafa' },
  tipoTabActive: { backgroundColor: CAFE },
  tipoTabText: { fontSize: 13, fontWeight: 'bold', color: '#888' },
  tipoTabTextActive: { color: '#f0d9a0' },
  tabs: { flexDirection: 'row', borderBottomWidth: 2, borderBottomColor: '#f0e8d8', marginBottom: 20 },
  tab: { flex: 1, paddingVertical: 12, alignItems: 'center' },
  tabActive: { borderBottomWidth: 3, borderBottomColor: GOLD },
  tabText: { fontSize: 13, fontWeight: 'bold', color: '#bbb' },
  tabTextActive: { color: CAFE },
  label: { fontSize: 12, fontWeight: 'bold', color: CAFE, marginBottom: 6 },
  input: { borderWidth: 1.5, borderColor: '#e8d8c0', borderRadius: 10, padding: 12, fontSize: 13, marginBottom: 16, backgroundColor: '#fafafa' },
  btnLogin: { backgroundColor: GOLD, padding: 14, borderRadius: 10, alignItems: 'center', marginTop: 4, marginBottom: 16 },
  btnLoginText: { fontWeight: 'bold', fontSize: 14, color: '#1a1a1a' },
  tipoDocRow: { flexDirection: 'row', gap: 8, marginBottom: 16 },
  tipoDocBtn: { flex: 1, padding: 10, borderRadius: 8, borderWidth: 1.5, borderColor: '#e8d8c0', alignItems: 'center' },
  tipoDocBtnActive: { backgroundColor: GOLD, borderColor: GOLD },
  tipoDocText: { fontSize: 12, fontWeight: 'bold', color: '#888' },
  tipoDocTextActive: { color: '#1a1a1a' },
});