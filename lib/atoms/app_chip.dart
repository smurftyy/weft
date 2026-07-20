import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import 'surface_box.dart';

/// AppChip — profile-agnostic as a prop system (Q4). No `profile` prop: Vision's
/// contrast reaches it through the semantic tokens paradigm×profile compose has
/// already adjusted; Motor doesn't apply (chips aren't primary tap targets). A
/// future interactive variant would be `ChipVariant.interactive`, not a retrofit.
class AppChip extends StatelessWidget {
  final String label;
  final WState state;

  const AppChip({super.key, required this.label, this.state = WState.enabled});

  @override
  Widget build(BuildContext context) {
    final c = context.sem.chip;
    final upper = c.uppercase;
    return SurfaceBox(
      style: c.ground(state),
      radius: c.radius,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Text(
        upper ? label.toUpperCase() : label,
        style: TextStyle(
          color: c.text(state),
          fontSize: (upper ? 11 : 13) * c.textScale,
          fontWeight: upper ? FontWeight.w700 : FontWeight.w600,
          letterSpacing: upper ? 0.9 : 0,
        ),
      ),
    );
  }
}
