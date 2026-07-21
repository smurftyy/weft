import 'package:flutter/material.dart';
import '../surfaces/home.dart';
import '../surfaces/control_center.dart';
import '../surfaces/customization.dart';

/// Surface host. Switches between Control Center and Customization and wires the
/// live flow: the Accessibility-Shortcut deep-link opens Customization, and
/// Apply returns to Control Center — where the just-changed paradigm/profile is
/// already reflected (Phase-4 checkpoint). Full gesture navigation lands Phase 6.
class TokenHarness extends StatefulWidget {
  const TokenHarness({super.key});

  @override
  State<TokenHarness> createState() => _TokenHarnessState();
}

class _TokenHarnessState extends State<TokenHarness> {
  int _index = 0; // 0 = Home, 1 = Control Center, 2 = Customization

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          Home(onOpenSettings: () => _go(2)),
          ControlCenter(onAccessibilityShortcut: () => _go(2)),
          Customization(onApply: () => _go(0)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.tune), label: 'Control'),
          NavigationDestination(icon: Icon(Icons.palette_outlined), label: 'Customize'),
        ],
      ),
    );
  }
}
