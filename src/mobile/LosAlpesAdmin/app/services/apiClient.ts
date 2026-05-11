// app/services/apiClient.ts

// URL Base centralizada. ¡Cámbiala aquí y afectará a toda la app!
const BASE_URL = "http://192.168.1.24:8080";

/**
 * Función genérica para hacer peticiones al servidor.
 * Maneja los errores de conexión por defecto y límites de peticiones.
 */
export const fetchAPI = async (
  handlerPath: string,
  action: string,
  method: string = "GET",
  bodyData: any = null,
) => {
  // Ajuste para evitar dobles barras en la URL si BASE_URL terminaba en "/"
  const url = `${BASE_URL.replace(/\/$/, "")}/${handlerPath}?action=${action}`;

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

    // 1. INTERCEPTAR ERRORES HTTP (Ej. El bloqueo de IIS)
    if (!response.ok) {
      // Si IIS bloqueó la IP, el status será 403
      if (response.status === 403) {
        // Leemos tu archivo error_limite.json
        const errorData = await response.json();
        // Lanzamos el error con el mensaje de tu JSON
        throw new Error(
          errorData.message ||
            "Demasiadas peticiones. Por favor, espere un momento.",
        );
      }

      // Manejo para otros errores del servidor (500, 404, etc.)
      throw new Error(`Error en el servidor (Código: ${response.status})`);
    }

    // 2. SI TODO ESTÁ BIEN (Código 200)
    const jsonResult = await response.json();

    // 3. Evaluar si tu VB.NET devolvió un error controlado (status: "error")
    if (jsonResult.status === "error") {
      throw new Error(jsonResult.message);
    }

    return jsonResult;
  } catch (error: any) {
    console.error("API Fetch Error:", error);
    // Lanzamos el mensaje exacto del error que capturamos arriba.
    // Si es un error de red (sin internet), usamos tu mensaje por defecto.
    throw new Error(error.message || "No se pudo conectar con el servidor.");
  }
};
