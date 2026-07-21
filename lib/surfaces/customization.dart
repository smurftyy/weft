import 'package:flutter/material.dart';
import '../theme/app_config.dart';
import '../theme/paradigm_scope.dart';
import '../tokens/semantic.dart';
import '../atoms/surface_box.dart';
import '../atoms/app_toggle.dart';
import '../atoms/section_header.dart';
import '../atoms/preview_card.dart';

/// Customization — the thesis-carrying surface. Selecting a paradigm or toggling
/// a profile mutates [AppConfig] live, so this surface AND (on re-entry) Control
/// Center + Home all reflect it. The picker cards each render in their OWN
/// paradigm via [ParadigmScope]; the live [PreviewCard] shows the composed
/// paradigm × profiles, demonstrating 3-axis stacking (e.g. Skeuo × Vision ×
/// One-Handed).
class Customization extends StatelessWidget {
  final VoidCallback? onApply;
  const Customization({super.key, this.onApply});

  static const _paradigms = <(Paradigm, String, String)>[
    (Paradigm.skeuo, 'Skeuo', 'Dimensional'),
    (Paradigm.glass, 'Glass', 'Translucent'),
    (Paradigm.minimal, 'Minimal', 'Flat'),
  ];
  static const _profiles = <(Profile, String, String)>[
    (Profile.motor, 'Motor', 'Larger targets, less motion'),
    (Profile.vision, 'Vision', 'Higher contrast, larger text'),
    (Profile.cognitive, 'Cognitive', 'Simplified, muted (preview)'),
    (Profile.oneHanded, 'One-Handed', 'Thumb-zone reach (preview)'),
  ];

  @override
  Widget build(BuildContext context) {
    final sem = context.sem;
    final ctrl = ThemeScope.of(context);
    final cfg = ctrl.value;
    final ink = sem.sectionHeader.titleColor;
    final cap = sem.sectionHeader.captionColor;

    return Stack(
      children: [
        const Positioned.fill(child: _CzWallpaper()),
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
                              selected: cfg.paradigm == _paradigms[i].$1,
                              onTap: () => ctrl.setParadigm(_paradigms[i].$1),
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
                              onTap: () => ctrl.setProfile(p.$1, !cfg.hasProfile(p.$1)),
                              child: AppToggle(on: cfg.hasProfile(p.$1)),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text('LIVE PREVIEW', style: _eyebrow(cap)),
                    const SizedBox(height: 10),
                    const PreviewCard(),
                    const SizedBox(height: 22),
                    _ApplyCta(onApply: onApply),
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
    final tile = context.sem.tile;
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SurfaceBox(style: tile.ground(WState.enabled), radius: tile.radius, width: 34, height: 40),
          const SizedBox(width: 6),
          SurfaceBox(style: tile.ground(WState.selected), radius: tile.radius, width: 34, height: 40),
        ],
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

class _CzWallpaper extends StatelessWidget {
  const _CzWallpaper();
  @override
  Widget build(BuildContext context) => const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3B2F63), Color(0xFF123240), Color(0xFF6B3B2A)],
          ),
        ),
      );
}
