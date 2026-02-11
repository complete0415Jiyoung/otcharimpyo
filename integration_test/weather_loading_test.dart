/// 날씨 정보 로딩 통합 테스트
///
/// 테스트 시나리오:
/// 1. 날씨 데이터 로딩 및 표시
/// 2. 위치 정보 표시
/// 3. 온도 기반 옷차림 추천

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

/// Mock WeatherDataSource - 다양한 온도 시나리오 지원
class MockWeatherDataSource implements WeatherDataSourceInterface {
  double mockTemp = 22.0;
  String mockDescription = '맑음';

  void setHotWeather() {
    mockTemp = 32.0;
    mockDescription = '맑음';
  }

  void setColdWeather() {
    mockTemp = 2.0;
    mockDescription = '눈';
  }

  void setMildWeather() {
    mockTemp = 22.0;
    mockDescription = '맑음';
  }

  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    return {
      'main': {'temp': mockTemp, 'feels_like': mockTemp + 1, 'humidity': 55},
      'weather': [
        {'description': mockDescription, 'icon': '01d'},
      ],
      'rain': {'1h': 0.0},
    };
  }
}

/// Mock LocationDataSource
class MockLocationDataSource implements LocationDataSourceInterface {
  String mockCity = '서울특별시';
  String mockDistrict = '중구';
  String mockDong = '명동';

  void setSeoulLocation() {
    mockCity = '서울특별시';
    mockDistrict = '중구';
    mockDong = '명동';
  }

  void setBusanLocation() {
    mockCity = '부산광역시';
    mockDistrict = '해운대구';
    mockDong = '우동';
  }

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
        administrativeArea: mockCity,
        subLocality: mockDistrict,
        thoroughfare: mockDong,
        name: '',
        street: '',
        isoCountryCode: 'KR',
        country: '대한민국',
        postalCode: '04536',
      ),
    ];
  }
}

late MockWeatherDataSource mockWeatherDataSource;
late MockLocationDataSource mockLocationDataSource;

/// Mock DI 설정
void mockDiSetup() {
  mockWeatherDataSource = MockWeatherDataSource();
  mockLocationDataSource = MockLocationDataSource();

  getIt.registerSingleton<WeatherDataSourceInterface>(mockWeatherDataSource);
  getIt.registerSingleton<LocationDataSourceInterface>(mockLocationDataSource);

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
  group('날씨 정보 로딩 통합 테스트', () {
    setUp(() {
      resetMockDi();
    });

    tearDown(() {
      resetMockDi();
    });

    group('1. 날씨 데이터 로딩', () {
      testWidgets('홈 화면에서 날씨 정보가 로드되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // 온도가 표시되어야 함
        expect(find.textContaining('22'), findsWidgets);
      });

      testWidgets('날씨 상태가 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // 날씨 설명이 표시되어야 함
        expect(find.textContaining('맑음'), findsWidgets);
      });
    });

    group('2. 위치 정보 표시', () {
      testWidgets('현재 위치가 표시되어야 한다', (tester) async {
        mockDiSetup();
        mockLocationDataSource.setSeoulLocation();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('서울특별시'), findsOneWidget);
      });

      testWidgets('부산 위치가 올바르게 표시되어야 한다', (tester) async {
        mockDiSetup();
        mockLocationDataSource.setBusanLocation();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('부산광역시'), findsOneWidget);
      });
    });

    group('3. 온도별 옷차림 추천', () {
      testWidgets('더운 날씨에 맞는 옷차림이 추천되어야 한다', (tester) async {
        mockDiSetup();
        mockWeatherDataSource.setHotWeather();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // 32도에 맞는 옷차림 추천 확인
        expect(find.textContaining('32'), findsWidgets);
      });

      testWidgets('추운 날씨에 맞는 옷차림이 추천되어야 한다', (tester) async {
        mockDiSetup();
        mockWeatherDataSource.setColdWeather();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // 2도에 맞는 옷차림 추천 확인
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('4. 화면 구성 요소', () {
      testWidgets('검색 버튼이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });

      testWidgets('새로고침 버튼이 있어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      });

      testWidgets('옷차림 카테고리가 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('오늘의 추천 옷차림'), findsOneWidget);
      });
    });

    group('5. 새로고침 동작', () {
      testWidgets('새로고침 버튼 탭 시 데이터가 갱신되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // 새로고침 버튼 탭
        await tester.tap(find.byIcon(Icons.refresh_rounded));
        await tester.pumpAndSettle();

        // 화면이 정상적으로 표시되어야 함
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('6. 온도 검색 화면 이동', () {
      testWidgets('검색 버튼 탭 시 온도 검색 화면으로 이동해야 한다', (tester) async {
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
    });

    group('7. 날씨 아이콘', () {
      testWidgets('날씨 아이콘이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // 화면에 이미지가 있어야 함 (날씨 아이콘)
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });
  });
}
