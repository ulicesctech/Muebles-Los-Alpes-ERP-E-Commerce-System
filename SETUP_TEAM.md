# 🛠️ SETUP DEL EQUIPO — Muebles Los Alpes ERP

## 📋 Stack tecnológico
- **Frontend/Backend:** ASP.NET Web Forms — Visual Basic .NET (VS 2022)
- **Base de datos:** Oracle 21c (ODP.NET Managed Driver)
- **Arquitectura BD:** Primary (productiva) + Standby (read-only) con Oracle Data Guard
- **ORM/Acceso a datos:** Sin ORM — todo por Packages PL/SQL
- **Control de versiones:** Git + GitHub

---

## 🌿 Estrategia de ramas

main          ← versión final / entrega
  └── develop ← integración de todo el equipo
        ├── feature/wilmer-auth-usuarios
        ├── feature/ulices-catalogo-inventario
        ├── feature/anderson-compras-proveedor
        └── feature/jose-ventas-facturacion

**Regla de oro:** Nunca hacer push directo a develop ni a main.

---

## 🚀 Configuración inicial (primera vez)

### 1. Clonar el repositorio
git clone https://github.com/ulicesctech/Muebles-Los-Alpes-ERP-E-Commerce-System.git
cd Muebles-Los-Alpes-ERP-E-Commerce-System

### 2. Cambiar a tu rama
git checkout feature/ulices-catalogo-inventario     # Ulices
git checkout feature/wilmer-auth-usuarios           # Wilmer
git checkout feature/anderson-compras-proveedor     # Anderson
git checkout feature/jose-ventas-facturacion        # Jose

### 3. Configurar Web.config (NUNCA subir al repo)
Copia la plantilla y edítala con tus credenciales locales de Oracle:
- Copia: Web.config.example → Web.config
- Edita User Id, Password y Data Source

### 4. Restaurar paquetes NuGet
Abrir solución en VS 2022:
Tools → NuGet Package Manager → Package Manager Console
Update-Package -reinstall

### 5. Instalar packages PL/SQL en Oracle
Abrir SQL Developer y ejecutar el instalador de tu módulo:
- Ulices:   @database/procedures/catalogo_inventario/00_install_catalogo_inventario.sql
- Wilmer:   @database/procedures/auth_usuarios/00_install_auth_usuarios.sql
- Anderson: @database/procedures/compras_proveedor/00_install_compras_proveedor.sql
- Jose:     @database/procedures/ventas_facturacion/00_install_ventas_facturacion.sql

---

## 📁 Estructura del proyecto

Muebles-Los-Alpes-ERP-E-Commerce-System/
├── database/
│   ├── ddl/
│   ├── full/databasefull/
│   └── procedures/
│       ├── auth_usuarios/           ← Wilmer
│       ├── catalogo_inventario/     ← Ulices
│       ├── compras_proveedor/       ← Anderson
│       └── ventas_facturacion/      ← Jose
└── src/
    └── web/
        └── MueblesAlpes.Web/
            └── MueblesAlpes.Web/
                ├── App_Code/
                │   ├── Data/
                │   │   └── OracleDb.vb          ← Helper DAL (NO tocar sin coordinar)
                │   ├── Services/
                │   │   ├── AuthUsuarios/         ← Wilmer
                │   │   ├── CatalogoInventario/   ← Ulices
                │   │   ├── ComprasProveedor/     ← Anderson
                │   │   └── VentasFacturacion/    ← Jose
                ├── Modules/
                │   ├── AuthUsuarios/             ← Wilmer
                │   ├── CatalogoInventario/       ← Ulices
                │   ├── ComprasProveedor/         ← Anderson
                │   └── VentasFacturacion/        ← Jose
                ├── Site.Master                   ← Compartida (coordinar cambios)
                ├── Web.config.example            ← Plantilla (SÍ va al repo)
                └── Web.config                    ← Local (NO va al repo)

---

## 📐 Zona de trabajo por desarrollador

| Dev      | Módulo               | Services                    | Modules                    |
|----------|----------------------|-----------------------------|----------------------------|
| Wilmer   | Auth & Usuarios      | Services/AuthUsuarios/      | Modules/AuthUsuarios/      |
| Ulices   | Catálogo & Inventario| Services/CatalogoInventario/| Modules/CatalogoInventario/|
| Anderson | Compras & Proveedor  | Services/ComprasProveedor/  | Modules/ComprasProveedor/  |
| Jose     | Ventas & Facturación | Services/VentasFacturacion/ | Modules/VentasFacturacion/ |

---

## 🔄 Flujo de trabajo diario

# 1. Antes de empezar — sincronizar con develop
git checkout feature/tu-rama
git fetch origin
git merge origin/develop

# 2. Trabajar en tu módulo

# 3. Commit
git add .
git commit -m "feat(modulo): descripción del cambio"

# 4. Push
git push origin feature/tu-rama

# 5. Crear Pull Request en GitHub → base: develop

---

## ✅ Convención de commits

Formato: tipo(modulo): descripción

feat     → Nueva funcionalidad
fix      → Corrección de bug
refactor → Mejora sin cambiar funcionalidad
docs     → Documentación
db       → Scripts de base de datos

Ejemplos:
feat(catalogo): agregar CRUD de productos
fix(inventario): corregir búsqueda de nichos
db(catalogo): agregar package PKG_BOD_STOCK

---

## ⚠️ Reglas obligatorias

1. NUNCA hacer commit del Web.config con credenciales
2. NUNCA escribir SQL directo en VB.NET — todo por packages PL/SQL
3. NUNCA quemar la cadena de conexión en el código
4. NUNCA hacer push directo a develop o main
5. SOLO trabajar en tu carpeta de módulo asignada
6. SIEMPRE sincronizar con develop antes de empezar
7. OracleDb.vb es compartido — coordinarlo con el equipo antes de modificar
8. Site.Master es compartido — coordinarlo antes de modificar

---

## 🆘 Problemas comunes

| Problema                     | Solución                                      |
|------------------------------|-----------------------------------------------|
| OracleConn not found         | Crear Web.config desde Web.config.example     |
| Errores NuGet al abrir       | Update-Package -reinstall en Package Manager  |
| designer.vb vacío            | Abrir .aspx, agregar espacio y guardar        |
| Conflicto en Site.Master     | Coordinarse con el equipo                     |
| Error al compilar OracleDb   | Verificar Build Action = Compile              |