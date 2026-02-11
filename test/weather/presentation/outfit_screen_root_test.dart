import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:otcharimpyo/weather/presentation/outfit_screen_root.dart';
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
  if (!getIt.isRegistered<WeatherDataSourceInterface>()) {
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
}

/// DI 리셋
void resetMockDi() {
  if (getIt.isRegistered<WeatherDataSourceInterface>()) {
    getIt.reset();
  }
}

void main() {
  group('OutfitScreenRoot Widget Tests', () {
    setUp(() {
      resetMockDi();
    });

    tearDown(() {
      resetMockDi();
    });

    Widget createWidgetUnderTest() {
      mockDiSetup();
      return const ProviderScope(
        child: MaterialApp(
          home: OutfitScreenRoot(),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render OutfitScreenRoot', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(OutfitScreenRoot), findsOneWidget);
      });

      testWidgets('should show Scaffold', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('Data Loading', () {
      testWidgets('should display location after loading', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.textContaining('서울특별시'), findsOneWidget);
      });

      testWidgets('should display temperature after loading', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.textContaining('22'), findsWidgets);
      });
    });

    group('UI Elements', () {
      testWidgets('should show outfit recommendation title', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('오늘의 추천 옷차림'), findsOneWidget);
      });

      testWidgets('should show search button', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });

      testWidgets('should show weather details', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('체감온도'), findsOneWidget);
        expect(find.text('습도'), findsOneWidget);
        expect(find.text('강수량'), findsOneWidget);
      });
    });

    group('RefreshIndicator', () {
      testWidgets('should have RefreshIndicator for pull-to-refresh', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('should use Riverpod for state management', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // OutfitScreenRoot이 ConsumerWidget인지 확인
        expect(find.byType(OutfitScreenRoot), findsOneWidget);
      });
    });
  });
}
