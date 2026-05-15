import { fetchAPI } from '../apiClient';

const HANDLER_PATH = 'Handlers/Cliente/PerfilClienteHandler.ashx';

export const obtenerPerfil = async () => {
  return await fetchAPI(HANDLER_PATH, 'obtener', 'GET');
};

export const actualizarPerfil = async (data: any) => {
  const params = new URLSearchParams({
    tipoDoc: data.tipoDoc || '',
    numDoc: data.numDoc || '',
    primerNombre: data.primerNombre || '',
    segundoNombre: data.segundoNombre || '',
    primerApellido: data.primerApellido || '',
    segundoApellido: data.segundoApellido || '',
    email: data.email || '',
    profesion: data.profesion || '',
    tel1: data.tel1 || '',
    tel2: data.tel2 || '',
    pais: data.pais || '',
    departamento: data.departamento || '',
    municipio: data.municipio || '',
    zona: data.zona || '',
    codigoPostal: data.codigoPostal || '',
    direccion: data.direccion || '',
    tipoCliente: data.tipoCliente || 'NATURAL',
  }).toString();

  return await fetchAPI(HANDLER_PATH, `actualizar&${params}`, 'POST');
};