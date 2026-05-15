import AsyncStorage from '@react-native-async-storage/async-storage';
import { fetchAPI } from "../apiClient";

const BASE_URL = "http://10.91.87.87:61850";
const SESSION_KEY = "ASP_NET_SESSION_COOKIE";
const HANDLER_PATH = "Handlers/CatalogoInventario/ProductosHandler.ashx";

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

export const getProductos = async (): Promise<Producto[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const buscarProductos = async (texto: string): Promise<Producto[]> => {
  const actionString = `buscar&texto=${encodeURIComponent(texto)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "GET");
};

const obtenerMimeType = (uri: string) => {
  const extension = uri.split(".").pop()?.toLowerCase();

  if (extension === "jpg" || extension === "jpeg") return "image/jpeg";
  if (extension === "png") return "image/png";
  if (extension === "webp") return "image/webp";

  return "image/jpeg";
};

const crearFormDataProducto = (data: any) => {
  const formData = new FormData();

  formData.append("referencia", data.referencia);
  formData.append("nombre", data.nombre);
  formData.append("descripcion", data.descripcion || "");
  formData.append("tipTipo", String(data.tipoId));
  formData.append("matMaterial", String(data.materialId));
  formData.append("color", data.color || "");
  formData.append("altoCm", data.alto || "0");
  formData.append("anchoCm", data.ancho || "0");
  formData.append("profundidadCm", data.profundidad || "0");
  formData.append("peso", data.peso || "0");

  if (data.fotoUri) {
    const extension = data.fotoUri.split(".").pop()?.toLowerCase() || "jpg";

    formData.append("foto", {
      uri: data.fotoUri,
      name: `producto_${Date.now()}.${extension}`,
      type: obtenerMimeType(data.fotoUri),
    } as any);
  }

  return formData;
};

const enviarProductoMultipart = async (
  action: "crear" | "actualizar",
  data: any,
) => {
  const sessionCookie = await AsyncStorage.getItem(SESSION_KEY);
  const formData = crearFormDataProducto(data);

  const headers: Record<string, string> = {
    Accept: "application/json",
  };

  if (sessionCookie) {
    headers.Cookie = sessionCookie;
  }

  const response = await fetch(
    `${BASE_URL}/${HANDLER_PATH}?action=${action}`,
    {
      method: "POST",
      headers,
      credentials: "include",
      body: formData,
    },
  );

  let jsonResult: any = null;

  try {
    jsonResult = await response.json();
  } catch {
    jsonResult = null;
  }

  if (!response.ok) {
    throw new Error(
      jsonResult?.mensaje ||
      jsonResult?.message ||
      `Error en el servidor. Codigo: ${response.status}`,
    );
  }

  if (jsonResult?.ok === false) {
    throw new Error(jsonResult?.mensaje || "No se pudo procesar la solicitud.");
  }

  return jsonResult;
};

export const crearProducto = async (data: any) => {
  return await enviarProductoMultipart("crear", data);
};

export const actualizarProducto = async (data: any) => {
  return await enviarProductoMultipart("actualizar", data);
};

export const eliminarProducto = async (referencia: string) => {
  const actionString = `eliminar&referencia=${encodeURIComponent(referencia)}`;
  return await fetchAPI(HANDLER_PATH, actionString, "POST");
};