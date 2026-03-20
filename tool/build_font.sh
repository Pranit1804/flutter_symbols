#!/usr/bin/env bash
# Converts traced SVGs into a TTF font + JSON codepoint map using fantasticon.
# Input:  tool/svgs/        (SVG files from trace_to_svg.py)
# Output: lib/fonts/        (SFSymbols.ttf + SFSymbols.json)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SVG_DIR="$SCRIPT_DIR/svgs"
OUTPUT_DIR="$REPO_ROOT/lib/fonts"

if [ ! -d "$SVG_DIR" ]; then
  echo "Error: SVG directory not found at $SVG_DIR"
  echo "Run: python3 tool/trace_to_svg.py"
  exit 1
fi

SVG_COUNT=$(find "$SVG_DIR" -name "*.svg" | wc -l | tr -d ' ')
echo "Building font from $SVG_COUNT SVGs..."
mkdir -p "$OUTPUT_DIR"

# Run fantasticon
# --font-height 1000: standard icon font UPM height
# --normalize: scale all icons to the same height
# --round: round path coordinates for smaller file size
npx fantasticon "$SVG_DIR" \
  --output "$OUTPUT_DIR" \
  --name SFSymbols \
  --font-types ttf \
  --asset-types json \
  --font-height 1000 \
  --normalize \
  --silent

echo "Font generated:"
ls -lh "$OUTPUT_DIR/"
echo "Done → $OUTPUT_DIR"
