import 'package:flutter/material.dart';
import '../tokens/semantic.dart';

/// Forces a specific paradigm (and optional profiles) for its subtree by
/// injecting a fresh [AppSemantics] into the local [Theme]. Used by the
/// Customization paradigm-picker so each specimen renders in its OWN paradigm
/// regardless of the globally-active one. `context.sem` inside resolves to this.
class ParadigmScope extends StatelessWidget {
  final Paradigm paradigm;
  final Set<Profile> profiles;
  final Widget child;

  const ParadigmScope({
    super.key,
    required this.paradigm,
    this.profiles = const {},
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final sem = AppSemantics(paradigm: paradigm, profiles: profiles);
    return Theme(
      data: Theme.of(context).copyWith(extensions: <ThemeExtension>[sem]),
      child: child,
    );
  }
}
