/// TIER 4 — ONE-HANDED profile.
///
/// A LAYOUT delta (thumb-zone clustering), not a colour/scale delta (finding
/// #5) — so it is expressed as conditional layout code in the surfaces, NOT as
/// token overrides. Scope (Phase 8 / T13):
///  • HOME: the widgets + app grid cluster into the lower zone (bottom-anchored),
///    leaving the upper region as wallpaper; the dock is unchanged.
///  • Customization PREVIEW: tiles cluster into the lower ~65% with a
///    "reachable" hairline at ~35% (the original additive `oneHanded` axis).
///  • CONTROL CENTER: remains at preview-scale in this build (a clean lower-half
///    shift on the scroll-filling CC panel was deferred as slip-acceptable).
class OneHandedProfile {
  OneHandedProfile._();

  /// Fraction of the interior treated as reachable (bottom band). Consumed by
  /// PreviewCard.
  static const double reachableFromTop = 0.35;
}
