# Muebles Los Alpes — ERP & E-Commerce System

> Sistema ERP completo para la gestión empresarial de Muebles Los Alpes, Guatemala.  
> Cubre los módulos de catálogo, inventario, compras, ventas y autenticación de usuarios,  
> con una arquitectura robusta sobre Oracle 21c con alta disponibilidad mediante Data Guard.

---

## Descripción

**Muebles Los Alpes — Santos & Familia, Desde 1978** es una empresa guatemalteca de muebles que requería un sistema de gestión integral para administrar su catálogo de productos, control de inventario en múltiples bodegas, proceso de compras con proveedores y facturación de ventas.

Este proyecto implementa un ERP modular desarrollado en equipo, donde cada desarrollador es responsable de un módulo específico del sistema, siguiendo buenas prácticas de control de versiones, arquitectura en capas y acceso a datos exclusivamente mediante Packages PL/SQL en Oracle.

---

## Stack Tecnológico

| Capa | Tecnología |
|------|-----------|
| Frontend / Backend | ASP.NET Web Forms — Visual Basic .NET 4.8 |
| Base de datos | Oracle Database 21c |
| Alta disponibilidad | Oracle Data Guard — Primary + Standby |
| Acceso a datos | ODP.NET Managed Driver — Packages PL/SQL |
| Control de versiones | Git + GitHub |
| IDE | Visual Studio 2022 |

---

## Arquitectura del Sistema

```
┌──────────────────────────────────────────────────┐
│            ASP.NET Web Forms VB.NET              │
│                                                  │
│   Modules/  ──►  Services/  ──►  OracleDb.vb    │
└─────────────────────┬────────────────────────────┘
                      │  ODP.NET Managed Driver
                      ▼
┌──────────────────────────────────────────────────┐
│                  Oracle 21c                      │
│                                                  │
│   PRIMARY                    STANDBY             │
│   Escritura                  Lectura             │
│   INSERT / UPDATE / DELETE   SELECT / Reportes   │
│                                                  │
│            Packages PL/SQL                       │
└──────────────────────────────────────────────────┘
```

El acceso a la base de datos se realiza exclusivamente a través de **Packages PL/SQL**, sin SQL embebido en el código de la aplicación. El servidor Standby se utiliza para consultas de reportes y lectura, aliviando la carga del servidor Primary.

---

## Módulos del Sistema

| Módulo | Descripción | Desarrollador |
|--------|-------------|---------------|
| Catálogo & Inventario | Productos, categorías, materiales, tipos, almacenes, nichos, stock, historial de precios y promociones | Ulices |
| Auth & Usuarios | Autenticación, gestión de usuarios, roles y permisos | Wilmer |
| Compras & Proveedor | Órdenes de compra, proveedores, facturas de compra y reclamos | Anderson |
| Ventas & Facturación | Registro de ventas, facturación y reportes gerenciales | Jose |

---

## Estructura del Repositorio

```
Muebles-Los-Alpes-ERP-E-Commerce-System/
│
├── .github/
│   └── CODEOWNERS                        ← Propietarios de archivos por módulo
│
├── database/
│   ├── ddl/                              ← Scripts de creación de tablas
│   ├── full/databasefull/                ← Script completo de la base de datos
│   └── procedures/
│       ├── auth_usuarios/                ← Packages PL/SQL — Wilmer
│       ├── catalogo_inventario/          ← Packages PL/SQL — Ulices
│       ├── compras_proveedor/            ← Packages PL/SQL — Anderson
│       └── ventas_facturacion/           ← Packages PL/SQL — Jose
│
└── src/
    └── web/
        └── MueblesAlpes.Web/
            └── MueblesAlpes.Web/
                ├── App_Code/
                │   ├── Data/
                │   │   └── OracleDb.vb       ← Helper DAL central compartido
                │   └── Services/
                │       ├── AuthUsuarios/
                │       ├── CatalogoInventario/
                │       ├── ComprasProveedor/
                │       └── VentasFacturacion/
                ├── Modules/
                │   ├── AuthUsuarios/
                │   ├── CatalogoInventario/
                │   ├── ComprasProveedor/
                │   └── VentasFacturacion/
                ├── Content/                  ← Estilos, imágenes, Bootstrap
                ├── Scripts/                  ← JavaScript
                ├── Site.Master               ← Layout principal compartido
                ├── Default.aspx              ← Panel administrativo
                └── Web.config.example        ← Plantilla de configuración
```

---

## Equipo de Desarrollo

| Desarrollador | GitHub | Rama | Módulo |
|--------------|--------|------|--------|
| Ulices | [@ulicesctech](https://github.com/ulicesctech) | `feature/ulices-catalogo-inventario` | Catálogo & Inventario |
| Wilmer | [@wcojonc7](https://github.com/wcojonc7) | `feature/wilmer-auth-usuarios` | Auth & Usuarios |
| Anderson | [@anderg24](https://github.com/anderg24) | `feature/anderson-compras-proveedor` | Compras & Proveedor |
| Jose | [@Josepdib](https://github.com/Josepdib) | `feature/jose-ventas-facturacion` | Ventas & Facturación |

---

## Configuración del Entorno Local

### Requisitos previos

- Visual Studio 2022
- Oracle Database 21c local o acceso a servidor
- SQL Developer
- Git

### Instalación

**1. Clonar el repositorio**

```bash
git clone https://github.com/ulicesctech/Muebles-Los-Alpes-ERP-E-Commerce-System.git
cd Muebles-Los-Alpes-ERP-E-Commerce-System
```

**2. Cambiar a la rama correspondiente**

```bash
git checkout feature/tu-rama
```

**3. Crear el archivo de configuración local**

```bash
copy Web.config.example src\web\MueblesAlpes.Web\MueblesAlpes.Web\Web.config
```

Editar el `Web.config` con las credenciales locales de Oracle:

```xml
<connectionStrings>
  <add name="OracleConn"
       connectionString="User Id=TU_USUARIO;Password=TU_PASSWORD;Data Source=localhost:1521/ORCLPDB"
       providerName="Oracle.ManagedDataAccess.Client" />
</connectionStrings>
```

> El archivo `Web.config` está incluido en `.gitignore` y nunca debe subirse al repositorio.

**4. Restaurar paquetes NuGet**

Abrir la solución en Visual Studio 2022 y ejecutar en Package Manager Console:

```
Update-Package -reinstall
```

**5. Instalar los Packages PL/SQL**

Abrir SQL Developer y ejecutar el script instalador del módulo correspondiente:

```sql
@database/procedures/catalogo_inventario/00_install_catalogo_inventario.sql
@database/procedures/auth_usuarios/00_install_auth_usuarios.sql
@database/procedures/compras_proveedor/00_install_compras_proveedor.sql
@database/procedures/ventas_facturacion/00_install_ventas_facturacion.sql
```

---

## Flujo de Trabajo

La rama `develop` está protegida. Ningún desarrollador puede hacer push directo — todo cambio debe ingresar mediante Pull Request con al menos una aprobación del líder del proyecto.

```
feature/tu-rama  →  Pull Request  →  develop  →  main
```

**Flujo diario:**

```bash
# Antes de empezar — sincronizar con develop
git fetch origin
git merge origin/develop

# Hacer cambios en tu módulo

# Commit
git add .
git commit -m "feat: descripcion del cambio"

# Push a tu rama
git push origin feature/tu-rama

# Crear Pull Request en GitHub hacia develop
```

**Convención de commits:**

```
feat:      nueva funcionalidad
fix:       corrección de error
refactor:  mejora de código sin cambiar funcionalidad
docs:      documentación
db:        scripts de base de datos
style:     cambios de interfaz o formato
```

---

## Reglas del Proyecto

- Todo acceso a la base de datos se realiza mediante **Packages PL/SQL** — está prohibido el SQL directo en el código
- Las credenciales de conexión nunca se suben al repositorio
- Cada desarrollador trabaja únicamente en su módulo asignado
- Los archivos compartidos como `Site.Master`, `OracleDb.vb` y `Default.aspx` tienen propietario definido en `.github/CODEOWNERS` y requieren revisión del líder para cualquier modificación
- Las operaciones de escritura van al servidor **Primary** y los reportes al servidor **Standby**

---

## Documentación Adicional

- [Guía de configuración del equipo](SETUP_TEAM.md)
- [Guía de contribución y Pull Requests](CONTRIBUTING.md)
- [Plan de aplicación móvil](PLAN_APP_MOVIL.md)