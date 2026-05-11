import { fetchAPI } from "../apiClient";

export interface NicAlm {
  ID: number; // ID de la asignación (ajusta el nombre si tu DB devuelve NAL_ID u otro)
  NIC_NICHO: number;
  ALM_ALMACEN: number;
  // Campos opcionales por si tu procedimiento almacenado devuelve datos extra (JOINs)
  NIC_NUMERO?: string;
  ALM_NOMBRE?: string;
}

// Ruta relativa del Handler sin la barra inicial
const HANDLER_PATH = "Handlers/CatalogoInventario/NicAlmHandler.ashx";

export const getAsignaciones = async (): Promise<NicAlm[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const getAsignacionesPorAlmacen = async (
  almAlmacen: number,
): Promise<NicAlm[]> => {
  const actionString = `listar_por_almacen&almAlmacen=${almAlmacen}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};

export const asignarNicho = async (nicNicho: number, almAlmacen: number) => {
  const actionString = `asignar&nicNicho=${nicNicho}&almAlmacen=${almAlmacen}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const quitarAsignacion = async (id: number) => {
  const actionString = `quitar&id=${id}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};
