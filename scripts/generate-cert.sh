#!/bin/bash

# Script to generate a wildcard SSL certificate for *.local.io and local.io
# This creates a locally-trusted certificate using mkcert for local development

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CERTS_DIR="$PROJECT_ROOT/docker/certs"
CERT_FILE="$CERTS_DIR/wildcard-local.io-cert.pem"
KEY_FILE="$CERTS_DIR/wildcard-local.io-key.pem"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Generating wildcard SSL certificate for *.local.io using mkcert${NC}"

# Check if mkcert is installed
if ! command -v mkcert &> /dev/null; then
    echo -e "${YELLOW}Error: mkcert is not installed${NC}"
    echo "Please install mkcert:"
    echo "  macOS: brew install mkcert"
    echo "  Linux: See https://github.com/FiloSottile/mkcert#installation"
    exit 1
fi

# Create certs directory if it doesn't exist
mkdir -p "$CERTS_DIR"

# Install local CA if not already installed
echo -e "${BLUE}Ensuring local CA is installed...${NC}"
mkcert -install >/dev/null 2>&1 || true

# Generate certificate and key using mkcert
echo "Generating certificate and private key..."
cd "$CERTS_DIR"
mkcert -cert-file "$CERT_FILE" -key-file "$KEY_FILE" "*.local.io" "local.io"

# Set proper permissions
chmod 644 "$CERT_FILE"
chmod 600 "$KEY_FILE"

echo -e "${GREEN}✓ Certificate generated successfully!${NC}"
echo -e "  Certificate: ${YELLOW}$CERT_FILE${NC}"
echo -e "  Private Key: ${YELLOW}$KEY_FILE${NC}"
echo ""
echo "Certificate details:"
openssl x509 -in "$CERT_FILE" -noout -subject -issuer -dates
echo ""
echo -e "${GREEN}Note: This certificate is trusted by your system's root CA store${NC}"

