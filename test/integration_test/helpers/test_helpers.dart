/// 통합 테스트 공통 헬퍼
/// 테스트에서 반복적으로 사용되는 유틸리티 함수와 설정을 제공합니다.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:otcharimpyo/main.dart';
import 'package:otcharimpyo/weather/data/data_source/weather_data_source_interface.dart';
import 'package:otcharimpyo/location/data/data_source/location_data_source_interface.dart';
import 'package:otcharimpyo/weather/domain/repository/weather_repository.dart';
import 'package:otcharimpyo/weather/data/repository_impl/weather_repository_impl.dart';
import 'package:otcharimpyo/location/domain/repository/location_repository.dart';
import 'package:otcharimpyo/location/data/repository_impl/location_repository_impl.dart';
import 'package:otcharimpyo/weather/domain/usecase/get_current_weather_use_case.dart';
import 'package:otcharimpyo/location/domain/usecase/get_current_location_use_case.dart';
import 'package:otcharimpyo/weather/presentation/outfit_notifier.dart';

import 'mock_weather_service.dart';
import 'mock_location_service.dart';

/// GetIt 인스턴스
final getIt = GetIt.instance;

/// Mock 데이터소스 인스턴스 (테스트에서 접근 가능)
late MockWeatherDataSource mockWeatherDataSource;
late MockLocationDataSource mockLocationDataSource;

/// 테스트용 Mock DI 초기화
/// - 모든 외부 의존성을 Mock으로 대체합니다.
/// - 각 테스트 전에 호출해야 합니다.
void setupMockDI() {
  // Mock 데이터소스 생성
  mockWeatherDataSource = MockWeatherDataSource();
  mockLocationDataSource = MockLocationDataSource();

  // 기본 성공 시나리오 설정
  mockWeatherDataSource.setupSuccess();
  mockLocationDataSource.setupSeoulLocation();

  // DI 등록
  getIt.registerSingleton<WeatherDataSourceInterface>(mockWeatherDataSource);
  getIt.registerSingleton<LocationDataSourceInterface>(mockLocationDataSource);

  // Repositories
  getIt.registerSingleton<WeatherRepository>(
    WeatherRepositoryImpl(dataSource: getIt<WeatherDataSourceInterface>()),
  );
  getIt.registerSingleton<LocationRepository>(
    LocationRepositoryImpl(dataSource: getIt<LocationDataSourceInterface>()),
  );

  // Use Cases
  getIt.registerSingleton<GetCurrentWeatherUseCase>(
    GetCurrentWeatherUseCase(getIt<WeatherRepository>()),
  );
  getIt.registerSingleton<GetCurrentLocationUseCase>(
    GetCurrentLocationUseCase(getIt<LocationRepository>()),
  );

  // Notifiers
  getIt.registerFactory(
    () => OutfitNotifier(
      getWeatherUseCase: getIt<GetCurrentWeatherUseCase>(),
      getLocationUseCase: getIt<GetCurrentLocationUseCase>(),
    ),
  );
}

/// DI 정리 (각 테스트 후 호출)
void tearDownMockDI() {
  getIt.reset();
}

/// 앱 시작 헬퍼 - 온보딩 미완료 상태
Future<void> pumpAppWithOnboarding(WidgetTester tester) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MyApp(onboardingComplete: false),
    ),
  );
  await tester.pumpAndSettle();
}

/// 앱 시작 헬퍼 - 온보딩 완료 상태 (홈 화면으로 이동)
Future<void> pumpAppWithHome(WidgetTester tester) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MyApp(onboardingComplete: true),
    ),
  );
  await tester.pumpAndSettle();
}

/// 탭 액션 헬퍼
Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// 스와이프 액션 헬퍼
Future<void> swipeLeft(WidgetTester tester, Finder finder) async {
  await tester.fling(finder, const Offset(-300, 0), 1000);
  await tester.pumpAndSettle();
}

/// 슬라이더 드래그 헬퍼
Future<void> dragSlider(
  WidgetTester tester,
  Finder sliderFinder,
  double offsetX,
) async {
  await tester.drag(sliderFinder, Offset(offsetX, 0));
  await tester.pumpAndSettle();
}

/// Pull-to-refresh 헬퍼
Future<void> pullToRefresh(WidgetTester tester) async {
  await tester.fling(
    find.byType(RefreshIndicator),
    const Offset(0, 300),
    1000,
  );
  await tester.pumpAndSettle();
}

/// 특정 텍스트가 화면에 나타날 때까지 대기
Future<void> waitForText(
  WidgetTester tester,
  String text, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final stopwatch = Stopwatch()..start();
  while (stopwatch.elapsed < timeout) {
    await tester.pump(const Duration(milliseconds: 100));
    if (find.text(text).evaluate().isNotEmpty) {
      return;
    }
  }
  throw TimeoutException('텍스트 "$text"를 찾을 수 없습니다');
}

/// 특정 위젯 타입이 화면에 나타날 때까지 대기
Future<void> waitForWidget<T extends Widget>(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final stopwatch = Stopwatch()..start();
  while (stopwatch.elapsed < timeout) {
    await tester.pump(const Duration(milliseconds: 100));
    if (find.byType(T).evaluate().isNotEmpty) {
      return;
    }
  }
  throw TimeoutException('위젯 ${T.toString()}를 찾을 수 없습니다');
}

/// TimeoutException 정의
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}

/// 테스트 그룹 설정 헬퍼 (setUp/tearDown 포함)
void setupIntegrationTest({
  required void Function() onSetUp,
  required void Function() onTearDown,
}) {
  setUp(() async {
    tearDownMockDI();
    setupMockDI();
    onSetUp();
  });

  tearDown(() {
    onTearDown();
    tearDownMockDI();
  });
}

/// 에러 시나리오 설정 헬퍼
void setupErrorScenario(ErrorType type) {
  switch (type) {
    case ErrorType.networkError:
      mockWeatherDataSource.setupNetworkError();
      break;
    case ErrorType.serverError:
      mockWeatherDataSource.setupServerError();
      break;
    case ErrorType.timeout:
      mockWeatherDataSource.setupTimeout();
      break;
    case ErrorType.permissionDenied:
      mockLocationDataSource.setupPermissionDenied();
      break;
    case ErrorType.permissionDeniedForever:
      mockLocationDataSource.setupPermissionDeniedForever();
      break;
    case ErrorType.gpsError:
      mockLocationDataSource.setupGpsError();
      break;
  }
}

/// 에러 타입 열거형
enum ErrorType {
  networkError,
  serverError,
  timeout,
  permissionDenied,
  permissionDeniedForever,
  gpsError,
}

/// 온도 범위별 옷차림 검증 헬퍼
void expectOutfitForTemperature(double temp) {
  if (temp >= 28) {
    expect(find.text('민소매'), findsOneWidget);
    expect(find.text('반팔'), findsOneWidget);
  } else if (temp >= 23) {
    expect(find.text('반팔'), findsOneWidget);
    expect(find.text('얇은 셔츠'), findsOneWidget);
  } else if (temp >= 12) {
    expect(find.text('니트'), findsOneWidget);
  } else if (temp < 5) {
    expect(find.text('패딩'), findsOneWidget);
  }
}

/// 시간대별 인사말 반환
String getGreetingForTime() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return '좋은 아침입니다!';
  } else if (hour < 18) {
    return '좋은 오후입니다!';
  } else {
    return '좋은 저녁입니다!';
  }
}
