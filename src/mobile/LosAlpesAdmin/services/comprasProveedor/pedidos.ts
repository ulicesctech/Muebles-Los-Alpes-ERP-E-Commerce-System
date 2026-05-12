// app/services/compras/pedidoService.ts
import { fetchAPI } from "../apiClient";

const HANDLER_PEDIDO  = "Handlers/ComprasProveedor/PedidoHandler.ashx";
const HANDLER_DETALLE = "Handlers/ComprasProveedor/DetallePedidoHandler.ashx";

// Los handlers leen JSON body en POST (via StreamReader + Newtonsoft)
// y query string en GET (via context.Request("key")).

export const PedidoService = {

  // ── GET ──────────────────────────────────────────────────────────────────
  listar: async () =>
    fetchAPI(HANDLER_PEDIDO, "listar", "GET"),

  obtener: async (id: number) =>
    fetchAPI(HANDLER_PEDIDO, `obtener&id=${id}`, "GET"),

  buscar: async (codigo: string) =>
    fetchAPI(HANDLER_PEDIDO, `buscar&codigo=${encodeURIComponent(codigo)}`, "GET"),

  listarFormasPago: async () =>
    fetchAPI(HANDLER_PEDIDO, "listarFormasPago", "GET"),

  // ── POST — body JSON ──────────────────────────────────────────────────────
  crear: async (formaPago: string) =>
    fetchAPI(HANDLER_PEDIDO, "crear", "POST", {
      forma_pago: formaPago,
      total: 0,
    }),

  actualizar: async (id: number, codigo: string, formaPago: string, total: number) =>
    fetchAPI(HANDLER_PEDIDO, "actualizar", "POST", {
      id,
      codigo,
      forma_pago: formaPago,
      total,
    }),

  eliminar: async (id: number) =>
    fetchAPI(HANDLER_PEDIDO, "eliminar", "POST", { id }),
};

export const DetallePedidoService = {

  // ── GET ──────────────────────────────────────────────────────────────────
  listarPorPedido: async (pedidoId: number) =>
    fetchAPI(HANDLER_DETALLE, `listarPorPedido&pedido_id=${pedidoId}`, "GET"),

  listarTodosProductos: async () =>
    fetchAPI(HANDLER_DETALLE, "listarTodosProductos", "GET"),

  // ── POST — body JSON ──────────────────────────────────────────────────────
  insertar: async (pedidoId: number, proReferencia: string, cantidad: number) =>
    fetchAPI(HANDLER_DETALLE, "insertar", "POST", {
      pedido_id:       pedidoId,
      pro_referencia:  proReferencia,
      cantidad,
    }),

  actualizar: async (detalleId: number, cantSolicitada: number, cantRecibida: number) =>
    fetchAPI(HANDLER_DETALLE, "actualizar", "POST", {
      detalle_id:      detalleId,
      cant_solicitada: cantSolicitada,
      cant_recibida:   cantRecibida,
    }),

  eliminar: async (detalleId: number) =>
    fetchAPI(HANDLER_DETALLE, "eliminar", "POST", {
      detalle_id: detalleId,
    }),
};