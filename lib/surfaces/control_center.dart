import 'package:flutter/material.dart';
import '../theme/app_config.dart';
import '../tokens/semantic.dart';
import '../atoms/surface_box.dart';
import '../atoms/atom_tile.dart';
import '../atoms/app_slider.dart';
import '../atoms/app_toggle.dart';
import '../atoms/section_header.dart';
import '../atoms/widget_card.dart';

/// Control Center — first assembled surface. Built Skeuo-correct, but every
/// visual comes from the semantic tier, so Glass/Minimal are produced by a
/// paradigm swap with ZERO widget changes (the Phase-3 thesis moment). Toggle
/// and tile on/off state is session-persistent in `AppConfig.toggles`.
class ControlCenter extends StatelessWidget {
  /// Deep-link fired by the "Accessibility Shortcut" row → Customization surface
  /// (wired in Phase 6 navigation; Phase 4 builds the target).
  final VoidCallback? onAccessibilityShortcut;

  const ControlCenter({super.key, this.onAccessibilityShortcut});

  static const _connectivity = <_TileCfg>[
    _TileCfg('wifi', TileIcon.wifi, 'Wi-Fi', 'Home network', 'Off', true),
    _TileCfg('bluetooth', TileIcon.bluetooth, 'Bluetooth', 'On', 'Off', true),
    _TileCfg('airplane', TileIcon.airplane, 'Airplane Mode', 'On', 'Off', false),
    _TileCfg('cellular', TileIcon.cellular, 'Cellular Data', 'LTE', 'Off', true),
  ];
  static const _quickActions = <_TileCfg>[
    _TileCfg('voice', TileIcon.voice, 'Voice Control', 'Listening', 'Off', false),
    _TileCfg('flashlight', TileIcon.flashlight, 'Flashlight', 'On', 'Off', false),
    _TileCfg('dnd', TileIcon.dnd, 'Do Not Disturb', 'On', 'Off', false),
    _TileCfg('rotation', TileIcon.rotation, 'Rotation Lock', 'Locked', 'Off', false),
  ];
  static const _moreToggles = <(String, String)>[
    ('location', 'Location'),
    ('batterySaver', 'Battery Saver'),
    ('focusMode', 'Focus Mode'),
  ];

  @override
  Widget build(BuildContext context) {
    final sem = context.sem;
    final ctrl = ThemeScope.of(context);
    final ink = sem.sectionHeader.titleColor;

    bool on(String id, bool dflt) => ctrl.value.toggles[id] ?? dflt;

    Widget tile(_TileCfg c) {
      final isOn = on(c.id, c.defaultOn);
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => ctrl.setToggle(c.id, !isOn),
        child: AtomTile(
          icon: c.icon,
          label: c.label,
          status: isOn ? c.onStatus : c.offStatus,
          state: isOn ? WState.selected : WState.enabled,
        ),
      );
    }

    Widget grid(List<_TileCfg> cfgs) => Column(children: [
          Row(children: [Expanded(child: tile(cfgs[0])), const SizedBox(width: 12), Expanded(child: tile(cfgs[1]))]),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: tile(cfgs[2])), const SizedBox(width: 12), Expanded(child: tile(cfgs[3]))]),
        ]);

    Widget sliderRow(IconData a, IconData b, double value) => Row(children: [
          Icon(a, color: ink, size: 22),
          const SizedBox(width: 12),
          Expanded(child: AppSlider(value: value)),
          const SizedBox(width: 12),
          Icon(b, color: ink, size: 22),
        ]);

    Widget toggleRow(String id, String label, bool dflt) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(children: [
            Expanded(child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: ink))),
            GestureDetector(
              onTap: () => ctrl.setToggle(id, !on(id, dflt)),
              child: AppToggle(on: on(id, dflt)),
            ),
          ]),
        );

    Widget accessibilityRow() => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onAccessibilityShortcut,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(children: [
              Icon(Icons.accessibility_new, size: 20, color: ink),
              const SizedBox(width: 10),
              Expanded(child: Text('Accessibility Shortcut', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: ink))),
              Icon(Icons.chevron_right, size: 22, color: ink.withValues(alpha: 0.6)),
            ]),
          ),
        );

    final content = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatusBar(ink: ink),
            const SizedBox(height: 8),
            const SectionHeader(title: 'Control Center', caption: 'Connections & quick settings', page: true),
            const SizedBox(height: 16),
            grid(_connectivity),
            const SizedBox(height: 20),
            sliderRow(Icons.brightness_low, Icons.brightness_high, 0.62),
            const SizedBox(height: 14),
            sliderRow(Icons.volume_mute, Icons.volume_up, 0.4),
            const SizedBox(height: 20),
            grid(_quickActions),
            const SizedBox(height: 20),
            WidgetCard(
              title: 'More',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final t in _moreToggles) toggleRow(t.$1, t.$2, false),
                  accessibilityRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Stack(
      children: [
        const Positioned.fill(child: _CCWallpaper()),
        Positioned.fill(
          child: SurfaceBox(style: sem.container.style, radius: 0, child: content),
        ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  final Color ink;
  const _StatusBar({required this.ink});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('9:41', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ink)),
          Row(children: [
            Icon(Icons.wifi, size: 17, color: ink),
            const SizedBox(width: 6),
            Icon(Icons.signal_cellular_alt, size: 17, color: ink),
            const SizedBox(width: 6),
            Icon(Icons.battery_full, size: 19, color: ink),
          ]),
        ],
      ),
    );
  }
}

class _CCWallpaper extends StatelessWidget {
  const _CCWallpaper();
  @override
  Widget build(BuildContext context) => const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3B2F63), Color(0xFF123240), Color(0xFF6B3B2A)],
          ),
        ),
      );
}

class _TileCfg {
  final String id;
  final TileIcon icon;
  final String label;
  final String onStatus;
  final String offStatus;
  final bool defaultOn;
  const _TileCfg(this.id, this.icon, this.label, this.onStatus, this.offStatus, this.defaultOn);
}
