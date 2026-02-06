import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/di/di_setup.dart';
import 'user_state.dart';
import 'user_action.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../domain/usecase/get_user_list_use_case.dart';
import '../../weather/domain/usecase/get_current_weather_use_case.dart';
import '../../location/domain/usecase/get_current_location_use_case.dart';

part 'user_notifier.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  // ✅ GetIt으로부터 주입받을 UseCase들
  late final GetUserUseCase _getUserUseCase;
  late final GetUserListUseCase _getUserListUseCase;
  late final GetCurrentWeatherUseCase _getWeatherUseCase;
  late final GetCurrentLocationUseCase _getLocationUseCase;

  UserNotifier({
    GetUserUseCase? getUserUseCase,
    GetUserListUseCase? getUserListUseCase,
    GetCurrentWeatherUseCase? getWeatherUseCase,
    GetCurrentLocationUseCase? getLocationUseCase,
  }) : _getUserUseCase = getUserUseCase ?? getIt<GetUserUseCase>(),
       _getUserListUseCase = getUserListUseCase ?? getIt<GetUserListUseCase>(),
       _getWeatherUseCase =
           getWeatherUseCase ?? getIt<GetCurrentWeatherUseCase>(),
       _getLocationUseCase =
           getLocationUseCase ?? getIt<GetCurrentLocationUseCase>();

  @override
  UserState build() {
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
        await _loadLocation();
    }
  }

  Future<void> _loadUser(String userId) async {
    state = state.copyWith(userResult: const AsyncValue.loading());
    final result = await _getUserUseCase.execute(userId);
    state = state.copyWith(userResult: result);
  }

  Future<void> _loadLocation() async {
    try {
      final locationResult = await _getLocationUseCase.execute();

      if (locationResult.hasValue) {
        final location = locationResult.value!;
        state = state.copyWith(
          latitude: location.latitude,
          longitude: location.longitude,
        );
        await _loadWeather(location.latitude, location.longitude);
      } else {
        debugPrint('위치 조회 실패: ${locationResult.error}');
      }
    } catch (e) {
      debugPrint('위치 조회 예외: $e');
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
    state = state.copyWith(userListResult: const AsyncValue.loading());
    final result = await _getUserListUseCase.execute();
    state = state.copyWith(userListResult: result);
  }
}
