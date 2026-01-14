import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sampleapp/main.dart';

void main() {
  group('Calculator App Tests', () {
    testWidgets('Calculator displays 0 on startup', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Pressing digit updates display', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.tap(find.text('5'));
      await tester.pump();

      expect(find.text('5'), findsWidgets);
    });

    testWidgets('Addition works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('5'), findsWidgets);
    });

    testWidgets('Subtraction works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.tap(find.text('9'));
      await tester.pump();
      await tester.tap(find.text('-'));
      await tester.pump();
      await tester.tap(find.text('4'));
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('5'), findsWidgets);
    });

    testWidgets('Multiplication works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('*'));
      await tester.pump();
      await tester.tap(find.text('4'));
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('Division works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.tap(find.text('8'));
      await tester.pump();
      await tester.tap(find.text('/'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('4'), findsWidgets);
    });

    testWidgets('Clear button resets display', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.tap(find.text('5'));
      await tester.pump();
      await tester.tap(find.text('C'));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Multi-digit numbers work', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();

      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('Decimal numbers work', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('.'));
      await tester.pump();
      await tester.tap(find.text('5'));
      await tester.pump();

      expect(find.text('3.5'), findsOneWidget);
    });
  });
}
