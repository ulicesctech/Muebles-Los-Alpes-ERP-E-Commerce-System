import { fetchAPI } from '../apiClient';

const HANDLER = 'Handlers/Cliente/MisComprasHandler.ashx';

export const listarMisCompras = (clienteId: number) =>
  fetchAPI(HANDLER, `listar&clienteId=${clienteId}`);