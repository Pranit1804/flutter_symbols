## 1.0.0

* Initial release with ~8,000 Apple SF Symbols 6 icons as `IconData` constants.
* Supports all non-locale SF Symbols (locale variants excluded per Apple guidelines).
* Icons rendered via `NSImage(systemSymbolName:)`, traced to vector SVG, and packaged as a TTF font.
* Includes `IconDataSFSymbol` class extending `IconData` with the correct `fontFamily` and `fontPackage`.
