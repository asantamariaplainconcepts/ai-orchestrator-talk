# Material para la historia de la charla

Cronología sacada de los repos el 10 de octubre de 2026 (git log, retro-log, ADRs, épicas y el deck antiguo). Es material de trabajo, no el guion.

Todo el material sale de las fuentes locales: el git log de los dos repos, `retro-log.md`, las ADR, `AGENTS.md`, los épicos de GitHub y los dos decks. No he modificado ningún repo. Dos avisos antes de empezar: el repo nuevo vive en `/Users/andoniplain/projects/charlas/ai-orchestator-new` (con la errata "orchestator"), y salvo que ponga otra cosa, "retro:N" es `docs/process/retro-log.md` de ese repo. `worktress` no es un repo git: es un deck Slidev aparte, "Disposable Worktrees" (unas 8–10 min, en inglés), con los tropiezos genéricos de los worktrees (puerto `:3000` compartido, `worktree prune`, hooks compartidos).

## A. Cronología

**Fase 0. La plataforma en la nube (25 jul – 2 ago, `ai-orchestrator`, 119 commits, +106.765 líneas).**
- Lo que se intentaba: una web interna que conecta backlogs de GitHub y Azure DevOps a jobs de agente escalados con KEDA en Azure Container Apps, con Entra BFF, connectors, board, automations y self-host. El MVP quedó fijado en DEC-002 (`BOOTSTRAP.md:23`).
- 21 de los 119 commits son de infra, Azure, Entra o deploy. Ejemplo: entre el 30/07 y el 01/08, `fix(infra)` #193, #195, #196, #198, #205.
- 30/07, el bucle de login infinito: la cookie pasó a Lax (#176, `5433774`) y volvió a Strict (#182, `bbc0293`) porque la causa real era otra. Cada componente "hizo exactamente lo que se le dijo".
- 01–02/08, primer contacto con worktrees: las sesiones en worktree perdían la telemetría. Pasó tres veces seguidas y acabó en la ADR-0011 (02/08, `ai-orchestrator/docs/adr/0011-…md`; retro de ese repo, líneas 2551–2574).
- Por qué se abandonó: **ninguna fuente lo dice de forma explícita**. Es una inferencia: el repo nuevo arranca el 14/08 como "local-first console" (`e27ac8de`) y hereda el esqueleto y los analizadores del hermano "which paid for it" (`ARCHITECTURE.md:115`).

**Fase 1. Consola local y primeros loops paralelos (14 – 22 ago, unos 280 commits).**
- 14/08: scaffold de 170 ficheros y +21.159 líneas (`e27ac8de`), con todos los adaptadores falsos.
- Ese mismo día se reparte el backlog en seis tracks paralelos con dueños de ficheros (`d716bc5a`, `docs/parallel.md`), y se decide que la claim es la rama y no una fila en un fichero (`06335653`).
- El loop 1 deja dos lecciones (`6a0647b1`, 14/08). Todo bug encontrado en código ya commiteado salió de ejecutar el producto, y ninguno de la suite, que estuvo en verde todo el rato. Además, una rama `track/*` que sobró tras un rebase parecía tomada y no lo estaba, y por eso se pasa al prefijo `loop2/*`.
- 15/08: "Move governance to GitHub" borra seis documentos (−3.312 líneas, `a5b246da`). De los 40 ítems del backlog, 33 estaban hechos y ya explicados en comentarios del código (retro:19–42).
- 17/08: "Universal Agent Skills" (#123, +3.970) se revierte el mismo día (`1b06d03f`). La retro (1237–1243) cuenta que pasaban 368 tests mientras todo run real corría con cero pasos.

**Fase 2. Hueco en el repo y PoC de 24 tickets en otro repo (25 ago – 4 sep).**
- La skill `implement-spec-poc` entra el 25/08 (`363b7c7e`) y sube a v0.2 el 04/09 "con lo que enseñó la primera tirada de 24 tickets" (`fa937f7e`). La fecha exacta de la ejecución en ds-connect no aparece; queda entre esas dos fechas.
- Los números, sacados de `docs/poc-implement-spec-lecciones.md` (en el historial, `e3f82a01`) y del deck antiguo (`slides.md:68`, 805–816):
  - Epic #287, 24 tickets, PR #288, todo en verde.
  - 27 agentes (24 + explorador + verificador + fixer), unos 9,6M de tokens.
  - 148 commits, 463 ficheros, +72k líneas, 24 specs nuevas.
  - 878 tests de backend + 743 de frontend = 1.621, y 9 journeys e2e.
  - Concurrencia pico de 6 sobre 24 (mediana de unos 2).
  - Unas 31 rondas de rebase para 24 merges, unos 16 conflictos de texto y 6 conflictos semánticos.
  - 12 tests vacuos.
  - 1 bug real: "Añadir miembros" fallaba en torno al 36 % de las veces, y se encontró con un diff de traces de Playwright.
  - Unas 90 asunciones, porque 23 de los 24 tickets eran de una sola línea.
  - El #252 terminó trabajo correcto 5 veces y las 5 lo invalidó el merge de otra rama.
  - L9: un límite de uso mató 5 agentes con 27 ficheros sin commitear repartidos entre tres. Se recuperó todo y el coste fueron 6 rondas de rebase extra.
  - Nueve tickets rechazaron, con razón, tocar el fichero de otro, y el bug pasó porque nadie era su dueño.

**Fase 3. El control plane y el loop declarado (17 – 28 sep).**
- 17/09: primera cifra de coste real, unos 35,27 $ (retro:2899). El script de coste contaba doble, 46,35 $ frente a 23,18 $, con 727 tests en verde.
- 20–27/09: épica #321 "Agent Control Plane" (grants, registry, reservations). Más tarde la ADR-0006 la supera con v2.
- 26/09: el loop pasa a declararse en YAML y desaparecen el módulo Workflows, `lifecycle.json` y `workflows.json` (#367, `3177c5a8`, −8.928).
- 26/09: un `git add -A` hecho en el checkout compartido se tragó el trabajo de otra sesión (retro:3324–3330).

**Fase 4. Simplificación KISS y el loop desatendido (3 – 10 oct).**
- 03/10: 45 commits en un día de limpieza. Se quita el espejo SQLite de tareas (`8802a281`, −3.720) y 15 paquetes sin uso (`b55212bc`).
- 07/10, un día de fallos que lleva a la épica #477:
  - La épica #447 se cierra con 9 changes y ninguna de sus pantallas construida (retro:4229, #471).
  - Dos releases se etiquetan en el commit equivocado (retro:4256).
  - Un gate de 2,5 min se repite siete veces.
- 08–09/10: v2 se construye en unas 8 horas. Son 29 PRs contra `v2`, de 21:17Z a 04:58Z, en 9 olas con WIP 4 y subagentes en worktrees (#496).
- 09/10: v3 (#561).
- 10/10: v4 (#579). La primera issue de prueba de verdad, la #575, se quedó parada en `spec-ready` sin aparecer en *Needs you*: `file-overlap` buscaba una sección Seam que `refine` ya no escribía.
- 10/10: v5 (#592), "el loop es solo datos".

## B. Cuándo y por qué los worktrees pasaron a ser lo normal

1. **14/08, desde el primer día.** Seis tracks, un worktree por track, la claim como rama (`06335653`). La razón: un fichero de claims vive en una rama y nadie más lo ve hasta que se mergea.
2. **15/08, un worktree arrancado contra la base de datos de otro.** Un segundo postmaster sobre el `PGDATA` del usuario se llevó el historial de runs esa mañana. De ahí sale el #50: base de datos por worktree (retro:326–370). Las mediciones fueron:
   - `--isolated` aísla puertos y secretos, pero no el volumen.
   - Un contenedor Persistent sigue vivo después de `aspire stop`.
3. **15/08, el CLI de Aspire se escapa del worktree.** Desde un worktree escribe `aspire.config.json` en el checkout principal (retro:420). Hoy la regla es `--apphost` siempre (`AGENTS.md:60–67`).
4. **15/08, dos instancias a la vez.** Dos AppHosts corrieron a la vez, cada uno con su Postgres, sin pisarse (retro:466–470).
5. **15/08, dos sustos de trabajo sin proteger.** 516 líneas terminadas pasaron un día sin commit en un working tree, y `gh pr merge --delete-branch` falló porque "master is already used by worktree" (retro:283–295).
6. **20/08, contenedores huérfanos.** Aparecieron `postgres-2c197ffc` y `postgres-ad1ee381` huérfanos, y un `PANIC` de checkpoint. Se pasó a SQLite derivado de la raíz del checkout (ADR-0003, −7.152, `ff7d9c84`). El deck antiguo cita un contenedor huérfano 36 minutos bloqueando un puerto (`slides.md:313`), pero **no he encontrado esa cifra en el retro-log**.
7. **26–28/09, compartir checkout o máquina sigue rompiendo cosas.**
   - El `git add -A` del 26/09.
   - El gate compiló el frontend del checkout primario, roto por el change/402 de otro agente (#400, retro:3495).
   - Un AppHost de desarrollo vivo hizo fallar el gate (retro:3515).
   - ADR-0007 (27/09): parecía que el gate medía master desde el worktree. El 03/10 se rechazó porque no se reprodujo con CLI 13.6.0.
8. **5/10, el worktree pasa a ser el ciclo de vida.** Una ola de 9 issues con WIP 4 llegó a master sin una sola colisión que parara un merge, y `cleanup` borró cada worktree al mergear (retro:4166–4172). Antes, el 26/09, ya se había establecido que el worktree es la instancia del loop (#374).

## C. Las salvaguardas que entraron en el código

- **Analizadores MOD001–005 y CQS001, y warnings como errores.** Vienen del scaffold del primer repo (25/07, `797c56c`) y se heredan el 14/08 (`e27ac8de`). No he encontrado un incidente concreto que los motive.
- **ArchitectureTests: 18 tests.** Entran el 14/08 (`4b7b7ce9`) para "lo que los analizadores no ven". Seis son una segunda opinión por si una supresión o un proyecto nuevo deja de cargar los analizadores.
- **`aspire do ci`, un solo comando de gate.** Entra el 15/08 (#51/PR #54, retro:372). Un agente ejecutó `dotnet test` sin la solución y dio 118 tests por la suite completa de 250. Faltaban 132, entre ellos los de los límites de módulo, y el #24 se mergeó así. Hoy está en `AGENTS.md:51` con la regla "a smaller count is a subset".
  - Otro hallazgo de ese día: sin `node_modules` salían 247 en verde y 3 fallos.
  - El recuento real creció: 250 → 435 (19/08) → 1.035 (20/09) → 1.336 (05/10).
- **Reglas de colisión en AGENTS.md.** Empezaron como cuatro puntos en `parallel.md` el 14/08 y pasaron a cinco reglas en AGENTS.md el 15/08 (retro:34).
  - La regla 4, "mover código fuera de un fichero ajeno", sale del loop 1 (`6a0647b1`).
  - "Assert your worktree" se refuerza tras el `add -A` del 26/09.
- **Propiedad de ficheros en las issues.**
  - Sección Seam, comparada con los ficheros que toca el worktree: #149, 19/08 (retro:1666).
  - Calcular el solape con `comm -12` en vez de recordarlo: 15/08 (retro:271–280). De siete ficheros previstos, chocaron dos.
  - En v2 pasó a "Port o zona" (#496).
  - Esta salvaguarda se degradó: el 10/10, `file-overlap` dejó parada la #575 (#576).
- **Holds.** El 19/08, el botón para quitar un hold nunca había funcionado, con 435 tests en verde (#157, retro:1458). Hoy los holds los aplica el motor según `risk-score` y `diff-risk` (`CONTRIBUTING.md:12–24`). La comprobación del hold en el servidor llegó el 05/10 (#456, `HeldByPbi`).
- **Deltas de OpenSpec.**
  - 22/08: 37 specs sacadas del código (`79f1e601`).
  - 20/09: dos merges desde la interfaz de GitHub se saltaron el plegado de specs (retro:2955, 2987).
  - En la ola de 9, el MODIFIED de un escenario renombrado hizo abortar archive en 5 de las 9 issues.
- **El loop en `loop.yaml`.**
  - ADR-0005 (18/09): había tres respuestas distintas a "qué estados hay", de 6, 9 y 4 estados.
  - #367 (26/09): el backend ejecuta el YAML.
  - #523 (08/10): se lee y se valida el `loop.yaml` (`Modules.Loop`).
  - v5: todavía quedan nombres de estado metidos en `Planner.cs`, `ScriptVerdict.cs` y `tabs.tsx`.
- **Hooks que bloquean.** `pre-tool-use` rechaza `--no-verify` y cualquier merge que no sea `.harness/scripts/merge` (#525, 08/10; hoy `.aio/steps/merge`). Viene de los fallos del 07/10 (#477, #486), con la idea de "los hooks bloquean, los documentos informan".

## D. Lo que se quitó (KISS)

- **15/08:** el plan pasa a GitHub. Desaparecen 2.163 líneas de backlog y seis documentos (−3.312, `a5b246da`).
- **21/08:** `FolderDetailScreen` baja de 2.334 a 1.133 líneas (`3fa2f7e0`).
- **26/09:** el módulo Workflows y sus JSON (−8.928, `3177c5a8`).
- **03/10:** el espejo SQLite de tareas (−3.720) y la limpieza de mecanismos sin uso (`5b56a88c`).
- **09/10, v2 (#542, `f7f5a0e7`):** +7.947 / −120.339.
  - Sale World con sus 53 interfaces, y `IWorkspaceProbe`, de 1.371 líneas.
  - `en.ts` pasa de 1.600 a 452 claves.
  - Medido por mí en `src`, contando .cs/.ts/.tsx sin migraciones ni ficheros generados: master antes de v2 tenía 588 ficheros y unas 123k líneas; tras el merge, 341 y unas 42k; hoy, 391 y unas 52k.
- **09/10, especificaciones:** 76 capabilities archivadas y 24 nuevas (#543).
- **09/10, documentación:** −64.249 líneas, y los documentos canónicos bajan de 922 a 500 (#558).
- **09/10, la shell Photino** desaparece y la app pasa a ser un solo proceso (−1.773, ADR-0008).
- **10/10, `evidence`:** pasa de 675 a 84 líneas (el commit dice 675, no 672) y `EvidenceComments.cs` de 186 a 69 (#604, `14d27fb2`).

## E. Posibles arcos para la charla

1. **"Cada regla la pagó un agente que hizo lo obvio".** Lo sostienen 118/250, el PGDATA, el `add -A`, la regla 4 de colisiones y el `--no-verify`.
2. **"Verde ya no significa lo que creíamos".** Lo sostienen los 1.621 tests con 12 vacuos, los 368 tests con cero pasos reales, el hold que no se quitaba con 435 tests y el coste contado doble con 727.
3. **"El worktree aísla el código; el runtime hay que aislarlo a mano".** Lo sostienen PGDATA, `--isolated`, `aspire.config.json`, los contenedores huérfanos y ADR-0003, y el gate con el checkout del vecino.
4. **"Construir menos para controlar más".** Lo sostienen la plataforma Azure abandonada, el v2 con −120k, los documentos de 922 a 500 y `evidence` de 675 a 84.
5. **"Del documento al mecanismo".** El recorrido es `parallel.md` → AGENTS.md → `file-overlap` → hooks → `loop.yaml`, y también muestra que el mecanismo se pudre: la #575 parada.

**Mi recomendación es el 1, cerrando con el 4.** Es exactamente la historia que pides: del caos a los worktrees y a las salvaguardas en el propio código. Cada regla tiene fecha, número y commit, y el público de .NET reconoce los analizadores y Aspire. El 4 da el final: la versión que funciona es la más pequeña, y v2 salió en una noche con 29 PRs de subagentes en worktrees. Ese dato funciona como clímax.
## Añadido el 11 de octubre: el Docker sandbox, medido

Fuentes: la sonda #613 (PR #624, `infra/README.md` e `infra/sbx-agent/` en ai-orchestrator-harness) y la prueba de login del 11 de octubre.

- **Montaje.** Montar solo un worktree deja git sin funcionar (el `.git` apunta a una ruta que no existe dentro). Montar el `.git` principal deja al agente escribir hooks y configuración que se ejecutan en el host. El modo `--clone` monta el repo en solo lectura en `/run/sandbox/source`, el agente trabaja en un clon y los commits vuelven con `git fetch sandbox-<nombre>`.
- **Autenticación con la suscripción, sin clave de API.** Un `/login` dentro de un sandbox ("Claude account with subscription") deja en sbx un secreto global `anthropic (oauth configured)`. Un segundo sandbox creado después responde a `claude -p` sin login, con `authMethod: "claude.ai"` y plan Claude Team, en 4,5 s. El token se queda en el host; el proxy lo inyecta. Antes del login, la cabecera de Claude Code decía "API Usage Billing" por la clave falsa (`proxy-managed`) que deja la plantilla.
- **Modo por defecto.** Sin argumentos, sbx arranca `claude --dangerously-skip-permissions`.
- **Red.** Con `balanced`, `api.nuget.org` responde 403 y `github.com` y `registry.npmjs.org` 200. Una regla por sandbox lo abre al momento. Una petición que no casa con ninguna regla pide aprobación en vez de denegarse. Las reglas de denegar ganan a las de permitir.
- **Disco.** 2,4–5,4 GB por sandbox. Tres a la vez llenaron los 13 GB libres del portátil durante la sonda.
- **Arranque.** Crear un sandbox: 4,0–5,4 s con la imagen en caché.
- **GitHub.** Un push desde dentro sale con el secreto global `github` de sbx, que alcanza todos los repos de la persona; uno por sandbox lo sustituye al momento.

## Añadido el 11 de octubre: la épica del dogfood (aio-dogfood#4), la primera vuelta de una épica entera

- Cinco sub-issues, lanzadas a las 10:34 con `wip: 4` y los implement en un Docker sandbox; la última llegó a `done` a las 11:11. Cinco PRs mergeados por el loop (#10–#14), 20 runs de agente, 7 gates y 5 merges. Capturas del grafo al arrancar, a mitad y al final; el deck las usa en la slide `grafo`.
- Las dos primeras (#8, #9) llegaron a `done` en 14 minutos sin ninguna parada.
- **El refiner devolvió dos issues con razón:** las había escrito pensando en la plantilla de Aspire y la app ya pintaba tarjetas y tenía el interruptor °F/°C. Preguntó qué era "la cabecera" y si la issue de Fahrenheit seguía en pie. Contestadas, siguieron.
- **El reviewer rechazó un implement:** el test de `?days=0` comprobaba el 400 pero no el mensaje "between 1 and 14". Volvió a `in-progress`, el segundo implement lo arregló (commit f281127) y la segunda ronda lo aprobó. Coste de los dos implement: 0,14 $ y 0,31 $.
- **Dos paradas del entorno, no del cambio:** `could not lock config file .git/config` al preparar cuatro worktrees a la vez (#631), y un gate rojo sin salida guardada que a mano pasó un minuto después (#638).
- La espera por `file-overlap` no llegó a verse: las parejas que chocaban no coincidieron en el tiempo.

## Añadido el 13 de octubre: Kata Containers en el portátil (#630, PR #688)

- k3s en una VM de Lima (`vz`, virtualización anidada, 4 CPUs, 8 GB) en el M4 Pro con macOS 27; dentro hay `/dev/kvm`. La máquina de Podman (`applehv`) no lo tiene, por eso Kata no puede ir ahí.
- Kata 4.2.0 con `kata-deploy`. En arm64 funcionan `kata-qemu` y `kata-qemu-runtime-rs`; `kata-clh` y `kata-fc` solo traen hipervisor para amd64. Hicieron falta cuatro ajustes para la VM anidada (sin `pmu`, sin UEFI, `pci=nomsi` y una espera de 60 s en runtime-rs).
- Mismo nodo: un pod runc ve el kernel `7.0.0-34-generic`, uno de Kata ve `6.18.35`.
- Arranque en frío de un pod Kata: 11–19 s (runc, 0,5 s). Unos 230 MiB por pod. 15 a la vez con 4 CPUs; para el 16 falta CPU (cada pod Kata reserva 250m), no memoria.
- Primer byte de `kubectl exec -it`: runc 52–94 ms, Kata 237–527 ms.
- agent-sandbox v1.0.2 en Kata: listo en 27–45 s, suspendido en 3,4–4,5 s (el pod se va, el volumen se queda), reanudado en 28–35 s con el fichero de antes intacto.
- Con Podman y la VM de Kata a la vez, el Mac se queda corto de memoria y el arranque en frío sube a 17–30 s.
- El backend 4 de `infra/pty-demo` pasa a ser Kata (kind con runc queda como 4b), con captura en `infra/pty-demo/screenshots/4-agent-sandbox-kata.jpg`.

## Añadido el 14 de octubre: las dos vueltas del dogfood con el journey y las evidencias en el vendor

- **aio-dogfood#29, del 13 al 14 de octubre.**
  - Cuatro sub-issues; la última llegó a `done` 27 minutos después de relanzar, y el motor cerró la épica solo a las 01:07.
  - Hubo que desatascarla cuatro veces:
    - login de Claude Code caducado: 27 min de espera;
    - permisos en `allow-list` en una base nueva: una hora esperando una aprobación de `python3 -c`;
    - un hold que volvía al liberar;
    - una carrera de `npm ci` en el gate del dogfood.
  - Todo eso es la épica v12 (#705).
- **El replay desde una instancia vacía.** Una segunda instancia con la base vacía (puerto 48999) leyó el journey de #32 desde GitHub y sirvió una grabación desde `aio/evidence`, idéntica byte a byte (88.102 bytes). Las grabaciones de #5 a #9 eran 29 ficheros y 358 KB empaquetados en la rama huérfana.
- **aio-dogfood#40, el 14 de octubre, con 0.3.3 y el harness 23.**
  - Las cuatro sub-issues se etiquetaron a la vez. A las 08:37, #44 y #43 esperaron con "goes first (the epic's graph)" y arrancaron cada una al integrarse la anterior.
  - El login volvió a caer, y en 70 s #41 y #42 estaban en hold con "Claude Code is not logged in. Run `claude /login` on this machine, then release". Liberar bastó.
  - El reviewer rechazó #41: el test del 400 no comprobaba que el error cayera en `errors.days`. La segunda revisión dijo "No findings".
  - `evidence` dejó 8 capturas (claro y oscuro, 1440 y 390, `/` y `/?day=tomorrow`) en #42, #43 y #44. En #41 dijo "nothing in frontend/** changed".
  - Filas del journey: 20, 15, 12 y 12. Grabaciones: 8, 6, 5 y 5.
  - La épica se cerró sola a las 10:16.
- **Dos fallos que solo salieron al usarlo fuera del repo del orquestador** (#719, #726):
  - la pestaña Review no reconocía capturas con una ruta por nombre;
  - la pestaña Proposal solo leía OpenSpec, y el plan del dogfood es un comentario `## Plan`.
- **La publicación sin espera (#724).** El workflow `release` de 0.3.5 salió verde en 150 s, contra unos 15 min y en rojo en 0.3.3 y 0.3.4.
- **En la roundtable interna de DevEx del 13 de octubre**, cuatro equipos enseñaron su flujo agéntico y era el mismo: refinamiento, plan, implementación, verificación, revisión por otro y merge, con decisiones humanas antes de implementar y antes de integrar. La frase que se repitió: "estamos todos llegando a lo mismo".

## Añadido el 15 de octubre: quality, medir lo que toca el cambio

- **El paso nuevo.** ai-orchestrator-harness#746 (PR #749) añade `quality` al paquete. Corre en `verifying` después del gate y de `evidence`, y publica en la issue un comentario `aio:quality <sha>` con cinco filas: cobertura de las líneas añadidas, CRAP de los métodos tocados, mutación de los ficheros tocados, duplicación nueva y tests perdidos o saltados. Informa y no bloquea. Los umbrales están en `.harness/quality.json` (hoy la clave `quality` de `.aio/config.json`), que es del repositorio. La pestaña Review lo pinta entre el gate y las capturas. Sale en la 0.3.9.
- **Cómo se añadió al loop.** Es un script que acaba con su línea de JSON y una línea más en la lista de `verifying`. El motor no cambió por él.
- **Primera vuelta, sin informes (aio-dogfood#56).** El gate del dogfood no medía nada: tres filas "not measured" y dos verdes. aio-dogfood#58 (PR #60) le añade cobertura con ReportGenerator, `crap.tsv` y Stryker sobre `AioDogfood.Server`. El gate pasa de 10 a 13 pasos, en menos de un minuto.
- **Segunda vuelta, los informes desaparecen (aio-dogfood#61).** El gate los escribió (8 de 45 métodos por encima de 30 de CRAP, según su log), pero `quality` dijo "no Cobertura.xml". Cada script de un estado tenía su propio worktree y el del gate se retiraba con los informes, que están en una carpeta ignorada. La fila dijo "not measured", no verde, y por eso se vio. Arreglado en ai-orchestrator-harness#751 (PR #752): los scripts de un estado comparten worktree. Sale en la 0.3.10.
- **Tercera vuelta, todo medido (aio-dogfood#63, de 16:56 a 17:06).** Cobertura 100 % de 6 líneas; CRAP máximo 34 en 1 de 3 métodos; mutación 74,4 % (90 de 121); sin duplicación ni tests perdidos. El 34 es `Program.<Main>$`, las instrucciones de nivel superior donde viven todos los endpoints, con complejidad 34 y cubierto al 100 %. La función nueva, `DayAlert`, tiene CRAP 8.
- **Con frontend (aio-dogfood#65, de 17:19 a 17:29).** 8 capturas de `evidence` y las cinco filas medidas. La de tests perdidos dio 5 que seguían en el fichero: el check toma como clase el último `record` que lee, y el cambio añadió uno anidado. Abierto como ai-orchestrator-harness#754.

## Añadido el 17 de octubre: `.harness/` pasa a `.aio/`

- **Por qué.** Después de la épica #756, `.harness/` seguía pidiendo aprender tres reglas para leerla: la raíz es del repositorio, `aio/` del paquete, `repo/` de la fontanería de este repositorio. Mirando cómo lo hace Lyceum (una carpeta `scripts/` plana, nombres que dicen lo que hacen y una cabecera "Managed by…" en cada fichero gestionado), se rehízo en una sola issue.
- **Qué quedó.** ai-orchestrator-harness#779 (PR #780), hecho por un subagente Sonnet en unos 45 minutos y devuelto una vez por el orquestador con tres cambios: el hueco de las rutas protegidas (`scripts/release` había dejado de estar protegido al salir de `.aio/`), la versión fuera de la cabecera (con ella, cada subida reescribía todos los ficheros) y el rebase sobre el arreglo de MessagePack.
  - Lo tuyo: `loop.yaml`, `gate`, `config.json` (que junta `evidence.json`, `quality.json` y `protected-paths`), `context.md`, `templates/`.
  - Del paquete, con "Managed by aio" en la primera línea: `steps/` (diez pasos), `checks/`, `lib/`, `scorers/laya/`, `schemas/` y `aio`.
  - Fuera de `.aio/`: `scripts/` con `pack`, `release`, `trust-sweep` y `keep-committer`.
- **MessagePack.** El 15 de octubre se publicó GHSA-qhrr-8q5h-9q3h sobre MessagePack 2.5.302, que entra por Aspire. NuGetAudit lo convierte en error y `master` dejó de restaurar. Se fijó 2.5.303 con el pin transitivo (#781).
- Sale en la 0.3.12.

## Añadido el 21 de octubre: el informe del loop y de dónde sale cada idea

- **Qué es.** Un informe del loop v2, ahora resumido en la slide `mejora` del deck: una maqueta de la pantalla de Métricas convertida en informe, con cinco pestañas (Flujo, Agentes, Review, Calidad y Propuesta). Cada bloque dice si ya existe en aio, si está a medias o si es nuevo, y lleva una lectura y una palanca. **Los números son de ejemplo**, salvo los marcados "real": la versión 0.3.12, #777 (Opus para refinar y proponer, Sonnet desde implement) y #781 (MessagePack). En el escenario se dice que es una maqueta.
- **Lo que ya existe.** La pantalla de Métricas (#734, `openspec/specs/metrics-screen`) ya agrupa los holds por motivo y cómo acabaron ("Released unchanged N of N: this hold caught nothing"), el coste y la duración por estado, las decisiones sobre el plan y los PRs con commit de una persona gracias a las marcas de commit (#741).
- **Las fuentes del bloque "Y cómo sabes si mejora".** Casi todas están leídas en resúmenes de prensa o en la página del propio autor, no en el informe original. Antes de citar una cifra en una slide hay que comprobarla en la fuente:
  - **Harvard, octubre 2026.** Fiona Chen y James Stratton, *Artificial Intelligence in the Firm: Bottlenecks in Software Production*. Es un working paper sin revisión por pares, con datos de Jellyfish de unas 700 empresas y unos 700.000 trabajadores hasta marzo de 2026. Con agentes: +30 % de código por persona, +20 % de commits y +23 % de PRs, sin cambio significativo en issues ni épicas resueltas; PR a merge +49 %, comentarios por PR +35 % y un 14 % más de gente revisando. Prensa: [NetzWoche, 12 oct](https://www.netzwoche.ch/news/2026-10-12/harvard-studie-stellt-produktivitaetsversprechen-von-ki-infrage), [AI Weekly](https://aiweekly.co/alerts/harvard-study-ai-coding-agents-lift-code-30-shipped-output-flat).
  - **LinearB, 2026.** Benchmarks sobre 8,1 millones de PRs. Un PR de un agente espera unas 17,6 h a que alguien lo coja, frente a 3,4 h si no hay IA. Los resúmenes dan ratios distintos (5,3× y 2,47×), así que hay que mirar las definiciones. [linearb.io](https://linearb.io/library/ai-in-software-development)
  - **Faros AI, *The Acceleration Whiplash*, 2026.** Telemetría de 22.000 desarrolladores. Épicas por desarrollador +66 %, bugs por desarrollador +54 %, el triple de incidentes y un 31,3 % más de PRs mergeados sin review. Faros vende la herramienta, y sus propias páginas dan dos cifras de churn que no cuadran (861 % y 10×): esa no se cita. [faros.ai](https://faros.ai/research/ai-acceleration-whiplash)
  - **DORA, *ROI of AI-Assisted Software Development*, abril 2026.** La IA amplifica lo que ya hay; la code review es la palanca del ROI; más throughput viene con más inestabilidad. Hay críticas de que es más recomendación que dato. [InfoQ](https://www.infoq.com/news/2026/05/dora-roi-ai-assisted-dev-report/)
  - **arXiv 2606.15283, junio 2026.** *AI-driven Software Development: A Pragmatic Path to Agentic Development Processes*. Un harness que junta contexto, herramientas, verificación, permisos, logging y aprobación humana: casi la definición de aio. Solo leído el resumen. [arXiv](https://arxiv.org/pdf/2606.15283)
  - **GitHub Agentic Workflows, 2026.** `gh aw audit` compara runs contra una línea base, y cada run deja `token-usage.jsonl`. Con eso GitHub bajó un 62 % el coste de un workflow. De aquí salen "antes y después de un cambio del loop" y "contexto antes de la primera respuesta". [audit](https://github.github.com/gh-aw/reference/audit/), [blog](https://github.blog/ai-and-ml/github-copilot/improving-token-efficiency-in-github-agentic-workflows/)
  - **Coste por cambio aceptado y supervivencia del código.** Guías de 2026: medir el coste de lo que llega a merge y no tokens, y mirar qué código sigue igual a las 3–4 semanas. El mismo task puede variar hasta 30× en tokens sin acertar más. [Larridin](https://larridin.com/blog/measure-agentic-coding-tool-productivity), [Unicoconnect](https://unicoconnect.com/blogs/measuring-coding-agent-output)
  - **Eficiencia de flujo.** Flow Framework, de Mik Kersten: el tiempo activo sobre el tiempo total, que sale optimista si las esperas no están bien modeladas. [Planview](https://blog.planview.com/flow-efficiency)
  - **GitClear, 2025.** 211 millones de líneas: los bloques duplicados se multiplicaron por 8 en 2024, y por primera vez se pegó más código del que se movió. GitClear vende herramientas de review. [DevClass](https://devclass.com/2025/02/20/ai-is-eroding-code-quality-states-new-in-depth-report/)
  - **OpenSSF Scorecard.** Una nota por práctica, sin autocertificar: el modelo de la tabla de prácticas. [InfoQ](https://www.infoq.com/news/2022/01/openssf-scorecards-v4)
  - **METR, julio 2025.** Un ensayo con 16 desarrolladores expertos: con IA tardaron un 19 % más, creyendo que habían ido un 20 % más rápido. Por si alguien pregunta por qué medir en vez de fiarse. [METR](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)
