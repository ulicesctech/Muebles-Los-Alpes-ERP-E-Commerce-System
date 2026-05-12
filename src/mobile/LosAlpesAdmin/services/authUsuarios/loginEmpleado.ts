import { fetchAPI } from "../apiClient";

const HANDLER = 'Handlers/Auth/AuthHandler.ashx';

export const loginEmpleado = (usuario: string, password: string) =>
  fetchAPI(HANDLER, 'login-empleado', 'POST', {usuario, password});