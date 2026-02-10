import 'package:get_it/get_it.dart';

// Data Source Interfaces
import '../../weather/data/data_source/weather_data_source_interface.dart';
import '../../location/data/data_source/location_data_source_interface.dart';

// Data Sources (Concrete implementations)
import '../../weather/data/data_source/weather_data_source.dart';
import '../../location/data/data_source/location_data_source.dart';

// Repositories
import '../../weather/domain/repository/weather_repository.dart';
import '../../weather/data/repository_impl/weather_repository_impl.dart';
import '../../location/domain/repository/location_repository.dart';
import '../../location/data/repository_impl/location_repository_impl.dart';

// Use Cases
import '../../weather/domain/usecase/get_current_weather_use_case.dart';
import '../../location/domain/usecase/get_current_location_use_case.dart';

// Notifiers
import '../../weather/presentation/outfit_notifier.dart';

final getIt = GetIt.instance;

/// DI 초기화 함수
void diSetup() {
  // ========================================
  // 1. Data Sources 등록 (인터페이스로 등록)
  // ========================================

  // Weather DataSource
  getIt.registerSingleton<WeatherDataSourceInterface>(WeatherDataSource());

  // Location DataSource
  getIt.registerSingleton<LocationDataSourceInterface>(LocationDataSource());

  // ========================================
  // 2. Repositories 등록
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

/// DI 초기화 해제 (테스트 후 cleanup)
void resetDi() {
  getIt.reset();
}
