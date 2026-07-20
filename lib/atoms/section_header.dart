import 'package:flutter/material.dart';
import '../tokens/semantic.dart';
import 'surface_box.dart';

/// SectionHeader — title + optional caption. In Glass it sits on a backing
/// plate; that plate is dropped by the generalized cascade under Vision (the
/// container carries legibility). Header knows none of that — it reads
/// `sem.sectionHeader.plate` and paints what it's given.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? caption;
  final bool page;

  const SectionHeader({super.key, required this.title, this.caption, this.page = false});

  @override
  Widget build(BuildContext context) {
    final h = context.sem.sectionHeader;
    final t = context.sem.text;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: t.titleSize * (page ? 1.3 : 1),
            fontWeight: FontWeight.w700,
            color: h.titleColor,
            height: 1.15,
          ),
        ),
        if (caption != null && caption!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            caption!,
            style: TextStyle(fontSize: t.captionSize, fontWeight: FontWeight.w500, color: h.captionColor, height: 1.15),
          ),
        ],
      ],
    );

    final plate = h.plate;
    if (plate.isEmpty) return content;
    return SurfaceBox(
      style: plate,
      radius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: content,
    );
  }
}
