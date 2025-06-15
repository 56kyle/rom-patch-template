#!/usr/bin/env bash
# Verifies output ROM against golden snapshot (if present)

set -euo pipefail
: "${ROM_OUTPUT_PATH?}"

SNAPSHOT_DIR="snapshots"
SNAPSHOT="$SNAPSHOT_DIR/$(basename "$ROM_OUTPUT_PATH")"

if [[ ! -f "$SNAPSHOT" ]]; then
  echo "ℹ️  No snapshot present → skipping comparison."
  exit 0
fi

if cmp -s "$ROM_OUTPUT_PATH" "$SNAPSHOT"; then
  echo "✅ Snapshot match."
else
  echo "❌ Snapshot mismatch!"
  echo "Hint: run 'just check' locally then inspect diff."
  exit 1
fi
