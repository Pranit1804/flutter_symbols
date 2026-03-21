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
