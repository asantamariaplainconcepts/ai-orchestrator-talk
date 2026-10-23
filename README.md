# Diez agentes a la vez

La charla de la NetCoreConf Madrid 2026.

| Fichero | Qué es |
| --- | --- |
| `guion-slides.md` | El guion: el texto de cada slide y cada clic, con los minutos de cada bloque. Es la fuente de las notas del deck. |
| `historia.md` | De dónde sale cada dato, con su fecha y su fuente. |
| `demo-sandboxes.md` | Cómo preparar la demo de worktree, sbx y ACA. |
| `demo-en-vivo.md` | La issue que se lanza al principio y se enseña al final: la idea, la issue de reserva, la preparación y el plan B. |
| `deck/` | Las slides: `index.html`, el runtime de Claude Design y sus assets. Funciona sin red. |
| `scripts/sync-deck.mjs` | Copia el texto de `guion-slides.md` a las notas del deck. |
| `scripts/arrancar.sh` | Levanta el deck (:4173), la página de terminales (:7681), la app del dogfood (:4174, su API en :4175) y los sandboxes, sin depender de ningún terminal. |
| `scripts/preflight.sh` | Comprueba que todo está listo y dice qué hacer con lo que no. |

```bash
npm run deck    # sirve el deck en http://127.0.0.1:4173
npm run sync    # guion-slides.md pasa a las notas de deck/index.html
npm run check   # falla si el deck no está al día con el guion
npm run arrancar   # deck, terminales, app del dogfood y sandboxes, en segundo plano
npm run preflight  # verde o rojo, y el remedio de cada rojo
```

En el deck: flechas o espacio para avanzar, N para las notas, F para pantalla completa, y `#s<n>`
en la URL para ir a un paso. El texto se cambia en `guion-slides.md`; el diseño de cada slide, en
`deck/index.html`, en el bloque `data-ov` que nombra su `<!-- ov=… -->`. Si un clic del guion no
tiene diseño, `npm run sync` falla y dice en qué slide.

## El día de la charla

1. Abre la app de aio y comprueba que el motor sigue encendido para aio-dogfood.
2. `npm run arrancar`. Lo que ya responde no se toca; los logs quedan en `~/Library/Logs/diez-agentes/`.
3. `npm run preflight`, hasta que salga todo en verde. Los logins (`claude /login`, `gh auth login`,
   `az login` con MFA) son tuyos: el preflight solo dice cuál falta.
4. Abre http://127.0.0.1:4173, http://127.0.0.1:7681 y http://127.0.0.1:4174, y deja preparado el Explore de
   `demo-en-vivo.md`.

