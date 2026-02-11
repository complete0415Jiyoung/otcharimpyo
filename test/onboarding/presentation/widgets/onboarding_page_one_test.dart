import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/onboarding/presentation/widgets/onboarding_page_one.dart';

void main() {
  group('OnboardingPageOne Widget Tests', () {
    late bool onNextCalled;

    setUp(() {
      onNextCalled = false;
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: OnboardingPageOne(
          onNext: () {
            onNextCalled = true;
          },
        ),
      );
    }

    group('UI Elements', () {
      testWidgets('should show start button', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('시작하기'), findsOneWidget);
      });

      testWidgets('should have safe area', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(SafeArea), findsOneWidget);
      });

      testWidgets('should have elevated button', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('Button Interaction', () {
      testWidgets('should call onNext when start button tapped', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        expect(onNextCalled, isTrue);
      });
    });

    group('Layout', () {
      testWidgets('should have column layout', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should have spacer for layout', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(Spacer), findsOneWidget);
      });
    });
  });
}
