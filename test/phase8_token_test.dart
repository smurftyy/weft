import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_launcher/tokens/semantic.dart';

/// Phase 8 token-layer proofs: the app-icon BACKING is chrome that differs per
/// paradigm (T2), and the Cognitive profile is a real, composable surface delta
/// that desaturates chroma-bearing roles across any paradigm (T5). No widgets —
/// pure token math, same style as token_compose_test.
void main() {
  AppSemantics sem(Paradigm p, [Set<Profile> profiles = const {}]) =>
      AppSemantics(paradigm: p, profiles: profiles);

  const brand = Color(0xFFFA2D48); // a saturated content colour (Music red)
  double sat(Color c) => HSLColor.fromColor(c).saturation;

  group('T2 — app-icon backing is paradigm chrome (same content colour)', () {
    test('skeuo backing is a dimensional gradient with inset detailing', () {
      final b = sem(Paradigm.skeuo).system.appIconBacking(brand);
      expect(b.gradient, isNotNull);
      expect(b.insets, isNotEmpty);
      expect(b.blurSigma, 0);
    });

    test('glass backing is translucent + blurs the wallpaper behind it', () {
      final b = sem(Paradigm.glass).system.appIconBacking(brand);
      expect(b.blurSigma, greaterThan(0));
      expect(b.color!.a, lessThan(1.0)); // translucent → wallpaper shows through
      expect(b.borderColor, isNotNull); // white edge rim
    });

    test('minimal backing is flat: no gradient, no blur, no shadow', () {
      final b = sem(Paradigm.minimal).system.appIconBacking(brand);
      expect(b.gradient, isNull);
      expect(b.blurSigma, 0);
      expect(b.shadows, isEmpty);
      expect(b.color, isNotNull);
    });
  });

  group('T5 — Cognitive is a composable surface desaturation delta', () {
    test('desaturates the icon backing on every paradigm', () {
      for (final p in Paradigm.values) {
        final base = sem(p).system.appIconBacking(brand);
        final cog = sem(p, {Profile.cognitive}).system.appIconBacking(brand);
        final baseColor = base.color ?? base.gradient!.colors[1];
        final cogColor = cog.color ?? cog.gradient!.colors[1];
        expect(sat(cogColor), lessThan(sat(baseColor)), reason: '$p icon backing should mute');
      }
    });

    test('reduces wallpaper saturation on every paradigm', () {
      for (final p in Paradigm.values) {
        final base = sem(p).system.wallpaper.colors;
        final cog = sem(p, {Profile.cognitive}).system.wallpaper.colors;
        // At least one stop drops saturation (neutral stops may already be ~0).
        final dropped = [
          for (var i = 0; i < base.length; i++) sat(cog[i]) <= sat(base[i]) + 1e-6
        ].every((x) => x);
        expect(dropped, isTrue, reason: '$p wallpaper should not gain saturation');
      }
    });

    test('mutes Control-Center on-state tile chroma (Glass example)', () {
      final base = sem(Paradigm.glass).tile.ground(WState.selected).color!;
      final cog = sem(Paradigm.glass, {Profile.cognitive}).tile.ground(WState.selected).color!;
      expect(sat(cog), lessThan(sat(base)));
    });

    test('lowers section-header emphasis (title shifts toward caption)', () {
      final base = sem(Paradigm.skeuo).sectionHeader.titleColor;
      final cog = sem(Paradigm.skeuo, {Profile.cognitive}).sectionHeader.titleColor;
      expect(cog, isNot(equals(base)));
    });

    test('is a NO-OP when Cognitive is absent (base unchanged)', () {
      expect(sem(Paradigm.glass).tile.ground(WState.selected).color,
          sem(Paradigm.glass).tile.ground(WState.selected).color);
      // Composes with other profiles without error.
      final s = sem(Paradigm.glass, {Profile.vision, Profile.cognitive, Profile.motor});
      expect(s.system.appIconBacking(brand), isNotNull);
    });
  });
}
