import { fetchAPI } from "../apiClient";

const HANDLER_PATH = "Handlers/ComprasProveedor/FacturaProveedorHandler.ashx";

// ✅ Campos reales que devuelve FAC_PROV_LISTAR / FAC_PROV_BUSCAR / FAC_PROV_BUSCAR_FILTRO:
//    orc_orden_compra | facpro_codigo_factura | facpro_fecha | orc_codigo
//    ⚠️ FACPRO_FACTURA no existe — la PK real es orc_orden_compra (FK a BOD_ORDEN_COMPRA)
//    ⚠️ PROV_NOMBRE no existe — Oracle no hace JOIN a proveedor en este listar
export interface FacturaProveedor {
  ORC_ORDEN_COMPRA: string;      // PK funcional — es la FK de la factura
  FACPRO_CODIGO_FACTURA: string;
  FACPRO_FECHA: string;
  ORC_CODIGO: string;
  // PROV_NOMBRE no viene — si se necesita, hay que modificar el paquete Oracle
}

export const getFacturasProveedor = async (): Promise<FacturaProveedor[]> => {
  return await fetchAPI(HANDLER_PATH, "listar", "GET");
};

export const buscarFacturasProveedor = async (texto: string): Promise<FacturaProveedor[]> => {
  return await fetchAPI(HANDLER_PATH, `buscar&texto=${encodeURIComponent(texto)}`, "GET");
};

export const buscarFacturasFiltro = async (
  texto: string,
  fechaDesde?: string,
  fechaHasta?: string
): Promise<FacturaProveedor[]> => {
  let action = `buscarFiltro&texto=${encodeURIComponent(texto)}`;
  if (fechaDesde) action += `&fecha_desde=${encodeURIComponent(fechaDesde)}`;
  if (fechaHasta) action += `&fecha_hasta=${encodeURIComponent(fechaHasta)}`;
  return await fetchAPI(HANDLER_PATH, action, "GET");
};

export const registrarFactura = async (orcKey: string, codigoFactura: string) => {
  const action = `registrar&orc_key=${encodeURIComponent(orcKey)}&codigo_factura=${encodeURIComponent(codigoFactura)}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

export const actualizarFactura = async (
  orcKeyOld: string, orcKeyNew: string, codigoFactura: string
) => {
  const action = `actualizar&orc_key_old=${encodeURIComponent(orcKeyOld)}&orc_key_new=${encodeURIComponent(orcKeyNew)}&codigo_factura=${encodeURIComponent(codigoFactura)}`;
  return await fetchAPI(HANDLER_PATH, action, "POST");
};

export const eliminarFactura = async (orcKey: string) => {
  return await fetchAPI(HANDLER_PATH, `eliminar&orc_key=${encodeURIComponent(orcKey)}`, "POST");
};