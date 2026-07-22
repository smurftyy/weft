import 'package:shared_preferences/shared_preferences.dart';
import '../tokens/token_types.dart';
import 'app_config.dart';

/// Persists the last-applied paradigm + profile set across launches (T6).
/// Skeuo baseline on first run. All access is guarded so a missing platform
/// plugin (e.g. under `flutter test`) degrades to the in-memory default rather
/// than throwing.
abstract final class Prefs {
  Prefs._();

  static const _kParadigm = 'weft.paradigm';
  static const _kProfiles = 'weft.profiles';

  static Future<AppConfig> load() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final pName = sp.getString(_kParadigm);
      final paradigm = Paradigm.values.firstWhere(
        (p) => p.name == pName,
        orElse: () => Paradigm.skeuo,
      );
      final profNames = sp.getStringList(_kProfiles) ?? const <String>[];
      final profiles = <Profile>{
        for (final p in Profile.values)
          if (profNames.contains(p.name)) p,
      };
      return AppConfig(paradigm: paradigm, profiles: profiles);
    } catch (_) {
      return const AppConfig(); // first run / plugin unavailable
    }
  }

  static Future<void> save(AppConfig cfg) async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setString(_kParadigm, cfg.paradigm.name);
      await sp.setStringList(_kProfiles, [for (final p in cfg.profiles) p.name]);
    } catch (_) {/* best-effort */}
  }
}
