#!/bin/bash

# Configuración
ROOT_DIR="./root"
ROOT_KEY="$ROOT_DIR/root-ca.key"
ROOT_CRT="$ROOT_DIR/root-ca.crt"
ROOT_CONF="$ROOT_DIR/root-ca.cnf"

# Crear directorio root si no existe
mkdir -p $ROOT_DIR

# Crear configuración de la Root CA
cat > $ROOT_CONF << EOF
[ req ]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
x509_extensions = v3_ca

[ dn ]
C = MX
ST = Mexico
L = Mexico
O = Local Development
OU = IT Department
CN = Local Development Root CA

[ v3_ca ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
EOF

# Generar clave privada de la Root CA
openssl genrsa -out $ROOT_KEY 4096

# Generar certificado auto-firmado de la Root CA
openssl req -x509 -new -nodes -key $ROOT_KEY -sha256 -days 3650 -out $ROOT_CRT -config $ROOT_CONF

echo "✅ Root CA generada:"
echo "   - Clave privada: $ROOT_KEY"
echo "   - Certificado: $ROOT_CRT"