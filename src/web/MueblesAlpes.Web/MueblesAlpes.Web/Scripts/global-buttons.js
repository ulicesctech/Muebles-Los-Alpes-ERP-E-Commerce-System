document.addEventListener("DOMContentLoaded", function () {
    const botones = document.querySelectorAll('.tiempoInhabilitado');
    const capa = document.getElementById('capaBloqueo');

    botones.forEach(function (boton) {
        boton.addEventListener('click', function (e) {
            var btn = this;

            // Si ya pasaron los 3 segundos, dejamos que el clic viaje al servidor
            if (btn.getAttribute('data-autorizado') === 'true') return;

            // FRENAMOS EL ENVÍO INICIAL
            e.preventDefault();

            // Evitamos doble ejecución
            if (btn.getAttribute('data-procesando') === 'true') return;
            btn.setAttribute('data-procesando', 'true');

            // 1. ACTIVAR BLOQUEO TOTAL DE LA PANTALLA
            if (capa) capa.style.display = 'block';

            // 2. Cambios visuales en el botón
            var textoOriginal = btn.tagName.toLowerCase() === 'input' ? btn.value : btn.innerText;
            btn.style.opacity = '0.6';

            if (btn.tagName.toLowerCase() === 'input') {
                btn.value = "Procesando...";
            } else {
                btn.innerText = "Procesando...";
            }

            // 3. EL TEMPORIZADOR OBLIGATORIO (3 segundos)
            setTimeout(function () {
                btn.setAttribute('data-autorizado', 'true');

                // Disparamos el envío al servidor
                if (btn.tagName.toLowerCase() === 'a' && btn.href.startsWith('javascript:')) {
                    window.location.href = btn.href;
                } else {
                    btn.click();
                }

                // Nota: No quitamos la capa de bloqueo aquí porque 
                // queremos que la pantalla siga protegida hasta que 
                // el servidor termine de cargar la nueva página.

            }, 250);
        });
    });
});