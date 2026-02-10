/// 온보딩 플로우 통합 테스트
///
/// 테스트 시나리오:
/// 1. 앱 최초 실행 시 온보딩 화면 표시
/// 2. 첫 번째 페이지에서 "시작하기" 버튼 탭
/// 3. 두 번째 페이지로 이동 확인
/// 4. "위치 정보 허용하기" 버튼 탭
/// 5. 온보딩 완료 후 홈 화면으로 이동

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:otcharimpyo/main.dart';

import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('온보딩 플로우 통합 테스트', () {
    setUp(() async {
      // Given: Mock DI 초기화
      tearDownMockDI();
      setupMockDI();
    });

    tearDown(() {
      tearDownMockDI();
    });

    group('1. 앱 최초 실행', () {
      testWidgets('온보딩 화면이 표시되어야 한다', (tester) async {
        // Given: 온보딩 미완료 상태

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 온보딩 화면 표시 확인
        expect(find.byType(PageView), findsOneWidget);
        expect(find.text('옷차림표\n오늘의 옷을 골라요'), findsOneWidget);
      });

      testWidgets('페이지 인디케이터가 표시되어야 한다', (tester) async {
        // Given: 온보딩 미완료 상태

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 페이지 인디케이터 (AnimatedContainer) 확인
        expect(find.byType(AnimatedContainer), findsWidgets);
      });

      testWidgets('첫 페이지에 "시작하기" 버튼이 표시되어야 한다', (tester) async {
        // Given: 온보딩 미완료 상태

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // Then: "시작하기" 버튼 표시 확인
        expect(find.text('시작하기'), findsOneWidget);
      });
    });

    group('2. 첫 번째 페이지 → 두 번째 페이지 이동', () {
      testWidgets('"시작하기" 버튼 탭 시 두 번째 페이지로 이동해야 한다', (tester) async {
        // Given: 온보딩 첫 번째 페이지
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // When: "시작하기" 버튼 탭
        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        // Then: 두 번째 페이지로 이동 확인
        expect(find.text('지금 계신 곳을\n알려주세요 📍'), findsOneWidget);
        expect(find.text('위치 정보 허용하기'), findsOneWidget);
      });

      testWidgets('스와이프로 두 번째 페이지로 이동할 수 있어야 한다', (tester) async {
        // Given: 온보딩 첫 번째 페이지
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // When: 왼쪽으로 스와이프
        await tester.fling(
          find.byType(PageView),
          const Offset(-300, 0),
          1000,
        );
        await tester.pumpAndSettle();

        // Then: 두 번째 페이지로 이동 확인
        expect(find.text('위치 정보 허용하기'), findsOneWidget);
      });
    });

    group('3. 두 번째 페이지 콘텐츠', () {
      testWidgets('두 번째 페이지에 올바른 타이틀이 표시되어야 한다', (tester) async {
        // Given: 온보딩 첫 번째 페이지
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // When: 두 번째 페이지로 이동
        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        // Then: 타이틀 및 서브타이틀 확인
        expect(find.text('지금 계신 곳을\n알려주세요 📍'), findsOneWidget);
        expect(
          find.text('현재 위치의 기온을 알고\n어울리는 옷차림을 추천합니다.'),
          findsOneWidget,
        );
      });

      testWidgets('두 번째 페이지에 "위치 정보 허용하기" 버튼이 표시되어야 한다', (tester) async {
        // Given: 온보딩 첫 번째 페이지
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // When: 두 번째 페이지로 이동
        await tester.fling(
          find.byType(PageView),
          const Offset(-300, 0),
          1000,
        );
        await tester.pumpAndSettle();

        // Then: 버튼 확인
        expect(find.text('위치 정보 허용하기'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsWidgets);
      });
    });

    group('4. 위치 권한 처리 및 홈 화면 이동', () {
      testWidgets('"위치 정보 허용하기" 탭 후 홈 화면으로 이동해야 한다', (tester) async {
        // Given: 위치 권한 허용 상태 설정
        mockLocationDataSource.setupSeoulLocation();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // 두 번째 페이지로 이동
        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        // When: "위치 정보 허용하기" 버튼 탭
        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        // Then: 홈 화면으로 이동 (Scaffold가 있는 홈 화면)
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('5. 온보딩 완료 후 재실행', () {
      testWidgets('온보딩 완료 상태에서 앱 실행 시 바로 홈 화면으로 이동해야 한다', (tester) async {
        // Given: 온보딩 완료 상태

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 홈 화면 직접 표시 (온보딩 스킵)
        expect(find.byType(PageView), findsNothing); // 온보딩 페이지뷰 없음
        expect(find.byType(Scaffold), findsOneWidget); // 홈 화면 표시
      });

      testWidgets('홈 화면에서 검색 버튼이 표시되어야 한다', (tester) async {
        // Given: 온보딩 완료 상태
        mockWeatherDataSource.setupSuccess();
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 검색 버튼 표시
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });

    group('6. 페이지 전환 애니메이션', () {
      testWidgets('페이지 전환 시 애니메이션이 부드럽게 동작해야 한다', (tester) async {
        // Given: 온보딩 첫 번째 페이지
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // When: 스와이프 시작
        final gesture = await tester.startGesture(const Offset(300, 400));
        await gesture.moveBy(const Offset(-100, 0));
        await tester.pump();

        // Then: 중간 상태에서 두 페이지 모두 부분적으로 보임
        // (PageView 내부 상태 확인)
        expect(find.byType(PageView), findsOneWidget);

        // 스와이프 완료
        await gesture.moveBy(const Offset(-200, 0));
        await gesture.up();
        await tester.pumpAndSettle();

        // 두 번째 페이지 표시
        expect(find.text('위치 정보 허용하기'), findsOneWidget);
      });
    });
  });
}
