# Composable Launcher — Demo Guide (INS 202)

**Thesis:** accessibility profiles *stack on top of* aesthetic paradigms via one
token architecture — provable at the token layer, not by mode-switching.

## Install (device-first, USB)
1. On the Android phone: Settings → About → tap Build Number 7× to enable
   Developer Options, then enable **USB debugging**.
2. Plug the phone into this machine.
3. Verify it's seen: `adb devices` (should list the device).
4. Install:
   ```
   flutter install                      # or:
   adb install -r build/app/outputs/flutter-apk/app-release.apk
   ```
5. Launch **Composable Launcher** from the app drawer.

APK path: `build/app/outputs/flutter-apk/app-release.apk` (release, debug-signed
— installs without a keystore).

## 3-minute demo — the four moments that prove the thesis

**0:00 — Home (Skeuo).** Warm, dimensional. Note the app grid, widgets, dock.

**0:20 — Moment #1: one widget, three paradigms.**
Swipe **down** from the top → Control Center. Then tap the **Settings** icon on
Home → Customization. Tap **Glass** → the entire UI re-skins to translucent.
Tap **Minimal** → flat. *Same widget code — only the paradigm→token binding
changed.* Re-open Control Center after each to show it too.

**1:00 — Moment #2: profiles compose over any paradigm.**
In Customization, turn on **Vision** → text scales up, contrast rises, everywhere.
Switch paradigm to **Glass** with Vision still on → watch the **cascade**: the
container tint deepens, the section-header plate and tile label-chips *drop out*
(the container has taken over legibility). One rule, fired at the intersection —
not a per-widget hack. Turn on **Motor** → touch targets grow.

**1:50 — Moment #3: three axes at once.**
On **Skeuo**, enable **Vision** and **One-Handed**. The live **Preview** shows
all three composing: dimensional (Skeuo) × enlarged (Vision) × clustered into the
thumb-zone with the "reachable" marker (One-Handed).

**2:30 — Moment #4: content stable, chrome adapts.**
Tap **Apply** → Home. Swap paradigm again and watch: the **app icons never
change** (Instagram-blue stays Instagram-blue) while wallpaper, widgets, dock,
corner radius and shadows all adapt. Content vs chrome, by design.

**Done.** Every visual difference above came from the three-tier token system
(`lib/tokens/`), never from swapping widgets.

## If Glass looks watery on the device
Emulators/renders can flatter blur. If the glass paradigm reads thin on real
hardware, the fix lives in one place: the glass tint/blur primitives in
`lib/tokens/primitives.dart` + `lib/tokens/paradigms/glass.dart`. Deepen
`glassTintContainer` / raise `blurBase`. No widget changes.

## Verify (developer)
- `flutter test` → 48 tests (token invariants, atom matrix, per-surface goldens,
  navigation loop).
- Golden images under `test/goldens/` are the visual regression record.
