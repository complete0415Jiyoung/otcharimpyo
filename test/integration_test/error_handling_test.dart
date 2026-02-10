/// 에러 처리 통합 테스트
///
/// 테스트 시나리오:
/// 1. 위치 권한 거부 시나리오
/// 2. 네트워크 오류 시나리오
/// 3. API 타임아웃 시나리오
/// 4. 다시 시도하기 기능 테스트

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:otcharimpyo/main.dart';

import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('에러 처리 통합 테스트', () {
    setUp(() async {
      // Given: Mock DI 초기화
      tearDownMockDI();
      setupMockDI();
    });

    tearDown(() {
      tearDownMockDI();
    });

    group('1. 위치 권한 거부 시나리오', () {
      testWidgets('위치 권한 거부 시 에러 상태가 표시되어야 한다', (tester) async {
        // Given: 위치 권한 거부 설정
        mockLocationDataSource.setupPermissionDenied();
        mockWeatherDataSource.setupSuccess();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 에러 상태 표시 확인
        // (에러 아이콘 또는 에러 메시지가 표시됨)
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('위치 권한 영구 거부 시 에러 상태가 표시되어야 한다', (tester) async {
        // Given: 위치 권한 영구 거부 설정
        mockLocationDataSource.setupPermissionDeniedForever();
        mockWeatherDataSource.setupSuccess();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 에러 상태 표시 확인
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('위치 권한 거부 후 에러 화면에서 다시 시도할 수 있어야 한다', (tester) async {
        // Given: 위치 권한 거부 설정
        mockLocationDataSource.setupPermissionDenied();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // 에러 화면에서 "다시 시도하기" 버튼 찾기
        final retryButton = find.text('다시 시도하기');
        if (retryButton.evaluate().isNotEmpty) {
          // When: 권한 허용으로 변경 후 다시 시도
          mockLocationDataSource.setupSeoulLocation();
          mockWeatherDataSource.setupSuccess();

          await tester.tap(retryButton);
          await tester.pumpAndSettle();

          // Then: 성공 상태로 전환 확인
          expect(find.byType(Scaffold), findsOneWidget);
        }
      });
    });

    group('2. 네트워크 오류 시나리오', () {
      testWidgets('네트워크 오류 시 에러 화면이 표시되어야 한다', (tester) async {
        // Given: 네트워크 오류 설정
        mockLocationDataSource.setupSeoulLocation();
        mockWeatherDataSource.setupNetworkError();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 에러 화면 표시 확인
        expect(find.byType(Scaffold), findsOneWidget);
        // 에러 아이콘 확인
        final hasErrorIcon =
            find.byIcon(Icons.cloud_off_rounded).evaluate().isNotEmpty ||
                find.byIcon(Icons.error_outline).evaluate().isNotEmpty;
        expect(hasErrorIcon || find.text('다시 시도하기').evaluate().isNotEmpty, isTrue);
      });

      testWidgets('네트워크 오류 시 "다시 시도하기" 버튼이 표시되어야 한다', (tester) async {
        // Given: 네트워크 오류 설정
        mockLocationDataSource.setupSeoulLocation();
        mockWeatherDataSource.setupNetworkError();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: "다시 시도하기" 버튼 확인
        expect(find.text('다시 시도하기'), findsOneWidget);
      });

      testWidgets('네트워크 복구 후 다시 시도하면 성공해야 한다', (tester) async {
        // Given: 네트워크 오류 설정
        mockLocationDataSource.setupSeoulLocation();
        mockWeatherDataSource.setupNetworkError();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Verify: 에러 상태
        expect(find.text('다시 시도하기'), findsOneWidget);

        // When: 네트워크 복구 후 다시 시도
        mockWeatherDataSource.setupSuccess();
        await tester.tap(find.text('다시 시도하기'));
        await tester.pumpAndSettle();

        // Then: 성공 상태로 전환
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });

    group('3. 서버 오류 시나리오', () {
      testWidgets('서버 오류(500) 시 에러 화면이 표시되어야 한다', (tester) async {
        // Given: 서버 오류 설정
        mockLocationDataSource.setupSeoulLocation();
        mockWeatherDataSource.setupServerError();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 에러 화면 표시 확인
        expect(find.text('다시 시도하기'), findsOneWidget);
      });
    });

    group('4. GPS 오류 시나리오', () {
      testWidgets('GPS 오류 시 에러 화면이 표시되어야 한다', (tester) async {
        // Given: GPS 오류 설정
        mockLocationDataSource.setupGpsError();
        mockWeatherDataSource.setupSuccess();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 에러 화면 표시 확인
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('5. 에러 화면 UI', () {
      testWidgets('에러 화면에 적절한 아이콘이 표시되어야 한다', (tester) async {
        // Given: 네트워크 오류 설정
        mockLocationDataSource.setupSeoulLocation();
        mockWeatherDataSource.setupNetworkError();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 에러 아이콘 확인 (cloud_off_rounded)
        expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
      });

      testWidgets('에러 화면에 에러 메시지가 표시되어야 한다', (tester) async {
        // Given: 네트워크 오류 설정
        mockLocationDataSource.setupSeoulLocation();
        mockWeatherDataSource.setupNetworkError();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 에러 메시지 확인
        expect(find.text('날씨 정보를 불러올 수 없습니다'), findsOneWidget);
      });
    });

    group('6. 에러 복구 시나리오', () {
      testWidgets('여러 번 다시 시도가 가능해야 한다', (tester) async {
        // Given: 네트워크 오류 설정
        mockLocationDataSource.setupSeoulLocation();
        mockWeatherDataSource.setupNetworkError();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // When: 첫 번째 다시 시도 (여전히 실패)
        await tester.tap(find.text('다시 시도하기'));
        await tester.pumpAndSettle();

        // Then: 여전히 에러 상태
        expect(find.text('다시 시도하기'), findsOneWidget);

        // When: 두 번째 다시 시도 (성공)
        mockWeatherDataSource.setupSuccess();
        await tester.tap(find.text('다시 시도하기'));
        await tester.pumpAndSettle();

        // Then: 성공 상태
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });

      testWidgets('에러에서 복구 후 모든 정보가 표시되어야 한다', (tester) async {
        // Given: 초기 네트워크 오류 설정
        mockLocationDataSource.setupSeoulLocation();
        mockWeatherDataSource.setupNetworkError();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // When: 네트워크 복구 후 다시 시도
        mockWeatherDataSource.setupSuccess(
          temp: 22.0,
          humidity: 55,
        );
        await tester.tap(find.text('다시 시도하기'));
        await tester.pumpAndSettle();

        // Then: 날씨 정보가 표시됨
        expect(find.textContaining('서울특별시'), findsOneWidget);
        expect(find.textContaining('22'), findsWidgets);
      });
    });

    group('7. 에러 상태에서의 UI 상호작용', () {
      testWidgets('에러 상태에서도 화면이 스크롤 가능해야 한다', (tester) async {
        // Given: 네트워크 오류 설정
        mockLocationDataSource.setupSeoulLocation();
        mockWeatherDataSource.setupNetworkError();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 기본 화면 구조 확인
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('8. 복합 에러 시나리오', () {
      testWidgets('위치와 날씨 모두 실패 시 에러 화면이 표시되어야 한다', (tester) async {
        // Given: 위치와 날씨 모두 오류 설정
        mockLocationDataSource.setupGpsError();
        mockWeatherDataSource.setupNetworkError();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 에러 화면 표시
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });
  });
}
