#!/bin/bash
set -euo pipefail

# Verifica que las variables necesarias estén configuradas
if [[ -z "${DOMAIN:-}" || -z "${CERTBOT_EMAIL:-}" ]]; then
  echo "Error: Debes especificar las variables de entorno DOMAIN y CERTBOT_EMAIL."
  echo "Uso: docker run -it -e DOMAIN='*.subdomain.domain.com' -e CERTBOT_EMAIL='sysadmin@domain.com' certbot-wildcard"
  exit 1
fi

PFX_NAME="${PFX_NAME:-websocket}"
PFX_PASSWORD="${PFX_PASSWORD:-}"
BASE_DOMAIN="${DOMAIN#*.}"
LIVE_DIR="/etc/letsencrypt/live/${BASE_DOMAIN}"

# Certbot en modo manual: él mismo muestra el registro TXT y espera a que pulses Enter.
certbot certonly \
  --manual \
  --preferred-challenges dns \
  -d "$DOMAIN" \
  -d "$BASE_DOMAIN" \
  --email "$CERTBOT_EMAIL" \
  --agree-tos \
  ${CERTBOT_EXTRA_ARGS:-}

echo "Generando archivo PFX..."

openssl pkcs12 -export \
  -inkey "${LIVE_DIR}/privkey.pem" \
  -in "${LIVE_DIR}/fullchain.pem" \
  -out "${LIVE_DIR}/${PFX_NAME}.pfx" \
  -name "${PFX_NAME}" \
  -passout "pass:${PFX_PASSWORD}"

echo "Archivo PFX generado: ${LIVE_DIR}/${PFX_NAME}.pfx"
