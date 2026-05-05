// app/services/apiClient.ts

// URL Base centralizada. ¡Cámbiala aquí y afectará a toda la app!
const BASE_URL = "http://192.168.0.3:8080/";
/**
 * Función genérica para hacer peticiones al servidor.
 * Maneja los errores de conexión por defecto.
 */
export const fetchAPI = async (
  handlerPath: string,
  action: string,
  method: string = "GET",
  bodyData: any = null,
) => {
  const url = `${BASE_URL}/${handlerPath}?action=${action}`;

  const options: RequestInit = {
    method: method,
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
  };

  if (bodyData && (method === "POST" || method === "PUT")) {
    options.body = JSON.stringify(bodyData);
  }

  try {
    const response = await fetch(url, options);
    const jsonResult = await response.json();
    return jsonResult;
  } catch (error) {
    console.error("API Fetch Error:", error);
    // Puedes lanzar el error para que la pantalla lo maneje o devolver un objeto estándar
    throw new Error("No se pudo conectar con el servidor.");
  }
};
