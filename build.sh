#!/bin/bash
set -e

echo "[🧹] Entferne problematische Compiler-Flags"
# find . -name "CMakeLists.txt" -exec sed -i 's/-ferror-limit=4096//g' {} +
# find . -name "CMakeLists.txt" -exec sed -i 's/-Walign-cast//g' {} +

rm -r build
mkdir -p build

CC=clang CXX=clang++ cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DDOTNET_DIR=/opt/dotnet/ \
  -DCORECLR_DIR=/src/runtime/src/coreclr \
  -DCMAKE_C_FLAGS="-Wno-unknown-pragmas -Wno-implicit-fallthrough -Wno-pragmas" \
  -DCMAKE_CXX_FLAGS="-Wno-unknown-pragmas -Wno-implicit-fallthrough -Wno-pragmas"

# Kompilieren
make -j1

echo "[✅] Build abgeschlossen: build-armv7/netcoredbg"
 