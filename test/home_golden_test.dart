import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_launcher/theme/app_config.dart';
import 'package:mobile_launcher/tokens/token_types.dart';
import 'package:mobile_launcher/surfaces/home.dart';

/// Phase-5 checkpoint / §7 acceptance #4: app icons (content) stay identical
/// across paradigm swaps while chrome (wallpaper, widgets, dock, icon radius +
/// shadow) adapts. Regenerate: flutter test --update-goldens
void main() {
  // Freeze the live clock (T8) so goldens are deterministic.
  setUpAll(() => LiveTime.debugFixedNow = DateTime(2026, 7, 21, 9, 41));
  tearDownAll(() => LiveTime.debugFixedNow = null);

  Widget surface(Paradigm p, [Set<Profile> profiles = const {}]) {
    final controller = AppConfigController(AppConfig(paradigm: p, profiles: profiles));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LauncherTheme(
        controller: controller,
        child: const SizedBox(width: 393, height: 852, child: Home()),
      ),
    );
  }

  for (final p in Paradigm.values) {
    testWidgets('home: ${p.name}', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(surface(p));
      await tester.pumpAndSettle();
      await expectLater(find.byType(Home), matchesGoldenFile('goldens/home_${p.name}.png'));
    });
  }

  // T5: Cognitive desaturates Home chrome (icon backings, widget cards,
  // wallpaper) — proven on the surface, not just the preview.
  for (final p in [Paradigm.skeuo, Paradigm.glass]) {
    testWidgets('home: ${p.name} + cognitive', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(surface(p, {Profile.cognitive}));
      await tester.pumpAndSettle();
      await expectLater(
          find.byType(Home), matchesGoldenFile('goldens/home_${p.name}_cognitive.png'));
    });
  }
}
