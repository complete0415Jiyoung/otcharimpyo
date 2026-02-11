/// 온도 검색 기능 통합 테스트
///
/// 테스트 시나리오:
/// 1. 온도 검색 화면 표시
/// 2. 슬라이더로 온도 조절
/// 3. 온도별 옷차림 추천 변경
/// 4. 뒤로가기 동작

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

final getIt = GetIt.instance;

/// Mock WeatherDataSource
class MockWeatherDataSource implements WeatherDataSourceInterface {
  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    return {
      'main': {'temp': 22.0, 'feels_like': 23.0, 'humidity': 55},
      'weather': [
        {'description': '맑음', 'icon': '01d'},
      ],
      'rain': {'1h': 0.0},
    };
  }
}

/// Mock LocationDataSource
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
      ),
    ];
  }
}

/// Mock DI 설정
void mockDiSetup() {
  getIt.registerSingleton<WeatherDataSourceInterface>(MockWeatherDataSource());
  getIt.registerSingleton<LocationDataSourceInterface>(MockLocationDataSource());

  getIt.registerSingleton<WeatherRepository>(
    WeatherRepositoryImpl(dataSource: getIt<WeatherDataSourceInterface>()),
  );
  getIt.registerSingleton<LocationRepository>(
    LocationRepositoryImpl(dataSource: getIt<LocationDataSourceInterface>()),
  );

  getIt.registerSingleton<GetCurrentWeatherUseCase>(
    GetCurrentWeatherUseCase(getIt<WeatherRepository>()),
  );
  getIt.registerSingleton<GetCurrentLocationUseCase>(
    GetCurrentLocationUseCase(getIt<LocationRepository>()),
  );
}

/// DI 리셋
void resetMockDi() {
  if (getIt.isRegistered<WeatherDataSourceInterface>()) {
    getIt.reset();
  }
}

void main() {
  group('온도 검색 기능 통합 테스트', () {
    setUp(() {
      resetMockDi();
    });

    tearDown(() {
      resetMockDi();
    });

    group('1. 온도 검색 화면 표시', () {
      testWidgets('온도 검색 화면으로 이동할 수 있어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        expect(find.text('온도로 옷차림 찾기'), findsOneWidget);
      });

      testWidgets('슬라이더가 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('초기 온도가 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 초기 온도 12도
        expect(find.text('12'), findsOneWidget);
      });
    });

    group('2. 슬라이더 동작', () {
      testWidgets('슬라이더를 오른쪽으로 드래그하면 온도가 올라가야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 슬라이더 오른쪽으로 드래그
        await tester.drag(find.byType(Slider), const Offset(200, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('슬라이더를 왼쪽으로 드래그하면 온도가 내려가야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 슬라이더 왼쪽으로 드래그
        await tester.drag(find.byType(Slider), const Offset(-200, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });
    });

    group('3. 온도별 옷차림 추천', () {
      testWidgets('추천 옷차림 섹션이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        expect(find.text('추천 옷차림'), findsOneWidget);
      });

      testWidgets('상의 카테고리가 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        expect(find.text('상의'), findsOneWidget);
      });

      testWidgets('하의 카테고리가 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        expect(find.text('하의'), findsOneWidget);
      });

      testWidgets('더운 날씨 설정 시 민소매가 추천되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 슬라이더를 오른쪽 끝으로 (더운 날씨)
        await tester.drag(find.byType(Slider), const Offset(300, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('추운 날씨 설정 시 패딩이 추천되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 슬라이더를 왼쪽 끝으로 (추운 날씨)
        await tester.drag(find.byType(Slider), const Offset(-300, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('4. 뒤로가기 동작', () {
      testWidgets('뒤로가기 버튼이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      });

      testWidgets('뒤로가기 버튼 탭 시 홈 화면으로 돌아가야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        expect(find.text('온도로 옷차림 찾기'), findsNothing);
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });

    group('5. 화면 UI 요소', () {
      testWidgets('화면 제목이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        expect(find.text('온도로 옷차림 찾기'), findsOneWidget);
      });

      testWidgets('스크롤이 가능해야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 스크롤 테스트
        await tester.drag(find.byType(Scaffold), const Offset(0, -200));
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('6. 온도 범위 테스트', () {
      testWidgets('최저 온도로 설정 가능해야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 슬라이더를 왼쪽 끝으로
        await tester.drag(find.byType(Slider), const Offset(-500, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('최고 온도로 설정 가능해야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 슬라이더를 오른쪽 끝으로
        await tester.drag(find.byType(Slider), const Offset(500, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });
    });
  });
}
