import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import 'surface_box.dart';

/// Connectivity/quick-action glyphs the tile can show. Material glyphs stand in
/// for the source SVGs (recognizable); stroke-weight emphasis under Vision is a
/// known simplification — Material icons lack stroke control (see PLAN R7).
enum TileIcon { wifi, bluetooth, cellular, airplane, flashlight, dnd, rotation, battery }

IconData _glyph(TileIcon i) => switch (i) {
      TileIcon.wifi => Icons.wifi,
      TileIcon.bluetooth => Icons.bluetooth,
      TileIcon.cellular => Icons.signal_cellular_alt,
      TileIcon.airplane => Icons.airplanemode_active,
      TileIcon.flashlight => Icons.flashlight_on,
      TileIcon.dnd => Icons.do_not_disturb_on,
      TileIcon.rotation => Icons.screen_rotation,
      TileIcon.battery => Icons.battery_saver,
    };

/// AtomTile — the Control Center quick-setting tile. Reads only `sem.tile` /
/// `sem.text`; paradigm, profile and the Glass×Vision cascade are already
/// resolved for it (dumb atom).
class AtomTile extends StatelessWidget {
  final TileIcon icon;
  final String label;
  final String status;
  final WState state;

  const AtomTile({
    super.key,
    required this.icon,
    required this.label,
    this.status = '',
    this.state = WState.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.sem.tile;
    final scale = context.sem.text.scale;
    final ink = t.ink(state);
    final statusColor = t.status(state);
    final chip = t.labelChip(state);

    Widget labelBlock = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 15 * scale, fontWeight: FontWeight.w600, color: ink, height: 1.15)),
        if (status.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(status, style: TextStyle(fontSize: 12 * scale, fontWeight: FontWeight.w500, color: statusColor, height: 1.15)),
        ],
      ],
    );
    if (chip != null) {
      labelBlock = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(color: chip, borderRadius: BorderRadius.circular(8)),
        child: labelBlock,
      );
    }

    return SurfaceBox(
      style: t.ground(state),
      radius: t.radius,
      height: t.height,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(_glyph(icon), size: 28, color: ink),
          Align(alignment: Alignment.centerLeft, child: labelBlock),
        ],
      ),
    );
  }
}
