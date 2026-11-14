import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:discktop_test/main.dart';

void main() {
  testWidgets('Kiosk app smoke test', (WidgetTester tester) async {
    // Set a typical kiosk screen resolution
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RestaurantKioskApp());

    expect(find.text('برجر كينجدوم'), findsOneWidget);
    expect(find.text('تناول بالمطعم'), findsOneWidget);
    expect(find.text('طلب سفري'), findsOneWidget);
  });
}
