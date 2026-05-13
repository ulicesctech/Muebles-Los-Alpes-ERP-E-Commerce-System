import React, { useEffect } from 'react';
import { View, Text, ActivityIndicator, StyleSheet } from 'react-native';
import * as Linking from 'expo-linking';
import { useRouter } from 'expo-router'; // Importamos el router
import { getReporteUrl } from '../services/reporteria/reporteriaService';

interface ReporteViewerProps {
  reporte: string;
}

export default function ReporteViewer({ reporte }: ReporteViewerProps) {
  const url = getReporteUrl(reporte);
  const router = useRouter(); // Inicializamos el router

  useEffect(() => {
    const redireccionarYRegresar = async () => {
      if (url) {
        // 1. Abrimos el reporte en el navegador
        await Linking.openURL(url);
        
        // 2. Esperamos un breve momento para asegurar que el sistema lanzó la URL
        // y luego regresamos a la pantalla anterior (el index de reportes)
        setTimeout(() => {
          if (router.canGoBack()) {
            router.back();
          } else {
            router.replace('/modules/reporteria');
          }
        }, 500); 
      }
    };

    redireccionarYRegresar();
  }, [url]);

  return (
    <View style={styles.container}>
      <ActivityIndicator size="large" color="#3a1f0a" />
      <Text style={styles.text}>Abriendo reporte...</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
  },
  text: {
    marginTop: 15,
    fontSize: 16,
    color: '#3a1f0a',
  },
});

