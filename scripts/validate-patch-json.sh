#!/usr/bin/env bash
# Confirms patch.json hashes & file paths are correct

set -euo pipefail

PATCH_JSON=${1:-}
[[ -f "$PATCH_JSON" ]] || { echo "❌ patch.json missing: $PATCH_JSON"; exit 1; }

INPUT_FILE=$(jq -r '.input_file'  "$PATCH_JSON")
OUTPUT_FILE=$(jq -r '.output_file' "$PATCH_JSON")
PATCH_FILE=$(jq -r '.patch_file'  "$PATCH_JSON")

INPUT_EXPECT=$(jq -r '.input_sha1'  "$PATCH_JSON")
OUTPUT_EXPECT=$(jq -r '.output_sha1' "$PATCH_JSON")
PATCH_EXPECT=$(jq -r '.patch_sha1'   "$PATCH_JSON")

INPUT_ACT=$(sha1sum "$INPUT_FILE"  | cut -d' ' -f1)
OUTPUT_ACT=$(sha1sum "$OUTPUT_FILE" | cut -d' ' -f1)
PATCH_ACT=$(sha1sum "$PATCH_FILE"  | cut -d' ' -f1)

fail() { echo "❌ $1"; exit 1; }

[[ "$INPUT_ACT"  == "$INPUT_EXPECT"  ]] || fail "input_sha1 mismatch"
[[ "$OUTPUT_ACT" == "$OUTPUT_EXPECT" ]] || fail "output_sha1 mismatch"
[[ "$PATCH_ACT"  == "$PATCH_EXPECT"  ]] || fail "patch_sha1 mismatch"

echo "✅ patch.json hashes validated: $PATCH_JSON"
