# Guía de Contribución — Muebles Los Alpes ERP

## Antes de hacer un Pull Request

###  Checklist obligatorio

-  Mi código compila sin errores Build - Rebuild Solution
-  Lo subí el Web.config con credenciales
-  No escribí SQL directo en VB.NET
-  No quemé la cadena de conexión en el código
-  Solo modifiqué archivos de MI módulo asignado
-  Mis packages PL/SQL están en database/procedures/<mi_modulo>/
-  Sincronicé mi rama con develop antes de crear el PR
-  El mensaje de commit sigue el formato tipo(modulo): descripción

---

## Archivos compartidos — coordinación obligatoria

| Archivo                  | Acción requerida                        |
|--------------------------|-----------------------------------------|
| Site.Master              | Avisar al equipo antes de modificar     |
| App_Code/Data/OracleDb.vb| Avisar al equipo antes de modificar     |
| Web.config.example       | Avisar al equipo antes de modificar     |
| database/ddl/            | Avisar al equipo antes de modificar     |
| .gitignore               | Avisar al equipo antes de modificar     |

---

## Cómo crear un Pull Request

1. Verifica tu rama: git branch
2. Sincroniza: git merge origin/develop
3. Resuelve conflictos si los hay
4. Push: git push origin feature/tu-rama
5. GitHub: New Pull Request → base: develop ← compare: feature/tu-rama
6. Título: [MODULO] Descripción breve

Ejemplos de títulos:
[CATALOGO] CRUD completo de Productos y Categorías
[AUTH] Login y gestión de usuarios
[COMPRAS] Registro de órdenes de compra

---

## Qué NO debe ir en el repositorio

- Web.config          credenciales de BD
- bin/                compilados
- obj/                temporales
- packages/           NuGet
- .vs/                configuración local de VS
- *.user              configuración personal

---

## Estándar de un Service

Imports System.Data
Imports Oracle.ManagedDataAccess.Client

' RUTA: App_Code/Services/TuModulo/TuEntidadService.vb
Public Class TuEntidadService

    Private Const PKG As String = "PKG_NOMBRE_PACKAGE"

    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    Public Shared Function Crear(param As String) As Decimal
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_param", OracleDbType.Varchar2, param, ParameterDirection.Input)
        }
        Return OracleDb.ExecOutNumber(PKG & ".CREAR", ps, "p_id")
    End Function

End Class

---

## Estándar de una página ASPX

' RUTA: Modules/TuModulo/TuPagina.aspx.vb
Namespace Modules.TuModulo

    Partial Public Class TuPagina
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarDatos()
            End If
        End Sub

    End Class

End Namespace

Y en el .aspx:
<%@ Page Language="VB" AutoEventWireup="true"
    CodeBehind="TuPagina.aspx.vb"
    Inherits="MueblesAlpes.Web.Modules.TuModulo.TuPagina"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="cBody" ContentPlaceHolderID="MainContent" runat="server">
</asp:Content>