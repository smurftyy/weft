# PLAN.md — Mobile OS Launcher (INS 202 HCI)

**Status:** Phase 3 (Control Center) — **COMPLETE ✅ (2026-07-21)**, awaiting review before Phase 4. Assembled Control Center works across all 3 paradigms (swap-only, zero widget changes) + Motor/Vision overlays; stateful toggles; 38/38 tests pass.

### Phase 3 checkpoint log — COMPLETE (2026-07-21)
**Shipped:** `lib/surfaces/control_center.dart` — status bar, page header, Connectivity 2×2 (Wi-Fi/Bluetooth/Airplane/Cellular), Brightness+Volume sliders with icon endcaps, Quick-Actions 2×2 (Voice/Flashlight/DND/Rotation), "More" card (Location/Battery Saver/Focus Mode toggles + Accessibility-Shortcut deep-link row). Built from Phase-2 atoms; every visual from the semantic tier.
- **Stateful & session-persistent:** tile + toggle on/off live in `AppConfig.toggles` (in-memory, MVP). Tapping a tile flips selected↔enabled; interaction lives in the surface, atoms stay presentational.
- **Deep-link:** Accessibility-Shortcut row fires `onAccessibilityShortcut` (placeholder SnackBar in harness; wired to Customization in Phase 6, target built Phase 4).
- **Swap-only proven:** Glass + Minimal come purely from paradigm swap — no inline overrides. `test/control_center_golden_test.dart` = 7 cases (3 paradigms + Motor/Vision on Skeuo & Glass). Full suite **38/38**, analyze clean.
- Added `TileIcon.voice` (mic) for Voice Control.

**Device-blur note (Q6):** on-device Glass-blur validation still pending — the phone isn't attached to *this* build machine, so verification remains golden-based (real `BackdropFilter`, but goldens can flatter blur). Will run `flutter run` for a live blur check whenever the phone is plugged into this box.

**Next:** Phase 4 — Customization surface (paradigm picker specimens, 4 profile toggles incl. Cognitive/One-Handed preview-only, live `PreviewCard` with 3-axis composition, Apply CTA). **Awaiting approval.**

### Phase 2 checkpoint log — COMPLETE (2026-07-20)
**Shipped:**
- Token tiers extended: `SurfaceStyle.insets`, full inset-shadow vocabulary in `primitives.dart`, slider/toggle/chip/card/preview roles across all 3 paradigm bindings, compose geometry + glass-hardening.
- **R6 resolved** — `lib/atoms/surface_box.dart`: `InsetShadowPainter` (clip-to-rrect + blurred difference-path) handles directional highlights/grooves AND the omnidirectional glass on-state glow. Values stay in Tier 1 as `InsetSpec`; painting in one shared widget. Goldens confirm Skeuo reads dimensional and Glass on-states glow.
- 8 atoms in `lib/atoms/`: `AtomTile`, `AppSlider`, `AppToggle`, `AppChip`, `SectionHeader`, `WidgetCard`, `AppIcon`, `PreviewCard` — each reads only `context.sem`, no literals.
- `lib/dev/atom_gallery.dart` — all atoms on one surface; harness now shows it.
- Tests: `test/atom_gallery_golden_test.dart` (9-cell matrix). Full suite **31/31**.

**Signature rule honored:** `AtomTile/Slider/Chip` resolvers are `(WState)`; `Toggle` uses the on/off second axis mapped onto WState in the semantic tier — the only genuine extra axis so far.

**Discovered tokens (Q2 rule — logged, added at semantic layer, not inline):**
1. `card.titleColor` for **glass** — source `WidgetCard` title was skeuo-tuned (`#8A7C64`) only; glass needs a light title on its dark translucent ground. Added `Prims.white@.85` in `GlassBindings.cardTitleColor()`.
2. **Vision tile-height step** — source only grew tile height for Motor; Vision's ×1.35 type needs vertical room, so `Compose.tileHeight` now returns 132 under Vision (140 Motor still dominates). Legitimate a11y behavior; flagged for your review.

**Known simplification (R7):** Material glyphs lack stroke control, so Vision's "icon stroke +50%" is not literally rendered (icon size/contrast carry emphasis instead). Real SVG icons could restore it later; out of MVP scope unless you want it.

**Next:** Phase 3 — assemble the real Control Center (Skeuo first, then Glass/Minimal by swap only; Motor/Vision overlays; stateful toggles; a11y-shortcut deep-link). **Awaiting approval.**

### Phase 1 checkpoint log — Tier 1 (2026-07-20)
**Shipped:**
- Flutter **3.44.6 stable** (Dart 3.12.2) installed at `~/development/flutter`.
- Project scaffolded: package `mobile_launcher`, org `com.unilag.ins202`, `--platforms=android` (no emulator, device-first).
- `lib/tokens/primitives.dart` — full scaled Tier 1 (radius/blur/ink/blue/warm/alpha/spacing ladders + gradient & drop-shadow primitives + `InsetSpec` for R6).
- `lib/dev/tier1_stub.dart` + `test/tier1_test.dart` — **5/5 tests pass**, `flutter analyze` clean. Tests assert the *scales* (radius/blur strictly increasing, glass tint `plate<container<vision`, 8pt spacing).

**Changed from plan:** device-first (no emulator/system-image); R3 retired; R6 (inset-shadow gap) added.
**Next (rest of Phase 1):** Tier 2 semantic (`AppSemantics` ThemeExtension), Tier 3 paradigm factories, Tier 4 profile deltas, `compose.dart` (incl. Glass×Vision cascade), `dev/token_harness` live-swap screen. Android SDK finishing in background (for on-device runs, not needed for token work).

### Phase 1 checkpoint log — COMPLETE (2026-07-20)
**Shipped (full four-tier system + harness):**
- Tier 2 `lib/tokens/semantic.dart` — `AppSemantics` ThemeExtension + resolver groups (`tile`, `container`, `sectionHeader`, `text`, `state`, `system`). Atoms call e.g. `context.sem.tile.ground(WState.selected)` (state-resolver in tokens, per approved Option A).
- Tier 3 `lib/tokens/paradigms/{paradigm_bindings,skeuo,glass,minimal}.dart` — base bindings; swap changes only which binding is active.
- Tier 4 `lib/tokens/profiles/{motor,vision,cognitive,one_handed}.dart` — Motor/Vision real; Cognitive/One-Handed surface no-ops (Q3), preview-scoped.
- `lib/tokens/compose.dart` — the fold + **one** `backingDropped()` predicate driving the generalized Glass×Vision cascade (plate-drop, labelChip-drop, container-deepen, tile-rebind all consult it).
- `lib/theme/app_config.dart` — `AppConfig` + `AppConfigController` (ValueNotifier) + `ThemeScope` (InheritedNotifier) + `LauncherTheme` + `context.sem`.
- `lib/dev/{token_stub_surface,token_harness}.dart` + `lib/main.dart` — live paradigm SegmentedButton + profile FilterChips; stub repaints on change.

**Verification:** `flutter analyze` clean · **22/22 tests pass** (5 Tier-1 + 11 differential compose + 6 golden). Golden PNGs (`test/goldens/`) visually confirm: 3 distinct paradigms; Glass×Vision cascade (plate gone, tiles rebind to opaque light, container deepens, chip dropped); Motor taller tiles; three-axis Skeuo×Vision×One-Handed.

**Signature rule honored:** resolvers are `(WState)`; no extra axes added (slider value / toggle on-off will extend to `(WState, X)` in Phase 2 only where genuinely needed).

**Env note:** Flutter 3.44 needs Android **platform-36** (installing in background) for device/APK builds; host tests unaffected. Phone not yet attached to this machine — on-device run is a Phase-7/when-plugged concern.

**R6 status:** deferred to Phase 2 as agreed — skeuo dimensionality currently via gradients + drop shadows (goldens look dimensional); inset highlight/groove painting (CustomPainter vs overlay) decided when the real Skeuo tile atom is built.

**Next:** Phase 2 — port the 8 atoms to real widgets reading only the semantic tier. **Awaiting approval.**
**Thesis:** Composable unification — accessibility profiles *stack on top of* aesthetic paradigms via one token architecture. Provable at the token layer.
**Target:** Flutter → Android APK. Demoable in <3 min proving the four §7 moments.
**Last updated:** 2026-07-19 (Phase 1 start).

### Decisions locked (Phase 0 review)
- Architecture: four-tier decomposition ✅ · State: `ValueNotifier`+`InheritedNotifier` ✅ · `theme_tailor`: skip ✅
- Q4 chips: profile-agnostic prop system (semantic tokens carry Vision contrast; Motor N/A). Future interactive chip → `ChipVariant.interactive`, no retrofit.
- Q5 Customization entry: tap **Settings app icon** on Home (no long-press).
- Q6 Demo: **DEVICE-FIRST (revised).** Physical Android phone via USB from Phase 1 onward — **no emulator, no system image**. Install = Flutter SDK + Android cmdline-tools + platform API 34 + build-tools + platform-tools/adb only (~3 GB). Every visual runs on real hardware → **R3 (Glass-blur validation) retired**, folded into ongoing dev.
- Q7 spacing snap-vs-preserve: **decide at Phase 3** in surface context (non-blocking).
- Dir renamed `moimoi-launcher` → `mobile-launcher`.
- Spec `control-center-design-spec.md` still not received → proceeding provisional Tier-2 names per 1-hour rule.

> ⚠️ **Open dependency:** `control-center-design-spec.md` (canonical for the semantic tier + paradigm bindings) has **not** been received — it is not in the Claude Design project and not on local disk. The token architecture below is **reverse-engineered from the atom source** and is authoritative for *primitives* (my job per Q1) but **provisional for the semantic-tier naming**, which I will reconcile against the spec on arrival. See Risk R2.

---

## 1. Environment verification

| Item | Finding | Action |
|---|---|---|
| Flutter SDK | **Not installed.** Latest stable = **3.44.0** (notes updated 2026-07-10, stable channel). | Install stable 3.44.x in Phase 1 (parallel with token work). |
| Dart SDK | Not installed (bundles with Flutter 3.44 → Dart 3.9.x). | Comes with Flutter install. |
| `ThemeExtension` API | Stable since Flutter 3.0, current in 3.44. Nested typed token trees fully supported. No breaking changes affecting our use. | Use as the spine (per §3.2). **Not** `ColorScheme`. |
| `theme_tailor` | v**3.1.3**, ~4mo old, 225 likes, ThemeExtension codegen (copyWith/lerp/==/hashCode). Healthy. | **Recommend NOT adopting initially** — see §2.5. |
| Android toolchain | `ANDROID_HOME=~/Android/Sdk` set but **directory does not exist**. `adb` absent. | Install Android SDK + platform-tools + accept licenses in Phase 7 (or early). |
| Java | OpenJDK **21.0.11** present. | Fine for AGP/Gradle; verify Gradle/AGP compatibility at project create. |
| minSdk / targetSdk | Proposed **minSdk 24, targetSdk 35** (Flutter 3.44 defaults). | Confirm at `flutter create`. |
| Likely deprecations | `withOpacity` → `withValues` migration in recent Flutter; watch surface-blur APIs. | Use `withValues` from the start. |

**Biggest environment fact:** the machine has *no* Flutter and *no* Android SDK. This is the #1 timeline risk (R1) — installation + first Gradle build is a real cost independent of our code.

---

## 2. Architecture proposal

### 2.1 The four tiers → Dart types

The design source **inlines everything** — each atom hardcodes paradigm maps *and* profile deltas as fused primitive strings (e.g. `WidgetCard`'s skeuo ground is one baked gradient+shadow). Faithful translation means **un-fusing** these into four clean tiers. Widgets will read **only** the semantic tier (§3.1).

```
Tier 1  primitives   → raw const values (colors, radii, blurs, opacities, shadows, spacings)
Tier 2  semantic     → typed role tree (surface.*, component.*, text.*, state.*, system.*)
Tier 3  paradigm     → factory that builds the Tier-2 tree from Tier-1 (skeuo|glass|minimal)
Tier 4  profile      → pure delta fns overriding Tier-2 roles, composed in stable order
```

| Tier | Dart representation | Rationale |
|---|---|---|
| 1 Primitives | `abstract final class Prims` of `static const` (Color, double, `List<BoxShadow>`, `Gradient`). **Never** in the widget tree; only binding factories touch it. | Enforces §3.1 "widgets never read primitives." |
| 2 Semantic | One `AppSemantics extends ThemeExtension<AppSemantics>` composed of nested typed groups (`SurfaceTokens`, `TileTokens`, `SliderTokens`, `ToggleTokens`, `TextTokens`, `StateTokens`, `SystemTokens`, `ChipTokens`, `SectionHeaderTokens`). Widgets read `context.sem.tile.groundEnabled`. | `ThemeExtension` gives the nested typed tree `ColorScheme` can't. Matches §3.2. |
| 3 Paradigm | `AppSemantics.skeuo()`, `.glass()`, `.minimal()` factory constructors that assemble Tier-2 from `Prims`. | A paradigm swap = choosing a factory. Zero widget changes (§7 moment 1). |
| 4 Profile | `AppSemantics applyMotor(AppSemantics s, Paradigm p)`, `applyVision(...)`, etc. Each returns a `copyWith`-ed tree; may read `p` to fire intersection overrides. | Profiles compose over paradigm (build-order inversion §3.5). |

Because states (enabled/pressed/focus/selected/disabled) are **per-atom** and numerous, each atom's `*Tokens` group carries the *inputs* it needs (grounds per state, on-fill, ink colors, ring spec) rather than a fully-resolved style — the atom still selects by state, but every value it selects from comes from the semantic tier. No hardcoded color/radius/opacity in any atom body (§Phase 2 rule).

### 2.2 Composition & intersection-override resolution (§3.3)

```
final base    = paradigmFactory(paradigm);              // Tier 3
final themed  = activeProfiles                          // stable order: Motor → Vision → Cognitive → OneHanded
                  .fold(base, (s, prof) => prof.apply(s, paradigm));
```

- **Order is fixed and documented:** Motor, Vision, Cognitive, One-Handed. (Motor = geometry; Vision = contrast/scale; later profiles never undo earlier.)
- **Intersection overrides live in the profile delta, conditioned on paradigm** — not in the widget. Concrete, from source:
  - `applyVision`: when `p == glass`, deepen `surface.controlCenter.container` tint ~60%→~92%, set `surface.sectionHeader.plate` opacity → 0, set `component.tile.labelChip` → transparent. (Findings #2, #4.)
  - **Generalized rule (finding #4):** *any opaque-backing element in the Glass paradigm reduces to ~0 under Vision, because the container has taken over the legibility job.* Implemented once in `applyVision`, iterating the known backing roles — not per widget.
- All of this is centralized in `tokens/compose.dart` so the cascade is auditable in one place.

### 2.3 State propagation — **recommend zero-dependency `ValueNotifier` + `InheritedNotifier`**

The app state is tiny and global: `{ Paradigm paradigm; Set<Profile> profiles; Map<String,bool> toggles }`. Options weighed:

| Option | Verdict |
|---|---|
| **`ValueNotifier<AppConfig>` + `InheritedNotifier`** (zero deps) | **Recommended.** No magic, no package risk on a 48h clock, and it keeps the story "the thesis is in the tokens, not the state library." Root rebuilds `Theme` from composed `AppSemantics` on change. |
| `provider` (ChangeNotifier) | Fine, familiar, but a dependency for something a 30-line InheritedNotifier does. |
| Riverpod | Overkill here; great for async/large graphs we don't have. |

I'm **not** uncertain on this — recommending zero-dep unless you prefer `provider` for team familiarity (Q2).

### 2.4 Directory structure

```
lib/
  main.dart
  theme/
    app_config.dart      # Paradigm enum, Profile enum, AppConfig (ValueNotifier), ThemeScope (InheritedNotifier)
  tokens/
    primitives.dart      # Tier 1
    semantic.dart        # Tier 2: AppSemantics ThemeExtension + *Tokens groups + context.sem getter
    paradigms/{skeuo,glass,minimal}.dart   # Tier 3 factories
    profiles/{motor,vision,cognitive,one_handed}.dart  # Tier 4 deltas
    compose.dart         # paradigm × profiles → AppSemantics; intersection cascade
  atoms/{atom_tile,app_slider,app_toggle,chip,section_header,preview_card,app_icon,widget_card}.dart
  surfaces/{control_center,customization,home}.dart
  dev/token_harness.dart # Phase 1 dev screen: paradigm picker + profile checkboxes
design-source/           # read-only mirror of the Claude Design .dc.html artifacts
```

### 2.5 `theme_tailor` recommendation: **skip for now**

Its value is generated `copyWith`/`lerp`/`==`. We need `copyWith` (hand-writable) but **not** `lerp` — paradigm swaps are instant, not animated (an animated 60%→92% tint cross-fade is a nice-to-have, not MVP). Adding `build_runner` codegen risks fragility against the exact four-tier composition we control by hand. Keep it as a Phase-2 escape hatch if `copyWith` boilerplate becomes painful.

---

## 3. Reverse-engineered token seed (primitives — my Q1 deliverable, provisional names)

Extracted from the 8 atoms + Home surface. Presented as **scaled ladders**, not a flat dictionary. Four axes are clean scales; opacity + spacing are the regularization work Q1 asked for.

- **Radius scale** (2px step in interactive band, +4 for containers): `xs8 · sm10 · md12 · lg16 · xl18 · 2xl20 · 3xl22 · 4xl24 · 5xl26 │ 6xl30 · 7xl34 │ frame44`. AppIcon: minimal16·skeuo22·glass24. Tile: minimal8·skeuo20·glass22 (finding #3: 16→22 glass-only).
- **Blur scale** (anchor 24; Vision collapses to floor): `none0 · reduced6 · sm16 · md18–20 · base24 · pressed34 · container40`.
- **Ink ramp** (10-step luminance): `900 #17181C · 800 #1D1E24 · 700 #2A2C33 · 600 #4A4D57 · 550 #5A5D67 · 500 #6B6E78 · 400 #8A8D96 · 300 #B7BAC2 · 200 #DBDDE4 · 100 #E9EAEE`.
- **Brand-blue ramp** (8-step lightness): `b900 #0B49C0 · #1550C0 · #1A63E6 · b500 #1E6FFF · #2E6BE0 · #2E7BFF · #4C8DFF · b300 #5C9BFF`. Skeuo-on gradient `[#5C9BFF,#2E7BFF@50%,#1A63E6]`; Vision-on `[#2E6BE0,#0B49C0]`.
- **Warm/skeuo ramp:** `#2A2620 · #33301F · terracotta #B24C34 · cream #DBC49E · #E4CFAC · #ECE3D2 · #EFDFC5 · #F3ECDF · #F7EEDC · #FCFAF4`.
- **Opacity — regularize into named alpha ladder.** Thesis-critical scale IS clean: glass legibility tint `plate .55 → container .60 → Vision-deepened .92` (container takes over → backing plates → 0). Fill `.09→.16→.18`; rim `.16→.26→.30→.45→.50→.60`. Snap to a named ladder in `primitives.dart`.
- **Spacing — 8pt ladder** `4·8·12·16·20·24·32`. Hi-fi has off-grid hand-tuning (`14·9·13·18`) → **open Q7: snap-all vs preserve as component exceptions** (non-blocking).
- **Shadows (named primitives):** `skeuoLift`, `skeuoInsetGroove`, `glassDrop`, `appIconShadow{skeuo|glass|minimal}`.
- **Focus ring** (formula): `white Npx + brand#1E6FFF (N+2.5)px`; N = 2.5 base → **4 under Motor/Vision**.
- **Profile scalars:** Vision `textScale 1.35`, `iconStroke ×1.5`, `blurReduce`, `tintDeepen`; Motor `tileH 116→140`, `thumb ≥32`, `track ≥12`, toggle `60→76`.

**Five design-phase findings are encoded as inputs (not rediscovered):** (1) skeuo on-state dimensional fills; (2) glass container 60% tint + 40px blur + 15% rim, plate 55%→30%; (3) Tile radius 16→22 glass-only; (4) Glass×Vision cascade (tint→92%, plate→0, labelChip→transparent) as a generalized intersection rule; (5) One-Handed = lower-thumb-zone layout delta, preview-only.

---

## 4. Phased build order & estimates

| Phase | Scope | Est (focused hrs) |
|---|---|---|
| **0** Research & Plan | this doc | ~done |
| **1** Token scaffold | project + install Flutter/Android; Tiers 1–4; compose.dart; `dev/token_harness` live swap | 4–6 |
| **2** Atom layer | port 8 atoms, semantic-only reads; sanity across 3 paradigms × Motor/Vision | 6–8 |
| **3** Control Center | Skeuo → Glass/Minimal by swap only; Motor/Vision overlays; stateful toggles; a11y-shortcut deep-link | 4–6 |
| **4** Customization | paradigm picker (3 material specimens), 4 profile toggles, live `PreviewCard` (3-axis), Apply CTA | 3–4 |
| **5** Home | 4×5 grid, Clock/Weather widgets, dock (WidgetCard pill), page indicator; swap to Glass/Minimal (icons stable) | 3–4 |
| **6** Navigation | Home base; swipe-down→Control Center; entry→Customization; state persists | 2–3 |
| **7** APK & polish | Android SDK install/licenses, release build, emulator/device test, package | 4–6 |
| | **Total** | **~26–37h** (fits 24–48h calendar if focused; hi-fi HTML is the fallback demo path) |

Each phase ends at a checkpoint; I stop for approval and update this file (what shipped / changed / next).

---

## 5. Questions for the user (before Phase 1)

1. **Canonical spec (blocking the semantic tier):** please drop `control-center-design-spec.md` into the Claude Design project (I'll pull it) or `~/mobile-launcher/` / paste. Until then Tier-2 naming is provisional (R2).
2. **State approach:** OK with zero-dep `ValueNotifier`+`InheritedNotifier` (my rec), or do you want `provider` for team familiarity?
3. **`theme_tailor`:** confirm skip-for-now (hand-written tiers), revisit only if boilerplate bites.
4. **Chip profile-awareness:** in source, `Chip` has **no** `profile` prop (fixed 2.5px ring, no Motor/Vision scaling), unlike Tile/Slider/Toggle. Keep chips profile-agnostic, or should they inherit the Motor/Vision ring-width + text scale for consistency?
5. **Navigation gestures (§6):** confirm swipe-down-from-top → Control Center, and Customization entry = tapping the **Settings** app icon on Home (it exists in the grid) vs a long-press. Which?
6. **Demo target:** emulator only, or do you have a physical Android device to sideload onto (affects Phase 7 packaging + on-device polish)?

---

## 6. Risk register

| # | Risk | Impact | Mitigation |
|---|---|---|---|
| **R1** | Flutter + Android SDK **not installed**; first Gradle build unproven on this box. | Could eat hours; blocks APK. | Install in Phase 1 *before* it's on the critical path; keep hi-fi HTML as fallback demo (§handoff). |
| **R2** | Canonical `control-center-design-spec.md` not yet received. | Semantic-tier naming may need rework. | Derive from atoms now (done); reconcile on arrival; provisional names isolated to `semantic.dart`. |
| **R3** | Flutter `BackdropFilter` blur ≠ CSS `backdrop-filter`; perf-heavy, esp. stacked. | Glass fidelity/jank. | Prototype glass tile early (Phase 2). Note: Vision **reduces** blur (a11y fallback = perf fallback, §3.5) — the escape hatch is already in the design. |
| **R4** | Intersection-override logic sprawls into widgets. | Kills the thesis (§3.3). | One `compose.dart`, one generalized Glass×Vision rule, zero per-widget overrides. Reviewed at Phase 2/3 checkpoints. |
| **R5** | 26–37h work in a 24–48h window is tight. | Slip. | Strict MVP order (Skeuo-first each surface); paradigm/profile added by swap not re-author; hi-fi fallback. |
| **R6** | ~~Flutter `BoxShadow` has no inset support; Skeuo's dimensionality relies on CSS `inset`.~~ | ~~Skeuo could read flat.~~ | **RESOLVED (Phase 2):** `InsetShadowPainter` (clip + blurred difference-path) renders directional + omnidirectional insets from Tier-1 `InsetSpec`. Goldens confirm dimensional Skeuo + glass glow. |
| **R7** | Material glyphs lack stroke control → Vision "icon stroke +50%" not literally rendered. | Minor Vision-icon fidelity gap. | Size/contrast carry emphasis in MVP; swap to SVG icon set later if desired. Low impact. |

---

## 7. What ships to prove the thesis (§7 acceptance)

1. Same widget → 3 paradigms (Control Center live swap).
2. Profiles compose over any paradigm (Motor/Skeuo, Vision/Glass).
3. Multiple profiles on one paradigm (Skeuo × Vision × One-Handed in Customization preview).
4. Home content (app icons) stable across swaps while chrome adapts.

---

*Awaiting approval to start Phase 1. No code until then.*
