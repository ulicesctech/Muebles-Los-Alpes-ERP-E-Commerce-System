import { fetchAPI } from "../apiClient";

const HANDLER = 'Handlers/Auth/AuthHandler.ashx';

export const listarAscensos = () => fetchAPI(HANDLER, 'listar-ascensos');
export const crearAscenso = (datos: object) => fetchAPI(HANDLER, 'crear-ascenso', 'POST', datos);
export const cerrarAscenso = (datos: object) => fetchAPI(HANDLER, 'cerrar-ascenso', 'POST', datos);
export const eliminarAscenso = (datos: object) => fetchAPI(HANDLER, 'eliminar-ascenso', 'POST', datos);