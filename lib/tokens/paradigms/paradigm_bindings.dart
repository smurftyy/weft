import 'package:flutter/painting.dart';
import '../token_types.dart';

/// TIER 3 — PARADIGM BINDINGS (base, profile-free).
///
/// Each paradigm maps semantic roles → Tier-1 primitives. These return the
/// BASE (no-profile) values; orthogonal profile scalars and intersection
/// overrides are folded on top in compose.dart. A paradigm swap changes only
/// which [ParadigmBindings] is active — zero widget changes (§7 moment 1).
///
/// Scope note: Phase 1 seeds the roles needed for a visibly-differing stub
/// (container, tile, section-header, app-icon, base type sizes). Phase 2 grows
/// this interface per-atom; growth is mechanical because atoms read only the
/// semantic tier, never this.
abstract class ParadigmBindings {
  Paradigm get id;

  // ── Control-center container (chrome) ──
  SurfaceStyle container();

  // ── Tile ──
  double get tileRadius;
  SurfaceStyle tileGround(WState s);
  Color tileInk(WState s); // icon + label ink
  Color tileStatus(WState s);
  Color? tileLabelChip(WState s); // opaque backing chip; null when paradigm has none

  // ── Section header ──
  SurfaceStyle sectionPlate(); // SurfaceStyle.none when the paradigm has no plate
  Color sectionTitleColor();
  Color sectionCaptionColor();

  // ── App icon ──
  // GLYPH stays content (brand identity constant); only radius + shadow +
  // BACKING are paradigm-tokenized (§3.4 / T2 content-vs-chrome fix). The
  // backing is derived from the icon's content colour so each paradigm renders
  // its own material (raised / translucent / flat) around the same glyph.
  double get appIconRadius;
  List<BoxShadow> get appIconShadow;
  SurfaceStyle appIconBacking(Color content);
  // App-icon LABEL is chrome (text over the wallpaper) — must stay legible on
  // each paradigm's ground. Discovered tokens (Q2); source only tuned Skeuo.
  Color get appIconLabelColor;
  Shadow? get appIconLabelShadow;

  // ── Home wallpaper (chrome — changes across paradigms; §3.4) ──
  Gradient get homeWallpaper;

  // ── Base type sizes (px); Vision multiplies these at the profile tier ──
  double get titleSize;
  double get captionSize;

  // ── Slider ──
  SurfaceStyle sliderTrack(WState s);
  SurfaceStyle sliderFill(WState s);
  SurfaceStyle sliderThumb(WState s);

  // ── Toggle (standard WState axis: enabled=off, selected=on) ──
  SurfaceStyle toggleTrack(WState s);
  SurfaceStyle toggleThumb(WState s);

  // ── Chip (profile-agnostic per Q4; states via WState) ──
  double get chipRadius;
  bool get chipUppercase; // minimal's caption treatment
  SurfaceStyle chipGround(WState s);
  Color chipText(WState s);

  // ── WidgetCard (chrome; dock is a radius/padding variant) ──
  SurfaceStyle cardGround();
  Color cardTitleColor();

  // ── PreviewCard panel (Customization specimen ground) ──
  SurfaceStyle previewPanel();
  Color previewCaption();
  Color previewHairline();
}
