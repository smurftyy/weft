import 'package:flutter/painting.dart';
import '../primitives.dart';
import '../token_types.dart';

/// TIER 4 — VISION profile.
///
/// Two kinds of contribution:
///  • ORTHOGONAL scalars (apply over ANY paradigm): text ×1.35, icon stroke
///    ×1.5, focus ring width → 4.
///  • INTERSECTION rebindings (Glass only): when the container takes over the
///    legibility job, glass tiles switch to opaque light grounds and reduced
///    blur, and opaque backing chips/plates drop. Orchestrated in compose.dart;
///    the concrete glass-vision values live here.
class VisionProfile {
  VisionProfile._();

  static const double textScale = Prims.visionScale; // 1.35
  static const double iconStrokeMul = 1.5;
  static const double ringWidth = Prims.focusRingBig; // 4
  static const double glassContainerTint = Prims.glassTintVision; // .92
  static const double glassBlurFloor = Prims.blurReduced; // 6

  /// Glass×Vision tile rebinding (opaque light grounds, blur floored).
  static SurfaceStyle glassTileGround(WState s) {
    switch (s) {
      case WState.selected:
        return SurfaceStyle(
          color: const Color(0xFF185AD6).withValues(alpha: 0.94),
          blurSigma: glassBlurFloor,
          borderColor: const Color(0xFFAAC6FF).withValues(alpha: Prims.a95),
          shadows: Prims.glassDrop,
          insets: const [InsetSpec.glassGlowTileVision],
        );
      case WState.pressed:
        return SurfaceStyle(
          color: const Color(0xFFE4EAF4).withValues(alpha: 0.92),
          blurSigma: glassBlurFloor,
          borderColor: Prims.white.withValues(alpha: Prims.a70),
        );
      case WState.disabled:
        return SurfaceStyle(
          color: const Color(0xFFE0E4EC).withValues(alpha: 0.92),
          blurSigma: glassBlurFloor,
          borderColor: Prims.white.withValues(alpha: Prims.a50),
        );
      case WState.enabled:
      case WState.focus:
        return SurfaceStyle(
          color: const Color(0xFFF4F7FC).withValues(alpha: 0.90),
          blurSigma: glassBlurFloor,
          borderColor: Prims.white.withValues(alpha: Prims.a70),
          shadows: Prims.glassDrop,
        );
    }
  }

  static Color glassTileInk(WState s) => switch (s) {
        WState.selected => Prims.white,
        WState.disabled => Prims.ink400,
        _ => const Color(0xFF1A2A44), // dark ink on light ground
      };

  static Color glassTileStatus(WState s) => switch (s) {
        WState.selected => const Color(0xE6FFFFFF),
        WState.disabled => Prims.ink400,
        _ => const Color(0xFF2A3550),
      };
}
