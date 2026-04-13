' ============================================================
' RUTA: Modules/ComprasProveedor/Pedidos.aspx.vb
' ============================================================
Imports Oracle.ManagedDataAccess.Client

Namespace Modules.ComprasProveedor

    Partial Public Class Pedidos
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                LimpiarFormulario()
                CargarGrilla()
            End If
        End Sub

        Private Sub CargarGrilla(Optional texto As String = "")
            Try
                gvPedidos.DataSource = If(String.IsNullOrWhiteSpace(texto),
                                          PedidoService.Listar(),
                                          PedidoService.Buscar(texto))
                gvPedidos.DataBind()
            Catch ex As Exception
                MostrarError("Error al cargar datos: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
            CargarGrilla(txtBuscar.Text.Trim())
        End Sub

        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            txtBuscar.Text = ""
            LimpiarFormulario()
            CargarGrilla()
        End Sub

        Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
            ' Validación básica
            If String.IsNullOrWhiteSpace(txtCodigo.Text) Then
                MostrarError("El código es obligatorio.")
                Return
            End If

            Try
                Dim id As Decimal = Convert.ToDecimal(hfId.Value)
                Dim codigo As String = txtCodigo.Text.Trim()
                Dim formaPago As String = ddlFormaPago.SelectedValue

                ' Obtenemos el total (ahora disponible tanto en creación como edición)
                Dim total As Decimal = 0
                Decimal.TryParse(txtTotal.Text.Trim(), total)

                If id = 0 Then
                    ' NUEVO: Ahora pasamos el total al crear
                    PedidoService.Crear(codigo, formaPago, total)
                    MostrarExito("Pedido creado correctamente.")
                Else
                    ' ACTUALIZAR
                    PedidoService.Actualizar(id, codigo, formaPago, total)
                    MostrarExito("Pedido actualizado correctamente.")
                End If

                LimpiarFormulario()
                CargarGrilla()
            Catch ex As Exception
                MostrarError("Error al guardar: " & ex.Message)
            End Try
        End Sub

        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarFormulario()
            CargarGrilla()
        End Sub

        Protected Sub gvPedidos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            ' Evitar errores con comandos automáticos de la grilla
            If String.IsNullOrEmpty(e.CommandArgument.ToString()) Then Return

            Dim id As Decimal = Convert.ToDecimal(e.CommandArgument)

            Select Case e.CommandName
                Case "Editar"
                    Dim dt As DataTable = PedidoService.Listar()
                    ' Buscamos la fila en el DataTable
                    Dim filas As DataRow() = dt.Select("PED_PEDIDO = " & id)

                    If filas.Length > 0 Then
                        Dim fila As DataRow = filas(0)
                        hfId.Value = id.ToString()
                        txtCodigo.Text = fila("PED_CODIGO").ToString()
                        txtTotal.Text = fila("PED_TOTAL").ToString()
                        ddlFormaPago.SelectedValue = fila("PED_FORMA_PAGO").ToString()

                        ' Ajustes de interfaz
                        txtCodigo.Enabled = False ' El código no se suele editar por integridad
                        lblTituloForm.Text = "Editar Pedido"
                        btnGuardar.Text = "💾 Actualizar"
                        pnlMsg.Visible = False
                    End If

                Case "Eliminar"
                    Try
                        PedidoService.Eliminar(id)
                        MostrarExito("Pedido eliminado correctamente.")
                        LimpiarFormulario()
                        CargarGrilla()
                    Catch ex As Exception
                        MostrarError("Error al eliminar: " & ex.Message)
                    End Try

                Case "Recibir"
                    Try
                        Dim conn As New OracleConnection(ConfigurationManager.ConnectionStrings("OracleConn").ConnectionString)
                        Dim cmdRec As New OracleCommand("PKG_CP_BOD_PEDIDO.PED_RECIBIR_TODO", conn)
                        cmdRec.CommandType = CommandType.StoredProcedure
                        cmdRec.Parameters.Add("p_ped_id", OracleDbType.Decimal).Value = id
                        conn.Open()
                        cmdRec.ExecuteNonQuery()
                        conn.Close()
                        MostrarExito("Pedido recibido. Stock actualizado correctamente.")
                        CargarGrilla()
                    Catch ex As Exception
                        MostrarError("Error al recibir: " & ex.Message)
                    End Try

            End Select
        End Sub

        Private Sub LimpiarFormulario()
            hfId.Value = "0"
            txtCodigo.Text = ""
            txtTotal.Text = "0" ' Valor por defecto
            ddlFormaPago.SelectedIndex = 0

            ' UI defaults
            txtCodigo.Enabled = True
            lblTituloForm.Text = "Nuevo Pedido"
            btnGuardar.Text = "💾 Guardar"
            pnlMsg.Visible = False
        End Sub

        ' --- Mensajería ---
        Private Sub MostrarError(msg As String)
            lblMsg.Text = "<span>⚠️ " & msg & "</span>"
            pnlMsg.CssClass = "alert-err"
            pnlMsg.Visible = True
        End Sub

        Private Sub MostrarExito(msg As String)
            lblMsg.Text = "<span>✅ " & msg & "</span>"
            pnlMsg.CssClass = "alert-ok"
            pnlMsg.Visible = True
        End Sub

    End Class

End Namespace