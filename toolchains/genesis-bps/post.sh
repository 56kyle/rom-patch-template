#!/usr/bin/env bash
set -euo pipefail
[ -f "$ROM_OUTPUT_PATH" ] || { echo 'missing output'; exit 1; }
