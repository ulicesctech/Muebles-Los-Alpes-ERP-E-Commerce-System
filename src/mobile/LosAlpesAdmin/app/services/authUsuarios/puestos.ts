import { fetchAPI } from "../apiClient";

const HANDLER = 'Handlers/Auth/AuthHandler.ashx';

export const listarPuestos = () => fetchAPI(HANDLER, 'listar-puestos');
export const crearPuesto = (datos: object) => fetchAPI(HANDLER, 'crear-puesto', 'POST', datos);
export const actualizarPuesto = (datos: object) => fetchAPI(HANDLER, 'actualizar-puesto', 'POST', datos);
export const eliminarPuesto = (datos: object) => fetchAPI(HANDLER, 'eliminar-puesto', 'POST', datos);