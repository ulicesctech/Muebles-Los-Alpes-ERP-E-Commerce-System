// app/services/catalogoInventario/stockService.ts
import { fetchAPI } from "../apiClient";

// StockHandler usa body JSON para guardar/entrada/salida/eliminar (LeerBody)
// y querystring para listar/obtener y recibir_desde_pedido
const HANDLER = "Handlers/CatalogoInventario/StockHandler.ashx";

export const StockService = {

  // ── GET ───────────────────────────────────────────────────────────────────
  listar: async () =>
    fetchAPI(HANDLER, "listar", "GET"),

  listarPorProducto: async (proReferencia: string) =>
    fetchAPI(HANDLER, `listar_por_producto&proReferencia=${encodeURIComponent(proReferencia)}`, "GET"),

  obtenerPorNicho: async (proReferencia: string, nicNicho: number) =>
    fetchAPI(HANDLER, `obtener_por_nicho&proReferencia=${encodeURIComponent(proReferencia)}&nicNicho=${nicNicho}`, "GET"),

  obtener: async (hipHistorialPrecio: number) =>
    fetchAPI(HANDLER, `obtener&hipHistorialPrecio=${hipHistorialPrecio}`, "GET"),

  // ── POST con body JSON (igual que el handler actual) ─────────────────────
  guardar: async (hipHistorialPrecio: number, minimo: number, maximo: number, disponible: number) =>
    fetchAPI(HANDLER, "guardar", "POST", {
      hip_historial_precio: hipHistorialPrecio,
      minimo, maximo, disponible,
    }),

  entrada: async (hipHistorialPrecio: number, cantidad: number) =>
    fetchAPI(HANDLER, "entrada", "POST", {
      hip_historial_precio: hipHistorialPrecio,
      cantidad,
    }),

  salida: async (hipHistorialPrecio: number, cantidad: number) =>
    fetchAPI(HANDLER, "salida", "POST", {
      hip_historial_precio: hipHistorialPrecio,
      cantidad,
    }),

  eliminar: async (hipHistorialPrecio: number) =>
    fetchAPI(HANDLER, "eliminar", "POST", {
      hip_historial_precio: hipHistorialPrecio,
    }),

  // ── NUEVO: Recepción desde Pedidos via querystring ────────────────────────
  // El handler hace todo el flujo de Stock.aspx.vb:
  //   1. ResolverHipParaRecepcion → si precio cambió crea nuevo historial de precio
  //   2. GuardarStockSumando      → suma disponible, migra HIP si cambió
  //   3. DetallePedidoService.Actualizar → actualiza cant_recibida del pedido
  recibirDesdePedido: async (params: {
    proReferencia: string;
    hipSemilla: number;
    nichoId: number;
    precio: number;
    cantRecibida: number;
    cantTotal: number;
    detpeId: number;
    pedidoId: number;
    minimo?: number;
    maximo?: number;
  }) =>
    fetchAPI(
      HANDLER,
      [
        "recibir_desde_pedido",
        `proReferencia=${encodeURIComponent(params.proReferencia)}`,
        `hipSemilla=${params.hipSemilla}`,
        `nichoId=${params.nichoId}`,
        `precio=${params.precio.toFixed(2)}`,
        `cantRecibida=${params.cantRecibida}`,
        `cantTotal=${params.cantTotal}`,
        `detpeId=${params.detpeId}`,
        `pedidoId=${params.pedidoId}`,
        `minimo=${params.minimo ?? 0}`,
        `maximo=${params.maximo ?? 0}`,
      ].join("&"),
      "GET"
    ),
};