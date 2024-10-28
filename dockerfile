FROM debian:latest

RUN apt-get update && \
    apt-get install -y certbot awscli && \
    rm -rf /var/lib/apt/lists/*


RUN apt-get update && \
    apt-get install -y openssl && \
    rm -rf /var/lib/apt/lists/*

# Crea el directorio donde se almacenarán los certificados
VOLUME /etc/letsencrypt

# Copia el script para generar el certificado y el hook de autenticación
COPY generate-cert.sh /usr/local/bin/generate-cert.sh
#COPY auth-hook.sh /usr/local/bin/auth-hook.sh
RUN chmod +x /usr/local/bin/generate-cert.sh

ENTRYPOINT ["/usr/local/bin/generate-cert.sh"]

