import 'package:flutter/painting.dart';

/// TIER 1 — PRIMITIVES.
///
/// Raw, scaled values only. This is the ONLY tier that holds literal colors,
/// radii, blurs, opacities, gradients and shadow geometry. Per the token
/// architecture (§3.1) nothing above the paradigm-binding factories may read
/// from here — widgets read the semantic tier, paradigm factories read this.
///
/// Reverse-engineered from the hi-fi atom source (AtomTile/Slider/Toggle/Chip/
/// SectionHeader/PreviewCard/AppIcon/WidgetCard) and regularized into scales:
/// a 2px radius ladder, an anchored blur ladder, a 10-step ink ramp, an 8-step
/// brand-blue ramp, a warm/skeuo ramp, a named alpha ladder, and the 8pt grid.
///
/// NOTE (inset shadows): CSS `inset` box-shadows used pervasively by Skeuo have
/// no `BoxShadow` equivalent in Flutter. Outer/drop shadows live here as
/// `BoxShadow`; the skeuo top-lit highlight + inset groove are modelled as
/// gradient primitives (Flutter-native) plus an [InsetSpec] data type that the
/// Phase-2 atoms render via CustomPainter / gradient overlay. See PLAN R6.
abstract final class Prims {
  Prims._();

  // ────────────────────────────────────────────────────────────────────────
  // RADIUS SCALE (logical px) — 2px step through the interactive band, +4 for
  // containers, fixed device frame.
  // ────────────────────────────────────────────────────────────────────────
  static const double radXs = 8;    // minimal tile, minimal chip
  static const double radSm = 10;   // skeuo chip
  static const double radMd = 12;   // glass section-header plate
  static const double radLg = 16;   // minimal AppIcon, pre-glass tile base
  static const double radXl = 18;   // glass chip
  static const double rad2Xl = 20;  // skeuo tile
  static const double rad3Xl = 22;  // glass tile, skeuo AppIcon, small card
  static const double rad4Xl = 24;  // glass AppIcon
  static const double rad5Xl = 26;  // medium card
  static const double rad6Xl = 30;  // large card
  static const double rad7Xl = 34;  // dock
  static const double radFrame = 44; // device bezel

  // ────────────────────────────────────────────────────────────────────────
  // BLUR LADDER (sigma px for BackdropFilter) — anchor 24; Vision floor 6.
  // ────────────────────────────────────────────────────────────────────────
  static const double blurNone = 0;
  static const double blurReduced = 6;    // Vision floor
  static const double blurSm = 16;        // section plate, disabled tile
  static const double blurMd = 20;        // slider/toggle/chip
  static const double blurBase = 24;      // glass tile enabled (anchor)
  static const double blurPressed = 34;   // glass tile pressed
  static const double blurContainer = 40; // control-center container

  // ────────────────────────────────────────────────────────────────────────
  // INK RAMP — neutral luminance, 10 steps + extremes.
  // ────────────────────────────────────────────────────────────────────────
  static const Color ink900 = Color(0xFF17181C);
  static const Color ink800 = Color(0xFF1D1E24);
  static const Color ink700 = Color(0xFF2A2C33);
  static const Color ink600 = Color(0xFF4A4D57);
  static const Color ink550 = Color(0xFF5A5D67);
  static const Color ink500 = Color(0xFF6B6E78);
  static const Color ink400 = Color(0xFF8A8D96);
  static const Color ink300 = Color(0xFFB7BAC2);
  static const Color ink200 = Color(0xFFDBDDE4);
  static const Color ink100 = Color(0xFFE9EAEE);
  static const Color ink50 = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0B0B0D); // glass label-chip / plate base

  // Cool near-white step pair used by skeuo enabled-tile ground.
  static const Color coolTop = Color(0xFFFFFFFF);
  static const Color coolBot = Color(0xFFE7EAF0);
  static const Color coolPressTop = Color(0xFFE4E7EE);
  static const Color coolPressBot = Color(0xFFD6DAE3);

  // ────────────────────────────────────────────────────────────────────────
  // BRAND-BLUE RAMP — by lightness. Both ends used by Vision/Skeuo on-states.
  // ────────────────────────────────────────────────────────────────────────
  static const Color blue900 = Color(0xFF0B49C0); // Vision-on deep
  static const Color blue800 = Color(0xFF1550C0);
  static const Color blue700 = Color(0xFF1A63E6);
  static const Color blue500 = Color(0xFF1E6FFF); // BASE / focus ring
  static const Color blue550 = Color(0xFF2E6BE0); // Vision-on light
  static const Color blue450 = Color(0xFF2E7BFF);
  static const Color blue400 = Color(0xFF4C8DFF);
  static const Color blue300 = Color(0xFF5C9BFF);

  // ────────────────────────────────────────────────────────────────────────
  // WARM / SKEUO RAMP — warm luminance.
  // ────────────────────────────────────────────────────────────────────────
  static const Color warmInk900 = Color(0xFF2A2620);
  static const Color warmInk800 = Color(0xFF33301F);
  static const Color warmInk600 = Color(0xFF6B6151);
  static const Color warmInk500 = Color(0xFF8A8072);
  static const Color terracotta = Color(0xFFB24C34);
  static const Color cream700 = Color(0xFFDBC49E);
  static const Color cream600 = Color(0xFFE4CFAC);
  static const Color cream500 = Color(0xFFECE3D2);
  static const Color cream400 = Color(0xFFEFDFC5);
  static const Color cream300 = Color(0xFFF3ECDF);
  static const Color cream200 = Color(0xFFF7EEDC);
  static const Color cream100 = Color(0xFFFCFAF4);
  static const Color warmGround = Color(0xFF2A2622); // device body behind frame

  // ────────────────────────────────────────────────────────────────────────
  // ALPHA LADDER (0..1) — regularized from the source's ~30 scattered alphas.
  // ────────────────────────────────────────────────────────────────────────
  static const double a05 = 0.05;
  static const double a06 = 0.06;
  static const double a08 = 0.08;
  static const double a09 = 0.09;
  static const double a12 = 0.12;
  static const double a14 = 0.14;
  static const double a16 = 0.16;
  static const double a18 = 0.18;
  static const double a22 = 0.22;
  static const double a26 = 0.26;
  static const double a30 = 0.30;
  static const double a35 = 0.35;
  static const double a40 = 0.40;
  static const double a45 = 0.45;
  static const double a50 = 0.50;
  static const double a55 = 0.55;
  static const double a60 = 0.60;
  static const double a70 = 0.70;
  static const double a78 = 0.78;
  static const double a82 = 0.82;
  static const double a90 = 0.90;
  static const double a92 = 0.92;
  static const double a95 = 0.95;

  /// Thesis-critical glass legibility tint ladder (findings #2 / #4):
  /// plate .55 → container .60 → Vision-deepened .92. When the container
  /// deepens to [glassTintVision], backing plates collapse toward 0.
  static const double glassTintPlate = a55;
  static const double glassTintContainer = a60;
  static const double glassTintVision = a92;

  // ────────────────────────────────────────────────────────────────────────
  // SPACING — true 8pt ladder (half-step 4). Off-grid hi-fi tuning (14/9/13/18)
  // is NOT a primitive; resolved per Q7 at Phase 3.
  // ────────────────────────────────────────────────────────────────────────
  static const double sp1 = 4;
  static const double sp2 = 8;
  static const double sp3 = 12;
  static const double sp4 = 16;
  static const double sp5 = 20;
  static const double sp6 = 24;
  static const double sp8 = 32;

  // ────────────────────────────────────────────────────────────────────────
  // TYPE SCALE anchors (px) — Vision multiplies by 1.35 at the profile tier.
  // ────────────────────────────────────────────────────────────────────────
  static const double textCaption = 11;
  static const double textStatus = 12;
  static const double textLabel = 15;
  static const double textTitle = 20;
  static const double textPage = 28;
  static const double visionScale = 1.35;

  // Motor geometry anchors.
  static const double focusRingBase = 2.5;
  static const double focusRingBig = 4.0; // Motor/Vision
  static const double tileHeightBase = 116;
  static const double tileHeightMotor = 140;

  // ────────────────────────────────────────────────────────────────────────
  // GRADIENT PRIMITIVES (Flutter-native; carry skeuo dimensionality that inset
  // shadows can't).
  // ────────────────────────────────────────────────────────────────────────
  /// Skeuo raised card ground (WidgetCard / tile off-state).
  static const LinearGradient skeuoCardGround = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [cream100, cream300, cream500],
    stops: [0.0, 0.55, 1.0],
  );

  /// Skeuo enabled-tile ground (cool near-white).
  static const LinearGradient skeuoTileEnabled = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [coolTop, coolBot],
  );

  /// Skeuo on-state fill (base). Vision variant swaps to [blue550]→[blue900].
  static const LinearGradient skeuoOnFill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blue300, blue450, blue700],
    stops: [0.0, 0.5, 1.0],
  );

  /// Warm atmospheric wallpaper (Skeuo Home ground).
  static const RadialGradient warmWallpaper = RadialGradient(
    center: Alignment(0.0, -0.88),
    radius: 1.35,
    colors: [cream200, cream400, cream600, cream700],
    stops: [0.0, 0.46, 0.78, 1.0],
  );

  /// Glass wallpaper (T1) — a saturated, high-variance diagonal so a
  /// [BackdropFilter] blur reveals visibly different colour regions across the
  /// panel (warm-magenta → deep-blue → violet → deep-blue). Chrome; changes
  /// across paradigms.
  static const LinearGradient glassWallpaper = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFA8226E), Color(0xFF232C86), Color(0xFF6A2FA0), Color(0xFF17245C)],
    stops: [0.0, 0.38, 0.68, 1.0],
  );

  /// Minimal wallpaper (T1) — soft neutral off-white, near-flat, barely
  /// perceptible warmth.
  static const LinearGradient minimalWallpaper = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF6F5F1), Color(0xFFEDEBE4)],
  );

  // ────────────────────────────────────────────────────────────────────────
  // SHADOW PRIMITIVES — OUTER/drop only (Flutter BoxShadow has no inset).
  // ────────────────────────────────────────────────────────────────────────
  /// Skeuo dimensional lift (outer components of the source's layered shadow).
  static const List<BoxShadow> skeuoLift = [
    BoxShadow(color: Color(0x2E14161E), offset: Offset(0, 10), blurRadius: 20), // rgba(20,22,30,.18)
    BoxShadow(color: Color(0x1F14161E), offset: Offset(0, 2), blurRadius: 4),   // rgba(20,22,30,.12)
  ];

  /// Skeuo raised WidgetCard drop.
  static const List<BoxShadow> skeuoCardLift = [
    BoxShadow(color: Color(0x2E14161E), offset: Offset(0, 10), blurRadius: 22),
    BoxShadow(color: Color(0x1F14161E), offset: Offset(0, 1), blurRadius: 2),
  ];

  /// Glass drop.
  static const List<BoxShadow> glassDrop = [
    BoxShadow(color: Color(0x2E000000), offset: Offset(0, 8), blurRadius: 24), // rgba(0,0,0,.18–.28)
  ];

  /// AppIcon shadows (content-tokenized: only radius + this shadow vary).
  static const List<BoxShadow> appIconShadowSkeuo = [
    BoxShadow(color: Color(0x2614161E), offset: Offset(0, 2), blurRadius: 5), // rgba(20,22,30,.15)
  ];
  static const List<BoxShadow> appIconShadowGlass = [
    BoxShadow(color: Color(0x38000000), offset: Offset(0, 4), blurRadius: 12), // rgba(0,0,0,.22)
  ];
  static const List<BoxShadow> appIconShadowMinimal = <BoxShadow>[];
}

/// Spec for an inset (inner) shadow — Flutter can't express these with
/// [BoxShadow], so Phase-2 atoms paint them (CustomPainter / gradient overlay).
/// Held as data so the values still live in Tier 1, not in widget bodies.
class InsetSpec {
  final Offset offset;
  final double blur;
  final Color color;
  const InsetSpec({required this.offset, required this.blur, required this.color});

  /// Skeuo top highlight: inset 0 1px 0 rgba(255,255,255,.9).
  static const InsetSpec skeuoTopHighlight =
      InsetSpec(offset: Offset(0, 1), blur: 0, color: Color(0xE6FFFFFF));

  /// Skeuo inset groove (track): inset 0 2px 4px rgba(20,22,30,.28).
  static const InsetSpec skeuoGroove =
      InsetSpec(offset: Offset(0, 2), blur: 4, color: Color(0x4714161E));

  /// Skeuo bottom seat: inset 0 -2px 3px rgba(20,22,30,.05).
  static const InsetSpec skeuoBottomSeat =
      InsetSpec(offset: Offset(0, -2), blur: 3, color: Color(0x0D14161E));

  /// Skeuo pressed depression: inset 0 3px 8px rgba(20,22,30,.3) + 0 1px 2px .24.
  static const InsetSpec skeuoPressDeep =
      InsetSpec(offset: Offset(0, 3), blur: 8, color: Color(0x4D14161E));
  static const InsetSpec skeuoPressEdge =
      InsetSpec(offset: Offset(0, 1), blur: 2, color: Color(0x3D14161E));

  /// Skeuo on-state: inset 0 1px 0 rgba(255,255,255,.4) + 0 -3px 6px rgba(0,0,60,.24).
  static const InsetSpec skeuoOnHighlight =
      InsetSpec(offset: Offset(0, 1), blur: 0, color: Color(0x66FFFFFF));
  static const InsetSpec skeuoOnSeat =
      InsetSpec(offset: Offset(0, -3), blur: 6, color: Color(0x3D00003C));

  /// Skeuo slider-fill sheen: inset 0 2px 3px rgba(0,0,60,.38) + -1px 0 white .25.
  static const InsetSpec skeuoFillShade =
      InsetSpec(offset: Offset(0, 2), blur: 3, color: Color(0x6100003C));
  static const InsetSpec skeuoFillEdge =
      InsetSpec(offset: Offset(0, -1), blur: 0, color: Color(0x40FFFFFF));

  /// Skeuo card interior: inset 0 1px 0 white .95 + 0 -2px 3px rgba(120,104,78,.14).
  static const InsetSpec skeuoCardHighlight =
      InsetSpec(offset: Offset(0, 1), blur: 0, color: Color(0xF2FFFFFF));
  static const InsetSpec skeuoCardSeat =
      InsetSpec(offset: Offset(0, -2), blur: 3, color: Color(0x2478684E));

  /// Skeuo toggle-track groove: inset 0 2px 5px rgba(20,22,30,.28).
  static const InsetSpec skeuoToggleGroove =
      InsetSpec(offset: Offset(0, 2), blur: 5, color: Color(0x4714161E));
  static const InsetSpec skeuoToggleOnSeat =
      InsetSpec(offset: Offset(0, -2), blur: 4, color: Color(0x4200003C));
  static const InsetSpec skeuoToggleOnHighlight =
      InsetSpec(offset: Offset(0, 1), blur: 0, color: Color(0x61FFFFFF));

  /// Glass inner glows (omnidirectional — the reason R6 chose CustomPainter).
  /// tile on: inset 0 0 34px rgba(96,162,255,.55); vision-on: 0 0 42px rgba(130,185,255,.8);
  /// toggle on: 0 0 16px .55; chip selected: 0 0 14px .5.
  static const InsetSpec glassGlowTile =
      InsetSpec(offset: Offset.zero, blur: 34, color: Color(0x8C60A2FF));
  static const InsetSpec glassGlowTileVision =
      InsetSpec(offset: Offset.zero, blur: 42, color: Color(0xCC82B9FF));
  static const InsetSpec glassGlowToggle =
      InsetSpec(offset: Offset.zero, blur: 16, color: Color(0x8C60A2FF));
  static const InsetSpec glassGlowChip =
      InsetSpec(offset: Offset.zero, blur: 14, color: Color(0x8060A2FF));
}
