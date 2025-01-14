#!/bin/bash

# Verifica que las variables necesarias estén configuradas
if [[ -z "$DOMAIN" || -z "$CERTBOT_EMAIL" ]]; then
  echo "Error: Debes especificar las variables de entorno DOMAIN y CERTBOT_EMAIL."
  echo "Uso: docker run -e DOMAIN='*.subdomain.domain.com' -e CERTBOT_EMAIL='sysadmin@domain.com' certbot-wildcard"
  exit 1
fi

# Ejecuta Certbot en modo manual
certbot certonly \
  --manual \
  --preferred-challenges dns \
  -d "$DOMAIN" \
  -d "${DOMAIN#*.}" \
  --email "$CERTBOT_EMAIL" \
  --agree-tos \
  --manual-public-ip-logging-ok

# Pausa para que el usuario agregue el registro DNS
echo "Por favor, agrega el registro DNS TXT indicado y luego presiona Enter para continuar."
read -p "Presiona Enter cuando el registro esté listo..."

# Una vez que presionas Enter, el script continúa y Certbot valida el registro.

if [ $? -eq 0 ]; then
  echo "Generando archivo PFX..."
  
  openssl pkcs12 -export -inkey "/etc/letsencrypt/live/${DOMAIN#*.}/privkey.pem" \
                  -in "/etc/letsencrypt/live/${DOMAIN#*.}/fullchain.pem" \
                  -out "/etc/letsencrypt/live/${DOMAIN#*.}/websocket.pfx" \
                  -name "websocket" \
                  -passout pass:

  echo "Archivo PFX generado: /etc/letsencrypt/${DOMAIN#*.}/websocket.pfx"
else
  echo "La renovación del certificado falló."
fi
