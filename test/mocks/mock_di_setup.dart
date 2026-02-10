import 'package:get_it/get_it.dart';

// Data Source Interfaces
import 'package:otcharimpyo/weather/data/data_source/weather_data_source_interface.dart';
import 'package:otcharimpyo/location/data/data_source/location_data_source_interface.dart';

// Repositories
import 'package:otcharimpyo/weather/domain/repository/weather_repository.dart';
import 'package:otcharimpyo/weather/data/repository_impl/weather_repository_impl.dart';
import 'package:otcharimpyo/location/domain/repository/location_repository.dart';
import 'package:otcharimpyo/location/data/repository_impl/location_repository_impl.dart';

// Use Cases
import 'package:otcharimpyo/weather/domain/usecase/get_current_weather_use_case.dart';
import 'package:otcharimpyo/location/domain/usecase/get_current_location_use_case.dart';

// Notifiers
import 'package:otcharimpyo/weather/presentation/outfit_notifier.dart';

// Mocks
import 'mock_data_sources.dart';

final getIt = GetIt.instance;

/// Mock DataSources for testing
late MockWeatherDataSource mockWeatherDataSource;
late MockLocationDataSource mockLocationDataSource;

/// 테스트용 Mock DI 초기화 함수
/// 외부 의존성(HTTP, Geolocator, Geocoding)을 Mock으로 대체
void mockDiSetup() {
  // ========================================
  // 1. Mock Data Sources 생성 및 등록
  // ========================================

  // Mock Weather DataSource
  mockWeatherDataSource = MockWeatherDataSource();
  getIt.registerSingleton<WeatherDataSourceInterface>(mockWeatherDataSource);

  // Mock Location DataSource
  mockLocationDataSource = MockLocationDataSource();
  getIt.registerSingleton<LocationDataSourceInterface>(mockLocationDataSource);

  // ========================================
  // 2. Repositories 등록 (Mock DataSource 사용)
  // ========================================

  // Weather Repository
  getIt.registerSingleton<WeatherRepository>(
    WeatherRepositoryImpl(dataSource: getIt<WeatherDataSourceInterface>()),
  );

  // Location Repository
  getIt.registerSingleton<LocationRepository>(
    LocationRepositoryImpl(dataSource: getIt<LocationDataSourceInterface>()),
  );

  // ========================================
  // 3. Use Cases 등록
  // ========================================

  // Weather Use Cases
  getIt.registerSingleton<GetCurrentWeatherUseCase>(
    GetCurrentWeatherUseCase(getIt<WeatherRepository>()),
  );

  // Location Use Cases
  getIt.registerSingleton<GetCurrentLocationUseCase>(
    GetCurrentLocationUseCase(getIt<LocationRepository>()),
  );

  // ========================================
  // 4. Notifiers 등록 (Factory - 매번 새 인스턴스)
  // ========================================

  // Outfit Notifier
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

/// 테스트용 기본 Mock 데이터 설정
void setupDefaultMockData() {
  // Default weather response
  mockWeatherDataSource.setMockResponse({
    'main': {'temp': 22.0, 'feels_like': 23.0, 'humidity': 55},
    'weather': [
      {'description': '맑음', 'icon': '01d'},
    ],
    'rain': {'1h': 0.0},
  });

  // Default location data is already set in MockLocationDataSource
}
