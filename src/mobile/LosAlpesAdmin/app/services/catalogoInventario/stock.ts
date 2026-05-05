import { fetchAPI } from "../apiClient";

export interface Stock {
  HIP_HISTORIAL_PRECIO: number;
  PRO_REFERENCIA?: string;
  PRO_NOMBRE?: string;
  ALM_NOMBRE?: string;
  NIC_NUMERO?: string;
  NIC_CARACTERISTICA?: string;
  HIP_PRECIO?: number;
  STO_MINIMO: number;
  STO_MAXIMO: number;
  STO_DISPONIBLE: number;
}

// Ruta relativa del Handler sin la barra inicial
const HANDLER_PATH = "Handlers/CatalogoInventario/StockHandler.ashx";

// ==========================================
// MÉTODOS DE LECTURA (GET)
// ==========================================

export const getStockList = async (): Promise<Stock[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const getStockPorProducto = async (
  proReferencia: string,
): Promise<Stock[]> => {
  const actionString = `listar_por_producto&proReferencia=${encodeURIComponent(proReferencia)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};

export const obtenerStock = async (
  hipHistorialPrecio: number,
): Promise<Stock[]> => {
  const actionString = `obtener&hipHistorialPrecio=${hipHistorialPrecio}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};

export const obtenerStockPorNicho = async (
  proReferencia: string,
  nicNicho: number,
): Promise<Stock[]> => {
  const actionString = `obtener_por_nicho&proReferencia=${encodeURIComponent(proReferencia)}&nicNicho=${nicNicho}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};

// ==========================================
// MÉTODOS DE ESCRITURA (POST)
// ==========================================

export const guardarStock = async (
  hipHistorialPrecio: number,
  minimo: number,
  maximo: number,
  disponible: number,
) => {
  const actionString = `guardar&hipHistorialPrecio=${hipHistorialPrecio}&minimo=${minimo}&maximo=${maximo}&disponible=${disponible}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const entradaStock = async (
  hipHistorialPrecio: number,
  cantidad: number,
) => {
  const actionString = `entrada&hipHistorialPrecio=${hipHistorialPrecio}&cantidad=${cantidad}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const salidaStock = async (
  hipHistorialPrecio: number,
  cantidad: number,
) => {
  const actionString = `salida&hipHistorialPrecio=${hipHistorialPrecio}&cantidad=${cantidad}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const eliminarStock = async (hipHistorialPrecio: number) => {
  const actionString = `eliminar&hipHistorialPrecio=${hipHistorialPrecio}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};
