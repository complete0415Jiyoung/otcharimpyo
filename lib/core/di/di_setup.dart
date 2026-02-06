import 'package:get_it/get_it.dart';

// Data Sources
import '../../user/data/data_source/user_data_source.dart';
import '../../user/data/data_source/user_data_source_impl.dart';
import '../../user/data/data_source/mock_user_data_source.dart';
import '../../weather/data/data_source/weather_data_source.dart';
import '../../location/data/data_source/location_data_source.dart';

// Repositories
import '../../user/domain/repository/user_repository.dart';
import '../../user/data/repository_impl/user_repository_impl.dart';
import '../../weather/domain/repository/weather_repository.dart';
import '../../weather/data/repository_impl/weather_repository_impl.dart';
import '../../location/domain/repository/location_repository.dart';
import '../../location/data/repository_impl/location_repository_impl.dart';

// Use Cases
import '../../user/domain/usecase/get_user_use_case.dart';
import '../../user/domain/usecase/get_user_list_use_case.dart';
import '../../weather/domain/usecase/get_current_weather_use_case.dart';
import '../../location/domain/usecase/get_current_location_use_case.dart';

// Notifiers
import '../../user/presentation/user_notifier.dart';
import '../../weather/presentation/outfit_notifier.dart';

final getIt = GetIt.instance;

/// DI 초기화 함수
void diSetup({bool useMockData = false}) {
  // ========================================
  // 1. Data Sources 등록
  // ========================================

  // User DataSource
  if (useMockData) {
    getIt.registerSingleton<UserDataSource>(MockUserDataSource());
  } else {
    getIt.registerSingleton<UserDataSource>(UserDataSourceImpl());
  }

  // Weather DataSource
  getIt.registerSingleton<WeatherDataSource>(WeatherDataSource());

  // Location DataSource
  getIt.registerSingleton<LocationDataSource>(LocationDataSource());

  // ========================================
  // 2. Repositories 등록
  // ========================================

  // User Repository
  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(dataSource: getIt<UserDataSource>()),
  );

  // Weather Repository
  getIt.registerSingleton<WeatherRepository>(
    WeatherRepositoryImpl(dataSource: getIt<WeatherDataSource>()),
  );

  // Location Repository
  getIt.registerSingleton<LocationRepository>(
    LocationRepositoryImpl(dataSource: getIt<LocationDataSource>()),
  );

  // ========================================
  // 3. Use Cases 등록
  // ========================================

  // User Use Cases
  getIt.registerSingleton<GetUserUseCase>(
    GetUserUseCase(getIt<UserRepository>()),
  );

  getIt.registerSingleton<GetUserListUseCase>(
    GetUserListUseCase(getIt<UserRepository>()),
  );

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

  // User Notifier
  getIt.registerFactory(
    () => UserNotifier(
      getUserUseCase: getIt<GetUserUseCase>(),
      getUserListUseCase: getIt<GetUserListUseCase>(),
      getWeatherUseCase: getIt<GetCurrentWeatherUseCase>(),
      getLocationUseCase: getIt<GetCurrentLocationUseCase>(),
    ),
  );

  // Outfit Notifier
  getIt.registerFactory(
    () => OutfitNotifier(
      getWeatherUseCase: getIt<GetCurrentWeatherUseCase>(),
      getLocationUseCase: getIt<GetCurrentLocationUseCase>(),
    ),
  );
}

/// Mock 데이터를 사용하는 DI 설정 (테스트용)
void mockDiSetup() {
  diSetup(useMockData: true);
}

/// DI 초기화 해제 (테스트 후 cleanup)
void resetDi() {
  getIt.reset();
}
