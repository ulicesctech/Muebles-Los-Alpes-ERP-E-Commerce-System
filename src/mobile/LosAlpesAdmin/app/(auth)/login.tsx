import { router } from 'expo-router';
import React, { useState } from 'react';
import {
  ActivityIndicator, Alert, KeyboardAvoidingView,
  Platform, ScrollView, StyleSheet, Text, TextInput,
  TouchableOpacity, View
} from 'react-native';
import { useAuth } from '../../context/AuthContext';
import { loginCliente } from '../services/authUsuarios/loginCliente';
import { loginEmpleado } from '../services/authUsuarios/loginEmpleado';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function LoginScreen() {
  const { login } = useAuth();
  const [tipo, setTipo] = useState<'empleado' | 'cliente'>('empleado');
  const [loading, setLoading] = useState(false);

  // Empleado
  const [dpi, setDpi] = useState('');
  const [passEmp, setPassEmp] = useState('');

  // Cliente
  const [email, setEmail] = useState('');
  const [passCli, setPassCli] = useState('');

  // Registro cliente
  const [tabCliente, setTabCliente] = useState<'login' | 'registro'>('login');
  const [regNombre, setRegNombre] = useState('');
  const [regApellido, setRegApellido] = useState('');
  const [regEmail, setRegEmail] = useState('');
  const [regPassword, setRegPassword] = useState('');
  const [regConfirm, setRegConfirm] = useState('');
  const [regTipoDoc, setRegTipoDoc] = useState('DPI');
  const [regNumDoc, setRegNumDoc] = useState('');
  const [regTel, setRegTel] = useState('');
  const [regDep, setRegDep] = useState('');
  const [regMun, setRegMun] = useState('');
  const [regZona, setRegZona] = useState('');
  const [regDir, setRegDir] = useState('');
  const [regCP, setRegCP] = useState('');

  const handleLoginEmpleado = async () => {
    if (!dpi || !passEmp) { Alert.alert('Error', 'Completa todos los campos.'); return; }
    setLoading(true);
    try {
      const res = await loginEmpleado(dpi, passEmp);
      if (res.ok) {
        await login({ id: res.em_empleado, nombre: res.nombre, grupo: res.grupo, tipo: 'EMPLEADO', permisos: res.permisos });
        router.replace('/');
      } else {
        Alert.alert('Error', res.mensaje || 'Credenciales incorrectas.');
      }
    } catch {
      Alert.alert('Error', 'No se pudo conectar al servidor.');
    } finally { setLoading(false); }
  };

  const handleLoginCliente = async () => {
    if (!email || !passCli) { Alert.alert('Error', 'Completa todos los campos.'); return; }
    setLoading(true);
    try {
      const res = await loginCliente(email, passCli);
      if (res.ok) {
        await login({ id: res.cli_cliente, nombre: res.nombre, grupo: 0, tipo: 'CLIENTE' });
        router.replace('/');
      } else {
        Alert.alert('Error', res.mensaje || 'Credenciales incorrectas.');
      }
    } catch {
      Alert.alert('Error', 'No se pudo conectar al servidor.');
    } finally { setLoading(false); }
  };

  const handleRegistro = async () => {
    if (!regNombre || !regApellido || !regEmail || !regPassword || !regNumDoc || !regTel || !regDep || !regMun || !regZona || !regDir || !regCP) {
      Alert.alert('Error', 'Completa todos los campos.');
      return;
    }
    if (regPassword !== regConfirm) { Alert.alert('Error', 'Las contraseñas no coinciden.'); return; }
    setLoading(true);
    try {
      const { registroCliente } = await import('../services/authUsuarios/loginCliente');
      const res = await registroCliente({
        tipodocumento: regTipoDoc, numdocumento: regNumDoc,
        primer_nombre: regNombre, primer_apellido: regApellido,
        email: regEmail, primer_telefono: regTel,
        pais: 'Guatemala', departamento: regDep, municipio: regMun,
        zona: regZona, direccion: regDir, codigo_postal: regCP,
        tipocliente: 'NATURAL', password: regPassword,
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
    } finally { setLoading(false); }
  };

  return (
    <KeyboardAvoidingView style={styles.container} behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scroll}>

        {/* TABS TIPO */}
        <View style={styles.tipoTabs}>
          <TouchableOpacity
            style={[styles.tipoTab, tipo === 'empleado' && styles.tipoTabActive]}
            onPress={() => setTipo('empleado')}>
            <Text style={[styles.tipoTabText, tipo === 'empleado' && styles.tipoTabTextActive]}>👨‍💼 Empleado</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.tipoTab, tipo === 'cliente' && styles.tipoTabActive]}
            onPress={() => setTipo('cliente')}>
            <Text style={[styles.tipoTabText, tipo === 'cliente' && styles.tipoTabTextActive]}>🛒 Cliente</Text>
          </TouchableOpacity>
        </View>

        {/* LOGIN EMPLEADO */}
        {tipo === 'empleado' && (
          <View style={styles.card}>
            <View style={styles.cardHead}>
              <Text style={styles.cardLogo}>🪑</Text>
              <Text style={styles.cardTitle}>Muebles Los Alpes</Text>
              <Text style={styles.cardSub}>Inicia sesión en tu cuenta</Text>
            </View>
            <View style={styles.cardBody}>
              <Text style={styles.label}>USUARIO (DPI)</Text>
              <TextInput style={styles.input} placeholder="Tu DPI de 13 dígitos" value={dpi} onChangeText={setDpi} keyboardType="numeric" autoCorrect={false} />
              <Text style={styles.label}>CONTRASEÑA</Text>
              <TextInput style={styles.input} placeholder="Tu contraseña" value={passEmp} onChangeText={setPassEmp} secureTextEntry />
              <TouchableOpacity style={styles.btnLogin} onPress={handleLoginEmpleado} disabled={loading}>
                {loading ? <ActivityIndicator color="white" /> : <Text style={styles.btnLoginText}>Iniciar Sesión</Text>}
              </TouchableOpacity>
            </View>
          </View>
        )}

        {/* LOGIN / REGISTRO CLIENTE */}
        {tipo === 'cliente' && (
          <View style={styles.card}>
            <View style={styles.cardHead}>
              <Text style={styles.cardLogo}>🛋️</Text>
              <Text style={styles.cardTitle}>Muebles Los Alpes</Text>
              <Text style={styles.cardSub}>
                {tabCliente === 'login' ? 'Inicia sesión en tu cuenta' : 'Crea tu cuenta'}
              </Text>
            </View>

            <View style={styles.tabs}>
              <TouchableOpacity style={[styles.tab, tabCliente === 'login' && styles.tabActive]} onPress={() => setTabCliente('login')}>
                <Text style={[styles.tabText, tabCliente === 'login' && styles.tabTextActive]}>🔑 Iniciar Sesión</Text>
              </TouchableOpacity>
              <TouchableOpacity style={[styles.tab, tabCliente === 'registro' && styles.tabActive]} onPress={() => setTabCliente('registro')}>
                <Text style={[styles.tabText, tabCliente === 'registro' && styles.tabTextActive]}>✨ Registrarse</Text>
              </TouchableOpacity>
            </View>

            {tabCliente === 'login' && (
              <View style={styles.cardBody}>
                <Text style={styles.label}>USUARIO O EMAIL</Text>
                <TextInput style={styles.input} placeholder="Tu usuario o email" value={email} onChangeText={setEmail} keyboardType="email-address" autoCapitalize="none" autoCorrect={false} />
                <Text style={styles.label}>CONTRASEÑA</Text>
                <TextInput style={styles.input} placeholder="Tu contraseña" value={passCli} onChangeText={setPassCli} secureTextEntry />
                <TouchableOpacity style={styles.btnLogin} onPress={handleLoginCliente} disabled={loading}>
                  {loading ? <ActivityIndicator color="white" /> : <Text style={styles.btnLoginText}>Iniciar Sesión</Text>}
                </TouchableOpacity>
              </View>
            )}

            {tabCliente === 'registro' && (
              <View style={styles.cardBody}>
                <Text style={styles.label}>TIPO DOCUMENTO</Text>
                <View style={styles.tipoDocRow}>
                  {['DPI', 'Pasaporte', 'NIT'].map(t => (
                    <TouchableOpacity key={t} style={[styles.tipoDocBtn, regTipoDoc === t && styles.tipoDocBtnActive]} onPress={() => setRegTipoDoc(t)}>
                      <Text style={[styles.tipoDocText, regTipoDoc === t && styles.tipoDocTextActive]}>{t}</Text>
                    </TouchableOpacity>
                  ))}
                </View>
                <Text style={styles.label}>NÚMERO DOCUMENTO *</Text>
                <TextInput style={styles.input} placeholder="1234567890101" value={regNumDoc} onChangeText={setRegNumDoc} keyboardType="numeric" />
                <Text style={styles.label}>PRIMER NOMBRE *</Text>
                <TextInput style={styles.input} placeholder="Tu nombre" value={regNombre} onChangeText={setRegNombre} />
                <Text style={styles.label}>PRIMER APELLIDO *</Text>
                <TextInput style={styles.input} placeholder="Tu apellido" value={regApellido} onChangeText={setRegApellido} />
                <Text style={styles.label}>EMAIL * (será tu usuario)</Text>
                <TextInput style={styles.input} placeholder="tucorreo@email.com" value={regEmail} onChangeText={setRegEmail} keyboardType="email-address" autoCapitalize="none" />
                <Text style={styles.label}>CONTRASEÑA *</Text>
                <TextInput style={styles.input} placeholder="Mín. 8 caracteres" value={regPassword} onChangeText={setRegPassword} secureTextEntry />
                <Text style={styles.label}>CONFIRMAR CONTRASEÑA *</Text>
                <TextInput style={styles.input} placeholder="Repite tu contraseña" value={regConfirm} onChangeText={setRegConfirm} secureTextEntry />
                <Text style={styles.label}>TELÉFONO *</Text>
                <TextInput style={styles.input} placeholder="55551234" value={regTel} onChangeText={setRegTel} keyboardType="numeric" maxLength={8} />
                <Text style={styles.label}>DEPARTAMENTO *</Text>
                <TextInput style={styles.input} placeholder="Guatemala" value={regDep} onChangeText={setRegDep} />
                <Text style={styles.label}>MUNICIPIO *</Text>
                <TextInput style={styles.input} placeholder="Guatemala" value={regMun} onChangeText={setRegMun} />
                <Text style={styles.label}>ZONA *</Text>
                <TextInput style={styles.input} placeholder="Zona 1" value={regZona} onChangeText={setRegZona} />
                <Text style={styles.label}>DIRECCIÓN *</Text>
                <TextInput style={styles.input} placeholder="1 Calle 1-23" value={regDir} onChangeText={setRegDir} />
                <Text style={styles.label}>CÓDIGO POSTAL *</Text>
                <TextInput style={styles.input} placeholder="01001" value={regCP} onChangeText={setRegCP} keyboardType="numeric" />
                <TouchableOpacity style={styles.btnLogin} onPress={handleRegistro} disabled={loading}>
                  {loading ? <ActivityIndicator color="white" /> : <Text style={styles.btnLoginText}>Crear mi cuenta</Text>}
                </TouchableOpacity>
              </View>
            )}

            <View style={styles.cardFooter}>
              {tabCliente === 'login'
                ? <Text style={styles.footerText}>¿No tienes cuenta? <Text style={styles.footerLink} onPress={() => setTabCliente('registro')}>Regístrate aquí</Text></Text>
                : <Text style={styles.footerText}>¿Ya tienes cuenta? <Text style={styles.footerLink} onPress={() => setTabCliente('login')}>Inicia sesión</Text></Text>
              }
            </View>
          </View>
        )}
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0' },
  scroll: { padding: 20, paddingBottom: 40 },
  tipoTabs: { flexDirection: 'row', borderRadius: 10, overflow: 'hidden', borderWidth: 1.5, borderColor: '#e8d8c0', marginBottom: 20 },
  tipoTab: { flex: 1, padding: 12, alignItems: 'center', backgroundColor: '#fafafa' },
  tipoTabActive: { backgroundColor: CAFE },
  tipoTabText: { fontSize: 13, fontWeight: 'bold', color: '#888' },
  tipoTabTextActive: { color: '#f0d9a0' },
  card: { backgroundColor: 'white', borderRadius: 16, borderWidth: 1, borderColor: '#e8d8c0', overflow: 'hidden', elevation: 4 },
  cardHead: { background: CAFE, backgroundColor: CAFE, padding: 30, alignItems: 'center' },
  cardLogo: { fontSize: 48, marginBottom: 8 },
  cardTitle: { color: '#f0d9a0', fontSize: 20, fontWeight: 'bold', fontFamily: 'serif' },
  cardSub: { color: '#d4b896', fontSize: 13, marginTop: 4 },
  tabs: { flexDirection: 'row', borderBottomWidth: 1, borderBottomColor: '#f5ece0' },
  tab: { flex: 1, paddingVertical: 14, alignItems: 'center' },
  tabActive: { borderBottomWidth: 3, borderBottomColor: GOLD },
  tabText: { fontSize: 13, fontWeight: 'bold', color: '#bbb' },
  tabTextActive: { color: CAFE },
  cardBody: { padding: 24 },
  label: { fontSize: 11, fontWeight: 'bold', color: CAFE, letterSpacing: 0.5, marginBottom: 6, textTransform: 'uppercase' },
  input: { borderWidth: 2, borderColor: '#e8d8c0', borderRadius: 8, padding: 12, fontSize: 14, marginBottom: 16, backgroundColor: '#fdf8f3', fontFamily: 'sans-serif' },
  btnLogin: { backgroundColor: CAFE, padding: 14, borderRadius: 8, alignItems: 'center', marginTop: 4 },
  btnLoginText: { color: 'white', fontWeight: 'bold', fontSize: 15 },
  cardFooter: { padding: 16, borderTopWidth: 1, borderTopColor: '#f5ece0', alignItems: 'center' },
  footerText: { fontSize: 13, color: '#888' },
  footerLink: { color: GOLD, fontWeight: 'bold' },
  tipoDocRow: { flexDirection: 'row', gap: 8, marginBottom: 16 },
  tipoDocBtn: { flex: 1, padding: 10, borderRadius: 8, borderWidth: 1.5, borderColor: '#e8d8c0', alignItems: 'center' },
  tipoDocBtnActive: { backgroundColor: GOLD, borderColor: GOLD },
  tipoDocText: { fontSize: 12, fontWeight: 'bold', color: '#888' },
  tipoDocTextActive: { color: '#1a1a1a' },
});