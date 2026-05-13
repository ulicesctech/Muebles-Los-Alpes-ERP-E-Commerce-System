import { fetchAPI } from "../apiClient";

const HANDLER_PATH = "Handlers/ComprasProveedor/OrdenDetallePedidoHandler.ashx";

export interface OrdenDetalle {
  odp_orden_detalle_pedido: number;  // ← nombre real de Oracle (minúscula)
  ODP_ID?: number;                    // alias por compatibilidad
  ODP_MATERIAL: string;
  ODP_PRODUCTO: string;
  ODP_PRECIO: number;
  ODP_CANTIDAD: number;
  PED_PEDIDO: number;
}

export const listarPorOrden = async (orcKey: string): Promise<OrdenDetalle[]> => {
  return await fetchAPI(HANDLER_PATH, `listarPorOrden&orc_key=${encodeURIComponent(orcKey)}`, "GET");
};

export const buscarPorPedido = async (pedidoId: number): Promise<OrdenDetalle[]> => {
  return await fetchAPI(HANDLER_PATH, `buscarPorPedido&pedido_id=${pedidoId}`, "GET");
};

export const insertarOrdenDetalle = async (
  orcKey: string, pedidoId: number, material: string,
  producto: string, precio: number, cantidad: number
) => {
  const action = `insertar&orc_key=${encodeURIComponent(orcKey)}&pedido_id=${pedidoId}&material=${encodeURIComponent(material)}&producto=${encodeURIComponent(producto)}&precio=${precio}&cantidad=${cantidad}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

export const actualizarOrdenDetalle = async (
  odpId: number, material: string, producto: string,
  precio: number, cantidad: number
) => {
  const action = `actualizar&odp_id=${odpId}&material=${encodeURIComponent(material)}&producto=${encodeURIComponent(producto)}&precio=${precio}&cantidad=${cantidad}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

export const eliminarOrdenDetalle = async (odpId: number) => {
  return await fetchAPI(HANDLER_PATH, `eliminar&odp_id=${odpId}`, "POST");
};
