import 'package:flutter/material.dart';
import '../tokens/primitives.dart';

/// Phase-1 Tier-1 sanity stub. Proves the primitives layer is consumable by a
/// real widget without any hardcoded literals in the widget body — every value
/// comes from [Prims]. This is scaffolding, absorbed once the atom layer lands.
class Tier1Stub extends StatelessWidget {
  const Tier1Stub({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Prims.warmGround,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(Prims.sp4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Skeuo raised card ground (gradient + outer lift shadow primitives).
          Container(
            width: 220,
            height: 120,
            decoration: BoxDecoration(
              gradient: Prims.skeuoCardGround,
              borderRadius: BorderRadius.circular(Prims.rad5Xl),
              boxShadow: Prims.skeuoCardLift,
            ),
            alignment: Alignment.center,
            child: const Text(
              'Tier 1',
              style: TextStyle(
                color: Prims.ink900,
                fontSize: Prims.textTitle,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: Prims.sp4),
          // Brand on-fill gradient primitive.
          Container(
            width: 220,
            height: 44,
            decoration: BoxDecoration(
              gradient: Prims.skeuoOnFill,
              borderRadius: BorderRadius.circular(Prims.rad2Xl),
            ),
          ),
        ],
      ),
    );
  }
}
