import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../tokens/semantic.dart';

/// The single widget every atom paints its resolved [SurfaceStyle] through.
/// Handles fill/gradient, border, drop shadows, backdrop blur (glass) and — the
/// R6 payload — inner shadows/glows via [InsetShadowPainter]. Atoms hand it a
/// [SurfaceStyle] from the semantic tier and never touch paint themselves.
class SurfaceBox extends StatelessWidget {
  final SurfaceStyle style;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Widget? child;

  const SurfaceBox({
    super.key,
    required this.style,
    required this.radius,
    this.padding,
    this.width,
    this.height,
    this.alignment,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(radius);

    Widget inner = child ?? const SizedBox.shrink();
    if (padding != null) inner = Padding(padding: padding!, child: inner);
    // Inner shadows paint over the fill, below the child (CSS inset order).
    if (style.insets.isNotEmpty) {
      inner = CustomPaint(
        painter: InsetShadowPainter(insets: style.insets, radius: radius),
        child: inner,
      );
    }

    Widget core = Container(
      width: width,
      height: height,
      alignment: alignment,
      decoration: BoxDecoration(
        color: style.color,
        gradient: style.gradient,
        borderRadius: br,
        border: style.borderColor != null
            ? Border.all(color: style.borderColor!, width: style.borderWidth)
            : null,
        boxShadow: style.shadows.isEmpty ? null : style.shadows,
      ),
      child: inner,
    );

    if (style.blurSigma > 0) {
      core = ClipRRect(
        borderRadius: br,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: style.blurSigma, sigmaY: style.blurSigma),
          child: core,
        ),
      );
    }
    return core;
  }
}

/// Paints CSS-`inset`-style inner shadows and glows. Technique: clip to the
/// rounded rect, then for each spec fill the "frame" (a huge rect minus the
/// inner rrect), offset and blurred — so the blurred inner edge bleeds inward.
/// Directional specs (offset≠0) read as edge highlights/grooves; zero-offset
/// large-blur specs read as omnidirectional inner glows (the glass on-state).
class InsetShadowPainter extends CustomPainter {
  final List<InsetSpec> insets;
  final double radius;
  const InsetShadowPainter({required this.insets, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final inner = Path()..addRRect(rrect);

    canvas.save();
    canvas.clipRRect(rrect);
    for (final spec in insets) {
      final paint = Paint()..color = spec.color;
      if (spec.blur > 0) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, spec.blur);
      }
      final pad = spec.blur * 3 + 40;
      final outer = Path()..addRect(rect.inflate(pad));
      final frame = Path.combine(PathOperation.difference, outer, inner);
      canvas.save();
      canvas.translate(spec.offset.dx, spec.offset.dy);
      canvas.drawPath(frame, paint);
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(InsetShadowPainter old) =>
      old.radius != radius || old.insets != insets;
}
