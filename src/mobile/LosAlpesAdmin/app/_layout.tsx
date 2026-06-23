import { Link, Slot, router, useSegments } from "expo-router";
import { useEffect, useState } from "react";
import {
  Alert,
  Modal,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  TouchableWithoutFeedback,
  View,
} from "react-native";
import { AuthProvider, useAuth } from "../context/AuthContext";
import { CarritoProvider, useCarrito } from "../context/CarritoContext";

function AuthGuard() {
  const { usuario, loading } = useAuth();
  const segments = useSegments();

  useEffect(() => {
    if (loading) return;

    const enAuth = segments[0] === "(auth)";
    const enModulos = segments[0] === "modules";
    const enCliente = segments[1] === "cliente";
    const enRoot = !segments[0];

    if (!usuario && !enAuth) {
      router.replace("/(auth)/login");
      return;
    }

    if (usuario && enAuth) {
      if (usuario.tipo === "CLIENTE") {
        router.replace("/modules/cliente/catalogo" as any);
      } else {
        router.replace("/");
      }
      return;
    }

    if (usuario?.tipo === "CLIENTE") {
      if (enRoot || !enCliente) {
        router.replace("/modules/cliente/catalogo" as any);
      }
      return;
    }

    if (usuario?.tipo === "EMPLEADO" && enModulos && enCliente) {
      router.replace("/");
      return;
    }
  }, [usuario, loading, segments]);

  return null;
}

function NavAdmin() {
  const { logout } = useAuth();

  const handleLogout = async () => {
    Alert.alert("Cerrar Sesión", "¿Estás seguro?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Sí, salir",
        onPress: async () => {
          await logout();
          router.replace("/(auth)/login");
        },
      },
    ]);
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.topBar}>
        <Text style={styles.topBarText}>
          Envíos a todo Guatemala | Tel: +502 5568 8472
        </Text>
      </View>

      <View style={styles.header}>
        <View style={styles.headerTop}>
          <Text style={styles.logoText}>Muebles Los Alpes</Text>
          <TouchableOpacity onPress={handleLogout} style={styles.btnSalir}>
            <Text style={styles.btnSalirText}>✕</Text>
          </TouchableOpacity>
        </View>
      </View>

      <View style={styles.navContainer}>
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

          <Link href={"/modules/reporteria" as any} asChild>
            <TouchableOpacity style={styles.navItem}>
              <Text style={styles.navText}> Reportes</Text>
            </TouchableOpacity>
          </Link>
        </ScrollView>
      </View>

      <View style={styles.contentWrapper}>
        <Slot />
      </View>

      <View style={styles.footerMain}>
        <Text style={styles.footerTitle}>Santos & Familia — Desde 1978</Text>
        <Text style={styles.footerText}>
          Diseño & Confort Hogareño — Guatemala
        </Text>
        <View style={styles.footerBottom}>
          <Text style={styles.footerBottomText}>
            © 2026 — Muebles Los Alpes ERP
          </Text>
        </View>
      </View>
    </SafeAreaView>
  );
}

function NavCliente() {
  const { usuario, logout } = useAuth();
  const { items } = useCarrito();
  const [menuAbierto, setMenuAbierto] = useState(false);
  const totalItems = items.reduce((a, i) => a + i.cantidad, 0);

  const handleLogout = async () => {
    setMenuAbierto(false);
    Alert.alert("Cerrar Sesión", "¿Estás seguro?", [
      { text: "Cancelar", style: "cancel" },
      {
        text: "Sí, salir",
        onPress: async () => {
          await logout();
          router.replace("/(auth)/login");
        },
      },
    ]);
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <View style={styles.headerTop}>
          <Text style={styles.logoText}>Muebles Los Alpes</Text>

          <View style={styles.headerBtns}>
            <TouchableOpacity
              style={styles.carritoBtn}
              onPress={() => router.push("/modules/cliente/carrito" as any)}
            >
              <Text style={styles.carritoIcon}>🛒</Text>
              {totalItems > 0 && (
                <View style={styles.carritoBadge}>
                  <Text style={styles.carritoBadgeText}>{totalItems}</Text>
                </View>
              )}
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.userBtn}
              onPress={() => setMenuAbierto(true)}
            >
              <Text style={styles.userBtnText}>
                Hola, {usuario?.nombre.split(" ")[0]} ▾
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>

      <View style={styles.navContainer}>
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.navScroll}
        >
          <Link href={"/modules/cliente/catalogo" as any} asChild>
            <TouchableOpacity style={styles.navItem}>
              <Text style={styles.navText}>🛋 Productos</Text>
            </TouchableOpacity>
          </Link>

          <Link href={"/modules/cliente/misCompras" as any} asChild>
            <TouchableOpacity style={styles.navItem}>
              <Text style={styles.navText}>Mis Compras</Text>
            </TouchableOpacity>
          </Link>

          <Link href={"/modules/cliente/promociones" as any} asChild>
            <TouchableOpacity style={styles.navItem}>
              <Text style={styles.navText}>Promociones</Text>
            </TouchableOpacity>
          </Link>
        </ScrollView>
      </View>

      <Modal visible={menuAbierto} transparent animationType="fade">
        <TouchableWithoutFeedback onPress={() => setMenuAbierto(false)}>
          <View style={styles.modalOverlay}>
            <TouchableWithoutFeedback>
              <View style={styles.menuDropdown}>
                <View style={styles.menuHeader}>
                  <Text style={styles.menuHeaderText}>
                    Hola, {usuario?.nombre.split(" ")[0]}
                  </Text>
                  <Text style={styles.menuHeaderSub}>{usuario?.nombre}</Text>
                </View>

                <TouchableOpacity
                  style={styles.menuItem}
                  onPress={() => {
                    setMenuAbierto(false);
                    router.push("/modules/cliente/misCompras" as any);
                  }}
                >
                  <Text style={styles.menuItemIcon}>📦</Text>
                  <Text style={styles.menuItemText}>Mis Pedidos</Text>
                </TouchableOpacity>

                <TouchableOpacity
                  style={styles.menuItem}
                  onPress={() => {
                    setMenuAbierto(false);
                    router.push("/modules/cliente/miPerfil" as any);
                  }}
                >
                  <Text style={styles.menuItemIcon}>👤</Text>
                  <Text style={styles.menuItemText}>Mi Información</Text>
                </TouchableOpacity>

                <View style={styles.menuDivider} />

                <TouchableOpacity
                  style={[styles.menuItem, styles.menuItemLogout]}
                  onPress={handleLogout}
                >
                  <Text style={styles.menuItemIcon}>🚪</Text>
                  <Text style={styles.menuItemTextLogout}>Cerrar sesión</Text>
                </TouchableOpacity>
              </View>
            </TouchableWithoutFeedback>
          </View>
        </TouchableWithoutFeedback>
      </Modal>

      <View style={styles.contentWrapper}>
        <Slot />
      </View>
    </SafeAreaView>
  );
}

function Layout() {
  const { usuario } = useAuth();

  if (!usuario) return <Slot />;
  if (usuario.tipo === "CLIENTE") return <NavCliente />;

  return <NavAdmin />;
}

export default function RootLayout() {
  return (
    <AuthProvider>
      <CarritoProvider>
        <AuthGuard />
        <Layout />
      </CarritoProvider>
    </AuthProvider>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#f0ebe0" },
  topBar: { backgroundColor: "#3a1f0a", padding: 6, alignItems: "center" },
  topBarText: { color: "rgba(240,217,160,0.7)", fontSize: 10 },

  header: {
    backgroundColor: "#111",
    padding: 15,
    borderBottomWidth: 3,
    borderBottomColor: "#C9973A",
  },
  headerTop: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  headerBtns: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
  },
  logoText: {
    color: "#f0d9a0",
    fontSize: 20,
    fontWeight: "bold",
  },

  btnSalir: {
    backgroundColor: "#c53030",
    width: 32,
    height: 32,
    borderRadius: 6,
    justifyContent: "center",
    alignItems: "center",
  },
  btnSalirText: {
    color: "white",
    fontSize: 14,
    fontWeight: "bold",
  },

  carritoBtn: {
    position: "relative",
    padding: 4,
  },
  carritoIcon: {
    fontSize: 24,
  },
  carritoBadge: {
    position: "absolute",
    top: 0,
    right: 0,
    backgroundColor: "#e53e3e",
    borderRadius: 10,
    width: 16,
    height: 16,
    alignItems: "center",
    justifyContent: "center",
  },
  carritoBadgeText: {
    color: "white",
    fontSize: 9,
    fontWeight: "bold",
  },

  navContainer: {
    backgroundColor: "#1a0e05",
    borderBottomWidth: 2,
    borderBottomColor: "#C9973A",
    flexDirection: "row",
    alignItems: "center",
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
    paddingTop: 16,
    alignItems: "center",
    borderTopWidth: 3,
    borderTopColor: "#C9973A",
  },
  footerTitle: {
    color: "#C9973A",
    fontSize: 11,
    fontWeight: "bold",
    textTransform: "uppercase",
    letterSpacing: 1,
  },
  footerText: {
    color: "rgba(240,217,160,0.45)",
    fontSize: 11,
    marginTop: 4,
  },
  footerBottom: {
    backgroundColor: "#050300",
    width: "100%",
    padding: 8,
    marginTop: 12,
    alignItems: "center",
  },
  footerBottomText: {
    color: "rgba(240,217,160,0.25)",
    fontSize: 10,
  },

  userBtn: {
    backgroundColor: "rgba(201,151,58,0.15)",
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: "rgba(201,151,58,0.3)",
  },
  userBtnText: {
    color: "#C9973A",
    fontSize: 12,
    fontWeight: "bold",
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.4)",
    alignItems: "flex-end",
    paddingTop: 90,
    paddingRight: 16,
  },
  menuDropdown: {
    backgroundColor: "white",
    borderRadius: 12,
    width: 220,
    elevation: 10,
    overflow: "hidden",
    borderWidth: 1,
    borderColor: "#e8d8c0",
  },
  menuHeader: {
    backgroundColor: "#5C3A1E",
    padding: 16,
  },
  menuHeaderText: {
    color: "#f0d9a0",
    fontSize: 15,
    fontWeight: "bold",
  },
  menuHeaderSub: {
    color: "#d4b896",
    fontSize: 12,
    marginTop: 2,
  },
  menuItem: {
    flexDirection: "row",
    alignItems: "center",
    padding: 14,
    gap: 10,
    borderBottomWidth: 1,
    borderBottomColor: "#f5ece0",
  },
  menuItemIcon: {
    fontSize: 18,
  },
  menuItemText: {
    fontSize: 14,
    color: "#3a2a1a",
    fontWeight: "bold",
  },
  menuDivider: {
    height: 1,
    backgroundColor: "#e8d8c0",
  },
  menuItemLogout: {
    borderBottomWidth: 0,
  },
  menuItemTextLogout: {
    fontSize: 14,
    color: "#c53030",
    fontWeight: "bold",
  },
});
