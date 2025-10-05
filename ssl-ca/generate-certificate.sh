#!/bin/bash

if [ -z "$1" ]; then
    echo "Uso: $0 <dominio>"
    echo "Ejemplo: $0 mi-app.local"
    exit 1
fi

DOMAIN=$1
DOMAINS_DIR="./domains"
DOMAIN_DIR="$DOMAINS_DIR/$DOMAIN"

# Configuración
DOMAIN_KEY="$DOMAIN_DIR/$DOMAIN.key"
DOMAIN_CSR="$DOMAIN_DIR/$DOMAIN.csr"
DOMAIN_CRT="$DOMAIN_DIR/$DOMAIN.crt"
DOMAIN_CONF="$DOMAIN_DIR/$DOMAIN.cnf"
ROOT_CRT="./root/root-ca.crt"
ROOT_KEY="./root/root-ca.key"

# Crear directorio del dominio
mkdir -p $DOMAIN_DIR

# Crear configuración del certificado
cat > $DOMAIN_CONF << EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[ dn ]
C = MX
ST = Mexico
L = Mexico
O = Local Development
OU = IT Department
CN = $DOMAIN

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
DNS.3 = localhost
IP.1 = 127.0.0.1
EOF

# Generar clave privada del dominio
openssl genrsa -out $DOMAIN_KEY 2048

# Generar Certificate Signing Request (CSR)
openssl req -new -key $DOMAIN_KEY -out $DOMAIN_CSR -config $DOMAIN_CONF

# Generar certificado firmado por la Root CA
openssl x509 -req -in $DOMAIN_CSR \
    -CA $ROOT_CRT -CAkey $ROOT_KEY -CAcreateserial \
    -out $DOMAIN_CRT -days 825 -sha256 \
    -extensions req_ext -extfile $DOMAIN_CONF

# Crear bundle (certificado + Root CA)
cat $DOMAIN_CRT $ROOT_CRT > $DOMAIN_DIR/$DOMAIN-bundle.crt

echo "✅ Certificado para $DOMAIN generado:"
echo "   - Clave privada: $DOMAIN_KEY"
echo "   - Certificado: $DOMAIN_CRT"
echo "   - Bundle: $DOMAIN_DIR/$DOMAIN-bundle.crt"