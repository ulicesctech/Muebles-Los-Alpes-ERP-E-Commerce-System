import { router } from 'expo-router';
import React, { useEffect, useState } from 'react';
import {
  ActivityIndicator, Alert, ScrollView, StyleSheet,
  Text, TextInput, TouchableOpacity, View
} from 'react-native';
import { useAuth } from '../../../context/AuthContext';
import { actualizarPerfil, obtenerPerfil } from '../../../services/cliente/perfilService';

const CAFE = '#5C3A1E';
const GOLD = '#C9973A';

export default function MiPerfilScreen() {
  const { usuario } = useAuth();
  const [loading, setLoading] = useState(true);
  const [guardando, setGuardando] = useState(false);
  const [perfil, setPerfil] = useState<any>(null);

  useEffect(() => {
    if (usuario) {
      cargar();
    }
  }, [usuario]);

  const cargar = async () => {
    try {
      setLoading(true);

      const res = await obtenerPerfil();

      if (res.ok && res.data) {
        setPerfil(res.data);
      } else {
        setPerfil(null);
        Alert.alert('Error', res.mensaje || 'No se pudo cargar el perfil.');
      }
    } catch (e: any) {
      setPerfil(null);
      Alert.alert('Error', e.message);
    } finally {
      setLoading(false);
    }
  };

  const handleGuardar = async () => {
    if (!perfil) {
      Alert.alert('Error', 'No hay datos de perfil para guardar.');
      return;
    }

    setGuardando(true);

    try {
      await actualizarPerfil({
        tipoDoc: perfil.CLI_TIPODOCUMENTO,
        numDoc: perfil.CLI_NUMDOCUMENTO,
        primerNombre: perfil.CLI_PRIMER_NOMBRE,
        segundoNombre: perfil.CLI_SEGUNDO_NOMBRE,
        primerApellido: perfil.CLI_PRIMER_APELLIDO,
        segundoApellido: perfil.CLI_SEGUNDO_APELLIDO,
        email: perfil.CLI_EMAIL,
        profesion: perfil.CLI_PROFESION,
        tel1: perfil.CLI_PRIMER_TELEFONO,
        tel2: perfil.CLI_SEGUNDO_TELEFONO,
        pais: perfil.CLI_PAIS,
        departamento: perfil.CLI_DEPARTAMENTO,
        municipio: perfil.CLI_MUNICIPIO,
        zona: perfil.CLI_ZONA,
        codigoPostal: perfil.CLI_CODIGO_POSTAL,
        direccion: perfil.CLI_DIRECCION,
        tipoCliente: perfil.CLI_TIPOCLIENTE || 'NATURAL',
      });

      Alert.alert('Éxito', 'Datos actualizados correctamente.');
      await cargar();
    } catch (e: any) {
      Alert.alert('Error', e.message);
    } finally {
      setGuardando(false);
    }
  };

  const update = (campo: string, valor: string) => {
    setPerfil((prev: any) => ({ ...(prev || {}), [campo]: valor }));
  };

  if (!usuario) {
    return (
      <View style={styles.noLogin}>
        <Text style={styles.noLoginIcon}>🔒</Text>
        <Text style={styles.noLoginText}>Debes iniciar sesión para ver tu perfil.</Text>
        <TouchableOpacity style={styles.btnLogin} onPress={() => router.push('/(auth)/login')}>
          <Text style={styles.btnLoginText}>Iniciar sesión</Text>
        </TouchableOpacity>
      </View>
    );
  }

  if (loading) {
    return (
      <View style={styles.loadingBox}>
        <ActivityIndicator color={CAFE} size="large" />
        <Text style={styles.loadingText}>Cargando perfil...</Text>
      </View>
    );
  }

  if (!perfil) {
    return (
      <View style={styles.noLogin}>
        <Text style={styles.noLoginIcon}>⚠️</Text>
        <Text style={styles.noLoginText}>No se pudo cargar la información del perfil.</Text>
        <TouchableOpacity style={styles.btnLogin} onPress={cargar}>
          <Text style={styles.btnLoginText}>Reintentar</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      <View style={styles.hero}>
        <Text style={styles.heroTitle}>👤 Mi Perfil</Text>
        <Text style={styles.heroSub}>Gestiona tus datos personales</Text>
      </View>

      <TouchableOpacity
        style={styles.pedidosCard}
        onPress={() => router.push('/modules/cliente/misCompras' as any)}
      >
        <Text style={styles.pedidosIcon}>📦</Text>
        <View style={styles.pedidosInfo}>
          <Text style={styles.pedidosTitle}>Mis Pedidos</Text>
          <Text style={styles.pedidosSub}>Ver historial de compras</Text>
        </View>
        <Text style={styles.pedidosArrow}>›</Text>
      </TouchableOpacity>

      <View style={styles.card}>
        <View style={styles.cardHead}>
          <Text style={styles.cardHeadText}>🪪 Identificación</Text>
        </View>

        <View style={styles.cardBody}>
          <Text style={styles.label}>TIPO DE DOCUMENTO</Text>

          <View style={styles.tipoDocWrap}>
            {['DPI', 'CEDULA', 'PASAPORTE', 'NIT'].map(t => (
              <TouchableOpacity
                key={t}
                style={[
                  styles.tipoDocBtn,
                  perfil.CLI_TIPODOCUMENTO === t && styles.tipoDocBtnActive
                ]}
                onPress={() => update('CLI_TIPODOCUMENTO', t)}
              >
                <Text
                  style={[
                    styles.tipoDocText,
                    perfil.CLI_TIPODOCUMENTO === t && styles.tipoDocTextActive
                  ]}
                >
                  {t}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          <Text style={styles.label}>NÚMERO DE DOCUMENTO</Text>
          <TextInput
            style={styles.input}
            value={perfil.CLI_NUMDOCUMENTO || ''}
            onChangeText={v => update('CLI_NUMDOCUMENTO', v)}
          />

          <Text style={styles.label}>NIT</Text>
          <TextInput
            style={styles.input}
            value={perfil.CLI_NIT || ''}
            onChangeText={v => update('CLI_NIT', v)}
            placeholder="CF"
          />
        </View>
      </View>

      <View style={styles.card}>
        <View style={styles.cardHead}>
          <Text style={styles.cardHeadText}>👤 Datos personales</Text>
        </View>

        <View style={styles.cardBody}>
          {[
            ['PRIMER NOMBRE', 'CLI_PRIMER_NOMBRE'],
            ['SEGUNDO NOMBRE', 'CLI_SEGUNDO_NOMBRE'],
            ['PRIMER APELLIDO', 'CLI_PRIMER_APELLIDO'],
            ['SEGUNDO APELLIDO', 'CLI_SEGUNDO_APELLIDO'],
            ['EMAIL', 'CLI_EMAIL'],
            ['PROFESIÓN', 'CLI_PROFESION'],
          ].map(([label, campo]) => (
            <View key={campo}>
              <Text style={styles.label}>{label}</Text>
              <TextInput
                style={styles.input}
                value={perfil[campo] || ''}
                onChangeText={v => update(campo, v)}
                keyboardType={campo === 'CLI_EMAIL' ? 'email-address' : 'default'}
              />
            </View>
          ))}
        </View>
      </View>

      <View style={styles.card}>
        <View style={styles.cardHead}>
          <Text style={styles.cardHeadText}>📞 Contacto</Text>
        </View>

        <View style={styles.cardBody}>
          <Text style={styles.label}>TELÉFONO PRINCIPAL</Text>
          <TextInput
            style={styles.input}
            value={perfil.CLI_PRIMER_TELEFONO || ''}
            onChangeText={v => update('CLI_PRIMER_TELEFONO', v)}
            keyboardType="phone-pad"
          />

          <Text style={styles.label}>TELÉFONO SECUNDARIO</Text>
          <TextInput
            style={styles.input}
            value={perfil.CLI_SEGUNDO_TELEFONO || ''}
            onChangeText={v => update('CLI_SEGUNDO_TELEFONO', v)}
            keyboardType="phone-pad"
          />
        </View>
      </View>

      <View style={styles.card}>
        <View style={styles.cardHead}>
          <Text style={styles.cardHeadText}>📍 Dirección</Text>
        </View>

        <View style={styles.cardBody}>
          {[
            ['PAÍS', 'CLI_PAIS'],
            ['DEPARTAMENTO', 'CLI_DEPARTAMENTO'],
            ['MUNICIPIO', 'CLI_MUNICIPIO'],
            ['ZONA', 'CLI_ZONA'],
            ['CÓDIGO POSTAL', 'CLI_CODIGO_POSTAL'],
            ['DIRECCIÓN', 'CLI_DIRECCION'],
          ].map(([label, campo]) => (
            <View key={campo}>
              <Text style={styles.label}>{label}</Text>
              <TextInput
                style={styles.input}
                value={perfil[campo] || ''}
                onChangeText={v => update(campo, v)}
              />
            </View>
          ))}
        </View>
      </View>

      <TouchableOpacity
        style={styles.btnGuardar}
        onPress={handleGuardar}
        disabled={guardando}
      >
        {guardando ? (
          <ActivityIndicator color="white" />
        ) : (
          <Text style={styles.btnGuardarText}>✓ Guardar cambios</Text>
        )}
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f5ece0' },

  loadingBox: {
    flex: 1,
    backgroundColor: '#f5ece0',
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    marginTop: 12,
    color: CAFE,
    fontSize: 14,
    fontWeight: 'bold',
  },

  hero: {
    backgroundColor: CAFE,
    padding: 28,
    margin: 16,
    borderRadius: 14,
  },
  heroTitle: {
    color: '#f0d9a0',
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  heroSub: {
    color: '#d4b896',
    fontSize: 13,
  },

  pedidosCard: {
    backgroundColor: 'white',
    margin: 16,
    marginTop: 0,
    borderRadius: 12,
    padding: 16,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    borderWidth: 1,
    borderColor: '#e8d8c0',
    elevation: 2,
  },
  pedidosIcon: { fontSize: 32 },
  pedidosInfo: { flex: 1 },
  pedidosTitle: { fontSize: 15, fontWeight: 'bold', color: CAFE },
  pedidosSub: { fontSize: 12, color: '#888', marginTop: 2 },
  pedidosArrow: { fontSize: 24, color: GOLD, fontWeight: 'bold' },

  card: {
    backgroundColor: 'white',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#e8d8c0',
    margin: 16,
    marginTop: 0,
    overflow: 'hidden',
    elevation: 2,
  },
  cardHead: {
    backgroundColor: CAFE,
    padding: 14,
  },
  cardHeadText: {
    color: '#f0d9a0',
    fontSize: 14,
    fontWeight: 'bold',
  },
  cardBody: {
    padding: 20,
  },

  label: {
    fontSize: 11,
    fontWeight: 'bold',
    color: CAFE,
    textTransform: 'uppercase',
    letterSpacing: 0.4,
    marginBottom: 5,
    marginTop: 10,
  },
  input: {
    borderWidth: 2,
    borderColor: '#e8d8c0',
    borderRadius: 8,
    padding: 10,
    fontSize: 14,
    backgroundColor: '#fdf8f3',
    color: '#333',
  },

  tipoDocWrap: {
    flexDirection: 'row',
    gap: 8,
    flexWrap: 'wrap',
    marginBottom: 8,
  },
  tipoDocBtn: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 8,
    borderWidth: 1.5,
    borderColor: '#e8d8c0',
  },
  tipoDocBtnActive: {
    backgroundColor: GOLD,
    borderColor: GOLD,
  },
  tipoDocText: {
    fontSize: 12,
    fontWeight: 'bold',
    color: '#888',
  },
  tipoDocTextActive: {
    color: 'white',
  },

  btnGuardar: {
    backgroundColor: '#276749',
    margin: 16,
    padding: 16,
    borderRadius: 10,
    alignItems: 'center',
  },
  btnGuardarText: {
    color: 'white',
    fontSize: 15,
    fontWeight: 'bold',
  },

  noLogin: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 40,
    backgroundColor: '#f5ece0',
  },
  noLoginIcon: {
    fontSize: 64,
    marginBottom: 12,
  },
  noLoginText: {
    fontSize: 15,
    color: '#555',
    textAlign: 'center',
    marginBottom: 20,
  },
  btnLogin: {
    backgroundColor: CAFE,
    paddingHorizontal: 28,
    paddingVertical: 12,
    borderRadius: 8,
  },
  btnLoginText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 14,
  },
});