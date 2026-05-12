/*import React from 'react';
import { View, Button } from 'react-native';
import * as Linking from 'expo-linking';

import { getReporteUrl } from '../app/services/reporteria/reporteriaService';

interface ReporteViewerProps {
  reporte: string;
}

export default function ReporteViewer({
  reporte,
}: ReporteViewerProps) {

  const url = getReporteUrl(reporte);

  const abrirReporte = async () => {
    await Linking.openURL(url);
  };

  return (
    <View>
      <Button
        title={`Abrir reporte ${reporte}`}
        onPress={abrirReporte}
      />
    </View>
  );
}*/


import React, { useEffect } from 'react';
import { View, Text, ActivityIndicator, StyleSheet } from 'react-native';
import * as Linking from 'expo-linking';
import { getReporteUrl } from '../app/services/reporteria/reporteriaService';

interface ReporteViewerProps {
  reporte: string;
}

export default function ReporteViewer({ reporte }: ReporteViewerProps) {
  const url = getReporteUrl(reporte);

  useEffect(() => {
    // Esta función se ejecuta automáticamente al cargar el componente
    const redireccionar = async () => {
      if (url) {
        await Linking.openURL(url);
      }
    };

    redireccionar();
  }, [url]);

  return (
    <View style={styles.container}>
      <ActivityIndicator size="large" color="#3a1f0a" />
      <Text style={styles.text}>Redirigiendo al reporte de {reporte}...</Text>
      <Text style={styles.subtext}>Inicia sesión en tu navegador si es necesario.</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
    padding: 20
  },
  text: {
    marginTop: 15,
    fontSize: 16,
    fontWeight: 'bold',
    color: '#3a1f0a',
    textAlign: 'center'
  },
  subtext: {
    marginTop: 5,
    fontSize: 12,
    color: '#7a4f2a',
  }
});