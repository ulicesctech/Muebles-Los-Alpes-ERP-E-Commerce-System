import AsyncStorage from '@react-native-async-storage/async-storage';
import React, { createContext, useContext, useEffect, useState } from 'react';

interface Permisos {
  admin: number;
  rh: number;
  fac: number;
  cli: number;
  bod: number;
  promo: number;
}

interface Usuario {
  id: number;
  nombre: string;
  grupo: number;
  tipo: 'EMPLEADO' | 'CLIENTE';
  permisos?: Permisos;
}

interface AuthContextType {
  usuario: Usuario | null;
  loading: boolean;
  login: (data: Usuario) => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType>({} as AuthContextType);

export const AuthProvider = ({children}: {children: React.ReactNode}) => {
  const [usuario, setUsuario] = useState<Usuario | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const cargarSesion = async () => {
      try {
        const data = await AsyncStorage.getItem('usuario');
        if (data) setUsuario(JSON.parse(data));
      } catch {}
      finally { setLoading(false); }
    };
    cargarSesion();
  }, []);

  const login = async (data: Usuario) => {
    setUsuario(data);
    await AsyncStorage.setItem('usuario', JSON.stringify(data));
  };

  const logout = async () => {
    setUsuario(null);
    await AsyncStorage.removeItem('usuario');
  };

  return (
    <AuthContext.Provider value={{usuario, loading, login, logout}}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);