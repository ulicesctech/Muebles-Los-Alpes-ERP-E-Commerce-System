import { fetchAPI } from "../apiClient";

const HANDLER = 'Handlers/Auth/AuthHandler.ashx';

export const listarClientes = () => fetchAPI(HANDLER, 'listar-clientes');
export const crearCliente = (datos: object) => fetchAPI(HANDLER, 'crear-cliente', 'POST', datos);
export const actualizarCliente = (datos: object) => fetchAPI(HANDLER, 'actualizar-cliente', 'POST', datos);
export const eliminarCliente = (datos: object) => fetchAPI(HANDLER, 'eliminar-cliente', 'POST', datos);