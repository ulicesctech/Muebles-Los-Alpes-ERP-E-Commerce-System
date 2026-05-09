import { fetchAPI } from "../apiClient";

const HANDLER_PATH = "Handlers/ComprasProveedor/ProveedorHandler.ashx";

export interface Proveedor {
  PROV_PROVEEDOR: number;
  PROV_NIT: string;
  PROV_NOMBRE: string;
  PROV_AVENIDA: string;
  PROV_ZONA: string;
  PROV_DIRECCION: string;
  PROV_TELEFONO: string;
}

// ─── Validaciones espejo del package Oracle ───────────────────────────────────
// VALIDAR_NIT: NIT sin guion 3-10 chars (2-9 dígitos + dígito verificador 0-9|K)
//              ó CUI exactamente 13 dígitos.
export const validarNit = (nit: string): boolean => {
  const v = nit.trim().toUpperCase();
  if (/^\d{13}$/.test(v)) return true;           // CUI
  if (/^\d{2,9}[\dK]$/.test(v)) return true;     // NIT sin guion
  return false;
};

// VALIDAR_TELEFONO: exactamente 8 dígitos numéricos.
export const validarTelefono = (tel: string): boolean =>
  /^\d{8}$/.test(tel.trim());

// ─── API ──────────────────────────────────────────────────────────────────────
export const getProveedores = async (): Promise<Proveedor[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const buscarProveedores = async (texto: string): Promise<Proveedor[]> => {
  return await fetchAPI(
    HANDLER_PATH,
    `buscar&texto=${encodeURIComponent(texto)}`,
    "GET"
  );
};

export const crearProveedor = async (
  nit: string,
  nombre: string,
  avenida: string,
  zona: string,
  direccion: string,
  telefono: string
) => {
  const action =
    `crear` +
    `&nit=${encodeURIComponent(nit)}` +
    `&nombre=${encodeURIComponent(nombre)}` +
    `&avenida=${encodeURIComponent(avenida)}` +
    `&zona=${encodeURIComponent(zona)}` +
    `&direccion=${encodeURIComponent(direccion)}` +
    `&telefono=${encodeURIComponent(telefono)}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

export const actualizarProveedor = async (
  id: number,
  nit: string,
  nombre: string,
  avenida: string,
  zona: string,
  direccion: string,
  telefono: string
) => {
  const action =
    `actualizar` +
    `&id=${id}` +
    `&nit=${encodeURIComponent(nit)}` +
    `&nombre=${encodeURIComponent(nombre)}` +
    `&avenida=${encodeURIComponent(avenida)}` +
    `&zona=${encodeURIComponent(zona)}` +
    `&direccion=${encodeURIComponent(direccion)}` +
    `&telefono=${encodeURIComponent(telefono)}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

export const eliminarProveedor = async (id: number) => {
  return await fetchAPI(HANDLER_PATH, `eliminar&id=${id}`, "POST");
};