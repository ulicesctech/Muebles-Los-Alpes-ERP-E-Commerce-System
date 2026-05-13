import { fetchAPI } from "../apiClient";

export interface HistorialPrecio {
  HIP_HISTORIAL_PRECIO: number;
  PRO_NOMBRE: string;
  ALM_NOMBRE: string;
  NIC_NUMERO: string;
  NIC_CARACTERISTICA: string;
  HIP_PRECIO: number;
  HIP_FECHA_INICIO: string;
  HIP_FECHA_FINAL?: string | null; // null = precio vigente
}

const HANDLER_PATH = "Handlers/CatalogoInventario/HistorialPreciosHandler.ashx";

export const getHistorialTodos = async (): Promise<HistorialPrecio[]> => {
  return await fetchAPI(HANDLER_PATH, "listar_todos", "GET");
};

export const getHistorialPorMes = async (
  mes: number,
  anio: number,
): Promise<HistorialPrecio[]> => {
  return await fetchAPI(HANDLER_PATH, `listar_por_mes&mes=${mes}&anio=${anio}`, "GET");
};

/** Años con registros en el historial — viene de OBTENER_ANIOS del paquete Oracle */
export const getHistorialAnios = async (): Promise<number[]> => {
  const rows = await fetchAPI(HANDLER_PATH, "obtener_anios", "GET") as { ANIO: number }[];
  return rows.map((r) => r.ANIO);
};