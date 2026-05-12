import { fetchAPI } from '../apiClient';

const HANDLER = 'Handlers/Cliente/PerfilClienteHandler.ashx';

export const obtenerPerfil = (clienteId: number) =>
  fetchAPI(HANDLER, `obtener&clienteId=${clienteId}`);

export const actualizarPerfil = (clienteId: number, datos: any) => {
  const params = new URLSearchParams({ clienteId: String(clienteId), ...datos }).toString();
  return fetchAPI(HANDLER, `actualizar&${params}`, 'POST');
};