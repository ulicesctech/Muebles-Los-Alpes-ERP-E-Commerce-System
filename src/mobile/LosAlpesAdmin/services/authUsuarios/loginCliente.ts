import { fetchAPI } from "../apiClient";

const HANDLER = 'Handlers/Auth/AuthHandler.ashx';

export const loginCliente = (usuario: string, password: string) =>
  fetchAPI(HANDLER, 'login-cliente', 'POST', {usuario, password});

export const registroCliente = (datos: object) =>
  fetchAPI(HANDLER, 'registro', 'POST', datos);