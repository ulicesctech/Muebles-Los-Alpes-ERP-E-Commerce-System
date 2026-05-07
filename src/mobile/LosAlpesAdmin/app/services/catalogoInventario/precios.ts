import { fetchAPI } from "../apiClient";

export interface HistorialPrecio {
  HIP_HISTORIAL_PRECIO: number;
  PRO_NOMBRE: string;
  ALM_NOMBRE: string;
  NIC_NUMERO: string;
  NIC_CARACTERISTICA: string;
  HIP_PRECIO: number;
  HIP_FECHA_INICIO: string;
  HIP_FECHA_FINAL?: string | null; // Es null si el precio sigue vigente
}

// Ruta relativa del Handler sin la barra inicial
const HANDLER_PATH = "Handlers/CatalogoInventario/HistorialPrecioHandler.ashx";

export const getHistorialTodos = async (): Promise<HistorialPrecio[]> => {
  return await fetchAPI(HANDLER_PATH, "listar_todos", "GET");
};

export const getHistorialPorMes = async (
  mes: number,
  anio: number,
): Promise<HistorialPrecio[]> => {
  const actionString = `listar_por_mes&mes=${mes}&anio=${anio}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};
