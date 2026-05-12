import React, { createContext, useContext, useState } from 'react';

interface ItemCarrito {
  hvId: number;
  proReferencia: string;
  proNombre: string;
  precio: number;
  precioOriginal?: number;
  promPorcentaje?: number;
  campNombre?: string;
  cantidad: number;
}

interface CarritoContextType {
  items: ItemCarrito[];
  agregarItem: (item: ItemCarrito) => void;
  eliminarItem: (hvId: number) => void;
  actualizarCantidad: (hvId: number, cantidad: number) => void;
  vaciar: () => void;
  total: number;
}

const CarritoContext = createContext<CarritoContextType>({} as CarritoContextType);

export const CarritoProvider = ({ children }: { children: React.ReactNode }) => {
  const [items, setItems] = useState<ItemCarrito[]>([]);

  const agregarItem = (item: ItemCarrito) => {
    setItems(prev => {
      const existe = prev.find(i => i.hvId === item.hvId);

      if (existe) {
        return prev.map(i =>
          i.hvId === item.hvId
            ? { ...i, cantidad: i.cantidad + item.cantidad }
            : i
        );
      }

      return [...prev, item];
    });
  };

  const eliminarItem = (hvId: number) =>
    setItems(prev => prev.filter(i => i.hvId !== hvId));

  const actualizarCantidad = (hvId: number, cantidad: number) =>
    setItems(prev =>
      prev.map(i =>
        i.hvId === hvId
          ? { ...i, cantidad }
          : i
      )
    );

  const vaciar = () => setItems([]);

  const total = items.reduce((acc, i) => acc + i.precio * i.cantidad, 0);

  return (
    <CarritoContext.Provider
      value={{
        items,
        agregarItem,
        eliminarItem,
        actualizarCantidad,
        vaciar,
        total,
      }}
    >
      {children}
    </CarritoContext.Provider>
  );
};

export const useCarrito = () => useContext(CarritoContext);