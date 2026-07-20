/// TIER 4 — ONE-HANDED profile.
///
/// SCOPE (Q3): Customization-preview-only, and a LAYOUT delta (thumb-zone
/// clustering) not a colour delta (finding #5). No surface-level token change on
/// Control Center or Home. PreviewCard (Phase 4) clusters tiles into the lower
/// ~65% with a "reachable" hairline at ~35%, matching the hi-fi PreviewCard's
/// additive `oneHanded` axis. Surface no-op by design.
class OneHandedProfile {
  OneHandedProfile._();

  /// Fraction of the interior treated as reachable (bottom band). Consumed by
  /// PreviewCard in Phase 4.
  static const double reachableFromTop = 0.35;
}
