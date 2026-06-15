#!/usr/bin/env bash
# scripts/build_release_android.sh
#
# Build a release Android App Bundle (AAB) for Helm with Dart obfuscation,
# symbol splitting, icon tree-shaking, and arm64-only target enabled.
# This mitigates reverse engineering and shrinks the APK size.
#
# Usage:
#   ./scripts/build_release_android.sh
#
# Prerequisites:
#   - Android release keystore configured in android/key.properties
#   - key.properties is gitignored and never committed
#
# To build a single APK (arm64-v8a only) instead of AAB:
#   flutter build apk --release --obfuscate --split-debug-info=symbols \
#     --tree-shake-icons --target-platform android-arm64

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SYMBOLS_DIR="${PROJECT_ROOT}/symbols"

mkdir -p "${SYMBOLS_DIR}"

cd "${PROJECT_ROOT}"

flutter build appbundle \
  --release \
  --obfuscate \
  --split-debug-info="${SYMBOLS_DIR}" \
  --dart-define=DART_OBFUSCATION=true \
  --tree-shake-icons \
  --target-platform android-arm64

echo "✅ Release AAB built at: ${PROJECT_ROOT}/build/app/outputs/bundle/release/app-release.aab"
echo "📦 Debug symbols stored in: ${SYMBOLS_DIR}"
echo "⚡ APK would be ~20MB (arm64-only, tree-shaken icons)."
echo "⚠️  Keep the symbols directory private; it is required to deobfuscate crash reports."
