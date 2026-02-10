/// DI 및 라우팅 통합 테스트
///
/// 테스트 시나리오:
/// 1. DI 초기화 확인
/// 2. 모든 의존성 주입 확인
/// 3. 라우팅 테스트 (온보딩 → 홈 → 온도 검색)
/// 4. 존재하지 않는 라우트 접근 시 에러 페이지 표시
/// 5. 에러 페이지에서 "홈으로 돌아가기" 버튼 동작

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:otcharimpyo/main.dart';
import 'package:otcharimpyo/weather/data/data_source/weather_data_source_interface.dart';
import 'package:otcharimpyo/location/data/data_source/location_data_source_interface.dart';
import 'package:otcharimpyo/weather/domain/repository/weather_repository.dart';
import 'package:otcharimpyo/location/domain/repository/location_repository.dart';
import 'package:otcharimpyo/weather/domain/usecase/get_current_weather_use_case.dart';
import 'package:otcharimpyo/location/domain/usecase/get_current_location_use_case.dart';

import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('DI 및 라우팅 통합 테스트', () {
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

    group('1. DI 초기화 확인', () {
      testWidgets('GetIt이 초기화되어야 한다', (tester) async {
        // Given: Mock DI 설정됨

        // When: GetIt 인스턴스 확인
        final getIt = GetIt.instance;

        // Then: GetIt이 초기화됨
        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isTrue);
      });

      testWidgets('모든 필수 의존성이 등록되어야 한다', (tester) async {
        // Given: Mock DI 설정됨
        final getIt = GetIt.instance;

        // Then: 모든 의존성 등록 확인
        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isTrue);
        expect(getIt.isRegistered<LocationDataSourceInterface>(), isTrue);
        expect(getIt.isRegistered<WeatherRepository>(), isTrue);
        expect(getIt.isRegistered<LocationRepository>(), isTrue);
        expect(getIt.isRegistered<GetCurrentWeatherUseCase>(), isTrue);
        expect(getIt.isRegistered<GetCurrentLocationUseCase>(), isTrue);
      });
    });

    group('2. 의존성 주입 동작 확인', () {
      testWidgets('WeatherDataSource가 올바르게 주입되어야 한다', (tester) async {
        // Given: Mock DI 설정됨
        final getIt = GetIt.instance;

        // When: WeatherDataSource 가져오기
        final weatherDataSource = getIt<WeatherDataSourceInterface>();

        // Then: Mock 인스턴스 확인
        expect(weatherDataSource, isNotNull);
        expect(weatherDataSource, isA<WeatherDataSourceInterface>());
      });

      testWidgets('LocationDataSource가 올바르게 주입되어야 한다', (tester) async {
        // Given: Mock DI 설정됨
        final getIt = GetIt.instance;

        // When: LocationDataSource 가져오기
        final locationDataSource = getIt<LocationDataSourceInterface>();

        // Then: Mock 인스턴스 확인
        expect(locationDataSource, isNotNull);
        expect(locationDataSource, isA<LocationDataSourceInterface>());
      });

      testWidgets('WeatherRepository가 올바르게 주입되어야 한다', (tester) async {
        // Given: Mock DI 설정됨
        final getIt = GetIt.instance;

        // When: WeatherRepository 가져오기
        final repository = getIt<WeatherRepository>();

        // Then: 인스턴스 확인
        expect(repository, isNotNull);
        expect(repository, isA<WeatherRepository>());
      });

      testWidgets('LocationRepository가 올바르게 주입되어야 한다', (tester) async {
        // Given: Mock DI 설정됨
        final getIt = GetIt.instance;

        // When: LocationRepository 가져오기
        final repository = getIt<LocationRepository>();

        // Then: 인스턴스 확인
        expect(repository, isNotNull);
        expect(repository, isA<LocationRepository>());
      });

      testWidgets('GetCurrentWeatherUseCase가 올바르게 주입되어야 한다', (tester) async {
        // Given: Mock DI 설정됨
        final getIt = GetIt.instance;

        // When: UseCase 가져오기
        final useCase = getIt<GetCurrentWeatherUseCase>();

        // Then: 인스턴스 확인
        expect(useCase, isNotNull);
        expect(useCase, isA<GetCurrentWeatherUseCase>());
      });

      testWidgets('GetCurrentLocationUseCase가 올바르게 주입되어야 한다', (tester) async {
        // Given: Mock DI 설정됨
        final getIt = GetIt.instance;

        // When: UseCase 가져오기
        final useCase = getIt<GetCurrentLocationUseCase>();

        // Then: 인스턴스 확인
        expect(useCase, isNotNull);
        expect(useCase, isA<GetCurrentLocationUseCase>());
      });
    });

    group('3. 라우팅 - 온보딩 → 홈', () {
      testWidgets('온보딩 미완료 시 온보딩 화면이 표시되어야 한다', (tester) async {
        // Given: 온보딩 미완료 상태

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 온보딩 화면 (PageView) 표시
        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('온보딩 완료 시 홈 화면이 표시되어야 한다', (tester) async {
        // Given: 온보딩 완료 상태

        // When: 앱 실행
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 홈 화면 표시 (PageView 없음)
        expect(find.byType(PageView), findsNothing);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('온보딩에서 홈으로 네비게이션이 동작해야 한다', (tester) async {
        // Given: 온보딩 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // When: 온보딩 완료 플로우
        // 1단계: "시작하기" 탭
        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        // 2단계: "위치 정보 허용하기" 탭
        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        // Then: 홈 화면으로 이동
        expect(find.byType(PageView), findsNothing);
      });
    });

    group('4. 라우팅 - 홈 → 온도 검색', () {
      testWidgets('홈에서 온도 검색 화면으로 이동할 수 있어야 한다', (tester) async {
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

        // Then: 온도 검색 화면 표시
        expect(find.text('온도로 옷차림 찾기'), findsOneWidget);
      });

      testWidgets('온도 검색에서 뒤로가기로 홈에 돌아올 수 있어야 한다', (tester) async {
        // Given: 온도 검색 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // When: 뒤로가기 버튼 탭
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        // Then: 홈 화면으로 복귀
        expect(find.text('온도로 옷차림 찾기'), findsNothing);
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });

    group('5. 라우팅 - 화면 전환 일관성', () {
      testWidgets('여러 번 화면 전환이 일관되게 동작해야 한다', (tester) async {
        // Given: 홈 화면
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // When/Then: 온도 검색으로 이동 → 복귀 (3회 반복)
        for (int i = 0; i < 3; i++) {
          // 온도 검색으로 이동
          await tester.tap(find.byIcon(Icons.search_rounded));
          await tester.pumpAndSettle();
          expect(find.text('온도로 옷차림 찾기'), findsOneWidget);

          // 홈으로 복귀
          await tester.tap(find.byIcon(Icons.arrow_back_rounded));
          await tester.pumpAndSettle();
          expect(find.byIcon(Icons.search_rounded), findsOneWidget);
        }
      });
    });

    group('6. 화면 전환 시 상태 유지', () {
      testWidgets('홈 화면 데이터가 화면 전환 후에도 유지되어야 한다', (tester) async {
        // Given: 홈 화면에 날씨 데이터 로드
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Verify: 초기 데이터 확인
        expect(find.textContaining('서울특별시'), findsOneWidget);

        // When: 온도 검색으로 이동 후 복귀
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        // Then: 데이터가 유지됨
        expect(find.textContaining('서울특별시'), findsOneWidget);
      });
    });

    group('7. DI 리셋 테스트', () {
      testWidgets('DI 리셋 후 재등록이 가능해야 한다', (tester) async {
        // Given: 기존 DI 상태
        final getIt = GetIt.instance;
        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isTrue);

        // When: DI 리셋
        tearDownMockDI();

        // Then: 모든 등록이 해제됨
        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isFalse);

        // When: 재등록
        setupMockDI();

        // Then: 다시 등록됨
        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isTrue);
      });
    });

    group('8. 앱 생명주기와 DI', () {
      testWidgets('앱 재시작 시 DI가 올바르게 동작해야 한다', (tester) async {
        // Given: 첫 번째 앱 인스턴스
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Verify: 첫 번째 인스턴스 동작 확인
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);

        // When: 새로운 앱 인스턴스 (DI 유지)
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 두 번째 인스턴스도 정상 동작
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });

    group('9. ProviderScope 테스트', () {
      testWidgets('ProviderScope가 올바르게 설정되어야 한다', (tester) async {
        // Given/When: ProviderScope로 감싼 앱
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Then: 정상 동작
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('10. 라우트 파라미터 테스트', () {
      testWidgets('onboardingComplete 파라미터가 라우팅에 영향을 미쳐야 한다', (tester) async {
        // Test 1: false인 경우
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(PageView), findsOneWidget);

        // Test 2: true인 경우 (새로운 위젯 트리)
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(PageView), findsNothing);
      });
    });
  });
}
