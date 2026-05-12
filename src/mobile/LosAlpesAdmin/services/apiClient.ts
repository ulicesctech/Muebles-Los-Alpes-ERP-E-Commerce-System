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
      if (response.status === 401) {
        throw new Error(jsonResult?.mensaje || "Sesion no valida.");
      }

      if (response.status === 403) {
        throw new Error(jsonResult?.mensaje || "No tienes permisos para realizar esta accion.");
      }

      throw new Error(
        jsonResult?.mensaje ||
        `Error en el servidor (Codigo: ${response.status})`
      );
    }

    if (jsonResult?.status === "error") {
      throw new Error(jsonResult.message);
    }

    if (jsonResult?.ok === false) {
      throw new Error(jsonResult.mensaje || "No se pudo procesar la solicitud.");
    }

    return jsonResult;
  } catch (error: any) {
    console.error("API Fetch Error:", error);
    throw new Error(error.message || "No se pudo conectar con el servidor.");
  }
};