import '../primitives.dart';

/// TIER 4 — MOTOR profile. Purely orthogonal geometry deltas that compose over
/// ANY paradigm: larger touch targets, wider focus rings. No colour changes.
/// (Reduced-motion is a runtime concern handled at the animation layer later.)
class MotorProfile {
  MotorProfile._();

  static const double tileHeight = Prims.tileHeightMotor; // 140 (from 116)
  static const double ringWidth = Prims.focusRingBig; // 4
  static const double minThumb = 32;
  static const double minTrackHeight = 12;
  static const double toggleWidth = 76; // from 60
}
