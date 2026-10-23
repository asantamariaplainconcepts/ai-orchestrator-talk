#!/usr/bin/env bash
# Comprueba, sin cambiar nada, que todo lo que usa la charla está listo, y dice qué hacer con lo que
# no. Sale con 0 solo si todo está en verde.
#
#   npm run preflight
set -u

TALK=$(cd "$(dirname "$0")/.." && pwd)
DOGFOOD=${DOGFOOD_REPO:-$HOME/projects/charlas/aio-dogfood}
export ACA_SUBSCRIPTION=${ACA_SUBSCRIPTION:?set ACA_SUBSCRIPTION to your Azure subscription id}
export ACA_RESOURCE_GROUP=${ACA_RESOURCE_GROUP:-netcoreconf-dev-rg-01}
export ACA_SANDBOX_GROUP=${ACA_SANDBOX_GROUP:-ptydemo}
export ACA_REGION=${ACA_REGION:-northeurope}
LABSPLAIN=<tenant-id>

failed=0
ok() { echo "  ✓ $1"; }
ko() { echo "  ✗ $1"; echo "      → $2"; failed=$((failed + 1)); }
# macOS no trae `timeout`: corta una orden a los N segundos.
within() { perl -e 'alarm shift; exec @ARGV' "$@"; }
answers() { curl -s -o /dev/null -m 3 -w "%{http_code}" "http://127.0.0.1:$1/" | grep -q '^200$'; }

echo "▸ La máquina"
free=$(df -g /System/Volumes/Data | awk 'NR==2 {print $4}')
if [ "${free:-0}" -ge 10 ]; then ok "disco: $free GiB libres"; else ko "disco: solo $free GiB libres" "libera espacio: un gate y las capturas escriben varios GiB"; fi
if curl -s -o /dev/null -m 5 https://cdn.jsdelivr.net/npm/@xterm/xterm@5.5.0/css/xterm.css; then ok "red: la página de terminales carga xterm.js"; else ko "sin red hacia cdn.jsdelivr.net" "la página de terminales no pintará: usa el plan B de capturas"; fi

echo "▸ Servicios"
answers 4173 && ok "deck en :4173" || ko "el deck no responde en :4173" "npm run arrancar"
(cd "$TALK" && node scripts/sync-deck.mjs --check >/dev/null 2>&1) && ok "deck al día con guion-slides.md" || ko "el deck no está al día con el guion" "npm run sync"
answers 7681 && ok "terminales en :7681" || ko "la página de terminales no responde en :7681" "npm run arrancar"
curl -s -m 5 http://127.0.0.1:4174/api/weatherforecast | grep -q temperatureC && ok "app del dogfood en :4174, con su API" || ko "la app del dogfood no responde en :4174" "npm run arrancar; mira ~/Library/Logs/diez-agentes/dogfood-*.log"
answers 48117 && ok "app de aio en :48117" || ko "la app de aio no responde en :48117" "abre la app instalada: aio"

echo "▸ Sesiones"
claude auth status 2>/dev/null | grep -q '"loggedIn": true' && ok "Claude Code con sesión" || ko "Claude Code sin sesión" "claude /login"
gh auth status >/dev/null 2>&1 && ok "gh con sesión" || ko "gh sin sesión" "gh auth login"
tenant=$(az account show --query tenantId -o tsv 2>/dev/null)
[ "$tenant" = "$LABSPLAIN" ] && ok "az en Labsplain" || ko "az no está en Labsplain (está en ${tenant:-ninguno})" "az login --tenant $LABSPLAIN"

echo "▸ Sandboxes"
if within 30 sbx exec pty-demo sh -c 'curl -s -o /dev/null -w "%{http_code}" https://api.nuget.org/v3/index.json' 2>/dev/null | grep -q 403; then
  ok "sbx pty-demo en marcha, con nuget bloqueado (403)"
else
  ko "sbx pty-demo no responde o nuget no da 403" "npm run arrancar; si da 200: sbx policy rm network --sandbox pty-demo --resource api.nuget.org"
fi
# Los roles de ACA, vistos desde PIM: si alguno es una activación, dice cuándo caduca.
RG=/subscriptions/$ACA_SUBSCRIPTION/resourceGroups/$ACA_RESOURCE_GROUP
roles=$(within 40 az rest --method get --url "https://management.azure.com/subscriptions/$ACA_SUBSCRIPTION/providers/Microsoft.Authorization/roleAssignmentScheduleInstances?api-version=2020-10-01&\$filter=asTarget()" 2>/dev/null)
for need in "Container Apps SandboxGroup Data Owner|$RG/providers/Microsoft.App/sandboxGroups/$ACA_SANDBOX_GROUP|usar el sandbox" "Contributor|$RG|recrear el sandbox group"; do
  IFS='|' read -r role scope why <<<"$need"
  until=$(echo "$roles" | python3 -I -c '
import json, sys, datetime as dt
role, scope = sys.argv[1], sys.argv[2].lower()
now = dt.datetime.now(dt.timezone.utc)
for x in json.load(sys.stdin)["value"]:
    p = x["properties"]
    if p["expandedProperties"]["roleDefinition"]["displayName"] != role: continue
    if not (scope + "/").startswith(p["scope"].lower().rstrip("/") + "/"): continue  # en el recurso o en algo que lo contiene
    end = p.get("endDateTime")
    if not end: print("sin fecha de fin"); break
    left = dt.datetime.fromisoformat(end.replace("Z", "+00:00")) - now
    print(("hasta " if left > dt.timedelta(hours=12) else "CADUCA ") + end[:16].replace("T", " ") + " UTC"); break
' "$role" "$scope" 2>/dev/null)
  case "$until" in
    "") ko "$role en ${scope##*/}: no lo tienes (o az no responde)" "actívalo en PIM (lo necesitas para $why) o az login --tenant $LABSPLAIN" ;;
    CADUCA*) ko "$role en ${scope##*/}: ${until#CADUCA } (menos de 12 h)" "actívalo de nuevo en PIM justo antes de la charla" ;;
    *) ok "$role en ${scope##*/}, $until" ;;
  esac
done
if within 40 aca sandbox list 2>/dev/null | grep -q "name=pty-demo"; then ok "ACA responde y tiene pty-demo"; else ko "ACA no responde o no tiene pty-demo" "az login --tenant $LABSPLAIN, y npm run arrancar"; fi

echo "▸ La demo en vivo (aio-dogfood)"
git -C "$DOGFOOD" fetch -q 2>/dev/null
behind=$(git -C "$DOGFOOD" rev-list --count HEAD..origin/main 2>/dev/null || echo "?")
[ "$behind" = 0 ] && ok "dogfood en main, al día" || ko "el dogfood no está al día ($behind commits detrás)" "git -C $DOGFOOD pull --ff-only"
open=$(cd "$DOGFOOD" && gh issue list --state open --json number -q 'length' 2>/dev/null)
[ "${open:-1}" = 0 ] && ok "ninguna issue abierta en el dogfood" || ko "hay $open issues abiertas en el dogfood" "ciérralas o asegúrate de que no ocupan el wip"
loop=$(curl -s -m 5 http://127.0.0.1:48117/api/loop/present 2>/dev/null)
if echo "$loop" | python3 -I -c 'import json,sys; d=json.load(sys.stdin); f=[x for x in d["folders"] if x["repository"].endswith("/aio-dogfood")][0]; sys.exit(0 if d["enabled"] and f["on"] and not f["problem"] else 1)' 2>/dev/null; then
  ok "motor encendido para el dogfood"
else
  ko "el motor no está encendido para el dogfood" "en la app: Loop, enciende el motor y la carpeta aio-dogfood"
fi

echo
if [ "$failed" = 0 ]; then echo "Todo en verde: la charla está lista."; else echo "$failed cosas en rojo: arréglalas y vuelve a pasar npm run preflight."; fi
exit "$failed"
