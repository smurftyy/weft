import 'package:flutter/material.dart';
import '../tokens/semantic.dart';

/// AppIcon — CONTENT, not chrome (§3.4). Fill + glyph + label are constant
/// across paradigms; ONLY corner radius and system shadow are paradigm-
/// tokenized (via `sem.system`). Safari stays the blue compass everywhere.
class AppIcon extends StatelessWidget {
  final Color fill; // content — never paradigm-tokenized
  final Widget? glyph; // content (inline SVG-equivalent), passed as child
  final String label; // content
  final double size;

  const AppIcon({
    super.key,
    required this.fill,
    this.glyph,
    this.label = '',
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final sys = context.sem.system;
    final r = sys.appIconRadius * size / 60;
    final icon = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(r),
        boxShadow: sys.appIconShadow.isEmpty ? null : sys.appIconShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: glyph,
    );
    if (label.trim().isEmpty) return icon;
    final sysShadow = sys.appIconLabelShadow;
    return SizedBox(
      width: 74,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 7),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: sys.appIconLabelColor, // chrome: legible on each wallpaper
              shadows: sysShadow == null ? null : [sysShadow],
            ),
          ),
        ],
      ),
    );
  }
}
