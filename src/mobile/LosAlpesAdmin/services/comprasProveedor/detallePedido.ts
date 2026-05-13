import { fetchAPI } from "../apiClient";

const HANDLER_PATH = "Handlers/ComprasProveedor/DetallePedidoHandler.ashx";

export interface DetallePedido {
  DETPE_DETALLE_PEDIDO: number;
  PRO_REFERENCIA: string;
  PRO_NOMBRE: string;
  MATERIAL: string;
  DETPE_CANTIDAD_SOLICITADA: number;
  DETPE_CANTIDAD_RECIBIDA: number;
  HIP_HISTORIAL_PRECIO: number;
  HIP_PRECIO: number;
}

export interface Producto {
  PRO_REFERENCIA: string;
  PRO_NOMBRE: string;
}

export const getDetallePedido = async (pedidoId: number): Promise<DetallePedido[]> => {
  return await fetchAPI(HANDLER_PATH, `listarPorPedido&pedido_id=${pedidoId}`, "GET");
};

export const getProductosParaPedido = async (): Promise<Producto[]> => {
  return await fetchAPI(HANDLER_PATH, "listarTodosProductos", "GET");
};

// El handler internamente llama a HistorialPrecioService.RegistrarSemilla
// El móvil no necesita conocer ni pasar el hip_id — Oracle lo genera
export const insertarDetallePedido = async (
  pedidoId: number,
  proReferencia: string,
  cantidad: number
) => {
  const action = `insertar&pedido_id=${pedidoId}&pro_referencia=${encodeURIComponent(proReferencia)}&cantidad=${cantidad}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

export const actualizarDetallePedido = async (
  detalleId: number,
  cantSolicitada: number,
  cantRecibida: number
) => {
  const action = `actualizar&detalle_id=${detalleId}&cant_solicitada=${cantSolicitada}&cant_recibida=${cantRecibida}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

export const eliminarDetallePedido = async (detalleId: number) => {
  return await fetchAPI(HANDLER_PATH, `eliminar&detalle_id=${detalleId}`, "POST");
};
