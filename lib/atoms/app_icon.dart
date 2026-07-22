import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import 'surface_box.dart';

/// AppIcon — the GLYPH is content (§3.4): brand identity constant across
/// paradigms (Safari stays the blue compass). The BACKING is chrome (T2): each
/// paradigm renders its own material — dimensional raised tile / translucent
/// glass revealing the wallpaper / flat tile — derived from the icon's content
/// colour (`fill`), resolved through `sem.system.appIconBacking`.
class AppIcon extends StatelessWidget {
  final Color fill; // content colour the backing is derived from
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
    final icon = SurfaceBox(
      style: sys.appIconBacking(fill),
      radius: r,
      width: size,
      height: size,
      alignment: Alignment.center,
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
