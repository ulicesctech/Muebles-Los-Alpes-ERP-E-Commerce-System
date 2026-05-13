import { fetchAPI } from './apiClient';

const HANDLER = 'Handlers/VentasFacturacion/FacturaHandler.ashx';

export const crearFactura = async (carrito: number, empleado: number): Promise<string> => {
  const result = await fetchAPI(HANDLER, `crear&carrito=${carrito}&empleado=${empleado}`, 'POST');
  return result.codigo;
};
