import 'package:flutter/material.dart';
import '../theme/app_config.dart';
import '../tokens/token_types.dart';
import '../surfaces/control_center.dart';

/// Phase-1 dev harness: the stub surface above, live paradigm + profile controls
/// below. Flipping a control recomposes [AppSemantics] and the stub repaints —
/// same widget code, visibly different tokens.
class TokenHarness extends StatelessWidget {
  const TokenHarness({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = ThemeScope.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF141018),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ControlCenter(
                onAccessibilityShortcut: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('→ Customization profiles (Phase 4)'), duration: Duration(seconds: 1)),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: ctrl,
              builder: (context, _) => _Controls(ctrl: ctrl),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  final AppConfigController ctrl;
  const _Controls({required this.ctrl});

  static const _profileLabels = {
    Profile.motor: 'Motor',
    Profile.vision: 'Vision',
    Profile.cognitive: 'Cognitive',
    Profile.oneHanded: 'One-Handed',
  };

  @override
  Widget build(BuildContext context) {
    final cfg = ctrl.value;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      color: const Color(0xFF1E1826),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Paradigm', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SegmentedButton<Paradigm>(
            segments: const [
              ButtonSegment(value: Paradigm.skeuo, label: Text('Skeuo')),
              ButtonSegment(value: Paradigm.glass, label: Text('Glass')),
              ButtonSegment(value: Paradigm.minimal, label: Text('Minimal')),
            ],
            selected: {cfg.paradigm},
            onSelectionChanged: (s) => ctrl.setParadigm(s.first),
          ),
          const SizedBox(height: 14),
          const Text('Profiles', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in _profileLabels.entries)
                FilterChip(
                  label: Text(entry.value),
                  selected: cfg.hasProfile(entry.key),
                  onSelected: (on) => ctrl.setProfile(entry.key, on),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
