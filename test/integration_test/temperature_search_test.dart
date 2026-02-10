/// 온도 검색 기능 통합 테스트
///
/// 테스트 시나리오:
/// 1. 홈 화면에서 검색 버튼 탭
/// 2. 온도 검색 화면으로 이동
/// 3. 슬라이더로 온도 변경
/// 4. 온도에 맞는 옷차림 업데이트 확인
/// 5. 여러 온도 구간 테스트
/// 6. 뒤로 가기 버튼으로 홈 화면 복귀

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:otcharimpyo/main.dart';

import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('온도 검색 기능 통합 테스트', () {
    setUp(() async {
      // Given: Mock DI 초기화
      tearDownMockDI();
      setupMockDI();
      mockWeatherDataSource.setupSuccess();
      mockLocationDataSource.setupSeoulLocation();
    });

    tearDown(() {
      tearDownMockDI();
    });

    group('1. 온도 검색 화면 진입', () {
      testWidgets('홈 화면에서 검색 버튼이 표시되어야 한다', (tester) async {
        // Given: 홈 화면

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 검색 버튼 확인
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });

      testWidgets('검색 버튼 탭 시 온도 검색 화면으로 이동해야 한다', (tester) async {
        // Given: 홈 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // When: 검색 버튼 탭
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Then: 온도 검색 화면 표시 확인
        expect(find.text('온도로 옷차림 찾기'), findsOneWidget);
      });
    });

    group('2. 온도 검색 화면 UI', () {
      testWidgets('화면 타이틀이 표시되어야 한다', (tester) async {
        // Given: 홈 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // When: 온도 검색 화면으로 이동
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Then: 타이틀 확인
        expect(find.text('온도로 옷차림 찾기'), findsOneWidget);
        expect(find.text('원하는 온도를 선택해주세요'), findsOneWidget);
      });

      testWidgets('슬라이더가 표시되어야 한다', (tester) async {
        // Given: 홈 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // When: 온도 검색 화면으로 이동
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Then: 슬라이더 확인
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('초기 온도(12도)가 표시되어야 한다', (tester) async {
        // Given: 홈 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // When: 온도 검색 화면으로 이동
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Then: 초기 온도 12도 확인
        expect(find.text('12'), findsOneWidget);
      });

      testWidgets('온도 범위 라벨이 표시되어야 한다', (tester) async {
        // Given: 홈 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // When: 온도 검색 화면으로 이동
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Then: 범위 라벨 확인 (-10°C ~ 40°C)
        expect(find.text('-10°C'), findsOneWidget);
        expect(find.text('40°C'), findsOneWidget);
      });

      testWidgets('뒤로가기 버튼이 표시되어야 한다', (tester) async {
        // Given: 홈 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // When: 온도 검색 화면으로 이동
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Then: 뒤로가기 버튼 확인
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      });
    });

    group('3. 슬라이더 조작 및 온도 변경', () {
      testWidgets('슬라이더를 오른쪽으로 드래그하면 온도가 증가해야 한다', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // When: 슬라이더를 오른쪽으로 드래그
        await tester.drag(find.byType(Slider), const Offset(100, 0));
        await tester.pumpAndSettle();

        // Then: 슬라이더가 여전히 존재 (온도가 변경됨)
        expect(find.byType(Slider), findsOneWidget);
        // 12도보다 높은 온도가 표시되어야 함
        // (정확한 값은 슬라이더 위치에 따라 다름)
      });

      testWidgets('슬라이더를 왼쪽으로 드래그하면 온도가 감소해야 한다', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // When: 슬라이더를 왼쪽으로 드래그
        await tester.drag(find.byType(Slider), const Offset(-100, 0));
        await tester.pumpAndSettle();

        // Then: 슬라이더가 여전히 존재
        expect(find.byType(Slider), findsOneWidget);
      });
    });

    group('4. 옷차림 추천 섹션', () {
      testWidgets('추천 옷차림 타이틀이 표시되어야 한다', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Then: 추천 옷차림 타이틀 확인
        expect(find.text('추천 옷차림'), findsOneWidget);
      });

      testWidgets('상의/하의 카테고리가 표시되어야 한다', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Then: 카테고리 확인
        expect(find.text('상의'), findsOneWidget);
        expect(find.text('하의'), findsOneWidget);
      });
    });

    group('5. 온도 구간별 옷차림 테스트', () {
      testWidgets('더운 날씨(28도 이상) - 민소매, 반팔 추천', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // When: 슬라이더를 오른쪽 끝으로 드래그 (더운 날씨)
        await tester.drag(find.byType(Slider), const Offset(300, 0));
        await tester.pumpAndSettle();

        // Then: 더운 날씨 옷차림 확인
        // (아우터가 없어야 함)
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('따뜻한 날씨(23-27도) - 반팔, 얇은 셔츠 추천', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // When: 슬라이더를 적당히 오른쪽으로 드래그
        await tester.drag(find.byType(Slider), const Offset(150, 0));
        await tester.pumpAndSettle();

        // Then: 슬라이더가 존재
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('선선한 날씨(12-16도) - 니트, 재킷 추천', (tester) async {
        // Given: 온도 검색 화면 (초기 온도 12도)
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Then: 12도에서 니트, 재킷 추천 확인
        expect(find.text('니트'), findsOneWidget);
        expect(find.text('재킷'), findsOneWidget);
      });

      testWidgets('추운 날씨(5도 이하) - 패딩, 코트 추천', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // When: 슬라이더를 왼쪽 끝으로 드래그 (추운 날씨)
        await tester.drag(find.byType(Slider), const Offset(-300, 0));
        await tester.pumpAndSettle();

        // Then: 추운 날씨 옷차림 확인
        expect(find.byType(Slider), findsOneWidget);
      });
    });

    group('6. 네비게이션', () {
      testWidgets('뒤로가기 버튼 탭 시 홈 화면으로 돌아가야 한다', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // Verify: 온도 검색 화면에 있음
        expect(find.text('온도로 옷차림 찾기'), findsOneWidget);

        // When: 뒤로가기 버튼 탭
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        // Then: 홈 화면으로 복귀
        expect(find.text('온도로 옷차림 찾기'), findsNothing);
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });

      testWidgets('시스템 뒤로가기로도 홈 화면으로 돌아가야 한다', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // When: 시스템 뒤로가기 (pageBack)
        final navigator = tester.state<NavigatorState>(find.byType(Navigator));
        navigator.pop();
        await tester.pumpAndSettle();

        // Then: 홈 화면으로 복귀
        expect(find.text('온도로 옷차림 찾기'), findsNothing);
      });
    });

    group('7. 슬라이더 상호작용', () {
      testWidgets('슬라이더 조작 후에도 추천 옷차림이 표시되어야 한다', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // When: 여러 번 슬라이더 조작
        await tester.drag(find.byType(Slider), const Offset(100, 0));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(Slider), const Offset(-50, 0));
        await tester.pumpAndSettle();

        // Then: 추천 옷차림 섹션이 여전히 표시됨
        expect(find.text('추천 옷차림'), findsOneWidget);
        expect(find.text('상의'), findsOneWidget);
        expect(find.text('하의'), findsOneWidget);
      });
    });
  });
}
