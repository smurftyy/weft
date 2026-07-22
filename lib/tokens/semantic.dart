import 'package:flutter/material.dart';
import 'primitives.dart';
import 'token_types.dart';
import 'compose.dart';
import 'paradigms/paradigm_bindings.dart';
import 'paradigms/skeuo.dart';
import 'paradigms/glass.dart';
import 'paradigms/minimal.dart';

export 'token_types.dart';

/// TIER 2 — SEMANTIC.
///
/// The only tier widgets read. [AppSemantics] is a [ThemeExtension] carrying the
/// active paradigm + profile set; its component-group getters expose resolver
/// methods that hand atoms the fully-composed, intersection-corrected value for
/// a given [WState]. Atoms stay dumb — no literals, no state/paradigm/profile
/// branching in atom bodies.
///
/// Because the extension already encodes paradigm×profiles (composed via
/// [Compose]), the resolver is the single call site atoms touch. A paradigm swap
/// or profile toggle produces a new [AppSemantics]; every resolver reflects it.
@immutable
class AppSemantics extends ThemeExtension<AppSemantics> {
  final Paradigm paradigm;
  final Set<Profile> profiles;
  final ParadigmBindings _b;

  AppSemantics({required this.paradigm, Set<Profile> profiles = const {}})
      : profiles = Set.unmodifiable(profiles),
        _b = bindingsFor(paradigm);

  static ParadigmBindings bindingsFor(Paradigm p) => switch (p) {
        Paradigm.skeuo => SkeuoBindings(),
        Paradigm.glass => GlassBindings(),
        Paradigm.minimal => MinimalBindings(),
      };

  // Component-group views (cheap; constructed on access).
  ContainerTokens get container => ContainerTokens(_b, profiles);
  TileTokens get tile => TileTokens(_b, profiles);
  SectionHeaderTokens get sectionHeader => SectionHeaderTokens(_b, profiles);
  TextTokens get text => TextTokens(_b, profiles);
  StateTokens get state => StateTokens(profiles);
  SystemTokens get system => SystemTokens(_b, profiles);
  SliderTokens get slider => SliderTokens(_b, profiles);
  ToggleTokens get toggle => ToggleTokens(_b, profiles);
  ChipTokens get chip => ChipTokens(_b, profiles);
  CardTokens get card => CardTokens(_b, profiles);
  PreviewTokens get preview => PreviewTokens(_b, profiles);

  @override
  AppSemantics copyWith({Paradigm? paradigm, Set<Profile>? profiles}) =>
      AppSemantics(
        paradigm: paradigm ?? this.paradigm,
        profiles: profiles ?? this.profiles,
      );

  /// Paradigm/profile swaps are instant, not cross-faded (Q3: skip theme_tailor
  /// lerp). Snap at the midpoint so any incidental theme animation resolves.
  @override
  AppSemantics lerp(covariant ThemeExtension<AppSemantics>? other, double t) =>
      (t < 0.5 || other == null) ? this : other as AppSemantics;

  @override
  bool operator ==(Object other) =>
      other is AppSemantics &&
      other.paradigm == paradigm &&
      other.profiles.length == profiles.length &&
      other.profiles.containsAll(profiles);

  @override
  int get hashCode => Object.hash(paradigm, Object.hashAllUnordered(profiles));
}

/// Convenience accessor: `context.sem.tile.ground(WState.selected)`.
extension AppSemanticsX on BuildContext {
  AppSemantics get sem => Theme.of(this).extension<AppSemantics>()!;
}

// ── Component-group resolver views ───────────────────────────────────────────

class ContainerTokens {
  final ParadigmBindings _b;
  final Set<Profile> _p;
  const ContainerTokens(this._b, this._p);

  SurfaceStyle get style => Compose.container(_b, _p);
}

class TileTokens {
  final ParadigmBindings _b;
  final Set<Profile> _p;
  const TileTokens(this._b, this._p);

  double get radius => _b.tileRadius;
  double get height => Compose.tileHeight(_p);
  SurfaceStyle ground(WState s) => Compose.tileGround(_b, s, _p);
  Color ink(WState s) => Compose.tileInk(_b, s, _p);
  Color status(WState s) => Compose.tileStatus(_b, s, _p);

  /// Opaque backing chip behind the label; null when the paradigm has none or
  /// the generalized cascade dropped it (Glass×Vision).
  Color? labelChip(WState s) => Compose.tileLabelChip(_b, s, _p);
}

class SectionHeaderTokens {
  final ParadigmBindings _b;
  final Set<Profile> _p;
  const SectionHeaderTokens(this._b, this._p);

  SurfaceStyle get plate => Compose.sectionPlate(_b, _p);
  Color get titleColor => Compose.sectionTitle(_b, _p); // Cognitive lowers emphasis (T5)
  Color get captionColor => _b.sectionCaptionColor();
}

class TextTokens {
  final ParadigmBindings _b;
  final Set<Profile> _p;
  const TextTokens(this._b, this._p);

  double get titleSize => _b.titleSize * Compose.textScale(_p);
  double get captionSize => _b.captionSize * Compose.textScale(_p);
  double get scale => Compose.textScale(_p);
}

class StateTokens {
  final Set<Profile> _p;
  const StateTokens(this._p);

  double get focusRingWidth => Compose.ringWidth(_p);
  Color get focusRingColor => Prims.blue500;
  double get iconStrokeMul => Compose.iconStrokeMul(_p);
}

class SystemTokens {
  final ParadigmBindings _b;
  final Set<Profile> _p;
  const SystemTokens(this._b, this._p);

  /// AppIcon glyph is CONTENT (§3.4). Radius + shadow + BACKING are chrome (T2).
  double get appIconRadius => _b.appIconRadius;
  List<BoxShadow> get appIconShadow => _b.appIconShadow;

  /// Paradigm-tokenized backing derived from the icon's content colour (T2).
  /// Cognitive desaturates it (T5).
  SurfaceStyle appIconBacking(Color content) => Compose.appIconBacking(_b, content, _p);

  /// App-icon label is chrome (text over the wallpaper).
  Color get appIconLabelColor => _b.appIconLabelColor;
  Shadow? get appIconLabelShadow => _b.appIconLabelShadow;

  /// Wallpaper — chrome; changes across paradigms (T1). Cognitive desaturates
  /// it (T5). `homeWallpaper` kept as an alias for existing call sites.
  Gradient get wallpaper => Compose.wallpaper(_b, _p);
  Gradient get homeWallpaper => wallpaper;
}

class SliderTokens {
  final ParadigmBindings _b;
  final Set<Profile> _p;
  const SliderTokens(this._b, this._p);

  double get trackHeight => Compose.sliderTrackHeight(_p);
  double thumbDiameter({bool dragging = false}) => Compose.sliderThumb(_p, dragging: dragging);
  SurfaceStyle track(WState s) => Compose.sliderTrack(_b, s, _p);
  SurfaceStyle fill(WState s) => Compose.sliderFill(_b, s, _p);
  SurfaceStyle thumb(WState s) => Compose.sliderThumbStyle(_b, s, _p);
}

class ToggleTokens {
  final ParadigmBindings _b;
  final Set<Profile> _p;
  const ToggleTokens(this._b, this._p);

  double get width => Compose.toggleWidth(_p);
  double get height => Compose.toggleHeight(_p);
  double get thumbSize => Compose.toggleThumbSize(_p);

  /// Second axis (on/off) mapped onto the standard WState: on→selected.
  SurfaceStyle track(bool on, {bool disabled = false}) =>
      Compose.toggleTrack(_b, _state(on, disabled), _p);
  SurfaceStyle thumb(bool on, {bool disabled = false}) =>
      Compose.toggleThumbStyle(_b, _state(on, disabled), _p);

  WState _state(bool on, bool disabled) =>
      disabled ? WState.disabled : (on ? WState.selected : WState.enabled);
}

class ChipTokens {
  final ParadigmBindings _b;
  final Set<Profile> _p;
  const ChipTokens(this._b, this._p);

  double get radius => _b.chipRadius;
  bool get uppercase => _b.chipUppercase;
  double get textScale => Compose.textScale(_p); // Vision contrast/scale propagates
  SurfaceStyle ground(WState s) => Compose.chipGround(_b, s, _p);
  Color text(WState s) => _b.chipText(s);
}

class CardTokens {
  final ParadigmBindings _b;
  final Set<Profile> _p;
  const CardTokens(this._b, this._p);

  SurfaceStyle get ground => Compose.cardGround(_b, _p);
  Color get titleColor => _b.cardTitleColor();
}

class PreviewTokens {
  final ParadigmBindings _b;
  final Set<Profile> _p;
  const PreviewTokens(this._b, this._p);

  SurfaceStyle get panel => _b.previewPanel();
  Color get caption => _b.previewCaption();
  Color get hairline => _b.previewHairline();

  /// One-Handed reachable-zone fraction (preview-only, Q3). null when inactive.
  double? get reachableFromTop =>
      _p.contains(Profile.oneHanded) ? 0.35 : null;
}
