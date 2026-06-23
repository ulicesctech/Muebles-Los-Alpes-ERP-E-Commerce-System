# Muebles Los Alpes — ERP & E-Commerce System

<p align="center">
  <img src="src/web/MueblesAlpes.Web/MueblesAlpes.Web/Content/MueblesLosAlpes.png" height="120" alt="Muebles Los Alpes" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/ASP.NET_WebForms-VB.NET_4.8-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/Oracle-21c-red?style=flat-square" />
  <img src="https://img.shields.io/badge/Data_Guard-Primary_+_Standby-orange?style=flat-square" />
  <img src="https://img.shields.io/badge/Estado-En_Desarrollo-yellow?style=flat-square" />
</p>

Sistema ERP completo para la gestión empresarial de Muebles Los Alpes, Guatemala. Cubre los módulos de catálogo, inventario, compras, ventas y autenticación de usuarios, con arquitectura robusta sobre Oracle 21c y alta disponibilidad mediante Data Guard.

---

## Descripción

Muebles Los Alpes es una empresa guatemalteca de muebles fundada en 1978 por Santos & Familia. Este sistema ERP permite administrar el catálogo de productos, control de inventario en múltiples bodegas, proceso de compras con proveedores y facturación de ventas.

El proyecto está desarrollado en equipo. Cada desarrollador es responsable de un módulo específico y debe seguir las reglas de arquitectura, control de versiones y acceso a datos definidas en este documento. El incumplimiento de estas reglas resulta en rechazo del Pull Request.

---

## Stack Tecnológico

| Capa | Tecnología |
|------|-----------|
| Frontend y Backend | ASP.NET Web Forms — Visual Basic .NET 4.8 |
| Base de datos | Oracle Database 21c |
| Alta disponibilidad | Oracle Data Guard — Primary + Standby |
| Acceso a datos | ODP.NET Managed Driver — Packages PL/SQL |
| Control de versiones | Git + GitHub |
| IDE | Visual Studio 2022 |
| App Móvil | Flutter — consume Handlers .ashx del mismo proyecto Web |

---

## Arquitectura del Sistema

```
UI Layer          Modules/*.aspx + *.aspx.vb
                        |
Business Layer    App_Code/Services/Modulo/EntidadService.vb
                        |
Data Layer        App_Code/Data/OracleDb.vb
                        |
Database Layer    Oracle 21c — Packages PL/SQL
```

Cada capa tiene una sola responsabilidad. No se mezclan responsabilidades entre capas.

**UI Layer** — El `.aspx.vb` solo maneja eventos de interfaz. Llama al Service y muestra el resultado. No sabe nada de Oracle.

**Business Layer** — El Service contiene la lógica de negocio. Sabe qué package PL/SQL llamar y con qué parámetros. No sabe nada de botones ni GridViews.

**Data Layer** — OracleDb.vb es el único punto de conexión a Oracle. Solo ejecuta comandos. No sabe qué módulo lo usa ni qué datos son.

**Database Layer** — Todo acceso a datos se hace mediante Packages PL/SQL. Prohibido SQL directo en el código VB.NET.

### Flujo correcto

```vb
' En el .aspx.vb — solo UI
Protected Sub Page_Load(sender As Object, e As EventArgs)
    If Not IsPostBack Then
        gvProveedores.DataSource = ProveedorService.Listar()
        gvProveedores.DataBind()
    End If
End Sub
```

```vb
' En el Service — lógica de negocio
Public Shared Function Listar() As DataTable
    Return OracleDb.ExecRefCursor("PKG_CP_BOD_PROVEEDOR.LISTAR", Nothing, "p_data")
End Function
```

### Lo que está prohibido

```vb
' PROHIBIDO — nunca hacer esto en un .aspx.vb
Using conn As New OracleConnection("User Id=ULISS;Password=12345;...")
    Using cmd As New OracleCommand("SELECT * FROM TABLA", conn)
        ' ...
    End Using
End Using
```

---

## Base de Datos

### Oracle Data Guard

```
PRIMARY    localhost:1521/ORCLPDB    Escritura — INSERT, UPDATE, DELETE
STANDBY    standby:1521/ORCLPDB     Lectura — SELECT, reportes
```

Las operaciones de escritura van siempre al servidor Primary. Las consultas de reportes y lectura van al Standby para no cargar el productivo.

### Convención de nombres de packages

```
PKG_BOD_*      Bodega, Catálogo, Inventario
PKG_AUTH_*     Autenticación, Usuarios
PKG_CP_*       Compras, Proveedor
PKG_VEN_*      Ventas, Facturación
PKG_FAC_*      Facturación
PKG_PROMO_*    Promociones
PKG_RH_*       Recursos Humanos
PKG_CLI_*      Clientes, Carrito
PKG_ADMIN_*    Administración
```

---

## Estructura del Repositorio

```
Muebles-Los-Alpes-ERP-E-Commerce-System/
|
+-- .github/
|     +-- CODEOWNERS
|     +-- PULL_REQUEST_TEMPLATE.md
|
+-- database/
|     +-- ddl/                              Scripts de creación de tablas
|     +-- dml/                              Datos iniciales y catálogos base
|     +-- full/                             Script completo de base de datos
|     +-- procedures/
|           +-- auth_usuarios/              Packages PL/SQL — Wilmer
|           +-- catalogo_inventario/        Packages PL/SQL — Ulices
|           +-- compras_proveedor/          Packages PL/SQL — Anderson
|           +-- ventas_facturacion/         Packages PL/SQL — Jose
|
+-- src/
|     +-- web/
|           +-- MueblesAlpes.Web/
|                 +-- MueblesAlpes.Web/
|                       +-- App_Code/
|                       |     +-- Data/
|                       |     |     +-- OracleDb.vb         Helper DAL central — no tocar sin coordinar
|                       |     +-- Services/
|                       |     |     +-- AuthUsuarios/        Wilmer
|                       |     |     +-- CatalogoInventario/  Ulices
|                       |     |     +-- ComprasProveedor/    Anderson
|                       |     |     +-- VentasFacturacion/   Jose
|                       |     +-- Utils/                     Helpers compartidos
|                       +-- Modules/
|                       |     +-- AuthUsuarios/              Wilmer
|                       |     +-- CatalogoInventario/        Ulices
|                       |     +-- ComprasProveedor/          Anderson
|                       |     +-- VentasFacturacion/         Jose
|                       +-- Handlers/                        Endpoints JSON para app móvil
|                       +-- Content/                         CSS, imágenes, Bootstrap
|                       +-- Scripts/                         JavaScript
|                       +-- Site.Master                      Layout principal — solo Ulices
|                       +-- Default.aspx                     Panel administrativo — solo Ulices
|                       +-- Web.config.example               Plantilla de configuración
|
+-- .gitignore
+-- CODEOWNERS
+-- CONTRIBUTING.md
+-- README.md
+-- SETUP_TEAM.md
+-- Web.config.example
```

---

## Módulos del Sistema

| Módulo | Descripción | Desarrollador |
|--------|-------------|---------------|
| Catálogo & Inventario | Productos, categorías, materiales, tipos, almacenes, nichos, stock, historial de precios y promociones | Ulices |
| Auth & Usuarios | Autenticación, gestión de usuarios, roles, permisos y puestos | Wilmer |
| Compras & Proveedor | Órdenes de compra, pedidos, proveedores, facturas de compra y reclamos | Anderson |
| Ventas & Facturación | Carrito de compras, detalle de carrito y facturación | Jose |

---

## Equipo de Desarrollo

| Desarrollador | GitHub | Rama |
|--------------|--------|------|
| Ulices | @ulicesctech | feature/ulices-catalogo-inventario |
| Wilmer | @wcojonc7 | feature/wilmer-auth-usuarios |
| Anderson | @anderg24 | feature/anderson-compras-proveedor |
| Jose | @Josepdib | feature/jose-ventas-facturacion |

---

## Configuración del Entorno Local

### Requisitos

- Visual Studio 2022
- Oracle Database 21c local o acceso al servidor
- SQL Developer
- Git

### Pasos

**1. Clonar el repositorio**

```bash
git clone https://github.com/ulicesctech/Muebles-Los-Alpes-ERP-E-Commerce-System.git
cd Muebles-Los-Alpes-ERP-E-Commerce-System
```

**2. Cambiar a la rama asignada**

```bash
git checkout feature/tu-rama
```

**3. Crear el Web.config local**

```bash
copy Web.config.example src\web\MueblesAlpes.Web\MueblesAlpes.Web\Web.config
```

Editar el Web.config con las credenciales locales de Oracle:

```xml
<connectionStrings>
  <add name="OracleConn"
       connectionString="User Id=TU_USUARIO;Password=TU_PASSWORD;Data Source=localhost:1521/ORCLPDB"
       providerName="Oracle.ManagedDataAccess.Client" />
</connectionStrings>
```

El Web.config está en .gitignore. Nunca debe subirse al repositorio.

**4. Restaurar paquetes NuGet**

Abrir la solución en Visual Studio 2022 y ejecutar en Package Manager Console:

```
Update-Package -reinstall
```

**5. Instalar los Packages PL/SQL**

Abrir SQL Developer y ejecutar el instalador del módulo asignado:

```sql
@database/procedures/catalogo_inventario/00_install_catalogo_inventario.sql
@database/procedures/auth_usuarios/00_install_auth_usuarios.sql
@database/procedures/compras_proveedor/00_install_compras_proveedor.sql
@database/procedures/ventas_facturacion/00_install_ventas_facturacion.sql
```

---

## Flujo de Trabajo Git

La rama develop está protegida. Nadie puede hacer push directo. Todo cambio entra mediante Pull Request con aprobación del líder del proyecto.

```
feature/tu-rama  →  Pull Request  →  develop  →  main
```

**Flujo diario obligatorio:**

```bash
# Antes de empezar — sincronizar con develop
git fetch origin
git merge origin/develop

# Trabajar solo en tu módulo

# Commit con formato estándar
git add .
git commit -m "feat: descripcion del cambio"

# Push a tu rama
git push origin feature/tu-rama

# Crear Pull Request en GitHub hacia develop
# Esperar aprobación del líder antes de mergear
```

**Convención de commits:**

```
feat        Nueva funcionalidad
fix         Corrección de error
refactor    Mejora de código sin cambiar funcionalidad
docs        Documentación
db          Scripts de base de datos
style       Cambios de interfaz o formato
```

**Ejemplos:**

```
feat: agregar CRUD de proveedores
fix: corregir validación en orden de compra
db: agregar package PKG_CP_BOD_PEDIDO
style: modernizar página de categorías
docs: actualizar README
```

---

## Reglas Obligatorias

Estas reglas no son opcionales. El incumplimiento resulta en rechazo del Pull Request.

**1. Nunca escribir SQL directo en VB.NET**

Todo acceso a datos debe ir por Packages PL/SQL. El código VB.NET nunca debe contener SELECT, INSERT, UPDATE ni DELETE.

**2. Nunca quemar credenciales en el código**

La cadena de conexión siempre va en el Web.config local. Nunca en el código fuente.

**3. Siempre usar la arquitectura de capas**

El .aspx.vb llama al Service. El Service llama a OracleDb.vb. OracleDb.vb llama al package PL/SQL. No hay atajos.

**4. Nunca hacer push directo a develop o main**

Todo cambio entra por Pull Request con aprobación. GitHub lo bloquea automáticamente.

**5. Solo trabajar en el módulo asignado**

Nadie modifica archivos de carpetas de otros desarrolladores.

**6. Siempre sincronizar antes de empezar**

Ejecutar `git merge origin/develop` antes de iniciar cualquier sesión de trabajo.

**7. OracleDb.vb es compartido**

Cualquier modificación debe coordinarse con el líder del proyecto primero.

**8. Site.Master y Default.aspx son de Ulices**

Si se necesita cambio en el layout o panel principal, solicitarlo al líder.

**9. Las operaciones de escritura van al Primary**

Las consultas de reportes van al Standby. No mezclar.

**10. Reportes van al servidor Standby**

Nunca cargar reportes pesados en el servidor Primary.

---

## Archivos Compartidos

Estos archivos tienen propietario definido en .github/CODEOWNERS. Modificarlos sin coordinación previa resulta en conflictos y rechazo del PR.

| Archivo | Propietario | Acción si necesitas cambiarlo |
|---------|-------------|-------------------------------|
| Site.Master | Ulices | Solicitar al líder |
| Default.aspx | Ulices | Solicitar al líder |
| App_Code/Data/OracleDb.vb | Ulices | Coordinar con todo el equipo |
| Web.config.example | Ulices | Coordinar con todo el equipo |
| .gitignore | Ulices | Coordinar con todo el equipo |
| MueblesAlpes.Web.vbproj | Todos | Coordinar antes de modificar |
| packages.config | Todos | Coordinar antes de modificar |

---

## Estándares de Código

### Estructura de un Service

```vb
' RUTA: App_Code/Services/TuModulo/TuEntidadService.vb
Imports System.Data
Imports Oracle.ManagedDataAccess.Client

Public Class ProveedorService

    Private Const PKG As String = "PKG_CP_BOD_PROVEEDOR"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Crear(nombre As String, contacto As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_nombre",   OracleDbType.Varchar2, nombre,   ParameterDirection.Input),
            New OracleParameter("p_contacto", OracleDbType.Varchar2, contacto, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CREAR", ps, "p_id_out")
    End Function

End Class
```

### Estructura de una página ASPX

```vb
' RUTA: Modules/TuModulo/TuPagina.aspx.vb
Imports System
Imports System.Data

Namespace Modules.TuModulo

    Partial Public Class TuPagina
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarDatos()
            End If
        End Sub

        Private Sub CargarDatos()
            gvDatos.DataSource = TuEntidadService.Listar()
            gvDatos.DataBind()
        End Sub

    End Class

End Namespace
```

```aspx
<%@ Page Language="VB" AutoEventWireup="true"
    CodeBehind="TuPagina.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.TuModulo.TuPagina"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
    <%-- Contenido aquí --%>
</asp:Content>
```

---

## Documentación Adicional

- Guía de configuración del equipo — SETUP_TEAM.md
- Guía de contribución y Pull Requests — CONTRIBUTING.md
- Plan de aplicación móvil — PLAN_APP_MOVIL.md