Namespace Modules.CatalogoInventario

    Partial Public Class Almacenes
        Inherits BasePage

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarGrilla()
            Try
                gvAlmacenes.DataSource = AlmacenService.Listar()
                gvAlmacenes.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar almacenes: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' ALMACEN — GUARDAR (Crear / Actualizar)
        ' =============================================
        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtNombre.Text) Then MostrarError("El nombre es obligatorio.") : Return
            If String.IsNullOrWhiteSpace(txtPais.Text) Then MostrarError("El pais es obligatorio.") : Return
            If String.IsNullOrWhiteSpace(txtUbicacion.Text) Then MostrarError("La ubicacion es obligatoria.") : Return
            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                If id = 0 Then
                    AlmacenService.Crear(txtNombre.Text.Trim(), txtPais.Text.Trim(), txtUbicacion.Text.Trim())
                    MostrarExito("Almacen creado correctamente.")
                    LimpiarFormulario()
                Else
                    AlmacenService.Actualizar(id, txtNombre.Text.Trim(), txtPais.Text.Trim(), txtUbicacion.Text.Trim())
                    MostrarExito("Almacen actualizado correctamente.")
                    ' Mantener el panel de nichos abierto al actualizar
                    If pnlNichos.Visible Then
                        CargarNichosDelAlmacen(id)
                    End If
                End If
                CargarGrilla()
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            pnlNichos.Visible = False
            CargarGrilla()
        End Sub

        ' =============================================
        ' ALMACEN — GRILLA EVENTOS
        ' =============================================
        Protected Sub gvAlmacenes_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)
            Select Case e.CommandName
                Case "Editar"
                    Dim dt As DataTable = AlmacenService.Listar()
                    Dim fila As DataRow() = dt.Select("ALM_ALMACEN = " & id)
                    If fila.Length > 0 Then
                        hfId.Value = id.ToString()
                        txtNombre.Text = fila(0)("ALM_NOMBRE").ToString()
                        txtPais.Text = fila(0)("ALM_PAIS").ToString()
                        txtUbicacion.Text = fila(0)("ALM_UBICACION").ToString()
                        lblTituloForm.Text = "Editando: " & fila(0)("ALM_NOMBRE").ToString()
                        btnGuardar.Text = "Actualizar"
                        ' Abrir panel de nichos automaticamente al editar
                        AbrirPanelNichos(id)
                    End If
                Case "Eliminar"
                    Try
                        AlmacenService.Eliminar(id)
                        MostrarExito("Almacen eliminado correctamente.")
                        LimpiarFormulario()
                        pnlNichos.Visible = False
                        CargarGrilla()
                    Catch ex As Exception
                        MostrarError("Error: " & ex.Message)
                    End Try
            End Select
        End Sub

        ' =============================================
        ' NICHOS — PANEL
        ' =============================================
        Private Sub AbrirPanelNichos(almId As Decimal)
            Try
                hfAlmacenId.Value = almId.ToString()
                Dim dt As DataTable = AlmacenService.Listar()
                Dim fila As DataRow() = dt.Select("ALM_ALMACEN = " & almId)
                If fila.Length > 0 Then
                    lblAlmacenNombre.Text = fila(0)("ALM_NOMBRE").ToString()
                End If
                CargarNichosDelAlmacen(almId)
                LimpiarFormularioNicho()
                pnlNichos.Visible = True
            Catch ex As Exception
                MostrarError("Error al abrir panel: " & ex.Message)
            End Try
        End Sub

        Private Sub CargarNichosDelAlmacen(almId As Decimal)
            Try
                gvNichos.DataSource = NichoService.ListarPorAlmacen(almId)
                gvNichos.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar nichos: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' NICHOS — CREAR Y ASIGNAR
        ' =============================================
        Protected Sub btnCrearNicho_Click(sender As Object, e As EventArgs)
            If String.IsNullOrWhiteSpace(txtNicNumero.Text) Then MostrarError("El numero del nicho es obligatorio.") : Return
            If String.IsNullOrWhiteSpace(txtNicZona.Text) Then MostrarError("La zona es obligatoria.") : Return
            If String.IsNullOrWhiteSpace(txtNicCaracteristica.Text) Then MostrarError("La caracteristica es obligatoria.") : Return
            Try
                Dim almId As Decimal = Convert.ToDecimal(hfAlmacenId.Value)
                NichoService.CrearYAsignar(
                    txtNicNumero.Text.Trim(),
                    txtNicZona.Text.Trim(),
                    txtNicCaracteristica.Text.Trim(),
                    almId
                )
                MostrarExito("Nicho creado y asignado correctamente.")
                LimpiarFormularioNicho()
                CargarNichosDelAlmacen(almId)
            Catch ex As Exception
                MostrarError("Error: " & ex.Message)
            End Try
        End Sub

        ' =============================================
        ' NICHOS — ELIMINAR
        ' =============================================
        Protected Sub gvNichos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "EliminarNicho" Then
                Try
                    Dim nicId As Decimal = Convert.ToDecimal(e.CommandArgument)
                    NichoService.Eliminar(nicId)
                    MostrarExito("Nicho eliminado correctamente.")
                    CargarNichosDelAlmacen(Convert.ToDecimal(hfAlmacenId.Value))
                Catch ex As Exception
                    MostrarError("Error: " & ex.Message)
                End Try
            End If
        End Sub

        ' =============================================
        ' HELPERS
        ' =============================================
        Private Sub LimpiarFormulario()
            hfId.Value = "0"
            txtNombre.Text = ""
            txtPais.Text = ""
            txtUbicacion.Text = ""
            lblTituloForm.Text = "Nuevo Almacen"
            btnGuardar.Text = "Guardar"
            pnlMsg.Visible = False
        End Sub

        Private Sub LimpiarFormularioNicho()
            txtNicNumero.Text = ""
            txtNicZona.Text = ""
            txtNicCaracteristica.Text = ""
        End Sub

        Private Sub MostrarError(msg As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = msg
            pnlMsg.CssClass = "alert-ok"
            pnlMsg.Visible = True
        End Sub

    End Class
End Namespace