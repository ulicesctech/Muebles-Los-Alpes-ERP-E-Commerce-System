import { fetchAPI } from "../apiClient";

const HANDLER = 'Handlers/Auth/AuthHandler.ashx';

export const listarEmpleados = () => fetchAPI(HANDLER, 'listar-empleados');
export const crearEmpleado = (datos: object) => fetchAPI(HANDLER, 'crear-empleado', 'POST', datos);
export const actualizarEmpleado = (datos: object) => fetchAPI(HANDLER, 'actualizar-empleado', 'POST', datos);
export const eliminarEmpleado = (datos: object) => fetchAPI(HANDLER, 'eliminar-empleado', 'POST', datos);