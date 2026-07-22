/// TIER 4 — COGNITIVE profile.
///
/// SCOPE (Phase 8 / T5): now a first-class SURFACE delta, no longer preview-
/// only. Cognitive contributes an orthogonal desaturation that composes over
/// any paradigm (the Motor/Vision shape): chroma-bearing surfaces mute so the
/// screen reads calmer under cognitive load. The concrete amounts live here;
/// they are applied once, at the chroma-bearing roles, in compose.dart — never
/// per widget.
class CognitiveProfile {
  CognitiveProfile._();

  /// Default saturation reduction for chroma-bearing surfaces (widget cards,
  /// wallpaper, Control-Center on-states + slider fills). 0 = unchanged.
  static const double desaturation = 0.5;

  /// Stronger reduction for app-icon backings — the load-bearing perceptibility
  /// cue on Home (T5: "desaturate app icon backings" is the key fix).
  static const double iconDesaturation = 0.6;

  /// Section-header emphasis reduction: blend the title colour toward the
  /// caption colour by this fraction (lower visual hierarchy).
  static const double headerEmphasisBlend = 0.4;
}
