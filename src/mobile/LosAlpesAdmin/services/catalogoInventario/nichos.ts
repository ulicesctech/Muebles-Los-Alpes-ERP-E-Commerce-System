import { fetchAPI } from "../apiClient";

export interface Nicho {
  NIC_NICHO: number;
  NIC_NUMERO: string;
  NIC_ZONA: string;
  NIC_CARACTERISTICA: string;
  ALM_NOMBRE?: string; // Opcional porque viene del JOIN con Almacenes en tu base de datos
}

// Ruta relativa del Handler sin la barra inicial
const HANDLER_PATH = "Handlers/CatalogoInventario/NichoHandler.ashx";

export const getNichos = async (): Promise<Nicho[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const getNichosPorAlmacen = async (
  almacenId: number,
): Promise<Nicho[]> => {
  const actionString = `listar_por_almacen&almacenId=${almacenId}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};

export const crearYAsignarNicho = async (
  numero: string,
  zona: string,
  caracteristica: string,
  almacenId: number,
) => {
  const actionString = `crear_y_asignar&numero=${encodeURIComponent(numero)}&zona=${encodeURIComponent(zona)}&caracteristica=${encodeURIComponent(caracteristica)}&almacenId=${almacenId}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const actualizarNicho = async (
  id: number,
  numero: string,
  zona: string,
  caracteristica: string,
) => {
  const actionString = `actualizar&id=${id}&numero=${encodeURIComponent(numero)}&zona=${encodeURIComponent(zona)}&caracteristica=${encodeURIComponent(caracteristica)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const eliminarNicho = async (id: number) => {
  const actionString = `eliminar&id=${id}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};
