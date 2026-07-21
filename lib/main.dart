import 'package:flutter/material.dart';
import 'theme/app_config.dart';
import 'surfaces/launcher_shell.dart';

void main() => runApp(const LauncherApp());

/// Phase-1 entry point: mounts the token harness under [LauncherTheme]. From
/// Phase 6 the home surface replaces the harness as the app root.
class LauncherApp extends StatefulWidget {
  const LauncherApp({super.key});

  @override
  State<LauncherApp> createState() => _LauncherAppState();
}

class _LauncherAppState extends State<LauncherApp> {
  final AppConfigController controller = AppConfigController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Launcher',
      debugShowCheckedModeBanner: false,
      home: LauncherTheme(controller: controller, child: const LauncherShell()),
    );
  }
}
