import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:narsingh_kitchen/main.dart';

void main() {
  testWidgets('App launches with splash route', (WidgetTester tester) async {
    await tester.pumpWidget(const NarsinghKitchenApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
