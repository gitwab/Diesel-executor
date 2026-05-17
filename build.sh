#!/bin/bash
# Wineblox Executor - Build Helper Script

set -e  # Exit on any error

echo "================================================"
echo "Wineblox Executor - Build Script"
echo "================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check required tools
echo "[1/3] Checking dependencies..."
DEPS_OK=true

if ! command -v gcc &> /dev/null; then
    echo -e "${RED}✗ gcc not found${NC}"
    echo "  Install: sudo apt-get install build-essential (Ubuntu)"
    echo "           sudo dnf install gcc (Fedora)"
    DEPS_OK=false
fi

if ! pkg-config --exists lua5.1 2>/dev/null && ! pkg-config --exists lua 2>/dev/null; then
    echo -e "${YELLOW}⚠ Lua not found (optional for UI)${NC}"
    echo "  Install: sudo apt-get install liblua5.1-0-dev (Ubuntu)"
    echo "           sudo dnf install lua-devel (Fedora)"
fi

if ! pkg-config --exists gtk4 2>/dev/null; then
    echo -e "${YELLOW}⚠ GTK4 not found (optional for UI)${NC}"
    echo "  Install: sudo apt-get install libgtk-4-dev (Ubuntu)"
    echo "           sudo dnf install gtk4-devel (Fedora)"
fi

if ! pkg-config --exists libcurl 2>/dev/null; then
    echo -e "${YELLOW}⚠ libcurl not found (optional for Script Hub)${NC}"
    echo "  Install: sudo apt-get install libcurl4-openssl-dev (Ubuntu)"
    echo "           sudo dnf install libcurl-devel (Fedora)"
fi

if ! pkg-config --exists json-c 2>/dev/null; then
    echo -e "${YELLOW}⚠ json-c not found (optional for Script Hub)${NC}"
    echo "  Install: sudo apt-get install libjson-c-dev (Ubuntu)"
    echo "           sudo dnf install json-c-devel (Fedora)"
fi

if [ "$DEPS_OK" = false ]; then
    echo ""
    echo -e "${RED}Critical dependencies missing. Cannot continue.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Core dependencies found${NC}"
echo ""

# Clean old builds
echo "[2/3] Cleaning old builds..."
make clean > /dev/null 2>&1 || true
echo -e "${GREEN}✓ Cleaned${NC}"
echo ""

# Build
echo "[3/3] Building..."
if make; then
    echo ""
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo ""
    echo "Built executables:"
    [ -f "atingle" ] && echo "  ✓ atingle (Enhanced UI)"
    [ -f "atingle_enhanced" ] && echo "  ✓ atingle_enhanced (Enhanced UI with Script Hub)"
    [ -f "injector" ] && echo "  ✓ injector (Process Injector)"
    [ -f "sober_test_inject.so" ] && echo "  ✓ sober_test_inject.so (Injected Library)"
    echo ""
    echo "Quick start:"
    echo "  sudo ./injector sober"
    echo ""
else
    echo ""
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi
