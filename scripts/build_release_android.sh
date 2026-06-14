#!/usr/bin/env bash
# scripts/build_release_android.sh
#
# Build a release Android App Bundle (AAB) for Helm with Dart obfuscation
# and symbol splitting enabled. This mitigates reverse engineering by stripping
# human-readable identifiers from the release binary.
#
# Usage:
#   ./scripts/build_release_android.sh
#
# Prerequisites:
#   - Android release keystore configured in android/key.properties
#   - key.properties is gitignored and never committed

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
  --dart-define=DART_OBFUSCATION=true

echo "✅ Release AAB built at: ${PROJECT_ROOT}/build/app/outputs/bundle/release/app-release.aab"
echo "📦 Debug symbols stored in: ${SYMBOLS_DIR}"
echo "⚠️  Keep the symbols directory private; it is required to deobfuscate crash reports."
