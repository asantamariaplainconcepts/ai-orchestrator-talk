---
description: "Guion de la charla: el SDLC de siempre, convertido en un loop de pasos que corre solo con diez agentes."
---

# Diez agentes a la vez

Guion de las slides. Cada bloque es un clic o una slide; «[clic]» marca dónde se avanza dentro de la slide.

Este fichero es el texto del deck: `npm run sync` lo copia a las notas de `deck/index.html`. Cada slide dice con `<!-- ov=… -->` qué slide del deck es, y el script falla si sus clics no coinciden con los del diseño. Tiempo previsto: 45 minutos con las preguntas dentro.

La idea que atraviesa la charla: el flujo es el SDLC de hace no mucho, con sus buenas prácticas. Hoy cada práctica es un paso que corre solo y deja algo que se puede comprobar. Los agentes ponen la velocidad; el flujo sigue siendo el mismo.

---

## Apertura y cierre

### 1. Portada <!-- ov=portada -->

Portada. Esperar a que la sala se siente.

### 2. Sponsors <!-- ov=sponsors -->

Gracias a los sponsors de la NetCoreConf Madrid.

### 2a. Quién soy <!-- ov=quiensoy -->

Soy Andoni, Principal Engineer en Plain Concepts y MVP de Microsoft. Llevo este año construyendo aio, el orquestador del que va la charla, y lo uso para trabajar en él mismo.

---

## Arranque (4 min)

### 2b. Cómo trabajáis hoy <!-- ov=pulso -->

Antes de empezar, quiero saber dónde estáis. Levantad la mano en el nivel en el que trabajáis hoy con agentes. [clic]

**1 · Vibe coding**

Le pides algo, aplicas lo que sale y lo pruebas. [clic]

**2 · Plan y apply**

Le pides un plan, lo revisas y después lo aplica. Aquí está mucha gente, y está bien. [clic]

**3 · El repo enseña al agente**

AGENTS.md, skills, comandos y hooks versionados en el repositorio: el agente lee lo mismo que tu equipo. Esto es el bloque 01. [clic]

**4 · Varios a la vez**

Cada agente en su worktree o en un sandbox, sin pisarse. Esto es el bloque 03. [clic]

**5 · Un loop**

Pasos con gate y evidencias, y tú miras solo lo que se para. Esto es el bloque 02. Comentar la sala en una frase: «la mayoría en el 2; hoy vamos a ver cómo se llega al 5».

### 3. Las tres preguntas <!-- ov=preguntas -->

Hoy abrir diez terminales y lanzar diez agentes es lo fácil. Lo difícil viene después: diez ramas que se pisan, diez PRs que revisar, y a veces todo en verde sin saber si funciona.

Para que diez agentes ayuden hay que contestar tres preguntas. [clic]

**Tres preguntas**

Cómo controlas algo que no es determinista: el mismo prompt, dos veces, da dos resultados. Cómo sabes qué ha hecho cuando no estabas mirando. Y cómo trabaja una persona con diez a la vez sin mirar diez terminales.

La respuesta no empieza con agentes. Empieza hace no mucho, con lo que ya hacían los buenos equipos.

### 3a. La app de hoy <!-- ov=dhoy -->

Esta es la app con la que va a trabajar el loop: el dogfood, una app del tiempo de ejemplo con Aspire, corriendo ahora en mi portátil. Fijaos en la cabecera. Al final de la charla volvemos a esta misma página.

### 3b. Una idea, en directo <!-- ov=lanzo -->

Antes de contaros nada, pongo a trabajar al loop. En la consola del dogfood, la app del tiempo, Explore with agent con una idea de una línea, a propósito tonta: «que la página salude a la NetCoreConf Madrid». El agente pregunta lo que no sabe, lee el código y la plantilla, y escribe la issue: qué pasa hoy, qué tiene que pasar, dónde cae, cómo se comprueba y lo que no es. Nada existe hasta que digo que sí. Por defecto la issue nace sin etiqueta, porque meterla en el loop es decisión de una persona; esta vez lo decido en el propio prompt, y entra sola en ready-for-proposal.

Y me olvido. Al final de la charla vemos qué ha pasado.

Plan B: si el Explore pasa de tres minutos, pego la issue preparada en demo-en-vivo.md y le pongo la etiqueta status:ready-for-proposal.

---

## 00 · El SDLC de hace no mucho, sin IA (6 min) <!-- short=00 SDLC -->

### 4. Un corcho y unas tarjetas <!-- ov=corcho -->

Antes de hablar de agentes, de dónde venimos. Así hacíamos Scrum: una tarjeta por tarea, con su estimación, y un corcho con cuatro columnas, todo, dev, test y done, y una fila por proyecto. Mover una tarjeta de columna era el flujo. Lo que viene ahora es ese mismo flujo, con un nombre para cada columna y lo que deja escrito.

### 4a. Así trabajábamos hace no mucho <!-- ov=sdlc25 -->

**En las mejores familias, sin agentes**

Así trabajábamos hace no mucho en las mejores familias, sin agentes: refinar, diseñar, rama, código, CI, QA, review y merge. Cada caja tiene un dueño y deja algo escrito: el ticket, el diseño, la rama, el PR, el informe de CI. [clic]

**Donde decide una persona**

Y en cuatro sitios decide una persona. En el refinamiento: ¿está listo? En el diseño: ¿es esto lo que queremos? En QA: ¿funciona? Y en la review: ¿es esto lo que pedimos?

### 5. DoR: lo que entra <!-- ov=dor -->

Un ticket no entra en el sprint porque alguien lo haya escrito. Entra cuando cumple la Definition of Ready: qué pasa hoy, qué tiene que pasar, los criterios de aceptación y lo que queda fuera. Para eso estaba el refinamiento. [clic]

**Si no cumple, no entra**

Si al ticket le falta algo, vuelve a quien lo escribió con preguntas. Nadie empieza a programar sobre un hueco.

### 6. DoD: lo que sale <!-- ov=dod -->

Al otro lado, la Definition of Done: los tests en verde, el código revisado por otra persona, lo que cambia documentado y desplegado en un entorno donde se puede probar. [clic]

**Hecho es una lista**

Hecho no es una sensación de quien lo programó. Es una lista que se puede comprobar, y es la misma para todos.

### 7. Tests y sus informes <!-- ov=tests -->

El CI corre todos los tests, no los que se acuerda alguien. Y deja un informe: cuántos tests corrió, la cobertura de lo que cambió y, en los equipos más cuidadosos, la mutación. QA añade capturas de lo que probó. [clic]

**El informe, en la PR**

Ese informe va en la PR. Quien revisa no tiene que creerse a nadie: lee lo que se midió.

### 8. Métricas de delivery <!-- ov=dora -->

Y el equipo medía cómo entregaba: cuántas veces despliega, cuánto tarda un cambio en llegar, cuántos despliegues fallan y cuánto tarda en recuperarse. Son las cuatro métricas de DORA, y la retro de cada sprint las miraba.


Con eso sabías si un cambio en el proceso mejoraba algo o solo lo parecía.

### 9. Hoy: el mismo flujo, en pasos <!-- ov=sdlc26 -->

**Hoy, el mismo flujo**

Hoy las ocho cajas son las mismas. Cuatro las hace un agente, y no son deterministas. Las otras cuatro, y las flechas, son código. No hemos inventado nada: cada paso del flujo va ahora más rápido, y el siguiente paso lo sigue decidiendo código, nunca el agente. [clic]

**Cada práctica, un paso**

Cada práctica de antes es ahora un paso que corre solo. El DoR es el refine contra una plantilla, y si faltan respuestas vuelve a una persona. El informe de CI es el gate. Las capturas de QA las saca un script. El review lo hace otro agente. La persona sigue decidiendo el plan y el merge, con todo eso delante. Y las métricas de delivery salen del diario de cada issue.


Cada paso deja algo que se puede comprobar: una línea con su resultado, un informe, unas capturas, una puntuación de riesgo. Eso es lo que os voy a enseñar, y es donde se nos fueron los tres meses.

---

## 01 · Cómo controlar a los agentes (7 min)

### 10. 01 · Controlar al agente <!-- ov=sec01 -->

Bloque 1: cómo se controla algo que no es determinista.

### 11. El agente no va a ser determinista <!-- ov=nodet -->

A finales de agosto lanzamos 24 tickets a la vez en otro proyecto. 23 de los 24 eran de una sola línea. Al terminar contamos unas 90 decisiones que los agentes habían tomado por su cuenta, porque el ticket no decía nada. Todas plausibles. Ninguna la habíamos pedido.

El agente no va a ser determinista, y no hay prompt que lo arregle. [clic]

**Lo que lo rodea**

Lo que sí puede ser determinista es todo lo que lo rodea: qué lee, qué recibe, qué puede tocar y qué entrega. A eso le llamamos el harness: lo que el repositorio pone alrededor del agente.

### 11a. Lo que lee <!-- ov=lee -->

Un agente lee todo lo que encuentra, y lo que no encuentra se lo inventa. El repositorio es la base de conocimiento. AGENTS.md es un índice: qué es el producto en docs/product, cómo está hecho en ARCHITECTURE, cómo se pinta en DESIGN, las decisiones en sus ADRs, y lo que el producto hace, como requisitos, en 26 specs de OpenSpec. En brownfield las specs no se escriben: el 22 de agosto sacamos 37 del código que ya había. Y el porqué de cada cosa vive en el comentario del código que explica, para que viaje con el código cuando alguien lo mueve. [clic]

**Lo que no lee**

Lo que no lee: menos documentos. El 15 de agosto borramos seis. De 40 ítems de backlog, 33 ya estaban hechos y explicados en el código. En octubre los documentos canónicos bajaron de 922 a 500 líneas. La regla que quedó: GitHub tiene el estado del trabajo, el repo tiene los hechos del código.

### 11b. Lo que hay en .aio/ <!-- ov=harness -->

```
.aio/
  loop.yaml          el orden de los pasos                         ┐
  gate               tu comando: verde o rojo                      │
  config.json        qué se fotografía, qué se mide, qué se protege │ tuyo
  context.md         lo que tu repositorio añade a los comandos    │
  templates/         issue.md y epic.md: el contrato               ┘
  steps/             un fichero por paso del loop                  ┐
  checks/            un check de calidad por fichero               │ del paquete:
  lib/               lo que comparten los pasos                    │ "Managed by aio"
  scorers/laya/      el modelo que puntúa el riesgo, opcional      │
  aio                el único canal del agente: aio done, aio issue┘
.ai/commands/aio/    explore, refine, propose, implement, review-diff, review
.claude/hooks/       pre-tool-use
scripts/             lo que solo usa este repositorio: pack, release…
```

El árbol de la carpeta: arriba lo que es tuyo, abajo lo que trae el paquete, y cada fichero del paquete lo dice en su primera línea. [clic]

**Lo que trae**

Lo que sale tiene la misma forma, escriba quien escriba: analizadores y warnings como errores.

Lo que no puede hacer: un --no-verify o un merge por fuera del script no pasa. Los documentos informan; los hooks bloquean.

El agente habla con el orquestador, no con GitHub: aio issue, aio pr. Hoy el vendor es GitHub; mañana el mismo harness sirve para Azure DevOps.

Es un paquete: un botón escribe la carpeta, las plantillas, los comandos y el hook en cualquier repositorio, y el repositorio hace suyos el gate y la configuración.

### 12. La issue es el DoR <!-- ov=contrato -->

Lo que recibe es la issue, y la issue es una plantilla: qué pasa hoy, qué tiene que pasar, dónde cae, cómo comprobarlo y lo que no es. Es el DoR de siempre, escrito para que lo lea una máquina. [clic]

**El refiner devuelve la issue**

Esos 90 huecos de agosto ahora son preguntas. El refiner lee la plantilla y, si una sección no responde lo que pide, devuelve la issue con las preguntas en vez de inventar.


Cambias la plantilla y cambias el DoR, sin tocar ningún prompt. Lo que está en un documento, el agente lo interpreta. Lo que está en una plantilla, un hook o un analizador, se cumple.

### 12a. Mientras tanto, mi issue <!-- ov=aprobar -->

La issue que lancé al principio ya tiene plan, y no me ha esperado: ha pasado sola a implementar. En el dogfood, el loop no se para en el plan. En el repo del orquestador sí: después del plan corre un score de riesgo, y si sale alto, el loop espera a una persona con la pregunta de siempre, «¿es esto lo que queremos?». Dónde decide una persona no está en un prompt: está en el yaml de cada repositorio.

---

## 02 · El loop y lo que entrega cada paso (8 min)

### 13. 02 · Evidencias <!-- ov=sec02 -->

Bloque 2: cómo sabes qué ha hecho. El loop y lo que entrega cada paso.

### 14. El loop es un fichero <!-- ov=abstracto -->

El flujo de antes no está en el código. Es un yaml de un centenar de líneas. Cada estado es una etiqueta de la issue, y en cada estado pasa una sola cosa: un agente con un comando, o un script. Lo escribimos a mano porque queríamos ese control; GitHub Agentic Workflows, Conductor o n8n resuelven lo mismo. [clic]

**Al motor le da igual**

Al motor le da igual qué estado sea. Lee la etiqueta, mira el yaml y hace lo que diga la fila. No sabe qué es refinar ni qué es verificar.


Añadir un paso es añadir cuatro líneas al yaml. Así metimos el score, las capturas y la retro sin cambiar el motor.

### 15. Un paso siempre es igual <!-- ov=paso -->

Dentro, un paso siempre es igual, sea de un agente o de un script. Son mis principios, sacados de varios proyectos; cada equipo tendría que decidir los suyos. El motor hace siempre lo mismo, y empieza preparando: reserva la issue con la rama y la etiqueta, porque si existe la rama alguien está en ello, y le da un sitio donde trabajar. Que sea un worktree o un sandbox es un detalle: el paso no lo sabe. [clic]

**run**

Después corre lo que diga el yaml: el agente con su comando, en un terminal de verdad y grabado, o el script. [clic]

**Anota y decide**

Recoge una línea de JSON: cómo acabó y por qué. El motor no lee la salida, lee esa línea. Si un agente no la escribe, o elige un resultado que su estado no tiene, el run ha fallado: lo que el agente dice de sí mismo es entrada no fiable. Escribe la fila en la issue, con quién, cuánto tardó, cuánto costó y cómo acabó, y pone la etiqueta siguiente, la que diga el yaml para ese resultado.

Entre dos pasos solo cambia lo que corre en el medio. Lo determinista es el camino que se toma con la respuesta, nunca la respuesta.

### 16. El gate es el DoD <!-- ov=gate -->

El 15 de agosto un agente ejecutó dotnet test sin la solución. Dijo que habían pasado 118 tests. La suite tenía 250. Los 132 que faltaban eran los que vigilan las fronteras entre módulos, y ese cambio se mergeó.

No lo hizo por malicia, lo hizo por literalidad. Si una comprobación se puede ejecutar a medias, un agente la ejecutará a medias. [clic]

**Un comando, sin mitades**

Así que el gate es un script: corre un solo comando, aspire do ci, y dice cuántos tests contó: hoy 875. Detrás, quality mide lo que tocó el cambio: cobertura, CRAP, mutación y duplicación. Es el informe de CI de siempre, en la issue.


Y lo corre el loop, no el agente. Un rojo que no dice por qué es casi tan malo como un verde que miente.

### 17. Los informes viven en la issue <!-- ov=evidencias -->

Al principio todo lo que el loop sabía vivía en la base de datos de mi portátil. Abrí la app instalada, con su base nueva, y la épica de esa misma tarde salía vacía. Así que lo movimos todo al sitio que ya compartimos todos, la issue. El estado es la etiqueta, status:in-progress, y la reserva es la rama change/43: dos motores no se pisan sin una base de datos compartida. El plan, la revisión y la retro son comentarios que escriben los agentes. [clic]

**El journey y las capturas**

El journey es un comentario que el motor edita en cada transición: una fila por paso, con quién, cuánto tardó, cuánto costó y cómo acabó. Y las capturas las saca evidence después del gate: cada pantalla que el cambio toca, en claro y en oscuro, a 1440 y a 390. Es el QA de antes, sin que nadie haga las capturas a mano. [clic]

**La rama aio/evidence**

Las grabaciones de cada sesión van a una rama huérfana, aio/evidence, un commit por run. Levanté otra instancia con la base vacía y el journey seguía ahí, y la grabación se reprodujo igual. Si solo enseñas el resultado, es una demostración. Si dejas lo necesario para refutarlo, es una evidencia.

---

## 03 · Cómo trabaja una persona con diez agentes (10 min)

### 19. 03 · Diez issues a la vez <!-- ov=sec03 -->

Bloque 3: cómo trabaja una persona con diez agentes, y dónde corre cada uno.

### 20. Una rama ya no basta <!-- ov=wtque -->

**Antes · una persona**

Antes, una persona convivía con varias ramas sin problema: git stash, git switch y vuelves. Solo corría una cosa a la vez, así que la app, los puertos y la base de datos eran los mismos y no chocaban. [clic]

**Hoy · diez agentes, a la vez**

Con diez agentes a la vez eso ya no vale. Un worktree: otra carpeta del mismo repositorio, con su rama, una por agente. Un runtime aislado, porque el 15 de agosto un agente levantó su Postgres sobre mi carpeta de datos y perdí el historial: el código estaba separado, los datos no. Y un sandbox, sbx, cuando además hay que aislar la máquina.

De los tres, el que no os podéis saltar es el segundo: aspire start --isolated. Da a cada checkout sus puertos, sus secretos y su base de datos. Sin él, el worktree no os protege: dos agentes acaban escribiendo en la misma base de datos.


Una rama aísla el trabajo de una persona. Diez agentes necesitan aislar la carpeta, el runtime y la máquina.

### 21. Demo · el selector de entorno <!-- ov=dsel hide -->

En directo: la página del folder del dogfood, con una fila por paso del loop y un selector: worktree o Docker sandbox. Implement está en Docker sandbox.

Elegimos dónde corre cada agente sin cambiar su comando ni el contrato del loop. Vivimos en el worktree y subimos al sandbox el paso que escribe código. [clic]

**Lo integrado y lo medido**

Worktree y sbx están integrados en el selector. ACA Sandbox y Kata los hemos probado aparte; si alguien pregunta, están en la reserva.

Haz clic fuera del recuadro para volver a navegar con el teclado.

### 22. Docker Sandbox · un kernel y una red con límites <!-- ov=sbx hide -->

Abrir la [terminal de la demo](http://127.0.0.1:7681), backend **2 · Docker sbx**. Los entornos están preparados antes de empezar.

Un contenedor Docker normal comparte el kernel de su host. sbx crea una microVM con kernel propio y su propio Docker: pudimos arrancar Postgres con Testcontainers dentro, sin usar el daemon del host. [clic]

**La red**

En la terminal del sandbox:

```bash
uname -r
curl -sS -o /dev/null -w '%{http_code}\n' https://api.nuget.org/v3/index.json
```

Con la política `balanced`, NuGet devuelve 403. Aislar la red también puede romper el restore. Dentro del sandbox no hay `sbx`: el agente no puede abrirse la red a sí mismo. Desde el host, en la pestaña 1 · Local de la misma terminal:

```bash
sbx policy allow network --sandbox pty-demo api.nuget.org
```

De vuelta en la pestaña 2 · Docker sbx, el mismo `curl` devuelve 200. Hemos abierto un host para este sandbox, no toda la red. [clic]

**El montaje y los permisos también cuentan**

El loop usa `--clone`: el agente escribe en su clon y la rama vuelve con un fetch. Una microVM no protege una carpeta que le montas con escritura, y el agente puede usar los permisos que le da el proxy aunque no vea el token.

### 23. Qué aísla cada uno, y qué no <!-- ov=aisla -->

Más aislado no es mejor: cada opción cuesta algo. El worktree separa el trabajo; sbx añade una VM en tu portátil; ACA la ofrece gestionada y en remoto; Kata la pone por pod en Kubernetes. Eliges según lo que el agente podría romper y lo que necesita para trabajar: si tiene que levantar Docker, si necesita red, si toca tus credenciales.


El sandbox limita dónde puede hacer daño. El gate y las evidencias responden a la otra pregunta: si hizo lo que tenía que hacer. Hacen falta las dos cosas.

### 24. Diez a la vez sin pisarse <!-- ov=diez -->

Separar carpetas no basta si dos agentes van a cambiar el mismo fichero, o si uno necesita lo que hace otro. Cada issue dice qué ficheros toca, en Dónde cae, y si dos chocan, una espera. Y la épica tiene un grafo en su descripción: qué va después de qué. [clic]

**El diario del 14 de octubre**

El 14 de octubre etiqueté las cuatro sub-issues de una épica a la vez, y el diario dijo esto. Nadie tocó una etiqueta más. Cada una arrancó cuando la anterior se integró.

### 25. Tú miras un sitio <!-- ov=needsyou -->

Con diez agentes no puedes mirar diez terminales. Todo corre solo, y lo que se para sale en Needs you con lo que hay que hacer. El 14 de octubre se me cayó el login de Claude Code, y en setenta segundos las dos issues en marcha estaban paradas. [clic]

**El hold, tal cual**

"Claude Code is not logged in. Run claude /login, then release." Antes de eso, la misma situación nos tuvo una hora con dos agentes esperando una aprobación que nadie veía.

### 26. Y cómo sabes si mejora <!-- ov=mejora -->

**El cuello de botella**

Antes ya mirábamos las métricas de delivery. Siguen haciendo falta. Este octubre, un estudio de Harvard con datos de setecientas empresas: con agentes se escribe un 30 % más de código y se cierran las mismas issues. Lo que sube es el tiempo de PR a merge, un 49 %. El cuello de botella ya no es escribir, es quien revisa. Con diez agentes, ese eres tú. [clic]

**Dónde se va el tiempo**

Como cada transición está en el diario y cada hold tiene su motivo, se puede partir el tiempo de cada PBI en quién lo tiene. Es una maqueta con números de ejemplo. Si pesa la cola, subes el WIP. Si pesa la persona, miras los holds. [clic]

**Un hold que no atrapó nada**

Esto ya lo tenemos hoy. Un hold que siempre se suelta sin cambios no protege nada, solo te cuesta tiempo. Lo quitas o subes el umbral, y lo decides con datos. [clic]

**Lo siguiente**

El coste por cambio aceptado y no por tokens, el antes y el después de cada cambio del loop, y el código que sigue igual a las cuatro semanas. Ninguna de estas ideas es nuestra. Lo nuestro es que los datos para medirlas ya están en la issue.

---

## Lo que ha pasado mientras hablaba (6 min) <!-- short=Demo -->

### 27. Lo que ha pasado mientras hablaba <!-- ov=secdemo -->

Al principio puse a trabajar al loop con una idea de una línea. Vamos a ver qué ha hecho mientras yo hablaba, sin que nadie la tocara.

### 28. Demo · la issue del principio <!-- ov=dexp hide -->

Una sola vista para toda la demo; el orden es este:

1. La issue: la que escribió el agente con la plantilla, y su etiqueta, status:done.
2. El Journey: una fila por paso, con quién, cuánto tardó, cuánto costó y cómo acabó.
3. El plan en Proposal, que pasó solo a implementar: en el dogfood el loop no se para en el plan.
4. La grabación del implement, reproduciéndose.
5. El gate con lo que contó y quality con lo que midió, y las capturas en Review.
6. El PR mergeado, y la rama aio/evidence con un commit por run.

Si no ha terminado, se enseña dónde está y por qué, y después la del ensayo.

### 28a. La app, con el cambio <!-- ov=dapp hide -->

La app del dogfood corriendo desde mi checkout de main. El PR ya está mergeado: en la pestaña 1 · Local de la terminal, `git pull`, y Vite recarga la página con el saludo. Nadie ha abierto el editor.

Si el loop no ha llegado al merge, el pull no trae nada: se dice y se vuelve al Journey.

### 29. Plan B · arranque <!-- ov=grafo -->

Plan B: la épica aio-dogfood#40 terminada. Arranque: cinco sub-issues, dos parejas tocan el mismo fichero.

**Plan B · a mitad**

A mitad: una corre, otra espera a la que toca su mismo fichero.

**Plan B · final**

Al final: varias a la vez, las primeras ya hechas. Cuatro sub-issues, 8 capturas en cada una del frontend, 24 grabaciones, un rechazo del reviewer, cerrada sola.

---

## Cierre (2 min)

### 30. Para llevaros <!-- ov=ideas -->

Si os lleváis tres cosas: [clic]

**1 · El flujo es el de siempre**

DoR, DoD, tests con su informe, review y métricas de delivery. Lo que hacía un buen equipo hace no mucho es lo que hoy controla a un agente. Cuantas más buenas prácticas tengas, más fácil es.

**2 · Lo que entrega cada paso**

El agente no es determinista; el paso sí. Cada paso deja una línea con su porqué, el gate dice lo que contó, y las evidencias quedan en la issue y en una rama, donde cualquiera puede revisarlas sin tu portátil.

**3 · Un entorno por agente y un solo sitio que mirar**

El worktree separa el código, pero un agente que se equivoca puede seguir rompiendo tu base de datos o tu portátil. aspire start --isolated separa los datos; sbx, ACA o Kata separan la máquina, cada uno con su coste. Y lo que se para no te busca en diez terminales: te espera en Needs you.

### 30a. Probadlo <!-- ov=instalar -->

aio es un .NET tool en nuget.org. Para probarlo sin instalar nada, con .NET 10: dnx aio. Para quedároslo: dotnet tool install -g aio, y aio abre la consola en el navegador; la primera vez os dice qué os falta, git, gh, Node y un CLI de agente. Añadís la carpeta de vuestro repo y un botón instala el harness en .aio/: el loop, el gate, las plantillas y los comandos, y desde ese momento son vuestros. Empezad por una issue pequeña, como la de hoy.

Y un aviso: aio es una prueba de concepto. Sirve para aprender y probar estas ideas en vuestro repo, no para llevarlo a producción: cambia cada semana y no tiene soporte.

### 32. Sponsors <!-- ov=sponsors -->

Gracias a los sponsors.

### 33. Gracias <!-- ov=gracias -->

Gracias. Preguntas.

---

## Reserva · preguntas

### 34. Reserva · Conductor <!-- ov=r1 -->

Mismo principio: YAML versionado, routing determinista, sin un modelo decidiendo el siguiente paso. Pero esos orquestan una ejecución, que empieza y termina. Nuestro loop orquesta el ciclo de vida de una issue, que dura días: el estado es una etiqueta, sobrevive a reinicios, un hold espera a una persona lo que haga falta y el journey queda en la issue. Un paso podría delegar en uno de ellos.

### 37. Reserva · ACA Sandbox <!-- ov=aca hide -->

Cambiar al backend **5 · ACA Sandboxes**. Es Azure Container Apps Sandbox, no una Container App normal ni Dynamic Sessions.

La misma terminal, en un sandbox gestionado en Azure, sin mantener una VM ni un clúster:

```bash
aca sandbox resume -l name=pty-demo
aca sandbox shell -l name=pty-demo -c /bin/sh
```

En la prueba vimos kernel `6.12.8`, usuario root y ningún Docker instalado. Ser root aquí no es ser root en mi portátil, pero tampoco me llevo el checkout, las herramientas ni las credenciales: hay que decidir cómo entra el código y cómo sale el resultado. [clic]

**ACA · dentro**

[clic]

**El coste de alejarlo**

Medimos una creación en 1,6 segundos y la primera shell entre 1,7 y 3,4, en aquella prueba. Para acceder hace falta el rol de datos `Container Apps SandboxGroup Data Owner`; Contributor no nos bastó.

### 38. Reserva · Kata Containers <!-- ov=kata -->

Si ya tienes Kubernetes, la alternativa es Kata Containers: cada pod corre en una VM ligera. [clic]

**Dos pods en el mismo nodo**

```bash
kubectl --context kata-local exec probe-runc -- uname -r
kubectl --context kata-local exec probe-kata -- uname -r
```

Mismo nodo: runc vio `7.0.0-34-generic`; Kata, `6.18.35`. La diferencia en el manifiesto es `runtimeClassName: kata-qemu`. [clic]

**Kata aísla; agent-sandbox gestiona el ciclo de vida**

El controlador `agent-sandbox` añade suspensión y pools. Con un volumen persistente, suspender eliminó el pod y conservó los archivos, no el proceso del agente. Volver a Running tardó entre 28 y 35 segundos. Corre en k3s dentro de una VM Lima de este portátil, y no está conectado al loop.

### 39. Reserva · Coste y suspensión en Kata <!-- ov=r2 -->

En el M4 Pro, con k3s y Kata en una Lima de 4 CPUs y 8 GiB, medimos unos 230 MiB por pod de prueba. Se programaron 15 pods; entre 13 y 15 llegaron a Ready en 240 segundos. No eran quince agentes compilando a la vez.

Un pod Kata arrancó en 11–30 segundos. El Sandbox con volumen tardó 27–45. Suspenderlo eliminó el pod en 3,4–4,5 segundos y conservó el PVC; volver a Running tardó 28–35 y el archivo seguía allí. Se conserva el disco, no la sesión en memoria. Estas son las cifras locales del 13 de octubre, no una capacidad garantizada para producción.

### 40. Reserva · Relajar un control <!-- ov=r3 -->

Hoy sí, y es un hueco. El hook bloquea el --no-verify y el merge por fuera del script, pero nada impide que un implement toque gate o loop.yaml. Lo que para eso es el reviewer y la persona antes del merge. La regla que queremos es que un agente pueda añadir controles y nunca quitarlos.

### 41. Reserva · Cuánto cuesta <!-- ov=r4 -->

Cada fila del journey lleva su coste: los dos implement de un rechazo del dogfood, 0,14 $ y 0,31 $. La épica de 24 tickets de agosto, unos 9,6 millones de tokens. No tenemos todavía una comparación con hacerlo sin loop.

### 42. Reserva · Secretos <!-- ov=r5 -->

Las grabaciones llevan lo que pasó por la terminal. Por eso solo se publican en repositorios con el harness instalado, nunca en uno de cliente que solo tienes abierto. Eso limita dónde se publican, pero no elimina secretos de una grabación.

En sbx, el proxy conserva los tokens en el host; aun así, el agente puede actuar con los permisos concedidos. No hay que imprimir secretos en la terminal ni suponer que ACA o Kata resuelven su gestión automáticamente.
