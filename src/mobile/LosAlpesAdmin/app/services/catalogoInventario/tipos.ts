import { fetchAPI } from "../apiClient";

export interface Tipo {
  TIP_TIPO: number;
  TIP_DESCRIPCION: string;
  CAT_CATEGORIA: number;
  CATEGORIA?: string; // Nombre de la categoría (viene del JOIN de la base de datos)
}

// Ruta relativa del Handler sin la barra inicial
const HANDLER_PATH = "Handlers/CatalogoInventario/TiposHandler.ashx";

export const getTipos = async (): Promise<Tipo[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const getTiposPorCategoria = async (catId: number): Promise<Tipo[]> => {
  const actionString = `listar_por_categoria&catId=${catId}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};

export const crearTipo = async (descripcion: string, catCategoria: number) => {
  const actionString = `crear&descripcion=${encodeURIComponent(descripcion)}&catCategoria=${catCategoria}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const actualizarTipo = async (
  id: number,
  descripcion: string,
  catCategoria: number,
) => {
  const actionString = `actualizar&id=${id}&descripcion=${encodeURIComponent(descripcion)}&catCategoria=${catCategoria}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const eliminarTipo = async (id: number) => {
  const actionString = `eliminar&id=${id}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};
