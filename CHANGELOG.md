## 1.0.2

* Fixed icon centering for all non-square symbols (6,318 landscape and 1,604 portrait glyphs).
* Wide symbols like `minus`, `ellipsis`, `line3HorizontalDecrease` and tall symbols like `poweron`, `exclamationmark`, `chevronCompactLeft` were rendered off-center due to fantasticon normalising non-square SVGs to the font UPM height. Each SVG canvas is now squared with the artwork centred before font generation.

## 1.0.1

* Renamed package to `flutter_cupertino_symbols`.
* Improved README with full usage examples, popular icons reference table, and SEO-friendly documentation.
* Added MIT license.
* Added `.pubignore` to exclude build artifacts from the published package.

## 1.0.0

* Initial release with 6,000+ Apple SF Symbols 6 icons as `IconData` constants.
* Supports all non-locale SF Symbols (locale variants excluded per Apple guidelines).
* Icons rendered via `NSImage(systemSymbolName:)`, traced to vector SVG, and packaged as a TTF font.
* Includes `IconDataSFSymbol` class extending `IconData` with the correct `fontFamily` and `fontPackage`.
