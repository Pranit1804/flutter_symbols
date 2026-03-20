# flutter_symbols

Apple SF Symbols 6 as Flutter `IconData`. 8,000+ icons, ready to drop in anywhere you use Flutter's `Icon` widget.

> **License notice**: SF Symbols are licensed by Apple for use **on Apple platforms only** (iOS, macOS, watchOS, tvOS, visionOS). Do not use these icons in apps distributed for Android, Web, Linux, or Windows.

## Features

- 8,000+ SF Symbols 6 icons as static `IconData` constants
- Works with Flutter's standard `Icon` widget — no custom widgets required
- Zero runtime dependencies beyond Flutter itself
- Tree-shakable: only the icons you reference are included in your app bundle
- Regeneratable pipeline: update to SF Symbols 7 with a single `make` command

## Installation

```yaml
dependencies:
  flutter_symbols: ^1.0.0
```

## Usage

```dart
import 'package:flutter_symbols/flutter_symbols.dart';

// Use like any Flutter icon
Icon(SFSymbols.heart_fill)
Icon(SFSymbols.star_fill, size: 32, color: Colors.blue)
Icon(SFSymbols.checkmark_circle, size: 24)

// Works in buttons, list tiles, etc.
IconButton(
  icon: const Icon(SFSymbols.arrow_right_circle_fill),
  onPressed: () {},
)

ListTile(
  leading: const Icon(SFSymbols.person_fill),
  title: const Text('Profile'),
)
```

## Icon naming convention

SF Symbol names use dots (e.g. `heart.fill`) — Dart identifiers use underscores:

| SF Symbol name        | Dart identifier         |
|-----------------------|-------------------------|
| `heart`               | `SFSymbols.heart`       |
| `heart.fill`          | `SFSymbols.heart_fill`  |
| `arrow.up.circle`     | `SFSymbols.arrow_up_circle` |
| `0.circle`            | `SFSymbols.zero_circle` |
| `00.circle.fill`      | `SFSymbols.zero_zero_circle_fill` |

## Finding icons

Browse SF Symbols at [developer.apple.com/sf-symbols](https://developer.apple.com/sf-symbols/) or download the free **SF Symbols** app from Apple. Then convert the dotted name to a Dart identifier using the table above.

## Regenerating (for contributors)

The icons are generated from the SF Symbols app on macOS:

```bash
# Prerequisites: macOS with SF Symbols app, Node.js, Python 3
pip3 install vtracer

# Full regeneration (~15 minutes)
make -C tool all

# Quick test with 20 symbols
make -C tool test
```

Pipeline steps:
1. `export` — Swift renders each symbol to a high-res PNG
2. `trace`  — Python/vtracer converts PNGs to SVGs
3. `font`   — fantasticon packages SVGs into `SFSymbols.ttf`
4. `dart`   — Dart generates `lib/flutter_symbols.dart`

## License

Package code: MIT

**SF Symbols**: All SF Symbols are considered system-provided images and are subject to the terms and conditions set forth in the [Xcode and Apple SDKs License Agreement](https://developer.apple.com/terms/). You may use SF Symbols to create content for your apps only on Apple platforms. SF Symbols shall not be used in logos, marketing materials, or used to represent app functionality in app icons.
