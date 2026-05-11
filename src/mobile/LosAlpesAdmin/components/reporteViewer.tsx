import React from 'react';
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
}