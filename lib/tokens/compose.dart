import 'package:flutter/painting.dart';
import 'primitives.dart';
import 'token_types.dart';
import 'color_util.dart';
import 'paradigms/paradigm_bindings.dart';
import 'profiles/motor.dart';
import 'profiles/vision.dart';
import 'profiles/cognitive.dart';

/// COMPOSITION — folds paradigm bindings (Tier 3) with profile deltas (Tier 4)
/// into resolved values. The semantic tier calls these; nothing else does.
///
/// Two delta kinds:
///  • orthogonal scalars (ring width, tile height, text scale) — any paradigm.
///  • intersection overrides — the generalized Glass×Vision cascade (finding
///    #4): when the container has taken over legibility, every opaque backing
///    element drops and glass tiles rebind to opaque light grounds. This is
///    expressed as ONE predicate ([backingDropped]) that all backing roles
///    consult — one rule, not seven.
///
/// Composition order is fixed and documented: Motor → Vision → Cognitive →
/// One-Handed. Cognitive/One-Handed are surface no-ops (Q3), so only Motor and
/// Vision affect resolved surface values here.
class Compose {
  Compose._();

  static bool _vision(Set<Profile> p) => p.contains(Profile.vision);
  static bool _motor(Set<Profile> p) => p.contains(Profile.motor);
  static bool _cognitive(Set<Profile> p) => p.contains(Profile.cognitive);

  /// COGNITIVE delta (T5) — an orthogonal desaturation that composes over any
  /// paradigm (Motor/Vision shape). When active, chroma-bearing surfaces mute:
  /// icon backings, widget cards, wallpaper, and Control-Center on-states/fills
  /// all drop saturation so the surface reads calmer. Neutral surfaces are
  /// unaffected (desaturating near-white is a no-op). One helper, applied at the
  /// chroma-bearing roles — not per widget.
  static SurfaceStyle _mute(SurfaceStyle s, Set<Profile> p, [double amt = CognitiveProfile.desaturation]) {
    if (!_cognitive(p)) return s;
    final g = s.gradient == null ? null : Tone.desaturateGradient(s.gradient!, amt);
    return s.copyWith(color: s.color == null ? null : Tone.desaturate(s.color!, amt), gradient: g);
  }

  /// THE generalized cascade predicate (finding #4). When true, any opaque
  /// backing element in the current intersection reduces to nothing and glass
  /// tiles rebind — because the container now carries the contrast job.
  static bool backingDropped(Paradigm id, Set<Profile> profiles) =>
      id == Paradigm.glass && _vision(profiles);

  // ── Container ──
  static SurfaceStyle container(ParadigmBindings b, Set<Profile> profiles) {
    final base = b.container();
    if (backingDropped(b.id, profiles)) {
      // Container deepens .60 → .92 and drops blur to the Vision floor.
      return base.copyWith(
        color: Prims.black.withValues(alpha: VisionProfile.glassContainerTint),
        blurSigma: VisionProfile.glassBlurFloor,
      );
    }
    return base;
  }

  // ── Tile ──
  static SurfaceStyle tileGround(ParadigmBindings b, WState s, Set<Profile> profiles) {
    final base = backingDropped(b.id, profiles)
        ? VisionProfile.glassTileGround(s)
        : b.tileGround(s);
    return _mute(base, profiles); // Cognitive desaturates the on-state chroma (T5)
  }

  static Color tileInk(ParadigmBindings b, WState s, Set<Profile> profiles) {
    if (backingDropped(b.id, profiles)) return VisionProfile.glassTileInk(s);
    return b.tileInk(s);
  }

  static Color tileStatus(ParadigmBindings b, WState s, Set<Profile> profiles) {
    if (backingDropped(b.id, profiles)) return VisionProfile.glassTileStatus(s);
    return b.tileStatus(s);
  }

  /// Opaque label chip — dropped by the generalized cascade.
  static Color? tileLabelChip(ParadigmBindings b, WState s, Set<Profile> profiles) {
    if (backingDropped(b.id, profiles)) return null;
    return b.tileLabelChip(s);
  }

  static double tileHeight(Set<Profile> profiles) => _motor(profiles)
      ? MotorProfile.tileHeight // 140 (Motor dominates)
      : (_vision(profiles) ? 132 : Prims.tileHeightBase); // Vision enlarges a step for the bigger type

  // ── Section header ──
  /// Backing plate — dropped by the same generalized cascade as the label chip.
  static SurfaceStyle sectionPlate(ParadigmBindings b, Set<Profile> profiles) {
    if (backingDropped(b.id, profiles)) return SurfaceStyle.none;
    return b.sectionPlate();
  }

  /// Section title colour — Cognitive lowers header emphasis by blending the
  /// title toward the caption colour (T5). No change otherwise.
  static Color sectionTitle(ParadigmBindings b, Set<Profile> p) {
    final base = b.sectionTitleColor();
    if (!_cognitive(p)) return base;
    return Color.lerp(base, b.sectionCaptionColor(), CognitiveProfile.headerEmphasisBlend)!;
  }

  // ── App icon backing (T2) — chrome derived from the icon's content colour.
  // Cognitive (T5) desaturates the content before the paradigm builds material.
  static SurfaceStyle appIconBacking(ParadigmBindings b, Color content, Set<Profile> p) {
    final c = _cognitive(p) ? Tone.desaturate(content, CognitiveProfile.iconDesaturation) : content;
    return b.appIconBacking(c);
  }

  // ── Wallpaper (T1) — Cognitive reduces its saturation (T5).
  static Gradient wallpaper(ParadigmBindings b, Set<Profile> p) =>
      _cognitive(p) ? Tone.desaturateGradient(b.homeWallpaper, CognitiveProfile.desaturation) : b.homeWallpaper;

  // ── Orthogonal scalars ──
  static double ringWidth(Set<Profile> profiles) =>
      (_motor(profiles) || _vision(profiles)) ? Prims.focusRingBig : Prims.focusRingBase;

  static double textScale(Set<Profile> profiles) =>
      _vision(profiles) ? VisionProfile.textScale : 1.0;

  static double iconStrokeMul(Set<Profile> profiles) =>
      _vision(profiles) ? VisionProfile.iconStrokeMul : 1.0;

  // ── New-role geometry (Motor grows targets; Vision moderate bump) ──
  static double sliderTrackHeight(Set<Profile> p) =>
      _motor(p) ? 12 : (_vision(p) ? 10 : 8);
  static double sliderThumb(Set<Profile> p, {bool dragging = false}) {
    if (_motor(p)) return dragging ? 40 : 32;
    if (_vision(p)) return dragging ? 30 : 24;
    return dragging ? 26 : 20;
  }

  static double toggleWidth(Set<Profile> p) => _motor(p) ? 76 : 60;
  static double toggleHeight(Set<Profile> p) => _motor(p) ? 44 : 34;
  static double toggleThumbSize(Set<Profile> p) => _motor(p) ? 36 : 26;

  /// Glass×Vision transparency reduction (F2). Raises translucent fills to
  /// near-opaque so small controls stay legible under Vision. Preserves hue —
  /// on-states keep saturation, so their (often white) text keeps contrast —
  /// rather than compositing over a light paper that would wash them out. Blur
  /// drops to zero. One rule, applied to slider/toggle/chip grounds.
  static SurfaceStyle _opaquify(SurfaceStyle s, Paradigm id, Set<Profile> p) {
    if (!(id == Paradigm.glass && _vision(p))) return s;
    Color op(Color c) => c.a >= 0.92 ? c : c.withValues(alpha: 0.92);
    Gradient? g = s.gradient;
    if (g is LinearGradient) {
      g = LinearGradient(
        begin: g.begin,
        end: g.end,
        stops: g.stops,
        colors: [for (final c in g.colors) op(c)],
      );
    }
    return s.copyWith(color: s.color == null ? null : op(s.color!), gradient: g, blurSigma: 0);
  }

  /// Card is excluded from [_opaquify]: its content ink is surface-owned, and a
  /// dark translucent card with light content stays legible. Vision just floors
  /// its blur (reduced transparency without flipping the card to light).
  static SurfaceStyle _floorBlur(SurfaceStyle s, Paradigm id, Set<Profile> p) =>
      (id == Paradigm.glass && _vision(p) && s.blurSigma > 0)
          ? s.copyWith(blurSigma: VisionProfile.glassBlurFloor)
          : s;

  static SurfaceStyle sliderTrack(ParadigmBindings b, WState s, Set<Profile> p) =>
      _opaquify(b.sliderTrack(s), b.id, p);
  static SurfaceStyle sliderFill(ParadigmBindings b, WState s, Set<Profile> p) =>
      _mute(_opaquify(b.sliderFill(s), b.id, p), p); // Cognitive mutes fill (T5)
  static SurfaceStyle sliderThumbStyle(ParadigmBindings b, WState s, Set<Profile> p) =>
      b.sliderThumb(s);

  static SurfaceStyle toggleTrack(ParadigmBindings b, WState s, Set<Profile> p) =>
      _opaquify(b.toggleTrack(s), b.id, p);
  static SurfaceStyle toggleThumbStyle(ParadigmBindings b, WState s, Set<Profile> p) =>
      b.toggleThumb(s);

  static SurfaceStyle chipGround(ParadigmBindings b, WState s, Set<Profile> p) =>
      _opaquify(b.chipGround(s), b.id, p);

  static SurfaceStyle cardGround(ParadigmBindings b, Set<Profile> p) =>
      _mute(_floorBlur(b.cardGround(), b.id, p), p); // Cognitive mutes card chroma (T5)
}
