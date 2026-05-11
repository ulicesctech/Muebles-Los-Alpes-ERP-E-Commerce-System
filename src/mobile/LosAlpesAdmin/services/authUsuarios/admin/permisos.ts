import { fetchAPI } from "../../apiClient";

const HANDLER = 'Handlers/Auth/AuthHandler.ashx';

export const listarPermisos = () => fetchAPI(HANDLER, 'listar-permisos');
export const crearPermiso = (datos: object) => fetchAPI(HANDLER, 'crear-permiso', 'POST', datos);
export const actualizarPermiso = (datos: object) => fetchAPI(HANDLER, 'actualizar-permiso', 'POST', datos);
export const eliminarPermiso = (datos: object) => fetchAPI(HANDLER, 'eliminar-permiso', 'POST', datos);