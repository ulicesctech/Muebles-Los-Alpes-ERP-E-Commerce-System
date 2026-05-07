import { StyleSheet, Text, View } from "react-native";

export default function Index() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>¡Bienvenido a Muebles Los Alpes!</Text>
      <Text style={styles.subtitle}>
        Este es el contenido dinámico. Si navegas a otra pantalla, el menú y el
        pie de página se mantendrán intactos.
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: "#fff",
    borderRadius: 8,
    shadowColor: "#000",
    shadowOpacity: 0.1,
    shadowRadius: 5,
    elevation: 3,
  },
  title: {
    fontSize: 22,
    fontWeight: "bold",
    color: "#3a1f0a",
    marginBottom: 10,
  },
  subtitle: {
    fontSize: 16,
    color: "#555",
    lineHeight: 24,
  },
});
