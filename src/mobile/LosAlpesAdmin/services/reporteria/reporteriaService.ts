
//La direccion IP depende de la IP que tenga la computadora Host Servidor PBI
const BASE_URL = 'http://192.168.0.90/Reports/powerbi';

export const getReporteUrl = (reporte: string) => {
  return `${BASE_URL}/${reporte}?rs:Embed=true&rs:navContentPaneEnabled=false&rc:Toolbar=false`;
};