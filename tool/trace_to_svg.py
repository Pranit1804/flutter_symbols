#!/usr/bin/env python3
"""
Converts exported SF Symbol PNGs to SVGs using vtracer.
Input:  tool/pngs/        (PNG files from export_symbols.swift)
Output: tool/svgs/        (SVG files ready for fantasticon)

Install dependency: pip3 install vtracer
"""

import re
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

def square_svg(svg_path: Path) -> None:
    """
    Rewrite the SVG so its canvas is square (max(width, height) × max(width, height))
    with the artwork centred inside it.  This prevents non-square glyphs (e.g. wide
    landscape symbols like line.3.horizontal.decrease) from appearing off-centre when
    fantasticon normalises all icons to the same UPM height.
    """
    text = svg_path.read_text(encoding="utf-8")

    # Extract width / height from the <svg …> opening tag
    w_match = re.search(r'<svg[^>]+\bwidth="([0-9.]+)"', text)
    h_match = re.search(r'<svg[^>]+\bheight="([0-9.]+)"', text)
    if not w_match or not h_match:
        return  # can't parse — leave as-is

    w = float(w_match.group(1))
    h = float(h_match.group(1))
    if abs(w - h) < 1:
        return  # already square — nothing to do

    side = max(w, h)
    dx   = (side - w) / 2
    dy   = (side - h) / 2

    # Replace width/height attributes with the square size
    text = re.sub(r'(<svg[^>]+\bwidth=")[0-9.]+(")', rf'\g<1>{side}\2', text)
    text = re.sub(r'(<svg[^>]+\bheight=")[0-9.]+(")', rf'\g<1>{side}\2', text)

    # Wrap all existing content in a <g translate(dx, dy)> so it stays centred
    text = text.replace(
        "</svg>",
        f'</g>\n</svg>',
        1,
    )
    # Insert the opening <g> right after the <svg …> tag closes
    text = re.sub(
        r'(<svg[^>]*>)',
        rf'\1\n<g transform="translate({dx:.3f},{dy:.3f})">',
        text,
        count=1,
    )

    svg_path.write_text(text, encoding="utf-8")


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
        if not (svg_path.exists() and svg_path.stat().st_size > 0):
            return False
        square_svg(svg_path)
        return True
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
