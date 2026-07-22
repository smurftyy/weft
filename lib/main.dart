import 'package:flutter/material.dart';
import 'theme/app_config.dart';
import 'theme/prefs.dart';
import 'surfaces/launcher_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load the last-applied paradigm + profile (Skeuo baseline on first run). (T6)
  final initial = await Prefs.load();
  runApp(LauncherApp(initialConfig: initial));
}

/// Weft — the composable launcher. Home is the app root, wrapped in
/// [LauncherTheme] so the whole tree reads the composed [AppSemantics].
class LauncherApp extends StatefulWidget {
  final AppConfig initialConfig;
  const LauncherApp({super.key, this.initialConfig = const AppConfig()});

  @override
  State<LauncherApp> createState() => _LauncherAppState();
}

class _LauncherAppState extends State<LauncherApp> {
  late final AppConfigController controller = AppConfigController(widget.initialConfig);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weft',
      debugShowCheckedModeBanner: false,
      home: LauncherTheme(controller: controller, child: const LauncherShell()),
    );
  }
}
