// app/services/almacenService.ts
import { fetchAPI } from "../apiClient";

const HANDLER = "Handlers/CatalogoInventario/AlmacenesHandler.ashx";

export const AlmacenService = {
  listar: async () => {
    return await fetchAPI(HANDLER, "listar", "GET");
  },

  crear: async (nombre: string, pais: string, ubicacion: string) => {
    return await fetchAPI(HANDLER, "crear", "POST", {
      nombre,
      pais,
      ubicacion,
    });
  },

  actualizar: async (
    id: number,
    nombre: string,
    pais: string,
    ubicacion: string,
  ) => {
    return await fetchAPI(HANDLER, "actualizar", "POST", {
      id,
      nombre,
      pais,
      ubicacion,
    });
  },

  eliminar: async (id: number) => {
    return await fetchAPI(HANDLER, "eliminar", "POST", { id });
  },
};
