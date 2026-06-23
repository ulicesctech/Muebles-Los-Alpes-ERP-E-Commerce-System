import { router } from 'expo-router';
import React from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useAuth } from '../../../context/AuthContext';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function AuthUsuariosIndex() {
  const { usuario } = useAuth();

  const tienePermiso = (permiso: string) => {
    if (!usuario?.permisos) return false;
    return usuario.permisos[permiso as keyof typeof usuario.permisos] === 1;
  };

  const opciones = [
    { title: 'Gestión de Empleados', route: '/modules/authUsuarios/empleados', icon: '👥', permiso: 'rh' },
    { title: 'Puestos y Cargos', route: '/modules/authUsuarios/puestos', icon: '🎖️', permiso: 'rh' },
    { title: 'Control de Ascensos', route: '/modules/authUsuarios/ascensos', icon: '📈', permiso: 'rh' },
    { title: 'Listado de Clientes', route: '/modules/authUsuarios/clientes', icon: '👤', permiso: 'cli' },
    { title: 'Grupos de Usuario', route: '/modules/authUsuarios/admin/grupoUsuario', icon: '🛡️', permiso: 'admin' },
    { title: 'Permisos de Sistema', route: '/modules/authUsuarios/admin/permisos', icon: '🔑', permiso: 'admin' },
  ];

  const opcionesFiltradas = opciones.filter(op => tienePermiso(op.permiso));

  return (
    <ScrollView style={styles.container}>
      <View style={styles.headerArea}>
        <Text style={styles.title}>Seguridad y Personal</Text>
        <Text style={styles.subtitle}>Control de acceso y administración de RR.HH.</Text>
      </View>

      {opcionesFiltradas.length === 0 ? (
        <View style={styles.sinPermisos}>
          <Text style={styles.sinPermisosIco}>🔒</Text>
          <Text style={styles.sinPermisosText}>No tienes permisos para este módulo.</Text>
        </View>
      ) : (
        <View style={styles.grid}>
          {opcionesFiltradas.map((item, index) => (
            <TouchableOpacity key={index} style={styles.card} onPress={() => router.push(item.route as any)}>
              <Text style={styles.icon}>{item.icon}</Text>
              <Text style={styles.cardTitle}>{item.title}</Text>
            </TouchableOpacity>
          ))}
        </View>
      )}

      <View style={styles.securityBox}>
        <Text style={styles.securityTitle}>Estado del Sistema</Text>
        <View style={styles.securityItem}>
          <Text style={styles.securityText}>👤 {usuario?.nombre}</Text>
          <Text style={styles.securityText}>🔐 {usuario?.tipo === 'EMPLEADO' ? 'Empleado' : 'Cliente'}</Text>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff', borderRadius: 12, padding: 15 },
  headerArea: { marginBottom: 20, borderBottomWidth: 1, borderBottomColor: '#e0d0b8', paddingBottom: 10 },
  title: { fontSize: 20, fontWeight: 'bold', color: '#3a1f0a' },
  subtitle: { fontSize: 14, color: '#7a4f2a' },
  grid: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'space-between' },
  card: { width: '48%', backgroundColor: '#fdf6ec', padding: 20, borderRadius: 12, marginBottom: 15, alignItems: 'center', borderWidth: 1, borderColor: '#e0d0b8', elevation: 2 },
  icon: { fontSize: 30, marginBottom: 8 },
  cardTitle: { fontSize: 14, fontWeight: 'bold', color: CAFE, textAlign: 'center' },
  sinPermisos: { alignItems: 'center', padding: 40 },
  sinPermisosIco: { fontSize: 48, marginBottom: 12 },
  sinPermisosText: { fontSize: 14, color: '#888', textAlign: 'center' },
  securityBox: { marginTop: 10, padding: 15, backgroundColor: '#3a1f0a', borderRadius: 8 },
  securityTitle: { color: GOLD, fontWeight: 'bold', marginBottom: 5, fontSize: 12, textTransform: 'uppercase' },
  securityItem: { paddingVertical: 5, gap: 4 },
  securityText: { color: 'rgba(240,217,160,0.8)', fontSize: 13 },
});