import { fetchAPI } from '../apiClient';

const HANDLER = 'Handlers/Cliente/CatalogoClienteHandler.ashx';

export const listarProductos = () => fetchAPI(HANDLER, 'listar');
export const listarCategorias = () => fetchAPI(HANDLER, 'categorias');
export const buscarProductos = (texto: string, categoria: number = 0) =>
  fetchAPI(HANDLER, `buscar&texto=${encodeURIComponent(texto)}&categoria=${categoria}`);
export const listarPromociones = () => fetchAPI(HANDLER, 'promociones');
export const detalleProducto = (ref: string) =>
  fetchAPI(HANDLER, `detalle&ref=${encodeURIComponent(ref)}`);