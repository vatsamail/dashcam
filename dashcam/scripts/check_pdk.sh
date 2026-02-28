#!/usr/bin/env bash
set -euo pipefail
if [ -z "${PDK_ROOT:-}" ]; then
  # Try common OpenLane/Volare location
  CIEL_ROOT="${HOME}/.ciel/ciel/sky130/versions"
  if [ -d "${CIEL_ROOT}" ]; then
    FOUND="$(find "${CIEL_ROOT}" -maxdepth 2 -type d -name sky130A 2>/dev/null | head -n 1 || true)"
    if [ -n "${FOUND}" ]; then
      export PDK_ROOT="$(dirname "${FOUND}")"
      echo "PDK_ROOT not set. Using detected PDK_ROOT=${PDK_ROOT}"
      echo "Hint: export PDK_ROOT=${PDK_ROOT}"
    fi
  fi
fi
if [ -z "${PDK_ROOT:-}" ]; then
  echo "PDK_ROOT is not set. Please install Sky130 and export PDK_ROOT." >&2
  exit 2
fi
if [ ! -d "${PDK_ROOT}/sky130A" ]; then
  echo "Sky130A not found under PDK_ROOT (${PDK_ROOT})." >&2
  exit 2
fi
echo "PDK OK: ${PDK_ROOT}/sky130A"
