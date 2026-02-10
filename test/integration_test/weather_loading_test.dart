/// 날씨 정보 로딩 통합 테스트
///
/// 테스트 시나리오:
/// 1. 홈 화면 진입
/// 2. 로딩 상태 표시 확인
/// 3. 위치 정보 가져오기 성공
/// 4. 날씨 API 호출 성공
/// 5. 날씨 정보 화면에 표시 확인
/// 6. 추천 옷차림 표시 확인
/// 7. 새로고침 기능 테스트

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:otcharimpyo/main.dart';

import 'helpers/test_helpers.dart';
import 'helpers/mock_weather_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('날씨 정보 로딩 통합 테스트', () {
    setUp(() async {
      // Given: Mock DI 초기화
      tearDownMockDI();
      setupMockDI();
    });

    tearDown(() {
      tearDownMockDI();
    });

    group('1. 홈 화면 진입 및 로딩', () {
      testWidgets('홈 화면 진입 시 Scaffold가 표시되어야 한다', (tester) async {
        // Given: 온보딩 완료 상태
        mockWeatherDataSource.setupSuccess();
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );

        // Then: 기본 화면 구조 확인
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('데이터 로딩 후 성공 상태로 전환되어야 한다', (tester) async {
        // Given: Mock 데이터 설정
        mockWeatherDataSource.setupSuccess(
          temp: 22.0,
          feelsLike: 23.0,
          humidity: 55,
        );
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행 및 로딩 완료 대기
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 검색 버튼이 보이면 성공 상태
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });

    group('2. 위치 정보 표시', () {
      testWidgets('위치 정보가 화면에 표시되어야 한다', (tester) async {
        // Given: 서울 위치 설정
        mockWeatherDataSource.setupSuccess();
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행 및 로딩 완료 대기
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 위치 정보 표시 확인 (서울특별시 포함)
        expect(find.textContaining('서울특별시'), findsOneWidget);
      });

      testWidgets('위치 아이콘이 표시되어야 한다', (tester) async {
        // Given: Mock 데이터 설정
        mockWeatherDataSource.setupSuccess();
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 위치 아이콘 확인
        expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);
      });

      testWidgets('다른 도시 위치도 올바르게 표시되어야 한다', (tester) async {
        // Given: 부산 위치 설정
        mockWeatherDataSource.setupSuccess();
        mockLocationDataSource.setupBusanLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 부산 위치 표시 확인
        expect(find.textContaining('부산광역시'), findsOneWidget);
      });
    });

    group('3. 온도 정보 표시', () {
      testWidgets('온도가 화면에 표시되어야 한다', (tester) async {
        // Given: 22도 설정
        mockWeatherDataSource.setupSuccess(temp: 22.0);
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 온도 표시 확인
        expect(find.textContaining('22'), findsWidgets);
      });

      testWidgets('영하 온도도 올바르게 표시되어야 한다', (tester) async {
        // Given: -5도 설정
        mockWeatherDataSource.setupSuccess(temp: -5.0);
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 영하 온도 표시 확인
        expect(find.textContaining('-5'), findsWidgets);
      });
    });

    group('4. 날씨 상세 정보 표시', () {
      testWidgets('체감온도가 표시되어야 한다', (tester) async {
        // Given: 체감온도 23도 설정
        mockWeatherDataSource.setupSuccess(feelsLike: 23.0);
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 체감온도 라벨 확인
        expect(find.text('체감온도'), findsOneWidget);
      });

      testWidgets('습도가 표시되어야 한다', (tester) async {
        // Given: 습도 55% 설정
        mockWeatherDataSource.setupSuccess(humidity: 55);
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 습도 라벨 확인
        expect(find.text('습도'), findsOneWidget);
      });

      testWidgets('강수량이 표시되어야 한다', (tester) async {
        // Given: 강수량 설정
        mockWeatherDataSource.setupSuccess(precipitation: 0.0);
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 강수량 라벨 확인
        expect(find.text('강수량'), findsOneWidget);
      });
    });

    group('5. 옷차림 추천 표시', () {
      testWidgets('추천 옷차림 섹션이 표시되어야 한다', (tester) async {
        // Given: Mock 데이터 설정
        mockWeatherDataSource.setupSuccess(temp: 15.0);
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 추천 옷차림 타이틀 확인
        expect(find.text('오늘의 추천 옷차림'), findsOneWidget);
      });

      testWidgets('상의 카테고리가 표시되어야 한다', (tester) async {
        // Given: Mock 데이터 설정
        mockWeatherDataSource.setupSuccess(temp: 15.0);
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 상의 카테고리 확인
        expect(find.text('상의'), findsOneWidget);
      });

      testWidgets('하의 카테고리가 표시되어야 한다', (tester) async {
        // Given: Mock 데이터 설정
        mockWeatherDataSource.setupSuccess(temp: 15.0);
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 하의 카테고리 확인
        expect(find.text('하의'), findsOneWidget);
      });

      testWidgets('더운 날씨(28도 이상)에 적절한 옷차림이 추천되어야 한다', (tester) async {
        // Given: 30도 설정 (더운 날씨)
        mockWeatherDataSource.setupSuccess(temp: 30.0);
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 여름 옷차림 확인
        expect(find.text('민소매'), findsOneWidget);
        expect(find.text('반팔'), findsOneWidget);
      });

      testWidgets('추운 날씨(5도 이하)에 적절한 옷차림이 추천되어야 한다', (tester) async {
        // Given: 2도 설정 (추운 날씨)
        mockWeatherDataSource.setupSuccess(temp: 2.0);
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 겨울 옷차림 확인
        expect(find.text('패딩'), findsOneWidget);
      });
    });

    group('6. 인사말 표시', () {
      testWidgets('시간대에 맞는 인사말이 표시되어야 한다', (tester) async {
        // Given: Mock 데이터 설정
        mockWeatherDataSource.setupSuccess();
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 인사말 중 하나가 표시되어야 함
        final hasGreeting =
            find.text('좋은 아침입니다!').evaluate().isNotEmpty ||
                find.text('좋은 오후입니다!').evaluate().isNotEmpty ||
                find.text('좋은 저녁입니다!').evaluate().isNotEmpty;
        expect(hasGreeting, isTrue);
      });
    });

    group('7. 새로고침 기능', () {
      testWidgets('RefreshIndicator가 존재해야 한다', (tester) async {
        // Given: Mock 데이터 설정
        mockWeatherDataSource.setupSuccess();
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: RefreshIndicator 확인
        expect(find.byType(RefreshIndicator), findsOneWidget);
      });
    });

    group('8. 다양한 날씨 조건', () {
      testWidgets('비오는 날씨 데이터가 올바르게 표시되어야 한다', (tester) async {
        // Given: 비오는 날씨 설정
        mockWeatherDataSource.mockResponse = WeatherTestData.rainyWeather;
        mockLocationDataSource.setupSeoulLocation();

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 강수량이 표시됨
        expect(find.text('강수량'), findsOneWidget);
      });
    });
  });
}
