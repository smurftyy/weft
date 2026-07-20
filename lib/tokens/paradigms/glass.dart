import 'package:flutter/painting.dart';
import '../primitives.dart';
import '../token_types.dart';
import 'paradigm_bindings.dart';

/// Glass binding — translucent, atmospheric. Base (non-Vision) values.
/// The Vision-on-Glass rebinding + plate/labelChip drop are intersection
/// overrides applied in compose.dart, NOT here (§3.3).
class GlassBindings extends ParadigmBindings {
  @override
  Paradigm get id => Paradigm.glass;

  @override
  SurfaceStyle container() => SurfaceStyle(
        color: Prims.black.withValues(alpha: Prims.glassTintContainer), // .60 tint
        blurSigma: Prims.blurContainer, // 40
        borderColor: Prims.white.withValues(alpha: Prims.a16), // 15% top rim
        borderWidth: 1,
      );

  @override
  double get tileRadius => Prims.rad3Xl; // 22 (finding #3: 16→22 glass-only)

  @override
  SurfaceStyle tileGround(WState s) {
    switch (s) {
      case WState.selected:
        return SurfaceStyle(
          color: const Color(0xFF3880FF).withValues(alpha: Prims.a35 + 0.01), // ~.36
          blurSigma: Prims.blurBase,
          borderColor: const Color(0xFFB8D0FF).withValues(alpha: Prims.a95),
          shadows: Prims.glassDrop,
          insets: const [InsetSpec.glassGlowTile], // omnidirectional inner glow (R6)
        );
      case WState.pressed:
        return SurfaceStyle(
          color: Prims.white.withValues(alpha: Prims.a18),
          blurSigma: Prims.blurPressed,
          borderColor: Prims.white.withValues(alpha: Prims.a50),
        );
      case WState.disabled:
        return SurfaceStyle(
          color: Prims.white.withValues(alpha: Prims.a09),
          blurSigma: Prims.blurSm,
          borderColor: Prims.white.withValues(alpha: Prims.a26),
        );
      case WState.enabled:
      case WState.focus:
        return SurfaceStyle(
          color: Prims.white.withValues(alpha: Prims.a16),
          blurSigma: Prims.blurBase,
          borderColor: Prims.white.withValues(alpha: Prims.a50),
          shadows: Prims.glassDrop,
        );
    }
  }

  @override
  Color tileInk(WState s) =>
      s == WState.disabled ? Prims.ink400 : Prims.white;

  @override
  Color tileStatus(WState s) => s == WState.disabled
      ? Prims.ink400
      : Prims.white.withValues(alpha: Prims.a82);

  @override
  Color? tileLabelChip(WState s) => Prims.black; // opaque #0B0B0D chip (base)

  @override
  SurfaceStyle sectionPlate() => SurfaceStyle(
        color: Prims.black.withValues(alpha: Prims.glassTintPlate), // .55
        blurSigma: Prims.blurSm, // 16
        borderColor: Prims.white.withValues(alpha: Prims.a16),
      );

  @override
  Color sectionTitleColor() => Prims.white;

  @override
  Color sectionCaptionColor() => Prims.white.withValues(alpha: Prims.a78);

  @override
  double get appIconRadius => Prims.rad4Xl; // 24

  @override
  List<BoxShadow> get appIconShadow => Prims.appIconShadowGlass;

  @override
  double get titleSize => Prims.textTitle;

  @override
  double get captionSize => Prims.textStatus;

  @override
  SurfaceStyle sliderTrack(WState s) => SurfaceStyle(
        color: Prims.white.withValues(alpha: Prims.a14),
        blurSigma: 18,
        borderColor: Prims.white.withValues(alpha: Prims.a45),
      );

  @override
  SurfaceStyle sliderFill(WState s) => s == WState.disabled
      ? SurfaceStyle(color: const Color(0xFFA0A5AF).withValues(alpha: Prims.a60))
      : SurfaceStyle(color: const Color(0xFF3880FF).withValues(alpha: Prims.a60));

  @override
  SurfaceStyle sliderThumb(WState s) {
    if (s == WState.disabled) return const SurfaceStyle(color: Color(0xFF9A9DA6));
    return SurfaceStyle(
      color: Prims.white,
      shadows: [
        if (s == WState.pressed)
          BoxShadow(color: const Color(0xFF3880FF).withValues(alpha: 0.28), spreadRadius: 6),
        const BoxShadow(color: Color(0x4D000000), offset: Offset(0, 2), blurRadius: 6),
      ],
    );
  }

  @override
  SurfaceStyle toggleTrack(WState s) {
    switch (s) {
      case WState.selected:
        return SurfaceStyle(
          color: const Color(0xFF3078FF).withValues(alpha: Prims.a40),
          blurSigma: Prims.blurMd,
          borderColor: const Color(0xFFB8D0FF).withValues(alpha: Prims.a90),
          insets: const [InsetSpec.glassGlowToggle],
        );
      case WState.disabled:
        return SurfaceStyle(
          color: Prims.white.withValues(alpha: Prims.a08),
          blurSigma: Prims.blurMd,
          borderColor: Prims.white.withValues(alpha: 0.25),
        );
      default:
        return SurfaceStyle(
          color: Prims.white.withValues(alpha: Prims.a14),
          blurSigma: Prims.blurMd,
          borderColor: Prims.white.withValues(alpha: Prims.a50),
        );
    }
  }

  @override
  SurfaceStyle toggleThumb(WState s) => s == WState.disabled
      ? const SurfaceStyle(color: Color(0xFF9A9DA6))
      : const SurfaceStyle(
          color: Prims.white,
          shadows: [BoxShadow(color: Color(0x47000000), offset: Offset(0, 2), blurRadius: 5)],
        );

  @override
  double get chipRadius => Prims.radXl; // 18

  @override
  bool get chipUppercase => false;

  @override
  SurfaceStyle chipGround(WState s) {
    switch (s) {
      case WState.selected:
        return SurfaceStyle(
          color: const Color(0xFF3880FF).withValues(alpha: Prims.a50),
          blurSigma: 18,
          borderColor: const Color(0xFFB8D0FF).withValues(alpha: Prims.a95),
          insets: const [InsetSpec.glassGlowChip],
        );
      case WState.disabled:
        return SurfaceStyle(
          color: Prims.white.withValues(alpha: Prims.a22),
          blurSigma: 18,
          borderColor: Prims.white.withValues(alpha: Prims.a30),
        );
      default:
        return SurfaceStyle(
          color: Prims.white.withValues(alpha: 0.42),
          blurSigma: 18,
          borderColor: Prims.white.withValues(alpha: Prims.a60),
        );
    }
  }

  @override
  Color chipText(WState s) => switch (s) {
        WState.selected => Prims.white,
        WState.disabled => const Color(0xFF6B6E78),
        _ => const Color(0xFF12131A),
      };

  @override
  SurfaceStyle cardGround() => SurfaceStyle(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Prims.white.withValues(alpha: Prims.a22),
            Prims.white.withValues(alpha: Prims.a08),
          ],
        ),
        blurSigma: Prims.blurBase,
        borderColor: Prims.white.withValues(alpha: Prims.a35),
        shadows: Prims.glassDrop,
      );

  @override
  // DISCOVERED TOKEN (Q2 rule): source WidgetCard title was skeuo-tuned only
  // (#8A7C64); glass needs a light title on its dark translucent ground.
  // Added at the semantic layer, logged in PLAN.md.
  Color cardTitleColor() => Prims.white.withValues(alpha: 0.85);

  @override
  SurfaceStyle previewPanel() => const SurfaceStyle(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF241D3F), Color(0xFF10323A)],
        ),
      );

  @override
  Color previewCaption() => Prims.white.withValues(alpha: Prims.a70);

  @override
  Color previewHairline() => Prims.white.withValues(alpha: 0.32);
}
