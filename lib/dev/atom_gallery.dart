import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import '../atoms/surface_box.dart';
import '../atoms/atom_tile.dart';
import '../atoms/app_slider.dart';
import '../atoms/app_toggle.dart';
import '../atoms/app_chip.dart';
import '../atoms/section_header.dart';
import '../atoms/widget_card.dart';
import '../atoms/app_icon.dart';
import '../atoms/preview_card.dart';

/// Phase-2 sanity gallery: every atom on one surface, so a paradigm swap or
/// profile toggle shows them all adapt together. Content sits in the paradigm
/// container so Glass reads correctly. Not a product surface — Phase 3 assembles
/// the real Control Center from these same atoms.
class AtomGallery extends StatelessWidget {
  const AtomGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final sem = context.sem;
    final ink = sem.sectionHeader.titleColor; // paradigm-appropriate label ink
    final cap = sem.sectionHeader.captionColor;

    Widget rowLabel(String s, Widget trailing) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Expanded(child: Text(s, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ink))),
            trailing,
          ]),
        );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(title: 'Quick Settings', caption: 'Network & connections'),
        const SizedBox(height: 14),
        Row(children: const [
          Expanded(child: AtomTile(icon: TileIcon.wifi, label: 'Wi-Fi', status: 'On', state: WState.selected)),
          SizedBox(width: 12),
          Expanded(child: AtomTile(icon: TileIcon.bluetooth, label: 'Bluetooth', status: 'Off')),
        ]),
        const SizedBox(height: 12),
        Row(children: const [
          Expanded(child: AtomTile(icon: TileIcon.airplane, label: 'Airplane', status: 'Off')),
          SizedBox(width: 12),
          Expanded(child: AtomTile(icon: TileIcon.cellular, label: 'Cellular', status: 'Unavailable', state: WState.disabled)),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          Icon(Icons.brightness_low, color: ink, size: 22),
          const SizedBox(width: 12),
          const Expanded(child: AppSlider(value: 0.62)),
          const SizedBox(width: 12),
          Icon(Icons.brightness_high, color: ink, size: 22),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Icon(Icons.volume_down, color: ink, size: 22),
          const SizedBox(width: 12),
          const Expanded(child: AppSlider(value: 0.35)),
          const SizedBox(width: 12),
          Icon(Icons.volume_up, color: ink, size: 22),
        ]),
        const SizedBox(height: 12),
        rowLabel('Location', const AppToggle(on: true)),
        rowLabel('Battery Saver', const AppToggle(on: false)),
        rowLabel('Focus Mode', const AppToggle(on: false, disabled: true)),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: const [
          AppChip(label: 'Focus', state: WState.selected),
          AppChip(label: 'Sleep'),
          AppChip(label: 'Work'),
          AppChip(label: 'Off', state: WState.disabled),
        ]),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: Row(children: [
            Expanded(
              child: WidgetCard(
                title: 'Clock',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('9:41', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: ink, height: 1)),
                    ),
                    Text('Friday, July 20', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: cap)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WidgetCard(
                title: 'Weather',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('72°', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: ink, height: 1)),
                    ),
                    Text('Partly Cloudy', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.5, color: cap)),
                  ],
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
          AppIcon(fill: Color(0xFF33C75A), label: 'Phone', size: 56, glyph: Icon(Icons.phone, color: Colors.white, size: 28)),
          AppIcon(fill: Color(0xFF1466D8), label: 'Safari', size: 56, glyph: Icon(Icons.explore, color: Colors.white, size: 30)),
          AppIcon(fill: Color(0xFFFA2D48), label: 'Music', size: 56, glyph: Icon(Icons.music_note, color: Colors.white, size: 28)),
          AppIcon(fill: Color(0xFFFF9500), label: 'Photos', size: 56, glyph: Icon(Icons.photo, color: Colors.white, size: 28)),
        ]),
        const SizedBox(height: 20),
        const PreviewCard(),
      ],
    );

    return Stack(
      children: [
        const Positioned.fill(child: _GalleryWallpaper()),
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SurfaceBox(
              style: sem.container.style,
              radius: 28,
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          ),
        ),
      ],
    );
  }
}

class _GalleryWallpaper extends StatelessWidget {
  const _GalleryWallpaper();
  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B2F63), Color(0xFF10323A), Color(0xFF6B3B2A)],
        ),
      ),
    );
  }
}
