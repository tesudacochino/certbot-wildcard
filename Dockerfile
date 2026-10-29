FROM debian:12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends certbot openssl && \
    rm -rf /var/lib/apt/lists/*

# Directorio donde se almacenarán los certificados
VOLUME /etc/letsencrypt

# Script que genera el certificado y el PFX
COPY generate-cert.sh /usr/local/bin/generate-cert.sh
RUN chmod +x /usr/local/bin/generate-cert.sh

ENTRYPOINT ["/usr/local/bin/generate-cert.sh"]
