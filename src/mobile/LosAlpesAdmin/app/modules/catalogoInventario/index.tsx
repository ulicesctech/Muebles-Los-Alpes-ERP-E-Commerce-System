import { Link } from "expo-router";
import React from "react";
import {
  FlatList,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

// Definimos los accesos directos basados en tu árbol de archivos
const menuOptions = [
  {
    title: "Categorías",
    route: "/modules/catalogoInventario/categorias",
    icon: "📁",
  },
  {
    title: "Tipos",
    route: "/modules/catalogoInventario/tipos",
    icon: "🗂️",
  },
  {
    title: "Materiales",
    route: "/modules/catalogoInventario/materiales",
    icon: "🪵",
  },
  {
    title: "Productos",
    route: "/modules/catalogoInventario/productos",
    icon: "🪑",
  },
  {
    title: "Precios",
    route: "/modules/catalogoInventario/precios",
    icon: "💰",
  },
  {
    title: "Stock / Existencias",
    route: "/modules/catalogoInventario/stock",
    icon: "📦",
  },
  {
    title: "Almacenes",
    route: "/modules/catalogoInventario/almacenes",
    icon: "🏬",
  },
  {
    title: "Nichos",
    route: "/modules/catalogoInventario/nichos",
    icon: "📍",
  },
  {
    title: "Promociones",
    route: "/modules/catalogoInventario/promociones",
    icon: "🏷️",
  },
];

export default function CatalogoDashboard() {
  // Encabezado del menú
  const renderHeader = () => (
    <View style={styles.headerArea}>
      <Text style={styles.title}>Panel de Inventario</Text>
      <Text style={styles.subtitle}>
        Gestión de Bodegas y Catálogo de Muebles
      </Text>
    </View>
  );

  // Tarjeta individual del menú
  const renderItem = ({ item }: { item: (typeof menuOptions)[0] }) => (
    <Link href={item.route as any} asChild>
      <TouchableOpacity style={styles.card}>
        <Text style={styles.icon}>{item.icon}</Text>
        <Text style={styles.cardTitle}>{item.title}</Text>
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
        numColumns={2} // Transforma la lista en una cuadrícula de 2 columnas
        columnWrapperStyle={styles.row} // Estilo para separar las columnas
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
  row: {
    flexDirection: "row",
    justifyContent: "space-between",
  },
  card: {
    width: "48%", // Ocupa un poco menos de la mitad para dejar espacio en el centro
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
});
