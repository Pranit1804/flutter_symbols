# SF Symbols Flutter Package — Build Pipeline
# Run `make` from the repo root or `make -C tool` from anywhere.
#
# Steps:
#   1. export  — render all SF Symbols to PNG via Swift
#   2. trace   — trace PNGs to SVG via vtracer (Python)
#   3. font    — convert SVGs to TTF + JSON via fantasticon
#   4. dart    — generate lib/flutter_symbols.dart

SCRIPT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: all export trace font dart clean test

all: export trace font dart

## Run all steps with only 20 symbols (fast sanity check)
test:
	swift $(SCRIPT_DIR)export_symbols.swift --test
	python3 $(SCRIPT_DIR)trace_to_svg.py --test
	bash $(SCRIPT_DIR)build_font.sh
	dart run $(SCRIPT_DIR)generate_dart.dart

export:
	swift $(SCRIPT_DIR)export_symbols.swift

trace:
	pip3 install -q vtracer
	python3 $(SCRIPT_DIR)trace_to_svg.py

font:
	bash $(SCRIPT_DIR)build_font.sh

dart:
	dart run $(SCRIPT_DIR)generate_dart.dart

clean:
	rm -rf $(SCRIPT_DIR)pngs $(SCRIPT_DIR)svgs $(SCRIPT_DIR)symbol_manifest.json
