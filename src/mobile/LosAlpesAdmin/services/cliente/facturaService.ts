import { fetchAPI } from '../apiClient';

const HANDLER = 'Handlers/Cliente/FacturaClienteHandler.ashx';

export const crearFactura = (carritoId: number, formaPago: string, tipoEntrega: string, almacenId: number = 0) =>
  fetchAPI(HANDLER, `crear&carritoId=${carritoId}&formaPago=${formaPago}&tipoEntrega=${tipoEntrega}&almacenId=${almacenId}`, 'POST');