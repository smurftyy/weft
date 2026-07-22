import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_launcher/theme/app_config.dart';
import 'package:mobile_launcher/tokens/token_types.dart';
import 'package:mobile_launcher/surfaces/launcher_shell.dart';
import 'package:mobile_launcher/surfaces/home.dart';

/// Phase-6 checkpoint: the full navigation loop is demoable AND paradigm/profile
/// + toggle state persists across every hop (shared AppConfigController).
void main() {
  // Freeze the live clock (T8) so the 1s Stream.periodic doesn't spin
  // pumpAndSettle.
  setUpAll(() => LiveTime.debugFixedNow = DateTime(2026, 7, 21, 9, 41));
  tearDownAll(() => LiveTime.debugFixedNow = null);

  testWidgets('nav loop + state persistence', (tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    final controller = AppConfigController();
    await tester.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LauncherTheme(controller: controller, child: const LauncherShell()),
    ));
    await tester.pumpAndSettle();

    // Home is the base surface (Settings icon present).
    expect(find.byKey(const ValueKey('home-settings')), findsOneWidget);

    // Swipe-down safety-net handle → Control Center.
    await tester.tap(find.byKey(const ValueKey('cc-open-handle')));
    await tester.pumpAndSettle();

    // Toggle Wi-Fi (default on → off) inside Control Center.
    expect(controller.value.toggles['wifi'] ?? true, isTrue);
    await tester.tap(find.byKey(const ValueKey('cc-tile-wifi')));
    await tester.pumpAndSettle();
    expect(controller.value.toggles['wifi'], isFalse);

    // Dismiss Control Center back to Home.
    await tester.tap(find.byKey(const ValueKey('cc-close-handle')));
    await tester.pumpAndSettle();

    // Settings icon → Customization; change paradigm to Glass in the DRAFT.
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Glass'));
    await tester.pumpAndSettle();
    // Staging (T6): the draft changed, but the committed config has NOT — Home
    // behind is still Skeuo until Apply.
    expect(controller.value.paradigm, Paradigm.skeuo);

    // Apply commits the draft and returns to Home (scroll it into view first —
    // the Customization surface scrolls).
    await tester.ensureVisible(find.text('Apply'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    // State persisted across the whole loop: paradigm swap AND the Wi-Fi toggle.
    expect(controller.value.paradigm, Paradigm.glass);
    expect(controller.value.toggles['wifi'], isFalse);

    // Re-open Control Center — still reflects the persisted state.
    await tester.tap(find.byKey(const ValueKey('cc-open-handle')));
    await tester.pumpAndSettle();
    expect(controller.value.paradigm, Paradigm.glass);

    controller.dispose();
  });
}
