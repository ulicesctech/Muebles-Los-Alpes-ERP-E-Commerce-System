import { fetchAPI } from "../apiClient";

const HANDLER_PATH = "Handlers/ComprasProveedor/OrdenCompraHandler.ashx";

// ✅ Aliases reales que devuelve Oracle en ORC_LISTAR y ORC_BUSCAR
export interface OrdenCompra {
  ORC_KEY: string;      // era ORC_ORDEN_COMPRA — alias real del SELECT
  CODIGO: string;       // era ORC_CODIGO
  PROVEEDOR: string;    // era PROV_NOMBRE
  FECHA: string;        // era ORC_FECHA
  TOTAL: number;        // era ORC_TOTAL
}

export const getOrdenesCompra = async (): Promise<OrdenCompra[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const getOrdenCompraPorId = async (orcKey: string): Promise<OrdenCompra[]> => {
  return await fetchAPI(HANDLER_PATH, `listarPorId&orc_key=${encodeURIComponent(orcKey)}`, "GET");
};

export const buscarOrdenesCompra = async (codigo: string): Promise<OrdenCompra[]> => {
  return await fetchAPI(HANDLER_PATH, `buscar&codigo=${encodeURIComponent(codigo)}`, "GET");
};

// ORC_BUSCAR_PEDIDOS devuelve: ped_pedido, ped_codigo, ped_fecha,
// ped_forma_pago, ped_total, total_items
// ⚠️ YA_ASIGNADO no viene — el paquete no lo calcula actualmente
export const buscarPedidosParaOrden = async (texto: string) => {
  return await fetchAPI(HANDLER_PATH, `buscarPedidos&texto=${encodeURIComponent(texto)}`, "GET");
};

// ORC_DETALLES_PEDIDO devuelve: detpe_detalle_pedido, ped_pedido,
// ped_forma_pago, cantidad, producto_nombre, material, precio_ref, pro_referencia
export const getDetallesPedidoParaOrden = async (pedId: number) => {
  return await fetchAPI(HANDLER_PATH, `detallesPedido&ped_id=${pedId}`, "GET");
};

export const crearOrdenCompra = async (provId: number, total: number) => {
  return await fetchAPI(HANDLER_PATH, `crear&prov_id=${provId}&total=${total}`, "POST");
};

export const actualizarOrdenCompra = async (
  orcKey: string, codigo: string, provId: number, total: number
) => {
  const action = `actualizar&orc_key=${encodeURIComponent(orcKey)}&codigo=${encodeURIComponent(codigo)}&prov_id=${provId}&total=${total}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

// El total lo recalcula Oracle — el móvil solo dispara el endpoint
export const actualizarTotalOrden = async (orcKey: string) => {
  return await fetchAPI(HANDLER_PATH, `actualizarTotal&orc_key=${encodeURIComponent(orcKey)}`, "POST");
};

export const eliminarOrdenCompra = async (orcKey: string) => {
  return await fetchAPI(HANDLER_PATH, `eliminar&orc_key=${encodeURIComponent(orcKey)}`, "POST");
};

// Usado por pedidos.tsx para verificar si un pedido ya tiene OC asignada.
// Llama a ODP_LISTAR_POR_PEDIDO en OrdenDetallePedidoHandler —
// si devuelve registros, el pedido tiene OC y no se puede modificar.
export const buscarDetallesPorPedido = async (pedidoId: number) => {
  return await fetchAPI(
    "Handlers/ComprasProveedor/OrdenDetallePedidoHandler.ashx",
    `buscarPorPedido&pedido_id=${pedidoId}`,
    "GET"
  );
};