# Run Docker

```
docker run --rm -it \
           -v "$(pwd)/certs:/etc/letsencrypt" \
           -e DOMAIN="*.testcert.dominio.com" \
           -e CERTBOT_EMAIL="sysadmin@dominio.com" \
           molero/certbot-wildcard:latest
```
