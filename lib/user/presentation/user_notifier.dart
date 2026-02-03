import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'user_state.dart';
import 'user_action.dart';
import '../../weather/domain/usecase/get_current_weather_use_case.dart';
import '../../weather/data/data_source/weather_data_source.dart';
import '../../weather/data/repository_impl/weather_repository_impl.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../domain/usecase/get_user_list_use_case.dart';
import '../domain/repository/user_repository.dart';
import '../data/repository_impl/user_repository_impl.dart';
import '../data/data_source/user_data_source.dart';
import '../data/data_source/mock_user_data_source.dart';

part 'user_notifier.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  late final GetUserUseCase _getUserUseCase;
  late final GetUserListUseCase _getUserListUseCase;
  late final GetCurrentWeatherUseCase _getWeatherUseCase;

  @override
  UserState build() {
    // DI를 직접 구성
    final UserDataSource dataSource = MockUserDataSource();
    final UserRepository repository = UserRepositoryImpl(
      dataSource: dataSource,
    );

    _getUserUseCase = GetUserUseCase(repository);
    _getUserListUseCase = GetUserListUseCase(repository);

    final weatherDataSource = WeatherDataSource();
    final weatherRepository = WeatherRepositoryImpl(dataSource: weatherDataSource);
    _getWeatherUseCase = GetCurrentWeatherUseCase(weatherRepository);

    // 화면 로드 시 자동으로 데이터 불러오기
    Future.microtask(() {
      _loadUserList();
      _loadLocation();
    });

    return const UserState();
  }

  Future<void> onAction(UserAction action) async {
    switch (action) {
      case OnLoadUser(:final userId):
        await _loadUser(userId);
      case OnLoadUserList():
        await _loadUserList();
      case OnTapUser():
        // 화면 이동은 Root에서 처리
        break;
      case OnRefresh():
        await _loadUserList();
    }
  }

  Future<void> _loadUser(String userId) async {
    state = state.copyWith(userResult: const AsyncValue.loading()); // ← 수정!
    final result = await _getUserUseCase.execute(userId);
    state = state.copyWith(userResult: result);
  }

  Future<void> _loadLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      await _loadWeather(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('위치 조회 실패: $e');
    }
  }

  Future<void> _loadWeather(double lat, double lon) async {
    try {
      final result = await _getWeatherUseCase.execute(lat, lon);
      if (result.hasValue) {
        state = state.copyWith(weather: result.value);
      } else {
        debugPrint('날씨 조회 실패: ${result.error}');
      }
    } catch (e) {
      debugPrint('날씨 조회 예외: $e');
    }
  }

  Future<void> _loadUserList() async {
    state = state.copyWith(userListResult: const AsyncValue.loading()); // ← 수정!
    final result = await _getUserListUseCase.execute();
    state = state.copyWith(userListResult: result);
  }
}
