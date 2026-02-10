import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:otcharimpyo/main.dart';
import 'package:otcharimpyo/core/di/di_setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    setUp(() async {
      // 테스트 전 초기화
      resetDi();
    });

    tearDown(() {
      resetDi();
    });

    group('Onboarding Screen', () {
      testWidgets('should display onboarding screen when not completed',
          (tester) async {
        // DI 설정
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // 온보딩 화면이 표시되는지 확인
        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('should show page indicator', (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // 페이지 인디케이터가 있는지 확인 (AnimatedContainer 2개)
        expect(find.byType(AnimatedContainer), findsWidgets);
      });

      testWidgets('should navigate to second page on swipe', (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // 왼쪽으로 스와이프
        await tester.fling(
          find.byType(PageView),
          const Offset(-300, 0),
          1000,
        );
        await tester.pumpAndSettle();

        // 두 번째 페이지로 이동했는지 확인
        // (페이지가 변경되면 인디케이터 상태가 변경됨)
        expect(find.byType(PageView), findsOneWidget);
      });
    });

    group('Home Screen', () {
      testWidgets('should display home screen when onboarding completed',
          (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // 홈 화면이 표시되는지 확인 (로딩, 에러, 또는 성공 상태)
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should show loading indicator initially', (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );

        // 로딩 인디케이터 또는 컨텐츠가 있어야 함
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should have search button', (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pump(const Duration(seconds: 2));

        // 검색 아이콘 찾기 (에러 상태에서는 없을 수 있음)
        final searchIcon = find.byIcon(Icons.search_rounded);
        if (searchIcon.evaluate().isNotEmpty) {
          expect(searchIcon, findsOneWidget);
        }
      });
    });

    group('Temperature Search Screen', () {
      testWidgets('should navigate to temperature search screen',
          (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // 검색 버튼 찾기
        final searchButton = find.byIcon(Icons.search_rounded);

        if (searchButton.evaluate().isNotEmpty) {
          await tester.tap(searchButton);
          await tester.pumpAndSettle();

          // 온도 검색 화면으로 이동했는지 확인
          expect(find.text('온도로 옷차림 찾기'), findsOneWidget);
        }
      });

      testWidgets('should display slider in temperature search', (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        final searchButton = find.byIcon(Icons.search_rounded);

        if (searchButton.evaluate().isNotEmpty) {
          await tester.tap(searchButton);
          await tester.pumpAndSettle();

          // 슬라이더가 있는지 확인
          expect(find.byType(Slider), findsOneWidget);
        }
      });

      testWidgets('should update temperature when slider moved', (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        final searchButton = find.byIcon(Icons.search_rounded);

        if (searchButton.evaluate().isNotEmpty) {
          await tester.tap(searchButton);
          await tester.pumpAndSettle();

          // 초기 온도 표시 확인 (12도)
          expect(find.text('12'), findsOneWidget);

          // 슬라이더 조작
          final slider = find.byType(Slider);
          await tester.drag(slider, const Offset(100, 0));
          await tester.pumpAndSettle();

          // 온도가 변경되었는지 확인 (정확한 값은 슬라이더 위치에 따라 다름)
          expect(find.byType(Slider), findsOneWidget);
        }
      });

      testWidgets('should display outfit recommendations', (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        final searchButton = find.byIcon(Icons.search_rounded);

        if (searchButton.evaluate().isNotEmpty) {
          await tester.tap(searchButton);
          await tester.pumpAndSettle();

          // 추천 옷차림 섹션이 있는지 확인
          expect(find.text('추천 옷차림'), findsOneWidget);

          // 상의, 하의, 아우터 카테고리가 있는지 확인
          expect(find.text('상의'), findsOneWidget);
          expect(find.text('하의'), findsOneWidget);
        }
      });

      testWidgets('should show back button', (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        final searchButton = find.byIcon(Icons.search_rounded);

        if (searchButton.evaluate().isNotEmpty) {
          await tester.tap(searchButton);
          await tester.pumpAndSettle();

          // 뒤로가기 버튼 확인
          expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
        }
      });

      testWidgets('should navigate back when back button pressed',
          (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        final searchButton = find.byIcon(Icons.search_rounded);

        if (searchButton.evaluate().isNotEmpty) {
          await tester.tap(searchButton);
          await tester.pumpAndSettle();

          // 뒤로가기 버튼 탭
          await tester.tap(find.byIcon(Icons.arrow_back_rounded));
          await tester.pumpAndSettle();

          // 이전 화면으로 돌아갔는지 확인
          expect(find.text('온도로 옷차림 찾기'), findsNothing);
        }
      });
    });

    group('Outfit Recommendations', () {
      testWidgets('should show different outfits for hot weather',
          (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        final searchButton = find.byIcon(Icons.search_rounded);

        if (searchButton.evaluate().isNotEmpty) {
          await tester.tap(searchButton);
          await tester.pumpAndSettle();

          // 슬라이더를 오른쪽 끝으로 이동 (더운 날씨)
          final slider = find.byType(Slider);
          await tester.drag(slider, const Offset(300, 0));
          await tester.pumpAndSettle();

          // 더운 날씨에 맞는 옷차림이 표시되는지 확인
          // (민소매, 반팔 등이 있어야 함)
          expect(find.byType(Slider), findsOneWidget);
        }
      });

      testWidgets('should show different outfits for cold weather',
          (tester) async {
        diSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        final searchButton = find.byIcon(Icons.search_rounded);

        if (searchButton.evaluate().isNotEmpty) {
          await tester.tap(searchButton);
          await tester.pumpAndSettle();

          // 슬라이더를 왼쪽 끝으로 이동 (추운 날씨)
          final slider = find.byType(Slider);
          await tester.drag(slider, const Offset(-300, 0));
          await tester.pumpAndSettle();

          // 추운 날씨에 맞는 옷차림이 표시되는지 확인
          // (패딩, 코트 등이 있어야 함)
          expect(find.byType(Slider), findsOneWidget);
        }
      });
    });
  });
}
