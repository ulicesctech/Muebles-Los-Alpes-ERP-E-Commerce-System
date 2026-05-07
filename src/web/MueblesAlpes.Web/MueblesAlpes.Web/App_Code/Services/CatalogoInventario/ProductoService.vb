Imports Oracle.ManagedDataAccess.Client
Imports System.Data

' ============================================================
' RUTA: App_Code/Services/CatalogoInventario/ProductoService.vb
' Package: PKG_BOD_PRODUCTO
' NOTA: La PK es pro_referencia (VARCHAR2), no un NUMBER.
'       CREAR no retorna ID.
'       La foto es BLOB (opcional, puede ser Nothing).
' ============================================================
Public Class ProductoService

    Private Const PKG As String = "PKG_BOD_PRODUCTO"

    ''' <summary>
    ''' Crea un nuevo producto. La referencia es la clave primaria.
    ''' Pasar foto=Nothing si no se sube imagen.
    ''' </summary>
    Public Shared Sub Crear(referencia As String,
                             nombre As String,
                             descripcion As String,
                             tipTipo As Decimal,
                             matMaterial As Decimal,
                             altoCm As Decimal,
                             anchoCm As Decimal,
                             profundidadCm As Decimal,
                             color As String,
                             peso As Decimal,
                             foto As Byte())
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_referencia", OracleDbType.Varchar2, referencia, ParameterDirection.Input),
            New OracleParameter("p_nombre", OracleDbType.Varchar2, nombre, ParameterDirection.Input),
            New OracleParameter("p_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input),
            New OracleParameter("p_tip_tipo", OracleDbType.Decimal, tipTipo, ParameterDirection.Input),
            New OracleParameter("p_mat_material", OracleDbType.Decimal, matMaterial, ParameterDirection.Input),
            New OracleParameter("p_alto_cm", OracleDbType.Decimal, altoCm, ParameterDirection.Input),
            New OracleParameter("p_ancho_cm", OracleDbType.Decimal, anchoCm, ParameterDirection.Input),
            New OracleParameter("p_profundidad_cm", OracleDbType.Decimal, profundidadCm, ParameterDirection.Input),
            New OracleParameter("p_color", OracleDbType.Varchar2, color, ParameterDirection.Input),
            New OracleParameter("p_peso", OracleDbType.Decimal, peso, ParameterDirection.Input)
        }

        ' BLOB: si no hay foto se pasa DBNull
        Dim pFoto As New OracleParameter("p_foto", OracleDbType.Blob)
        pFoto.Direction = ParameterDirection.Input
        If foto Is Nothing OrElse foto.Length = 0 Then
            pFoto.Value = DBNull.Value
        Else
            pFoto.Value = foto
        End If
        ps.Add(pFoto)

        OracleDb.ExecNonQuery(PKG & ".CREAR", ps)
    End Sub

    ''' <summary>
    ''' Actualiza un producto existente por su referencia.
    ''' Pasar foto=Nothing para conservar la foto actual (el pkb lo maneja).
    ''' </summary>
    Public Shared Sub Actualizar(referencia As String,
                              nombre As String,
                              descripcion As String,
                              tipTipo As Decimal,
                              matMaterial As Decimal,
                              altoCm As Decimal,
                              anchoCm As Decimal,
                              profundidadCm As Decimal,
                              color As String,
                              peso As Decimal,
                              foto As Byte())
        ' 1. Actualizar datos del producto (sin foto)
        Dim ps As New List(Of OracleParameter) From {
        New OracleParameter("p_referencia", OracleDbType.Varchar2, referencia, ParameterDirection.Input),
        New OracleParameter("p_nombre", OracleDbType.Varchar2, nombre, ParameterDirection.Input),
        New OracleParameter("p_descripcion", OracleDbType.Varchar2, descripcion, ParameterDirection.Input),
        New OracleParameter("p_tip_tipo", OracleDbType.Decimal, tipTipo, ParameterDirection.Input),
        New OracleParameter("p_mat_material", OracleDbType.Decimal, matMaterial, ParameterDirection.Input),
        New OracleParameter("p_alto_cm", OracleDbType.Decimal, altoCm, ParameterDirection.Input),
        New OracleParameter("p_ancho_cm", OracleDbType.Decimal, anchoCm, ParameterDirection.Input),
        New OracleParameter("p_profundidad_cm", OracleDbType.Decimal, profundidadCm, ParameterDirection.Input),
        New OracleParameter("p_color", OracleDbType.Varchar2, color, ParameterDirection.Input),
        New OracleParameter("p_peso", OracleDbType.Decimal, peso, ParameterDirection.Input)
    }
        OracleDb.ExecNonQuery(PKG & ".ACTUALIZAR", ps)

        ' 2. Actualizar foto solo si se subió una nueva
        If foto IsNot Nothing AndAlso foto.Length > 0 Then
            Dim psFoto As New List(Of OracleParameter) From {
            New OracleParameter("p_referencia", OracleDbType.Varchar2, referencia, ParameterDirection.Input)
        }
            Dim pFoto As New OracleParameter("p_foto", OracleDbType.Blob)
            pFoto.Direction = ParameterDirection.Input
            pFoto.Value = foto
            psFoto.Add(pFoto)
            OracleDb.ExecNonQuery(PKG & ".ACTUALIZAR_FOTO", psFoto)
        End If
    End Sub

    ''' <summary>
    ''' Elimina un producto por su referencia (VARCHAR2).
    ''' Lanza error si tiene historial de precio o promociones asociadas.
    ''' </summary>
    Public Shared Sub Eliminar(referencia As String)
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_referencia", OracleDbType.Varchar2, referencia, ParameterDirection.Input)
        }
        OracleDb.ExecNonQuery(PKG & ".ELIMINAR", ps)
    End Sub

    ''' <summary>
    ''' Lista todos los productos con JOIN a Tipo y Material.
    ''' Columnas: PRO_REFERENCIA, PRO_NOMBRE, PRO_DESCRIPCION,
    '''           TIP_TIPO, TIPO, MAT_MATERIAL, MATERIAL,
    '''           PRO_ALTO_CM, PRO_ANCHO_CM, PRO_PROFUNDIDAD_CM,
    '''           PRO_COLOR, PRO_PESO
    ''' </summary>
    Public Shared Function Listar() As DataTable
        Return OracleDb.ExecRefCursor(PKG & ".LISTAR", Nothing, "p_data")
    End Function

    ''' <summary>
    ''' Busca productos por referencia, nombre, tipo o material.
    ''' Columnas: PRO_REFERENCIA, PRO_NOMBRE, TIP_TIPO, TIPO,
    '''           MAT_MATERIAL, MATERIAL, PRO_COLOR, PRO_PESO
    ''' </summary>
    Public Shared Function Buscar(texto As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_texto", OracleDbType.Varchar2, If(texto, ""), ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".BUSCAR", ps, "p_data")
    End Function
    Public Shared Function Obtener(referencia As String) As DataTable
        Dim ps As New List(Of OracleParameter) From {
            New OracleParameter("p_referencia", OracleDbType.Varchar2, referencia, ParameterDirection.Input)
        }
        Return OracleDb.ExecRefCursor(PKG & ".OBTENER", ps, "p_data")
    End Function

End Class