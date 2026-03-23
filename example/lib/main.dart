import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_symbols/flutter_cupertino_symbols.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_symbols',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const IconGalleryPage(),
    );
  }
}

/// A small curated set of symbols to showcase in the example.
/// (After a full pipeline run, you can reference any of the 8000+ symbols.)
const List<(IconData, String)> _showcaseIcons = [
  (SFSymbols.zero_circle, '0.circle'),

  (SFSymbols.line_horizontal_3_decrease, 'line.3.horizontal.decrease'),
  (SFSymbols.zero_square, '0.square'),
  (SFSymbols.zero_square_fill, '0.square.fill'),
  (SFSymbols.zero_zero_circle, '00.circle'),
  (SFSymbols.zero_one_circle, '01.circle'),
  (SFSymbols.zero_two_circle, '02.circle'),
  (SFSymbols.zero_three_circle, '03.circle'),
];

class IconGalleryPage extends StatefulWidget {
  const IconGalleryPage({super.key});

  @override
  State<IconGalleryPage> createState() => _IconGalleryPageState();
}

class _IconGalleryPageState extends State<IconGalleryPage> {
  String _search = '';

  List<(IconData, String)> get _filtered => _search.isEmpty
      ? _showcaseIcons
      : _showcaseIcons
            .where((e) => e.$2.contains(_search.toLowerCase()))
            .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SF Symbols'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: CupertinoSearchTextField(
              onChanged: (v) => setState(() => _search = v),
              placeholder: 'Search symbols…',
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 120,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: _filtered.length,
        itemBuilder: (ctx, i) {
          final (icon, name) = _filtered[i];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(fontSize: 9),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }
}
