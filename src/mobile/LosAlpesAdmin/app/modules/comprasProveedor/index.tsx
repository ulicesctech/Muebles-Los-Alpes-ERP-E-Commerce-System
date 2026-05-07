import { Link } from "expo-router";
import React from "react";
import {
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

// Opciones basadas en tu árbol de archivos de ComprasProveedor
const supplierOptions = [
  {
    title: "Dashboard Compras",
    route: "/modules/comprasProveedor",
    icon: "📈",
  },
  {
    title: "Gestión de Proveedores",
    route: "/modules/comprasProveedor/proveedores",
    icon: "🤝",
  },
  {
    title: "Órdenes de Compra",
    route: "/modules/comprasProveedor/ordenesCompra",
    icon: "📝",
  },
  {
    title: "Control de Pedidos",
    route: "/modules/comprasProveedor/pedidos",
    icon: "🚚",
  },
  {
    title: "Facturas Proveedor",
    route: "/modules/comprasProveedor/facturasProveedor",
    icon: "🧾",
  },
  {
    title: "Reclamos y Devoluciones",
    route: "/modules/comprasProveedor/reclamosProveedor",
    icon: "⚠️",
  },
];

export default function ComprasIndex() {
  return (
    <ScrollView style={styles.container}>
      <View style={styles.headerArea}>
        <Text style={styles.title}>Compras y Proveedores</Text>
        <Text style={styles.subtitle}>
          Gestión de suministros y abastecimiento
        </Text>
      </View>

      <View style={styles.grid}>
        {supplierOptions.map((item, index) => (
          <Link key={index} href={item.route as any} asChild>
            <TouchableOpacity style={styles.card}>
              <Text style={styles.icon}>{item.icon}</Text>
              <Text style={styles.cardTitle}>{item.title}</Text>
            </TouchableOpacity>
          </Link>
        ))}
      </View>

      {/* Sección de Alertas Rápidas */}
      <View style={styles.alertBox}>
        <Text style={styles.alertTitle}>Pedidos Pendientes</Text>
        <View style={styles.alertItem}>
          <Text style={styles.alertText}>
            No hay pedidos próximos a vencer.
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
    shadowColor: "#000",
    shadowOpacity: 0.05,
    shadowRadius: 5,
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
  alertBox: {
    marginTop: 10,
    padding: 15,
    backgroundColor: "#fff4e5",
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: "#C9973A",
  },
  alertTitle: {
    color: "#3a1f0a",
    fontWeight: "bold",
    marginBottom: 5,
    fontSize: 13,
  },
  alertItem: {
    paddingVertical: 5,
  },
  alertText: {
    color: "#7a4f2a",
    fontSize: 13,
    fontStyle: "italic",
  },
});
