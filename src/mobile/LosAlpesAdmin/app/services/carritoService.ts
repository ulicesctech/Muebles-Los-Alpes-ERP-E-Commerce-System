import { fetchAPI } from './apiClient';

const HANDLER = 'Handlers/VentasFacturacion/CarritoHandler.ashx';

export interface Carrito {
  PRE_CARRITO: number;
  PRE_CORRELATIVO: string;
  PRE_FECHA_INICIO: string;
  PRE_TOTAL: number | string;
  NOMBRE_CLIENTE: string;
  PRODUCTOS: string;
}

export interface Producto {
  PRO_CODIGO: number;
  PRO_NOMBRE: string;
  PRO_PRECIO: number;
  HV_HISTORIAL_PRECIO_VENTA: number;
}

export const listarCarritos = async (): Promise<Carrito[]> => {
  return await fetchAPI(HANDLER, 'listar');
};

export const listarProductos = async (): Promise<Producto[]> => {
  return await fetchAPI(HANDLER, 'productos');
};

export const crearCarrito = async (clienteId: number): Promise<number> => {
  const result = await fetchAPI(HANDLER, `crear&cliente=${clienteId}`, 'POST');
  return result.id;
};

export const agregarDetalle = async (carritoId: number, hvPrecio: number, cantidad: number): Promise<void> => {
  await fetchAPI(HANDLER, `agregardetalle&carrito=${carritoId}&hvPrecio=${hvPrecio}&cantidad=${cantidad}`, 'POST');
};

export const vaciarCarrito = async (carritoId: number): Promise<void> => {
  await fetchAPI(HANDLER, `vaciar&carrito=${carritoId}`, 'POST');
};

export const eliminarCarrito = async (id: number): Promise<void> => {
  await fetchAPI(HANDLER, `eliminar&id=${id}`, 'POST');
};
