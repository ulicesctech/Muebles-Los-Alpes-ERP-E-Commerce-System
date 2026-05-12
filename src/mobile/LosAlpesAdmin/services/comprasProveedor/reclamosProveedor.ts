import { fetchAPI } from "../apiClient";

const HANDLER_PATH = "Handlers/ComprasProveedor/ReclamoProveedorHandler.ashx";

// ✅ Campos reales que devuelve REC_PROV_LISTAR / REC_PROV_BUSCAR:
//    rep_reclamo_proveedor | orc_orden_compra | rep_descripcion |
//    rep_comentarios | rep_estado | rep_fecha_inicio | rep_fecha_final
//    ⚠️ REP_RECLAMO no existe — el PK real es rep_reclamo_proveedor
//    ⚠️ ORC_CODIGO y PROV_NOMBRE no existen — Oracle no hace JOIN en este listar
export interface ReclamoProveedor {
  REP_RECLAMO_PROVEEDOR: number;  // PK real
  ORC_ORDEN_COMPRA: string;
  REP_DESCRIPCION: string;
  REP_COMENTARIOS: string;
  REP_ESTADO: string;
  REP_FECHA_INICIO: string;
  REP_FECHA_FINAL: string;
  // ORC_CODIGO y PROV_NOMBRE no vienen — si se necesitan hay que modificar el paquete
}

// ✅ REC_PROV_LISTAR_ESTADOS devuelve: estado | descripcion
//    ES_CIERRE no viene del listar — Oracle lo calcula via REC_PROV_ES_CIERRE (proc separado)
export interface EstadoReclamo {
  ESTADO: string;
  DESCRIPCION: string;
}

export const getReclamosProveedor = async (): Promise<ReclamoProveedor[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const getReclamoPorId = async (id: number): Promise<ReclamoProveedor[]> => {
  return await fetchAPI(HANDLER_PATH, `listarPorId&id=${id}`, "GET");
};

// Devuelve todos los estados incluyendo TODOS — Oracle decide qué incluir
export const getEstadosReclamo = async (): Promise<EstadoReclamo[]> => {
  return await fetchAPI(HANDLER_PATH, "listarEstados", "GET");
};

export const buscarReclamos = async (
  texto: string,
  estado: string,
  fechaDesde?: string,
  fechaHasta?: string
): Promise<ReclamoProveedor[]> => {
  let action = `buscar&texto=${encodeURIComponent(texto)}&estado=${encodeURIComponent(estado)}`;
  if (fechaDesde) action += `&fecha_desde=${encodeURIComponent(fechaDesde)}`;
  if (fechaHasta) action += `&fecha_hasta=${encodeURIComponent(fechaHasta)}`;
  return await fetchAPI(HANDLER_PATH, action, "GET");
};

export const crearReclamo = async (orcKey: string, descripcion: string) => {
  const action = `crear&orc_key=${encodeURIComponent(orcKey)}&descripcion=${encodeURIComponent(descripcion)}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

export const actualizarReclamo = async (id: number, descripcion: string) => {
  return await fetchAPI(HANDLER_PATH, `actualizar&id=${id}&descripcion=${encodeURIComponent(descripcion)}`, "POST");
};

export const actualizarComentariosReclamo = async (id: number, comentarios: string) => {
  return await fetchAPI(HANDLER_PATH, `actualizarComentarios&id=${id}&comentarios=${encodeURIComponent(comentarios)}`, "POST");
};

// Oracle valida el orden de estados y si requiere comentarios — el móvil solo envía
export const cambiarEstadoReclamo = async (
  id: number, estado: string, comentarios: string
) => {
  const action = `cambiarEstado&id=${id}&estado=${encodeURIComponent(estado)}&comentarios=${encodeURIComponent(comentarios)}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

export const eliminarReclamo = async (id: number) => {
  return await fetchAPI(HANDLER_PATH, `eliminar&id=${id}`, "POST");
};