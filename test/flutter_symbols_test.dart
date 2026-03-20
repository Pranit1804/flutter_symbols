import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_symbols/flutter_cupertino_symbols.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SFSymbols', () {
    test('icons have correct font family', () {
      expect(SFSymbols.zero_circle.fontFamily, 'SFSymbols');
      expect(SFSymbols.zero_circle_fill.fontFamily, 'SFSymbols');
      expect(SFSymbols.zero_square.fontFamily, 'SFSymbols');
    });

    test('icons have correct font package', () {
      expect(SFSymbols.zero_circle.fontPackage, 'flutter_cupertino_symbols');
      expect(SFSymbols.zero_circle_fill.fontPackage, 'flutter_cupertino_symbols');
    });

    test('icons have non-zero codepoints', () {
      expect(SFSymbols.zero_circle.codePoint, isNonZero);
      expect(SFSymbols.zero_circle_fill.codePoint, isNonZero);
      expect(SFSymbols.zero_square.codePoint, isNonZero);
      expect(SFSymbols.zero_square_fill.codePoint, isNonZero);
    });

    test('icons have unique codepoints', () {
      final codepoints = [
        SFSymbols.zero_circle.codePoint,
        SFSymbols.zero_circle_fill.codePoint,
        SFSymbols.zero_square.codePoint,
        SFSymbols.zero_square_fill.codePoint,
        SFSymbols.zero_zero_circle.codePoint,
        SFSymbols.zero_one_circle.codePoint,
      ];
      expect(codepoints.toSet().length, equals(codepoints.length),
          reason: 'All icon codepoints must be unique');
    });

    testWidgets('Icon widget builds without error', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Icon(SFSymbols.zero_circle),
        ),
      );
      expect(find.byType(Icon), findsOneWidget);
    });
  });

  group('IconDataSFSymbol', () {
    test('extends IconData correctly', () {
      const icon = IconDataSFSymbol(0xE001);
      expect(icon.codePoint, 0xE001);
      expect(icon.fontFamily, 'SFSymbols');
      expect(icon.fontPackage, 'flutter_cupertino_symbols');
    });
  });
}
