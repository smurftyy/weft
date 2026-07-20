import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_launcher/theme/app_config.dart';
import 'package:mobile_launcher/tokens/token_types.dart';
import 'package:mobile_launcher/dev/atom_gallery.dart';

/// Phase-2 checkpoint: every atom rendered across 3 paradigms × {none, Motor,
/// Vision}. Same widget code — the goldens prove the atoms adapt purely through
/// the semantic tier. Regenerate: flutter test --update-goldens
void main() {
  Widget harness(Paradigm p, Set<Profile> profiles) {
    final controller = AppConfigController(AppConfig(paradigm: p, profiles: profiles));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LauncherTheme(
        controller: controller,
        child: const SizedBox(width: 393, height: 1180, child: AtomGallery()),
      ),
    );
  }

  final matrix = <String, (Paradigm, Set<Profile>)>{
    for (final p in Paradigm.values) ...{
      '${p.name}_base': (p, <Profile>{}),
      '${p.name}_motor': (p, {Profile.motor}),
      '${p.name}_vision': (p, {Profile.vision}),
    },
  };

  matrix.forEach((name, cfg) {
    testWidgets('atoms: $name', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 1180));
      await tester.pumpWidget(harness(cfg.$1, cfg.$2));
      await tester.pumpAndSettle();
      await expectLater(find.byType(AtomGallery), matchesGoldenFile('goldens/atoms_$name.png'));
    });
  });
}
