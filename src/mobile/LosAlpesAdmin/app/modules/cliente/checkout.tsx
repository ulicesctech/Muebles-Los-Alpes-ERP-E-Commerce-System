import { router } from 'expo-router';
import React, { useEffect, useState } from 'react';
import {
    ActivityIndicator, Alert, ScrollView, StyleSheet,
    Text, TextInput, TouchableOpacity, View
} from 'react-native';
import { useAuth } from '../../../context/AuthContext';
import { useCarrito } from '../../../context/CarritoContext';
import { agregarDetalle, almacenesConStock, crearCarrito } from '../../../services/cliente/carritoService';
import { crearFactura } from '../../../services/cliente/facturaService';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function CheckoutScreen() {
  const { usuario } = useAuth();
  const { items, total, vaciar } = useCarrito();
  const [tipoEntrega, setTipoEntrega] = useState<'DOMICILIO' | 'SUCURSAL'>('DOMICILIO');
  const [formaPago, setFormaPago] = useState<'EFECTIVO' | 'TARJETA' | 'TRANSFERENCIA'>('EFECTIVO');
  const [almacenes, setAlmacenes] = useState<any[]>([]);
  const [almacenSeleccionado, setAlmacenSeleccionado] = useState<number>(0);
  const [loading, setLoading] = useState(false);
  const [codigoFactura, setCodigoFactura] = useState('');
  const [paso, setPaso] = useState(2);

  useEffect(() => { cargarAlmacenes(); }, []);

  const cargarAlmacenes = async () => {
    try {
      const hvIds = items.map(i => i.hvId).join(',');
      const res = await almacenesConStock(hvIds);
      setAlmacenes(res.data || []);
    } catch {}
  };

  const handleConfirmar = async () => {
    if (tipoEntrega === 'SUCURSAL' && almacenSeleccionado === 0) {
      Alert.alert('Error', 'Selecciona una sucursal.');
      return;
    }
    setLoading(true);
    try {
      const carritoRes = await crearCarrito(usuario!.id);
      const carritoId = carritoRes.carritoId;
      for (const item of items) {
        await agregarDetalle(carritoId, item.hvId, item.cantidad);
      }
      const res = await crearFactura(carritoId, formaPago, tipoEntrega, almacenSeleccionado);
      setCodigoFactura(res.codigoFactura);
      setPaso(3);
      vaciar();
    } catch (e: any) {
      if (e.message.includes('stock') || e.message.includes('Stock')) {
        Alert.alert('Stock insuficiente', 'No hay suficiente stock para uno o más productos. Por favor ajusta las cantidades.');
      } else {
        Alert.alert('Error', e.message);
      }
    } finally { setLoading(false); }
  };

  if (codigoFactura) {
    return (
      <ScrollView style={styles.container}>
        <View style={styles.confirmacionWrap}>
          <Text style={styles.confIcon}>✅</Text>
          <Text style={styles.confTitulo}>¡Pedido confirmado!</Text>
          <Text style={styles.confSub}>Gracias por tu compra. Tu pedido ha sido registrado exitosamente.</Text>
          <View style={styles.confCodigo}>
            <Text style={styles.confCodigoText}>Código: {codigoFactura}</Text>
          </View>
          <Text style={styles.confEntrega}>
            {tipoEntrega === 'DOMICILIO' ? '🏠 Envío a domicilio' : '📍 Retiro en sucursal'}
          </Text>
          <TouchableOpacity style={styles.btnSeguirComprando}
            onPress={() => router.replace('/modules/cliente/catalogo' as any)}>
            <Text style={styles.btnSeguirText}>Seguir comprando</Text>
          </TouchableOpacity>
          <TouchableOpacity style={[styles.btnSeguirComprando, { backgroundColor: GOLD, marginTop: 10 }]}
            onPress={() => router.push('/modules/cliente/misCompras' as any)}>
            <Text style={styles.btnSeguirText}>Ver mis compras</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    );
  }

  return (
    <ScrollView style={styles.container}>
      {/* Steps */}
      <View style={styles.stepsBar}>
        <View style={styles.step}>
          <View style={[styles.stepNum, styles.stepDone]}>
            <Text style={styles.stepNumText}>✓</Text>
          </View>
          <Text style={styles.stepLabel}>Carrito</Text>
        </View>
        <View style={styles.stepLine} />
        <View style={styles.step}>
          <View style={[styles.stepNum, styles.stepActive]}>
            <Text style={styles.stepNumText}>2</Text>
          </View>
          <Text style={[styles.stepLabel, { color: CAFE }]}>Datos de envío</Text>
        </View>
        <View style={styles.stepLine} />
        <View style={styles.step}>
          <View style={[styles.stepNum, styles.stepInactive]}>
            <Text style={[styles.stepNumText, { color: '#888' }]}>3</Text>
          </View>
          <Text style={[styles.stepLabel, { color: '#aaa' }]}>Confirmación</Text>
        </View>
      </View>

      {/* Tipo entrega */}
      <View style={styles.card}>
        <View style={styles.cardHead}>
          <Text style={styles.cardHeadText}>Tipo de entrega</Text>
        </View>
        <View style={styles.cardBody}>
          <View style={styles.entregaToggle}>
            <TouchableOpacity
              style={[styles.entregaBtn, tipoEntrega === 'DOMICILIO' && styles.entregaBtnActive]}
              onPress={() => setTipoEntrega('DOMICILIO')}>
              <Text style={styles.entregaIcon}>🏠</Text>
              <Text style={[styles.entregaBtnText, tipoEntrega === 'DOMICILIO' && styles.entregaBtnTextActive]}>
                Envío a domicilio
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.entregaBtn, tipoEntrega === 'SUCURSAL' && styles.entregaBtnActive]}
              onPress={() => setTipoEntrega('SUCURSAL')}>
              <Text style={styles.entregaIcon}>📍</Text>
              <Text style={[styles.entregaBtnText, tipoEntrega === 'SUCURSAL' && styles.entregaBtnTextActive]}>
                Recoger en sucursal
              </Text>
            </TouchableOpacity>
          </View>

          {tipoEntrega === 'DOMICILIO' && (
            <View style={styles.entregaInfo}>
              <Text style={styles.entregaInfoText}>
                ✓ Te enviaremos el pedido a tu dirección registrada. Entrega gratis.
              </Text>
            </View>
          )}

          {tipoEntrega === 'SUCURSAL' && (
            <View style={styles.sucursalPanel}>
              <Text style={styles.sucursalLabel}>Selecciona la sucursal</Text>
              {almacenes.length === 0
                ? <Text style={styles.sinAlmacen}>No hay sucursales con stock disponible.</Text>
                : almacenes.map(a => (
                  <TouchableOpacity
                    key={a.ALM_ALMACEN}
                    style={[styles.almacenItem, almacenSeleccionado === a.ALM_ALMACEN && styles.almacenItemActive]}
                    onPress={() => setAlmacenSeleccionado(a.ALM_ALMACEN)}>
                    <Text style={[styles.almacenNombre, almacenSeleccionado === a.ALM_ALMACEN && styles.almacenNombreActive]}>
                      {a.ALM_NOMBRE}
                    </Text>
                    <Text style={styles.almacenUbicacion}>{a.ALM_UBICACION}</Text>
                  </TouchableOpacity>
                ))
              }
              <View style={styles.entregaInfo}>
                <Text style={styles.entregaInfoText}>
                  ✓ Solo se muestran sucursales con stock disponible para todos tus productos.
                </Text>
              </View>
            </View>
          )}
        </View>
      </View>

      {/* Forma de pago */}
      <View style={styles.card}>
        <View style={styles.cardHead}>
          <Text style={styles.cardHeadText}>Método de pago</Text>
        </View>
        <View style={styles.cardBody}>
          {(['EFECTIVO', 'TARJETA', 'TRANSFERENCIA'] as const).map(fp => (
            <View key={fp}>
              <TouchableOpacity
                style={[styles.pagoItem, formaPago === fp && styles.pagoItemActive]}
                onPress={() => setFormaPago(fp)}>
                <Text style={styles.pagoIcon}>
                  {fp === 'EFECTIVO' ? '💵' : fp === 'TARJETA' ? '💳' : '🏦'}
                </Text>
                <Text style={[styles.pagoText, formaPago === fp && styles.pagoTextActive]}>
                  {fp === 'EFECTIVO' ? 'Efectivo al recibir' : fp === 'TARJETA' ? 'Tarjeta de crédito' : 'Transferencia bancaria'}
                </Text>
                {formaPago === fp && <Text style={styles.pagoCheck}>✓</Text>}
              </TouchableOpacity>
              {fp === 'TARJETA' && formaPago === 'TARJETA' && (
                <View style={styles.tarjetaPanel}>
                  <Text style={styles.tarjetaLabel}>NÚMERO DE TARJETA</Text>
                  <TextInput style={styles.tarjetaInput} placeholder="**** **** **** ****" keyboardType="numeric" maxLength={19} />
                  <Text style={styles.tarjetaLabel}>NOMBRE EN LA TARJETA</Text>
                  <TextInput style={styles.tarjetaInput} placeholder="Como aparece en la tarjeta" autoCapitalize="characters" />
                  <View style={{ flexDirection: 'row', gap: 12 }}>
                    <View style={{ flex: 1 }}>
                      <Text style={styles.tarjetaLabel}>VENCIMIENTO</Text>
                      <TextInput style={styles.tarjetaInput} placeholder="MM/AA" keyboardType="numeric" maxLength={5} />
                    </View>
                    <View style={{ flex: 1 }}>
                      <Text style={styles.tarjetaLabel}>CVV</Text>
                      <TextInput style={styles.tarjetaInput} placeholder="***" keyboardType="numeric" maxLength={4} secureTextEntry />
                    </View>
                  </View>
                </View>
              )}
            </View>
          ))}
        </View>
      </View>

      {/* Resumen */}
      <View style={styles.card}>
        <View style={styles.cardHead}>
          <Text style={styles.cardHeadText}>Resumen del pedido</Text>
        </View>
        <View style={styles.cardBody}>
          {items.map(item => (
            <View key={item.hvId} style={styles.resumenItem}>
              <View style={{ flex: 1 }}>
                <Text style={styles.resumenNombre}>{item.proNombre}</Text>
                <Text style={styles.resumenCant}>Cant: {item.cantidad}</Text>
              </View>
              <Text style={styles.resumenPrecio}>Q {(item.precio * item.cantidad).toFixed(2)}</Text>
            </View>
          ))}
          <View style={styles.resumenDivider} />
          <View style={styles.resumenRow}>
            <Text style={styles.resumenLabel}>Envío</Text>
            <Text style={styles.resumenGratis}>Gratis</Text>
          </View>
          <View style={[styles.resumenRow, styles.resumenTotal]}>
            <Text style={styles.resumenTotalLabel}>Total</Text>
            <Text style={styles.resumenTotalValor}>Q {total.toFixed(2)}</Text>
          </View>
          <TouchableOpacity style={styles.btnConfirmar} onPress={handleConfirmar} disabled={loading}>
            {loading ? <ActivityIndicator color="white" /> :
              <Text style={styles.btnConfirmarText}>✓ Confirmar Pedido</Text>}
          </TouchableOpacity>
          <TouchableOpacity style={styles.btnVolver} onPress={() => router.back()}>
            <Text style={styles.btnVolverText}>← Volver al carrito</Text>
          </TouchableOpacity>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0' },
  stepsBar: { flexDirection: 'row', alignItems: 'center', padding: 20, backgroundColor: 'white', borderBottomWidth: 1, borderBottomColor: '#e8d8c0' },
  step: { alignItems: 'center', gap: 4 },
  stepNum: { width: 32, height: 32, borderRadius: 16, alignItems: 'center', justifyContent: 'center' },
  stepDone: { backgroundColor: '#276749' },
  stepActive: { backgroundColor: GOLD },
  stepInactive: { backgroundColor: '#e8d8c0' },
  stepNumText: { color: 'white', fontWeight: 'bold', fontSize: 14 },
  stepLabel: { fontSize: 11, fontWeight: 'bold', color: '#276749' },
  stepLine: { flex: 1, height: 2, backgroundColor: '#e8d8c0', marginHorizontal: 8 },
  card: { backgroundColor: 'white', borderRadius: 12, borderWidth: 1, borderColor: '#e8d8c0', margin: 16, marginBottom: 0, overflow: 'hidden', elevation: 2 },
  cardHead: { backgroundColor: CAFE, padding: 14 },
  cardHeadText: { color: '#f0d9a0', fontSize: 14, fontWeight: 'bold' },
  cardBody: { padding: 20 },
  entregaToggle: { flexDirection: 'row', gap: 12, marginBottom: 16 },
  entregaBtn: { flex: 1, padding: 14, borderRadius: 10, borderWidth: 2, borderColor: '#e8d8c0', alignItems: 'center', backgroundColor: 'white' },
  entregaBtnActive: { borderColor: GOLD, backgroundColor: '#fdf6ec' },
  entregaIcon: { fontSize: 24, marginBottom: 6 },
  entregaBtnText: { fontSize: 13, fontWeight: 'bold', color: CAFE, textAlign: 'center' },
  entregaBtnTextActive: { color: GOLD },
  entregaInfo: { backgroundColor: '#f0fff4', borderWidth: 1, borderColor: '#9ae6b4', borderRadius: 8, padding: 12 },
  entregaInfoText: { fontSize: 13, color: '#276749' },
  sucursalPanel: { backgroundColor: '#fdf8f3', borderRadius: 10, borderWidth: 1, borderColor: '#e8d8c0', padding: 16, gap: 10 },
  sucursalLabel: { fontSize: 11, fontWeight: 'bold', color: CAFE, textTransform: 'uppercase', letterSpacing: 0.4 },
  sinAlmacen: { fontSize: 13, color: '#888', textAlign: 'center' },
  almacenItem: { padding: 12, borderRadius: 8, borderWidth: 1.5, borderColor: '#e8d8c0', marginBottom: 8 },
  almacenItemActive: { backgroundColor: GOLD, borderColor: GOLD },
  almacenNombre: { fontSize: 14, fontWeight: 'bold', color: '#333' },
  almacenNombreActive: { color: 'white' },
  almacenUbicacion: { fontSize: 12, color: '#888', marginTop: 2 },
  pagoItem: { flexDirection: 'row', alignItems: 'center', padding: 14, borderRadius: 8, borderWidth: 1.5, borderColor: '#e8d8c0', marginBottom: 8, gap: 12 },
  pagoItemActive: { borderColor: GOLD, backgroundColor: '#fdf6ec' },
  pagoIcon: { fontSize: 20 },
  pagoText: { flex: 1, fontSize: 14, color: '#555', fontWeight: 'bold' },
  pagoTextActive: { color: CAFE },
  pagoCheck: { fontSize: 16, color: GOLD, fontWeight: 'bold' },
  tarjetaPanel: { backgroundColor: '#fdf8f3', borderRadius: 10, borderWidth: 1, borderColor: '#e8d8c0', padding: 16, marginBottom: 8, marginTop: -4 },
  tarjetaLabel: { fontSize: 11, fontWeight: 'bold', color: CAFE, textTransform: 'uppercase', letterSpacing: 0.4, marginBottom: 5, marginTop: 8 },
  tarjetaInput: { borderWidth: 2, borderColor: '#e8d8c0', borderRadius: 8, padding: 10, fontSize: 14, backgroundColor: 'white' },
  resumenItem: { flexDirection: 'row', justifyContent: 'space-between', paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: '#f5ece0' },
  resumenNombre: { fontSize: 13, fontWeight: 'bold', color: '#3a2a1a' },
  resumenCant: { fontSize: 11, color: '#888', marginTop: 2 },
  resumenPrecio: { fontSize: 14, fontWeight: 'bold', color: CAFE },
  resumenDivider: { borderTopWidth: 1, borderTopColor: '#e8d8c0', marginVertical: 10 },
  resumenRow: { flexDirection: 'row', justifyContent: 'space-between', paddingVertical: 6 },
  resumenLabel: { fontSize: 14, color: '#555' },
  resumenGratis: { fontSize: 14, fontWeight: 'bold', color: '#276749' },
  resumenTotal: { borderTopWidth: 1, borderTopColor: '#e8d8c0', marginTop: 6, paddingTop: 12 },
  resumenTotalLabel: { fontSize: 18, fontWeight: 'bold', color: '#3a2a1a' },
  resumenTotalValor: { fontSize: 20, fontWeight: 'bold', color: CAFE },
  btnConfirmar: { backgroundColor: '#276749', padding: 16, borderRadius: 8, alignItems: 'center', marginTop: 16 },
  btnConfirmarText: { color: 'white', fontSize: 16, fontWeight: 'bold' },
  btnVolver: { alignItems: 'center', marginTop: 10, padding: 10 },
  btnVolverText: { color: GOLD, fontSize: 13 },
  confirmacionWrap: { alignItems: 'center', padding: 40 },
  confIcon: { fontSize: 80, marginBottom: 16 },
  confTitulo: { fontSize: 28, fontWeight: 'bold', color: '#276749', marginBottom: 8 },
  confSub: { fontSize: 15, color: '#555', textAlign: 'center', marginBottom: 24 },
  confCodigo: { backgroundColor: '#f0fff4', borderWidth: 2, borderColor: '#48bb78', borderRadius: 8, padding: 16, marginBottom: 16 },
  confCodigoText: { fontSize: 18, fontWeight: 'bold', color: '#276749' },
  confEntrega: { fontSize: 14, color: '#555', marginBottom: 30 },
  btnSeguirComprando: { backgroundColor: GOLD, paddingHorizontal: 32, paddingVertical: 14, borderRadius: 8, width: '100%', alignItems: 'center' },
  btnSeguirText: { color: 'white', fontWeight: 'bold', fontSize: 14 },
});