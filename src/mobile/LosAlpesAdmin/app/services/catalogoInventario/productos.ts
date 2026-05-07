import { fetchAPI } from "../apiClient";

export interface Producto {
  PRO_REFERENCIA: string;
  PRO_NOMBRE: string;
  PRO_DESCRIPCION?: string;
  TIP_TIPO?: number;
  TIP_DESCRIPCION?: string;
  MAT_MATERIAL?: number;
  MAT_DESCRIPCION?: string;
  PRO_ALTO_CM?: number;
  PRO_ANCHO_CM?: number;
  PRO_PROFUNDIDAD_CM?: number;
  PRO_COLOR?: string;
  PRO_PESO?: number;
  PRO_PRECIO?: number;
}

const HANDLER_PATH = "Handlers/CatalogoInventario/ProductosHandler.ashx";

export const getProductos = async (): Promise<Producto[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const buscarProductos = async (texto: string): Promise<Producto[]> => {
  const actionString = `buscar&texto=${encodeURIComponent(texto)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};

export const crearProducto = async (data: any) => {
  // Construimos el string enviando los datos por URL tal como los espera tu handler
  const params = new URLSearchParams({
    referencia: data.referencia,
    nombre: data.nombre,
    descripcion: data.descripcion || "",
    tipTipo: data.tipoId,
    matMaterial: data.materialId,
    color: data.color || "",
    altoCm: data.alto || "0",
    anchoCm: data.ancho || "0",
    profundidadCm: data.profundidad || "0",
    peso: data.peso || "0",
  }).toString();

  const actionString = `crear&${params}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const actualizarProducto = async (data: any) => {
  const params = new URLSearchParams({
    referencia: data.referencia,
    nombre: data.nombre,
    descripcion: data.descripcion || "",
    tipTipo: data.tipoId,
    matMaterial: data.materialId,
    color: data.color || "",
    altoCm: data.alto || "0",
    anchoCm: data.ancho || "0",
    profundidadCm: data.profundidad || "0",
    peso: data.peso || "0",
  }).toString();

  const actionString = `actualizar&${params}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};

export const eliminarProducto = async (referencia: string) => {
  const actionString = `eliminar&referencia=${encodeURIComponent(referencia)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};
