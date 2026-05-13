// app/services/apiClient.ts

import AsyncStorage from '@react-native-async-storage/async-storage';

const BASE_URL = "http://10.0.2.2:61850";
const SESSION_KEY = "ASP_NET_SESSION_COOKIE";

let sessionCookie: string | null = null;

const cargarCookieSesion = async () => {
  if (!sessionCookie) {
    sessionCookie = await AsyncStorage.getItem(SESSION_KEY);
  }
};

const guardarCookieSesion = async (sessionId: string) => {
  sessionCookie = `ASP.NET_SessionId=${sessionId}`;
  await AsyncStorage.setItem(SESSION_KEY, sessionCookie);
  console.log("Sesion ASP.NET guardada:", sessionCookie);
};

export const limpiarSesionAPI = async () => {
  sessionCookie = null;
  await AsyncStorage.removeItem(SESSION_KEY);
};

const obtenerMensajeError = (status: number, jsonResult: any) => {
  const mensajeBackend =
    jsonResult?.mensaje ||
    jsonResult?.message ||
    jsonResult?.error ||
    "";

  if (status === 400) {
    return mensajeBackend || "La solicitud enviada no es valida.";
  }

  if (status === 401) {
    return mensajeBackend || "Credenciales invalidas. Verifica tu usuario y contrasena.";
  }

  if (status === 403) {
    return mensajeBackend || "No tienes permisos para realizar esta accion.";
  }

  if (status === 404) {
    return "No se encontro el recurso solicitado.";
  }

  if (status === 405) {
    return "Metodo no permitido para esta accion.";
  }

  if (status === 409) {
    return mensajeBackend || "Ya existe un registro con esos datos.";
  }

  if (status >= 500) {
    return mensajeBackend || "Ocurrio un error en el servidor. Intenta nuevamente.";
  }

  return mensajeBackend || "No se pudo procesar la solicitud.";
};

export const fetchAPI = async (
  handlerPath: string,
  action: string,
  method: string = "GET",
  bodyData: any = null,
) => {
  await cargarCookieSesion();

  const url = `${BASE_URL.replace(/\/$/, "")}/${handlerPath}?action=${action}`;

  const headers: Record<string, string> = {
    "Content-Type": "application/json",
    Accept: "application/json",
  };

  if (sessionCookie) {
    headers.Cookie = sessionCookie;
  }

  console.log("Cookie enviada:", sessionCookie);

  const options: RequestInit = {
    method,
    credentials: "include",
    headers,
  };

  if (bodyData && (method === "POST" || method === "PUT")) {
    options.body = JSON.stringify(bodyData);
  }

  try {
    const response = await fetch(url, options);

    let jsonResult: any = null;

    try {
      jsonResult = await response.json();
    } catch {
      jsonResult = null;
    }

    console.log("RESPUESTA API:", handlerPath, action, jsonResult);

    if (jsonResult?.sessionId) {
      await guardarCookieSesion(jsonResult.sessionId);
    }

    if (!response.ok) {
      const mensaje = obtenerMensajeError(response.status, jsonResult);
      throw new Error(mensaje);
    }

    if (jsonResult?.status === "error") {
      throw new Error(jsonResult.message || "No se pudo procesar la solicitud.");
    }

    if (jsonResult?.ok === false) {
      throw new Error(jsonResult.mensaje || "No se pudo procesar la solicitud.");
    }

    return jsonResult;
  } catch (error: any) {
    console.log("API Fetch Error:", error);

    const mensaje = error?.message || "";

    if (
      mensaje.includes("Network request failed") ||
      mensaje.includes("Failed to fetch") ||
      mensaje.includes("NetworkError")
    ) {
      throw new Error("No se pudo conectar con el servidor. Verifica que IIS este encendido.");
    }

    throw new Error(mensaje || "No se pudo procesar la solicitud.");
  }
};