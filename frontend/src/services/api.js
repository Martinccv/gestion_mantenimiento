// src/services/api.js
import axios from "axios";

const api = axios.create({
  baseURL: process.env.REACT_APP_API_URL,
});

// Agregar token de autenticación si existe
api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const login = (credentials) => api.post("/auth/login", credentials);
export const crearOrden = (data) => api.post("/maintenance/crear_orden", data);
export const obtenerStock = (idRepuesto) => api.get(`/stock/${idRepuesto}`);

export default api;
