Imports System
Imports System.Data
Imports System.IO
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.CatalogoInventario

    Partial Public Class Productos
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarCategorias()
                CargarMateriales()
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarCategorias()
            Try
                Dim dt As DataTable = CategoriaService.Listar()
                ddlCategoria.Items.Clear()
                ddlCategoria.Items.Add(New ListItem("-- Seleccione categoría --", "0"))
                For Each row As DataRow In dt.Rows
                    ddlCategoria.Items.Add(New ListItem(row("CAT_DESCRIPCION").ToString(), row("CAT_CATEGORIA").ToString()))
                Next
                ddlTipo.Items.Clear()
                ddlTipo.Items.Add(New ListItem("-- Seleccione tipo --", "0"))
            Catch ex As Exception
                MostrarError("Error cargando categorías: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarMateriales()
            Try
                Dim dt As DataTable = MaterialService.Listar()
                ddlMaterial.Items.Clear()
                ddlMaterial.Items.Add(New ListItem("-- Seleccione material --", "0"))
                For Each row As DataRow In dt.Rows
                    ddlMaterial.Items.Add(New ListItem(row("MAT_DESCRIPCION").ToString(), row("MAT_MATERIAL").ToString()))
                Next
            Catch ex As Exception
                MostrarError("Error cargando materiales: " & ex.Message)
            End Try
        End Sub

        Protected Sub ddlCategoria_SelectedIndexChanged(sender As Object, e As EventArgs)
            ddlTipo.Items.Clear()
            ddlTipo.Items.Add(New ListItem("-- Seleccione tipo --", "0"))
            If ddlCategoria.SelectedValue = "0" Then Return
            Try
                Dim dt As DataTable = TipoService.ListarPorCategoria(Convert.ToDecimal(ddlCategoria.SelectedValue))
                For Each row As DataRow In dt.Rows
                    ddlTipo.Items.Add(New ListItem(row("TIP_DESCRIPCION").ToString(), row("TIP_TIPO").ToString()))
                Next
            Catch ex As Exception
                MostrarError("Error cargando tipos: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarGrilla(Optional texto As String = "")
            Try
                If String.IsNullOrWhiteSpace(texto) Then
                    gvProductos.DataSource = ProductoService.Listar()
                Else
                    gvProductos.DataSource = ProductoService.Buscar(texto)
                End If
                gvProductos.DataBind()
            Catch ex As OracleException
                MostrarError("Error Oracle: " & ex.Message)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            CargarGrilla(txtBuscar.Text.Trim())
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = "" : LimpiarFormulario() : CargarGrilla()
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If hfModo.Value = "C" AndAlso String.IsNullOrWhiteSpace(txtReferencia.Text) Then
                MostrarError("La referencia es obligatoria.") : Return
            End If
            If String.IsNullOrWhiteSpace(txtNombre.Text) Then
                MostrarError("El nombre es obligatorio.") : Return
            End If
            If ddlTipo.SelectedValue = "0" Then
                MostrarError("Debe seleccionar un tipo.") : Return
            End If
            If ddlMaterial.SelectedValue = "0" Then
                MostrarError("Debe seleccionar un material.") : Return
            End If
            Dim fotoBytes As Byte() = Nothing
            If fuFoto.HasFile Then
                Dim ext As String = Path.GetExtension(fuFoto.FileName).ToLower()
                If ext <> ".jpg" AndAlso ext <> ".jpeg" AndAlso ext <> ".png" AndAlso ext <> ".gif" Then
                    MostrarError("La foto debe ser JPG, PNG o GIF.") : Return
                End If
                fotoBytes = fuFoto.FileBytes
            End If
            Dim alto As Decimal = 0, ancho As Decimal = 0, prof As Decimal = 0, peso As Decimal = 0
            Decimal.TryParse(txtAlto.Text, alto)
            Decimal.TryParse(txtAncho.Text, ancho)
            Decimal.TryParse(txtProfundidad.Text, prof)
            Decimal.TryParse(txtPeso.Text, peso)
            Try
                If hfModo.Value = "C" Then
                    ProductoService.Crear(txtReferencia.Text.Trim(), txtNombre.Text.Trim(), txtDescripcion.Text.Trim(),
                        Convert.ToDecimal(ddlTipo.SelectedValue), Convert.ToDecimal(ddlMaterial.SelectedValue),
                        alto, ancho, prof, txtColor.Text.Trim(), peso, fotoBytes)
                    MostrarExito("Producto creado correctamente.")
                Else
                    ProductoService.Actualizar(hfReferencia.Value, txtNombre.Text.Trim(), txtDescripcion.Text.Trim(),
                        Convert.ToDecimal(ddlTipo.SelectedValue), Convert.ToDecimal(ddlMaterial.SelectedValue),
                        alto, ancho, prof, txtColor.Text.Trim(), peso, fotoBytes)
                    MostrarExito("Producto actualizado correctamente.")
                End If
                LimpiarFormulario() : CargarGrilla()
            Catch ex As OracleException
                MostrarError("Error Oracle: " & ex.Message)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario() : CargarGrilla()
        End Sub

        Protected Sub gvProductos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim ref As String = e.CommandArgument.ToString()
            Select Case e.CommandName
                Case "Editar"
                    Try
                        Dim dt As DataTable = ProductoService.Obtener(ref)
                        If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                            Dim fila As DataRow = dt.Rows(0)
                            hfReferencia.Value = ref : hfModo.Value = "E"
                            txtReferencia.Text = ref : txtReferencia.Enabled = False
                            txtNombre.Text = fila("PRO_NOMBRE").ToString()
                            txtDescripcion.Text = If(fila("PRO_DESCRIPCION") Is DBNull.Value, "", fila("PRO_DESCRIPCION").ToString())
                            txtColor.Text = If(fila("PRO_COLOR") Is DBNull.Value, "", fila("PRO_COLOR").ToString())
                            txtPeso.Text = fila("PRO_PESO").ToString()
                            txtAlto.Text = fila("PRO_ALTO_CM").ToString()
                            txtAncho.Text = fila("PRO_ANCHO_CM").ToString()
                            txtProfundidad.Text = fila("PRO_PROFUNDIDAD_CM").ToString()
                            ddlMaterial.SelectedValue = fila("MAT_MATERIAL").ToString()
                            Dim tipId As String = fila("TIP_TIPO").ToString()
                            Dim dtTipo As DataTable = TipoService.Listar()
                            Dim filaT As DataRow() = dtTipo.Select("TIP_TIPO = " & tipId)
                            If filaT.Length > 0 Then
                                ddlCategoria.SelectedValue = filaT(0)("CAT_CATEGORIA").ToString()
                                Dim dtCat As DataTable = TipoService.ListarPorCategoria(Convert.ToDecimal(filaT(0)("CAT_CATEGORIA")))
                                ddlTipo.Items.Clear()
                                For Each rowT As DataRow In dtCat.Rows
                                    ddlTipo.Items.Add(New ListItem(rowT("TIP_DESCRIPCION").ToString(), rowT("TIP_TIPO").ToString()))
                                Next
                                ddlTipo.SelectedValue = tipId
                            End If
                            lblTituloForm.Text = "Editar Producto" : btnGuardar.Text = "Actualizar"
                        End If
                    Catch ex As Exception
                        MostrarError("Error al cargar: " & ex.Message)
                    End Try

                Case "Eliminar"
                    Try
                        ProductoService.Eliminar(ref)
                        MostrarExito("Producto eliminado correctamente.")
                        LimpiarFormulario() : CargarGrilla()
                    Catch ex As OracleException
                        MostrarError("Error Oracle: " & ex.Message)
                    Catch ex As Exception
                        MostrarError("Error: " & ex.Message)
                    End Try
            End Select
        End Sub

        Private Sub LimpiarFormulario()
            hfReferencia.Value = "" : hfModo.Value = "C"
            txtReferencia.Text = "" : txtReferencia.Enabled = True
            txtNombre.Text = "" : txtDescripcion.Text = "" : txtColor.Text = "" : txtPeso.Text = ""
            txtAlto.Text = "" : txtAncho.Text = "" : txtProfundidad.Text = ""
            ddlCategoria.SelectedIndex = 0
            ddlTipo.Items.Clear() : ddlTipo.Items.Add(New ListItem("-- Seleccione tipo --", "0"))
            ddlMaterial.SelectedIndex = 0
            lblTituloForm.Text = "Nuevo Producto" : btnGuardar.Text = "Guardar"
            pnlMsg.Visible = False
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = msg : pnlMsg.CssClass = "alert alert-danger" : pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = msg : pnlMsg.CssClass = "alert alert-success" : pnlMsg.Visible = True
        End Sub

    End Class
End Namespace