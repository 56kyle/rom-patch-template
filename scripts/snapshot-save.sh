#!/usr/bin/env bash
# Saves first golden snapshot when none exists

set -euo pipefail
: "${ROM_OUTPUT_PATH?}"

SNAPSHOT_DIR="snapshots"
mkdir -p "$SNAPSHOT_DIR"
SNAPSHOT="$SNAPSHOT_DIR/$(basename "$ROM_OUTPUT_PATH")"

if [[ -f "$SNAPSHOT" ]]; then
  echo "ℹ️  Snapshot already exists → $SNAPSHOT"
  exit 0
fi

cp "$ROM_OUTPUT_PATH" "$SNAPSHOT"
echo "💾 Snapshot saved → $SNAPSHOT"
