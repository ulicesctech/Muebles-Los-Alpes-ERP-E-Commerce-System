<%@ Page Language="VB" AutoEventWireup="false" CodeBehind="ErrorLimite.aspx.vb" Inherits="MueblesAlpes.Web.ErrorLimite" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Demasiadas Peticiones - LosAltos</title>
    <style>
        body { background-color: #fdf8f3; font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .error-card { background: white; padding: 40px; border-radius: 12px; border: 1px solid #e8d8c0; box-shadow: 0 4px 12px rgba(92,58,30,0.1); text-align: center; max-width: 400px; }
        .error-card h1 { color: #5C3A1E; font-family: Georgia, serif; margin-bottom: 10px; }
        .error-card p { color: #888; font-size: 15px; line-height: 1.5; margin-bottom: 25px; }
        .btn-gold { background: linear-gradient(135deg,#C9973A,#a87a2e); color: white; text-decoration: none; padding: 12px 24px; border-radius: 8px; font-weight: bold; display: inline-block; }
        .btn-gold:hover { background: linear-gradient(135deg,#a87a2e,#7a5818); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="error-card">
            <h1 style="font-size: 48px; margin: 0; color: #C9973A;">¡Ups!</h1>
            <h1>Límite de peticiones</h1>
            <p>Hemos detectado un tráfico inusual desde tu conexión. Por razones de seguridad, por favor espera un momento antes de continuar navegando.</p>
            <a href="javascript:history.back()" class="btn-gold">Volver atrás</a>
        </div>
    </form>
</body>
</html>