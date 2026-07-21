import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_launcher/theme/app_config.dart';
import 'package:mobile_launcher/tokens/token_types.dart';
import 'package:mobile_launcher/surfaces/control_center.dart';

/// Phase-3 checkpoint: the assembled Control Center across all three paradigms
/// (swap-only, zero widget changes) + Motor/Vision overlays on Skeuo and Glass.
/// Regenerate: flutter test --update-goldens
void main() {
  Widget surface(Paradigm p, Set<Profile> profiles) {
    final controller = AppConfigController(AppConfig(paradigm: p, profiles: profiles));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LauncherTheme(
        controller: controller,
        child: const SizedBox(width: 393, height: 852, child: ControlCenter()),
      ),
    );
  }

  final cases = <String, (Paradigm, Set<Profile>)>{
    'skeuo': (Paradigm.skeuo, {}),
    'glass': (Paradigm.glass, {}),
    'minimal': (Paradigm.minimal, {}),
    'skeuo_motor': (Paradigm.skeuo, {Profile.motor}),
    'skeuo_vision': (Paradigm.skeuo, {Profile.vision}),
    'glass_motor': (Paradigm.glass, {Profile.motor}),
    'glass_vision': (Paradigm.glass, {Profile.vision}),
  };

  cases.forEach((name, cfg) {
    testWidgets('control center: $name', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      await tester.pumpWidget(surface(cfg.$1, cfg.$2));
      await tester.pumpAndSettle();
      await expectLater(find.byType(ControlCenter), matchesGoldenFile('goldens/cc_$name.png'));
    });
  });
}
