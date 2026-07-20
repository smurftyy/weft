import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_launcher/theme/app_config.dart';
import 'package:mobile_launcher/tokens/token_types.dart';
import 'package:mobile_launcher/dev/token_stub_surface.dart';

/// Renders the stub surface across paradigm × profile combinations to golden
/// PNGs — visual proof of "same widget, different tokens" without a device.
/// Regenerate with: flutter test --update-goldens
void main() {
  Widget harness(Paradigm p, Set<Profile> profiles) {
    final controller = AppConfigController(AppConfig(paradigm: p, profiles: profiles));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LauncherTheme(
        controller: controller,
        child: const SizedBox(width: 393, height: 620, child: TokenStubSurface()),
      ),
    );
  }

  final cases = <String, (Paradigm, Set<Profile>)>{
    'skeuo_base': (Paradigm.skeuo, {}),
    'glass_base': (Paradigm.glass, {}),
    'minimal_base': (Paradigm.minimal, {}),
    'skeuo_motor': (Paradigm.skeuo, {Profile.motor}),
    'glass_vision': (Paradigm.glass, {Profile.vision}),
    'skeuo_vision_onehanded': (Paradigm.skeuo, {Profile.vision, Profile.oneHanded}),
  };

  cases.forEach((name, cfg) {
    testWidgets('stub renders: $name', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 620));
      await tester.pumpWidget(harness(cfg.$1, cfg.$2));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(TokenStubSurface),
        matchesGoldenFile('goldens/$name.png'),
      );
    });
  });
}
