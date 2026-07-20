import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import 'surface_box.dart';

/// AppToggle — on/off is the widget-specific second axis (mapped onto WState in
/// the semantic tier). Motor grows the whole control together. Style from
/// `sem.toggle`; the atom just positions a thumb in a track.
class AppToggle extends StatelessWidget {
  final bool on;
  final bool disabled;

  const AppToggle({super.key, this.on = false, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    final tk = context.sem.toggle;
    final w = tk.width, h = tk.height, td = tk.thumbSize;
    const pad = 4.0;
    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        children: [
          SurfaceBox(style: tk.track(on, disabled: disabled), radius: h / 2, width: w, height: h),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            top: pad,
            left: on ? w - td - pad : pad,
            child: SurfaceBox(style: tk.thumb(on, disabled: disabled), radius: td / 2, width: td, height: td),
          ),
        ],
      ),
    );
  }
}
