import { fetchAPI } from '../apiClient';

const HANDLER = 'Handlers/Cliente/CarritoClienteHandler.ashx';

export const crearCarrito = (clienteId: number) =>
  fetchAPI(HANDLER, `crear&clienteId=${clienteId}`, 'POST');
export const buscarCarrito = (clienteId: number) =>
  fetchAPI(HANDLER, `buscar&clienteId=${clienteId}`);
export const listarDetalle = (carritoId: number) =>
  fetchAPI(HANDLER, `detalle&carritoId=${carritoId}`);
export const agregarDetalle = (carritoId: number, hvId: number, cantidad: number) =>
  fetchAPI(HANDLER, `agregar&carritoId=${carritoId}&hvId=${hvId}&cantidad=${cantidad}`, 'POST');
export const eliminarDetalle = (detalleId: number) =>
  fetchAPI(HANDLER, `eliminar-detalle&detalleId=${detalleId}`, 'POST');
export const vaciarCarrito = (carritoId: number) =>
  fetchAPI(HANDLER, `vaciar&carritoId=${carritoId}`, 'POST');
export const almacenesConStock = (hvIds: string) =>
  fetchAPI(HANDLER, `almacenes&hvIds=${encodeURIComponent(hvIds)}`);