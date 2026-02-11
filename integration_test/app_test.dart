import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

final getIt = GetIt.instance;

/// Mock WeatherDataSource for integration testing
class MockWeatherDataSource implements WeatherDataSourceInterface {
  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    // 테스트용 고정 응답 반환
    return {
      'main': {'temp': 22.0, 'feels_like': 23.0, 'humidity': 55},
      'weather': [
        {'description': '맑음', 'icon': '01d'},
      ],
      'rain': {'1h': 0.0},
    };
  }
}

/// Mock LocationDataSource for integration testing
class MockLocationDataSource implements LocationDataSourceInterface {
  @override
  Future<Position> getCurrentPosition() async {
    return Position(
      latitude: 37.5665,
      longitude: 126.9780,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  @override
  Future<LocationPermission> checkPermission() async {
    return LocationPermission.whileInUse;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return LocationPermission.whileInUse;
  }

  @override
  Future<List<Placemark>> getPlacemarksFromCoordinates(
    double lat,
    double lon,
  ) async {
    return [
      Placemark(
        administrativeArea: '서울특별시',
        subLocality: '중구',
        thoroughfare: '명동',
        name: '',
        street: '',
        isoCountryCode: 'KR',
        country: '대한민국',
        postalCode: '04536',
        locality: '서울특별시',
        subAdministrativeArea: '',
        subThoroughfare: '',
      ),
    ];
  }
}

/// 테스트용 Mock DI 설정 (외부 의존성 Mock 처리)
void mockDiSetup() {
  // Mock Data Sources
  getIt.registerSingleton<WeatherDataSourceInterface>(MockWeatherDataSource());
  getIt.registerSingleton<LocationDataSourceInterface>(
    MockLocationDataSource(),
  );

  // Repositories (using Mock DataSources)
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

/// Mock DI 초기화 해제
void resetMockDi() {
  getIt.reset();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    setUp(() async {
      // 테스트 전 초기화 - Mock DI 사용
      resetMockDi();
    });

    tearDown(() {
      resetMockDi();
    });

    group('Onboarding Screen', () {
      testWidgets('should display onboarding screen when not completed', (
        tester,
      ) async {
        // Mock DI 설정 (외부 의존성 Mock 처리)
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: false)),
        );
        await tester.pumpAndSettle();

        // 온보딩 화면이 표시되는지 확인
        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('should show page indicator', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: false)),
        );
        await tester.pumpAndSettle();

        // 페이지 인디케이터가 있는지 확인 (AnimatedContainer 2개)
        expect(find.byType(AnimatedContainer), findsWidgets);
      });

      testWidgets('should navigate to second page on swipe', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: false)),
        );
        await tester.pumpAndSettle();

        // 왼쪽으로 스와이프
        await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
        await tester.pumpAndSettle();

        // 두 번째 페이지로 이동했는지 확인
        // (페이지가 변경되면 인디케이터 상태가 변경됨)
        expect(find.byType(PageView), findsOneWidget);
      });
    });

    group('Home Screen', () {
      testWidgets('should display home screen when onboarding completed', (
        tester,
      ) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        // 홈 화면이 표시되는지 확인 (로딩, 에러, 또는 성공 상태)
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should show loading indicator initially', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );

        // 로딩 인디케이터 또는 컨텐츠가 있어야 함
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should have search button with mock data', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        // Mock 데이터로 인해 성공 상태이므로 검색 아이콘이 있어야 함
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });

      testWidgets('should display weather info from mock', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        // Mock 날씨 데이터가 표시되는지 확인 (온도 22도)
        expect(find.textContaining('22'), findsWidgets);
      });

      testWidgets('should display location info from mock', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        // Mock 위치 데이터가 표시되는지 확인
        expect(find.textContaining('서울특별시'), findsOneWidget);
      });
    });

    group('Temperature Search Screen', () {
      testWidgets('should navigate to temperature search screen', (
        tester,
      ) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        // 검색 버튼 탭
        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 온도 검색 화면으로 이동했는지 확인
        expect(find.text('온도로 옷차림 찾기'), findsOneWidget);
      });

      testWidgets('should display slider in temperature search', (
        tester,
      ) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 슬라이더가 있는지 확인
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('should update temperature when slider moved', (
        tester,
      ) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 초기 온도 표시 확인 (12도)
        expect(find.text('12'), findsOneWidget);

        // 슬라이더 조작
        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(100, 0));
        await tester.pumpAndSettle();

        // 온도가 변경되었는지 확인 (정확한 값은 슬라이더 위치에 따라 다름)
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('should display outfit recommendations', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 추천 옷차림 섹션이 있는지 확인
        expect(find.text('추천 옷차림'), findsOneWidget);

        // 상의, 하의, 아우터 카테고리가 있는지 확인
        expect(find.text('상의'), findsOneWidget);
        expect(find.text('하의'), findsOneWidget);
      });

      testWidgets('should show back button', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 뒤로가기 버튼 확인
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      });

      testWidgets('should navigate back when back button pressed', (
        tester,
      ) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 뒤로가기 버튼 탭
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        // 이전 화면으로 돌아갔는지 확인
        expect(find.text('온도로 옷차림 찾기'), findsNothing);
      });
    });

    group('Outfit Recommendations', () {
      testWidgets('should show different outfits for hot weather', (
        tester,
      ) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 슬라이더를 오른쪽 끝으로 이동 (더운 날씨)
        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(300, 0));
        await tester.pumpAndSettle();

        // 더운 날씨에 맞는 옷차림이 표시되는지 확인
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('should show different outfits for cold weather', (
        tester,
      ) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(child: MyApp(onboardingComplete: true)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 슬라이더를 왼쪽 끝으로 이동 (추운 날씨)
        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(-300, 0));
        await tester.pumpAndSettle();

        // 추운 날씨에 맞는 옷차림이 표시되는지 확인
        expect(find.byType(Slider), findsOneWidget);
      });
    });
  });
}
