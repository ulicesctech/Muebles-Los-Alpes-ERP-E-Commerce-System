import { Link } from "expo-router";
import React from "react";
import {
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

// Opciones basadas en tu estructura de archivos .aspx actual
const salesOptions = [
  {
    title: "Dashboard Ventas",
    route: "/modules/ventasFacturacion/index",
    icon: "📊",
  },
  {
    title: "Carrito de Compras",
    route: "/modules/ventasFacturacion/carrito",
    icon: "🛒",
  },
  {
    title: "Detalle de Carrito",
    route: "/modules/ventasFacturacion/detalleCarrito",
    icon: "📝",
  },
  {
    title: "Facturación",
    route: "/modules/ventasFacturacion/factura",
    icon: "🧾",
  },
  {
    title: "Historial Precio Venta",
    route: "/modules/ventasFacturacion/historialPrecioVenta",
    icon: "💰",
  },
];

export default function VentasIndex() {
  return (
    <ScrollView style={styles.container}>
      <View style={styles.headerArea}>
        <Text style={styles.title}>Ventas y Facturación</Text>
        <Text style={styles.subtitle}>
          Gestión de pedidos y comprobantes fiscales
        </Text>
      </View>

      <View style={styles.grid}>
        {salesOptions.map((item, index) => (
          <Link key={index} href={item.route as any} asChild>
            <TouchableOpacity style={styles.card}>
              <Text style={styles.icon}>{item.icon}</Text>
              <Text style={styles.cardTitle}>{item.title}</Text>
            </TouchableOpacity>
          </Link>
        ))}
      </View>

      {/* Resumen de actividad rápida */}
      <View style={styles.infoBox}>
        <Text style={styles.infoTitle}>Resumen del Día</Text>
        <View style={styles.row}>
          <Text style={styles.label}>Facturas emitidas:</Text>
          <Text style={styles.value}>0</Text>
        </View>
        <View style={styles.row}>
          <Text style={styles.label}>Total ventas (Q):</Text>
          <Text style={styles.value}>0.00</Text>
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
  infoBox: {
    marginTop: 10,
    padding: 15,
    backgroundColor: "#1a0e05",
    borderRadius: 8,
  },
  infoTitle: {
    color: "#C9973A",
    fontWeight: "bold",
    marginBottom: 10,
    fontSize: 12,
    textTransform: "uppercase",
  },
  row: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 5,
  },
  label: {
    color: "rgba(240,217,160,0.6)",
    fontSize: 13,
  },
  value: {
    color: "#f0d9a0",
    fontWeight: "bold",
    fontSize: 13,
  },
});