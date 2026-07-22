# Weft — Demo Guide (INS 202)

**Thesis:** accessibility profiles *stack on top of* aesthetic paradigms via one
token architecture — provable at the token layer, not by mode-switching.

## Install (device-first, USB or emulator)
1. On a physical Android phone: Settings → About → tap Build Number 7× to enable
   Developer Options, then enable **USB debugging**. (Or use an emulator, API 34.)
2. Plug in / boot the device; verify with `adb devices`.
3. Install:
   ```
   flutter install                      # or:
   adb install -r build/app/outputs/flutter-apk/app-release.apk
   ```
4. Launch **Weft** from the launcher/app list.

APK: `build/app/outputs/flutter-apk/app-release.apk` (release, debug-signed —
installs without a keystore). App label shows as **Weft**.

> First run opens on the **Skeuo** baseline. The last-applied paradigm + profiles
> + grid density persist across launches (`SharedPreferences`). To reset to the
> Skeuo baseline for a clean demo: `adb shell pm clear com.unilag.ins202.mobile_launcher`.

## ~3-minute demo — the moments that prove the thesis

**0:00 — Home (Skeuo baseline).** Warm gold wallpaper, dimensional widget cards,
**raised colored app-icon backings**, and a **live ticking clock**. Note the grid,
widgets, and dock.

**0:20 — Open the surfaces (gestures).** **Swipe down** from the top edge →
Control Center slides over Home. Tap a toggle. **Swipe up** (or tap the dim
backdrop) to dismiss. Tap the **Settings** app icon on Home (or the gear in
Control Center) → **Customization** slides in.

**0:40 — Moment #1: one system, three paradigms.** The three paradigm cards read
as distinct **material specimens** (each rendered in its own paradigm on a crop of
its own wallpaper). Tap **Glass** → the Customization surface itself previews
translucent glass (Home behind stays Skeuo — edits are staged). Tap **Apply** →
**Home crossfades to Glass**: the saturated wallpaper shows *through* the
translucent app-icon backings and widget cards. Tap **Minimal** + Apply → flat.
*Same widget code — only the paradigm→token binding changed. The app-icon GLYPHS
never change (content); their BACKINGS do (chrome).*

**1:20 — Moment #2: profiles compose over any paradigm.** Re-enter Customization.
Turn on **Vision** → text scales, contrast rises. With **Glass** active, watch the
**cascade**: container tint deepens, section-header plate + tile label-chips *drop
out* (the container took over legibility) — one rule fired at the intersection,
not a per-widget hack. Turn on **Motor** → touch targets grow.

**1:50 — Moment #3: Cognitive at surface scale.** Toggle **Cognitive** → Apply.
Home **visibly desaturates** across icon backings, widget cards, and wallpaper —
the whole screen calms. (No "look closely" needed.)

**2:15 — Moment #4: layout axes.** In the **Layout** section, pick **Compact** /
**Spacious** → Apply → the home grid re-densifies (composes with Motor's
tap-target bump). Toggle **One-Handed** → Apply → Home content **clusters into the
lower zone**, upper region left as wallpaper, dock unchanged.

**2:45 — Moment #5: content stable, chrome adapts.** Across every swap the **app
icons stay branded** (Photos stays the flower, Safari the compass) while wallpaper,
widgets, dock, radius, shadow, and icon *backing material* all adapt. Content vs
chrome, by design.

**Done.** Every visual difference above came from the four-tier token system
(`lib/tokens/`) — paradigm factories × profile deltas composed in `compose.dart`,
never from swapping widgets.

## If Glass looks watery on the device
Emulators can flatter blur. The fix lives in one place: the glass tint/blur
primitives in `lib/tokens/primitives.dart` + `lib/tokens/paradigms/glass.dart`
(deepen `glassTintContainer`, raise `blurBase`) and the icon-backing tint/blur in
`GlassBindings.appIconBacking`. No widget changes.

## Verify (developer)
- `flutter test` → **64 tests** (token invariants incl. Phase-8 backing/cognitive/
  density, atom matrix, per-surface goldens incl. cognitive + one-handed Home,
  navigation loop with staged Apply).
- Golden images under `test/goldens/` are the visual regression record.
