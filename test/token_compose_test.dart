import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_launcher/tokens/semantic.dart';

/// Proves the thesis at the token layer: same resolver calls, different
/// composed values across paradigm × profile. No widgets — pure token math.
void main() {
  AppSemantics sem(Paradigm p, [Set<Profile> profiles = const {}]) =>
      AppSemantics(paradigm: p, profiles: profiles);

  group('paradigm swap changes tokens (same call site)', () {
    test('tile radius differs per paradigm', () {
      expect(sem(Paradigm.skeuo).tile.radius, 20);
      expect(sem(Paradigm.glass).tile.radius, 22); // finding #3: 16→22 glass
      expect(sem(Paradigm.minimal).tile.radius, 8);
    });

    test('app-icon radius differs per paradigm (content: only radius+shadow)', () {
      expect(sem(Paradigm.skeuo).system.appIconRadius, 22);
      expect(sem(Paradigm.glass).system.appIconRadius, 24);
      expect(sem(Paradigm.minimal).system.appIconRadius, 16);
    });

    test('enabled tile ground is visually distinct across paradigms', () {
      final skeuo = sem(Paradigm.skeuo).tile.ground(WState.enabled);
      final glass = sem(Paradigm.glass).tile.ground(WState.enabled);
      final minimal = sem(Paradigm.minimal).tile.ground(WState.enabled);
      expect(skeuo.gradient, isNotNull); // skeuo dimensional gradient
      expect(glass.blurSigma, greaterThan(0)); // glass blurs
      expect(minimal.blurSigma, 0); // minimal is flat
      expect(minimal.color, isNotNull);
    });
  });

  group('profiles compose over any paradigm', () {
    test('Motor grows tile height on every paradigm', () {
      for (final p in Paradigm.values) {
        expect(sem(p).tile.height, 116);
        expect(sem(p, {Profile.motor}).tile.height, 140);
      }
    });

    test('Vision scales type ×1.35 on every paradigm', () {
      for (final p in Paradigm.values) {
        final base = sem(p).text.titleSize;
        final vision = sem(p, {Profile.vision}).text.titleSize;
        expect(vision, closeTo(base * 1.35, 0.001));
      }
    });

    test('focus ring widens under Motor OR Vision', () {
      expect(sem(Paradigm.skeuo).state.focusRingWidth, 2.5);
      expect(sem(Paradigm.skeuo, {Profile.motor}).state.focusRingWidth, 4);
      expect(sem(Paradigm.glass, {Profile.vision}).state.focusRingWidth, 4);
    });
  });

  group('generalized Glass×Vision cascade (finding #4 — one rule)', () {
    test('section-header plate present on Glass base, dropped under Vision', () {
      expect(sem(Paradigm.glass).sectionHeader.plate.isEmpty, isFalse);
      expect(sem(Paradigm.glass, {Profile.vision}).sectionHeader.plate.isEmpty, isTrue);
    });

    test('tile label chip present on Glass base, dropped under Vision', () {
      expect(sem(Paradigm.glass).tile.labelChip(WState.enabled), isNotNull);
      expect(sem(Paradigm.glass, {Profile.vision}).tile.labelChip(WState.enabled), isNull);
    });

    test('container tint deepens .60 → .92 under Vision (Glass only)', () {
      final base = sem(Paradigm.glass).container.style.color!;
      final vision = sem(Paradigm.glass, {Profile.vision}).container.style.color!;
      expect(vision.a, greaterThan(base.a));
      expect(vision.a, closeTo(0.92, 0.01));
    });

    test('cascade does NOT fire outside the Glass×Vision intersection', () {
      // Skeuo×Vision keeps its (null) chip semantics unchanged; no glass rebind.
      expect(sem(Paradigm.skeuo, {Profile.vision}).tile.ground(WState.enabled).gradient, isNotNull);
      // Glass WITHOUT vision keeps translucent ground + chip.
      expect(sem(Paradigm.glass).tile.labelChip(WState.enabled), isNotNull);
    });
  });

  group('Glass×Vision reduces transparency on small controls (F2)', () {
    test('slider/toggle/chip grounds go near-opaque, blur off', () {
      final s = sem(Paradigm.glass, {Profile.vision});
      expect(s.slider.track(WState.enabled).blurSigma, 0);
      expect(s.slider.track(WState.enabled).color!.a, greaterThanOrEqualTo(0.92));
      expect(s.toggle.track(true).color!.a, greaterThanOrEqualTo(0.92));
      expect(s.chip.ground(WState.selected).color!.a, greaterThanOrEqualTo(0.92));
    });

    test('does not fire on Glass without Vision (stays translucent)', () {
      final s = sem(Paradigm.glass);
      expect(s.toggle.track(true).color!.a, lessThan(0.92));
      expect(s.slider.track(WState.enabled).blurSigma, greaterThan(0));
    });
  });

  group('three-axis composition (Skeuo × Vision × One-Handed)', () {
    test('composes without error; Vision scalar applies, One-Handed is surface no-op', () {
      final s = sem(Paradigm.skeuo, {Profile.vision, Profile.oneHanded});
      expect(s.text.scale, closeTo(1.35, 0.001)); // Vision applies
      // One-Handed adds no surface delta (Q3): tile geometry matches Skeuo×Vision.
      expect(s.tile.radius, sem(Paradigm.skeuo, {Profile.vision}).tile.radius);
    });
  });
}
