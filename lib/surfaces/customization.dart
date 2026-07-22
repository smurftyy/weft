import 'package:flutter/material.dart';
import '../theme/app_config.dart';
import '../theme/paradigm_scope.dart';
import '../tokens/semantic.dart';
import '../atoms/surface_box.dart';
import '../atoms/app_toggle.dart';
import '../atoms/section_header.dart';
import '../atoms/preview_card.dart';

/// Customization — the thesis-carrying surface. It edits a local DRAFT [AppConfig]
/// (T6): picking a paradigm / toggling a profile mutates the draft and this
/// surface previews it live, but Home + Control Center behind stay on the
/// committed config until **Apply** commits the draft (and persists it). A back
/// gesture discards the draft (revert). The picker cards each render in their OWN
/// paradigm via [ParadigmScope]; the live [PreviewCard] shows the composed draft
/// paradigm × profiles, demonstrating 3-axis stacking (e.g. Skeuo × Vision ×
/// One-Handed).
class Customization extends StatefulWidget {
  /// The committed config the draft is seeded from when this surface opens.
  final AppConfig initialConfig;

  /// Commits the edited draft (parent persists it + returns to Home).
  final ValueChanged<AppConfig> onApply;

  const Customization({super.key, required this.initialConfig, required this.onApply});

  @override
  State<Customization> createState() => _CustomizationState();
}

class _CustomizationState extends State<Customization> {
  late AppConfig _draft = widget.initialConfig;

  static const _paradigms = <(Paradigm, String, String)>[
    (Paradigm.skeuo, 'Skeuo', 'Dimensional'),
    (Paradigm.glass, 'Glass', 'Translucent'),
    (Paradigm.minimal, 'Minimal', 'Flat'),
  ];
  static const _profiles = <(Profile, String, String)>[
    (Profile.motor, 'Motor', 'Larger targets, less motion'),
    (Profile.vision, 'Vision', 'Higher contrast, larger text'),
    (Profile.cognitive, 'Cognitive', 'Simplified, desaturated chrome'),
    (Profile.oneHanded, 'One-Handed', 'Content clusters to thumb zone'),
  ];

  void _setParadigm(Paradigm p) => setState(() => _draft = _draft.copyWith(paradigm: p));

  void _setProfile(Profile p, bool on) {
    final next = Set<Profile>.of(_draft.profiles);
    on ? next.add(p) : next.remove(p);
    setState(() => _draft = _draft.copyWith(profiles: next));
  }

  @override
  Widget build(BuildContext context) {
    // Inject DRAFT semantics for this subtree so the surface previews the draft
    // independently of the committed (Home-behind) theme.
    final draftSem = AppSemantics(paradigm: _draft.paradigm, profiles: _draft.profiles);
    return Theme(
      data: Theme.of(context).copyWith(extensions: <ThemeExtension>[draftSem]),
      child: Builder(builder: _buildContent),
    );
  }

  Widget _buildContent(BuildContext context) {
    final sem = context.sem; // draft-composed
    final ink = sem.sectionHeader.titleColor;
    final cap = sem.sectionHeader.captionColor;

    return Stack(
      children: [
        Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: sem.system.wallpaper))),
        Positioned.fill(
          child: SurfaceBox(
            style: sem.container.style,
            radius: 0,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionHeader(title: 'Customize', caption: 'Aesthetic + accessibility, composed', page: true),
                    const SizedBox(height: 18),
                    Text('AESTHETIC', style: _eyebrow(cap)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (var i = 0; i < _paradigms.length; i++) ...[
                          if (i > 0) const SizedBox(width: 10),
                          Expanded(
                            child: _ParadigmCard(
                              paradigm: _paradigms[i].$1,
                              name: _paradigms[i].$2,
                              subtitle: _paradigms[i].$3,
                              selected: _draft.paradigm == _paradigms[i].$1,
                              onTap: () => _setParadigm(_paradigms[i].$1),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text('ACCESSIBILITY', style: _eyebrow(cap)),
                    const SizedBox(height: 6),
                    for (final p in _profiles)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.$2, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ink)),
                                  Text(p.$3, style: TextStyle(fontSize: 12, color: cap)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _setProfile(p.$1, !_draft.hasProfile(p.$1)),
                              child: AppToggle(on: _draft.hasProfile(p.$1)),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text('LIVE PREVIEW', style: _eyebrow(cap)),
                    const SizedBox(height: 10),
                    const PreviewCard(),
                    const SizedBox(height: 22),
                    _ApplyCta(onApply: () => widget.onApply(_draft)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _eyebrow(Color c) =>
      TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.4, color: c);
}

/// A picker card rendered in ITS OWN paradigm (via [ParadigmScope]) containing a
/// pure material specimen — no icon/label/status props on the specimen itself.
class _ParadigmCard extends StatelessWidget {
  final Paradigm paradigm;
  final String name;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ParadigmCard({
    required this.paradigm,
    required this.name,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ParadigmScope(
      paradigm: paradigm,
      child: Builder(builder: (context) {
        final sem = context.sem;
        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected ? sem.state.focusRingColor : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: SurfaceBox(
              style: sem.card.ground,
              radius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _MaterialSpecimen(),
                  const SizedBox(height: 10),
                  Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: sem.card.titleColor)),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: sem.sectionHeader.captionColor)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Pure paradigm-material shapes: the enabled ground and the on-state ground of
/// the ambient (scoped) paradigm. No glyphs, labels or status.
class _MaterialSpecimen extends StatelessWidget {
  const _MaterialSpecimen();

  @override
  Widget build(BuildContext context) {
    final sem = context.sem;
    final tile = sem.tile;
    // T4 — each specimen sits on a mini-backdrop of ITS OWN paradigm's wallpaper
    // (a small crop for Glass, warm cream patch for Skeuo, flat neutral for
    // Minimal), so a Glass specimen tile has content to blur. The tiles remain a
    // pure material specimen (no icon/label/status).
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 48,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(decoration: BoxDecoration(gradient: sem.system.wallpaper)),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SurfaceBox(style: tile.ground(WState.enabled), radius: tile.radius, width: 32, height: 36),
                  const SizedBox(width: 6),
                  SurfaceBox(style: tile.ground(WState.selected), radius: tile.radius, width: 32, height: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-width Apply CTA in the currently-selected paradigm's on-state material.
class _ApplyCta extends StatelessWidget {
  final VoidCallback? onApply;
  const _ApplyCta({required this.onApply});

  @override
  Widget build(BuildContext context) {
    final tile = context.sem.tile;
    return GestureDetector(
      onTap: onApply,
      child: SurfaceBox(
        style: tile.ground(WState.selected),
        radius: tile.radius,
        height: 54,
        alignment: Alignment.center,
        child: Text(
          'Apply',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: tile.ink(WState.selected)),
        ),
      ),
    );
  }
}

