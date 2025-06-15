#!/usr/bin/env bash
# Generates per-patch metadata alongside a .bps file

set -euo pipefail

# Required envs (loaded by Just / .env)
: "${ROM_INPUT_PATH?}"  "${ROM_OUTPUT_PATH?}"  "${PATCH_PATH?}"
: "${PATCH_VERSION:=0.1.0}"  "${PATCH_AUTHOR:=Unknown}"
: "${PATCH_DESCRIPTION:=No description provided.}"  "${TOOLCHAIN:=unspecified}"

[[ -f "$PATCH_PATH"        ]] || { echo "❌ Missing patch: $PATCH_PATH"; exit 1; }
[[ -f "$ROM_INPUT_PATH"    ]] || { echo "❌ Missing input ROM: $ROM_INPUT_PATH"; exit 1; }
[[ -f "$ROM_OUTPUT_PATH"   ]] || { echo "❌ Missing output ROM: $ROM_OUTPUT_PATH"; exit 1; }

# Hashes
PATCH_HASH=$(sha1sum "$PATCH_PATH"      | cut -d' ' -f1)
INPUT_HASH=$(sha1sum "$ROM_INPUT_PATH"  | cut -d' ' -f1)
OUTPUT_HASH=$(sha1sum "$ROM_OUTPUT_PATH"| cut -d' ' -f1)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
PATCH_JSON="${PATCH_PATH}.json"
PATCH_NAME=$(basename "$PATCH_PATH" .bps)

cat > "$PATCH_JSON" <<EOF
{
  "name": "$PATCH_NAME",
  "version": "$PATCH_VERSION",
  "description": "$PATCH_DESCRIPTION",
  "author": "$PATCH_AUTHOR",
  "patch_file": "$PATCH_PATH",
  "patch_format": "bps",
  "input_file": "$ROM_INPUT_PATH",
  "input_sha1": "$INPUT_HASH",
  "output_file": "$ROM_OUTPUT_PATH",
  "output_sha1": "$OUTPUT_HASH",
  "toolchain": "$TOOLCHAIN",
  "created_at": "$TIMESTAMP",
  "patch_sha1": "$PATCH_HASH"
}
EOF

echo "✅ Patch metadata written → $PATCH_JSON"
