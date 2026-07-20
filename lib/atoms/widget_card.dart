import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import 'surface_box.dart';

/// WidgetCard — system CHROME (unlike AppIcon). Carries the full paradigm
/// treatment via `sem.card`. `dock` is the only structural variant (a long pill
/// holding a row of AppIcons). Content is passed as [child].
class WidgetCard extends StatelessWidget {
  final String? title;
  final bool dock;
  final Widget child;

  const WidgetCard({super.key, this.title, this.dock = false, required this.child});

  @override
  Widget build(BuildContext context) {
    final c = context.sem.card;
    final hasTitle = !dock && title != null && title!.trim().isNotEmpty;
    return SurfaceBox(
      style: c.ground,
      radius: dock ? 34 : 26,
      padding: dock ? const EdgeInsets.symmetric(horizontal: 18, vertical: 13) : const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasTitle) ...[
            Text(
              title!.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: c.titleColor,
              ),
            ),
            const SizedBox(height: 9),
          ],
          Flexible(child: child),
        ],
      ),
    );
  }
}
