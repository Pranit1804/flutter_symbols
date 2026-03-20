import 'package:flutter/widgets.dart';

/// An [IconData] for SF Symbols icons.
///
/// These icons are licensed by Apple for use on Apple platforms only
/// (iOS, macOS, watchOS, tvOS, visionOS). Do not use on Android, Web, or
/// other non-Apple platforms.
class IconDataSFSymbol extends IconData {
  const IconDataSFSymbol(super.codePoint)
      : super(
          fontFamily: 'SFSymbols',
          fontPackage: 'flutter_cupertino_symbols',
        );
}
