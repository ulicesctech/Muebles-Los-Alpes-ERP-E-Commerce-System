import { fetchAPI } from "../../apiClient";

const HANDLER = 'Handlers/Auth/AuthHandler.ashx';

export const listarGrupos = () => fetchAPI(HANDLER, 'listar-grupos');
export const crearGrupo = (datos: object) => fetchAPI(HANDLER, 'crear-grupo', 'POST', datos);
export const actualizarGrupo = (datos: object) => fetchAPI(HANDLER, 'actualizar-grupo', 'POST', datos);
export const eliminarGrupo = (datos: object) => fetchAPI(HANDLER, 'eliminar-grupo', 'POST', datos);