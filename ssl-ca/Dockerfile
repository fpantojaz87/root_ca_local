FROM alpine:3.18

# Instalar dependencias
RUN apk add --no-cache \
    openssl \
    curl \
    nginx \
    ca-certificates

# Crear directorios de trabajo
WORKDIR /ca

# Copiar scripts
COPY generate-root-ca.sh generate-certificate.sh ./
COPY root/ ./root/

# Hacer ejecutables los scripts
RUN chmod +x *.sh

# Exponer puerto para pruebas
EXPOSE 80 443

CMD ["/bin/sh"]