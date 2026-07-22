import 'package:flutter/painting.dart';
import '../primitives.dart';
import '../token_types.dart';
import 'paradigm_bindings.dart';

/// Minimal binding — flat, hierarchy from size/weight/spacing.
class MinimalBindings extends ParadigmBindings {
  @override
  Paradigm get id => Paradigm.minimal;

  @override
  SurfaceStyle container() =>
      const SurfaceStyle(color: Color(0xFFFAF9F5), borderColor: Prims.ink200);

  @override
  double get tileRadius => Prims.radXs; // 8

  @override
  SurfaceStyle tileGround(WState s) {
    switch (s) {
      case WState.selected:
        return const SurfaceStyle(color: Prims.blue500, borderColor: Prims.blue500);
      case WState.disabled:
        return const SurfaceStyle(color: Prims.ink50, borderColor: Prims.ink100);
      case WState.enabled:
      case WState.pressed:
      case WState.focus:
        return const SurfaceStyle(color: Prims.white, borderColor: Prims.ink200);
    }
  }

  @override
  Color tileInk(WState s) => switch (s) {
        WState.selected => Prims.white,
        WState.disabled => Prims.ink300,
        _ => Prims.ink900,
      };

  @override
  Color tileStatus(WState s) => switch (s) {
        WState.selected => const Color(0xFFA9C6FF),
        WState.disabled => Prims.ink300,
        _ => Prims.ink400,
      };

  @override
  Color? tileLabelChip(WState s) => null;

  @override
  SurfaceStyle sectionPlate() => SurfaceStyle.none;

  @override
  Color sectionTitleColor() => const Color(0xFF14151A);

  @override
  Color sectionCaptionColor() => Prims.ink400;

  @override
  double get appIconRadius => Prims.radLg; // 16

  @override
  List<BoxShadow> get appIconShadow => Prims.appIconShadowMinimal; // none

  @override
  // Flat colored tile: no shadow, no gradient. A hairline keeps white tiles
  // legible on the near-white wallpaper (border is neither shadow nor gradient,
  // so it stays within the flat-material contract). (T2)
  SurfaceStyle appIconBacking(Color content) => SurfaceStyle(
        color: content,
        borderColor: const Color(0x14000000),
        borderWidth: 1.0,
      );

  @override
  Color get appIconLabelColor => Prims.ink900;

  @override
  Shadow? get appIconLabelShadow => null; // flat: no text shadow

  @override
  Gradient get homeWallpaper => Prims.minimalWallpaper; // T1

  @override
  double get titleSize => Prims.textPage - 2; // minimal leans larger headers (26)

  @override
  double get captionSize => Prims.textCaption; // 11

  @override
  SurfaceStyle sliderTrack(WState s) => SurfaceStyle(
      color: s == WState.disabled ? const Color(0xFFECEDF0) : const Color(0xFFE1E3E8));

  @override
  SurfaceStyle sliderFill(WState s) => SurfaceStyle(
      color: s == WState.disabled ? Prims.ink300 : Prims.blue500);

  @override
  SurfaceStyle sliderThumb(WState s) => s == WState.disabled
      ? const SurfaceStyle(
          color: Prims.ink300,
          shadows: [BoxShadow(color: Color(0xFFFAF9F5), spreadRadius: 3)])
      : const SurfaceStyle(
          color: Prims.blue500,
          shadows: [BoxShadow(color: Prims.white, spreadRadius: 3)]);

  @override
  SurfaceStyle toggleTrack(WState s) => switch (s) {
        WState.selected => const SurfaceStyle(color: Prims.blue500),
        WState.disabled => const SurfaceStyle(color: Color(0xFFECEDF0)),
        _ => const SurfaceStyle(color: Prims.ink200),
      };

  @override
  SurfaceStyle toggleThumb(WState s) => s == WState.disabled
      ? const SurfaceStyle(color: Prims.ink50, borderColor: Color(0x0F000000))
      : const SurfaceStyle(color: Prims.white, borderColor: Color(0x1A000000));

  @override
  double get chipRadius => Prims.radXs; // 8

  @override
  bool get chipUppercase => true;

  @override
  SurfaceStyle chipGround(WState s) => switch (s) {
        WState.selected =>
          const SurfaceStyle(color: Prims.blue500, borderColor: Prims.blue500),
        WState.disabled =>
          const SurfaceStyle(color: Prims.ink50, borderColor: Prims.ink100),
        _ => const SurfaceStyle(color: Prims.white, borderColor: Prims.ink200),
      };

  @override
  Color chipText(WState s) => switch (s) {
        WState.selected => Prims.white,
        WState.disabled => Prims.ink300,
        _ => Prims.ink600,
      };

  @override
  SurfaceStyle cardGround() =>
      const SurfaceStyle(color: Color(0xFFFBFAF7), borderColor: Color(0xFFE4E0D6));

  @override
  Color cardTitleColor() => Prims.ink500;

  @override
  SurfaceStyle previewPanel() =>
      const SurfaceStyle(color: Color(0xFFFAF9F5), borderColor: Prims.ink200);

  @override
  Color previewCaption() => Prims.ink400;

  @override
  Color previewHairline() => const Color(0xFFC7CAD2);

  @override
  SurfaceStyle customizationSurface() => container(); // T7: edge-to-edge flat
  @override
  EdgeInsets get customizationInset => EdgeInsets.zero;
  @override
  double get customizationRadius => 0;
}
