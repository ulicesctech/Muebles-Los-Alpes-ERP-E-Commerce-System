import { fetchAPI } from '../apiClient';

const HANDLER = 'Handlers/CatalogoInventario/PromocionesHandler.ashx';

export const listarCampanas = () =>
  fetchAPI(HANDLER, 'listar-campanas');

export const crearCampana = (datos: {
  nombre: string;
  descripcion: string;
  fechaInicio: string;
  fechaFinal: string;
}) => fetchAPI(HANDLER, 'crear-campana', 'POST', datos);

export const actualizarCampana = (datos: {
  id: number;
  nombre: string;
  descripcion: string;
  estado: string;
  fechaInicio: string;
  fechaFinal: string;
}) => fetchAPI(HANDLER, 'actualizar-campana', 'POST', datos);

export const eliminarCampana = (id: number) =>
  fetchAPI(HANDLER, 'eliminar-campana', 'POST', { id });

export const listarPorCampana = (id: number) =>
  fetchAPI(HANDLER, `listar-por-campana&id=${id}`, 'GET');

export const crearPromo = (datos: {
  campanaId: number;
  proReferencia: string;
  porcentaje: number;
}) => fetchAPI(HANDLER, 'crear-promo', 'POST', datos);

export const eliminarPromo = (id: number) =>
  fetchAPI(HANDLER, 'eliminar-promo', 'POST', { id });