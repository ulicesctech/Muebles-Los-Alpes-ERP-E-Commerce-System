import { fetchAPI } from "../apiClient"; // Ajusta la ruta si es necesario

export interface Categoria {
  CAT_CATEGORIA: number;
  CAT_DESCRIPCION: string;
}

// Ruta relativa del Handler sin la barra inicial (apiClient ya tiene la barra final)
const HANDLER_PATH = "Handlers/CatalogoInventario/CategoriasHandler.ashx";

export const getCategorias = async (): Promise<Categoria[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const buscarCategorias = async (texto: string): Promise<Categoria[]> => {
  // Concatenamos el parámetro extra a la acción para que el backend lo lea por URL
  const actionString = `buscar&texto=${encodeURIComponent(texto)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};

export const crearCategoria = async (descripcion: string) => {
  const actionString = `crear&descripcion=${encodeURIComponent(descripcion)}`;
  // Usamos POST pero enviamos los datos en la URL para que context.Request los detecte
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const actualizarCategoria = async (id: number, descripcion: string) => {
  const actionString = `actualizar&id=${id}&descripcion=${encodeURIComponent(descripcion)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const eliminarCategoria = async (id: number) => {
  const actionString = `eliminar&id=${id}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};
