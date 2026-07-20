import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../tokens/semantic.dart';

/// Phase-1 stub surface. NOT a product screen — a token witness. It reads only
/// `context.sem` and paints a container + section header + two tiles + an app-
/// icon row, so a paradigm swap or profile toggle produces visible token
/// differences. The real atoms/surfaces replace this from Phase 2 on.
class TokenStubSurface extends StatelessWidget {
  const TokenStubSurface({super.key});

  @override
  Widget build(BuildContext context) {
    final sem = context.sem;
    final c = sem.container.style;
    return Stack(
      children: [
        // Decorative "wallpaper" so Glass backdrop blur has something to blur.
        Positioned.fill(child: const _Wallpaper()),
        Center(
          child: _surfaceBox(
            style: c,
            radius: 28,
            padding: const EdgeInsets.all(18),
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(sem: sem),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _Tile(sem: sem, state: WState.enabled, label: 'Bluetooth', status: 'Off')),
                    const SizedBox(width: 12),
                    Expanded(child: _Tile(sem: sem, state: WState.selected, label: 'Wi-Fi', status: 'On')),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: const [
                    _AppIcon(fill: Color(0xFF33C75A)),
                    SizedBox(width: 14),
                    _AppIcon(fill: Color(0xFF1466D8)),
                    SizedBox(width: 14),
                    _AppIcon(fill: Color(0xFFFA2D48)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final AppSemantics sem;
  const _Header({required this.sem});

  @override
  Widget build(BuildContext context) {
    final h = sem.sectionHeader;
    final t = sem.text;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Settings',
            style: TextStyle(fontSize: t.titleSize, fontWeight: FontWeight.w700, color: h.titleColor, height: 1.15)),
        const SizedBox(height: 2),
        Text('Network & connections',
            style: TextStyle(fontSize: t.captionSize, fontWeight: FontWeight.w500, color: h.captionColor, height: 1.15)),
      ],
    );
    final plate = h.plate;
    if (plate.isEmpty) return content;
    return _surfaceBox(
      style: plate,
      radius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: content,
    );
  }
}

class _Tile extends StatelessWidget {
  final AppSemantics sem;
  final WState state;
  final String label;
  final String status;
  const _Tile({required this.sem, required this.state, required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    final tile = sem.tile;
    final ink = tile.ink(state);
    final statusColor = tile.status(state);
    final chip = tile.labelChip(state);

    Widget labelBlock = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 15 * sem.text.scale, fontWeight: FontWeight.w600, color: ink)),
        const SizedBox(height: 3),
        Text(status, style: TextStyle(fontSize: 12 * sem.text.scale, fontWeight: FontWeight.w500, color: statusColor)),
      ],
    );
    if (chip != null) {
      labelBlock = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(color: chip, borderRadius: BorderRadius.circular(8)),
        child: labelBlock,
      );
    }

    return _surfaceBox(
      style: tile.ground(state),
      radius: tile.radius,
      padding: const EdgeInsets.all(14),
      height: tile.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.wifi, size: 26, color: ink),
          Align(alignment: Alignment.centerLeft, child: labelBlock),
        ],
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  final Color fill;
  const _AppIcon({required this.fill});

  @override
  Widget build(BuildContext context) {
    final s = context.sem.system;
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: fill, // CONTENT: fill is constant across paradigms (§3.4)
        borderRadius: BorderRadius.circular(s.appIconRadius),
        boxShadow: s.appIconShadow,
      ),
    );
  }
}

class _Wallpaper extends StatelessWidget {
  const _Wallpaper();
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B2F63), Color(0xFF10323A), Color(0xFF6B3B2A)],
        ),
      ),
      child: Stack(children: const [
        Positioned(left: -30, top: 40, child: _Blob(140, Color(0x55FF7A3D))),
        Positioned(right: -20, bottom: 80, child: _Blob(160, Color(0x554AA8FF))),
      ]),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob(this.size, this.color);
  @override
  Widget build(BuildContext context) =>
      Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}

/// Paints a [SurfaceStyle] into a rounded box, applying a backdrop blur when the
/// style asks for one. Atoms will share this helper's logic in Phase 2.
Widget _surfaceBox({
  required SurfaceStyle style,
  required double radius,
  EdgeInsets? padding,
  double? width,
  double? height,
  Widget? child,
}) {
  final deco = BoxDecoration(
    color: style.color,
    gradient: style.gradient,
    borderRadius: BorderRadius.circular(radius),
    border: style.borderColor != null
        ? Border.all(color: style.borderColor!, width: style.borderWidth)
        : null,
    boxShadow: style.shadows,
  );
  Widget content = Container(width: width, height: height, padding: padding, decoration: deco, child: child);
  if (style.blurSigma > 0) {
    content = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: style.blurSigma, sigmaY: style.blurSigma),
        child: content,
      ),
    );
  }
  return content;
}
