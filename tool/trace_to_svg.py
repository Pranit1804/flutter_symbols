#!/usr/bin/env python3
"""
Converts exported SF Symbol PNGs to SVGs using vtracer.
Input:  tool/pngs/        (PNG files from export_symbols.swift)
Output: tool/svgs/        (SVG files ready for fantasticon)

Install dependency: pip3 install vtracer
"""

import os
import sys
import json
import argparse
from pathlib import Path

try:
    import vtracer
except ImportError:
    print("Error: vtracer not installed. Run: pip3 install vtracer", file=sys.stderr)
    sys.exit(1)

# Directory layout (relative to this script)
script_dir = Path(__file__).parent
png_dir    = script_dir / "pngs"
svg_dir    = script_dir / "svgs"
manifest_path = script_dir / "symbol_manifest.json"

def trace_png_to_svg(png_path: Path, svg_path: Path) -> bool:
    try:
        vtracer.convert_image_to_svg_py(
            str(png_path),
            str(svg_path),
            colormode="binary",       # Black = foreground (the symbol)
            mode="spline",            # Smooth spline curves
            filter_speckle=4,         # Remove noise smaller than 4px
            corner_threshold=60,      # Angle threshold for corners
            length_threshold=4.0,     # Minimum segment length
            splice_threshold=45,      # Path splice threshold
            path_precision=3,         # Decimal places (3 = good balance)
        )
        return svg_path.exists() and svg_path.stat().st_size > 0
    except Exception as e:
        print(f"  Error tracing {png_path.name}: {e}", file=sys.stderr)
        return False

def main():
    parser = argparse.ArgumentParser(description="Trace SF Symbol PNGs to SVGs")
    parser.add_argument("--test", action="store_true", help="Process only first 20 PNGs")
    parser.add_argument("--workers", type=int, default=8, help="Parallel workers (default: 8)")
    args = parser.parse_args()

    if not png_dir.exists():
        print(f"Error: PNG directory not found at {png_dir}", file=sys.stderr)
        print("Run: swift tool/export_symbols.swift", file=sys.stderr)
        sys.exit(1)

    svg_dir.mkdir(exist_ok=True)

    png_files = sorted(png_dir.glob("*.png"))
    if args.test:
        png_files = png_files[:20]

    print(f"Tracing {len(png_files)} PNGs to SVGs...")

    success = 0
    failed  = 0

    for i, png_path in enumerate(png_files):
        if i > 0 and i % 500 == 0:
            print(f"Progress: {i}/{len(png_files)} ({success} ok, {failed} failed)")

        svg_path = svg_dir / (png_path.stem + ".svg")
        if trace_png_to_svg(png_path, svg_path):
            success += 1
        else:
            failed += 1

    print(f"\nTrace complete: {success} succeeded, {failed} failed")
    print(f"SVGs → {svg_dir}")

if __name__ == "__main__":
    main()
