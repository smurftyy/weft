import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import '../atoms/app_icon.dart';
import '../atoms/widget_card.dart';

/// One home app: fill + glyph + label are CONTENT — identical across paradigms
/// (§3.4). Only the surrounding chrome (radius, shadow, wallpaper, widgets,
/// dock) adapts. This is the §7 acceptance #4 demo.
class _App {
  final Color fill;
  final IconData glyph;
  final Color glyphColor;
  final String label;
  const _App(this.fill, this.glyph, this.label, {this.glyphColor = Colors.white});
}

const _apps = <_App>[
  _App(Color(0xFF33C75A), Icons.phone, 'Phone'),
  _App(Color(0xFF33C75A), Icons.chat_bubble, 'Messages'),
  _App(Color(0xFF1E8FFF), Icons.mail, 'Mail'),
  _App(Color(0xFF1466D8), Icons.explore, 'Safari'),
  _App(Color(0xFF1C1C1E), Icons.photo_camera, 'Camera'),
  _App(Color(0xFFFFFFFF), Icons.filter_vintage, 'Photos', glyphColor: Color(0xFFFF2D55)),
  _App(Color(0xFFFFCF2D), Icons.sticky_note_2, 'Notes'),
  _App(Color(0xFFFFFFFF), Icons.calendar_month, 'Calendar', glyphColor: Color(0xFFFF3B30)),
  _App(Color(0xFF1C1C1E), Icons.schedule, 'Clock'),
  _App(Color(0xFF2E8BE6), Icons.wb_sunny, 'Weather'),
  _App(Color(0xFFFA2D48), Icons.music_note, 'Music'),
  _App(Color(0xFF9B4DFF), Icons.podcasts, 'Podcasts'),
  _App(Color(0xFF34C759), Icons.navigation, 'Maps'),
  _App(Color(0xFF9AA0A8), Icons.settings, 'Settings'),
  _App(Color(0xFFFFFFFF), Icons.folder, 'Files', glyphColor: Color(0xFF3AA0FF)),
  _App(Color(0xFFFFFFFF), Icons.favorite, 'Health', glyphColor: Color(0xFFFF2D55)),
  _App(Color(0xFF1C1C1E), Icons.account_balance_wallet, 'Wallet'),
  _App(Color(0xFF0A84FF), Icons.apps, 'App Store'),
  _App(Color(0xFF1C1C1E), Icons.tv, 'TV'),
  _App(Color(0xFF1C1C1E), Icons.fitness_center, 'Fitness'),
];

const _dock = <_App>[
  _App(Color(0xFF33C75A), Icons.phone, 'Phone'),
  _App(Color(0xFF1466D8), Icons.explore, 'Safari'),
  _App(Color(0xFF33C75A), Icons.chat_bubble, 'Messages'),
  _App(Color(0xFFFA2D48), Icons.music_note, 'Music'),
];

/// Home Screen. Wallpaper + widgets + dock are chrome (paradigm-tokenized); the
/// app grid is content (stable across swaps).
class Home extends StatelessWidget {
  final VoidCallback? onOpenSettings; // Settings icon → Customization (Phase 6)
  const Home({super.key, this.onOpenSettings});

  Widget _icon(_App a, {double size = 56, bool label = true}) => AppIcon(
        fill: a.fill,
        size: size,
        label: label ? a.label : '',
        glyph: Icon(a.glyph, color: a.glyphColor, size: size * 0.5),
      );

  @override
  Widget build(BuildContext context) {
    final sem = context.sem;
    final ink = sem.sectionHeader.titleColor;
    final cap = sem.sectionHeader.captionColor;

    final grid = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var r = 0; r < 5; r++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var c = 0; c < 4; c++)
                GestureDetector(
                  key: _apps[r * 4 + c].label == 'Settings' ? const ValueKey('home-settings') : null,
                  onTap: _apps[r * 4 + c].label == 'Settings' ? onOpenSettings : null,
                  child: _icon(_apps[r * 4 + c]),
                ),
            ],
          ),
      ],
    );

    return Stack(
      children: [
        Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: sem.system.homeWallpaper))),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            child: Column(
              children: [
                _StatusBar(ink: ink),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 142,
                        child: WidgetCard(
                          title: 'Clock',
                          child: LiveTime(
                            builder: (context, now) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_weekday(now), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFB24C34))),
                                FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(_hourMinute(now), style: TextStyle(fontSize: 46, fontWeight: FontWeight.w700, height: 1, color: ink))),
                                Text(_monthDay(now), style: TextStyle(fontSize: 13, color: cap)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 100,
                        child: WidgetCard(
                          title: 'Weather',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.wb_cloudy, color: cap, size: 26),
                              FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text('72°', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, height: 1, color: ink))),
                              Text('H:78 L:61', style: TextStyle(fontSize: 11.5, color: cap)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: grid),
                const SizedBox(height: 8),
                _PageIndicator(ink: ink),
                const SizedBox(height: 10),
                WidgetCard(
                  dock: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [for (final a in _dock) _icon(a, size: 54, label: false)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Live clock (T8) ──────────────────────────────────────────────────────────
const _weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
const _months = ['January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December'];

String _weekday(DateTime t) => _weekdays[t.weekday - 1];
String _monthDay(DateTime t) => '${_months[t.month - 1]} ${t.day}';
String _hourMinute(DateTime t) {
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
  return '$h:${t.minute.toString().padLeft(2, '0')}';
}

/// Ticks once a second via `StreamBuilder` on `Stream.periodic` (T8) so the
/// clock is alive — no more "screenshot in phone chrome". Weather stays mock.
class LiveTime extends StatefulWidget {
  final Widget Function(BuildContext, DateTime) builder;
  const LiveTime({super.key, required this.builder});

  /// Test seam: when set, LiveTime renders this fixed time statically (no
  /// periodic stream), so widget tests stay deterministic and `pumpAndSettle`
  /// doesn't spin on the 1-second timer. Null in production → live ticking.
  static DateTime? debugFixedNow;

  @override
  State<LiveTime> createState() => _LiveTimeState();
}

class _LiveTimeState extends State<LiveTime> {
  Stream<DateTime>? _stream;

  @override
  void initState() {
    super.initState();
    if (LiveTime.debugFixedNow == null) {
      _stream = Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final fixed = LiveTime.debugFixedNow;
    if (fixed != null) return widget.builder(context, fixed);
    return StreamBuilder<DateTime>(
      stream: _stream,
      initialData: DateTime.now(),
      builder: (context, snap) => widget.builder(context, snap.data!),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final Color ink;
  const _StatusBar({required this.ink});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LiveTime(builder: (context, now) => Text(_hourMinute(now), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ink))),
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

class _PageIndicator extends StatelessWidget {
  final Color ink;
  const _PageIndicator({required this.ink});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: ink)),
          const SizedBox(width: 8),
          Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: ink.withValues(alpha: 0.32))),
        ],
      );
}
