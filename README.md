# certbot-wildcard

Imagen Docker que genera un certificado wildcard de Let's Encrypt mediante desafío DNS manual y lo exporta también como `.pfx`.

## Ejecutar

```
docker run --rm -it \
           -v "$(pwd)/certs:/etc/letsencrypt" \
           -e DOMAIN="*.testcert.dominio.com" \
           -e CERTBOT_EMAIL="sysadmin@dominio.com" \
           molero/certbot-wildcard:v2.0
```

Certbot mostrará el registro DNS `TXT` (`_acme-challenge`) que debes crear; pulsa Enter cuando esté propagado.
El proceso es interactivo (`-it`), por lo que no sirve para ejecuciones desatendidas (cron).

## Variables de entorno

| Variable | Obligatoria | Descripción |
|---|---|---|
| `DOMAIN` | sí | Dominio wildcard, p. ej. `*.sub.dominio.com` (también se incluye `sub.dominio.com`) |
| `CERTBOT_EMAIL` | sí | Email de registro en Let's Encrypt |
| `PFX_NAME` | no | Nombre del PFX y alias (por defecto `websocket`) |
| `PFX_PASSWORD` | no | Contraseña del PFX (por defecto vacía) |
| `CERTBOT_EXTRA_ARGS` | no | Argumentos extra para certbot, p. ej. `--staging` para pruebas |

## Salida

En `certs/live/<dominio-base>/`: `fullchain.pem`, `privkey.pem` y `<PFX_NAME>.pfx`.

## Build local

```
docker build -t certbot-wildcard .
```
