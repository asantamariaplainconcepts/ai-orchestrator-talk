# Demo de aislamiento: worktree, Docker sandbox y ACA Sandbox

La demo del bloque 01 (*¿cuánto puede romper?*). Tres niveles, tres terminales, y en cada uno la
misma pregunta: ¿qué ve el agente de mi máquina?

La página es `infra/pty-demo` del repo `ai-orchestrator-new` (en master): una terminal xterm.js en
el navegador con un backend por nivel. Para la charla bastan tres de sus cinco backends:

| Nivel | Backend de la página | Qué se enseña |
| --- | --- | --- |
| 1 · worktree | 1 · host | `git worktree list`: los worktrees del loop, cada uno con su rama. El kernel y el usuario son los tuyos |
| 2 · Docker sandbox | 2 · sbx en el portátil | Otro kernel (microVM), otro usuario, y **nuget.org bloqueado** hasta que le das permiso solo a ese sandbox |
| 3 · ACA Sandbox | 5 · ACA Sandboxes | Una máquina en Azure con otro kernel, sin tu identidad, creada en 1,6 s |

Los backends 3 (sbx en una VM de Azure) y 4 (agent-sandbox en kind) se quedan fuera: añaden dos
cosas que pueden fallar en el escenario y no cuentan nada que no cuenten el 2 y el 5.

## El guion de la demo (3–4 min)

**Nivel 1 · host**

```bash
cd ~/projects/charlas/ai-orchestrator-new && git worktree list
uname -r; whoami
```

> Cada agente tiene su worktree y su rama. Pero mirad el kernel y el usuario: son los míos. Si el
> agente hace `rm -rf ~`, es mi `~`.

**Nivel 2 · sbx en el portátil** (sandbox `pty-demo`, con `aio-dogfood` montado)

```bash
uname -r; whoami
ls                                    # el repo del dogfood, montado
curl -s -o /dev/null -w "%{http_code}\n" https://api.nuget.org/v3/index.json    # 403
curl -s -o /dev/null -w "%{http_code}\n" https://github.com                     # 200
```

> Otro kernel y otro usuario. Pero intento lo primero que haría cualquier agente de .NET, un
> restore, y nuget.org me devuelve un 403. Aislar la red es justo lo que queríamos y justo lo que
> nos rompe el restore.

En otra terminal del portátil (no dentro del sandbox):

```bash
sbx policy allow network --sandbox pty-demo api.nuget.org
```

Y de vuelta en el sandbox:

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://api.nuget.org/v3/index.json    # 200
```

> Una regla solo para este sandbox. Nada global. Cada nivel quita una superficie y te cobra en
> fricción: aquí la fricción es saber a qué hosts necesita salir tu build.

**Nivel 3 · ACA Sandboxes**

```bash
uname -r; whoami
env | grep -i -E "azure|token|github" || echo "ninguna credencial mía"
```

> Una máquina que no es la mía, en Azure, creada en un segundo y medio. Root aquí dentro, pero sin
> mi identidad. Si se para, no paga CPU. El precio: todo lo que en el nivel 1 era un `git diff`
> aquí es un push y un pull.

## Preparación

### El día antes

1. **Azure, en el tenant de la suscripción de la demo:** Labsplain, tenant `<tenant-id>`, suscripción `<subscription-id>`, grupo `netcoreconf-dev-rg-01`, sandbox group `ptydemo` en northeurope.
   - `az login --tenant <tenant-id>` (pide MFA; en la selección, Enter para Labsplain).
   - La configuración guardada de `aca` apunta a otro grupo que ya no existe (`aio-exercise`). No hace falta tocarla: `demo.sh` y el servidor pasan `ACA_SUBSCRIPTION`, `ACA_RESOURCE_GROUP`, `ACA_SANDBOX_GROUP` y `ACA_REGION` de la demo. Para probar a mano, exportar esas cuatro variables antes de `aca`.
   - Comprobar el acceso: con esas variables, `aca sandbox list` enseña `name=pty-demo` en vez de un 403.
2. **Levantar sin la VM ni Kata, con el dogfood como workspace:**
   `cd infra/pty-demo && DEMO_WORKSPACE=~/projects/charlas/aio-dogfood ./demo.sh up --no-vm --no-kata`.
   Crea el sandbox local `pty-demo` de sbx, reanuda el `pty-demo` de ACA (no crea uno nuevo si ya existe) y levanta el clúster de kind del backend 4b. Si `pty-demo` de sbx ya existía con otro workspace, borrarlo antes: `sbx rm --force pty-demo`.
3. Comprobar que nuget está bloqueado:
   `sbx exec pty-demo sh -c 'curl -s -o /dev/null -w "%{http_code}\n" https://api.nuget.org/v3/index.json'`
   tiene que dar `403`. Si da `200`, quitar la regla:
   `sbx policy rm network --sandbox pty-demo --resource api.nuget.org`.

Comprobado el 22 de octubre: sbx con kernel 7.0.12, usuario `agent` y el dogfood montado, nuget 403 y github 200; ACA con kernel 6.12.8, root, sin Docker, y 4,1 s hasta el primer byte.

### Antes de subir

- `./demo.sh serve` y abrir `http://127.0.0.1:7681`. La página carga xterm.js de `cdn.jsdelivr.net`: sin red en la sala no pinta la terminal, y toca el plan B.
- Abrir una terminal en cada uno de los tres backends para que el primer byte no se espere en escena (sbx: 0,4–1,8 s; ACA: 1,7–4,1 s). Un ACA Sandbox parado no abre shell; el backend hace `resume` antes de cada conexión, y eso añade unos segundos.

### Plan B

`infra/pty-demo/screenshots/` tiene una captura por backend (`1-local.jpg`, `2-sbx-laptop.jpg`,
`5-aca-sandboxes.jpg`). El momento del 403 → 200 conviene grabarlo con `asciinema` el día antes.

### Después

`./demo.sh down` borra el sandbox local, el clúster de kind y el ACA Sandbox.

## Medido (10 de octubre de 2026, sbx v0.38.0)

- Sandbox de prueba con `aio-dogfood` montado: kernel 7.0.12, usuario `agent`, el repo montado en su misma ruta.
- `api.nuget.org` → 403; `github.com` y `registry.npmjs.org` → 200 con la política por defecto.
- Con `sbx policy allow network --sandbox <sandbox> api.nuget.org` → 200; al quitar la regla,
  403 otra vez.
