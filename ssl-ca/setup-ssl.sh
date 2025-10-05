#!/bin/bash

# Hacer ejecutables los scripts
chmod +x generate-root-ca.sh generate-certificate.sh

# Generar Root CA
echo "🔐 Generando Root CA..."
./generate-root-ca.sh

# Generar certificado de ejemplo
echo "📝 Generando certificado para test-app.local..."
./generate-certificate.sh test-app.local

# Construir y levantar contenedores
echo "🐳 Iniciando contenedores Docker..."
docker-compose up -d

echo ""
echo "✅ Configuración completada!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Instala la Root CA en tu sistema:"
echo "   - Linux: sudo cp root/root-ca.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates"
echo "   - Windows: Importar root/root-ca.crt como 'Entidades de certificación raíz de confianza'"
echo "   - macOS: Abrir Keychain Access → Importar root/root-ca.crt → Marcar como confiable"
echo ""
echo "2. Agrega al /etc/hosts:"
echo "   127.0.0.1 test-app.local"
echo ""
echo "3. Testear:"
echo "   curl -k https://test-app.local:8443"
echo ""