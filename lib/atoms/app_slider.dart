import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import 'surface_box.dart';

/// AppSlider — display value only (static in the MVP demo). Motor grows the
/// track height + thumb; Vision bumps them moderately; the glass track hardens
/// under Vision. All geometry + style come from `sem.slider`.
class AppSlider extends StatelessWidget {
  final double value; // 0..1
  final WState state;
  final bool full;

  const AppSlider({super.key, this.value = 0.5, this.state = WState.enabled, this.full = true});

  @override
  Widget build(BuildContext context) {
    final s = context.sem.slider;
    final dragging = state == WState.pressed;
    final th = s.trackHeight;
    final d = s.thumbDiameter(dragging: dragging);
    final v = value.clamp(0.0, 1.0);

    final slider = LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final fillW = (w * v).clamp(0.0, w);
        final thumbLeft = (v * (w - d)).clamp(0.0, w - d);
        return SizedBox(
          height: d + 8,
          width: w,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              SurfaceBox(style: s.track(state), radius: th / 2, height: th, width: w),
              SurfaceBox(style: s.fill(state), radius: th / 2, height: th, width: fillW),
              Positioned(
                left: thumbLeft,
                child: SurfaceBox(style: s.thumb(state), radius: d / 2, width: d, height: d),
              ),
            ],
          ),
        );
      },
    );
    return full ? slider : SizedBox(width: 196, child: slider);
  }
}
