import { Link } from "expo-router";
import React from "react";
import {
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

// Opciones basadas en la estructura de AuthUsuarios
const authOptions = [
  {
    title: "Gestión de Empleados",
    route: "/modules/authUsuarios/empleados",
    icon: "👥",
  },
  {
    title: "Puestos y Cargos",
    route: "/modules/authUsuarios/puestos",
    icon: "🎖️",
  },
  {
    title: "Control de Ascensos",
    route: "/modules/authUsuarios/ascensos",
    icon: "📈",
  },
  {
    title: "Listado de Clientes",
    route: "/modules/authUsuarios/clientes",
    icon: "👤",
  },
  {
    title: "Grupos de Usuario",
    route: "/modules/authUsuarios/admin/grupoUsuario",
    icon: "🛡️",
  },
  {
    title: "Permisos de Sistema",
    route: "/modules/authUsuarios/admin/permisos",
    icon: "🔑",
  },
  {
    title: "Login Empleados",
    route: "/modules/authUsuarios/loginEmpleado",
    icon: "💻",
  },
  {
    title: "Login Clientes",
    route: "/modules/authUsuarios/loginCliente",
    icon: "📱",
  },
];

export default function AuthUsuariosIndex() {
  return (
    <ScrollView style={styles.container}>
      <View style={styles.headerArea}>
        <Text style={styles.title}>Seguridad y Personal</Text>
        <Text style={styles.subtitle}>
          Control de acceso y administración de RR.HH.
        </Text>
      </View>

      <View style={styles.grid}>
        {authOptions.map((item, index) => (
          <Link key={index} href={item.route as any} asChild>
            <TouchableOpacity style={styles.card}>
              <Text style={styles.icon}>{item.icon}</Text>
              <Text style={styles.cardTitle}>{item.title}</Text>
            </TouchableOpacity>
          </Link>
        ))}
      </View>

      {/* Resumen de Seguridad */}
      <View style={styles.securityBox}>
        <Text style={styles.securityTitle}>Estado del Sistema</Text>
        <View style={styles.securityItem}>
          <Text style={styles.securityText}>
            Sesión activa como Administrador
          </Text>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    borderRadius: 12,
    padding: 15,
  },
  headerArea: {
    marginBottom: 20,
    borderBottomWidth: 1,
    borderBottomColor: "#e0d0b8",
    paddingBottom: 10,
  },
  title: {
    fontSize: 20,
    fontWeight: "bold",
    color: "#3a1f0a",
  },
  subtitle: {
    fontSize: 14,
    color: "#7a4f2a",
  },
  grid: {
    flexDirection: "row",
    flexWrap: "wrap",
    justifyContent: "space-between",
  },
  card: {
    width: "48%",
    backgroundColor: "#fdf6ec",
    padding: 20,
    borderRadius: 12,
    marginBottom: 15,
    alignItems: "center",
    borderWidth: 1,
    borderColor: "#e0d0b8",
    elevation: 2,
  },
  icon: {
    fontSize: 30,
    marginBottom: 8,
  },
  cardTitle: {
    fontSize: 14,
    fontWeight: "bold",
    color: "#5C3A1E",
    textAlign: "center",
  },
  securityBox: {
    marginTop: 10,
    padding: 15,
    backgroundColor: "#3a1f0a",
    borderRadius: 8,
  },
  securityTitle: {
    color: "#C9973A",
    fontWeight: "bold",
    marginBottom: 5,
    fontSize: 12,
    textTransform: "uppercase",
  },
  securityItem: {
    paddingVertical: 5,
  },
  securityText: {
    color: "rgba(240,217,160,0.8)",
    fontSize: 13,
  },
});
