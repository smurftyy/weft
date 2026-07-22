import 'package:flutter/painting.dart';

/// Tier-1-adjacent colour math shared by paradigm bindings (deriving app-icon
/// backings from a content colour) and compose (Cognitive desaturation). Pure
/// functions — no literals leak into widgets; bindings/compose call these.
abstract final class Tone {
  Tone._();

  /// Shift lightness by [amt] in HSL space (clamped). Positive lightens.
  static Color lighten(Color c, double amt) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness + amt).clamp(0.0, 1.0)).toColor();
  }

  static Color darken(Color c, double amt) => lighten(c, -amt);

  /// Reduce saturation by fraction [amt] (0 = unchanged, 1 = greyscale).
  static Color desaturate(Color c, double amt) {
    final h = HSLColor.fromColor(c);
    return h.withSaturation((h.saturation * (1 - amt)).clamp(0.0, 1.0)).toColor();
  }

  /// Desaturate every stop of a gradient, preserving its geometry + type.
  static Gradient desaturateGradient(Gradient g, double amt) {
    final cols = [for (final c in g.colors) desaturate(c, amt)];
    if (g is LinearGradient) {
      return LinearGradient(begin: g.begin, end: g.end, colors: cols, stops: g.stops, tileMode: g.tileMode);
    }
    if (g is RadialGradient) {
      return RadialGradient(
        center: g.center,
        radius: g.radius,
        colors: cols,
        stops: g.stops,
        tileMode: g.tileMode,
        focal: g.focal,
        focalRadius: g.focalRadius,
      );
    }
    return g;
  }
}
