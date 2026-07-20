/// TIER 4 — COGNITIVE profile.
///
/// SCOPE (Q3): Customization-preview-only. Cognitive applies NO surface-level
/// token delta on Control Center or Home — it toggles in the profile panel and
/// its effect (simplified layout, reduced chrome, muted colour) is expressed in
/// PreviewCard only (Phase 4). This module is intentionally a surface no-op so
/// the profile is a real, composable member of the Profile set without deriving
/// unshipped surface behaviour.
class CognitiveProfile {
  CognitiveProfile._();

  /// Preview-only intent hints, consumed by PreviewCard in Phase 4 (not by
  /// Control Center / Home resolvers).
  static const double previewChromeReduction = 0.5; // muted/reduced in preview
}
