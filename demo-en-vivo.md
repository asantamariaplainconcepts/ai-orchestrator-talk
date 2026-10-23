# La demo en vivo: una issue que se hace mientras hablo

Al principio de la charla lanzo una issue en aio-dogfood, y al final enseño lo que ha hecho el loop. En el guion son las slides 3a (la app de hoy), 3b (lanzo), 12a (apruebo el plan) y 27 a 29 (lo que ha pasado).

## La idea

Una línea, a propósito tonta, que deja evidencia en el frontend:

> Que la página salude a la NetCoreConf Madrid.

Solo toca `frontend/`, así que `evidence` saca las capturas de `/` en claro y en oscuro, a 1440 y a 390, y en ellas se ve el saludo. Las dos últimas del dogfood que tocaban el frontend, #63 y #65, tardaron unos 10 minutos de la etiqueta a `done`.

## La issue preparada (plan B del Explore)

Si el Explore pasa de tres minutos, se pega esta y se le pone la etiqueta:

```markdown
Título: La página saluda a la NetCoreConf Madrid

## Qué pasa hoy

La cabecera de la página pone «Aspire Starter» (`frontend/src/App.tsx`, el `h1` de `app-header`), y la pestaña del navegador también (`frontend/index.html`).

## Qué tiene que pasar

La cabecera dice «Hola, NetCoreConf Madrid» y la pestaña, «Hola, NetCoreConf Madrid · El tiempo». Quien abre la app en la charla ve que el cambio es de hoy.

## Dónde cae

- `frontend/src/App.tsx`
- `frontend/index.html`

## Comprobación

- [ ] `npm run lint` y `npm run build` en `frontend/` sin errores.
- [ ] `aspire do ci` verde.
- [ ] Las capturas de `evidence` de `/` enseñan el saludo en claro y en oscuro.

## Lo que no es

No cambia los datos del tiempo, la API ni el resto de la página.
```

## Antes de subir

`npm run preflight` comprueba casi todo lo de esta lista (ver el README).

- [x] El harness del dogfood en la 0.3.12, con `.aio/` (PR #68).
- [x] La app de aio arrancada, con el motor encendido para aio-dogfood y el `wip` libre (22 de octubre).
- [ ] `claude /login` hecho en esta máquina, y el login de `gh` vivo.
- [x] El dogfood en `main`, al día, sin ninguna issue a medias (22 de octubre).
- [x] Ensayo completo, el 21 de octubre: aio-dogfood#69 («El pie de la página avisa de que los datos son de ejemplo»), de la liberación del hold a `done` en 10 min 36 s y 0,98 $, con el PR #70 mergeado y el gate 13/13 en verde. El plan no esperó a nadie: el loop del dogfood no tiene `proposal-review`.
- [x] Capturas del ensayo en `deck/assets/planb-69-journey.png`, `-issue`, `-proposal` y `-review`. El botón «Cambiar a plan B» de la demo final enseña la del Journey.

## Durante la charla

1. **Slides 3a y 3b, minuto 2:** enseño la app tal como está y lanzo el Explore con el prompt de la slide (botón Copiar). El prompt ya le pide que la meta en el loop, así que entra sola en `status:ready-for-proposal`; si no, la muevo yo.
2. **Slide 12a, hacia el minuto 12:** el plan ya está hecho y ha pasado solo a implementar, porque el loop del dogfood no tiene `proposal-review`. Lo enseño en la app y cuento que en el orquestador un score de riesgo alto lo habría parado.
3. **Slide 28, al final:** la issue, el Journey, el plan, la grabación del implement, el gate y quality, las capturas, el PR y `aio/evidence`.

## Plan B

- **El Explore se alarga:** pego la issue de arriba.
- **El loop se para** (login, score de riesgo alto, gate rojo): sale en Needs you con su motivo, y eso es lo que cuenta la charla. Lo enseño, lo suelto si se puede y sigo.
- **Al final no ha terminado:** enseño dónde está y por qué, y después la issue del ensayo.
- **No hay red o la app no responde:** las capturas del ensayo y, si hace falta, la épica aio-dogfood#40 (slide 29).
