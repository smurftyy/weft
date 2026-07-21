import 'package:flutter/material.dart';
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
  int _index = 0; // 0 = Control Center, 1 = Customization

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          ControlCenter(onAccessibilityShortcut: () => setState(() => _index = 1)),
          Customization(onApply: () => setState(() => _index = 0)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.tune), label: 'Control'),
          NavigationDestination(icon: Icon(Icons.palette_outlined), label: 'Customize'),
        ],
      ),
    );
  }
}
