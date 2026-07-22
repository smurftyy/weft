import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_launcher/theme/app_config.dart';
import 'package:mobile_launcher/tokens/token_types.dart';
import 'package:mobile_launcher/surfaces/customization.dart';

/// Phase-4 checkpoint: the Customization surface across paradigms, plus 3-axis
/// composition in the live preview. Regenerate: flutter test --update-goldens
void main() {
  Widget surface(Paradigm p, Set<Profile> profiles) {
    final controller = AppConfigController(AppConfig(paradigm: p, profiles: profiles));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LauncherTheme(
        controller: controller,
        child: SizedBox(
          width: 393,
          height: 852,
          child: Customization(
            initialConfig: AppConfig(paradigm: p, profiles: profiles),
            onApply: (_) {},
          ),
        ),
      ),
    );
  }

  final cases = <String, (Paradigm, Set<Profile>)>{
    'skeuo': (Paradigm.skeuo, {}),
    'glass': (Paradigm.glass, {}),
    'minimal': (Paradigm.minimal, {}),
    // The marquee three-axis moment (§7 acceptance #3):
    'skeuo_vision_onehanded': (Paradigm.skeuo, {Profile.vision, Profile.oneHanded}),
    'glass_vision': (Paradigm.glass, {Profile.vision}),
    'skeuo_all4': (Paradigm.skeuo, {Profile.motor, Profile.vision, Profile.cognitive, Profile.oneHanded}),
  };

  cases.forEach((name, cfg) {
    testWidgets('customization: $name', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(surface(cfg.$1, cfg.$2));
      await tester.pumpAndSettle();
      await expectLater(find.byType(Customization), matchesGoldenFile('goldens/cz_$name.png'));
    });
  });
}
