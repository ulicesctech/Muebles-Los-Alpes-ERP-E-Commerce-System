import { Link } from "expo-router";
import React from "react";
import {
  FlatList,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

// Rutas actualizadas según tu estructura de carpetas
const menuOptions = [
  {
    title: "Reporte de Inventario",
    route: "/modules/reporteria/Gerencial/inventario",
    icon: "📊",
    subtitle: "Gerencial"
  },
  {
    title: "Reporte de Ventas",
    route: "/modules/reporteria/Gerencial/ventas",
    icon: "📈",
    subtitle: "Gerencial"
  },
  {
    title: "Métricas de Marketing",
    route: "/modules/reporteria/Marketing/Marketing",
    icon: "🎯",
    subtitle: "Publicidad"
  },
];

export default function ReporteriaDashboard() {
  const renderHeader = () => (
    <View style={styles.headerArea}>
      <Text style={styles.title}>Módulo de Reportería</Text>
      <Text style={styles.subtitle}>
        Visualización de datos y análisis de Muebles Los Alpes
      </Text>
    </View>
  );

  const renderItem = ({ item }: { item: (typeof menuOptions)[0] }) => (
    <Link href={item.route as any} asChild>
      <TouchableOpacity style={styles.card}>
        <Text style={styles.icon}>{item.icon}</Text>
        <Text style={styles.cardTitle}>{item.title}</Text>
        <Text style={styles.tagText}>{item.subtitle}</Text>
      </TouchableOpacity>
    </Link>
  );

  return (
    <View style={styles.container}>
      <FlatList
        data={menuOptions}
        keyExtractor={(item, index) => index.toString()}
        renderItem={renderItem}
        ListHeaderComponent={renderHeader}
        numColumns={2}
        columnWrapperStyle={styles.row}
        contentContainerStyle={{ paddingBottom: 20 }}
        showsVerticalScrollIndicator={false}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    padding: 15,
  },
  headerArea: {
    marginBottom: 20,
    borderBottomWidth: 1,
    borderBottomColor: "#d1d5db",
    paddingBottom: 10,
  },
  title: {
    fontSize: 22,
    fontWeight: "bold",
    color: "#1f2937",
  },
  subtitle: {
    fontSize: 14,
    color: "#6b7280",
    marginTop: 4,
  },
  row: {
    flexDirection: "row",
    justifyContent: "space-between",
  },
  card: {
    width: "48%",
    backgroundColor: "#f9fafb",
    padding: 20,
    borderRadius: 16,
    marginBottom: 15,
    alignItems: "center",
    borderWidth: 1,
    borderColor: "#e5e7eb",
    shadowColor: "#000",
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 2,
  },
  icon: {
    fontSize: 32,
    marginBottom: 10,
  },
  cardTitle: {
    fontSize: 14,
    fontWeight: "700",
    color: "#111827",
    textAlign: "center",
  },
  tagText: {
    fontSize: 10,
    color: "#3b82f6",
    fontWeight: "600",
    marginTop: 5,
    textTransform: "uppercase",
  },
});