#!/bin/bash

echo "🔍 Validando certificados..."

# Validar Root CA
echo "1. Validando Root CA..."
openssl x509 -in root/root-ca.crt -text -noout

# Validar certificado de dominio
DOMAIN="test-app.local"
echo ""
echo "2. Validando certificado para $DOMAIN..."
openssl x509 -in domains/$DOMAIN/$DOMAIN.crt -text -noout

# Verificar cadena de certificación
echo ""
echo "3. Verificando cadena de certificación..."
openssl verify -CAfile root/root-ca.crt domains/$DOMAIN/$DOMAIN.crt

# Verificar con openssl s_client
echo ""
echo "4. Probando conexión SSL..."
echo "Q" | openssl s_client -connect localhost:8443 -servername $DOMAIN -CAfile root/root-ca.crt 2>/dev/null | grep "Verify"

# Test con curl
echo ""
echo "5. Probando con curl..."
curl -I --cacert root/root-ca.crt https://$DOMAIN:8443

echo ""
echo "✅ Validación completada!"