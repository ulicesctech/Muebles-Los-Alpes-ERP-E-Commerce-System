import { fetchAPI } from "../apiClient";

export interface Material {
  MAT_MATERIAL: number;
  MAT_DESCRIPCION: string;
}

const HANDLER_PATH = "Handlers/CatalogoInventario/MaterialesHandler.ashx";

export const getMateriales = async (): Promise<Material[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const buscarMateriales = async (texto: string): Promise<Material[]> => {
  const actionString = `buscar&texto=${encodeURIComponent(texto)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};

export const crearMaterial = async (descripcion: string) => {
  const actionString = `crear&descripcion=${encodeURIComponent(descripcion)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const actualizarMaterial = async (id: number, descripcion: string) => {
  const actionString = `actualizar&id=${id}&descripcion=${encodeURIComponent(descripcion)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const eliminarMaterial = async (id: number) => {
  const actionString = `eliminar&id=${id}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};
