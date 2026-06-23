import { Link } from "expo-router";
import React from "react";
import {
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

const secciones = [
  {
    label: "Proveedores",
    items: [
      { title: "Proveedores",  desc: "Registro y gestión de proveedores de la empresa.", route: "/modules/comprasProveedor/proveedores",       icon: "🏭", footerBg: "#f0fff4", linkColor: "#2d7a2d" },
      { title: "Reclamos",     desc: "Gestión de reclamos a proveedores.",               route: "/modules/comprasProveedor/reclamosProveedor",  icon: "⚠️", footerBg: "#fff5f5", linkColor: "#c53030" },
    ],
  },
  {
    label: "Órdenes y Pedidos",
    items: [
      { title: "Órdenes de Compra", desc: "Registro y seguimiento de órdenes de compra.", route: "/modules/comprasProveedor/ordenesCompra",    icon: "📦", footerBg: "#f0fff4", linkColor: "#2d7a2d" },
      { title: "Pedidos",           desc: "Control y seguimiento de pedidos activos.",    route: "/modules/comprasProveedor/pedidos",           icon: "🚛", footerBg: "#f0fff4", linkColor: "#2d7a2d" },
    ],
  },
  {
    label: "Facturación",
    items: [
      { title: "Facturas de Proveedor", desc: "Gestión de facturas recibidas de proveedores.", route: "/modules/comprasProveedor/facturasProveedor", icon: "📄", footerBg: "#f0fff4", linkColor: "#2d7a2d" },
    ],
  },
];

export default function ComprasProveedorDashboard() {
  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.scroll} showsVerticalScrollIndicator={false}>

        {/* mod-header */}
        <View style={styles.modHeader}>
          <View style={{ flex: 1 }}>
            <Text style={styles.modTitle}>Compras & Proveedor</Text>
            <Text style={styles.modSubtitle}>
              Gestión de órdenes de compra, pedidos, proveedores y facturación.
            </Text>
          </View>
          <Text style={styles.modIcon}>🛒</Text>
        </View>

        {secciones.map((sec) => (
          <View key={sec.label}>
            <View style={styles.sectionLabel}>
              <Text style={styles.sectionLabelText}>{sec.label}</Text>
            </View>
            <View style={styles.grid}>
              {sec.items.map((item) => (
                <Link key={item.route} href={item.route as any} asChild>
                  <TouchableOpacity style={styles.card}>
                    <View style={styles.cardBody}>
                      <Text style={styles.cardIcon}>{item.icon}</Text>
                      <Text style={styles.cardTitle}>{item.title}</Text>
                      <Text style={styles.cardDesc}>{item.desc}</Text>
                    </View>
                    <View style={[styles.cardFooter, { backgroundColor: item.footerBg }]}>
                      <Text style={[styles.cardLink, { color: item.linkColor }]}>Gestionar →</Text>
                    </View>
                  </TouchableOpacity>
                </Link>
              ))}
            </View>
          </View>
        ))}

      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: "#fdf8f3" },
  scroll: { padding: 16, paddingBottom: 30 },
  modHeader: {
    flexDirection: "row", alignItems: "center",
    backgroundColor: "#1a1a1a", borderRadius: 12,
    padding: 22, marginBottom: 24,
    borderLeftWidth: 5, borderLeftColor: "#2d7a2d",
    shadowColor: "#000", shadowOpacity: 0.15, shadowRadius: 8, elevation: 4,
  },
  modTitle: { fontSize: 20, fontWeight: "bold", color: "#4aaa4a", marginBottom: 4 },
  modSubtitle: { fontSize: 12, color: "rgba(200,240,200,0.7)" },
  modIcon: { fontSize: 42, opacity: 0.2, marginLeft: 12 },
  sectionLabel: {
    backgroundColor: "#fdf6ec", borderRadius: 8,
    borderLeftWidth: 4, borderLeftColor: "#C9973A",
    paddingHorizontal: 14, paddingVertical: 8,
    marginTop: 8, marginBottom: 12,
  },
  sectionLabelText: { fontSize: 11, fontWeight: "bold", color: "#5C3A1E", textTransform: "uppercase", letterSpacing: 0.5 },
  grid: { flexDirection: "row", flexWrap: "wrap", gap: 12, marginBottom: 4 },
  card: {
    width: "47%", backgroundColor: "white",
    borderRadius: 12, borderWidth: 1, borderColor: "#e8d8c0",
    overflow: "hidden",
    shadowColor: "#000", shadowOpacity: 0.05, shadowRadius: 6, elevation: 2,
  },
  cardBody: { padding: 18, alignItems: "center" },
  cardIcon: { fontSize: 36, marginBottom: 8 },
  cardTitle: { fontSize: 13, fontWeight: "bold", color: "#1a1a1a", textAlign: "center", marginBottom: 4 },
  cardDesc: { fontSize: 11, color: "#999", textAlign: "center", lineHeight: 16 },
  cardFooter: { paddingHorizontal: 14, paddingVertical: 10, borderTopWidth: 1, borderTopColor: "#f5ece0" },
  cardLink: { fontSize: 12, fontWeight: "bold" },
});
