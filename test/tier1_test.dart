import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_launcher/dev/tier1_stub.dart';
import 'package:mobile_launcher/tokens/primitives.dart';

void main() {
  testWidgets('Tier 1 primitives are consumable by a stub widget', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: Tier1Stub()))),
    );
    expect(find.text('Tier 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('radius ladder is strictly increasing (a scale, not a dictionary)', () {
    const r = [
      Prims.radXs, Prims.radSm, Prims.radMd, Prims.radLg, Prims.radXl,
      Prims.rad2Xl, Prims.rad3Xl, Prims.rad4Xl, Prims.rad5Xl, Prims.rad6Xl,
      Prims.rad7Xl, Prims.radFrame,
    ];
    for (var i = 1; i < r.length; i++) {
      expect(r[i], greaterThan(r[i - 1]), reason: 'radius step $i not increasing');
    }
  });

  test('blur ladder is strictly increasing from the Vision floor', () {
    const b = [
      Prims.blurNone, Prims.blurReduced, Prims.blurSm, Prims.blurMd,
      Prims.blurBase, Prims.blurPressed, Prims.blurContainer,
    ];
    for (var i = 1; i < b.length; i++) {
      expect(b[i], greaterThan(b[i - 1]), reason: 'blur step $i not increasing');
    }
  });

  test('glass legibility tint deepens plate < container < vision (findings #2/#4)', () {
    expect(Prims.glassTintPlate, lessThan(Prims.glassTintContainer));
    expect(Prims.glassTintContainer, lessThan(Prims.glassTintVision));
  });

  test('spacing follows the 8pt ladder', () {
    expect(Prims.sp2, 8);
    expect(Prims.sp4, 16);
    expect(Prims.sp8, 32);
    expect(Prims.sp1, Prims.sp2 / 2); // half-step
  });
}
