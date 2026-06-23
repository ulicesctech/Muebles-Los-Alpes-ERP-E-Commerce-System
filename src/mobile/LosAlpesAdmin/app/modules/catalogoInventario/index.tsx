import { Link } from "expo-router";
import React from "react";
import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from "react-native";

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

const menuOptions = [
  { title: "Categorías", route: "/modules/catalogoInventario/categorias", icon: "🏷️", desc: "Clasificación principal de productos.", color: GOLD },
  { title: "Materiales", route: "/modules/catalogoInventario/materiales", icon: "🧱", desc: "Materiales de fabricación.", color: '#8B5E3C' },
  { title: "Tipos", route: "/modules/catalogoInventario/tipos", icon: "📋", desc: "Subcategorías del catálogo.", color: CAFE },
  { title: "Productos", route: "/modules/catalogoInventario/productos", icon: "🛋️", desc: "Catálogo con foto y dimensiones.", color: '#2a1a0a' },
  { title: "Historial de Precios", route: "/modules/catalogoInventario/precios", icon: "💰", desc: "Precios por producto y nicho.", color: GOLD },
  { title: "Promociones", route: "/modules/catalogoInventario/promociones", icon: "🎯", desc: "Descuentos y campañas.", color: CAFE },
  { title: "Almacenes", route: "/modules/catalogoInventario/almacenes", icon: "🏭", desc: "Bodegas físicas y nichos.", color: GOLD },
  { title: "Nichos", route: "/modules/catalogoInventario/nichos", icon: "📍", desc: "Espacios dentro de almacenes.", color: CAFE },
  { title: "Stock", route: "/modules/catalogoInventario/stock", icon: "📦", desc: "Control de disponibilidad.", color: GOLD },
];

export default function CatalogoDashboard() {
  return (
    <ScrollView style={styles.container}>
      {/* Header */}
      <View style={styles.modHeader}>
        <View style={{ flex: 1 }}>
          <Text style={styles.modTitle}>Catálogo & Inventario</Text>
          <Text style={styles.modSubtitle}>Gestión de productos, materiales, tipos, precios y ubicaciones de bodega.</Text>
        </View>
        <Text style={styles.modIcon}>📦</Text>
      </View>

      {/* Catálogo */}
      <Text style={styles.sectionLabel}>Catálogo de Productos</Text>
      <View style={styles.grid}>
        {menuOptions.slice(0, 4).map((item, i) => (
          <Link key={i} href={item.route as any} asChild>
            <TouchableOpacity style={styles.card}>
              <View style={[styles.cardAccent, { backgroundColor: item.color }]} />
              <View style={styles.cardBody}>
                <Text style={styles.cardIcon}>{item.icon}</Text>
                <Text style={styles.cardTitle}>{item.title}</Text>
                <Text style={styles.cardDesc}>{item.desc}</Text>
              </View>
              <View style={styles.cardFooter}>
                <Text style={[styles.cardLink, { color: item.color }]}>Gestionar →</Text>
              </View>
            </TouchableOpacity>
          </Link>
        ))}
      </View>

      {/* Precios y Promociones */}
      <Text style={styles.sectionLabel}>Precios y Promociones</Text>
      <View style={styles.grid}>
        {menuOptions.slice(4, 6).map((item, i) => (
          <Link key={i} href={item.route as any} asChild>
            <TouchableOpacity style={styles.card}>
              <View style={[styles.cardAccent, { backgroundColor: item.color }]} />
              <View style={styles.cardBody}>
                <Text style={styles.cardIcon}>{item.icon}</Text>
                <Text style={styles.cardTitle}>{item.title}</Text>
                <Text style={styles.cardDesc}>{item.desc}</Text>
              </View>
              <View style={styles.cardFooter}>
                <Text style={[styles.cardLink, { color: item.color }]}>Gestionar →</Text>
              </View>
            </TouchableOpacity>
          </Link>
        ))}
      </View>

      {/* Bodega */}
      <Text style={styles.sectionLabel}>Ubicación Física — Bodega</Text>
      <View style={styles.grid}>
        {menuOptions.slice(6).map((item, i) => (
          <Link key={i} href={item.route as any} asChild>
            <TouchableOpacity style={styles.card}>
              <View style={[styles.cardAccent, { backgroundColor: item.color }]} />
              <View style={styles.cardBody}>
                <Text style={styles.cardIcon}>{item.icon}</Text>
                <Text style={styles.cardTitle}>{item.title}</Text>
                <Text style={styles.cardDesc}>{item.desc}</Text>
              </View>
              <View style={styles.cardFooter}>
                <Text style={[styles.cardLink, { color: item.color }]}>Gestionar →</Text>
              </View>
            </TouchableOpacity>
          </Link>
        ))}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0' },
  modHeader: { backgroundColor: '#1a1a1a', borderRadius: 12, margin: 16, padding: 24, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderLeftWidth: 5, borderLeftColor: GOLD, elevation: 4 },
  modTitle: { color: GOLD, fontSize: 20, fontWeight: 'bold', marginBottom: 4 },
  modSubtitle: { color: 'rgba(240,217,160,0.65)', fontSize: 11, lineHeight: 16 },
  modIcon: { fontSize: 48, opacity: 0.15, marginLeft: 8 },
  sectionLabel: { fontSize: 12, fontWeight: 'bold', color: CAFE, marginHorizontal: 16, marginBottom: 10, padding: 8, backgroundColor: '#fdf6ec', borderRadius: 8, borderLeftWidth: 4, borderLeftColor: GOLD, textTransform: 'uppercase', letterSpacing: 0.5 },
  grid: { flexDirection: 'row', flexWrap: 'wrap', paddingHorizontal: 16, gap: 12, marginBottom: 8 },
  card: { width: '47%', backgroundColor: 'white', borderRadius: 12, borderWidth: 1, borderColor: '#e8d8c0', overflow: 'hidden', elevation: 2 },
  cardAccent: { height: 6 },
  cardBody: { padding: 14 },
  cardIcon: { fontSize: 32, marginBottom: 8 },
  cardTitle: { fontSize: 13, fontWeight: 'bold', color: '#1a1a1a', marginBottom: 4 },
  cardDesc: { fontSize: 11, color: '#aaa', lineHeight: 15 },
  cardFooter: { padding: 10, borderTopWidth: 1, borderTopColor: '#f5ece0' },
  cardLink: { fontSize: 12, fontWeight: 'bold' },
});