import 'package:flutter/painting.dart';
import 'primitives.dart' show InsetSpec;
export 'primitives.dart' show InsetSpec;

/// Shared token enums + the resolved-surface value type. Kept in one low-level
/// file so paradigm bindings, profile deltas, compose and semantic can all
/// import it without cycles.

/// The three aesthetic paradigms.
enum Paradigm { skeuo, glass, minimal }

/// The four accessibility profiles. Motor + Vision are first-class across all
/// surfaces; Cognitive is a surface delta (T5); One-Handed is a layout delta.
enum Profile { motor, vision, cognitive, oneHanded }

/// Home-grid density (T10) — a user layout preference, composed with Motor
/// (which bumps the resolved icon size over the chosen density).
enum GridDensity { compact, standard, spacious }

/// Resolved home-grid geometry for a [GridDensity] (× Motor). Icon size,
/// spacing and page-indicator scale all move together.
class GridSpec {
  final int cols;
  final int rows;
  final double iconSize;
  final double spacing;
  final double indicatorScale;
  const GridSpec({
    required this.cols,
    required this.rows,
    required this.iconSize,
    required this.spacing,
    required this.indicatorScale,
  });
}

/// The standard interaction-state axis every interactive atom shares.
/// Widget-specific extra axes (slider value, toggle on/off) are passed as a
/// SECOND argument only where genuinely needed — never added proactively.
enum WState { enabled, pressed, focus, selected, disabled }

/// A fully-resolved surface style the atom paints verbatim (atoms stay dumb).
/// One value object covers solid/gradient fill, optional backdrop blur, border
/// and drop shadows — everything a tile/container/plate needs.
class SurfaceStyle {
  final Color? color;
  final Gradient? gradient;
  final double blurSigma; // 0 = no backdrop blur
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow> shadows;

  /// Inner shadows / inner glows (CSS `inset`), painted by the shared
  /// InsetShadowPainter (R6 decision). Values stay in the token tiers.
  final List<InsetSpec> insets;

  const SurfaceStyle({
    this.color,
    this.gradient,
    this.blurSigma = 0,
    this.borderColor,
    this.borderWidth = 1,
    this.shadows = const <BoxShadow>[],
    this.insets = const <InsetSpec>[],
  });

  /// Nothing drawn — used when a backing element is dropped by a cascade
  /// (e.g. SectionHeader plate under Glass×Vision).
  static const SurfaceStyle none = SurfaceStyle();

  bool get isEmpty =>
      color == null && gradient == null && borderColor == null && shadows.isEmpty && insets.isEmpty;

  SurfaceStyle copyWith({
    Color? color,
    Gradient? gradient,
    double? blurSigma,
    Color? borderColor,
    double? borderWidth,
    List<BoxShadow>? shadows,
    List<InsetSpec>? insets,
  }) {
    return SurfaceStyle(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      blurSigma: blurSigma ?? this.blurSigma,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadows: shadows ?? this.shadows,
      insets: insets ?? this.insets,
    );
  }
}
