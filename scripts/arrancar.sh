#!/usr/bin/env bash
# Levanta lo que la charla necesita, en segundo plano y sin depender de ningún terminal ni sesión:
# el deck (:4173), los sandboxes de la demo (sbx y ACA) y la página de terminales (:7681).
# Lo que ya responde no se toca. Los logs quedan en ~/Library/Logs/diez-agentes/.
#
#   npm run arrancar
#
# La app de aio (:48117) no se arranca aquí: es la app instalada, y se abre con `aio`.
set -u

TALK=$(cd "$(dirname "$0")/.." && pwd)
AIO=${AIO_REPO:-$HOME/projects/charlas/ai-orchestator-new}
DOGFOOD=${DOGFOOD_REPO:-$HOME/projects/charlas/aio-dogfood}
LOGS=$HOME/Library/Logs/diez-agentes
# El sandbox group de la demo, sin tocar la configuración guardada de aca. La pestaña 1 · Local de la
# página de terminales hereda este entorno, así que `aca sandbox list` funciona también ahí.
export ACA_SUBSCRIPTION=${ACA_SUBSCRIPTION:?set ACA_SUBSCRIPTION to your Azure subscription id}
export ACA_RESOURCE_GROUP=${ACA_RESOURCE_GROUP:-netcoreconf-dev-rg-01}
export ACA_SANDBOX_GROUP=${ACA_SANDBOX_GROUP:-ptydemo}
export ACA_REGION=${ACA_REGION:-northeurope}
mkdir -p "$LOGS"

answers() { curl -s -o /dev/null -m 3 -w "%{http_code}" "http://127.0.0.1:$1${2:-/}" | grep -q '^200$'; }

start() { # nombre puerto[/ruta que da 200] directorio orden…
  local name=$1 port=${2%%/*} path=/ dir=$3
  case $2 in */*) path=/${2#*/} ;; esac
  shift 3
  if answers "$port" "$path"; then echo "✓ $name ya responde en :$port"; return; fi
  (cd "$dir" && nohup "$@" >"$LOGS/$name.log" 2>&1 &)
  for _ in $(seq 1 90); do answers "$port" "$path" && break; sleep 1; done
  if answers "$port" "$path"; then echo "✓ $name arrancado en :$port"; else echo "✗ $name no responde en :$port: mira $LOGS/$name.log"; fi
}

echo "▸ Sandboxes de la demo"
# `demo.sh up` también crea el cluster de kind, que la charla no usa: solo se llama si falta el sbx.
if sbx ls 2>/dev/null | grep -q '^pty-demo '; then
  echo "✓ sbx pty-demo ya existe"
else
  (cd "$AIO/infra/pty-demo" && DEMO_WORKSPACE="$DOGFOOD" ./demo.sh up --no-vm --no-kata >"$LOGS/demo-up.log" 2>&1) \
    && echo "✓ demo.sh up" || echo "✗ demo.sh up falló: mira $LOGS/demo-up.log"
fi

echo "▸ Servicios"
start deck 4173 "$TALK" python3 -m http.server 4173 --bind 127.0.0.1 --directory deck
start terminales 7681 "$AIO/infra/pty-demo" node server.js
# La app del dogfood desde su checkout de main, con puertos fijos para el iframe del final. Vite recarga
# la página cuando cambian los ficheros: tras el merge, un `git pull` enseña el cambio.
start dogfood-api 4175/api/weatherforecast "$DOGFOOD" dotnet run --project AioDogfood.Server --no-launch-profile --urls http://127.0.0.1:4175
SERVER_HTTP=http://127.0.0.1:4175 start dogfood-web 4174 "$DOGFOOD/frontend" npx vite --host 127.0.0.1 --port 4174 --strictPort

echo
echo "Ahora: npm run preflight"
