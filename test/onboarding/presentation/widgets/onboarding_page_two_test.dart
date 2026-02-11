import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/onboarding/presentation/widgets/onboarding_page_two.dart';

void main() {
  group('OnboardingPageTwo Widget Tests', () {
    late bool onRequestPermissionCalled;

    setUp(() {
      onRequestPermissionCalled = false;
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: OnboardingPageTwo(
          onRequestPermission: () {
            onRequestPermissionCalled = true;
          },
        ),
      );
    }

    group('UI Elements', () {
      testWidgets('should show location permission button', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('위치 정보 허용하기'), findsOneWidget);
      });

      testWidgets('should show title text', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.textContaining('지금 계신 곳을'), findsOneWidget);
      });

      testWidgets('should show subtitle text', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.textContaining('현재 위치의 기온을 알고'), findsOneWidget);
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

      testWidgets('should show location emoji', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('📍'), findsOneWidget);
      });
    });

    group('Button Interaction', () {
      testWidgets('should call onRequestPermission when button tapped', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        expect(onRequestPermissionCalled, isTrue);
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

      testWidgets('should have row for title with emoji', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(Row), findsWidgets);
      });
    });

    group('Styling', () {
      testWidgets('should have container with decoration', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should have padding', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(Padding), findsWidgets);
      });
    });
  });
}
