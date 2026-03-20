// ignore_for_file: avoid_print

// Dart code generator for flutter_symbols.
//
// Reads:
//   - lib/fonts/SFSymbols.json  (fantasticon codepoint map)
//   - tool/symbol_manifest.json (original_name → safe_filename mapping)
//
// Writes:
//   - lib/flutter_symbols.dart  (the SFSymbols class with ~8,000 IconData constants)

import 'dart:convert';
import 'dart:io';

// Dart reserved words that cannot be used as identifiers.
const _dartReserved = {
  'abstract', 'as', 'assert', 'async', 'await', 'base', 'break', 'case',
  'catch', 'class', 'const', 'continue', 'covariant', 'default', 'deferred',
  'do', 'dynamic', 'else', 'enum', 'export', 'extends', 'extension', 'external',
  'factory', 'false', 'final', 'finally', 'for', 'function', 'get', 'hide',
  'if', 'implements', 'import', 'in', 'interface', 'is', 'late', 'library',
  'mixin', 'new', 'null', 'of', 'on', 'operator', 'part', 'required', 'return',
  'sealed', 'set', 'show', 'static', 'super', 'switch', 'sync', 'this', 'throw',
  'true', 'try', 'typedef', 'type', 'var', 'void', 'when', 'while', 'with',
  'yield',
};

// Maps leading digit characters to their English word equivalents.
const _digitWords = {
  '0': 'zero', '1': 'one', '2': 'two', '3': 'three', '4': 'four',
  '5': 'five', '6': 'six', '7': 'seven', '8': 'eight', '9': 'nine',
};

/// Converts an SF Symbol name (e.g. "heart.fill", "0.circle") to a
/// valid Dart identifier (e.g. "heart_fill", "zero_circle").
String toDartIdentifier(String sfName) {
  // Replace dots with underscores.
  var id = sfName.replaceAll('.', '_');

  // If the identifier starts with a digit, prefix with the word equivalent.
  // Handle multi-digit prefixes like "00", "01", etc.
  final leadingDigits = RegExp(r'^(\d+)_?').firstMatch(id);
  if (leadingDigits != null) {
    final digits = leadingDigits.group(1)!;
    final words = digits.split('').map((d) => _digitWords[d]!).join('_');
    id = id.replaceFirst(digits, words);
  }

  // If the result is a Dart reserved word, prefix with 'sf_'.
  if (_dartReserved.contains(id)) {
    id = 'sf_$id';
  }

  return id;
}

void main() {
  final scriptDir  = File(Platform.script.toFilePath()).parent;
  final repoRoot   = scriptDir.parent;

  final codepointFile = File('${repoRoot.path}/lib/fonts/SFSymbols.json');
  final manifestFile  = File('${scriptDir.path}/symbol_manifest.json');
  final outputFile    = File('${repoRoot.path}/lib/flutter_symbols.dart');

  if (!codepointFile.existsSync()) {
    stderr.writeln('Error: ${codepointFile.path} not found.');
    stderr.writeln('Run: bash tool/build_font.sh');
    exit(1);
  }
  if (!manifestFile.existsSync()) {
    stderr.writeln('Error: ${manifestFile.path} not found.');
    stderr.writeln('Run: swift tool/export_symbols.swift');
    exit(1);
  }

  // Load codepoint map: { "safe_name": codepoint_int }
  final codepointMap = (jsonDecode(codepointFile.readAsStringSync()) as Map<String, dynamic>)
      .map((k, v) => MapEntry(k, v as int));

  // Load manifest: { "original_sf_name": "safe_filename" }
  final manifestMap = (jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>)
      .map((k, v) => MapEntry(k, v as String));

  // Build a reverse map: safe_filename → original_sf_name
  final reverseManifest = <String, String>{};
  for (final entry in manifestMap.entries) {
    reverseManifest[entry.value] = entry.key;
  }

  // Build entries: Dart identifier → (codepoint, original SF name)
  final entries = <String, (int, String)>{};
  final collisions = <String>[];

  for (final entry in codepointMap.entries) {
    final safeName  = entry.key;
    final codepoint = entry.value;
    final sfName    = reverseManifest[safeName] ?? safeName.replaceAll('_', '.');
    var dartId      = toDartIdentifier(sfName);

    // Resolve collisions by appending a counter.
    if (entries.containsKey(dartId)) {
      collisions.add(dartId);
      var i = 2;
      while (entries.containsKey('${dartId}_$i')) { i++; }
      dartId = '${dartId}_$i';
    }

    entries[dartId] = (codepoint, sfName);
  }

  if (collisions.isNotEmpty) {
    print('Resolved ${collisions.length} identifier collisions: $collisions');
  }

  // Sort entries alphabetically for stable output.
  final sortedEntries = entries.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));

  // Generate the Dart file.
  final buf = StringBuffer();
  buf.writeln('// THIS FILE IS AUTO-GENERATED. DO NOT EDIT.');
  buf.writeln('// Run: make -C tool regenerate');
  buf.writeln('// Generated: ${DateTime.now().toIso8601String().split('T').first}');
  buf.writeln('// SF Symbols count: ${sortedEntries.length}');
  buf.writeln('//');
  buf.writeln('// IMPORTANT: SF Symbols are licensed by Apple for use on Apple platforms');
  buf.writeln('// (iOS, macOS, watchOS, tvOS, visionOS) only. Do not use on Android,');
  buf.writeln('// Web, or other non-Apple platforms.');
  buf.writeln();
  buf.writeln('library;');
  buf.writeln();
  buf.writeln("import 'package:flutter/widgets.dart';");
  buf.writeln("import 'package:flutter_symbols/src/icon_data.dart';");
  buf.writeln("export 'package:flutter_symbols/src/icon_data.dart';");
  buf.writeln();
  buf.writeln('/// Apple SF Symbols 6 as Flutter [IconData].');
  buf.writeln('///');
  buf.writeln('/// Usage:');
  buf.writeln('/// ```dart');
  buf.writeln('/// Icon(SFSymbols.heart_fill)');
  buf.writeln('/// ```');
  buf.writeln('///');
  buf.writeln('/// **License notice**: These icons are licensed by Apple for use on');
  buf.writeln('/// Apple platforms (iOS, macOS, watchOS, tvOS, visionOS) only.');
  buf.writeln('@staticIconProvider');
  buf.writeln('class SFSymbols {');
  buf.writeln('  SFSymbols._();');
  buf.writeln();

  for (final e in sortedEntries) {
    final dartId    = e.key;
    final codepoint = e.value.$1;
    final sfName    = e.value.$2;
    buf.writeln('  /// SF Symbol: `$sfName`');
  buf.writeln('  // ignore: constant_identifier_names');
    buf.writeln('  static const IconData $dartId = IconDataSFSymbol($codepoint);');
  }

  buf.writeln('}');

  outputFile.writeAsStringSync(buf.toString());
  print('Generated ${sortedEntries.length} icons → ${outputFile.path}');
}
