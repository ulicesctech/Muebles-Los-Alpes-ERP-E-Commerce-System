import { Link, Slot } from "expo-router";
import {
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";

export default function RootLayout() {
  return (
    <SafeAreaView style={styles.container}>
      {/* TOP BAR */}
      <View style={styles.topBar}>
        <Text style={styles.topBarText}>
          Envíos a todo Guatemala | Tel: +502 5568 8472
        </Text>
      </View>

      {/* HEADER & SEARCH */}
      <View style={styles.header}>
        <Text style={styles.logoText}>Muebles Los Alpes</Text>

        <View style={styles.searchContainer}>
          <TextInput
            style={styles.searchInput}
            placeholder="Buscar en la tienda..."
            placeholderTextColor="rgba(240,217,160,0.5)"
          />
          <TouchableOpacity style={styles.searchButton}>
            <Text style={styles.searchIcon}>🔍</Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* MOBILE NAVIGATION (Scroll Horizontal) */}
      <View style={styles.navContainer}>
        {/* Este ScrollView horizontal ESTÁ BIEN, no causa el error */}
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.navScroll}
        >
          <Link href="/" asChild>
            <TouchableOpacity style={styles.navItem}>
              <Text style={styles.navText}>Inicio</Text>
            </TouchableOpacity>
          </Link>
          <Link href="/modules/catalogoInventario" asChild>
            <TouchableOpacity style={styles.navItem}>
              <Text style={styles.navText}>Catálogo & Inv.</Text>
            </TouchableOpacity>
          </Link>
          <Link href="/modules/authUsuarios" asChild>
            <TouchableOpacity style={styles.navItem}>
              <Text style={styles.navText}>Usuarios</Text>
            </TouchableOpacity>
          </Link>
          <Link href="/modules/comprasProveedor" asChild>
            <TouchableOpacity style={styles.navItem}>
              <Text style={styles.navText}>Compras</Text>
            </TouchableOpacity>
          </Link>
          <Link href="/modules/ventasFacturacion" asChild>
            <TouchableOpacity style={styles.navItem}>
              <Text style={styles.navText}>Ventas</Text>
            </TouchableOpacity>
          </Link>
        </ScrollView>
      </View>

      {/* CONTENIDO PRINCIPAL - CORREGIDO: Cambiado de ScrollView a View */}
      <View style={styles.contentWrapper}>
        <Slot />
      </View>

      {/* FOOTER */}
      <View style={styles.footerMain}>
        <Text style={styles.footerTitle}>Santos & Familia — Desde 1978</Text>
        <Text style={styles.footerText}>Diseño & Confort Hogareño</Text>
        <Text style={styles.footerText}>Guatemala</Text>

        <View style={styles.footerBottom}>
          <Text style={styles.footerBottomText}>
            © 2026 — Muebles Los Alpes ERP
          </Text>
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f0ebe0", // Fondo crema de tu web
  },
  topBar: {
    backgroundColor: "#3a1f0a",
    padding: 6,
    alignItems: "center",
    borderBottomWidth: 1,
    borderBottomColor: "rgba(201,151,58,0.2)",
  },
  topBarText: {
    color: "rgba(240,217,160,0.7)",
    fontSize: 10,
    letterSpacing: 0.5,
  },
  header: {
    backgroundColor: "#111",
    padding: 15,
    borderBottomWidth: 3,
    borderBottomColor: "#C9973A", // Color Oro
  },
  logoText: {
    color: "#f0d9a0",
    fontSize: 22,
    fontWeight: "bold",
    fontFamily: "serif",
    textAlign: "center",
    marginBottom: 15,
  },
  searchContainer: {
    flexDirection: "row",
    height: 45,
  },
  searchInput: {
    flex: 1,
    backgroundColor: "#1e1e1e",
    borderWidth: 2,
    borderColor: "#C9973A",
    borderRightWidth: 0,
    borderTopLeftRadius: 6,
    borderBottomLeftRadius: 6,
    paddingHorizontal: 15,
    color: "#f0d9a0",
  },
  searchButton: {
    backgroundColor: "#C9973A",
    justifyContent: "center",
    alignItems: "center",
    paddingHorizontal: 15,
    borderTopRightRadius: 6,
    borderBottomRightRadius: 6,
  },
  searchIcon: {
    fontSize: 16,
  },
  navContainer: {
    backgroundColor: "#1a0e05",
    borderBottomWidth: 2,
    borderBottomColor: "#C9973A",
  },
  navScroll: {
    paddingHorizontal: 10,
  },
  navItem: {
    paddingVertical: 12,
    paddingHorizontal: 15,
  },
  navText: {
    color: "rgba(240,217,160,0.85)",
    fontWeight: "bold",
    fontSize: 13,
  },
  contentWrapper: {
    flex: 1,
  },
  footerMain: {
    backgroundColor: "#0d0703",
    paddingTop: 20,
    alignItems: "center",
    borderTopWidth: 3,
    borderTopColor: "#C9973A",
  },
  footerTitle: {
    color: "#C9973A",
    fontSize: 12,
    fontWeight: "bold",
    textTransform: "uppercase",
    letterSpacing: 1,
    marginBottom: 5,
  },
  footerText: {
    color: "rgba(240,217,160,0.45)",
    fontSize: 12,
    marginBottom: 3,
  },
  footerBottom: {
    backgroundColor: "#050300",
    width: "100%",
    padding: 10,
    marginTop: 15,
    alignItems: "center",
  },
  footerBottomText: {
    color: "rgba(240,217,160,0.25)",
    fontSize: 10,
  },
});
