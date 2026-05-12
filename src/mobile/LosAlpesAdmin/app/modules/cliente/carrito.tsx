import { router } from 'expo-router';
import React from 'react';
import {
  Image, ScrollView, StyleSheet,
  Text, TouchableOpacity, View
} from 'react-native';
import { useCarrito } from '../../../context/CarritoContext';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';
const BASE = 'http://10.0.2.2:61850';

export default function CarritoScreen() {
  const { items, eliminarItem, actualizarCantidad, total } = useCarrito();

  const totalProductos = items.reduce((acc, item) => acc + item.cantidad, 0);

  if (items.length === 0) {
    return (
      <View style={styles.vacio}>
        <Text style={styles.vacioIcon}>🛒</Text>
        <Text style={styles.vacioTitulo}>Tu carrito está vacío.</Text>
        <Text style={styles.vacioSub}>Agrega productos desde el catálogo para comenzar.</Text>
        <TouchableOpacity style={styles.btnCatalogo} onPress={() => router.back()}>
          <Text style={styles.btnCatalogoText}>Ver Catálogo</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <ScrollView style={styles.scroll} contentContainerStyle={styles.scrollContent}>
        <Text style={styles.pageTitle}>Mi Carrito</Text>

        {/* Tarjeta productos */}
        <View style={styles.cartMain}>
          <View style={styles.cartHead}>
            <Text style={styles.cartHeadTitle}>Productos en tu carrito</Text>
            <Text style={styles.cartHeadSub}>{totalProductos} artículo(s)</Text>
          </View>

          {items.map(item => {
            const tienePromo =
              !!item.promPorcentaje &&
              !!item.precioOriginal &&
              item.precioOriginal > item.precio;

            return (
              <View key={item.hvId} style={styles.cartItem}>
                <Image
                  source={{ uri: `${BASE}/Handlers/CatalogoInventario/FotoProductoHandler.ashx?ref=${item.proReferencia}` }}
                  style={styles.itemImg}
                  resizeMode="cover"
                />

                <View style={styles.itemCenter}>
                  <Text style={styles.itemNombre}>{item.proNombre}</Text>
                  <Text style={styles.itemStock}>✓ En stock</Text>
                  <Text style={styles.itemCantText}>Cant: {item.cantidad}</Text>

                  <View style={styles.itemControles}>
                    <View style={styles.qtyWrap}>
                      <TouchableOpacity
                        style={styles.ctrlBtn}
                        onPress={() => item.cantidad > 1
                          ? actualizarCantidad(item.hvId, item.cantidad - 1)
                          : eliminarItem(item.hvId)}
                      >
                        <Text style={styles.ctrlText}>−</Text>
                      </TouchableOpacity>

                      <Text style={styles.cantidad}>{item.cantidad}</Text>

                      <TouchableOpacity
                        style={styles.ctrlBtn}
                        onPress={() => actualizarCantidad(item.hvId, item.cantidad + 1)}
                      >
                        <Text style={styles.ctrlText}>+</Text>
                      </TouchableOpacity>
                    </View>

                    <Text style={styles.sep}>|</Text>

                    <TouchableOpacity onPress={() => eliminarItem(item.hvId)}>
                      <Text style={styles.btnEliminar}>Eliminar</Text>
                    </TouchableOpacity>
                  </View>
                </View>

                <View style={styles.itemPrecio}>
                  {tienePromo && (
                    <View style={styles.promoBadges}>
                      <Text style={styles.badgePct}>-{item.promPorcentaje}%</Text>
                      <Text style={styles.badgePromo}>{item.campNombre}</Text>
                    </View>
                  )}

                  <Text style={[styles.precioFinal, tienePromo && styles.precioPromo]}>
                    Q {item.precio.toFixed(2)}
                  </Text>

                  {tienePromo && (
                    <>
                      <Text style={styles.precioRecomendado}>Precio recomendado:</Text>
                      <Text style={styles.precioOriginal}>Q {item.precioOriginal?.toFixed(2)}</Text>
                    </>
                  )}

                  <Text style={styles.precioSub}>x{item.cantidad}</Text>
                  <Text style={styles.subtotal}>Q {(item.precio * item.cantidad).toFixed(2)}</Text>
                </View>
              </View>
            );
          })}
        </View>

        {/* Resumen */}
        <View style={styles.resumenCard}>
          <View style={styles.resumenHead}>
            <Text style={styles.resumenHeadText}>Resumen del pedido</Text>
          </View>

          <View style={styles.resumenBody}>
            {items.map(item => {
              const tienePromo =
                !!item.promPorcentaje &&
                !!item.precioOriginal &&
                item.precioOriginal > item.precio;

              return (
                <View key={`resumen-${item.hvId}`} style={styles.resumenProducto}>
                  {tienePromo && (
                    <View style={styles.resumenPromoBadges}>
                      <Text style={styles.badgePct}>-{item.promPorcentaje}%</Text>
                      <Text style={styles.badgePromo}>🛍️ {item.campNombre}</Text>
                    </View>
                  )}

                  <Text style={[styles.resumenPrecioProducto, tienePromo && styles.precioPromo]}>
                    Q {(item.precio * item.cantidad).toFixed(2)}
                  </Text>

                  {tienePromo && (
                    <>
                      <Text style={styles.precioRecomendado}>Precio recomendado:</Text>
                      <Text style={styles.precioOriginal}>
                        Q {(item.precioOriginal! * item.cantidad).toFixed(2)}
                      </Text>
                    </>
                  )}
                </View>
              );
            })}

            <View style={styles.resumenRow}>
              <Text style={styles.resumenLabel}>Envío</Text>
              <Text style={styles.resumenGratis}>Gratis</Text>
            </View>

            <View style={styles.resumenDivider} />

            <View style={styles.resumenTotal}>
              <Text style={styles.resumenTotalLabel}>
                Total ({totalProductos} producto(s))
              </Text>
              <Text style={styles.resumenTotalValor}>Q {total.toFixed(2)}</Text>
            </View>

            <TouchableOpacity
              style={styles.btnPagar}
              onPress={() => router.push('/modules/cliente/checkout' as any)}
            >
              <Text style={styles.btnPagarText}>✓ Proceder al Pago</Text>
            </TouchableOpacity>

            <TouchableOpacity style={styles.btnSeguir} onPress={() => router.back()}>
              <Text style={styles.btnSeguirText}>← Seguir comprando</Text>
            </TouchableOpacity>
          </View>
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f0ebe0',
  },
  scroll: {
    flex: 1,
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 40,
  },
  pageTitle: {
    fontSize: 24,
    fontFamily: 'serif',
    fontWeight: 'bold',
    color: '#3a2a1a',
    marginBottom: 16,
  },

  vacio: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'white',
    margin: 16,
    borderRadius: 12,
    padding: 40,
    borderWidth: 1,
    borderColor: '#e8d8c0',
  },
  vacioIcon: {
    fontSize: 64,
    marginBottom: 12,
  },
  vacioTitulo: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
  },
  vacioSub: {
    fontSize: 13,
    color: '#aaa',
    textAlign: 'center',
    marginBottom: 20,
  },
  btnCatalogo: {
    backgroundColor: GOLD,
    paddingHorizontal: 28,
    paddingVertical: 12,
    borderRadius: 8,
  },
  btnCatalogoText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 14,
  },

  cartMain: {
    backgroundColor: 'white',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#e8d8c0',
    overflow: 'hidden',
    elevation: 2,
    marginBottom: 20,
  },
  cartHead: {
    backgroundColor: CAFE,
    paddingVertical: 16,
    paddingHorizontal: 18,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  cartHeadTitle: {
    color: '#f0d9a0',
    fontSize: 16,
    fontFamily: 'serif',
    fontWeight: 'bold',
  },
  cartHeadSub: {
    color: '#d4b896',
    fontSize: 12,
  },

  cartItem: {
    backgroundColor: 'white',
    flexDirection: 'row',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#f5ece0',
    gap: 12,
    alignItems: 'flex-start',
  },
  itemImg: {
    width: 96,
    height: 96,
    borderRadius: 8,
    backgroundColor: '#fdf8f3',
    borderWidth: 1,
    borderColor: '#e8d8c0',
  },
  itemCenter: {
    flex: 1,
  },
  itemNombre: {
    fontSize: 14,
    fontFamily: 'serif',
    fontWeight: 'bold',
    color: '#3a2a1a',
    marginBottom: 4,
  },
  itemStock: {
    fontSize: 12,
    color: '#276749',
    fontWeight: 'bold',
    marginBottom: 6,
  },
  itemCantText: {
    fontSize: 12,
    color: '#888',
    marginBottom: 8,
  },
  itemControles: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    flexWrap: 'wrap',
  },
  qtyWrap: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#d5d9d9',
    borderRadius: 8,
    overflow: 'hidden',
  },
  ctrlBtn: {
    width: 32,
    height: 32,
    backgroundColor: '#f0f2f2',
    alignItems: 'center',
    justifyContent: 'center',
  },
  ctrlText: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
  },
  cantidad: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#3a2a1a',
    minWidth: 36,
    textAlign: 'center',
  },
  sep: {
    color: '#d5d9d9',
  },
  btnEliminar: {
    color: GOLD,
    fontSize: 12,
    fontWeight: 'bold',
    textDecorationLine: 'underline',
  },
  itemPrecio: {
    alignItems: 'flex-end',
    minWidth: 100,
  },
  promoBadges: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
    justifyContent: 'flex-end',
    marginBottom: 4,
    flexWrap: 'wrap',
  },
  badgePct: {
    backgroundColor: '#e53e3e',
    color: 'white',
    fontSize: 10,
    fontWeight: 'bold',
    paddingHorizontal: 7,
    paddingVertical: 2,
    borderRadius: 4,
  },
  badgePromo: {
    backgroundColor: '#fff3cd',
    color: '#856404',
    fontSize: 10,
    fontWeight: 'bold',
    paddingHorizontal: 7,
    paddingVertical: 2,
    borderRadius: 4,
  },
  precioFinal: {
    fontSize: 18,
    fontFamily: 'serif',
    fontWeight: 'bold',
    color: CAFE,
  },
  precioPromo: {
    color: '#B12704',
  },
  precioRecomendado: {
    fontSize: 11,
    color: '#888',
    marginTop: 2,
  },
  precioOriginal: {
    fontSize: 12,
    color: '#aaa',
    textDecorationLine: 'line-through',
  },
  precioSub: {
    fontSize: 11,
    color: '#888',
    marginTop: 2,
  },
  subtotal: {
    fontSize: 13,
    fontWeight: 'bold',
    color: '#333',
    marginTop: 4,
  },

  resumenCard: {
    backgroundColor: 'white',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#e8d8c0',
    overflow: 'hidden',
    elevation: 2,
  },
  resumenHead: {
    backgroundColor: CAFE,
    paddingVertical: 14,
    paddingHorizontal: 18,
  },
  resumenHeadText: {
    color: '#f0d9a0',
    fontSize: 15,
    fontFamily: 'serif',
    fontWeight: 'bold',
  },
  resumenBody: {
    padding: 20,
  },
  resumenProducto: {
    marginBottom: 10,
    paddingBottom: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#f5ece0',
  },
  resumenPromoBadges: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
    flexWrap: 'wrap',
    marginBottom: 4,
  },
  resumenPrecioProducto: {
    fontSize: 20,
    fontFamily: 'serif',
    fontWeight: 'bold',
    color: CAFE,
  },
  resumenRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 6,
  },
  resumenLabel: {
    fontSize: 14,
    color: '#555',
  },
  resumenGratis: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#276749',
  },
  resumenDivider: {
    borderTopWidth: 1,
    borderTopColor: '#e8d8c0',
    marginVertical: 10,
  },
  resumenTotal: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 10,
  },
  resumenTotalLabel: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#3a2a1a',
    flex: 1,
  },
  resumenTotalValor: {
    fontSize: 20,
    fontFamily: 'serif',
    fontWeight: 'bold',
    color: CAFE,
  },
  btnPagar: {
    backgroundColor: '#276749',
    padding: 16,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 14,
  },
  btnPagarText: {
    color: 'white',
    fontSize: 15,
    fontWeight: 'bold',
  },
  btnSeguir: {
    backgroundColor: '#fdf6ec',
    borderWidth: 2,
    borderColor: '#e8d8c0',
    padding: 12,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 8,
  },
  btnSeguirText: {
    color: GOLD,
    fontSize: 13,
    fontWeight: 'bold',
  },
});