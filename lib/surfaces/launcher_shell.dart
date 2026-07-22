import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import 'home.dart';
import 'control_center.dart';
import 'customization.dart';

/// The integrated launcher. Home is the base surface; Control Center is a
/// swipe-down sheet (with a tappable grab handle as the demo safety net);
/// Customization slides in from the Home Settings icon. All three share the one
/// `AppConfigController` (provided above by `LauncherTheme`), so paradigm/profile
/// and toggle state persist across every navigation.
class LauncherShell extends StatefulWidget {
  const LauncherShell({super.key});

  @override
  State<LauncherShell> createState() => _LauncherShellState();
}

class _LauncherShellState extends State<LauncherShell> with TickerProviderStateMixin {
  late final AnimationController _cc = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
  late final AnimationController _cz = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 320));

  @override
  void dispose() {
    _cc.dispose();
    _cz.dispose();
    super.dispose();
  }

  double get _h => MediaQuery.of(context).size.height;

  void _openCC() => _cc.fling(velocity: 2);
  void _closeCC() => _cc.fling(velocity: -2);
  void _openCz() => _cz.fling(velocity: 2);
  void _closeCz() => _cz.fling(velocity: -2);

  void _dragCC(DragUpdateDetails d) =>
      _cc.value = (_cc.value + d.primaryDelta! / _h).clamp(0.0, 1.0);
  void _settleCC(DragEndDetails d) {
    final v = d.primaryVelocity ?? 0;
    if (v.abs() > 300) {
      v > 0 ? _openCC() : _closeCC();
    } else {
      _cc.value > 0.5 ? _openCC() : _closeCC();
    }
  }

  @override
  Widget build(BuildContext context) {
    final handleColor = context.sem.sectionHeader.titleColor.withValues(alpha: 0.35);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_cz.value > 0) {
          _closeCz();
        } else if (_cc.value > 0) {
          _closeCC();
        }
      },
      // Transparent Material provides the DefaultTextStyle baseline for every
      // surface below (so Text isn't the yellow debug fallback) while painting
      // nothing over the per-paradigm wallpaper.
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
        children: [
          // Base surface.
          Home(onOpenSettings: _openCz),

          // Top edge: swipe-down opens Control Center; the pill is the safety net.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 56,
            child: GestureDetector(
              key: const ValueKey('cc-open-handle'),
              behavior: HitTestBehavior.translucent,
              onTap: _openCC,
              onVerticalDragUpdate: _dragCC,
              onVerticalDragEnd: _settleCC,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(color: handleColor, borderRadius: BorderRadius.circular(3)),
                ),
              ),
            ),
          ),

          // Control Center sheet (slides down from the top over Home).
          AnimatedBuilder(
            animation: _cc,
            builder: (context, _) {
              final v = _cc.value;
              return IgnorePointer(
                ignoring: v == 0,
                child: Stack(
                  children: [
                    Opacity(
                      opacity: v * 0.4,
                      child: GestureDetector(onTap: _closeCC, child: Container(color: Colors.black)),
                    ),
                    FractionalTranslation(
                      translation: Offset(0, v - 1),
                      child: _ccSheet(handleColor),
                    ),
                  ],
                ),
              );
            },
          ),

          // Customization (slides in from the right off the Settings icon).
          AnimatedBuilder(
            animation: _cz,
            builder: (context, _) {
              final v = _cz.value;
              return IgnorePointer(
                ignoring: v == 0,
                child: FractionalTranslation(
                  translation: Offset(1 - v, 0),
                  child: Customization(onApply: _closeCz),
                ),
              );
            },
          ),
        ],
        ),
      ),
    );
  }

  Widget _ccSheet(Color handleColor) {
    return Stack(
      children: [
        ControlCenter(onAccessibilityShortcut: () {
          _closeCC();
          _openCz();
        }),
        // Grab handle to dismiss (drag up, or tap — the safety net for closing).
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 30,
          child: GestureDetector(
            key: const ValueKey('cc-close-handle'),
            behavior: HitTestBehavior.translucent,
            onTap: _closeCC,
            onVerticalDragUpdate: _dragCC,
            onVerticalDragEnd: _settleCC,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                width: 44,
                height: 5,
                decoration: BoxDecoration(color: handleColor, borderRadius: BorderRadius.circular(3)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
