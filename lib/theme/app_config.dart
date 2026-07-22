import 'package:flutter/material.dart';
import '../tokens/semantic.dart';

/// Global app state: the active paradigm, the set of active profiles, and
/// session-scoped quick-setting toggles. Immutable value + a [ValueNotifier]
/// controller, per the zero-dependency state decision (Q2).
@immutable
class AppConfig {
  final Paradigm paradigm;
  final Set<Profile> profiles;
  final GridDensity density;
  final Map<String, bool> toggles;

  const AppConfig({
    this.paradigm = Paradigm.skeuo,
    this.profiles = const {},
    this.density = GridDensity.standard,
    this.toggles = const {},
  });

  bool hasProfile(Profile p) => profiles.contains(p);

  AppConfig copyWith({
    Paradigm? paradigm,
    Set<Profile>? profiles,
    GridDensity? density,
    Map<String, bool>? toggles,
  }) {
    return AppConfig(
      paradigm: paradigm ?? this.paradigm,
      profiles: profiles ?? this.profiles,
      density: density ?? this.density,
      toggles: toggles ?? this.toggles,
    );
  }
}

/// The single source of truth for paradigm/profile/toggle state.
class AppConfigController extends ValueNotifier<AppConfig> {
  AppConfigController([AppConfig? initial]) : super(initial ?? const AppConfig());

  void setParadigm(Paradigm p) => value = value.copyWith(paradigm: p);

  void setProfile(Profile p, bool on) {
    final next = Set<Profile>.of(value.profiles);
    on ? next.add(p) : next.remove(p);
    value = value.copyWith(profiles: next);
  }

  void toggleProfile(Profile p) => setProfile(p, !value.profiles.contains(p));

  void setDensity(GridDensity d) => value = value.copyWith(density: d);

  void setToggle(String key, bool on) =>
      value = value.copyWith(toggles: {...value.toggles, key: on});

  bool toggle(String key) => value.toggles[key] ?? false;
}

/// Exposes the controller to descendants (for mutation) and rebuilds them when
/// config changes.
class ThemeScope extends InheritedNotifier<AppConfigController> {
  const ThemeScope({
    super.key,
    required AppConfigController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppConfigController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'No ThemeScope found in context');
    return scope!.notifier!;
  }
}

/// Root theming widget: listens to the controller, composes [AppSemantics] for
/// the current config, and injects it as a [ThemeExtension] so any descendant
/// can read `context.sem`. A paradigm swap or profile toggle rebuilds only this
/// subtree's [Theme] — widgets themselves never change (§7 moment 1).
class LauncherTheme extends StatelessWidget {
  final AppConfigController controller;
  final Widget child;

  const LauncherTheme({super.key, required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: controller,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final cfg = controller.value;
          final sem = AppSemantics(paradigm: cfg.paradigm, profiles: cfg.profiles, density: cfg.density);
          final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
          return Theme(
            data: base.copyWith(extensions: <ThemeExtension>[sem]),
            child: child,
          );
        },
      ),
    );
  }
}
