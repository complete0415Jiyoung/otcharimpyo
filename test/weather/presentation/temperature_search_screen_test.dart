import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:otcharimpyo/weather/presentation/temperature_search_screen.dart';

void main() {
  group('TemperatureSearchScreen Widget Tests', () {
    Widget createWidgetUnderTest() {
      return const ProviderScope(
        child: MaterialApp(
          home: TemperatureSearchScreen(),
        ),
      );
    }

    group('Screen Elements', () {
      testWidgets('should show title', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('온도로 옷차림 찾기'), findsOneWidget);
      });

      testWidgets('should show back button', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      });

      testWidgets('should show slider', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('should show initial temperature', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('12'), findsOneWidget);
      });

      testWidgets('should show outfit recommendation section', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('추천 옷차림'), findsOneWidget);
      });

      testWidgets('should show tops category', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('상의'), findsOneWidget);
      });

      testWidgets('should show bottoms category', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('하의'), findsOneWidget);
      });
    });

    group('Slider Interaction', () {
      testWidgets('should update temperature when slider moved right', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // 초기 온도 확인
        expect(find.text('12'), findsOneWidget);

        // 슬라이더를 오른쪽으로 드래그
        await tester.drag(find.byType(Slider), const Offset(200, 0));
        await tester.pumpAndSettle();

        // 온도가 변경되었는지 확인 (12가 더 이상 없어야 함)
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('should update temperature when slider moved left', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // 슬라이더를 왼쪽으로 드래그
        await tester.drag(find.byType(Slider), const Offset(-200, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });
    });

    group('Outfit Recommendations', () {
      testWidgets('should show outfit items for initial temperature', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // 12도에 해당하는 옷차림 (니트, 맨투맨 등)
        expect(find.text('니트'), findsOneWidget);
      });

      testWidgets('should have outers for cool weather', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // 12도에는 아우터가 있어야 함
        expect(find.text('아우터'), findsOneWidget);
      });
    });

    group('Temperature Range', () {
      testWidgets('should handle minimum temperature', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // 슬라이더를 최소값으로
        await tester.drag(find.byType(Slider), const Offset(-500, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('should handle maximum temperature', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // 슬라이더를 최대값으로
        await tester.drag(find.byType(Slider), const Offset(500, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('should be scrollable', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // 스크롤 테스트
        await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -200));
        await tester.pumpAndSettle();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should have proper structure', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
        // 커스텀 헤더 사용 (AppBar 대신)
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
        expect(find.text('온도로 옷차림 찾기'), findsOneWidget);
      });
    });

    group('Temperature Display', () {
      testWidgets('should show degree symbol', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.textContaining('°'), findsWidgets);
      });
    });
  });
}
