document.addEventListener("DOMContentLoaded", function () {
    const botones = document.querySelectorAll('.tiempoInhabilitado');
    const capa = document.getElementById('capaBloqueo');

    // ── NUEVO: Si hay UpdatePanel, quitamos la capa al terminar ──
    if (typeof Sys !== 'undefined') {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            // Quitar capa de bloqueo
            if (capa) capa.style.display = 'none';

            // Restaurar todos los botones
            botones.forEach(function (btn) {
                btn.removeAttribute('data-autorizado');
                btn.removeAttribute('data-procesando');
                btn.style.opacity = '';
                // Restaurar texto original si lo guardaste
                if (btn.getAttribute('data-texto-original')) {
                    if (btn.tagName.toLowerCase() === 'input') {
                        btn.value = btn.getAttribute('data-texto-original');
                    } else {
                        btn.innerText = btn.getAttribute('data-texto-original');
                    }
                }
            });
        });
    }

    botones.forEach(function (boton) {
        boton.addEventListener('click', function (e) {
            var btn = this;
            if (btn.getAttribute('data-autorizado') === 'true') return;
            e.preventDefault();
            if (btn.getAttribute('data-procesando') === 'true') return;
            btn.setAttribute('data-procesando', 'true');

            // ── NUEVO: Guardar texto original antes de cambiarlo ──
            var textoOriginal = btn.tagName.toLowerCase() === 'input' ? btn.value : btn.innerText;
            btn.setAttribute('data-texto-original', textoOriginal.trim());

            if (capa) capa.style.display = 'block';
            btn.style.opacity = '0.6';
            if (btn.tagName.toLowerCase() === 'input') {
                btn.value = "Procesando...";
            } else {
                btn.innerText = "Procesando...";
            }

            setTimeout(function () {
                btn.setAttribute('data-autorizado', 'true');
                if (btn.tagName.toLowerCase() === 'a' && btn.href && btn.href.startsWith('javascript:')) {
                    window.location.href = btn.href;
                } else {
                    btn.click();
                }
            }, 250);
        });
    });
});