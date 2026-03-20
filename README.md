# flutter_sf_symbols

**Apple SF Symbols for Flutter** — 6000+ iOS & macOS icons as native `IconData` constants. Drop SF Symbols directly into any Flutter `Icon` widget with zero custom widgets and zero runtime overhead.

[![pub version](https://img.shields.io/pub/v/flutter_sf_symbols.svg)](https://pub.dev/packages/flutter_sf_symbols)
[![pub points](https://img.shields.io/pub/points/flutter_sf_symbols)](https://pub.dev/packages/flutter_sf_symbols/score)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> **Platform notice**: SF Symbols are licensed by Apple for use **on Apple platforms only** (iOS, macOS, watchOS, tvOS, visionOS). Do not distribute apps using these icons on Android, Web, Linux, or Windows.

---

## Why flutter_sf_symbols?

Building a Flutter app for iOS or macOS? SF Symbols are the **native icon system used across all Apple platforms** — the same icons found in Settings, Safari, Maps, and every first-party Apple app. Using them makes your Flutter app feel truly native on iOS and macOS.

- **6,843 SF Symbols 6 icons** — the full set, including transport, health, finance, accessibility, multicolor, and more
- **No custom widget needed** — works with Flutter's built-in `Icon`, `IconButton`, `ListTile`, anywhere that accepts `IconData`
- **Tree-shakable** — only icons you reference are included in the app bundle
- **Type-safe** — every icon is a named `static const IconData` with IDE autocomplete
- **Zero dependencies** — only depends on Flutter itself

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_sf_symbols: ^1.0.0
```

Then run:

```sh
flutter pub get
```

---

## Usage

```dart
import 'package:flutter_sf_symbols/flutter_sf_symbols.dart';

// Basic usage — identical to Flutter's built-in Icons
Icon(SFSymbols.heart_fill)
Icon(SFSymbols.star_fill, size: 32, color: Colors.pink)
Icon(SFSymbols.checkmark_circle, size: 24, color: Colors.green)

// In buttons
IconButton(
  icon: const Icon(SFSymbols.arrow_right_circle_fill),
  onPressed: () {},
)

// In list tiles — perfect for iOS-style settings screens
ListTile(
  leading: const Icon(SFSymbols.person_fill),
  title: const Text('Profile'),
)

ListTile(
  leading: const Icon(SFSymbols.bell_badge_fill),
  title: const Text('Notifications'),
)

// Navigation bar icons
NavigationBar(
  destinations: const [
    NavigationDestination(
      icon: Icon(SFSymbols.house),
      selectedIcon: Icon(SFSymbols.house_fill),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(SFSymbols.magnifyingglass),
      label: 'Search',
    ),
    NavigationDestination(
      icon: Icon(SFSymbols.person_circle),
      selectedIcon: Icon(SFSymbols.person_circle_fill),
      label: 'Profile',
    ),
  ],
)
```

---

## Icon naming convention

SF Symbol names use dots (e.g. `heart.fill`) — Dart identifiers use underscores. Numbers at the start of a name are written out as words:

| SF Symbol name            | Dart identifier                    |
|---------------------------|------------------------------------|
| `heart`                   | `SFSymbols.heart`                  |
| `heart.fill`              | `SFSymbols.heart_fill`             |
| `arrow.up.circle`         | `SFSymbols.arrow_up_circle`        |
| `arrow.up.circle.fill`    | `SFSymbols.arrow_up_circle_fill`   |
| `0.circle`                | `SFSymbols.zero_circle`            |
| `00.circle.fill`          | `SFSymbols.zero_zero_circle_fill`  |
| `person.2.fill`           | `SFSymbols.person_2_fill`          |

---

## Finding icons

1. Browse the full catalog at [developer.apple.com/sf-symbols](https://developer.apple.com/sf-symbols/)
2. Download the free **SF Symbols** app from Apple (macOS only) to search, filter, and preview every symbol
3. Convert the dotted name to a Dart identifier using the table above
4. Use IDE autocomplete — type `SFSymbols.` and browse

---

## Popular icons

A quick reference for commonly used symbols:

| Category        | Dart identifier                   | SF Symbol name              |
|-----------------|-----------------------------------|-----------------------------|
| UI / Navigation | `SFSymbols.chevron_right`         | `chevron.right`             |
|                 | `SFSymbols.chevron_left`          | `chevron.left`              |
|                 | `SFSymbols.xmark`                 | `xmark`                     |
|                 | `SFSymbols.magnifyingglass`       | `magnifyingglass`           |
|                 | `SFSymbols.ellipsis`              | `ellipsis`                  |
| People          | `SFSymbols.person_fill`           | `person.fill`               |
|                 | `SFSymbols.person_circle_fill`    | `person.circle.fill`        |
|                 | `SFSymbols.person_2_fill`         | `person.2.fill`             |
| Interaction     | `SFSymbols.heart_fill`            | `heart.fill`                |
|                 | `SFSymbols.star_fill`             | `star.fill`                 |
|                 | `SFSymbols.bookmark_fill`         | `bookmark.fill`             |
|                 | `SFSymbols.share`                 | `square.and.arrow.up`       |
| Communication   | `SFSymbols.bell_fill`             | `bell.fill`                 |
|                 | `SFSymbols.message_fill`          | `message.fill`              |
|                 | `SFSymbols.envelope_fill`         | `envelope.fill`             |
| System          | `SFSymbols.gear`                  | `gear`                      |
|                 | `SFSymbols.house_fill`            | `house.fill`                |
|                 | `SFSymbols.lock_fill`             | `lock.fill`                 |
|                 | `SFSymbols.checkmark_circle_fill` | `checkmark.circle.fill`     |

---

## Regenerating (for contributors)

The icon font and Dart file are generated from the SF Symbols app on macOS:

```bash
# Prerequisites: macOS with SF Symbols app installed, Node.js, Python 3
pip3 install vtracer

# Full regeneration (~15 minutes, produces all 6843+ symbols)
make -C tool all

# Quick test with 20 symbols
make -C tool test
```

Pipeline steps:
1. **export** — Swift renders each symbol to a high-res PNG via the SF Symbols app
2. **trace** — Python/vtracer converts PNGs to SVGs
3. **font** — fantasticon packages SVGs into `SFSymbols.ttf`
4. **dart** — Dart script generates `lib/flutter_sf_symbols.dart` with all constants

---

## License

**Package code**: MIT — see [LICENSE](LICENSE)

**SF Symbols**: All SF Symbols are considered system-provided images and are subject to the [Xcode and Apple SDKs License Agreement](https://developer.apple.com/terms/). You may use SF Symbols only in apps distributed on Apple platforms (iOS, macOS, watchOS, tvOS, visionOS). SF Symbols must not be used in logos, marketing materials, or to represent app functionality in app icons.
