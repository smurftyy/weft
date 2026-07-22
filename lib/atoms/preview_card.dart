import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import 'atom_tile.dart';

/// PreviewCard — the Customization live-composition specimen. Renders scaled
/// AtomTiles in the current paradigm×profile so three-axis composition (e.g.
/// Skeuo × Vision × One-Handed) is visible. One-Handed is realized HERE only
/// (Q3): tiles cluster to the lower band with a "reachable" hairline at ~35%.
class PreviewCard extends StatelessWidget {
  const PreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final pv = context.sem.preview;
    final reach = pv.reachableFromTop; // null unless One-Handed active

    final tiles = Row(
      children: [
        Expanded(child: _mini(const AtomTile(icon: TileIcon.flashlight, label: 'Flashlight', status: 'Off'))),
        const SizedBox(width: 8),
        Expanded(child: _mini(const AtomTile(icon: TileIcon.wifi, label: 'Wi-Fi', status: 'On', state: WState.selected))),
      ],
    );

    Widget interior = tiles;
    if (reach != null) {
      interior = Stack(
        children: [
          Align(alignment: Alignment.bottomCenter, child: tiles),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: reach,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 1, color: pv.hairline),
                    const SizedBox(height: 3),
                    Text('REACHABLE',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.7, color: pv.caption)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    // T3 — a bounded backdrop region inside the panel that renders the current
    // paradigm's wallpaper, so Glass preview tiles have varied content to blur
    // (their BackdropFilter now reveals the wallpaper behind).
    final wallpaper = context.sem.system.wallpaper;
    final region = ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: reach != null ? 150 : 100,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(decoration: BoxDecoration(gradient: wallpaper)),
            Padding(padding: const EdgeInsets.all(10), child: interior),
          ],
        ),
      ),
    );

    final panel = pv.panel;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: panel.color,
        gradient: panel.gradient,
        borderRadius: BorderRadius.circular(20),
        border: panel.borderColor != null ? Border.all(color: panel.borderColor!) : null,
        boxShadow: panel.shadows.isEmpty ? null : panel.shadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          region,
          const SizedBox(height: 10),
          Text('PREVIEW',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: pv.caption)),
        ],
      ),
    );
  }

  Widget _mini(Widget tile) => FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.topLeft, child: SizedBox(width: 156, height: 116, child: tile));
}
